import React, { useState } from 'react';
import Layout from '../components/Layout';
import { FileText, Plus, Eye, Edit, Trash2, Copy } from 'lucide-react';

const Forms = () => {
  const [activeTab, setActiveTab] = useState<'all' | 'templates' | 'submissions'>('all');

  // Mock forms data
  const forms = [
    {
      id: '1',
      name: 'Asset Purchase Request',
      description: 'Request form for purchasing new assets',
      category: 'Purchase',
      submissions: 24,
      lastModified: '2025-10-05',
      status: 'active' as const,
    },
    {
      id: '2',
      name: 'Asset Transfer Form',
      description: 'Form to request asset transfer between departments',
      category: 'Transfer',
      submissions: 12,
      lastModified: '2025-10-03',
      status: 'active' as const,
    },
    {
      id: '3',
      name: 'Asset Disposal Request',
      description: 'Request form for disposing of old or damaged assets',
      category: 'Disposal',
      submissions: 8,
      lastModified: '2025-09-28',
      status: 'active' as const,
    },
    {
      id: '4',
      name: 'Equipment Checkout',
      description: 'Form for temporary equipment checkout',
      category: 'Checkout',
      submissions: 45,
      lastModified: '2025-10-01',
      status: 'active' as const,
    },
    {
      id: '5',
      name: 'Budget Approval Form',
      description: 'Form for requesting budget approvals',
      category: 'Budget',
      submissions: 15,
      lastModified: '2025-09-25',
      status: 'draft' as const,
    },
  ];

  return (
    <Layout title="Forms">
      {/* Page Header */}
      <div className="mb-5">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
              Forms
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
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Total Forms
              </p>
              <p className="text-3xl font-bold text-gray-900">{forms.length}</p>
            </div>
            <div className="bg-blue-100 rounded-2xl p-3">
              <FileText className="text-blue-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Active Forms
              </p>
              <p className="text-3xl font-bold text-gray-900">
                {forms.filter(f => f.status === 'active').length}
              </p>
            </div>
            <div className="bg-green-100 rounded-2xl p-3">
              <FileText className="text-green-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Total Submissions
              </p>
              <p className="text-3xl font-bold text-gray-900">
                {forms.reduce((sum, f) => sum + f.submissions, 0)}
              </p>
            </div>
            <div className="bg-purple-100 rounded-2xl p-3">
              <FileText className="text-purple-600 h-7 w-7" />
            </div>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-2 mb-6 shadow-sm">
        <div className="flex gap-2">
          {['all', 'templates', 'submissions'].map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab as any)}
              className={`flex-1 px-6 py-3 rounded-2xl font-semibold text-sm transition-all duration-200 ${
                activeTab === tab
                  ? 'bg-primary-500 text-white shadow-md'
                  : 'text-gray-600 hover:bg-gray-100'
              }`}
            >
              {tab.charAt(0).toUpperCase() + tab.slice(1)}
            </button>
          ))}
        </div>
      </div>

      {/* Forms Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {forms.map((form) => (
          <div key={form.id} className="group bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
            <div className="flex items-start justify-between mb-4">
              <div className="w-12 h-12 bg-gradient-to-br from-cyan-100 to-cyan-200 rounded-2xl flex items-center justify-center">
                <FileText className="h-6 w-6 text-cyan-600" />
              </div>
              <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                form.status === 'active' 
                  ? 'bg-green-100 text-green-700' 
                  : 'bg-gray-100 text-gray-700'
              }`}>
                {form.status.toUpperCase()}
              </span>
            </div>
            
            <h3 className="text-lg font-bold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">
              {form.name}
            </h3>
            <p className="text-sm text-gray-600 mb-4 line-clamp-2">
              {form.description}
            </p>
            
            <div className="flex items-center justify-between text-sm text-gray-500 mb-4">
              <span className="font-semibold">{form.category}</span>
              <span>{form.submissions} submissions</span>
            </div>
            
            <div className="text-xs text-gray-400 mb-4">
              Last modified: {form.lastModified}
            </div>
            
            <div className="flex gap-2">
              <button className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-xl font-semibold text-sm hover:bg-primary-600 transition-colors">
                <Eye className="h-4 w-4" />
                View
              </button>
              <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-xl font-semibold text-sm hover:bg-gray-200 transition-colors">
                <Edit className="h-4 w-4" />
              </button>
              <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-xl font-semibold text-sm hover:bg-gray-200 transition-colors">
                <Copy className="h-4 w-4" />
              </button>
            </div>
          </div>
        ))}
      </div>
    </Layout>
  );
};

export default Forms;
