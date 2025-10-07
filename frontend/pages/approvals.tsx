import React, { useState } from 'react';
import Layout from '../components/Layout';
import { CheckCircle, XCircle, Clock, Filter, Search } from 'lucide-react';

const Approvals = () => {
  const [filter, setFilter] = useState<'all' | 'pending' | 'approved' | 'rejected'>('all');

  // Mock approvals data
  const approvals = [
    {
      id: '1',
      type: 'Asset Purchase',
      item: 'MacBook Pro 16" M3',
      requestedBy: 'John Doe',
      department: 'IT',
      amount: '$3,499',
      date: '2025-10-05',
      status: 'pending' as const,
      priority: 'high' as const,
    },
    {
      id: '2',
      type: 'Asset Transfer',
      item: 'Standing Desk',
      requestedBy: 'Jane Smith',
      department: 'HR',
      amount: '-',
      date: '2025-10-04',
      status: 'approved' as const,
      priority: 'medium' as const,
    },
    {
      id: '3',
      type: 'Asset Disposal',
      item: 'Old Server Rack',
      requestedBy: 'Mike Johnson',
      department: 'IT',
      amount: '$500',
      date: '2025-10-03',
      status: 'pending' as const,
      priority: 'low' as const,
    },
    {
      id: '4',
      type: 'Budget Approval',
      item: 'Office Furniture Set',
      requestedBy: 'Sarah Williams',
      department: 'Admin',
      amount: '$8,500',
      date: '2025-10-02',
      status: 'approved' as const,
      priority: 'high' as const,
    },
    {
      id: '5',
      type: 'Asset Purchase',
      item: 'Conference Room Projector',
      requestedBy: 'Robert Brown',
      department: 'Operations',
      amount: '$1,200',
      date: '2025-10-01',
      status: 'rejected' as const,
      priority: 'medium' as const,
    },
  ];

  const filteredApprovals = filter === 'all' 
    ? approvals 
    : approvals.filter(a => a.status === filter);

  const stats = [
    { label: 'Pending', count: approvals.filter(a => a.status === 'pending').length, color: 'text-yellow-600', bgColor: 'bg-yellow-100' },
    { label: 'Approved', count: approvals.filter(a => a.status === 'approved').length, color: 'text-green-600', bgColor: 'bg-green-100' },
    { label: 'Rejected', count: approvals.filter(a => a.status === 'rejected').length, color: 'text-red-600', bgColor: 'bg-red-100' },
  ];

  return (
    <Layout title="Approvals">
      {/* Page Header */}
      <div className="mb-5">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
          Approvals
        </h1>
        <div className="flex items-center space-x-2 text-sm text-gray-500">
          <span>Home</span>
          <span>•</span>
          <span>Approvals</span>
          <span>•</span>
          <span>{new Date().toLocaleDateString()}</span>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-3 mb-6">
        {stats.map((stat) => (
          <div key={stat.label} className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                  {stat.label}
                </p>
                <p className="text-3xl font-bold text-gray-900">{stat.count}</p>
              </div>
              <div className={`${stat.bgColor} rounded-2xl p-3`}>
                {stat.label === 'Pending' && <Clock className={`${stat.color} h-7 w-7`} />}
                {stat.label === 'Approved' && <CheckCircle className={`${stat.color} h-7 w-7`} />}
                {stat.label === 'Rejected' && <XCircle className={`${stat.color} h-7 w-7`} />}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Filters and Search */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 mb-6 shadow-sm">
        <div className="flex flex-col sm:flex-row gap-4 items-center justify-between">
          <div className="flex gap-2">
            {['all', 'pending', 'approved', 'rejected'].map((f) => (
              <button
                key={f}
                onClick={() => setFilter(f as any)}
                className={`px-4 py-2 rounded-xl font-semibold text-sm transition-all duration-200 ${
                  filter === f
                    ? 'bg-primary-500 text-white shadow-md'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {f.charAt(0).toUpperCase() + f.slice(1)}
              </button>
            ))}
          </div>
          <div className="relative w-full sm:w-64">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search approvals..."
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>
        </div>
      </div>

      {/* Approvals List */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm">
        <div className="space-y-4">
          {filteredApprovals.map((approval) => (
            <div key={approval.id} className="group p-6 rounded-2xl border border-gray-200/60 hover:bg-gray-50/80 transition-all duration-200">
              <div className="flex items-center justify-between">
                <div className="flex-1">
                  <div className="flex items-center gap-4 mb-3">
                    <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                      approval.priority === 'high' ? 'bg-red-100 text-red-700' :
                      approval.priority === 'medium' ? 'bg-yellow-100 text-yellow-700' :
                      'bg-gray-100 text-gray-700'
                    }`}>
                      {approval.priority.toUpperCase()}
                    </span>
                    <span className="text-sm font-semibold text-gray-500">{approval.type}</span>
                  </div>
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{approval.item}</h3>
                  <div className="flex items-center gap-6 text-sm text-gray-600">
                    <span>Requested by: <span className="font-semibold">{approval.requestedBy}</span></span>
                    <span>Department: <span className="font-semibold">{approval.department}</span></span>
                    <span>Amount: <span className="font-semibold">{approval.amount}</span></span>
                    <span>Date: <span className="font-semibold">{approval.date}</span></span>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  {approval.status === 'pending' ? (
                    <>
                      <button className="px-6 py-2 bg-green-500 text-white rounded-xl font-semibold hover:bg-green-600 transition-colors">
                        Approve
                      </button>
                      <button className="px-6 py-2 bg-red-500 text-white rounded-xl font-semibold hover:bg-red-600 transition-colors">
                        Reject
                      </button>
                    </>
                  ) : (
                    <span className={`px-4 py-2 rounded-xl font-semibold text-sm ${
                      approval.status === 'approved' ? 'bg-green-100 text-green-700' :
                      'bg-red-100 text-red-700'
                    }`}>
                      {approval.status.charAt(0).toUpperCase() + approval.status.slice(1)}
                    </span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </Layout>
  );
};

export default Approvals;
