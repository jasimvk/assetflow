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
    if (!loading && !isAuthenticated && process.env.NODE_ENV === 'production') {
      router.push('/login');
    }
  }, [isAuthenticated, loading, router]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // In development mode, use mock data
        if (process.env.NODE_ENV === 'development') {
          const mockAssets = [
            {
              id: '1',
              name: 'MacBook Pro 16"',
              category: 'IT Equipment',
              location: 'Office - Floor 1',
              current_value: 2500,
              condition: 'excellent' as const,
              purchase_date: '2023-01-15',
              purchase_cost: 3000,
              assigned_to: null,
              maintenance_schedule: 'quarterly',
              warranty_expiry: '2025-01-15',
              created_at: '2023-01-15T00:00:00Z',
              updated_at: '2023-01-15T00:00:00Z'
            },
            {
              id: '2',
              name: 'Standing Desk',
              category: 'Office Furniture',
              location: 'Office - Floor 2',
              current_value: 800,
              condition: 'good' as const,
              purchase_date: '2023-02-20',
              purchase_cost: 1000,
              assigned_to: null,
              maintenance_schedule: 'annually',
              warranty_expiry: '2025-02-20',
              created_at: '2023-02-20T00:00:00Z',
              updated_at: '2023-02-20T00:00:00Z'
            }
          ];

          const mockMaintenance = [
            {
              id: '1',
              asset_id: '1',
              maintenance_type: 'Software Update',
              scheduled_date: '2024-12-01',
              status: 'scheduled' as const,
              cost: 0,
              completed_date: null,
              notes: 'Regular software maintenance',
              created_at: '2024-01-01T00:00:00Z',
              updated_at: '2024-01-01T00:00:00Z'
            },
            {
              id: '2',
              asset_id: '2',
              maintenance_type: 'Height Adjustment Check',
              scheduled_date: '2024-11-15',
              status: 'in_progress' as const,
              cost: 50,
              completed_date: null,
              notes: 'Check mechanism and lubricate',
              created_at: '2024-01-15T00:00:00Z',
              updated_at: '2024-01-15T00:00:00Z'
            }
          ];

          setAssets(mockAssets);
          setMaintenanceRecords(mockMaintenance);
        } else {
          const [assetsData, maintenanceData] = await Promise.all([
            getAssets(),
            getMaintenanceRecords()
          ]);
          setAssets(assetsData);
          setMaintenanceRecords(maintenanceData);
        }
      } catch (error) {
        console.error('Error fetching dashboard data:', error);
      } finally {
        setDashboardLoading(false);
      }
    };

    fetchData();
  }, []); // Remove dependency on isAuthenticated for development

  if (loading || dashboardLoading) {
    return (
      <Layout title="Dashboard">
        <div className="flex justify-center items-center h-64">
          <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8">
            <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600 mx-auto"></div>
            <p className="text-gray-600 text-center mt-4 font-medium">Loading dashboard...</p>
          </div>
        </div>
      </Layout>
    );
  }

  // Temporarily disable authentication check for development
  // if (!isAuthenticated) {
  //   return null;
  // }

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
      {/* Enhanced Stats Grid */}
      <div className="space-y-8">
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 xl:grid-cols-4">
        {stats.map((stat, index) => (
          <div key={stat.name} className="group relative">
            <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg hover:bg-white/90 transition-all duration-300 group-hover:scale-105">
              <div className="flex items-center justify-between">
                <div className="flex-1">
                  <div className="flex items-center mb-4">
                    <div className={`${stat.bgColor} rounded-2xl p-3 shadow-sm`}>
                      <stat.icon className={`${stat.color} h-7 w-7`} />
                    </div>
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                      {stat.name}
                    </p>
                    <p className="text-3xl font-bold text-gray-900 mb-2">
                      {stat.value}
                    </p>
                    <div className="flex items-center">
                      <div className="w-2 h-2 bg-green-400 rounded-full mr-2 animate-pulse"></div>
                      <span className="text-sm font-medium text-green-600">
                        {index % 2 === 0 ? '+12.5%' : '+8.3%'} from last month
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        ))}
        </div>

        <div className="grid grid-cols-1 gap-8 xl:grid-cols-2">
        {/* Recent Assets */}
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-bold text-gray-900">Recent Assets</h3>
            <div className="flex items-center text-sm text-gray-500">
              <div className="w-2 h-2 bg-blue-400 rounded-full mr-2"></div>
              {assets.length} total assets
            </div>
          </div>
          <div className="space-y-4">
            {assets.length === 0 ? (
              <div className="text-center py-8">
                <Package className="mx-auto h-12 w-12 text-gray-300 mb-4" />
                <p className="text-gray-500 text-sm">No assets found</p>
                <p className="text-gray-400 text-xs mt-1">Assets will appear here once added</p>
              </div>
            ) : (
              assets.slice(0, 5).map((asset, index) => (
              <div key={asset.id} className="group p-4 rounded-2xl hover:bg-gray-50/80 transition-all duration-200">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <div className="w-12 h-12 bg-gradient-to-br from-blue-100 to-blue-200 rounded-2xl flex items-center justify-center">
                      <Package className="h-6 w-6 text-blue-600" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900 group-hover:text-blue-600 transition-colors">
                        {asset.name}
                      </p>
                      <p className="text-xs text-gray-500 flex items-center">
                        <span>{asset.category}</span>
                        <span className="mx-2">•</span>
                        <span>{asset.location}</span>
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-bold text-gray-900">${asset.current_value.toLocaleString()}</p>
                    <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${
                      asset.condition === 'excellent' ? 'bg-green-100 text-green-700 border border-green-200' :
                      asset.condition === 'good' ? 'bg-blue-100 text-blue-700 border border-blue-200' :
                      asset.condition === 'fair' ? 'bg-yellow-100 text-yellow-700 border border-yellow-200' :
                      'bg-red-100 text-red-700 border border-red-200'
                    }`}>
                      {asset.condition}
                    </span>
                  </div>
                </div>
              </div>
            )))}
          </div>
        </div>

        {/* Upcoming Maintenance */}
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-bold text-gray-900">Upcoming Maintenance</h3>
            <div className="flex items-center text-sm text-gray-500">
              <div className="w-2 h-2 bg-orange-400 rounded-full mr-2 animate-pulse"></div>
              {upcomingMaintenance} due this week
            </div>
          </div>
          <div className="space-y-4">
            {maintenanceRecords
              .filter(record => record.status === 'scheduled')
              .slice(0, 5)
              .map((record, index) => (
                <div key={record.id} className="group p-4 rounded-2xl hover:bg-gray-50/80 transition-all duration-200">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-4">
                      <div className="w-12 h-12 bg-gradient-to-br from-orange-100 to-orange-200 rounded-2xl flex items-center justify-center">
                        <Calendar className="h-6 w-6 text-orange-600" />
                      </div>
                      <div>
                        <p className="text-sm font-semibold text-gray-900 group-hover:text-orange-600 transition-colors">
                          {record.maintenance_type}
                        </p>
                        <p className="text-xs text-gray-500">
                          Asset ID: {record.asset_id}
                        </p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-bold text-gray-900">
                        {new Date(record.scheduled_date).toLocaleDateString()}
                      </p>
                      <span className="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-orange-100 text-orange-700 border border-orange-200">
                        {record.status}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            {maintenanceRecords.filter(record => record.status === 'scheduled').length === 0 && (
              <div className="text-center py-8">
                <Calendar className="mx-auto h-12 w-12 text-gray-300 mb-4" />
                <p className="text-gray-500 text-sm">No upcoming maintenance scheduled</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Dashboard;