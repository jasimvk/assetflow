import React, { useEffect, useState } from 'react';
import Layout from '../components/Layout';
import { useAuth } from '../context/AuthContext';
import { useRouter } from 'next/router';
import { getAssets, getMaintenanceRecords, Asset, MaintenanceRecord } from '../utils/supabase';
import { Package, Calendar, Users, TrendingUp } from 'lucide-react';

const Dashboard = () => {
  const { isAuthenticated, loading } = useAuth();
  const router = useRouter();
  const [assets, setAssets] = useState<Asset[]>([]);
  const [maintenanceRecords, setMaintenanceRecords] = useState<MaintenanceRecord[]>([]);
  const [dashboardLoading, setDashboardLoading] = useState(true);

  useEffect(() => {
    if (!loading && !isAuthenticated) {
      router.push('/login');
    }
  }, [isAuthenticated, loading, router]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [assetsData, maintenanceData] = await Promise.all([
          getAssets(),
          getMaintenanceRecords()
        ]);
        setAssets(assetsData);
        setMaintenanceRecords(maintenanceData);
      } catch (error) {
        console.error('Error fetching dashboard data:', error);
      } finally {
        setDashboardLoading(false);
      }
    };

    if (isAuthenticated) {
      fetchData();
    }
  }, [isAuthenticated]);

  if (loading || dashboardLoading) {
    return (
      <Layout title="Dashboard">
        <div className="flex justify-center items-center h-64">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary-600"></div>
        </div>
      </Layout>
    );
  }

  if (!isAuthenticated) {
    return null;
  }

  const totalAssets = assets.length;
  const assetsInMaintenance = maintenanceRecords.filter(r => r.status === 'in_progress').length;
  const upcomingMaintenance = maintenanceRecords.filter(r => 
    r.status === 'scheduled' && new Date(r.scheduled_date) <= new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
  ).length;
  const totalValue = assets.reduce((sum, asset) => sum + asset.current_value, 0);

  const stats = [
    {
      name: 'Total Assets',
      value: totalAssets.toString(),
      icon: Package,
      color: 'text-blue-600',
      bgColor: 'bg-blue-100',
    },
    {
      name: 'In Maintenance',
      value: assetsInMaintenance.toString(),
      icon: Calendar,
      color: 'text-yellow-600',
      bgColor: 'bg-yellow-100',
    },
    {
      name: 'Upcoming Maintenance',
      value: upcomingMaintenance.toString(),
      icon: Users,
      color: 'text-green-600',
      bgColor: 'bg-green-100',
    },
    {
      name: 'Total Value',
      value: `$${totalValue.toLocaleString()}`,
      icon: TrendingUp,
      color: 'text-purple-600',
      bgColor: 'bg-purple-100',
    },
  ];

  return (
    <Layout title="Dashboard">
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat) => (
          <div key={stat.name} className="card">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className={`${stat.bgColor} rounded-md p-3`}>
                  <stat.icon className={`${stat.color} h-6 w-6`} />
                </div>
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    {stat.name}
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {stat.value}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-8 grid grid-cols-1 gap-5 lg:grid-cols-2">
        {/* Recent Assets */}
        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Recent Assets</h3>
          <div className="space-y-3">
            {assets.slice(0, 5).map((asset) => (
              <div key={asset.id} className="flex items-center justify-between py-2 border-b border-gray-100 last:border-b-0">
                <div>
                  <p className="text-sm font-medium text-gray-900">{asset.name}</p>
                  <p className="text-xs text-gray-500">{asset.category} • {asset.location}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm font-medium text-gray-900">${asset.current_value.toLocaleString()}</p>
                  <span className={`inline-flex px-2 py-1 text-xs font-medium rounded-full ${
                    asset.condition === 'excellent' ? 'bg-green-100 text-green-800' :
                    asset.condition === 'good' ? 'bg-blue-100 text-blue-800' :
                    asset.condition === 'fair' ? 'bg-yellow-100 text-yellow-800' :
                    'bg-red-100 text-red-800'
                  }`}>
                    {asset.condition}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Upcoming Maintenance */}
        <div className="card">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Upcoming Maintenance</h3>
          <div className="space-y-3">
            {maintenanceRecords
              .filter(record => record.status === 'scheduled')
              .slice(0, 5)
              .map((record) => (
                <div key={record.id} className="flex items-center justify-between py-2 border-b border-gray-100 last:border-b-0">
                  <div>
                    <p className="text-sm font-medium text-gray-900">{record.maintenance_type}</p>
                    <p className="text-xs text-gray-500">Asset ID: {record.asset_id}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-gray-900">
                      {new Date(record.scheduled_date).toLocaleDateString()}
                    </p>
                    <span className="inline-flex px-2 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-800">
                      {record.status}
                    </span>
                  </div>
                </div>
              ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Dashboard;