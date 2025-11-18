import React, { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { BarChart3, Download, FileText, TrendingUp, Calendar, DollarSign, Package } from 'lucide-react';

interface Report {
  id: string;
  name: string;
  description: string;
  icon: any;
  color: string;
  bgColor: string;
  lastGenerated: string;
  size: string;
}

const Reports = () => {
  const [selectedPeriod, setSelectedPeriod] = useState<'week' | 'month' | 'quarter' | 'year'>('month');
  const [reports, setReports] = useState<Report[]>([]);
  const [stats, setStats] = useState({
    totalReports: 0,
    generatedThisMonth: 0,
    scheduledReports: 0
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchReports();
  }, []);

  const fetchReports = async () => {
    try {
      setLoading(true);
      // TODO: Replace with actual API call when reports endpoint is ready
      // For now, setting empty arrays to remove hardcoded data
      setReports([]);
      setStats({
        totalReports: 0,
        generatedThisMonth: 0,
        scheduledReports: 0
      });
    } catch (error) {
      console.error('Error fetching reports:', error);
      setReports([]);
    } finally {
      setLoading(false);
    }
  };

  const reportTemplates = [
    {
      id: 'inventory',
      name: 'Asset Inventory Report',
      description: 'Complete inventory of all assets with current status',
      icon: Package,
      color: 'text-blue-600',
      bgColor: 'bg-blue-100',
    },
    {
      id: 'financial',
      name: 'Financial Summary',
      description: 'Total asset value and depreciation analysis',
      icon: DollarSign,
      color: 'text-green-600',
      bgColor: 'bg-green-100',
    },
    {
      id: 'utilization',
      name: 'Asset Utilization Report',
      description: 'Usage statistics and utilization rates',
      icon: TrendingUp,
      color: 'text-purple-600',
      bgColor: 'bg-purple-100',
    },
    {
      id: 'depreciation',
      name: 'Depreciation Report',
      description: 'Asset depreciation over time',
      icon: BarChart3,
      color: 'text-orange-600',
      bgColor: 'bg-orange-100',
    },
    {
      id: 'compliance',
      name: 'Compliance Report',
      description: 'Regulatory compliance and audit trail',
      icon: FileText,
      color: 'text-red-600',
      bgColor: 'bg-red-100',
    },
    {
      id: 'activity',
      name: 'Monthly Activity Report',
      description: 'All transactions and activities for the month',
      icon: Calendar,
      color: 'text-cyan-600',
      bgColor: 'bg-cyan-100',
    },
  ];

  const statsArray = [
    { label: 'Total Reports', value: stats.totalReports.toString(), change: '+12%', color: 'text-blue-600', bgColor: 'bg-blue-100' },
    { label: 'Generated This Month', value: stats.generatedThisMonth.toString(), change: '+8%', color: 'text-green-600', bgColor: 'bg-green-100' },
    { label: 'Scheduled Reports', value: stats.scheduledReports.toString(), change: '+2', color: 'text-purple-600', bgColor: 'bg-purple-100' },
  ];

  return (
    <Layout title="Reports">
      {/* Page Header */}
      <div className="mb-5">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
              Reports & Analytics
            </h1>
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <span>Home</span>
              <span>•</span>
              <span>Reports</span>
              <span>•</span>
              <span>{new Date().toLocaleDateString()}</span>
            </div>
          </div>
          <button className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-all duration-200 shadow-md hover:shadow-lg">
            <FileText className="h-5 w-5" />
            Generate Custom Report
          </button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-3 mb-6">
        {statsArray.map((stat) => (
          <div key={stat.label} className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
            <div className="flex items-center justify-between mb-2">
              <div>
                <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                  {stat.label}
                </p>
                <p className="text-3xl font-bold text-gray-900">{stat.value}</p>
              </div>
              <div className={`${stat.bgColor} rounded-2xl p-3`}>
                <BarChart3 className={`${stat.color} h-7 w-7`} />
              </div>
            </div>
            <div className="flex items-center">
              <TrendingUp className="h-4 w-4 text-green-600 mr-1" />
              <span className="text-sm font-semibold text-green-600">{stat.change}</span>
              <span className="text-sm text-gray-500 ml-2">from last period</span>
            </div>
          </div>
        ))}
      </div>

      {/* Period Filter */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 mb-6 shadow-sm">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-lg font-bold text-gray-900 mb-1">Report Period</h3>
            <p className="text-sm text-gray-600">Select the time period for analytics</p>
          </div>
          <div className="flex gap-2">
            {['week', 'month', 'quarter', 'year'].map((period) => (
              <button
                key={period}
                onClick={() => setSelectedPeriod(period as any)}
                className={`px-4 py-2 rounded-xl font-semibold text-sm transition-all duration-200 ${
                  selectedPeriod === period
                    ? 'bg-primary-500 text-white shadow-md'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {period.charAt(0).toUpperCase() + period.slice(1)}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Reports Grid */}
      {loading ? (
        <div className="flex justify-center items-center h-64">
          <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8">
            <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600 mx-auto"></div>
            <p className="text-gray-600 text-center mt-4 font-medium">Loading reports...</p>
          </div>
        </div>
      ) : reports.length === 0 ? (
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-12 text-center">
          <FileText className="h-16 w-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-xl font-bold text-gray-900 mb-2">No Reports Generated Yet</h3>
          <p className="text-gray-600 mb-6">Generate your first report using the templates below</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          {reports.map((report) => (
            <div key={report.id} className="group bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
              <div className="flex items-start justify-between mb-4">
                <div className={`${report.bgColor} rounded-2xl p-3`}>
                  <report.icon className={`${report.color} h-7 w-7`} />
                </div>
                <button className="p-2 hover:bg-gray-100 rounded-xl transition-colors">
                  <Download className="h-5 w-5 text-gray-600" />
                </button>
              </div>
              
              <h3 className="text-lg font-bold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">
                {report.name}
              </h3>
              <p className="text-sm text-gray-600 mb-4">
                {report.description}
              </p>
              
              <div className="flex items-center justify-between text-sm text-gray-500 mb-4 pb-4 border-b border-gray-200">
                <div className="flex items-center gap-1">
                  <Calendar className="h-4 w-4" />
                  <span>{report.lastGenerated}</span>
                </div>
                <span className="font-semibold">{report.size}</span>
              </div>
              
              <button className="w-full py-2 bg-gray-50 hover:bg-gray-100 text-gray-700 font-semibold rounded-xl transition-colors">
                View Report
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Report Templates */}
      <div className="mt-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">Report Templates</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {reportTemplates.map((template) => (
            <div key={template.id} className="group bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
            <div className="flex items-start justify-between mb-4">
              <div className={`${template.bgColor} rounded-2xl p-3`}>
                <template.icon className={`${template.color} h-7 w-7`} />
              </div>
            </div>
            
            <h3 className="text-lg font-bold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">
              {template.name}
            </h3>
            <p className="text-sm text-gray-600 mb-4">
              {template.description}
            </p>
            
            <div className="mt-4">
              <button className="w-full px-4 py-2 bg-primary-500 text-white rounded-xl font-semibold text-sm hover:bg-primary-600 transition-colors">
                Generate Report
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
    </Layout>
  );
};

export default Reports;
