import React, { useState, useEffect, useMemo } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { Plus, Save, X, AlertCircle, CheckCircle, RefreshCw } from 'lucide-react';
import { 
  assetsAPI, 
  categoriesAPI, 
  departmentsAPI,
  locationsAPI,
  manufacturersAPI,
  modelsAPI,
  osVersionsAPI,
  cpuTypesAPI,
  ramSizesAPI,
  storageSizesAPI,
  assetCodeAPI
} from '../utils/api';
import SearchableDropdown from '../components/SearchableDropdown';

interface Department {
  id: string;
  name: string;
}

interface MasterDataItem {
  id: string;
  name: string;
}

// Define which fields are visible for each category
const CATEGORY_FIELDS: Record<string, string[]> = {
  'Desktop': ['manufacturer', 'model', 'serialNumber', 'osVersion', 'cpuType', 'memory', 'storage', 'ipAddress', 'macAddress', 'sentinel', 'ninja', 'domain'],
  'Laptop': ['manufacturer', 'model', 'serialNumber', 'osVersion', 'cpuType', 'memory', 'storage', 'ipAddress', 'macAddress', 'sentinel', 'ninja', 'domain'],
  'Server': ['manufacturer', 'model', 'serialNumber', 'osVersion', 'cpuType', 'memory', 'storage', 'ipAddress', 'macAddress', 'iloIp', 'physicalVirtual', 'sentinel', 'ninja', 'domain'],
  'Monitor': ['manufacturer', 'model', 'serialNumber'],
  'Switch': ['manufacturer', 'model', 'serialNumber', 'ipAddress', 'macAddress'],
  'Storage': ['manufacturer', 'model', 'serialNumber', 'storage', 'ipAddress'],
  'Printer': ['manufacturer', 'model', 'serialNumber', 'ipAddress', 'macAddress'],
  'Mobile Phone': ['manufacturer', 'model', 'serialNumber', 'osVersion', 'storage'],
  'Walkie Talkie': ['manufacturer', 'model', 'serialNumber'],
  'Tablet': ['manufacturer', 'model', 'serialNumber', 'osVersion', 'storage'],
  'IT Peripherals': ['manufacturer', 'model', 'serialNumber'],
  'Other': ['manufacturer', 'model', 'serialNumber', 'specifications']
};

const AddAsset = () => {
  const router = useRouter();
  const { id: editId, mode } = router.query;
  const isEditMode = mode === 'edit' && !!editId;
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [categories, setCategories] = useState<string[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  
  // Master data for searchable dropdowns
  const [locations, setLocations] = useState<MasterDataItem[]>([]);
  const [manufacturers, setManufacturers] = useState<MasterDataItem[]>([]);
  const [models, setModels] = useState<MasterDataItem[]>([]);
  const [osVersions, setOsVersions] = useState<MasterDataItem[]>([]);
  const [cpuTypes, setCpuTypes] = useState<MasterDataItem[]>([]);
  const [ramSizes, setRamSizes] = useState<MasterDataItem[]>([]);
  const [storageSizes, setStorageSizes] = useState<MasterDataItem[]>([]);
  const [masterDataLoading, setMasterDataLoading] = useState(true);

  // Form state - Basic Information
  const [name, setName] = useState('');
  const [assetCode, setAssetCode] = useState('');
  const [assetCodeLoading, setAssetCodeLoading] = useState(false);
  const [category, setCategory] = useState('Desktop');
  const [location, setLocation] = useState('');
  const [inOfficeLocation, setInOfficeLocation] = useState('');
  const [description, setDescription] = useState('');

  // Hardware Details
  const [manufacturer, setManufacturer] = useState('');
  const [model, setModel] = useState('');
  const [serialNumber, setSerialNumber] = useState('');
  
  // Technical Specifications
  const [osVersion, setOsVersion] = useState('');
  const [cpuType, setCpuType] = useState('');
  const [memory, setMemory] = useState('');
  const [storage, setStorage] = useState('');
  const [specifications, setSpecifications] = useState('');

  // Network Information
  const [ipAddress, setIpAddress] = useState('');
  const [macAddress, setMacAddress] = useState('');
  const [iloIp, setIloIp] = useState('');

  // Assignment & Ownership
  const [assignedTo, setAssignedTo] = useState('');
  const [departmentId, setDepartmentId] = useState('');
  const [previousOwner, setPreviousOwner] = useState('');

  // Status & Condition
  const [status, setStatus] = useState<'active' | 'in_stock' | 'maintenance' | 'retired' | 'disposed' | 'not_upgradable'>('active');
  const [condition, setCondition] = useState<'excellent' | 'good' | 'fair' | 'poor'>('good');

  // Financial & Warranty
  const [purchaseDate, setPurchaseDate] = useState('');
  const [purchaseCost, setPurchaseCost] = useState('');
  const [currentValue, setCurrentValue] = useState('');
  const [warrantyExpiry, setWarrantyExpiry] = useState('');
  const [yearOfPurchase, setYearOfPurchase] = useState('');

  // Software & Security
  const [sentinelStatus, setSentinelStatus] = useState('');
  const [ninjaStatus, setNinjaStatus] = useState('');
  const [domainStatus, setDomainStatus] = useState('');

  // Additional Information
  const [functionType, setFunctionType] = useState('');
  const [physicalVirtual, setPhysicalVirtual] = useState('');
  const [issueDate, setIssueDate] = useState('');
  const [transferredDate, setTransferredDate] = useState('');
  const [notes, setNotes] = useState('');
  const [maintenanceSchedule, setMaintenanceSchedule] = useState('');

  useEffect(() => {
    loadCategories();
    loadDepartments();
    loadMasterData();
  }, []);

  // Auto-generate asset code when category changes (only in add mode)
  useEffect(() => {
    if (!isEditMode && category) {
      generateAssetCode();
    }
  }, [category, isEditMode]);

  // Auto-calculate condition based on purchase date
  useEffect(() => {
    if (purchaseDate) {
      const calculatedCondition = calculateConditionFromAge(purchaseDate);
      setCondition(calculatedCondition);
    }
  }, [purchaseDate]);

  // Calculate condition based on asset age
  const calculateConditionFromAge = (dateString: string): 'excellent' | 'good' | 'fair' | 'poor' => {
    const purchaseDateObj = new Date(dateString);
    const now = new Date();
    const ageInYears = (now.getTime() - purchaseDateObj.getTime()) / (365.25 * 24 * 60 * 60 * 1000);
    
    if (ageInYears <= 1) return 'excellent';
    if (ageInYears <= 3) return 'good';
    if (ageInYears <= 4) return 'fair';
    return 'poor';
  };

  // Generate asset code
  const generateAssetCode = async () => {
    setAssetCodeLoading(true);
    try {
      const code = await assetCodeAPI.generate(category);
      setAssetCode(code);
    } catch (error) {
      console.error('Error generating asset code:', error);
    } finally {
      setAssetCodeLoading(false);
    }
  };

  // Load all master data
  const loadMasterData = async () => {
    setMasterDataLoading(true);
    try {
      const [
        locationsData,
        manufacturersData,
        modelsData,
        osVersionsData,
        cpuTypesData,
        ramSizesData,
        storageSizesData
      ] = await Promise.all([
        locationsAPI.getAll(),
        manufacturersAPI.getAll(),
        modelsAPI.getAll(),
        osVersionsAPI.getAll(),
        cpuTypesAPI.getAll(),
        ramSizesAPI.getAll(),
        storageSizesAPI.getAll()
      ]);
      
      setLocations(locationsData || []);
      setManufacturers(manufacturersData || []);
      setModels(modelsData || []);
      setOsVersions(osVersionsData || []);
      setCpuTypes(cpuTypesData || []);
      setRamSizes(ramSizesData || []);
      setStorageSizes(storageSizesData || []);
    } catch (error) {
      console.error('Error loading master data:', error);
    } finally {
      setMasterDataLoading(false);
    }
  };

  // Check if a field should be visible for current category
  const isFieldVisible = (fieldName: string): boolean => {
    const fields = CATEGORY_FIELDS[category] || CATEGORY_FIELDS['Other'];
    return fields.includes(fieldName);
  };

  const loadCategories = async () => {
    try {
      const data = await categoriesAPI.getAll();
      setCategories(data?.map(c => c.name) || [
        'Server', 'Switch', 'Storage', 'Laptop', 'Desktop', 'Monitor',
        'Mobile Phone', 'Walkie Talkie', 'Tablet', 'Printer', 'IT Peripherals', 'Other'
      ]);
    } catch (error) {
      console.error('Error loading categories:', error);
      setCategories(['Server', 'Switch', 'Storage', 'Laptop', 'Desktop', 'Monitor',
        'Mobile Phone', 'Walkie Talkie', 'Tablet', 'Printer', 'IT Peripherals', 'Other']);
    }
  };

  const loadDepartments = async () => {
    try {
      const data = await departmentsAPI.getAll();
      setDepartments(data || []);
    } catch (error) {
      console.error('Error loading departments:', error);
    }
  };

  // Handler for adding new master data items
  const handleAddLocation = async (newValue: string) => {
    const newItem = await locationsAPI.create(newValue);
    if (newItem) {
      setLocations(prev => [...prev, newItem]);
      setLocation(newItem.name);
    }
  };

  const handleAddManufacturer = async (newValue: string) => {
    const newItem = await manufacturersAPI.create(newValue);
    if (newItem) {
      setManufacturers(prev => [...prev, newItem]);
      setManufacturer(newItem.name);
    }
  };

  const handleAddModel = async (newValue: string) => {
    const newItem = await modelsAPI.create(newValue);
    if (newItem) {
      setModels(prev => [...prev, newItem]);
      setModel(newItem.name);
    }
  };

  const handleAddOsVersion = async (newValue: string) => {
    const newItem = await osVersionsAPI.create(newValue);
    if (newItem) {
      setOsVersions(prev => [...prev, newItem]);
      setOsVersion(newItem.name);
    }
  };

  const handleAddCpuType = async (newValue: string) => {
    const newItem = await cpuTypesAPI.create(newValue);
    if (newItem) {
      setCpuTypes(prev => [...prev, newItem]);
      setCpuType(newItem.name);
    }
  };

  const handleAddRamSize = async (newValue: string) => {
    const newItem = await ramSizesAPI.create(newValue);
    if (newItem) {
      setRamSizes(prev => [...prev, newItem]);
      setMemory(newItem.name);
    }
  };

  const handleAddStorageSize = async (newValue: string) => {
    const newItem = await storageSizesAPI.create(newValue);
    if (newItem) {
      setStorageSizes(prev => [...prev, newItem]);
      setStorage(newItem.name);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation
    if (!name || !category || !location) {
      setError('Please fill in all required fields (Name, Category, Location)');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const assetData = {
        name,
        asset_code: assetCode || null,
        category,
        location,
        in_office_location: inOfficeLocation || null,
        description: description || null,
        manufacturer: manufacturer || null,
        model: model || null,
        serial_number: serialNumber || null,
        os_version: osVersion || null,
        cpu_type: cpuType || null,
        memory: memory || null,
        storage: storage || null,
        specifications: specifications || null,
        ip_address: ipAddress || null,
        mac_address: macAddress || null,
        ilo_ip: iloIp || null,
        assigned_to: assignedTo || null,
        department_id: departmentId || null,
        previous_owner: previousOwner || null,
        status,
        condition,
        purchase_date: purchaseDate || null,
        purchase_cost: purchaseCost ? parseFloat(purchaseCost) : 0,
        current_value: currentValue ? parseFloat(currentValue) : 0,
        warranty_expiry: warrantyExpiry || null,
        year_of_purchase: yearOfPurchase ? parseInt(yearOfPurchase) : null,
        sentinel_status: sentinelStatus || null,
        ninja_status: ninjaStatus || null,
        domain_status: domainStatus || null,
        function: functionType || null,
        physical_virtual: physicalVirtual || null,
        issue_date: issueDate || null,
        transferred_date: transferredDate || null,
        notes: notes || null,
        maintenance_schedule: maintenanceSchedule || null,
      };

      await assetsAPI.create(assetData);
      setSuccess(true);
      setTimeout(() => {
        router.push('/assets');
      }, 2000);
    } catch (err: any) {
      console.error('Error creating asset:', err);
      setError(err.message || 'Failed to create asset');
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    router.push('/assets');
  };

  return (
    <Layout>
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl font-bold text-gray-800 flex items-center gap-2">
              <Plus size={28} className="text-blue-600" />
              {isEditMode ? 'Edit Asset' : 'Add New Asset'}
            </h1>
            <p className="text-gray-600 mt-1">
              {isEditMode ? 'Update asset information below' : 'Enter asset information below'}
            </p>
            {/* Category indicator */}
            {category && (
              <span className="inline-block mt-2 px-3 py-1 bg-blue-100 text-blue-800 text-sm rounded-full">
                Category: {category}
              </span>
            )}
          </div>
          <button
            onClick={handleCancel}
            className="px-4 py-2 text-gray-600 hover:text-gray-800 flex items-center gap-2"
          >
            <X size={20} />
            Cancel
          </button>
        </div>

        {/* Success Message */}
        {success && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <CheckCircle className="text-green-600 flex-shrink-0" size={24} />
            <div>
              <h3 className="font-semibold text-green-800">Asset Created Successfully!</h3>
              <p className="text-green-700 text-sm">Redirecting to assets list...</p>
            </div>
          </div>
        )}

        {/* Error Message */}
        {error && (
          <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 flex items-start gap-3">
            <AlertCircle className="text-red-600 flex-shrink-0" size={24} />
            <div>
              <h3 className="font-semibold text-red-800">Error</h3>
              <p className="text-red-700 text-sm">{error}</p>
            </div>
          </div>
        )}

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Basic Information */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Basic Information
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Asset Name <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., ONEH-RANJEET"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Asset Code
                  <span className="text-xs text-gray-500 ml-2">(Auto-generated)</span>
                </label>
                <div className="flex gap-2">
                  <input
                    type="text"
                    value={assetCode}
                    onChange={(e) => setAssetCode(e.target.value)}
                    className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-gray-50"
                    placeholder={assetCodeLoading ? 'Generating...' : 'e.g., DSK-25-0001'}
                    readOnly={!isEditMode}
                  />
                  <button
                    type="button"
                    onClick={generateAssetCode}
                    disabled={assetCodeLoading}
                    className="px-3 py-2 bg-gray-100 border border-gray-300 rounded-lg hover:bg-gray-200 disabled:opacity-50"
                    title="Regenerate code"
                  >
                    <RefreshCw size={18} className={assetCodeLoading ? 'animate-spin' : ''} />
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Category <span className="text-red-500">*</span>
                </label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                >
                  {categories.map(cat => (
                    <option key={cat} value={cat}>{cat}</option>
                  ))}
                </select>
              </div>

              <div>
                <SearchableDropdown
                  label="Location"
                  required
                  options={locations.map(l => ({ value: l.name, label: l.name }))}
                  value={location}
                  onChange={setLocation}
                  placeholder="Search or select location..."
                  allowAdd
                  onAddNew={handleAddLocation}
                  addNewLabel="Add New Location"
                  disabled={masterDataLoading}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  In-Office Location
                </label>
                <input
                  type="text"
                  value={inOfficeLocation}
                  onChange={(e) => setInOfficeLocation(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., Finance Office, Admin Office"
                />
              </div>

              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Description
                </label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  rows={2}
                  placeholder="Brief description of the asset"
                />
              </div>
            </div>
          </div>

          {/* Hardware Details - Show based on category */}
          {(isFieldVisible('manufacturer') || isFieldVisible('model') || isFieldVisible('serialNumber')) && (
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Hardware Details
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {isFieldVisible('manufacturer') && (
              <div>
                <SearchableDropdown
                  label="Manufacturer"
                  options={manufacturers.map(m => ({ value: m.name, label: m.name }))}
                  value={manufacturer}
                  onChange={setManufacturer}
                  placeholder="Search or select manufacturer..."
                  allowAdd
                  onAddNew={handleAddManufacturer}
                  addNewLabel="Add New Manufacturer"
                  disabled={masterDataLoading}
                />
              </div>
              )}

              {isFieldVisible('model') && (
              <div>
                <SearchableDropdown
                  label="Model"
                  options={models.map(m => ({ value: m.name, label: m.name }))}
                  value={model}
                  onChange={setModel}
                  placeholder="Search or select model..."
                  allowAdd
                  onAddNew={handleAddModel}
                  addNewLabel="Add New Model"
                  disabled={masterDataLoading}
                />
              </div>
              )}

              {isFieldVisible('serialNumber') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Serial Number
                </label>
                <input
                  type="text"
                  value={serialNumber}
                  onChange={(e) => setSerialNumber(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 4CE323CR0Q"
                />
              </div>
              )}
            </div>
          </div>
          )}

          {/* Technical Specifications - Show based on category */}
          {(isFieldVisible('osVersion') || isFieldVisible('cpuType') || isFieldVisible('memory') || isFieldVisible('storage')) && (
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Technical Specifications
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {isFieldVisible('osVersion') && (
              <div>
                <SearchableDropdown
                  label="OS Version"
                  options={osVersions.map(os => ({ value: os.name, label: os.name }))}
                  value={osVersion}
                  onChange={setOsVersion}
                  placeholder="Search or select OS..."
                  allowAdd
                  onAddNew={handleAddOsVersion}
                  addNewLabel="Add New OS Version"
                  disabled={masterDataLoading}
                />
              </div>
              )}

              {isFieldVisible('cpuType') && (
              <div>
                <SearchableDropdown
                  label="CPU Type"
                  options={cpuTypes.map(cpu => ({ value: cpu.name, label: cpu.name }))}
                  value={cpuType}
                  onChange={setCpuType}
                  placeholder="Search or select CPU..."
                  allowAdd
                  onAddNew={handleAddCpuType}
                  addNewLabel="Add New CPU Type"
                  disabled={masterDataLoading}
                />
              </div>
              )}

              {isFieldVisible('memory') && (
              <div>
                <SearchableDropdown
                  label="Memory (RAM)"
                  options={ramSizes.map(ram => ({ value: ram.name, label: ram.name }))}
                  value={memory}
                  onChange={setMemory}
                  placeholder="Search or select RAM..."
                  allowAdd
                  onAddNew={handleAddRamSize}
                  addNewLabel="Add New RAM Size"
                  disabled={masterDataLoading}
                />
              </div>
              )}

              {isFieldVisible('storage') && (
              <div>
                <SearchableDropdown
                  label="Storage"
                  options={storageSizes.map(s => ({ value: s.name, label: s.name }))}
                  value={storage}
                  onChange={setStorage}
                  placeholder="Search or select storage..."
                  allowAdd
                  onAddNew={handleAddStorageSize}
                  addNewLabel="Add New Storage Size"
                  disabled={masterDataLoading}
                />
              </div>
              )}

              {isFieldVisible('specifications') && (
              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Additional Specifications
                </label>
                <textarea
                  value={specifications}
                  onChange={(e) => setSpecifications(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  rows={2}
                  placeholder="Other technical specifications (pipe-delimited)"
                />
              </div>
              )}
            </div>
          </div>
          )}

          {/* Network Information - Show based on category */}
          {(isFieldVisible('ipAddress') || isFieldVisible('macAddress') || isFieldVisible('iloIp')) && (
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Network Information
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {isFieldVisible('ipAddress') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  IP Address
                </label>
                <input
                  type="text"
                  value={ipAddress}
                  onChange={(e) => setIpAddress(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 192.168.1.10"
                />
              </div>
              )}

              {isFieldVisible('macAddress') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  MAC Address
                </label>
                <input
                  type="text"
                  value={macAddress}
                  onChange={(e) => setMacAddress(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 00:1A:2B:3C:4D:5E"
                />
              </div>
              )}

              {isFieldVisible('iloIp') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  ILO/iDRAC IP (Servers)
                </label>
                <input
                  type="text"
                  value={iloIp}
                  onChange={(e) => setIloIp(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 192.168.1.100"
                />
              </div>
              )}
            </div>
          </div>
          )}

          {/* Assignment & Ownership - Hidden in edit mode */}
          {!isEditMode && (
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Assignment & Ownership
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Assigned To
                </label>
                <input
                  type="text"
                  value={assignedTo}
                  onChange={(e) => setAssignedTo(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., John Doe"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Department
                </label>
                <select
                  value={departmentId}
                  onChange={(e) => setDepartmentId(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Select Department</option>
                  {departments.map(dept => (
                    <option key={dept.id} value={dept.id}>{dept.name}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Previous Owner
                </label>
                <input
                  type="text"
                  value={previousOwner}
                  onChange={(e) => setPreviousOwner(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., Jane Smith"
                />
              </div>
            </div>
          </div>
          )}

          {/* Status & Condition */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Status & Condition
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Status
                </label>
                <select
                  value={status}
                  onChange={(e) => setStatus(e.target.value as any)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="active">Active</option>
                  <option value="in_stock">In Stock</option>
                  <option value="maintenance">Maintenance</option>
                  <option value="retired">Retired</option>
                  <option value="disposed">Disposed</option>
                  <option value="not_upgradable">Not Upgradable</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Condition
                  {purchaseDate && (
                    <span className="text-xs text-blue-600 ml-2">(Auto-calculated from age)</span>
                  )}
                </label>
                <select
                  value={condition}
                  onChange={(e) => setCondition(e.target.value as any)}
                  className={`w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent ${purchaseDate ? 'bg-gray-50' : ''}`}
                >
                  <option value="excellent">Excellent (≤1 year)</option>
                  <option value="good">Good (2-3 years)</option>
                  <option value="fair">Fair (4 years)</option>
                  <option value="poor">Poor (5+ years)</option>
                </select>
              </div>
            </div>
          </div>

          {/* Financial & Warranty */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Financial & Warranty
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Purchase Date
                </label>
                <input
                  type="date"
                  value={purchaseDate}
                  onChange={(e) => setPurchaseDate(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Warranty Expiry
                </label>
                <input
                  type="date"
                  value={warrantyExpiry}
                  onChange={(e) => setWarrantyExpiry(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Purchase Cost
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={purchaseCost}
                  onChange={(e) => setPurchaseCost(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="0.00"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Current Value
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={currentValue}
                  onChange={(e) => setCurrentValue(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="0.00"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Year of Purchase
                </label>
                <input
                  type="number"
                  value={yearOfPurchase}
                  onChange={(e) => setYearOfPurchase(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 2023"
                />
              </div>
            </div>
          </div>

          {/* Software & Security (for Desktops/Laptops/Servers) */}
          {(isFieldVisible('sentinel') || isFieldVisible('ninja') || isFieldVisible('domain')) && (
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Software & Security Status
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {isFieldVisible('sentinel') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Sentinel One Status
                </label>
                <select
                  value={sentinelStatus}
                  onChange={(e) => setSentinelStatus(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Not Applicable</option>
                  <option value="Done">Done</option>
                  <option value="Pending">Pending</option>
                  <option value="Not Installed">Not Installed</option>
                </select>
              </div>
              )}

              {isFieldVisible('ninja') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Ninja RMM Status
                </label>
                <select
                  value={ninjaStatus}
                  onChange={(e) => setNinjaStatus(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Not Applicable</option>
                  <option value="Done">Done</option>
                  <option value="Pending">Pending</option>
                  <option value="Not Installed">Not Installed</option>
                </select>
              </div>
              )}

              {isFieldVisible('domain') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Domain Status
                </label>
                <select
                  value={domainStatus}
                  onChange={(e) => setDomainStatus(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Not Applicable</option>
                  <option value="Domain">Domain</option>
                  <option value="Non Domain">Non Domain</option>
                  <option value="Workgroup">Workgroup</option>
                </select>
              </div>
              )}
            </div>
          </div>
          )}

          {/* Additional Information */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Additional Information
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Function
                </label>
                <select
                  value={functionType}
                  onChange={(e) => setFunctionType(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Select Function</option>
                  <option value="Admin">Admin</option>
                  <option value="Operation">Operation</option>
                </select>
              </div>

              {isFieldVisible('physicalVirtual') && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Physical/Virtual (Servers)
                </label>
                <select
                  value={physicalVirtual}
                  onChange={(e) => setPhysicalVirtual(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Not Applicable</option>
                  <option value="Physical">Physical</option>
                  <option value="Virtual">Virtual</option>
                </select>
              </div>
              )}

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Issue Date
                </label>
                <input
                  type="date"
                  value={issueDate}
                  onChange={(e) => setIssueDate(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Transferred Date
                </label>
                <input
                  type="date"
                  value={transferredDate}
                  onChange={(e) => setTransferredDate(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Maintenance Schedule
                </label>
                <select
                  value={maintenanceSchedule}
                  onChange={(e) => setMaintenanceSchedule(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Not Applicable</option>
                  <option value="monthly">Monthly</option>
                  <option value="quarterly">Quarterly</option>
                  <option value="annually">Annually</option>
                </select>
              </div>

              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Notes
                </label>
                <textarea
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  rows={3}
                  placeholder="Additional notes or comments"
                />
              </div>
            </div>
          </div>

          {/* Form Actions */}
          <div className="flex justify-end gap-3 pt-4">
            <button
              type="button"
              onClick={handleCancel}
              className="px-6 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 flex items-center gap-2"
              disabled={loading}
            >
              <X size={18} />
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <Save size={18} />
              {loading ? (isEditMode ? 'Updating...' : 'Creating...') : (isEditMode ? 'Update Asset' : 'Create Asset')}
            </button>
          </div>
        </form>
      </div>
    </Layout>
  );
};

export default AddAsset;
