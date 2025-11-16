import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { Plus, Save, X, AlertCircle, CheckCircle } from 'lucide-react';
import { assetsAPI, categoriesAPI, departmentsAPI } from '../utils/api';

interface Department {
  id: string;
  name: string;
}

const AddAsset = () => {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [categories, setCategories] = useState<string[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);

  // Form state - Basic Information
  const [name, setName] = useState('');
  const [assetCode, setAssetCode] = useState('');
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
  }, []);

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
              Add New Asset
            </h1>
            <p className="text-gray-600 mt-1">Enter asset information below</p>
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
                </label>
                <input
                  type="text"
                  value={assetCode}
                  onChange={(e) => setAssetCode(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 1H-00001"
                />
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
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Location <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., Head Office, Main Store"
                  required
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

          {/* Hardware Details */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Hardware Details
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Manufacturer
                </label>
                <input
                  type="text"
                  value={manufacturer}
                  onChange={(e) => setManufacturer(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., HP, Lenovo, Dell"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Model
                </label>
                <input
                  type="text"
                  value={model}
                  onChange={(e) => setModel(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., HP Pro Tower 290 G9"
                />
              </div>

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
            </div>
          </div>

          {/* Technical Specifications */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Technical Specifications
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  OS Version
                </label>
                <input
                  type="text"
                  value={osVersion}
                  onChange={(e) => setOsVersion(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., Windows 11 Pro, Ubuntu 22.04"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  CPU Type
                </label>
                <input
                  type="text"
                  value={cpuType}
                  onChange={(e) => setCpuType(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., Intel Core i7-12700"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Memory (RAM)
                </label>
                <input
                  type="text"
                  value={memory}
                  onChange={(e) => setMemory(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 16 GB, 32 GB"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Storage
                </label>
                <input
                  type="text"
                  value={storage}
                  onChange={(e) => setStorage(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="e.g., 512 GB, 1 TB"
                />
              </div>

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
            </div>
          </div>

          {/* Network Information */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Network Information
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
            </div>
          </div>

          {/* Assignment & Ownership */}
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
                </label>
                <select
                  value={condition}
                  onChange={(e) => setCondition(e.target.value as any)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="excellent">Excellent</option>
                  <option value="good">Good</option>
                  <option value="fair">Fair</option>
                  <option value="poor">Poor</option>
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

          {/* Software & Security (for Desktops/Laptops) */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">
              Software & Security Status
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
            </div>
          </div>

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
              {loading ? 'Creating...' : 'Create Asset'}
            </button>
          </div>
        </form>
      </div>
    </Layout>
  );
};

export default AddAsset;
