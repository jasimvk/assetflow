import React, { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { FileText, Plus, Eye, Edit, Trash2 } from 'lucide-react';

interface Form {
  id: number;
  name: string;
  category: string;
  submissions: number;
  lastModified: string;
  status: string;
}

const Forms = () => {
  const [activeTab, setActiveTab] = useState('all');
  const [forms, setForms] = useState<Form[]>([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalForms: 0,
    templates: 0,
    submissions: 0
  });

  useEffect(() => {
    fetchForms();
  }, []);

  const fetchForms = async () => {
    try {
      setLoading(true);
      // TODO: Replace with actual API call when forms endpoint is ready
      // const data = await formsAPI.getAll();
      // For now, setting empty arrays to remove hardcoded data
      setForms([]);
      setStats({
        totalForms: 0,
        templates: 0,
        submissions: 0
      });
    } catch (error) {
      console.error('Error fetching forms:', error);
      setForms([]);
    } finally {
      setLoading(false);
    }
  };

  const statsArray = [
    { name: 'Total Forms', value: stats.totalForms.toString(), icon: FileText, color: 'bg-blue-100 text-blue-600' },
    { name: 'Templates', value: stats.templates.toString(), icon: FileText, color: 'bg-purple-100 text-purple-600' },
    { name: 'Submissions', value: stats.submissions.toString(), icon: FileText, color: 'bg-green-100 text-green-600' },
  ];

  return (
    <Layout title="Forms">
      {/* Page Header */}
      <div className="mb-5">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
              Forms & Templates
            </h1>
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <span>Home</span>
              <span>•</span>
              <span>Forms</span>
              <span>•</span>
              <span>{new Date().toLocaleDateString()}</span>
            </div>
          </div>
          <button className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-all duration-200 shadow-md hover:shadow-lg">
            <Plus className="h-5 w-5" />
            Create New Form
          </button>
        </div>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-3 mb-6">
        {statsArray.map((stat) => (
          <div key={stat.name} className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                  {stat.name}
                </p>
                <p className="text-3xl font-bold text-gray-900">{stat.value}</p>
              </div>
              <div className={`${stat.color} rounded-2xl p-3`}>
                <stat.icon className="h-7 w-7" />
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl mb-6 shadow-sm">
        <div className="flex border-b border-gray-200/60">
          {['all', 'templates', 'submissions'].map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-8 py-4 text-sm font-semibold capitalize transition-colors ${
                activeTab === tab
                  ? 'text-primary-600 border-b-2 border-primary-600'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              {tab}
            </button>
          ))}
        </div>
      </div>

      {/* Forms Grid */}
      {loading ? (
        <div className="flex justify-center items-center h-64">
          <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8">
            <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600 mx-auto"></div>
            <p className="text-gray-600 text-center mt-4 font-medium">Loading forms...</p>
          </div>
        </div>
      ) : forms.length === 0 ? (
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-12 text-center">
          <FileText className="h-16 w-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-xl font-bold text-gray-900 mb-2">No Forms Available</h3>
          <p className="text-gray-600 mb-6">Create your first form to get started</p>
          <button className="inline-flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-all duration-200">
            <Plus className="h-5 w-5" />
            Create New Form
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          {forms.map((form) => (
            <div key={form.id} className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
              <div className="flex items-start justify-between mb-4">
                <div className="bg-blue-100 rounded-2xl p-3">
                  <FileText className="h-6 w-6 text-blue-600" />
                </div>
                <span className="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-700 border border-green-200">
                  {form.status}
                </span>
              </div>
              
              <h3 className="text-lg font-bold text-gray-900 mb-2">{form.name}</h3>
              <p className="text-sm text-gray-600 mb-4">{form.category}</p>
              
              <div className="flex items-center justify-between text-sm text-gray-500 mb-4">
                <span>{form.submissions} submissions</span>
                <span>{form.lastModified}</span>
              </div>
              
              <div className="flex items-center gap-2">
                <button className="flex-1 flex items-center justify-center gap-2 px-4 py-2 text-sm border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors">
                  <Eye className="h-4 w-4" />
                  View
                </button>
                <button className="flex-1 flex items-center justify-center gap-2 px-4 py-2 text-sm border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors">
                  <Edit className="h-4 w-4" />
                  Edit
                </button>
                <button className="p-2 text-red-600 border border-gray-300 rounded-xl hover:bg-red-50 transition-colors">
                  <Trash2 className="h-4 w-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </Layout>
  );
};

export default Forms;
