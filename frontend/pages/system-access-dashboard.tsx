import { useState, useEffect } from 'react';
import { createClient } from '@supabase/supabase-js';
import Layout from '../components/Layout';
import { 
  Plus, Search, Filter, Download, Users, Key, 
  AlertCircle, CheckCircle, Clock, XCircle 
} from 'lucide-react';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

export default function SystemAccess() {
  const [systems, setSystems] = useState([]);
  const [filteredSystems, setFilteredSystems] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [loading, setLoading] = useState(true);
  const [showRequestModal, setShowRequestModal] = useState(false);
  const [selectedSystem, setSelectedSystem] = useState(null);
  const [stats, setStats] = useState({
    total_systems: 0,
    total_active_users: 0,
    pending_requests: 0,
    expiring_soon: 0
  });

  useEffect(() => {
    fetchData();
  }, []);

  useEffect(() => {
    filterSystems();
  }, [searchTerm, categoryFilter, systems]);

  const fetchData = async () => {
    try {
      setLoading(true);
      
      // Fetch systems
      const { data: systemsData, error: systemsError } = await supabase
        .from('systems')
        .select('*')
        .eq('status', 'active')
        .order('name');

      if (systemsError) throw systemsError;

      // Fetch stats for each system
      const systemsWithStats = await Promise.all(
        (systemsData || []).map(async (system) => {
          const { count: activeUsers } = await supabase
            .from('user_access')
            .select('*', { count: 'exact', head: true })
            .eq('system_id', system.id)
            .eq('status', 'active');

          return {
            ...system,
            active_users: activeUsers || 0,
            usage_percentage: system.total_licenses > 0 
              ? ((system.total_licenses - system.available_licenses) / system.total_licenses * 100).toFixed(1)
              : 0
          };
        })
      );

      setSystems(systemsWithStats);
      setFilteredSystems(systemsWithStats);

      // Fetch dashboard stats
      const { data: statsData } = await supabase.rpc('get_system_access_stats');
      if (statsData) setStats(statsData);

    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const filterSystems = () => {
    let filtered = systems;

    // Search filter
    if (searchTerm) {
      filtered = filtered.filter(system =>
        system.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        system.vendor?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        system.category?.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }

    // Category filter
    if (categoryFilter !== 'all') {
      filtered = filtered.filter(system => system.category === categoryFilter);
    }

    setFilteredSystems(filtered);
  };

  const handleRequestAccess = (system) => {
    setSelectedSystem(system);
    setShowRequestModal(true);
  };

  const categories = Array.from(new Set(systems.map(s => s.category).filter(Boolean)));

  return (
    <Layout>
      <div className="p-6">
        {/* Header */}
        <div className="mb-6">
          <h1 className="text-3xl font-bold text-gray-900">System Access Management</h1>
          <p className="text-gray-600 mt-2">
            Manage software systems, licenses, and user access
          </p>
        </div>

        {/* Statistics Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
          <StatCard
            title="Total Systems"
            value={stats.total_systems}
            icon={<Key className="w-6 h-6 text-blue-600" />}
            color="bg-blue-50"
          />
          <StatCard
            title="Active Users"
            value={stats.total_active_users}
            icon={<Users className="w-6 h-6 text-green-600" />}
            color="bg-green-50"
          />
          <StatCard
            title="Pending Requests"
            value={stats.pending_requests}
            icon={<Clock className="w-6 h-6 text-yellow-600" />}
            color="bg-yellow-50"
          />
          <StatCard
            title="Expiring Soon"
            value={stats.expiring_soon}
            icon={<AlertCircle className="w-6 h-6 text-red-600" />}
            color="bg-red-50"
          />
        </div>

        {/* Search and Filters */}
        <div className="bg-white rounded-lg shadow-sm p-4 mb-6">
          <div className="flex flex-col md:flex-row gap-4">
            {/* Search */}
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  type="text"
                  placeholder="Search systems, vendors, categories..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            {/* Category Filter */}
            <select
              value={categoryFilter}
              onChange={(e) => setCategoryFilter(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="all">All Categories</option>
              {categories.map(category => (
                <option key={category} value={category}>{category}</option>
              ))}
            </select>

            {/* Actions */}
            <button
              className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center gap-2"
              onClick={() => window.location.href = '/system-access/requests'}
            >
              <Clock className="w-5 h-5" />
              My Requests
            </button>
          </div>
        </div>

        {/* Systems Grid */}
        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
            <p className="text-gray-600 mt-4">Loading systems...</p>
          </div>
        ) : filteredSystems.length === 0 ? (
          <div className="bg-white rounded-lg shadow-sm p-12 text-center">
            <Key className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600 text-lg">No systems found</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredSystems.map(system => (
              <SystemCard
                key={system.id}
                system={system}
                onRequestAccess={handleRequestAccess}
              />
            ))}
          </div>
        )}

        {/* Request Access Modal */}
        {showRequestModal && (
          <RequestAccessModal
            system={selectedSystem}
            onClose={() => {
              setShowRequestModal(false);
              setSelectedSystem(null);
            }}
            onSuccess={() => {
              setShowRequestModal(false);
              setSelectedSystem(null);
              fetchData();
            }}
          />
        )}
      </div>
    </Layout>
  );
}

// Statistics Card Component
function StatCard({ title, value, icon, color }) {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-600 text-sm">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        </div>
        <div className={`${color} p-3 rounded-lg`}>
          {icon}
        </div>
      </div>
    </div>
  );
}

// System Card Component
function SystemCard({ system, onRequestAccess }) {
  const getLicenseStatusColor = () => {
    const percentage = parseFloat(system.usage_percentage);
    if (percentage >= 90) return 'text-red-600 bg-red-50';
    if (percentage >= 75) return 'text-yellow-600 bg-yellow-50';
    return 'text-green-600 bg-green-50';
  };

  const getRenewalStatus = () => {
    if (!system.renewal_date) return null;
    
    const daysUntilRenewal = Math.ceil(
      (new Date(system.renewal_date).getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24)
    );

    if (daysUntilRenewal < 0) return { text: 'Expired', color: 'text-red-600 bg-red-50' };
    if (daysUntilRenewal <= 30) return { text: `${daysUntilRenewal} days`, color: 'text-red-600 bg-red-50' };
    if (daysUntilRenewal <= 60) return { text: `${daysUntilRenewal} days`, color: 'text-yellow-600 bg-yellow-50' };
    return { text: `${daysUntilRenewal} days`, color: 'text-green-600 bg-green-50' };
  };

  const renewalStatus = getRenewalStatus();

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition overflow-hidden">
      {/* Header */}
      <div className="p-6 border-b border-gray-200">
        <div className="flex items-start justify-between mb-3">
          <div>
            <h3 className="text-lg font-semibold text-gray-900">{system.name}</h3>
            <p className="text-sm text-gray-600 mt-1">{system.vendor}</p>
          </div>
          <span className="px-3 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full">
            {system.category}
          </span>
        </div>
        {system.description && (
          <p className="text-sm text-gray-600 line-clamp-2">{system.description}</p>
        )}
      </div>

      {/* Stats */}
      <div className="p-6 space-y-4">
        {/* License Usage */}
        <div>
          <div className="flex justify-between items-center mb-2">
            <span className="text-sm text-gray-600">License Usage</span>
            <span className={`text-sm font-medium px-2 py-1 rounded ${getLicenseStatusColor()}`}>
              {system.usage_percentage}%
            </span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className={`h-2 rounded-full transition-all ${
                system.usage_percentage >= 90 ? 'bg-red-500' :
                system.usage_percentage >= 75 ? 'bg-yellow-500' : 'bg-green-500'
              }`}
              style={{ width: `${Math.min(system.usage_percentage, 100)}%` }}
            />
          </div>
          <p className="text-xs text-gray-500 mt-1">
            {system.total_licenses - system.available_licenses} of {system.total_licenses} licenses used
          </p>
        </div>

        {/* Active Users */}
        <div className="flex items-center justify-between">
          <span className="text-sm text-gray-600 flex items-center gap-2">
            <Users className="w-4 h-4" />
            Active Users
          </span>
          <span className="text-sm font-medium text-gray-900">{system.active_users}</span>
        </div>

        {/* Renewal Date */}
        {renewalStatus && (
          <div className="flex items-center justify-between">
            <span className="text-sm text-gray-600 flex items-center gap-2">
              <AlertCircle className="w-4 h-4" />
              Renewal
            </span>
            <span className={`text-xs font-medium px-2 py-1 rounded ${renewalStatus.color}`}>
              {renewalStatus.text}
            </span>
          </div>
        )}

        {/* License Type */}
        <div className="flex items-center justify-between pt-2 border-t border-gray-100">
          <span className="text-xs text-gray-500">License Type</span>
          <span className="text-xs font-medium text-gray-700">{system.license_type}</span>
        </div>
      </div>

      {/* Actions */}
      <div className="p-4 bg-gray-50 border-t border-gray-200">
        <button
          onClick={() => onRequestAccess(system)}
          disabled={system.available_licenses <= 0}
          className={`w-full py-2 px-4 rounded-lg font-medium transition flex items-center justify-center gap-2 ${
            system.available_licenses <= 0
              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : 'bg-blue-600 text-white hover:bg-blue-700'
          }`}
        >
          <Plus className="w-4 h-4" />
          {system.available_licenses <= 0 ? 'No Licenses Available' : 'Request Access'}
        </button>
      </div>
    </div>
  );
}

// Request Access Modal Component
function RequestAccessModal({ system, onClose, onSuccess }) {
  const [formData, setFormData] = useState({
    access_level: 'Read',
    justification: '',
    urgency: 'normal',
    required_by_date: ''
  });
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);
    setError('');

    try {
      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        throw new Error('You must be logged in to request access');
      }

      // Get user details
      const { data: userData } = await supabase
        .from('users')
        .select('name, email, department')
        .eq('id', user.id)
        .single();

      // Create access request
      const { error: insertError } = await supabase
        .from('access_requests')
        .insert([{
          system_id: system.id,
          requester_id: user.id,
          requester_name: userData?.name || user.email,
          requester_email: userData?.email || user.email,
          requester_department: userData?.department || 'Not specified',
          request_type: 'new_access',
          ...formData
        }]);

      if (insertError) throw insertError;

      alert('Access request submitted successfully!');
      onSuccess();
    } catch (err) {
      console.error('Error submitting request:', err);
      setError(err.message);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="p-6 border-b border-gray-200">
          <h2 className="text-2xl font-bold text-gray-900">Request System Access</h2>
          <p className="text-gray-600 mt-2">System: <span className="font-semibold">{system.name}</span></p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-6">
          {error && (
            <div className="p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3">
              <XCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <p className="text-red-700 text-sm">{error}</p>
            </div>
          )}

          {/* Access Level */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Access Level *
            </label>
            <select
              value={formData.access_level}
              onChange={(e) => setFormData({ ...formData, access_level: e.target.value })}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="Read">Read Only</option>
              <option value="Write">Read/Write</option>
              <option value="Admin">Administrator</option>
            </select>
          </div>

          {/* Justification */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Justification *
            </label>
            <textarea
              value={formData.justification}
              onChange={(e) => setFormData({ ...formData, justification: e.target.value })}
              required
              rows={4}
              placeholder="Explain why you need access to this system..."
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          {/* Urgency */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Urgency
            </label>
            <select
              value={formData.urgency}
              onChange={(e) => setFormData({ ...formData, urgency: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="low">Low</option>
              <option value="normal">Normal</option>
              <option value="high">High</option>
              <option value="urgent">Urgent</option>
            </select>
          </div>

          {/* Required By Date */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Required By Date
            </label>
            <input
              type="date"
              value={formData.required_by_date}
              onChange={(e) => setFormData({ ...formData, required_by_date: e.target.value })}
              min={new Date().toISOString().split('T')[0]}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          {/* Actions */}
          <div className="flex gap-4 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={submitting}
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition disabled:bg-gray-400"
            >
              {submitting ? 'Submitting...' : 'Submit Request'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
