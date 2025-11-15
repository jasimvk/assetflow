import React, { useState } from 'react';
import Layout from '../components/Layout';
import { UserPlus, Plus, Search, Eye, CheckCircle, Clock, XCircle, Download, Filter } from 'lucide-react';

interface SystemAccessRequest {
  id: string;
  request_number: string;
  employee_first_name: string;
  employee_last_name: string;
  employee_id: string;
  department: string;
  department_head: string;
  email: string;
  date_of_joining: string;
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled';
  created_at: string;
  systems_count?: number;
  assets_count?: number;
}

interface SystemAccess {
  system_name: string;
  access_type: string;
  status: 'pending' | 'provisioned' | 'failed';
}

interface ITAsset {
  asset_type: string;
  asset_details: string;
  status: 'pending' | 'handed_over' | 'returned';
}

const SystemAccess = () => {
  const [requests, setRequests] = useState<SystemAccessRequest[]>([
    {
      id: '1',
      request_number: 'SAR-2025-001',
      employee_first_name: 'Ahmed',
      employee_last_name: 'Hassan',
      employee_id: 'EMP-2025-101',
      department: 'Finance',
      department_head: 'Sarah Johnson',
      email: 'ahmed.hassan@company.ae',
      date_of_joining: '2025-10-15',
      status: 'in_progress',
      created_at: '2025-10-07',
      systems_count: 4,
      assets_count: 2
    },
    {
      id: '2',
      request_number: 'SAR-2025-002',
      employee_first_name: 'Fatima',
      employee_last_name: 'Ali',
      employee_id: 'EMP-2025-102',
      department: 'HR',
      department_head: 'Mohammed Al-Rashid',
      email: 'fatima.ali@company.ae',
      date_of_joining: '2025-10-20',
      status: 'pending',
      created_at: '2025-10-08',
      systems_count: 3,
      assets_count: 1
    }
  ]);

  const [showModal, setShowModal] = useState(false);
  const [selectedRequest, setSelectedRequest] = useState<SystemAccessRequest | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [activeTab, setActiveTab] = useState<'all' | 'pending' | 'in_progress' | 'completed'>('all');

  // Form state for new request
  const [formData, setFormData] = useState({
    employee_first_name: '',
    employee_last_name: '',
    employee_id: '',
    department: '',
    department_head: '',
    email: '',
    date_of_joining: new Date().toISOString().split('T')[0],
    // Network Access
    network_access: false,
    network_login: '',
    // Email Access
    email_access: false,
    email_type: 'generic',
    email_address: '',
    // Oracle Fusion ERP - HR Module
    oracle_hr: false,
    hr_group_1_dhr: false,
    hr_group_2_vary: false,
    hr_group_3_executive: false,
    hr_group_4_hana: false,
    hr_group_5_pr: false,
    hr_group_6_hrm: false,
    hr_ess_user: false,
    // Oracle Fusion ERP - Finance Module
    oracle_finance: false,
    finance_ap: false,
    finance_ar: false,
    finance_manager: false,
    finance_din: false,
    // Oracle Fusion ERP - Department
    oracle_dept: false,
    dept_head_pcu: false,
    dept_manager: false,
    dept_buyer: false,
    dept_coordinator: false,
    dept_store: false,
    dept_receiver: false,
    dept_request_user: false,
    // Time & Attendance
    time_attendance: false,
    it_admin_access: false,
    hr_access: false,
    // IT Assets
    laptop: false,
    desktop: false,
    mobile: false,
    non_camera_mobile: false,
    walkie_talkie: false,
    duty_sim_card: false
  });

  const handleOpenModal = (request?: SystemAccessRequest) => {
    if (request) {
      setSelectedRequest(request);
    } else {
      setSelectedRequest(null);
      setFormData({
        employee_first_name: '',
        employee_last_name: '',
        employee_id: '',
        department: '',
        department_head: '',
        email: '',
        date_of_joining: new Date().toISOString().split('T')[0],
        network_access: false,
        network_login: '',
        email_access: false,
        email_type: 'generic',
        email_address: '',
        oracle_hr: false,
        hr_group_1_dhr: false,
        hr_group_2_vary: false,
        hr_group_3_executive: false,
        hr_group_4_hana: false,
        hr_group_5_pr: false,
        hr_group_6_hrm: false,
        hr_ess_user: false,
        oracle_finance: false,
        finance_ap: false,
        finance_ar: false,
        finance_manager: false,
        finance_din: false,
        oracle_dept: false,
        dept_head_pcu: false,
        dept_manager: false,
        dept_buyer: false,
        dept_coordinator: false,
        dept_store: false,
        dept_receiver: false,
        dept_request_user: false,
        time_attendance: false,
        it_admin_access: false,
        hr_access: false,
        laptop: false,
        desktop: false,
        mobile: false,
        non_camera_mobile: false,
        walkie_talkie: false,
        duty_sim_card: false
      });
    }
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedRequest(null);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Handle form submission
    console.log('Form submitted:', formData);
    handleCloseModal();
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed':
        return 'bg-green-100 text-green-800';
      case 'in_progress':
        return 'bg-blue-100 text-blue-800';
      case 'pending':
        return 'bg-yellow-100 text-yellow-800';
      case 'cancelled':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed':
        return <CheckCircle className="h-4 w-4" />;
      case 'in_progress':
        return <Clock className="h-4 w-4" />;
      case 'pending':
        return <Clock className="h-4 w-4" />;
      case 'cancelled':
        return <XCircle className="h-4 w-4" />;
      default:
        return <Clock className="h-4 w-4" />;
    }
  };

  const filteredRequests = requests.filter(request => {
    const matchesSearch = 
      request.employee_first_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      request.employee_last_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      request.employee_id.toLowerCase().includes(searchTerm.toLowerCase()) ||
      request.request_number.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesTab = activeTab === 'all' || request.status === activeTab;
    
    return matchesSearch && matchesTab;
  });

  const stats = {
    total: requests.length,
    pending: requests.filter(r => r.status === 'pending').length,
    in_progress: requests.filter(r => r.status === 'in_progress').length,
    completed: requests.filter(r => r.status === 'completed').length
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
            onClick={() => handleOpenModal()}
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
                In Progress
              </p>
              <p className="text-3xl font-bold text-blue-600">{stats.in_progress}</p>
            </div>
            <div className="bg-blue-100 rounded-2xl p-3">
              <Clock className="text-blue-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Completed
              </p>
              <p className="text-3xl font-bold text-green-600">{stats.completed}</p>
            </div>
            <div className="bg-green-100 rounded-2xl p-3">
              <CheckCircle className="text-green-600 h-7 w-7" />
            </div>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-2 mb-6 shadow-sm">
        <div className="flex gap-2">
          {(['all', 'pending', 'in_progress', 'completed'] as const).map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`flex-1 px-6 py-3 rounded-2xl font-semibold text-sm transition-all duration-200 ${
                activeTab === tab
                  ? 'bg-primary-500 text-white shadow-md'
                  : 'text-gray-600 hover:bg-gray-100'
              }`}
            >
              {tab === 'in_progress' ? 'In Progress' : tab.charAt(0).toUpperCase() + tab.slice(1)}
            </button>
          ))}
        </div>
      </div>

      {/* Search Bar */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-4 mb-6 shadow-sm">
        <div className="flex items-center gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
            <input
              type="text"
              placeholder="Search by name, employee ID, or request number..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>
        </div>
      </div>

      {/* Requests Table */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50/50">
              <tr>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Request #
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Employee Details
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Department
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Joining Date
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Systems
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Assets
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredRequests.map((request) => (
                <tr key={request.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm font-medium text-gray-900">{request.request_number}</div>
                    <div className="text-xs text-gray-500">{new Date(request.created_at).toLocaleDateString()}</div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm font-medium text-gray-900">
                      {request.employee_first_name} {request.employee_last_name}
                    </div>
                    <div className="text-xs text-gray-500">{request.employee_id}</div>
                    <div className="text-xs text-gray-500">{request.email}</div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm text-gray-900">{request.department}</div>
                    <div className="text-xs text-gray-500">{request.department_head}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900">
                      {new Date(request.date_of_joining).toLocaleDateString()}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                      {request.systems_count} systems
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                      {request.assets_count} assets
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ${getStatusColor(request.status)}`}>
                      {getStatusIcon(request.status)}
                      {request.status.replace('_', ' ')}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <button
                      onClick={() => handleOpenModal(request)}
                      className="text-primary-600 hover:text-primary-900 mr-3"
                    >
                      <Eye className="h-5 w-5" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal for New/View Request */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl shadow-xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 px-8 py-6 rounded-t-3xl z-10">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-gray-900">
                  {selectedRequest ? 'View Access Request' : 'New System Access Request'}
                </h2>
                <button
                  onClick={handleCloseModal}
                  className="text-gray-400 hover:text-gray-600 transition-colors"
                >
                  <XCircle className="h-6 w-6" />
                </button>
              </div>
            </div>

            <form onSubmit={handleSubmit} className="p-8">
              {/* Employee Information */}
              <div className="mb-8">
                <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                  <UserPlus className="h-5 w-5 text-primary-500" />
                  Employee Information
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
                      onChange={(e) => setFormData({ ...formData, employee_first_name: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
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
                      onChange={(e) => setFormData({ ...formData, employee_last_name: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
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
                      onChange={(e) => setFormData({ ...formData, employee_id: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Email *
                    </label>
                    <input
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      placeholder="f.name@company.ae"
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Department *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.department}
                      onChange={(e) => setFormData({ ...formData, department: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Department Head
                    </label>
                    <input
                      type="text"
                      value={formData.department_head}
                      onChange={(e) => setFormData({ ...formData, department_head: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div className="md:col-span-2">
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Date of Joining *
                    </label>
                    <input
                      type="date"
                      required
                      value={formData.date_of_joining}
                      onChange={(e) => setFormData({ ...formData, date_of_joining: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                </div>
              </div>

              {/* System Access Section */}
              <div className="mb-8">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">System Access</h3>
                
                {/* Network Access */}
                <div className="mb-6 p-4 bg-gray-50 rounded-xl">
                  <label className="flex items-center gap-2 mb-3">
                    <input
                      type="checkbox"
                      checked={formData.network_access}
                      onChange={(e) => setFormData({ ...formData, network_access: e.target.checked })}
                      className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                    />
                    <span className="text-sm font-semibold text-gray-900">Network Access (Login/Windows/Open)</span>
                  </label>
                  {formData.network_access && (
                    <input
                      type="text"
                      placeholder="Username"
                      value={formData.network_login}
                      onChange={(e) => setFormData({ ...formData, network_login: e.target.value })}
                      className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500"
                    />
                  )}
                </div>

                {/* Email Access */}
                <div className="mb-6 p-4 bg-gray-50 rounded-xl">
                  <label className="flex items-center gap-2 mb-3">
                    <input
                      type="checkbox"
                      checked={formData.email_access}
                      onChange={(e) => setFormData({ ...formData, email_access: e.target.checked })}
                      className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                    />
                    <span className="text-sm font-semibold text-gray-900">Email Access</span>
                  </label>
                  {formData.email_access && (
                    <div className="space-y-2">
                      <select
                        value={formData.email_type}
                        onChange={(e) => setFormData({ ...formData, email_type: e.target.value })}
                        className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500"
                      >
                        <option value="generic">Generic Email</option>
                        <option value="general">General Email</option>
                      </select>
                      <input
                        type="email"
                        placeholder="Email address or enter ID &amp; name"
                        value={formData.email_address}
                        onChange={(e) => setFormData({ ...formData, email_address: e.target.value })}
                        className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500"
                      />
                    </div>
                  )}
                </div>

                {/* Oracle Fusion ERP */}
                <div className="mb-6 p-4 bg-gradient-to-r from-red-50 to-orange-50 rounded-xl border border-red-200">
                  <h4 className="text-md font-semibold text-gray-900 mb-4">Oracle Fusion ERP Access</h4>
                  
                  {/* HR Module */}
                  <div className="mb-4">
                    <label className="flex items-center gap-2 mb-2">
                      <input
                        type="checkbox"
                        checked={formData.oracle_hr}
                        onChange={(e) => setFormData({ ...formData, oracle_hr: e.target.checked })}
                        className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                      />
                      <span className="text-sm font-semibold text-gray-900">HR Module</span>
                    </label>
                    {formData.oracle_hr && (
                      <div className="ml-6 grid grid-cols-2 gap-2">
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_group_1_dhr} onChange={(e) => setFormData({ ...formData, hr_group_1_dhr: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 1 - DHR</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_group_2_vary} onChange={(e) => setFormData({ ...formData, hr_group_2_vary: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 2 - Vary</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_group_3_executive} onChange={(e) => setFormData({ ...formData, hr_group_3_executive: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 3 - Executive</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_group_4_hana} onChange={(e) => setFormData({ ...formData, hr_group_4_hana: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 4 - Hana Deletion</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_group_5_pr} onChange={(e) => setFormData({ ...formData, hr_group_5_pr: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 5 - PR</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_group_6_hrm} onChange={(e) => setFormData({ ...formData, hr_group_6_hrm: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 6 - HRM</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.hr_ess_user} onChange={(e) => setFormData({ ...formData, hr_ess_user: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">ESS User</span>
                        </label>
                      </div>
                    )}
                  </div>

                  {/* Finance Module */}
                  <div className="mb-4">
                    <label className="flex items-center gap-2 mb-2">
                      <input
                        type="checkbox"
                        checked={formData.oracle_finance}
                        onChange={(e) => setFormData({ ...formData, oracle_finance: e.target.checked })}
                        className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                      />
                      <span className="text-sm font-semibold text-gray-900">Finance Module</span>
                    </label>
                    {formData.oracle_finance && (
                      <div className="ml-6 grid grid-cols-2 gap-2">
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.finance_ap} onChange={(e) => setFormData({ ...formData, finance_ap: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">AP (Accounts Payable)</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.finance_ar} onChange={(e) => setFormData({ ...formData, finance_ar: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">AR (Accounts Receivable)</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.finance_manager} onChange={(e) => setFormData({ ...formData, finance_manager: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Finance Manager</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.finance_din} onChange={(e) => setFormData({ ...formData, finance_din: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">DIN Finance</span>
                        </label>
                      </div>
                    )}
                  </div>

                  {/* Department Access */}
                  <div>
                    <label className="flex items-center gap-2 mb-2">
                      <input
                        type="checkbox"
                        checked={formData.oracle_dept}
                        onChange={(e) => setFormData({ ...formData, oracle_dept: e.target.checked })}
                        className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                      />
                      <span className="text-sm font-semibold text-gray-900">Department Access</span>
                    </label>
                    {formData.oracle_dept && (
                      <div className="ml-6 grid grid-cols-2 gap-2">
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_head_pcu} onChange={(e) => setFormData({ ...formData, dept_head_pcu: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 1 - Head PCU</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_manager} onChange={(e) => setFormData({ ...formData, dept_manager: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 2 - Manager</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_buyer} onChange={(e) => setFormData({ ...formData, dept_buyer: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 3 - Buyer</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_coordinator} onChange={(e) => setFormData({ ...formData, dept_coordinator: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Group 4 - Coordinator</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_store} onChange={(e) => setFormData({ ...formData, dept_store: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Store</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_receiver} onChange={(e) => setFormData({ ...formData, dept_receiver: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Receiver</span>
                        </label>
                        <label className="flex items-center gap-2">
                          <input type="checkbox" checked={formData.dept_request_user} onChange={(e) => setFormData({ ...formData, dept_request_user: e.target.checked })} className="w-4 h-4" />
                          <span className="text-sm">Request User</span>
                        </label>
                      </div>
                    )}
                  </div>
                </div>

                {/* Time & Attendance */}
                <div className="mb-6 p-4 bg-blue-50 rounded-xl border border-blue-200">
                  <label className="flex items-center gap-2 mb-3">
                    <input
                      type="checkbox"
                      checked={formData.time_attendance}
                      onChange={(e) => setFormData({ ...formData, time_attendance: e.target.checked })}
                      className="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                    />
                    <span className="text-sm font-semibold text-gray-900">Time & Attendance</span>
                  </label>
                  {formData.time_attendance && (
                    <div className="ml-6 space-y-2">
                      <label className="flex items-center gap-2">
                        <input type="checkbox" checked={formData.it_admin_access} onChange={(e) => setFormData({ ...formData, it_admin_access: e.target.checked })} className="w-4 h-4" />
                        <span className="text-sm">IT Admin Access</span>
                      </label>
                      <label className="flex items-center gap-2">
                        <input type="checkbox" checked={formData.hr_access} onChange={(e) => setFormData({ ...formData, hr_access: e.target.checked })} className="w-4 h-4" />
                        <span className="text-sm">HR Access</span>
                      </label>
                    </div>
                  )}
                </div>
              </div>

              {/* IT Assets Section */}
              <div className="mb-8">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">IT Assets to be Handed Over</h3>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-4 p-4 bg-purple-50 rounded-xl border border-purple-200">
                  <label className="flex items-center gap-2">
                    <input type="checkbox" checked={formData.laptop} onChange={(e) => setFormData({ ...formData, laptop: e.target.checked })} className="w-4 h-4" />
                    <span className="text-sm">Laptop</span>
                  </label>
                  <label className="flex items-center gap-2">
                    <input type="checkbox" checked={formData.desktop} onChange={(e) => setFormData({ ...formData, desktop: e.target.checked })} className="w-4 h-4" />
                    <span className="text-sm">Desktop</span>
                  </label>
                  <label className="flex items-center gap-2">
                    <input type="checkbox" checked={formData.mobile} onChange={(e) => setFormData({ ...formData, mobile: e.target.checked })} className="w-4 h-4" />
                    <span className="text-sm">Mobile</span>
                  </label>
                  <label className="flex items-center gap-2">
                    <input type="checkbox" checked={formData.non_camera_mobile} onChange={(e) => setFormData({ ...formData, non_camera_mobile: e.target.checked })} className="w-4 h-4" />
                    <span className="text-sm">Non-Camera Mobile</span>
                  </label>
                  <label className="flex items-center gap-2">
                    <input type="checkbox" checked={formData.walkie_talkie} onChange={(e) => setFormData({ ...formData, walkie_talkie: e.target.checked })} className="w-4 h-4" />
                    <span className="text-sm">Walkie Talkie</span>
                  </label>
                  <label className="flex items-center gap-2">
                    <input type="checkbox" checked={formData.duty_sim_card} onChange={(e) => setFormData({ ...formData, duty_sim_card: e.target.checked })} className="w-4 h-4" />
                    <span className="text-sm">Duty SIM Card</span>
                  </label>
                </div>
              </div>

              {/* Form Actions */}
              <div className="flex justify-end gap-4 pt-6 border-t border-gray-200">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="px-6 py-3 border border-gray-300 text-gray-700 rounded-2xl font-semibold hover:bg-gray-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-colors shadow-md hover:shadow-lg"
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

export default SystemAccess;
