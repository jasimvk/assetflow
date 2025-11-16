import React, { useEffect, useState } from 'react';
import Layout from '../components/Layout';
import { useAuth } from '../context/AuthContext';
import { useRouter } from 'next/router';
import { assetsAPI, maintenanceAPI, dashboardAPI, systemAccessAPI } from '../utils/api';
import { Package, Calendar, Users, TrendingUp, UserPlus, Clock } from 'lucide-react';

interface Asset {
  id: string;
  name: string;
  category: string;
  location: string;
  current_value: number;
  condition: 'excellent' | 'good' | 'fair' | 'poor';
  purchase_date: string;
  purchase_cost: number;
  assigned_to: string | null;
  maintenance_schedule: string;
  warranty_expiry: string;
  created_at: string;
  updated_at: string;
}

interface MaintenanceRecord {
  id: string;
  asset_id: string;
  maintenance_type: string;
  description: string;
  scheduled_date: string;
  completed_date: string | null;
  cost: number;
  status: 'scheduled' | 'in_progress' | 'completed' | 'cancelled';
  notes: string;
  created_at: string;
  updated_at: string;
}

const Dashboard = () => {
  const { isAuthenticated, loading } = useAuth();
  const router = useRouter();
  const [assets, setAssets] = useState<Asset[]>([]);
  const [maintenanceRecords, setMaintenanceRecords] = useState<MaintenanceRecord[]>([]);
  const [dashboardStats, setDashboardStats] = useState<any>(null);
  const [pendingRequests, setPendingRequests] = useState<number>(0);
  const [dashboardLoading, setDashboardLoading] = useState(true);

  useEffect(() => {
    if (!loading && !isAuthenticated && process.env.NODE_ENV === 'production') {
      router.push('/login');
    }
  }, [isAuthenticated, loading, router]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setDashboardLoading(true);
        
        // Fetch all data in parallel
        const [
          fetchedAssets,
          fetchedMaintenance,
          stats,
          systemAccessRequests
        ] = await Promise.all([
          assetsAPI.getAll(),
          maintenanceAPI.getAll(),
          dashboardAPI.getStats(),
          systemAccessAPI.getAll({ status: 'pending' })
        ]);

        setAssets(fetchedAssets || []);
        setMaintenanceRecords(fetchedMaintenance || []);
        setDashboardStats(stats);
        setPendingRequests(systemAccessRequests?.length || 0);
      } catch (error) {
        console.error('Error fetching dashboard data:', error);
        // Set empty arrays on error
        setAssets([]);
        setMaintenanceRecords([]);
        setPendingRequests(0);
      } finally {
        setDashboardLoading(false);
      }
    };

    fetchData();
  }, []);

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
      name: 'Total Value',
      value: `AED ${totalValue.toLocaleString()}`,
      icon: TrendingUp,
      color: 'text-purple-600',
      bgColor: 'bg-purple-100',
    },
    {
      name: 'Pending Access Requests',
      value: pendingRequests.toString(),
      icon: UserPlus,
      color: 'text-orange-600',
      bgColor: 'bg-orange-100',
    },
    {
      name: 'Active Maintenance',
      value: assetsInMaintenance.toString(),
      icon: Clock,
      color: 'text-green-600',
      bgColor: 'bg-green-100',
    },
  ];

  return (
    <Layout title="Dashboard">
      {/* Page Header */}
      <div className="mb-5">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
          Dashboard
        </h1>
        <div className="flex items-center space-x-2 text-sm text-gray-500">
          <span>Home</span>
          <span>•</span>
          <span>Dashboard</span>
          <span>•</span>
          <span>{new Date().toLocaleDateString()}</span>
        </div>
      </div>

      {/* Dashboard Content */}
      <div className="space-y-6">
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
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

        {/* System Access Requests Section */}
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-bold text-gray-900 flex items-center gap-2">
              <UserPlus className="h-6 w-6 text-orange-600" />
              Recent System Access Requests
            </h3>
            <a 
              href="/system-access"
              className="text-sm text-primary-600 hover:text-primary-700 font-semibold flex items-center gap-1"
            >
              View all →
            </a>
          </div>
          <div className="space-y-4">
            {[
              {
                id: '1',
                employee: 'Ahmed Hassan',
                department: 'Finance',
                date: '2025-10-15',
                status: 'in_progress',
                systems: 4,
                assets: 2
              },
              {
                id: '2',
                employee: 'Fatima Ali',
                department: 'HR',
                date: '2025-10-20',
                status: 'pending',
                systems: 3,
                assets: 1
              }
            ].map((request) => (
              <div key={request.id} className="group p-4 rounded-2xl hover:bg-gray-50/80 transition-all duration-200">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <div className="w-12 h-12 bg-gradient-to-br from-orange-100 to-orange-200 rounded-2xl flex items-center justify-center">
                      <UserPlus className="h-6 w-6 text-orange-600" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900 group-hover:text-orange-600 transition-colors">
                        {request.employee}
                      </p>
                      <p className="text-xs text-gray-500 flex items-center">
                        <span>{request.department}</span>
                        <span className="mx-2">•</span>
                        <span>Joining: {new Date(request.date).toLocaleDateString()}</span>
                      </p>
                      <p className="text-xs text-gray-400 mt-1">
                        {request.systems} systems • {request.assets} assets
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className={`inline-flex items-center gap-1 px-3 py-1 text-xs font-semibold rounded-full ${
                      request.status === 'in_progress' 
                        ? 'bg-blue-100 text-blue-700 border border-blue-200' 
                        : 'bg-yellow-100 text-yellow-700 border border-yellow-200'
                    }`}>
                      <Clock className="h-3 w-3" />
                      {request.status === 'in_progress' ? 'In Progress' : 'Pending'}
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

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
                        <p className="text-sm font-bold text-gray-900">AED {asset.current_value.toLocaleString()}</p>
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
                ))
              )}
            </div>
          </div>
      </div>
    </Layout>
  );
};

export default Dashboard;