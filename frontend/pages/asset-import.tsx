import React, { useState } from 'react';
import Layout from '../components/Layout';
import { Upload, Download, FileText, CheckCircle, AlertCircle, X, Server, Cpu, HardDrive, Laptop, Monitor, Smartphone, Radio, Tablet, Printer, Mouse } from 'lucide-react';
import { assetsAPI } from '../utils/api';

interface ImportResult {
  success: boolean;
  row: number;
  name: string;
  message: string;
}

type TemplateType = 'server' | 'switch' | 'storage' | 'laptop' | 'desktop' | 'monitor' | 'mobile' | 'walkie' | 'tablet' | 'printer' | 'peripherals';

const AssetImport = () => {
  const [file, setFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [results, setResults] = useState<ImportResult[]>([]);
  const [showResults, setShowResults] = useState(false);
  const [templateType, setTemplateType] = useState<TemplateType>('server');

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
      setResults([]);
      setShowResults(false);
    }
  };

  const downloadTemplate = (type: TemplateType = templateType) => {
    let template = '';
    let filename = '';

    switch(type) {
      case 'server':
        template = `Asset Name,Location,Model Name,Configuration,Serial No,Year Of Purchase,Warranty end,Asset Code,Physical/Virtual,IP Address,Mac Address,ILO IP
ONEHVMH2,Head Office,HP ProLiant DL380 Gen 10,2x Intel Xeon Silver 4210R | 64GB RAM | 4TB Storage,CZJ1020F01,2020,2025-12-15,1H-00001,Physical,192.168.1.10,00:1A:2B:3C:4D:5E,192.168.1.100
ONEHVMH1,Head Office,HP ProLiant DL380 Gen 11,2x Intel Xeon Gold 6430 | 128GB RAM | 8TB Storage,CZ2D2507J3,2023,2028-02-02,1H-00002,Physical,192.168.1.11,00:1A:2B:3C:4D:5F,192.168.1.101`;
        filename = 'server_import_template.csv';
        break;

      case 'switch':
        template = `Asset Name,Location,Model Name,Configuration,Serial No,Year Of Purchase,Warranty end,Asset Code,IP Address,Mac Address
SWITCH-CORE-01,Head Office,HP 2620-48 POE+,48-Port Gigabit PoE+ Switch,CN36J3N09H,2018,2023-06-15,1H-00099,192.168.1.252,B4:39:D6:3E:6F:2C
FIREWALL-01,Head Office,SonicWall NSa 2650,Next-Gen Firewall,18E81C27A026,2020,2025-01-15,1H-00100,192.168.1.253,2C:B8:ED:29:97:40`;
        filename = 'switch_import_template.csv';
        break;

      case 'storage':
        template = `Asset Name,Location,Model Name,Configuration,Serial number,Year Of Purchase,Warranty end,Asset Code,IP Address,Mac Address
ONEH-BACKUP,Head Office,Synology DS720+,2-Bay NAS | 8GB RAM | 2x4TB WD Red,2110QWR9N711R,2021,2024-08-15,1H-00103,192.168.1.94,00:11:32:6F:4A:E9
FILESERVER,Head Office,Synology RS1221+ Rackmount,8-Bay Rackmount NAS | 16GB RAM,2470RWR75W8CT,2024,2027-06-15,1H-00104,192.168.1.98,00:11:32:A3:8F:C5`;
        filename = 'storage_import_template.csv';
        break;

      case 'laptop':
        template = `Asset Name,Location,Model Name,OS Version,Memory,CPU Type,Storage,Serial No,Year Of Purchase,Warranty end,Transferred To,Department,Issue Date,Asset Code,Previous Owner,Sentinel,Ninja,Domain/Non Domain,In Office Location,Function
ONEH-SURESH-ALA,Spanish Villa,Lenovo ThinkPad T14s Gen 5,Windows 11 Pro,16 GB,Intel Core Ultra 7 155U,512 GB,5CD048LR8R,2024,2027-09-25,Suresh Pulivini,Housekeeping,25-Sep-24,1H-00200,,Done,Done,Non Domain,Spanish Villa,Operation
ONEH-JOHN-LAPTOP,Head Office,HP EliteBook 840 G8,Windows 11 Pro,16 GB,Intel Core i7-1165G7,512 GB,5CD0123456,2023,2026-05-15,John Doe,IT,15-May-23,1H-00201,,Done,Done,Domain,Head Office,Admin`;
        filename = 'laptop_import_template.csv';
        break;

      case 'desktop':
        template = `Asset Name,Location,Model Name,OS Version,Memory,CPU Type,Storage,Serial No,Year Of Purchase,Warranty end,Transferred To,Department,Issue Date,Asset Code,Previous Owner,Sentinel,Ninja,Domain/Non Domain,In Office Location,Function
ONEH-RANJEET,Head Office,HP Pro Tower 290 G9 Desktop PC,Windows 11 Pro,8 GB,12th Gen Intel Core i5-12400,500 GB,4CE323CR0Q,2023,2025-10-18,Ranjeet Yadav,Finance,19-Oct-23,1H-00300,,Done,Done,Domain,Document Control Office,Admin
ONEH-SUNITA,Head Office,HP Pro Tower 290 G9 Desktop PC,Windows 11 Pro,16 GB,12th Gen Intel Core i7-12700,512 GB,4CE334D27Y,2023,2025-12-13,Sunita Ghale,Finance,14-Nov-23,1H-00301,,Done,Done,Domain,Finance Office,Admin`;
        filename = 'desktop_import_template.csv';
        break;

      case 'monitor':
        template = `Asset Name,Location,Model Name,Configuration,Serial No,Year Of Purchase,Warranty end,Transferred To,Department,Issued Date,Asset Code,Previous Owner
,Head Office,HP X24ih FDH Monitor,,1CR1411S15,2023,2026-01-15,Mariam Eissa,Finance,15-Jan-23,1H-00160,
,Head Office,Lenovo T27i-30 27inch Monitor,,V5TDG923,2024,2027-05-20,Sreejith Achuthan,Procurement,20-May-24,1H-00161,`;
        filename = 'monitor_import_template.csv';
        break;

      case 'mobile':
        template = `Asset Name,Location,Model Name,Configuration,Serial number,IMEI,Year Of Purchase,Warranty end,Transferred To,Department,Issue Date,Asset Code,Previous Owner,Date Received
ONEH-MOBILE-001,Head Office,iPhone 14 Pro,256GB,ABC123456,123456789012345,2023,2025-06-15,John Doe,IT,15-Jun-23,1H-00400,,15-Jun-23
ONEH-MOBILE-002,Head Office,Samsung Galaxy S23,128GB,DEF789012,987654321098765,2023,2025-08-20,Jane Smith,HR,20-Aug-23,1H-00401,,20-Aug-23`;
        filename = 'mobile_import_template.csv';
        break;

      case 'walkie':
        template = `Asset Name,Location,Model Name,Configuration,Serial No,Year Of Purchase,Warranty end,Transferred To,Department,Issued Date,Previous Owner,Department,Issued Date
WALKIE-001,Spanish Villa,Motorola DP4400e,UHF 403-527MHz,1234567890,2022,2025-03-15,Security Team,Security,15-Mar-22,,,
WALKIE-002,Head Office,Hytera PD785G,DMR Digital,0987654321,2023,2026-01-20,Maintenance,Maintenance,20-Jan-23,,,`;
        filename = 'walkie_import_template.csv';
        break;

      case 'tablet':
        template = `Location,Model Name,Configuration,Serial No.,Year Of Purchase,Warranty end,Transferred To,Department,Issued Date,Asset Code,Previous Owner
Head Office,iPad Pro 12.9,256GB WiFi+Cellular,ABC123DEF456,2023,2026-04-10,Project Manager,Project,10-Apr-23,1H-00500,
Spanish Villa,Samsung Galaxy Tab S8,128GB WiFi,GHI789JKL012,2024,2027-02-15,Manager,Operations,15-Feb-24,1H-00501,`;
        filename = 'tablet_import_template.csv';
        break;

      case 'printer':
        template = `Model Name,Configuration,Serial No,Year Of Purchase,Warranty end,Transferred To,Department,Issued Date,Asset Code,IP Address/USB,Remarks
HP LaserJet Pro M404dn,Duplex Network Printer,VNC1A23456,2022,2025-05-10,Finance,Finance,10-May-22,1H-00600,192.168.1.50,Main office printer
Canon imageRUNNER ADVANCE DX C3826i,Multifunction Color Printer,ABC9876543,2023,2026-08-15,HR,HR,15-Aug-23,1H-00601,192.168.1.51,HR department MFP`;
        filename = 'printer_import_template.csv';
        break;

      case 'peripherals':
        template = `Asset Name,Location,Model Name,Configuration,Serial No.,Year Of Purchase,Warranty end,Transferred To,Department,Issued Date,Asset Code
KEYBOARD-001,Head Office,Logitech MX Keys,Wireless Bluetooth,2123ABC456,2023,2025-01-15,IT Department,IT,15-Jan-23,1H-00700
MOUSE-001,Head Office,Logitech MX Master 3,Wireless Ergonomic,2123DEF789,2023,2025-01-15,IT Department,IT,15-Jan-23,1H-00701`;
        filename = 'peripherals_import_template.csv';
        break;
    }

    const blob = new Blob([template], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  };

  const parseCSV = (text: string): Record<string, string>[] => {
    const lines = text.split('\n').filter(line => line.trim());
    const headers = lines[0].split(',').map(h => h.trim());
    
    return lines.slice(1).map(line => {
      const values = line.split(',').map(v => v.trim());
      const row: Record<string, string> = {};
      
      headers.forEach((header, index) => {
        row[header] = values[index] || '';
      });
      
      return row;
    });
  };

  const mapRowToAsset = (row: Record<string, string>, type: TemplateType): any => {
    const baseAsset = {
      name: row['Asset Name'] || '',
      location: row['Location'] || 'Head Office',
      model: row['Model Name'] || '',
      serial_number: row['Serial No'] || row['Serial No.'] || row['Serial number'] || '',
      status: 'active'
    };

    let category = '';
    let notes = '';
    let description = '';

    switch(type) {
      case 'server':
        category = 'Server';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Physical/Virtual'] ? `Type: ${row['Physical/Virtual']}` : '',
          row['IP Address'] ? `IP: ${row['IP Address']}` : '',
          row['Mac Address'] ? `MAC: ${row['Mac Address']}` : '',
          row['ILO IP'] ? `ILO IP: ${row['ILO IP']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'switch':
        category = 'Switch';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['IP Address'] ? `IP: ${row['IP Address']}` : '',
          row['Mac Address'] ? `MAC: ${row['Mac Address']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'storage':
        category = 'Storage';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['IP Address'] ? `IP: ${row['IP Address']}` : '',
          row['Mac Address'] ? `MAC: ${row['Mac Address']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'laptop':
        category = 'Laptop';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issue Date'] ? `Issued: ${row['Issue Date']}` : '',
          row['Previous Owner'] ? `Previous: ${row['Previous Owner']}` : '',
          row['Sentinel'] ? `Sentinel: ${row['Sentinel']}` : '',
          row['Ninja'] ? `Ninja: ${row['Ninja']}` : '',
          row['Domain/Non Domain'] ? `Domain: ${row['Domain/Non Domain']}` : '',
          row['In Office Location'] ? `Office: ${row['In Office Location']}` : '',
          row['Function'] ? `Function: ${row['Function']}` : ''
        ].filter(Boolean).join(' | ');
        description = `${row['OS Version'] || ''} | ${row['Memory'] || ''} | ${row['CPU Type'] || ''} | ${row['Storage'] || ''}`;
        break;

      case 'desktop':
        category = 'Desktop';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issue Date'] ? `Issued: ${row['Issue Date']}` : '',
          row['Previous Owner'] ? `Previous: ${row['Previous Owner']}` : '',
          row['Sentinel'] ? `Sentinel: ${row['Sentinel']}` : '',
          row['Ninja'] ? `Ninja: ${row['Ninja']}` : '',
          row['Domain/Non Domain'] ? `Domain: ${row['Domain/Non Domain']}` : '',
          row['In Office Location'] ? `Office: ${row['In Office Location']}` : '',
          row['Function'] ? `Function: ${row['Function']}` : ''
        ].filter(Boolean).join(' | ');
        description = `${row['OS Version'] || ''} | ${row['Memory'] || ''} | ${row['CPU Type'] || ''} | ${row['Storage'] || ''}`;
        break;

      case 'monitor':
        category = 'Monitor';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issued Date'] ? `Issued: ${row['Issued Date']}` : '',
          row['Previous Owner'] ? `Previous: ${row['Previous Owner']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'mobile':
        category = 'Mobile Phone';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['IMEI'] ? `IMEI: ${row['IMEI']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issue Date'] ? `Issued: ${row['Issue Date']}` : '',
          row['Previous Owner'] ? `Previous: ${row['Previous Owner']}` : '',
          row['Date Received'] ? `Received: ${row['Date Received']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'walkie':
        category = 'Walkie Talkie';
        notes = [
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issued Date'] ? `Issued: ${row['Issued Date']}` : '',
          row['Previous Owner'] ? `Previous: ${row['Previous Owner']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'tablet':
        category = 'Tablet';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issued Date'] ? `Issued: ${row['Issued Date']}` : '',
          row['Previous Owner'] ? `Previous: ${row['Previous Owner']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'printer':
        category = 'Printer';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issued Date'] ? `Issued: ${row['Issued Date']}` : '',
          row['IP Address/USB'] ? `Connection: ${row['IP Address/USB']}` : '',
          row['Remarks'] ? `Remarks: ${row['Remarks']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;

      case 'peripherals':
        category = 'IT Peripherals';
        notes = [
          row['Asset Code'] ? `Asset Code: ${row['Asset Code']}` : '',
          row['Transferred To'] ? `Assigned: ${row['Transferred To']}` : '',
          row['Department'] ? `Dept: ${row['Department']}` : '',
          row['Issued Date'] ? `Issued: ${row['Issued Date']}` : ''
        ].filter(Boolean).join(' | ');
        description = row['Configuration'] || '';
        break;
    }

    return {
      ...baseAsset,
      category,
      notes,
      description,
      warranty_expiry: row['Warranty end'] || null
    };
  };

  const handleImport = async () => {
    if (!file) return;

    setImporting(true);
    setResults([]);

    try {
      const text = await file.text();
      const rows = parseCSV(text);
      const importResults: ImportResult[] = [];

      for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        
        try {
          const asset = mapRowToAsset(row, templateType);
          
          // Validate required fields
          if (!asset.serial_number && !asset.name) {
            importResults.push({
              success: false,
              row: i + 2,
              name: asset.name || 'Unknown',
              message: 'Missing required fields (Asset Name or Serial Number)'
            });
            continue;
          }

          // Create asset
          await assetsAPI.create(asset);

          importResults.push({
            success: true,
            row: i + 2,
            name: asset.name || asset.serial_number,
            message: 'Successfully imported'
          });
        } catch (error: any) {
          importResults.push({
            success: false,
            row: i + 2,
            name: row['Asset Name'] || row['Model Name'] || 'Unknown',
            message: error.message || 'Import failed'
          });
        }
      }

      setResults(importResults);
      setShowResults(true);
    } catch (error) {
      console.error('Error reading file:', error);
      alert('Error reading file. Please ensure it is a valid CSV file.');
    } finally {
      setImporting(false);
    }
  };

  const successCount = results.filter(r => r.success).length;
  const errorCount = results.filter(r => !r.success).length;

  const categoryInfo = {
    server: { icon: Server, label: 'Server', color: 'blue' },
    switch: { icon: Cpu, label: 'Switch', color: 'green' },
    storage: { icon: HardDrive, label: 'Storage', color: 'purple' },
    laptop: { icon: Laptop, label: 'Laptop', color: 'indigo' },
    desktop: { icon: Monitor, label: 'Desktop', color: 'cyan' },
    monitor: { icon: Monitor, label: 'Monitor', color: 'pink' },
    mobile: { icon: Smartphone, label: 'Mobile Phone', color: 'yellow' },
    walkie: { icon: Radio, label: 'Walkie Talkie', color: 'orange' },
    tablet: { icon: Tablet, label: 'Tablet', color: 'teal' },
    printer: { icon: Printer, label: 'Printer', color: 'red' },
    peripherals: { icon: Mouse, label: 'IT Peripherals', color: 'gray' }
  };

  return (
    <Layout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Asset Import</h1>
            <p className="mt-1 text-sm text-gray-500">
              Bulk import assets from CSV files - Select category and download template
            </p>
          </div>
        </div>

        {/* Template Type Selector */}
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Select Asset Category</h2>
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
            {(Object.keys(categoryInfo) as TemplateType[]).map((type) => {
              const info = categoryInfo[type];
              const Icon = info.icon;
              return (
                <button
                  key={type}
                  onClick={() => setTemplateType(type)}
                  className={`p-4 border-2 rounded-lg text-left transition-all ${
                    templateType === type
                      ? 'border-blue-500 bg-blue-50'
                      : 'border-gray-200 hover:border-blue-300'
                  }`}
                >
                  <Icon className={`h-6 w-6 mb-2 ${templateType === type ? 'text-blue-600' : 'text-gray-400'}`} />
                  <div className="font-medium text-sm text-gray-900">{info.label}</div>
                </button>
              );
            })}
          </div>
          <div className="mt-4 flex justify-end">
            <button
              onClick={() => downloadTemplate(templateType)}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              <Download className="h-4 w-4 mr-2" />
              Download {categoryInfo[templateType].label} Template
            </button>
          </div>
        </div>

        {/* Import Instructions */}
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-6">
          <div className="flex">
            <FileText className="h-6 w-6 text-blue-600 mr-3" />
            <div className="flex-1">
              <h3 className="text-lg font-medium text-blue-900 mb-2">
                How to Import Assets
              </h3>
              <ol className="list-decimal list-inside space-y-2 text-sm text-blue-800">
                <li>Select your asset category above (Server, Switch, Storage, Laptop, Desktop, Monitor, etc.)</li>
                <li>Download the appropriate CSV template for your asset type</li>
                <li>Fill in your asset data following the exact column headers in the template</li>
                <li>Each category has specific columns:
                  <ul className="list-disc list-inside ml-6 mt-1 space-y-1">
                    <li><strong>Server:</strong> IP Address, MAC Address, ILO IP, Physical/Virtual</li>
                    <li><strong>Switch:</strong> IP Address, MAC Address</li>
                    <li><strong>Laptop/Desktop:</strong> OS, Memory, CPU, Storage, Assigned user, Department, Domain status</li>
                    <li><strong>Monitor:</strong> Assigned user, Department, Issue date</li>
                    <li><strong>Mobile:</strong> IMEI, Configuration, Assigned user</li>
                    <li><strong>Printer:</strong> IP Address/USB, Department, Remarks</li>
                  </ul>
                </li>
                <li>Required fields: Asset Name or Serial Number must be provided</li>
                <li>Upload your completed CSV file and click "Import Assets"</li>
              </ol>
            </div>
          </div>
        </div>

        {/* File Upload */}
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Upload CSV File</h2>
          
          <div className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center">
            <Upload className="mx-auto h-12 w-12 text-gray-400 mb-4" />
            
            {file ? (
              <div className="space-y-4">
                <div className="flex items-center justify-center space-x-2">
                  <FileText className="h-5 w-5 text-green-500" />
                  <span className="text-sm font-medium text-gray-900">{file.name}</span>
                  <button
                    onClick={() => setFile(null)}
                    className="text-red-500 hover:text-red-700"
                  >
                    <X className="h-4 w-4" />
                  </button>
                </div>
                <p className="text-xs text-gray-500">
                  {(file.size / 1024).toFixed(2)} KB
                </p>
              </div>
            ) : (
              <div>
                <label htmlFor="file-upload" className="cursor-pointer">
                  <span className="text-sm font-medium text-blue-600 hover:text-blue-500">
                    Choose a file
                  </span>
                  <input
                    id="file-upload"
                    name="file-upload"
                    type="file"
                    accept=".csv"
                    className="sr-only"
                    onChange={handleFileChange}
                  />
                </label>
                <p className="text-xs text-gray-500 mt-2">CSV files only</p>
              </div>
            )}
          </div>

          {file && (
            <div className="mt-6 flex justify-end">
              <button
                onClick={handleImport}
                disabled={importing}
                className="inline-flex items-center px-6 py-3 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400"
              >
                {importing ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    Importing...
                  </>
                ) : (
                  <>
                    <Upload className="h-4 w-4 mr-2" />
                    Import Assets
                  </>
                )}
              </button>
            </div>
          )}
        </div>

        {/* Import Results */}
        {showResults && (
          <div className="bg-white shadow rounded-lg p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-lg font-medium text-gray-900">Import Results</h2>
              <button
                onClick={() => setShowResults(false)}
                className="text-gray-400 hover:text-gray-500"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* Summary */}
            <div className="grid grid-cols-3 gap-4 mb-6">
              <div className="bg-gray-50 rounded-lg p-4">
                <div className="text-sm text-gray-500">Total Rows</div>
                <div className="text-2xl font-bold text-gray-900">{results.length}</div>
              </div>
              <div className="bg-green-50 rounded-lg p-4">
                <div className="text-sm text-green-600">Successful</div>
                <div className="text-2xl font-bold text-green-900">{successCount}</div>
              </div>
              <div className="bg-red-50 rounded-lg p-4">
                <div className="text-sm text-red-600">Failed</div>
                <div className="text-2xl font-bold text-red-900">{errorCount}</div>
              </div>
            </div>

            {/* Detailed Results */}
            <div className="space-y-2 max-h-96 overflow-y-auto">
              {results.map((result, index) => (
                <div
                  key={index}
                  className={`flex items-start p-3 rounded-lg ${
                    result.success ? 'bg-green-50' : 'bg-red-50'
                  }`}
                >
                  {result.success ? (
                    <CheckCircle className="h-5 w-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" />
                  ) : (
                    <AlertCircle className="h-5 w-5 text-red-500 mr-3 mt-0.5 flex-shrink-0" />
                  )}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between">
                      <p className={`text-sm font-medium ${
                        result.success ? 'text-green-900' : 'text-red-900'
                      }`}>
                        Row {result.row}: {result.name}
                      </p>
                    </div>
                    <p className={`text-xs mt-1 ${
                      result.success ? 'text-green-700' : 'text-red-700'
                    }`}>
                      {result.message}
                    </p>
                  </div>
                </div>
              ))}
            </div>

            {successCount > 0 && (
              <div className="mt-6 pt-6 border-t border-gray-200">
                <p className="text-sm text-gray-600">
                  Successfully imported {successCount} asset(s). 
                  <a href="/assets" className="text-blue-600 hover:text-blue-700 ml-1">
                    View all assets →
                  </a>
                </p>
              </div>
            )}
          </div>
        )}

        {/* Quick Actions */}
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Quick Actions</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <button
              onClick={() => window.location.href = '/assets'}
              className="flex items-center justify-center px-4 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              View All Assets
            </button>
            <button
              onClick={() => downloadTemplate(templateType)}
              className="flex items-center justify-center px-4 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              <Download className="h-4 w-4 mr-2" />
              Download Template
            </button>
            <button
              onClick={() => {
                setFile(null);
                setResults([]);
                setShowResults(false);
              }}
              className="flex items-center justify-center px-4 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Reset Form
            </button>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default AssetImport;
