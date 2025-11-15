import React, { useState } from 'react';
import Layout from '../components/Layout';
import { UserPlus, Plus, Search, Eye, CheckCircle, Clock, XCircle, Download, Filter, Edit, Trash2 } from 'lucide-react';

interface SystemAccessRequest {
  id: string;
  request_number: string;
  employee_first_name: string;
  employee_last_name: string;
  employee_id: string;
  entra_id: string;
  department: string;
  department_head: string;
  date_of_joining: string;
  priority: 'high' | 'medium' | 'low';
  status: 'pending' | 'in_progress' | 'approved' | 'rejected';
  created_at: string;
  notes?: string;
}

const SystemAccessPage = () => {
  const [requests, setRequests] = useState<SystemAccessRequest[]>([
    {
      id: '1',
      request_number: 'SAR-2025-001',
      employee_first_name: 'Ahmed',
      employee_last_name: 'Hassan',
      employee_id: 'EMP-2025-101',
      entra_id: 'a.hassan@1hospitality.ae',
      department: 'Finance',
      department_head: 'Sarah Johnson',
      date_of_joining: '2025-10-15',
      priority: 'high',
      status: 'in_progress',
      created_at: '2025-10-07'
    },
    {
      id: '2',
      request_number: 'SAR-2025-002',
      employee_first_name: 'Fatima',
      employee_last_name: 'Ali',
      employee_id: 'EMP-2025-102',
      entra_id: 'f.ali@1hospitality.ae',
      department: 'HR',
      department_head: 'Mohammed Al-Rashid',
      date_of_joining: '2025-10-20',
      priority: 'medium',
      status: 'pending',
      created_at: '2025-10-08'
    }
  ]);

  const [showModal, setShowModal] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [activeTab, setActiveTab] = useState<'all' | 'pending' | 'approved' | 'rejected'>('all');
  
  // Form state
  const [formData, setFormData] = useState({
    // Employee Details
    employee_first_name: '',
    employee_last_name: '',
    employee_id: '',
    entra_id: '',
    department: '',
    department_head: '',
    date_of_joining: new Date().toISOString().split('T')[0],
    priority: 'medium' as 'high' | 'medium' | 'low',
    
    // Network Access
    network_login: false,
    
    // Email Access
    email_generic: false,
    email_personal: false,
    
    // Oracle Fusion ERP - IT Admin
    it_admin_access: false,
    it_department: false,
    
    // Oracle Fusion ERP - HR Module
    hr_group_1_dhr: false,
    hr_group_2_manager: false,
    hr_group_3_executive: false,
    hr_group_4_accommodation: false,
    hr_group_5_pr: false,
    hr_group_6_hiring: false,
    ess_user: false,
    
    // Oracle Fusion ERP - Finance Module
    finance_ap: false,
    finance_ar: false,
    finance_manager: false,
    finance_dm: false,
    
    // Oracle Fusion ERP - Procurement Module
    procurement_buyer: false,
    procurement_coordinator: false,
    procurement_store: false,
    procurement_receiver: false,
    procurement_requestor: false,
    
    // Timetec Time Attendance
    timetec_it_admin: false,
    timetec_hr_admin: false,
    timetec_dept_coordinator: false,
    
    // IT Assets
    laptop: false,
    desktop: false,
    mobile_camera: false,
    mobile_non_camera: false,
    walkie_talkie: false,
    duty_sim: false,
    
    // Notes
    notes: ''
  });

  const handleOpenModal = () => {
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    // Reset form
    setFormData({
      employee_first_name: '',
      employee_last_name: '',
      employee_id: '',
      entra_id: '',
      department: '',
      department_head: '',
      date_of_joining: new Date().toISOString().split('T')[0],
      priority: 'medium',
      network_login: false,
      email_generic: false,
      email_personal: false,
      it_admin_access: false,
      it_department: false,
      hr_group_1_dhr: false,
      hr_group_2_manager: false,
      hr_group_3_executive: false,
      hr_group_4_accommodation: false,
      hr_group_5_pr: false,
      hr_group_6_hiring: false,
      ess_user: false,
      finance_ap: false,
      finance_ar: false,
      finance_manager: false,
      finance_dm: false,
      procurement_buyer: false,
      procurement_coordinator: false,
      procurement_store: false,
      procurement_receiver: false,
      procurement_requestor: false,
      timetec_it_admin: false,
      timetec_hr_admin: false,
      timetec_dept_coordinator: false,
      laptop: false,
      desktop: false,
      mobile_camera: false,
      mobile_non_camera: false,
      walkie_talkie: false,
      duty_sim: false,
      notes: ''
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Handle form submission
    const newRequest: SystemAccessRequest = {
      id: String(requests.length + 1),
      request_number: `SAR-2025-${String(requests.length + 1).padStart(3, '0')}`,
      employee_first_name: formData.employee_first_name,
      employee_last_name: formData.employee_last_name,
      employee_id: formData.employee_id,
      entra_id: formData.entra_id,
      department: formData.department,
      department_head: formData.department_head,
      date_of_joining: formData.date_of_joining,
      priority: formData.priority,
      status: 'pending',
      created_at: new Date().toISOString().split('T')[0],
      notes: formData.notes
    };
    
    setRequests([...requests, newRequest]);
    handleCloseModal();
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'approved':
        return 'bg-green-100 text-green-800 border-green-300';
      case 'in_progress':
        return 'bg-blue-100 text-blue-800 border-blue-300';
      case 'pending':
        return 'bg-yellow-100 text-yellow-800 border-yellow-300';
      case 'rejected':
        return 'bg-red-100 text-red-800 border-red-300';
      default:
        return 'bg-gray-100 text-gray-800 border-gray-300';
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high':
        return 'bg-red-100 text-red-800 border-red-300';
      case 'medium':
        return 'bg-yellow-100 text-yellow-800 border-yellow-300';
      case 'low':
        return 'bg-green-100 text-green-800 border-green-300';
      default:
        return 'bg-gray-100 text-gray-800 border-gray-300';
    }
  };

  const filteredRequests = requests.filter(request => {
    const matchesSearch = 
      request.employee_first_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      request.employee_last_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      request.employee_id.toLowerCase().includes(searchTerm.toLowerCase()) ||
      request.department.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesTab = activeTab === 'all' || request.status === activeTab;
    
    return matchesSearch && matchesTab;
  });

  const stats = {
    total: requests.length,
    pending: requests.filter(r => r.status === 'pending').length,
    approved: requests.filter(r => r.status === 'approved').length,
    rejected: requests.filter(r => r.status === 'rejected').length
  };

  return (
    <Layout title="System Access Management">
      {/* Page Header */}
      <div className="mb-5">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
              System Access Management
            </h1>
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <span>Home</span>
              <span>•</span>
              <span>System Access</span>
              <span>•</span>
              <span>{new Date().toLocaleDateString()}</span>
            </div>
          </div>
          <button 
            onClick={handleOpenModal}
            className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-all duration-200 shadow-md hover:shadow-lg"
          >
            <Plus className="h-5 w-5" />
            New Access Request
          </button>
        </div>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-4 mb-6">
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Total Requests
              </p>
              <p className="text-3xl font-bold text-gray-900">{stats.total}</p>
            </div>
            <div className="bg-blue-100 rounded-2xl p-3">
              <UserPlus className="text-blue-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Pending
              </p>
              <p className="text-3xl font-bold text-yellow-600">{stats.pending}</p>
            </div>
            <div className="bg-yellow-100 rounded-2xl p-3">
              <Clock className="text-yellow-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Approved
              </p>
              <p className="text-3xl font-bold text-green-600">{stats.approved}</p>
            </div>
            <div className="bg-green-100 rounded-2xl p-3">
              <CheckCircle className="text-green-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Rejected
              </p>
              <p className="text-3xl font-bold text-red-600">{stats.rejected}</p>
            </div>
            <div className="bg-red-100 rounded-2xl p-3">
              <XCircle className="text-red-600 h-7 w-7" />
            </div>
          </div>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 mb-6 shadow-sm">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
            <input
              type="text"
              placeholder="Search by employee name, ID, or department..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-12 pr-4 py-3 bg-white/80 backdrop-blur-sm border border-gray-200 rounded-2xl focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-all duration-300"
            />
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-2 mb-6 shadow-sm">
        <div className="flex gap-2">
          {['all', 'pending', 'approved', 'rejected'].map((tab) => (
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

      {/* Requests Table */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50/80">
              <tr>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Request #
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Employee
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Department
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Joining Date
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Priority
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white/50 divide-y divide-gray-200">
              {filteredRequests.map((request) => (
                <tr key={request.id} className="hover:bg-white/80 transition-all duration-200">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm font-medium text-gray-900">{request.request_number}</div>
                    <div className="text-xs text-gray-500">{request.created_at}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm font-medium text-gray-900">
                      {request.employee_first_name} {request.employee_last_name}
                    </div>
                    <div className="text-xs text-gray-500">{request.employee_id}</div>
                    <div className="text-xs text-gray-500">{request.entra_id}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900">{request.department}</div>
                    <div className="text-xs text-gray-500">{request.department_head}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {request.date_of_joining}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium border ${getPriorityColor(request.priority)}`}>
                      {request.priority === 'high' && '🔴'}
                      {request.priority === 'medium' && '🟡'}
                      {request.priority === 'low' && '🟢'}
                      {' '}{request.priority.toUpperCase()}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium border ${getStatusColor(request.status)}`}>
                      {request.status.replace('_', ' ').toUpperCase()}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <div className="flex items-center space-x-2">
                      <button className="text-blue-600 hover:text-blue-900 transition-colors">
                        <Eye className="h-5 w-5" />
                      </button>
                      <button className="text-green-600 hover:text-green-900 transition-colors">
                        <Edit className="h-5 w-5" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl shadow-2xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 px-8 py-6 rounded-t-3xl z-10">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-gray-900">New Access Request</h2>
                <button
                  onClick={handleCloseModal}
                  className="text-gray-400 hover:text-gray-600 transition-colors"
                >
                  <XCircle className="h-6 w-6" />
                </button>
              </div>
            </div>

            <form onSubmit={handleSubmit} className="p-8 space-y-8">
              {/* Employee Details */}
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  👤 Employee Details
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      First Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.employee_first_name}
                      onChange={(e) => setFormData({...formData, employee_first_name: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Last Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.employee_last_name}
                      onChange={(e) => setFormData({...formData, employee_last_name: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Employee ID *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.employee_id}
                      onChange={(e) => setFormData({...formData, employee_id: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Entra ID (f.lastname@1hospitality.ae) *
                    </label>
                    <input
                      type="email"
                      required
                      placeholder="f.lastname@1hospitality.ae"
                      value={formData.entra_id}
                      onChange={(e) => setFormData({...formData, entra_id: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Department *
                    </label>
                    <select
                      required
                      value={formData.department}
                      onChange={(e) => setFormData({...formData, department: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    >
                      <option value="">Select Department</option>
                      <option value="HR">HR</option>
                      <option value="Finance">Finance</option>
                      <option value="IT">IT</option>
                      <option value="Operations">Operations</option>
                      <option value="Procurement">Procurement</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Department Head *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.department_head}
                      onChange={(e) => setFormData({...formData, department_head: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Date of Joining *
                    </label>
                    <input
                      type="date"
                      required
                      value={formData.date_of_joining}
                      onChange={(e) => setFormData({...formData, date_of_joining: e.target.value})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Priority *
                    </label>
                    <select
                      required
                      value={formData.priority}
                      onChange={(e) => setFormData({...formData, priority: e.target.value as any})}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    >
                      <option value="low">🟢 Low (Non-urgent)</option>
                      <option value="medium">🟡 Medium (Standard 2-3 days)</option>
                      <option value="high">🔴 High (Urgent - Starting Today)</option>
                    </select>
                  </div>
                </div>
              </div>

              {/* System Access Required */}
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  💻 System Access Required
                </h3>
                
                {/* Network & Email Access */}
                <div className="space-y-4 mb-6">
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.network_login}
                      onChange={(e) => setFormData({...formData, network_login: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">
                      Network Login (Windows/Entra ID)
                    </label>
                  </div>
                  
                  <div className="ml-8 space-y-2">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.email_generic}
                        onChange={(e) => setFormData({...formData, email_generic: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-600">
                        Generic Email
                      </label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.email_personal}
                        onChange={(e) => setFormData({...formData, email_personal: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-600">
                        Personal Email
                      </label>
                    </div>
                  </div>
                </div>

                {/* Oracle Fusion ERP - IT Admin */}
                <div className="bg-blue-50/50 rounded-xl p-4 mb-4">
                  <h4 className="text-md font-semibold text-gray-900 mb-3">Oracle Fusion ERP - IT Admin Access</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.it_admin_access}
                        onChange={(e) => setFormData({...formData, it_admin_access: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">IT Admin Access</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.it_department}
                        onChange={(e) => setFormData({...formData, it_department: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">IT Department</label>
                    </div>
                  </div>
                </div>

                {/* Oracle Fusion ERP - HR Module */}
                <div className="bg-purple-50/50 rounded-xl p-4 mb-4">
                  <h4 className="text-md font-semibold text-gray-900 mb-3">Oracle Fusion ERP - HR Module</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.hr_group_1_dhr}
                        onChange={(e) => setFormData({...formData, hr_group_1_dhr: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 1: DHR</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.hr_group_2_manager}
                        onChange={(e) => setFormData({...formData, hr_group_2_manager: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 2: HR Manager</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.hr_group_3_executive}
                        onChange={(e) => setFormData({...formData, hr_group_3_executive: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 3: Executive</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.hr_group_4_accommodation}
                        onChange={(e) => setFormData({...formData, hr_group_4_accommodation: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 4: Accommodation</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.hr_group_5_pr}
                        onChange={(e) => setFormData({...formData, hr_group_5_pr: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 5: Public Relations</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.hr_group_6_hiring}
                        onChange={(e) => setFormData({...formData, hr_group_6_hiring: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 6: Hiring</label>
                    </div>
                    <div className="flex items-center md:col-span-2">
                      <input
                        type="checkbox"
                        checked={formData.ess_user}
                        onChange={(e) => setFormData({...formData, ess_user: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm font-medium text-gray-700">ESS User (Employee Self-Service)</label>
                    </div>
                  </div>
                </div>

                {/* Oracle Fusion ERP - Finance Module */}
                <div className="bg-green-50/50 rounded-xl p-4 mb-4">
                  <h4 className="text-md font-semibold text-gray-900 mb-3">Oracle Fusion ERP - Finance Module</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.finance_ap}
                        onChange={(e) => setFormData({...formData, finance_ap: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">AP (Accounts Payable)</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.finance_ar}
                        onChange={(e) => setFormData({...formData, finance_ar: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">AR (Accounts Receivable)</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.finance_manager}
                        onChange={(e) => setFormData({...formData, finance_manager: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Finance Manager</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.finance_dm}
                        onChange={(e) => setFormData({...formData, finance_dm: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">DM Finance</label>
                    </div>
                  </div>
                </div>

                {/* Oracle Fusion ERP - Procurement Module */}
                <div className="bg-orange-50/50 rounded-xl p-4 mb-4">
                  <h4 className="text-md font-semibold text-gray-900 mb-3">Oracle Fusion ERP - Procurement Module</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.procurement_buyer}
                        onChange={(e) => setFormData({...formData, procurement_buyer: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 3: Buyer</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.procurement_coordinator}
                        onChange={(e) => setFormData({...formData, procurement_coordinator: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 4: Coordinator</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.procurement_store}
                        onChange={(e) => setFormData({...formData, procurement_store: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 5: Store</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.procurement_receiver}
                        onChange={(e) => setFormData({...formData, procurement_receiver: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 6: Receiver</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.procurement_requestor}
                        onChange={(e) => setFormData({...formData, procurement_requestor: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 7: Requestor</label>
                    </div>
                  </div>
                </div>

                {/* Timetec Time Attendance */}
                <div className="bg-cyan-50/50 rounded-xl p-4 mb-4">
                  <h4 className="text-md font-semibold text-gray-900 mb-3">Timetec Time Attendance</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.timetec_it_admin}
                        onChange={(e) => setFormData({...formData, timetec_it_admin: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 1: IT Admin</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.timetec_hr_admin}
                        onChange={(e) => setFormData({...formData, timetec_hr_admin: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 2: HR Admin</label>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={formData.timetec_dept_coordinator}
                        onChange={(e) => setFormData({...formData, timetec_dept_coordinator: e.target.checked})}
                        className="h-4 w-4 text-primary-600 rounded focus:ring-primary-500"
                      />
                      <label className="ml-3 text-sm text-gray-700">Group 3: Dept Coordinator</label>
                    </div>
                  </div>
                </div>
              </div>

              {/* IT Assets Needed */}
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                  🖥️ IT Assets Needed
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.laptop}
                      onChange={(e) => setFormData({...formData, laptop: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">💻 Laptop</label>
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.desktop}
                      onChange={(e) => setFormData({...formData, desktop: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">🖥️ Desktop</label>
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.mobile_camera}
                      onChange={(e) => setFormData({...formData, mobile_camera: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">📱 Mobile (with camera)</label>
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.mobile_non_camera}
                      onChange={(e) => setFormData({...formData, mobile_non_camera: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">📱 Mobile (non-camera)</label>
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.walkie_talkie}
                      onChange={(e) => setFormData({...formData, walkie_talkie: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">📻 Walkie Talkie</label>
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.duty_sim}
                      onChange={(e) => setFormData({...formData, duty_sim: e.target.checked})}
                      className="h-5 w-5 text-primary-600 rounded focus:ring-primary-500"
                    />
                    <label className="ml-3 text-sm font-medium text-gray-700">📞 Duty SIM Card</label>
                  </div>
                </div>
              </div>

              {/* Notes */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Additional Notes / Special Requirements
                </label>
                <textarea
                  value={formData.notes}
                  onChange={(e) => setFormData({...formData, notes: e.target.value})}
                  rows={4}
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Any special requirements or additional information..."
                />
              </div>

              {/* Form Actions */}
              <div className="flex items-center justify-end space-x-4 pt-6 border-t border-gray-200">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="px-6 py-3 border border-gray-300 rounded-xl text-gray-700 font-medium hover:bg-gray-50 transition-all duration-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-all duration-200 shadow-md hover:shadow-lg"
                >
                  Submit Request
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </Layout>
  );
};

export default SystemAccessPage;
