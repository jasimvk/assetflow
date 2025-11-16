import React, { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { Package, Plus, Search, Edit, Trash2, X, Save, Download, Filter, QrCode, Upload, Info, AlertCircle, TrendingUp, Calendar, User, MapPin, Settings } from 'lucide-react';
import { assetsAPI, categoriesAPI, locationsAPI, usersAPI } from '../utils/api';
import { QRCodeCanvas } from 'qrcode.react';

interface Asset {
  id: string;
  name: string;
  category: string;
  location: string;
  serial_number?: string;
  model?: string;
  manufacturer?: string;
  current_value: number;
  condition: 'excellent' | 'good' | 'fair' | 'poor';
  status: 'active' | 'in_stock' | 'maintenance' | 'retired' | 'disposed';
  purchase_date: string;
  purchase_cost: number;
  warranty_expiry?: string;
  assigned_to: string | null;
  previous_user?: string | null;
  resigned_date?: string | null;
  resignation_notes?: string | null;
  description?: string;
  notes?: string;
  maintenance_schedule?: string;
  department?: {
    id: string;
    name: string;
    description?: string;
  };
}

const Assets = () => {
  const router = useRouter();
  const [assets, setAssets] = useState<Asset[]>([]);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<string[]>([]);
  const [locations, setLocations] = useState<string[]>([]);
  const [users, setUsers] = useState<any[]>([]);
  const [showModal, setShowModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedAsset, setSelectedAsset] = useState<Asset | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterCategory, setFilterCategory] = useState('all');
  const [filterLocation, setFilterLocation] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [filterCondition, setFilterCondition] = useState('all');
  const [editingAsset, setEditingAsset] = useState<Asset | null>(null);
  const [selectedAssets, setSelectedAssets] = useState<string[]>([]);
  const [showBulkModal, setShowBulkModal] = useState(false);
  const [bulkAction, setBulkAction] = useState<'assign' | 'transfer' | 'status' | 'condition' | null>(null);
  const [bulkValue, setBulkValue] = useState('');
  const [showAdvancedFilters, setShowAdvancedFilters] = useState(false);
  const [dateFrom, setDateFrom] = useState('');
  const [dateTo, setDateTo] = useState('');
  const [valueMin, setValueMin] = useState('');
  const [valueMax, setValueMax] = useState('');
  const [warrantyFilter, setWarrantyFilter] = useState('all');
  const [sortBy, setSortBy] = useState('name');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('asc');
  const [showQRModal, setShowQRModal] = useState(false);
  const [qrAsset, setQRAsset] = useState<Asset | null>(null);
  const qrRef = useRef<HTMLDivElement>(null);

  // Currency formatting helper - Always show in AED
  const formatCurrency = (amount: number) => {
    if (!amount && amount !== 0) return 'N/A';
    return `AED ${amount.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
  };

  // Load initial data
  useEffect(() => {
    loadAssets();
    loadCategories();
    loadLocations();
    loadUsers();
  }, []);

  const loadAssets = async () => {
    try {
      setLoading(true);
      console.log('Loading assets...');
      const data = await assetsAPI.getAll();
      console.log('Assets loaded:', data);
      console.log('Number of assets:', data?.length || 0);
      setAssets(data || []);
    } catch (error) {
      console.error('Error loading assets:', error);
      alert('Failed to load assets. Please check the console for details.');
    } finally {
      setLoading(false);
    }
  };

  const loadCategories = async () => {
    try {
      // First try to get categories from the API
      const data = await categoriesAPI.getAll();
      if (data && data.length > 0) {
        setCategories(data.map(c => c.name));
      } else {
        // If no categories from API, extract unique categories from assets
        const assetsData = await assetsAPI.getAll();
        if (assetsData && assetsData.length > 0) {
          const uniqueCategories = Array.from(new Set(assetsData.map(a => a.category))).sort();
          setCategories(uniqueCategories);
        } else {
          // Final fallback to predefined list
          setCategories([
            'Accessory',
            'Desktop',
            'Laptop',
            'Mobile Phone',
            'Monitor',
            'Network Device',
            'Peripheral',
            'Printer',
            'Server',
            'Storage',
            'Switch',
            'Tablet',
            'Walkie Talkie',
            'Other'
          ]);
        }
      }
    } catch (error) {
      console.error('Error loading categories:', error);
      // Fallback categories
      setCategories([
        'Accessory',
        'Desktop',
        'Laptop',
        'Mobile Phone',
        'Monitor',
        'Network Device',
        'Peripheral',
        'Printer',
        'Server',
        'Storage',
        'Switch',
        'Tablet',
        'Walkie Talkie',
        'Other'
      ]);
    }
  };

  const loadLocations = async () => {
    try {
      const data = await locationsAPI.getAll();
      setLocations(data?.map(l => l.name) || ['Office - Floor 1', 'Office - Floor 2', 'Warehouse']);
    } catch (error) {
      console.error('Error loading locations:', error);
      setLocations(['Office - Floor 1', 'Office - Floor 2', 'Warehouse']);
    }
  };

  const loadUsers = async () => {
    try {
      const data = await usersAPI.getAll();
      setUsers(data || []);
    } catch (error) {
      console.error('Error loading users:', error);
    }
  };
  
  const [formData, setFormData] = useState<Partial<Asset>>({
    name: '',
    category: 'Server',
    location: 'Office - Floor 1',
    serial_number: '',
    model: '',
    manufacturer: '',
    current_value: 0,
    condition: 'excellent',
    status: 'active',
    purchase_date: new Date().toISOString().split('T')[0],
    purchase_cost: 0,
    warranty_expiry: '',
    assigned_to: '',
    description: '',
    notes: '',
    maintenance_schedule: ''
  });

  const handleOpenModal = (asset?: Asset) => {
    if (asset) {
      setEditingAsset(asset);
      setFormData(asset);
    } else {
      setEditingAsset(null);
      setFormData({
        name: '',
        category: categories[0] || 'Server',
        location: locations[0] || 'Office - Floor 1',
        serial_number: '',
        model: '',
        manufacturer: '',
        current_value: 0,
        condition: 'excellent',
        status: 'active',
        purchase_date: new Date().toISOString().split('T')[0],
        purchase_cost: 0,
        warranty_expiry: '',
        assigned_to: '',
        description: '',
        notes: '',
        maintenance_schedule: ''
      });
    }
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setEditingAsset(null);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'current_value' || name === 'purchase_cost' ? parseFloat(value) || 0 : value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation
    if (!formData.name || !formData.category || !formData.location) {
      alert('Please fill in all required fields (Name, Category, Location)');
      return;
    }
    
    try {
      if (editingAsset) {
        // Update existing asset
        const updated = await assetsAPI.update(editingAsset.id, formData);
        if (updated) {
          setAssets(prev => prev.map(asset => 
            asset.id === editingAsset.id ? updated : asset
          ));
          alert('Asset updated successfully!');
        }
      } else {
        // Add new asset
        const created = await assetsAPI.create(formData);
        if (created) {
          setAssets(prev => [...prev, created]);
          alert('Asset added successfully!');
        }
      }
      handleCloseModal();
    } catch (error) {
      console.error('Error saving asset:', error);
      alert('Failed to save asset. Please try again.');
    }
  };

  const handleDelete = async (id: string) => {
    if (confirm('Are you sure you want to delete this asset? This action cannot be undone.')) {
      try {
        const success = await assetsAPI.delete(id);
        if (success) {
          setAssets(prev => prev.filter(asset => asset.id !== id));
          alert('Asset deleted successfully!');
        }
      } catch (error) {
        console.error('Error deleting asset:', error);
        alert('Failed to delete asset. Please try again.');
      }
    }
  };

  const handleBulkDelete = async () => {
    if (selectedAssets.length === 0) {
      alert('Please select assets to delete');
      return;
    }
    
    if (confirm(`Are you sure you want to delete ${selectedAssets.length} asset(s)? This action cannot be undone.`)) {
      try {
        for (const id of selectedAssets) {
          await assetsAPI.delete(id);
        }
        setAssets(prev => prev.filter(asset => !selectedAssets.includes(asset.id)));
        setSelectedAssets([]);
        alert('Assets deleted successfully!');
      } catch (error) {
        console.error('Error deleting assets:', error);
        alert('Failed to delete some assets. Please try again.');
      }
    }
  };

  const handleBulkUpdate = async () => {
    if (!bulkValue) {
      alert('Please select a value');
      return;
    }

    try {
      const updateData: any = {};
      
      if (bulkAction === 'assign') {
        updateData.assigned_to = bulkValue;
      } else if (bulkAction === 'transfer') {
        updateData.location = bulkValue;
      } else if (bulkAction === 'status') {
        updateData.status = bulkValue;
      } else if (bulkAction === 'condition') {
        updateData.condition = bulkValue;
      }

      for (const id of selectedAssets) {
        await assetsAPI.update(id, updateData);
      }

      // Refresh assets
      await loadAssets();
      setSelectedAssets([]);
      setShowBulkModal(false);
      setBulkValue('');
      alert(`${selectedAssets.length} asset(s) updated successfully!`);
    } catch (error) {
      console.error('Error updating assets:', error);
      alert('Failed to update assets. Please try again.');
    }
  };

  const exportSelectedToCSV = () => {
    const selectedAssetsData = assets.filter(a => selectedAssets.includes(a.id));
    const headers = ['Name', 'Category', 'Location', 'Serial Number', 'Model', 'Manufacturer', 'Status', 'Condition', 'Purchase Cost', 'Current Value', 'Assigned To'];
    const rows = selectedAssetsData.map(asset => [
      asset.name,
      asset.category,
      asset.location,
      asset.serial_number || '',
      asset.model || '',
      asset.manufacturer || '',
      asset.status,
      asset.condition,
      asset.purchase_cost,
      asset.current_value,
      asset.assigned_to || ''
    ]);

    const csvContent = [headers, ...rows].map(row => row.join(',')).join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `selected-assets-${new Date().toISOString().split('T')[0]}.csv`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  // Download QR code as PNG
  const downloadQRCode = (asset: Asset) => {
    const canvas = document.querySelector(`#qr-canvas-${asset.id}`) as HTMLCanvasElement;
    if (canvas) {
      canvas.toBlob((blob) => {
        if (blob) {
          const url = URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = `asset-qr-${asset.serial_number || asset.id}.png`;
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          URL.revokeObjectURL(url);
        }
      });
    }
  };

  const handleExport = () => {
    const csvContent = [
      ['Name', 'Category', 'Location', 'Serial Number', 'Model', 'Manufacturer', 'Status', 'Condition', 'Purchase Cost', 'Current Value', 'Assigned To'],
      ...filteredAssets.map(asset => [
        asset.name,
        asset.category,
        asset.location,
        asset.serial_number || '',
        asset.model || '',
        asset.manufacturer || '',
        asset.status || 'active',
        asset.condition,
        asset.purchase_cost,
        asset.current_value,
        asset.assigned_to || ''
      ])
    ].map(row => row.join(',')).join('\n');

    const blob = new Blob([csvContent], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `assets-${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
  };

  const filteredAssets = assets.filter(asset => {
    const matchesSearch = asset.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         asset.category.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         asset.serial_number?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         asset.model?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         asset.manufacturer?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = filterCategory === 'all' || asset.category === filterCategory;
    const matchesLocation = filterLocation === 'all' || asset.location === filterLocation;
    const matchesStatus = filterStatus === 'all' || asset.status === filterStatus;
    const matchesCondition = filterCondition === 'all' || asset.condition === filterCondition;
    
    // Advanced filters
    const matchesDateRange = (!dateFrom || new Date(asset.purchase_date) >= new Date(dateFrom)) &&
                            (!dateTo || new Date(asset.purchase_date) <= new Date(dateTo));
    const matchesValueRange = (!valueMin || asset.current_value >= parseFloat(valueMin)) &&
                             (!valueMax || asset.current_value <= parseFloat(valueMax));
    const matchesWarranty = warrantyFilter === 'all' ||
                           (warrantyFilter === 'active' && asset.warranty_expiry && new Date(asset.warranty_expiry) > new Date()) ||
                           (warrantyFilter === 'expired' && asset.warranty_expiry && new Date(asset.warranty_expiry) <= new Date()) ||
                           (warrantyFilter === 'none' && !asset.warranty_expiry);
    
    return matchesSearch && matchesCategory && matchesLocation && matchesStatus && matchesCondition && 
           matchesDateRange && matchesValueRange && matchesWarranty;
  }).sort((a, b) => {
    let aValue: any, bValue: any;
    
    switch (sortBy) {
      case 'name':
        aValue = a.name.toLowerCase();
        bValue = b.name.toLowerCase();
        break;
      case 'category':
        aValue = a.category.toLowerCase();
        bValue = b.category.toLowerCase();
        break;
      case 'purchase_date':
        aValue = new Date(a.purchase_date).getTime();
        bValue = new Date(b.purchase_date).getTime();
        break;
      case 'current_value':
        aValue = a.current_value;
        bValue = b.current_value;
        break;
      case 'status':
        aValue = a.status;
        bValue = b.status;
        break;
      default:
        return 0;
    }
    
    if (aValue < bValue) return sortOrder === 'asc' ? -1 : 1;
    if (aValue > bValue) return sortOrder === 'asc' ? 1 : -1;
    return 0;
  });

  const handleViewDetails = (asset: Asset) => {
    setSelectedAsset(asset);
    setShowDetailModal(true);
  };

  const getConditionColor = (condition: string) => {
    switch (condition) {
      case 'excellent': return 'bg-green-100 text-green-700 border border-green-200';
      case 'good': return 'bg-blue-100 text-blue-700 border border-blue-200';
      case 'fair': return 'bg-yellow-100 text-yellow-700 border border-yellow-200';
      case 'poor': return 'bg-red-100 text-red-700 border border-red-200';
      default: return 'bg-gray-100 text-gray-700 border border-gray-200';
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'bg-green-100 text-green-700 border border-green-200';
      case 'in_stock': return 'bg-blue-100 text-blue-700 border border-blue-200';
      case 'maintenance': return 'bg-yellow-100 text-yellow-700 border border-yellow-200';
      case 'retired': return 'bg-gray-100 text-gray-700 border border-gray-200';
      case 'disposed': return 'bg-red-100 text-red-700 border border-red-200';
      default: return 'bg-gray-100 text-gray-700 border border-gray-200';
    }
  };

  const getWarrantyStatus = (warrantyExpiry?: string) => {
    if (!warrantyExpiry) {
      return { status: 'None', color: 'bg-gray-100 text-gray-600 border border-gray-200' };
    }
    
    const expiryDate = new Date(warrantyExpiry);
    const today = new Date();
    const daysUntilExpiry = Math.floor((expiryDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
    
    if (daysUntilExpiry < 0) {
      return { status: 'Expired', color: 'bg-red-100 text-red-700 border border-red-200' };
    } else if (daysUntilExpiry <= 30) {
      return { status: `${daysUntilExpiry}d left`, color: 'bg-orange-100 text-orange-700 border border-orange-200' };
    } else if (daysUntilExpiry <= 90) {
      return { status: `${Math.floor(daysUntilExpiry / 30)}mo left`, color: 'bg-yellow-100 text-yellow-700 border border-yellow-200' };
    } else {
      return { status: 'Active', color: 'bg-green-100 text-green-700 border border-green-200' };
    }
  };

  const handleSelectAll = () => {
    if (selectedAssets.length === filteredAssets.length) {
      setSelectedAssets([]);
    } else {
      setSelectedAssets(filteredAssets.map(a => a.id));
    }
  };

  const handleSelectAsset = (id: string) => {
    setSelectedAssets(prev => 
      prev.includes(id) ? prev.filter(assetId => assetId !== id) : [...prev, id]
    );
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
          <div className="flex gap-3">
            <button 
              onClick={handleExport}
              className="flex items-center gap-2 px-6 py-3 bg-white border border-gray-300 text-gray-700 rounded-2xl font-semibold hover:bg-gray-50 transition-all duration-200 shadow-sm hover:shadow-md"
            >
              <Download className="h-5 w-5" />
              Export CSV
            </button>
            <button 
              onClick={() => router.push('/master-data')}
              className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-500 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-600 transition-all duration-200 shadow-md hover:shadow-lg"
            >
              <Settings className="h-5 w-5" />
              Master Data
            </button>
            <button 
              onClick={() => router.push('/asset-import')}
              className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-2xl font-semibold hover:from-green-600 hover:to-emerald-600 transition-all duration-200 shadow-md hover:shadow-lg"
            >
              <Upload className="h-5 w-5" />
              Import Assets
            </button>
            <button 
              onClick={() => router.push('/add-asset')}
              className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-2xl font-semibold hover:bg-primary-600 transition-all duration-200 shadow-md hover:shadow-lg"
            >
              <Plus className="h-5 w-5" />
              Add New Asset
            </button>
          </div>
        </div>
      </div>

      {/* Quick Tips Banner - Show only when there are assets */}
      {/* {assets.length > 0 && (
        <div className="bg-gradient-to-r from-indigo-50 to-purple-50 border border-indigo-200 rounded-2xl p-4 mb-6">
          <div className="flex items-start gap-3">
            <div className="bg-indigo-500 rounded-lg p-2 mt-0.5">
              <Info className="h-5 w-5 text-white" />
            </div>
            <div className="flex-1">
              <h3 className="text-sm font-bold text-indigo-900 mb-1">Quick Tips</h3>
              <ul className="text-xs text-indigo-700 space-y-1">
                <li>• <strong>Multi-select:</strong> Check boxes to perform bulk operations like assign, transfer, or export</li>
                <li>• <strong>Advanced Filters:</strong> Use date range, value range, and warranty filters for precise results</li>
                <li>• <strong>QR Codes:</strong> Generate QR codes for assets to enable quick scanning and identification</li>
                <li>• <strong>Click asset name:</strong> View complete details including specifications and history</li>
              </ul>
            </div>
          </div>
        </div>
      )} */}

      {/* Stats Cards */}
      {/* <div className="grid grid-cols-1 gap-6 sm:grid-cols-4 mb-6"> */}
        {/* <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
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
        </div> */}
        {/* <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Total Value
              </p>
              <p className="text-3xl font-bold text-gray-900">
                AED {assets.reduce((sum, a) => sum + a.current_value, 0).toLocaleString()}
              </p>
            </div>
            <div className="bg-green-100 rounded-2xl p-3">
              <Package className="text-green-600 h-7 w-7" />
            </div>
          </div>
        </div> */}
        {/* <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
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
        <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 shadow-sm hover:shadow-lg transition-all duration-300">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-1">
                Active
              </p>
              <p className="text-3xl font-bold text-gray-900">
                {assets.filter(a => a.status === 'active').length}
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
                Assigned
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
      </div> */}

      {/* Search and Filter */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-6 mb-6 shadow-sm">
        <div className="flex flex-col gap-4">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search by name, serial, model, manufacturer..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-10 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm('')}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                  title="Clear search"
                >
                  <X className="h-4 w-4" />
                </button>
              )}
            </div>
            <button
              onClick={() => {
                setFilterCategory('all');
                setFilterLocation('all');
                setFilterStatus('all');
                setFilterCondition('all');
                setSearchTerm('');
                setDateFrom('');
                setDateTo('');
                setValueMin('');
                setValueMax('');
                setWarrantyFilter('all');
              }}
              className="px-4 py-2.5 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors text-sm font-medium text-gray-700"
            >
              Clear All Filters
            </button>
            <button
              onClick={() => setShowAdvancedFilters(!showAdvancedFilters)}
              className={`px-4 py-2.5 rounded-xl transition-colors text-sm font-medium ${
                showAdvancedFilters 
                  ? 'bg-primary-500 text-white hover:bg-primary-600' 
                  : 'border border-gray-300 text-gray-700 hover:bg-gray-50'
              }`}
            >
              <Filter className="h-4 w-4 inline mr-2" />
              Advanced Filters
            </button>
          </div>
          
          {/* Advanced Filters Panel */}
          {showAdvancedFilters && (
            <div className="mt-4 p-4 bg-gray-50 rounded-xl border border-gray-200">
              <h3 className="text-sm font-bold text-gray-900 mb-3">Advanced Filters</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {/* Date Range Filter */}
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Purchase Date From</label>
                  <input
                    type="date"
                    value={dateFrom}
                    onChange={(e) => setDateFrom(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Purchase Date To</label>
                  <input
                    type="date"
                    value={dateTo}
                    onChange={(e) => setDateTo(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  />
                </div>
                {/* Value Range Filter */}
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Min Value (AED)</label>
                  <input
                    type="number"
                    value={valueMin}
                    onChange={(e) => setValueMin(e.target.value)}
                    placeholder="0"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Max Value (AED)</label>
                  <input
                    type="number"
                    value={valueMax}
                    onChange={(e) => setValueMax(e.target.value)}
                    placeholder="999999"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  />
                </div>
                {/* Warranty Status Filter */}
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Warranty Status</label>
                  <select
                    value={warrantyFilter}
                    onChange={(e) => setWarrantyFilter(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  >
                    <option value="all">All</option>
                    <option value="active">Active Warranty</option>
                    <option value="expired">Expired Warranty</option>
                    <option value="none">No Warranty Info</option>
                  </select>
                </div>
                {/* Sort By */}
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Sort By</label>
                  <select
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  >
                    <option value="name">Name</option>
                    <option value="category">Category</option>
                    <option value="purchase_date">Purchase Date</option>
                    <option value="current_value">Value</option>
                    <option value="status">Status</option>
                  </select>
                </div>
                {/* Sort Order */}
                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">Sort Order</label>
                  <select
                    value={sortOrder}
                    onChange={(e) => setSortOrder(e.target.value as 'asc' | 'desc')}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                  >
                    <option value="asc">Ascending</option>
                    <option value="desc">Descending</option>
                  </select>
                </div>
              </div>
            </div>
          )}
          
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <select 
              value={filterCategory}
              onChange={(e) => setFilterCategory(e.target.value)}
              className="px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
            >
              <option value="all">All Categories</option>
              {categories.map(cat => (
                <option key={cat} value={cat}>{cat}</option>
              ))}
            </select>
            
            <select 
              value={filterLocation}
              onChange={(e) => setFilterLocation(e.target.value)}
              className="px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
            >
              <option value="all">All Locations</option>
              {locations.map(loc => (
                <option key={loc} value={loc}>{loc}</option>
              ))}
            </select>
            
            <select 
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
            >
              <option value="all">All Status</option>
              <option value="active">Active</option>
              <option value="in_stock">In Stock</option>
              <option value="maintenance">Maintenance</option>
              <option value="retired">Retired</option>
              <option value="disposed">Disposed</option>
            </select>
            
            <select 
              value={filterCondition}
              onChange={(e) => setFilterCondition(e.target.value)}
              className="px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
            >
              <option value="all">All Conditions</option>
              <option value="excellent">Excellent</option>
              <option value="good">Good</option>
              <option value="fair">Fair</option>
              <option value="poor">Poor</option>
            </select>
          </div>

          {selectedAssets.length > 0 && (
            <div className="bg-gradient-to-r from-blue-50 to-purple-50 border border-blue-200 rounded-xl p-4 shadow-sm">
              <div className="flex items-center justify-between">
                <span className="text-sm font-bold text-blue-900">
                  ✓ {selectedAssets.length} asset(s) selected
                </span>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => { setBulkAction('assign'); setShowBulkModal(true); }}
                    className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg text-sm font-semibold hover:bg-blue-600 transition-colors"
                  >
                    <Save className="h-4 w-4" />
                    Assign To
                  </button>
                  <button
                    onClick={() => { setBulkAction('transfer'); setShowBulkModal(true); }}
                    className="flex items-center gap-2 px-4 py-2 bg-purple-500 text-white rounded-lg text-sm font-semibold hover:bg-purple-600 transition-colors"
                  >
                    <Package className="h-4 w-4" />
                    Transfer Location
                  </button>
                  <button
                    onClick={() => { setBulkAction('status'); setShowBulkModal(true); }}
                    className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white rounded-lg text-sm font-semibold hover:bg-green-600 transition-colors"
                  >
                    <Edit className="h-4 w-4" />
                    Update Status
                  </button>
                  <button
                    onClick={exportSelectedToCSV}
                    className="flex items-center gap-2 px-4 py-2 bg-yellow-500 text-white rounded-lg text-sm font-semibold hover:bg-yellow-600 transition-colors"
                  >
                    <Download className="h-4 w-4" />
                    Export
                  </button>
                  <button
                    onClick={handleBulkDelete}
                    className="flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-lg text-sm font-semibold hover:bg-red-600 transition-colors"
                  >
                    <Trash2 className="h-4 w-4" />
                    Delete
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Active Filters Banner */}
      {(searchTerm || filterCategory !== 'all' || filterLocation !== 'all' || filterStatus !== 'all' || filterCondition !== 'all' || warrantyFilter !== 'all' || dateFrom || dateTo || valueMin || valueMax) && (
        <div className="bg-blue-50 border border-blue-200 rounded-2xl p-4 mb-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Info className="h-5 w-5 text-blue-600" />
              <span className="text-sm font-semibold text-blue-900">
                Active Filters: 
                {searchTerm && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Search: "{searchTerm}"</span>}
                {filterCategory !== 'all' && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Category: {filterCategory}</span>}
                {filterLocation !== 'all' && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Location: {filterLocation}</span>}
                {filterStatus !== 'all' && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Status: {filterStatus}</span>}
                {filterCondition !== 'all' && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Condition: {filterCondition}</span>}
                {warrantyFilter !== 'all' && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Warranty: {warrantyFilter}</span>}
                {(dateFrom || dateTo) && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Date Range</span>}
                {(valueMin || valueMax) && <span className="ml-2 px-2 py-1 bg-blue-100 rounded-lg text-xs">Value Range</span>}
              </span>
            </div>
            <button
              onClick={() => {
                setSearchTerm('');
                setFilterCategory('all');
                setFilterLocation('all');
                setFilterStatus('all');
                setFilterCondition('all');
                setWarrantyFilter('all');
                setDateFrom('');
                setDateTo('');
                setValueMin('');
                setValueMax('');
              }}
              className="text-sm text-blue-600 hover:text-blue-800 font-semibold flex items-center gap-1"
            >
              <X className="h-4 w-4" />
              Clear All
            </button>
          </div>
        </div>
      )}

      {/* Quick Stats Summary */}
      {filteredAssets.length > 0 && (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
          <div className="bg-gradient-to-br from-blue-50 to-blue-100 border border-blue-200 rounded-2xl p-4">
            <div className="flex items-center gap-3">
              <div className="bg-blue-500 rounded-xl p-2">
                <Package className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-xs font-semibold text-blue-600 uppercase">Showing</p>
                <p className="text-2xl font-bold text-blue-900">{filteredAssets.length}</p>
              </div>
            </div>
          </div>
          <div className="bg-gradient-to-br from-green-50 to-green-100 border border-green-200 rounded-2xl p-4">
            <div className="flex items-center gap-3">
              <div className="bg-green-500 rounded-xl p-2">
                <Package className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-xs font-semibold text-green-600 uppercase">In Stock</p>
                <p className="text-2xl font-bold text-green-900">
                  {filteredAssets.filter(a => a.status === 'in_stock').length}
                </p>
              </div>
            </div>
          </div>
          <div className="bg-gradient-to-br from-purple-50 to-purple-100 border border-purple-200 rounded-2xl p-4">
            <div className="flex items-center gap-3">
              <div className="bg-purple-500 rounded-xl p-2">
                <User className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-xs font-semibold text-purple-600 uppercase">Assigned</p>
                <p className="text-2xl font-bold text-purple-900">
                  {filteredAssets.filter(a => a.assigned_to).length}
                </p>
              </div>
            </div>
          </div>
          <div className="bg-gradient-to-br from-orange-50 to-orange-100 border border-orange-200 rounded-2xl p-4">
            <div className="flex items-center gap-3">
              <div className="bg-orange-500 rounded-xl p-2">
                <AlertCircle className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-xs font-semibold text-orange-600 uppercase">Warranty Alert</p>
                <p className="text-2xl font-bold text-orange-900">
                  {filteredAssets.filter(a => {
                    if (!a.warranty_expiry) return false;
                    const days = Math.floor((new Date(a.warranty_expiry).getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24));
                    return days >= 0 && days <= 30;
                  }).length}
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Assets Table */}
      <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl overflow-hidden shadow-sm">
        {/* Scroll Indicator */}
        <div className="bg-gradient-to-r from-blue-50 to-purple-50 border-b border-blue-200 px-6 py-3 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Info className="h-4 w-4 text-blue-600" />
            <span className="text-xs font-semibold text-blue-900">
              💡 Scroll horizontally to view all columns →
            </span>
          </div>
          <span className="text-xs text-blue-600 font-medium">
            {filteredAssets.length} asset{filteredAssets.length !== 1 ? 's' : ''}
          </span>
        </div>
        <div className="overflow-x-auto relative">
          {/* Left Shadow Indicator */}
          <div className="absolute left-0 top-0 bottom-0 w-8 bg-gradient-to-r from-gray-100/50 to-transparent pointer-events-none z-10"></div>
          {/* Right Shadow Indicator */}
          <div className="absolute right-0 top-0 bottom-0 w-8 bg-gradient-to-l from-gray-100/50 to-transparent pointer-events-none z-10"></div>
          <table className="w-full min-w-[2000px]">
            <thead className="bg-gray-50/80 border-b border-gray-200/60">
              <tr>
                <th className="px-6 py-4 text-left">
                  <input
                    type="checkbox"
                    checked={selectedAssets.length === filteredAssets.length && filteredAssets.length > 0}
                    onChange={handleSelectAll}
                    className="rounded border-gray-300 text-primary-500 focus:ring-primary-500"
                  />
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider sticky left-0 bg-gray-50/80 z-20">Asset</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Serial Number</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Category</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Manufacturer</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Model</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Location</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Department</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Assigned To</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Condition</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Purchase Date</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Purchase Cost</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Current Value</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Warranty</th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Last Updated</th>
                <th className="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider sticky right-0 bg-gray-50/80 z-20">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200/60">
              {loading ? (
                // Loading skeleton
                Array.from({ length: 5 }).map((_, index) => (
                  <tr key={index} className="animate-pulse">
                    <td className="px-6 py-4">
                      <div className="h-4 w-4 bg-gray-200 rounded"></div>
                    </td>
                    <td className="px-6 py-4 sticky left-0 bg-white">
                      <div className="h-4 bg-gray-200 rounded w-32"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-24"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-6 bg-gray-200 rounded-full w-20"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-24"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-20"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-24"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-24"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-16"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-6 bg-gray-200 rounded-full w-16"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-6 bg-gray-200 rounded-full w-16"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-20"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-20"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-20"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-6 bg-gray-200 rounded-full w-16"></div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="h-4 bg-gray-200 rounded w-20"></div>
                    </td>
                    <td className="px-6 py-4 sticky right-0 bg-white">
                      <div className="flex justify-end gap-2">
                        <div className="h-8 w-8 bg-gray-200 rounded-xl"></div>
                        <div className="h-8 w-8 bg-gray-200 rounded-xl"></div>
                        <div className="h-8 w-8 bg-gray-200 rounded-xl"></div>
                      </div>
                    </td>
                  </tr>
                ))
              ) : filteredAssets.length === 0 ? (
                <tr>
                  <td colSpan={17} className="px-6 py-16 text-center">
                    <div className="flex flex-col items-center justify-center">
                      <div className="bg-gray-100 rounded-full p-4 mb-4">
                        <Package className="h-12 w-12 text-gray-400" />
                      </div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-2">No assets found</h3>
                      <p className="text-sm text-gray-500 mb-4">
                        {searchTerm || filterCategory !== 'all' || filterLocation !== 'all' || filterStatus !== 'all' || filterCondition !== 'all'
                          ? "Try adjusting your search or filters to find what you're looking for."
                          : "Get started by adding your first asset to the system."}
                      </p>
                      {!(searchTerm || filterCategory !== 'all' || filterLocation !== 'all' || filterStatus !== 'all' || filterCondition !== 'all') && (
                        <button
                          onClick={() => router.push('/add-asset')}
                          className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
                        >
                          <Plus className="h-4 w-4" />
                          Add Your First Asset
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ) : (
                filteredAssets.map((asset) => (
                  <tr 
                    key={asset.id} 
                    onClick={() => handleViewDetails(asset)}
                    className="hover:bg-blue-50/50 transition-colors cursor-pointer group"
                  >
                    <td className="px-6 py-4" onClick={(e) => e.stopPropagation()}>
                      <input
                        type="checkbox"
                        checked={selectedAssets.includes(asset.id)}
                        onChange={() => handleSelectAsset(asset.id)}
                        className="rounded border-gray-300 text-primary-500 focus:ring-primary-500"
                      />
                    </td>
                    <td className="px-6 py-4 sticky left-0 bg-white shadow-sm group-hover:bg-blue-50/50">
                      <div className="text-sm font-semibold text-gray-900 group-hover:text-primary-600">{asset.name}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-mono text-gray-700">{asset.serial_number || 'N/A'}</div>
                    </td>
                    <td className="px-6 py-4">
                      <span className="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-700 border border-blue-200">
                        {asset.category}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-900">{asset.manufacturer || 'N/A'}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-900">{asset.model || 'N/A'}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-900">{asset.location}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-600">{asset.department?.name || '-'}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-900">{asset.assigned_to || '-'}</div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${getStatusColor(asset.status)}`}>
                        {asset.status || 'active'}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${getConditionColor(asset.condition)}`}>
                        {asset.condition}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-700">
                        {asset.purchase_date ? new Date(asset.purchase_date).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' }) : 'N/A'}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-semibold text-green-700">{formatCurrency(asset.purchase_cost || 0)}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-semibold text-blue-700">{formatCurrency(asset.current_value)}</div>
                    </td>
                    <td className="px-6 py-4">
                      {(() => {
                        const warranty = getWarrantyStatus(asset.warranty_expiry);
                        return (
                          <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${warranty.color}`}>
                            {warranty.status}
                          </span>
                        );
                      })()}
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-xs text-gray-500">
                        {(asset as any).updated_at ? new Date((asset as any).updated_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }) : '-'}
                      </div>
                    </td>
                    <td className="px-6 py-4 sticky right-0 bg-white shadow-sm group-hover:bg-blue-50/50" onClick={(e) => e.stopPropagation()}>
                      <div className="flex items-center justify-end gap-2">
                        <button 
                          onClick={() => handleViewDetails(asset)}
                          className="p-2 hover:bg-blue-100 rounded-xl transition-colors"
                          title="View Details"
                        >
                          <Package className="h-4 w-4 text-blue-600" />
                        </button>
                        <button 
                          onClick={() => handleOpenModal(asset)}
                          className="p-2 hover:bg-gray-100 rounded-xl transition-colors"
                          title="Edit"
                        >
                          <Edit className="h-4 w-4 text-gray-600" />
                        </button>
                        <button 
                          onClick={() => handleDelete(asset.id)}
                          className="p-2 hover:bg-red-50 rounded-xl transition-colors"
                          title="Delete"
                        >
                          <Trash2 className="h-4 w-4 text-red-600" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
        
        {/* Pagination info */}
        {!loading && filteredAssets.length > 0 && (
          <div className="px-6 py-4 border-t border-gray-200 bg-gray-50/50">
            <div className="text-sm text-gray-600">
              Showing <span className="font-semibold">{filteredAssets.length}</span> of <span className="font-semibold">{assets.length}</span> assets
            </div>
          </div>
        )}
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

      {/* Asset Detail Modal */}
      {showDetailModal && selectedAsset && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 px-8 py-6 flex items-center justify-between rounded-t-3xl">
              <div>
                <h2 className="text-2xl font-bold text-gray-900">{selectedAsset.name}</h2>
                <p className="text-sm text-gray-500 mt-1">{selectedAsset.category} • {selectedAsset.serial_number}</p>
              </div>
              <button 
                onClick={() => setShowDetailModal(false)}
                className="p-2 hover:bg-gray-100 rounded-xl transition-colors"
              >
                <X className="h-6 w-6 text-gray-600" />
              </button>
            </div>

            <div className="p-8">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Basic Information */}
                <div className="md:col-span-2 bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-4">Basic Information</h3>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Asset Name</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.name}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Serial Number</p>
                      <p className="text-sm font-mono font-medium text-gray-900">{selectedAsset.serial_number || 'N/A'}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Category</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.category}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Status</p>
                      <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${
                        selectedAsset.status === 'active' ? 'bg-green-100 text-green-700' :
                        selectedAsset.status === 'in_stock' ? 'bg-blue-100 text-blue-700' :
                        selectedAsset.status === 'maintenance' ? 'bg-yellow-100 text-yellow-700' :
                        'bg-gray-100 text-gray-700'
                      }`}>
                        {selectedAsset.status || 'active'}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Hardware Details */}
                <div className="bg-gray-50 rounded-2xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-4">Hardware Details</h3>
                  <div className="space-y-3">
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Manufacturer</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.manufacturer || 'N/A'}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Model</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.model || 'N/A'}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Condition</p>
                      <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${getConditionColor(selectedAsset.condition)}`}>
                        {selectedAsset.condition}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Location & Assignment */}
                <div className="bg-gray-50 rounded-2xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-4">Location & Assignment</h3>
                  <div className="space-y-3">
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Location</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.location}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Assigned To</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.assigned_to || <span className="text-gray-400 italic">Unassigned</span>}</p>
                    </div>
                  </div>
                </div>

                {/* Financial Information */}
                <div className="bg-green-50 rounded-2xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center justify-between">
                    <span>Financial Information</span>
                    <span className="text-xs font-semibold text-gray-600 bg-white px-3 py-1 rounded-full">
                      💰 AED
                    </span>
                  </h3>
                  <div className="space-y-3">
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Purchase Cost</p>
                      <p className="text-lg font-bold text-gray-900">{formatCurrency(selectedAsset.purchase_cost || 0)}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Current Value</p>
                      <p className="text-lg font-bold text-gray-900">{formatCurrency(selectedAsset.current_value || 0)}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Purchase Date</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.purchase_date || 'N/A'}</p>
                    </div>
                  </div>
                </div>

                {/* Warranty Information */}
                <div className="bg-yellow-50 rounded-2xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-4">Warranty Information</h3>
                  <div className="space-y-3">
                    <div>
                      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Warranty Expiry</p>
                      <p className="text-sm font-medium text-gray-900">{selectedAsset.warranty_expiry || 'N/A'}</p>
                    </div>
                    {selectedAsset.warranty_expiry && (
                      <div>
                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Warranty Status</p>
                        <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${
                          new Date(selectedAsset.warranty_expiry) > new Date()
                            ? 'bg-green-100 text-green-700'
                            : 'bg-red-100 text-red-700'
                        }`}>
                          {new Date(selectedAsset.warranty_expiry) > new Date() ? 'Active' : 'Expired'}
                        </span>
                      </div>
                    )}
                  </div>
                </div>

                {/* Description & Notes */}
                {(selectedAsset.description || selectedAsset.notes) && (
                  <div className="md:col-span-2 bg-gray-50 rounded-2xl p-6">
                    <h3 className="text-lg font-bold text-gray-900 mb-4">Additional Information</h3>
                    {selectedAsset.description && (
                      <div className="mb-4">
                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Description</p>
                        <p className="text-sm text-gray-700 whitespace-pre-wrap">{selectedAsset.description}</p>
                      </div>
                    )}
                    {selectedAsset.notes && (
                      <div>
                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Notes</p>
                        <p className="text-sm text-gray-700 whitespace-pre-wrap">{selectedAsset.notes}</p>
                      </div>
                    )}
                  </div>
                )}
              </div>

              {/* Action Buttons */}
              <div className="mt-8 flex gap-4 justify-end">
                <button
                  onClick={() => {
                    setQRAsset(selectedAsset);
                    setShowQRModal(true);
                  }}
                  className="flex items-center gap-2 px-6 py-3 border border-purple-300 text-purple-700 bg-purple-50 rounded-xl font-semibold hover:bg-purple-100 transition-colors"
                >
                  <QrCode className="h-4 w-4" />
                  Generate QR
                </button>
                <button
                  onClick={() => {
                    setShowDetailModal(false);
                    handleOpenModal(selectedAsset);
                  }}
                  className="flex items-center gap-2 px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
                >
                  <Edit className="h-4 w-4" />
                  Edit Asset
                </button>
                <button
                  onClick={() => setShowDetailModal(false)}
                  className="px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Bulk Operations Modal */}
      {showBulkModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md">
            <div className="p-6 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-gray-900">
                  {bulkAction === 'assign' && 'Bulk Assign Assets'}
                  {bulkAction === 'transfer' && 'Bulk Transfer Location'}
                  {bulkAction === 'status' && 'Bulk Update Status'}
                  {bulkAction === 'condition' && 'Bulk Update Condition'}
                </h2>
                <button
                  onClick={() => { setShowBulkModal(false); setBulkValue(''); }}
                  className="text-gray-400 hover:text-gray-600 transition-colors"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
              <p className="text-sm text-gray-600 mt-2">
                Updating {selectedAssets.length} selected asset(s)
              </p>
            </div>

            <div className="p-6 space-y-4">
              {bulkAction === 'assign' && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Assign To *
                  </label>
                  <input
                    type="text"
                    value={bulkValue}
                    onChange={(e) => setBulkValue(e.target.value)}
                    placeholder="Enter employee name or department"
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>
              )}

              {bulkAction === 'transfer' && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Transfer to Location *
                  </label>
                  <select
                    value={bulkValue}
                    onChange={(e) => setBulkValue(e.target.value)}
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  >
                    <option value="">Select Location</option>
                    {locations.map(loc => (
                      <option key={loc} value={loc}>{loc}</option>
                    ))}
                  </select>
                </div>
              )}

              {bulkAction === 'status' && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Update Status *
                  </label>
                  <select
                    value={bulkValue}
                    onChange={(e) => setBulkValue(e.target.value)}
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  >
                    <option value="">Select Status</option>
                    <option value="active">Active</option>
                    <option value="in_stock">In Stock</option>
                    <option value="maintenance">Maintenance</option>
                    <option value="retired">Retired</option>
                    <option value="disposed">Disposed</option>
                  </select>
                </div>
              )}

              {bulkAction === 'condition' && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Update Condition *
                  </label>
                  <select
                    value={bulkValue}
                    onChange={(e) => setBulkValue(e.target.value)}
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  >
                    <option value="">Select Condition</option>
                    <option value="excellent">Excellent</option>
                    <option value="good">Good</option>
                    <option value="fair">Fair</option>
                    <option value="poor">Poor</option>
                  </select>
                </div>
              )}
            </div>

            <div className="p-6 border-t border-gray-200 flex gap-3 justify-end">
              <button
                onClick={() => { setShowBulkModal(false); setBulkValue(''); }}
                className="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleBulkUpdate}
                className="px-6 py-2.5 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors"
              >
                Update {selectedAssets.length} Asset(s)
              </button>
            </div>
          </div>
        </div>
      )}

      {/* QR Code Modal */}
      {showQRModal && qrAsset && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg">
            <div className="p-6 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-purple-100 rounded-xl">
                    <QrCode className="h-6 w-6 text-purple-600" />
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900">Asset QR Code</h3>
                    <p className="text-sm text-gray-500">Scan to view asset details</p>
                  </div>
                </div>
                <button
                  onClick={() => setShowQRModal(false)}
                  className="p-2 hover:bg-gray-100 rounded-xl transition-colors"
                >
                  <X className="h-5 w-5 text-gray-500" />
                </button>
              </div>
            </div>

            <div className="p-8">
              {/* Asset Info */}
              <div className="mb-6 p-4 bg-gradient-to-r from-purple-50 to-blue-50 rounded-2xl">
                <h4 className="font-bold text-gray-900 mb-2">{qrAsset.name}</h4>
                <div className="space-y-1 text-sm">
                  <p className="text-gray-600"><span className="font-semibold">Serial:</span> {qrAsset.serial_number || 'N/A'}</p>
                  <p className="text-gray-600"><span className="font-semibold">Category:</span> {qrAsset.category}</p>
                  <p className="text-gray-600"><span className="font-semibold">Status:</span> {qrAsset.status}</p>
                </div>
              </div>

              {/* QR Code Display */}
              <div className="flex justify-center mb-6">
                <div className="p-6 bg-white border-4 border-gray-200 rounded-2xl shadow-lg">
                  <QRCodeCanvas
                    id={`qr-canvas-${qrAsset.id}`}
                    value={JSON.stringify({
                      id: qrAsset.id,
                      name: qrAsset.name,
                      serial_number: qrAsset.serial_number,
                      category: qrAsset.category,
                      url: `${typeof window !== 'undefined' ? window.location.origin : ''}/assets?id=${qrAsset.id}`
                    })}
                    size={200}
                    level="H"
                    includeMargin={true}
                  />
                </div>
              </div>

              {/* Instructions */}
              <div className="mb-6 p-4 bg-blue-50 rounded-xl border border-blue-200">
                <p className="text-sm text-blue-800">
                  <span className="font-semibold">Tip:</span> Download and print this QR code to attach to your asset. 
                  Scanning it will provide instant access to all asset information.
                </p>
              </div>
            </div>

            <div className="p-6 border-t border-gray-200 flex gap-3 justify-end">
              <button
                onClick={() => setShowQRModal(false)}
                className="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
              >
                Close
              </button>
              <button
                onClick={() => downloadQRCode(qrAsset)}
                className="flex items-center gap-2 px-6 py-2.5 bg-gradient-to-r from-purple-500 to-blue-500 text-white rounded-xl font-semibold hover:from-purple-600 hover:to-blue-600 transition-all shadow-lg"
              >
                <Download className="h-4 w-4" />
                Download QR Code
              </button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
};

export default Assets;