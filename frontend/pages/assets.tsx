import React, { useState } from 'react';
import Layout from '../components/Layout';
import { Package, Plus, Search, Edit, Trash2, X, Save } from 'lucide-react';

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
  description?: string;
}

const Assets = () => {
  const [assets, setAssets] = useState<Asset[]>([
    {
      id: '1',
      name: 'MacBook Pro 16"',
      category: 'IT Equipment',
      location: 'Office - Floor 1',
      current_value: 2500,
      condition: 'excellent',
      purchase_date: '2023-01-15',
      purchase_cost: 3000,
      assigned_to: 'John Doe',
      description: 'High-performance laptop for development'
    },
    {
      id: '2',
      name: 'Standing Desk',
      category: 'Office Furniture',
      location: 'Office - Floor 2',
      current_value: 800,
      condition: 'good',
      purchase_date: '2023-02-20',
      purchase_cost: 1000,
      assigned_to: 'Jane Smith',
      description: 'Adjustable height standing desk'
    },
    {
      id: '3',
      name: 'Conference Table',
      category: 'Office Furniture',
      location: 'Meeting Room A',
      current_value: 1200,
      condition: 'excellent',
      purchase_date: '2023-03-10',
      purchase_cost: 1500,
      assigned_to: null,
      description: 'Large conference table for 12 people'
    }
  ]);

  const [showModal, setShowModal] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterCategory, setFilterCategory] = useState('all');
  const [filterLocation, setFilterLocation] = useState('all');
  const [editingAsset, setEditingAsset] = useState<Asset | null>(null);
  
  const [formData, setFormData] = useState<Partial<Asset>>({
    name: '',
    category: 'IT Equipment',
    location: 'Office - Floor 1',
    current_value: 0,
    condition: 'excellent',
    purchase_date: new Date().toISOString().split('T')[0],
    purchase_cost: 0,
    assigned_to: '',
    description: ''
  });

  const categories = ['IT Equipment', 'Office Furniture', 'Vehicles', 'Tools', 'Other'];
  const locations = ['Office - Floor 1', 'Office - Floor 2', 'Meeting Room A', 'Server Room', 'Warehouse'];

  const handleOpenModal = (asset?: Asset) => {
    if (asset) {
      setEditingAsset(asset);
      setFormData(asset);
    } else {
      setEditingAsset(null);
      setFormData({
        name: '',
        category: 'IT Equipment',
        location: 'Office - Floor 1',
        current_value: 0,
        condition: 'excellent',
        purchase_date: new Date().toISOString().split('T')[0],
        purchase_cost: 0,
        assigned_to: '',
        description: ''
      });
    }
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setEditingAsset(null);
    setFormData({
      name: '',
      category: 'IT Equipment',
      location: 'Office - Floor 1',
      current_value: 0,
      condition: 'excellent',
      purchase_date: new Date().toISOString().split('T')[0],
      purchase_cost: 0,
      assigned_to: '',
      description: ''
    });
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'current_value' || name === 'purchase_cost' ? parseFloat(value) || 0 : value
    }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (editingAsset) {
      // Update existing asset
      setAssets(prev => prev.map(asset => 
        asset.id === editingAsset.id 
          ? { ...asset, ...formData } as Asset
          : asset
      ));
    } else {
      // Add new asset
      const newAsset: Asset = {
        id: (assets.length + 1).toString(),
        name: formData.name || '',
        category: formData.category || 'IT Equipment',
        location: formData.location || 'Office - Floor 1',
        current_value: formData.current_value || 0,
        condition: formData.condition || 'excellent',
        purchase_date: formData.purchase_date || new Date().toISOString().split('T')[0],
        purchase_cost: formData.purchase_cost || 0,
        assigned_to: formData.assigned_to || null,
        description: formData.description || ''
      };
      setAssets(prev => [...prev, newAsset]);
    }
    
    handleCloseModal();
  };

  const handleDelete = (id: string) => {
    if (confirm('Are you sure you want to delete this asset?')) {
      setAssets(prev => prev.filter(asset => asset.id !== id));
    }
  };

  const filteredAssets = assets.filter(asset => {
    const matchesSearch = asset.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         asset.category.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = filterCategory === 'all' || asset.category === filterCategory;
    const matchesLocation = filterLocation === 'all' || asset.location === filterLocation;
    return matchesSearch && matchesCategory && matchesLocation;
  });

  const getConditionColor = (condition: string) => {
    switch (condition) {
      case 'excellent': return 'bg-green-100 text-green-700 border border-green-200';
      case 'good': return 'bg-blue-100 text-blue-700 border border-blue-200';
      case 'fair': return 'bg-yellow-100 text-yellow-700 border border-yellow-200';
      case 'poor': return 'bg-red-100 text-red-700 border border-red-200';
      default: return 'bg-gray-100 text-gray-700 border border-gray-200';
    }
  };

  return (
    <Layout title="Assets">
      {/* Page Header */}
      <div className="mb-5">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
              Assets Management
            </h1>
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <span>Home</span>
              <span>•</span>
              <span>Assets</span>
              <span>•</span>
              <span>{new Date().toLocaleDateString()}</span>
            </div>
          </div>
          <button 
            onClick={() => handleOpenModal()}
            className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-all duration-200 shadow-md hover:shadow-lg"
          >
            <Plus className="h-5 w-5" />
            Add New Asset
          </button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-3 mb-6">
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Total Assets
              </p>
              <p className="text-3xl font-bold text-gray-900">{assets.length}</p>
            </div>
            <div className="bg-blue-100 rounded-2xl p-3">
              <Package className="text-blue-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Total Value
              </p>
              <p className="text-3xl font-bold text-gray-900">
                ${assets.reduce((sum, a) => sum + a.current_value, 0).toLocaleString()}
              </p>
            </div>
            <div className="bg-green-100 rounded-2xl p-3">
              <Package className="text-green-600 h-7 w-7" />
            </div>
          </div>
        </div>
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Assigned Assets
              </p>
              <p className="text-3xl font-bold text-gray-900">
                {assets.filter(a => a.assigned_to).length}
              </p>
            </div>
            <div className="bg-purple-100 rounded-2xl p-3">
              <Package className="text-purple-600 h-7 w-7" />
            </div>
          </div>
        </div>
      </div>

      {/* Search and Filter */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 mb-6 shadow-sm">
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search assets..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>
          <select 
            value={filterCategory}
            onChange={(e) => setFilterCategory(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          >
            <option value="all">All Categories</option>
            {categories.map(cat => (
              <option key={cat} value={cat}>{cat}</option>
            ))}
          </select>
          <select 
            value={filterLocation}
            onChange={(e) => setFilterLocation(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          >
            <option value="all">All Locations</option>
            {locations.map(loc => (
              <option key={loc} value={loc}>{loc}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Assets Table */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50/80 border-b border-gray-200/60">
              <tr>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Asset</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Category</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Location</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Condition</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Value</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Assigned To</th>
                <th className="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200/60">
              {filteredAssets.map((asset) => (
                <tr key={asset.id} className="hover:bg-gray-50/80 transition-colors">
                  <td className="px-6 py-4">
                    <div>
                      <div className="text-sm font-semibold text-gray-900">{asset.name}</div>
                      <div className="text-xs text-gray-500">ID: {asset.id}</div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm text-gray-900">{asset.category}</div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm text-gray-900">{asset.location}</div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${getConditionColor(asset.condition)}`}>
                      {asset.condition}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm font-medium text-gray-900">
                      ${asset.current_value.toLocaleString()}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="text-sm text-gray-900">
                      {asset.assigned_to || 'Unassigned'}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center justify-end gap-2">
                      <button 
                        onClick={() => handleOpenModal(asset)}
                        className="p-2 hover:bg-gray-100 rounded-xl transition-colors"
                      >
                        <Edit className="h-4 w-4 text-blue-600" />
                      </button>
                      <button 
                        onClick={() => handleDelete(asset.id)}
                        className="p-2 hover:bg-gray-100 rounded-xl transition-colors"
                      >
                        <Trash2 className="h-4 w-4 text-red-600" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add/Edit Asset Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 px-8 py-6 flex items-center justify-between rounded-t-3xl">
              <h2 className="text-2xl font-bold text-gray-900">
                {editingAsset ? 'Edit Asset' : 'Add New Asset'}
              </h2>
              <button 
                onClick={handleCloseModal}
                className="p-2 hover:bg-gray-100 rounded-xl transition-colors"
              >
                <X className="h-6 w-6 text-gray-600" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="p-8">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Asset Name *
                  </label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleInputChange}
                    required
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Enter asset name"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Category *
                  </label>
                  <select
                    name="category"
                    value={formData.category}
                    onChange={handleInputChange}
                    required
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  >
                    {categories.map(cat => (
                      <option key={cat} value={cat}>{cat}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Location *
                  </label>
                  <select
                    name="location"
                    value={formData.location}
                    onChange={handleInputChange}
                    required
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  >
                    {locations.map(loc => (
                      <option key={loc} value={loc}>{loc}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Purchase Cost *
                  </label>
                  <input
                    type="number"
                    name="purchase_cost"
                    value={formData.purchase_cost}
                    onChange={handleInputChange}
                    required
                    min="0"
                    step="0.01"
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="0.00"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Current Value *
                  </label>
                  <input
                    type="number"
                    name="current_value"
                    value={formData.current_value}
                    onChange={handleInputChange}
                    required
                    min="0"
                    step="0.01"
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="0.00"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Condition *
                  </label>
                  <select
                    name="condition"
                    value={formData.condition}
                    onChange={handleInputChange}
                    required
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  >
                    <option value="excellent">Excellent</option>
                    <option value="good">Good</option>
                    <option value="fair">Fair</option>
                    <option value="poor">Poor</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Purchase Date *
                  </label>
                  <input
                    type="date"
                    name="purchase_date"
                    value={formData.purchase_date}
                    onChange={handleInputChange}
                    required
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Assigned To
                  </label>
                  <input
                    type="text"
                    name="assigned_to"
                    value={formData.assigned_to || ''}
                    onChange={handleInputChange}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Enter person or department name"
                  />
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Description
                  </label>
                  <textarea
                    name="description"
                    value={formData.description || ''}
                    onChange={handleInputChange}
                    rows={3}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    placeholder="Enter asset description"
                  />
                </div>
              </div>

              <div className="mt-8 flex gap-4 justify-end">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
                >
                  <Save className="h-5 w-5" />
                  {editingAsset ? 'Update Asset' : 'Add Asset'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </Layout>
  );
};

export default Assets;