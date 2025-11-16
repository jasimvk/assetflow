import { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { getSupabaseClient } from '../utils/supabase';
import { Plus, Edit, Trash2, Save, X, Building2, Tag, MapPin, Users, Settings, AlertCircle } from 'lucide-react';

const supabase = getSupabaseClient();

interface Department {
  id: string;
  name: string;
  description: string;
  department_head?: string;
  location?: string;
  is_active: boolean;
  created_at: string;
}

interface Category {
  id: string;
  name: string;
  description: string;
  created_at: string;
}

interface Location {
  id: string;
  name: string;
  address?: string;
  building?: string;
  floor?: string;
  room?: string;
  created_at: string;
}

type TabType = 'departments' | 'categories' | 'locations';

const MasterData = () => {
  const [activeTab, setActiveTab] = useState<TabType>('departments');
  const [loading, setLoading] = useState(false);
  
  // Departments State
  const [departments, setDepartments] = useState<Department[]>([]);
  const [showDeptModal, setShowDeptModal] = useState(false);
  const [editingDept, setEditingDept] = useState<Department | null>(null);
  const [deptForm, setDeptForm] = useState({
    name: '',
    description: '',
    department_head: '',
    location: '',
    is_active: true
  });

  // Categories State
  const [categories, setCategories] = useState<Category[]>([]);
  const [showCatModal, setShowCatModal] = useState(false);
  const [editingCat, setEditingCat] = useState<Category | null>(null);
  const [catForm, setCatForm] = useState({
    name: '',
    description: ''
  });

  // Locations State
  const [locations, setLocations] = useState<Location[]>([]);
  const [showLocModal, setShowLocModal] = useState(false);
  const [editingLoc, setEditingLoc] = useState<Location | null>(null);
  const [locForm, setLocForm] = useState({
    name: '',
    address: '',
    building: '',
    floor: '',
    room: ''
  });

  // Load data based on active tab
  useEffect(() => {
    if (activeTab === 'departments') loadDepartments();
    else if (activeTab === 'categories') loadCategories();
    else if (activeTab === 'locations') loadLocations();
  }, [activeTab]);

  // ==================== DEPARTMENTS ====================
  const loadDepartments = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('departments')
        .select('*')
        .order('name');
      
      if (error) throw error;
      setDepartments(data || []);
    } catch (error: any) {
      console.error('Error loading departments:', error);
      alert('Failed to load departments: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDeptSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      if (editingDept) {
        const { error } = await supabase
          .from('departments')
          .update(deptForm)
          .eq('id', editingDept.id);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('departments')
          .insert([deptForm]);
        if (error) throw error;
      }
      setShowDeptModal(false);
      setEditingDept(null);
      setDeptForm({ name: '', description: '', department_head: '', location: '', is_active: true });
      loadDepartments();
    } catch (error: any) {
      alert('Failed to save department: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDeptDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this department?')) return;
    try {
      const { error } = await supabase
        .from('departments')
        .delete()
        .eq('id', id);
      if (error) throw error;
      loadDepartments();
    } catch (error: any) {
      alert('Failed to delete department: ' + error.message);
    }
  };

  // ==================== CATEGORIES ====================
  const loadCategories = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('name');
      
      if (error) throw error;
      setCategories(data || []);
    } catch (error: any) {
      console.error('Error loading categories:', error);
      alert('Failed to load categories: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCatSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      if (editingCat) {
        const { error } = await supabase
          .from('categories')
          .update(catForm)
          .eq('id', editingCat.id);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('categories')
          .insert([catForm]);
        if (error) throw error;
      }
      setShowCatModal(false);
      setEditingCat(null);
      setCatForm({ name: '', description: '' });
      loadCategories();
    } catch (error: any) {
      alert('Failed to save category: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCatDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this category?')) return;
    try {
      const { error } = await supabase
        .from('categories')
        .delete()
        .eq('id', id);
      if (error) throw error;
      loadCategories();
    } catch (error: any) {
      alert('Failed to delete category: ' + error.message);
    }
  };

  // ==================== LOCATIONS ====================
  const loadLocations = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('locations')
        .select('*')
        .order('name');
      
      if (error) throw error;
      setLocations(data || []);
    } catch (error: any) {
      console.error('Error loading locations:', error);
      alert('Failed to load locations: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleLocSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      if (editingLoc) {
        const { error } = await supabase
          .from('locations')
          .update(locForm)
          .eq('id', editingLoc.id);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('locations')
          .insert([locForm]);
        if (error) throw error;
      }
      setShowLocModal(false);
      setEditingLoc(null);
      setLocForm({ name: '', address: '', building: '', floor: '', room: '' });
      loadLocations();
    } catch (error: any) {
      alert('Failed to save location: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleLocDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this location?')) return;
    try {
      const { error } = await supabase
        .from('locations')
        .delete()
        .eq('id', id);
      if (error) throw error;
      loadLocations();
    } catch (error: any) {
      alert('Failed to delete location: ' + error.message);
    }
  };

  return (
    <Layout title="Master Data">
      {/* Page Header */}
      <div className="mb-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
              Master Data Management
            </h1>
            <p className="text-sm text-gray-600">Manage departments, categories, and locations</p>
          </div>
          <div className="flex items-center gap-2">
            <Settings className="h-6 w-6 text-gray-400" />
          </div>
        </div>
      </div>

      {/* Info Banner */}
      <div className="bg-blue-50 border border-blue-200 rounded-2xl p-4 mb-6">
        <div className="flex items-start gap-3">
          <AlertCircle className="h-5 w-5 text-blue-600 mt-0.5" />
          <div>
            <h3 className="text-sm font-bold text-blue-900 mb-1">Master Data Configuration</h3>
            <p className="text-xs text-blue-700">
              Configure reference data used throughout the system. Changes here will affect asset assignments, filters, and reports.
            </p>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-sm mb-6">
        <div className="flex border-b border-gray-200">
          <button
            onClick={() => setActiveTab('departments')}
            className={`flex items-center gap-2 px-6 py-4 text-sm font-semibold transition-colors ${
              activeTab === 'departments'
                ? 'bg-primary-50 text-primary-700 border-b-2 border-primary-500'
                : 'text-gray-600 hover:bg-gray-50'
            }`}
          >
            <Users className="h-5 w-5" />
            Departments
            <span className="ml-2 px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full text-xs">
              {departments.length}
            </span>
          </button>
          <button
            onClick={() => setActiveTab('categories')}
            className={`flex items-center gap-2 px-6 py-4 text-sm font-semibold transition-colors ${
              activeTab === 'categories'
                ? 'bg-primary-50 text-primary-700 border-b-2 border-primary-500'
                : 'text-gray-600 hover:bg-gray-50'
            }`}
          >
            <Tag className="h-5 w-5" />
            Categories
            <span className="ml-2 px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full text-xs">
              {categories.length}
            </span>
          </button>
          <button
            onClick={() => setActiveTab('locations')}
            className={`flex items-center gap-2 px-6 py-4 text-sm font-semibold transition-colors ${
              activeTab === 'locations'
                ? 'bg-primary-50 text-primary-700 border-b-2 border-primary-500'
                : 'text-gray-600 hover:bg-gray-50'
            }`}
          >
            <MapPin className="h-5 w-5" />
            Locations
            <span className="ml-2 px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full text-xs">
              {locations.length}
            </span>
          </button>
        </div>

        {/* Tab Content */}
        <div className="p-6">
          {/* Departments Tab */}
          {activeTab === 'departments' && (
            <div>
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-xl font-bold text-gray-900">Departments</h2>
                <button
                  onClick={() => {
                    setEditingDept(null);
                    setDeptForm({ name: '', description: '', department_head: '', location: '', is_active: true });
                    setShowDeptModal(true);
                  }}
                  className="flex items-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
                >
                  <Plus className="h-4 w-4" />
                  Add Department
                </button>
              </div>

              {loading ? (
                <div className="text-center py-12 text-gray-500">Loading...</div>
              ) : departments.length === 0 ? (
                <div className="text-center py-12">
                  <Users className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500">No departments found. Add your first department.</p>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {departments.map((dept) => (
                    <div key={dept.id} className="border border-gray-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                      <div className="flex justify-between items-start mb-2">
                        <div>
                          <h3 className="font-bold text-gray-900">{dept.name}</h3>
                          {dept.is_active ? (
                            <span className="text-xs text-green-600 bg-green-50 px-2 py-0.5 rounded-full">Active</span>
                          ) : (
                            <span className="text-xs text-gray-600 bg-gray-100 px-2 py-0.5 rounded-full">Inactive</span>
                          )}
                        </div>
                        <div className="flex gap-1">
                          <button
                            onClick={() => {
                              setEditingDept(dept);
                              setDeptForm({
                                name: dept.name,
                                description: dept.description || '',
                                department_head: dept.department_head || '',
                                location: dept.location || '',
                                is_active: dept.is_active
                              });
                              setShowDeptModal(true);
                            }}
                            className="p-1.5 hover:bg-blue-50 rounded-lg transition-colors"
                          >
                            <Edit className="h-4 w-4 text-blue-600" />
                          </button>
                          <button
                            onClick={() => handleDeptDelete(dept.id)}
                            className="p-1.5 hover:bg-red-50 rounded-lg transition-colors"
                          >
                            <Trash2 className="h-4 w-4 text-red-600" />
                          </button>
                        </div>
                      </div>
                      <p className="text-sm text-gray-600 mb-2">{dept.description}</p>
                      {dept.department_head && (
                        <p className="text-xs text-gray-500">Head: {dept.department_head}</p>
                      )}
                      {dept.location && (
                        <p className="text-xs text-gray-500">Location: {dept.location}</p>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Categories Tab */}
          {activeTab === 'categories' && (
            <div>
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-xl font-bold text-gray-900">Asset Categories</h2>
                <button
                  onClick={() => {
                    setEditingCat(null);
                    setCatForm({ name: '', description: '' });
                    setShowCatModal(true);
                  }}
                  className="flex items-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
                >
                  <Plus className="h-4 w-4" />
                  Add Category
                </button>
              </div>

              {loading ? (
                <div className="text-center py-12 text-gray-500">Loading...</div>
              ) : categories.length === 0 ? (
                <div className="text-center py-12">
                  <Tag className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500">No categories found. Add your first category.</p>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                  {categories.map((cat) => (
                    <div key={cat.id} className="border border-gray-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                      <div className="flex justify-between items-start mb-2">
                        <h3 className="font-bold text-gray-900">{cat.name}</h3>
                        <div className="flex gap-1">
                          <button
                            onClick={() => {
                              setEditingCat(cat);
                              setCatForm({
                                name: cat.name,
                                description: cat.description || ''
                              });
                              setShowCatModal(true);
                            }}
                            className="p-1.5 hover:bg-blue-50 rounded-lg transition-colors"
                          >
                            <Edit className="h-4 w-4 text-blue-600" />
                          </button>
                          <button
                            onClick={() => handleCatDelete(cat.id)}
                            className="p-1.5 hover:bg-red-50 rounded-lg transition-colors"
                          >
                            <Trash2 className="h-4 w-4 text-red-600" />
                          </button>
                        </div>
                      </div>
                      <p className="text-sm text-gray-600">{cat.description}</p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Locations Tab */}
          {activeTab === 'locations' && (
            <div>
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-xl font-bold text-gray-900">Locations</h2>
                <button
                  onClick={() => {
                    setEditingLoc(null);
                    setLocForm({ name: '', address: '', building: '', floor: '', room: '' });
                    setShowLocModal(true);
                  }}
                  className="flex items-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
                >
                  <Plus className="h-4 w-4" />
                  Add Location
                </button>
              </div>

              {loading ? (
                <div className="text-center py-12 text-gray-500">Loading...</div>
              ) : locations.length === 0 ? (
                <div className="text-center py-12">
                  <MapPin className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500">No locations found. Add your first location.</p>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {locations.map((loc) => (
                    <div key={loc.id} className="border border-gray-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                      <div className="flex justify-between items-start mb-2">
                        <h3 className="font-bold text-gray-900">{loc.name}</h3>
                        <div className="flex gap-1">
                          <button
                            onClick={() => {
                              setEditingLoc(loc);
                              setLocForm({
                                name: loc.name,
                                address: loc.address || '',
                                building: loc.building || '',
                                floor: loc.floor || '',
                                room: loc.room || ''
                              });
                              setShowLocModal(true);
                            }}
                            className="p-1.5 hover:bg-blue-50 rounded-lg transition-colors"
                          >
                            <Edit className="h-4 w-4 text-blue-600" />
                          </button>
                          <button
                            onClick={() => handleLocDelete(loc.id)}
                            className="p-1.5 hover:bg-red-50 rounded-lg transition-colors"
                          >
                            <Trash2 className="h-4 w-4 text-red-600" />
                          </button>
                        </div>
                      </div>
                      {loc.address && <p className="text-sm text-gray-600 mb-1">{loc.address}</p>}
                      <div className="text-xs text-gray-500 space-y-0.5">
                        {loc.building && <p>Building: {loc.building}</p>}
                        {loc.floor && <p>Floor: {loc.floor}</p>}
                        {loc.room && <p>Room: {loc.room}</p>}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Department Modal */}
      {showDeptModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md">
            <div className="p-6 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-gray-900">
                  {editingDept ? 'Edit Department' : 'Add Department'}
                </h2>
                <button
                  onClick={() => setShowDeptModal(false)}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
            </div>
            <form onSubmit={handleDeptSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Department Name *
                </label>
                <input
                  type="text"
                  value={deptForm.name}
                  onChange={(e) => setDeptForm({ ...deptForm, name: e.target.value })}
                  required
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="e.g., IT, HR, Finance"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Description</label>
                <textarea
                  value={deptForm.description}
                  onChange={(e) => setDeptForm({ ...deptForm, description: e.target.value })}
                  rows={3}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Brief description of the department"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Department Head</label>
                <input
                  type="text"
                  value={deptForm.department_head}
                  onChange={(e) => setDeptForm({ ...deptForm, department_head: e.target.value })}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Name of department head"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Location</label>
                <input
                  type="text"
                  value={deptForm.location}
                  onChange={(e) => setDeptForm({ ...deptForm, location: e.target.value })}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Physical location"
                />
              </div>
              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  checked={deptForm.is_active}
                  onChange={(e) => setDeptForm({ ...deptForm, is_active: e.target.checked })}
                  className="rounded border-gray-300 text-primary-500 focus:ring-primary-500"
                />
                <label className="text-sm font-medium text-gray-700">Active</label>
              </div>
              <div className="flex gap-3 pt-4">
                <button
                  type="button"
                  onClick={() => setShowDeptModal(false)}
                  className="flex-1 px-4 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors disabled:opacity-50"
                >
                  <Save className="h-4 w-4" />
                  {loading ? 'Saving...' : 'Save'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Category Modal */}
      {showCatModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md">
            <div className="p-6 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-gray-900">
                  {editingCat ? 'Edit Category' : 'Add Category'}
                </h2>
                <button
                  onClick={() => setShowCatModal(false)}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
            </div>
            <form onSubmit={handleCatSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Category Name *
                </label>
                <input
                  type="text"
                  value={catForm.name}
                  onChange={(e) => setCatForm({ ...catForm, name: e.target.value })}
                  required
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="e.g., Laptop, Desktop, Monitor"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Description</label>
                <textarea
                  value={catForm.description}
                  onChange={(e) => setCatForm({ ...catForm, description: e.target.value })}
                  rows={3}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Brief description of the category"
                />
              </div>
              <div className="flex gap-3 pt-4">
                <button
                  type="button"
                  onClick={() => setShowCatModal(false)}
                  className="flex-1 px-4 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors disabled:opacity-50"
                >
                  <Save className="h-4 w-4" />
                  {loading ? 'Saving...' : 'Save'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Location Modal */}
      {showLocModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md">
            <div className="p-6 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-gray-900">
                  {editingLoc ? 'Edit Location' : 'Add Location'}
                </h2>
                <button
                  onClick={() => setShowLocModal(false)}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
            </div>
            <form onSubmit={handleLocSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Location Name *
                </label>
                <input
                  type="text"
                  value={locForm.name}
                  onChange={(e) => setLocForm({ ...locForm, name: e.target.value })}
                  required
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="e.g., Head Office, Warehouse"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Address</label>
                <input
                  type="text"
                  value={locForm.address}
                  onChange={(e) => setLocForm({ ...locForm, address: e.target.value })}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Street address"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Building</label>
                  <input
                    type="text"
                    value={locForm.building}
                    onChange={(e) => setLocForm({ ...locForm, building: e.target.value })}
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Building name/number"
                  />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Floor</label>
                  <input
                    type="text"
                    value={locForm.floor}
                    onChange={(e) => setLocForm({ ...locForm, floor: e.target.value })}
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Floor number"
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">Room</label>
                <input
                  type="text"
                  value={locForm.room}
                  onChange={(e) => setLocForm({ ...locForm, room: e.target.value })}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Room number"
                />
              </div>
              <div className="flex gap-3 pt-4">
                <button
                  type="button"
                  onClick={() => setShowLocModal(false)}
                  className="flex-1 px-4 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors disabled:opacity-50"
                >
                  <Save className="h-4 w-4" />
                  {loading ? 'Saving...' : 'Save'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </Layout>
  );
};

export default MasterData;
