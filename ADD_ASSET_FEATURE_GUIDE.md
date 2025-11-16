# Add Asset Feature - User Guide

## Overview
The **Add Asset** feature allows you to create new asset records directly from the web interface with all V2 schema fields supported.

## Accessing the Feature

1. Navigate to **Assets** page from the sidebar
2. Click the **"Add New Asset"** button (blue button with plus icon) in the top-right corner
3. You'll be redirected to `/add-asset` page with the comprehensive form

## Form Sections

### 1. Basic Information (Required)
- **Asset Name*** (Required): Unique identifier (e.g., ONEH-RANJEET, DESKTOP-01)
- **Asset Code**: Organization code (e.g., 1H-00001)
- **Category*** (Required): Desktop, Laptop, Server, Monitor, etc.
- **Location*** (Required): Physical location (e.g., Head Office, Main Store)
- **In-Office Location**: Specific office (e.g., Finance Office, Admin Office)
- **Description**: Brief description of the asset

### 2. Hardware Details
- **Manufacturer**: HP, Dell, Lenovo, etc.
- **Model**: Full model name (e.g., HP Pro Tower 290 G9)
- **Serial Number**: Unique serial number

### 3. Technical Specifications
- **OS Version**: Windows 11 Pro, Ubuntu 22.04, etc.
- **CPU Type**: Processor details (e.g., Intel Core i7-12700)
- **Memory (RAM)**: RAM capacity (e.g., 16 GB, 32 GB)
- **Storage**: Storage capacity (e.g., 512 GB, 1 TB)
- **Additional Specifications**: Pipe-delimited technical details

### 4. Network Information
- **IP Address**: IPv4/IPv6 address (e.g., 192.168.1.10)
- **MAC Address**: Network MAC address (e.g., 00:1A:2B:3C:4D:5E)
- **ILO/iDRAC IP**: Management IP for servers (e.g., 192.168.1.100)

### 5. Assignment & Ownership
- **Assigned To**: Person name (e.g., John Doe)
- **Department**: Select from department dropdown
- **Previous Owner**: Previous user/owner name

### 6. Status & Condition
- **Status**: 
  - Active: Currently in use
  - In Stock: Available for assignment
  - Maintenance: Under repair
  - Retired: No longer in service
  - Disposed: Disposed of
  - Not Upgradable: Cannot be upgraded
- **Condition**:
  - Excellent: Like new
  - Good: Minor wear
  - Fair: Noticeable wear
  - Poor: Significant issues

### 7. Financial & Warranty
- **Purchase Date**: Date of purchase
- **Warranty Expiry**: Warranty end date
- **Purchase Cost**: Original purchase price
- **Current Value**: Current estimated value
- **Year of Purchase**: Year purchased (e.g., 2023)

### 8. Software & Security Status
- **Sentinel One Status**: Done, Pending, Not Installed
- **Ninja RMM Status**: Done, Pending, Not Installed
- **Domain Status**: Domain, Non Domain, Workgroup

### 9. Additional Information
- **Function**: Admin or Operation
- **Physical/Virtual**: For servers (Physical or Virtual)
- **Issue Date**: Date issued to current user
- **Transferred Date**: Date transferred to current user
- **Maintenance Schedule**: Monthly, Quarterly, Annually
- **Notes**: Additional notes or comments

## Workflow

```
1. Click "Add New Asset" button
   ↓
2. Fill in required fields (Name, Category, Location)
   ↓
3. Fill in optional fields as needed
   ↓
4. Click "Create Asset" button
   ↓
5. Success message appears
   ↓
6. Automatically redirected to Assets list
```

## Required Fields

Only **3 fields** are required:
- ✅ **Asset Name**
- ✅ **Category**
- ✅ **Location**

All other fields are optional and can be filled later or left empty.

## Tips & Best Practices

### 1. Naming Conventions
- **Desktops**: `ONEH-[USERNAME]`, `DESKTOP-[LOCATION]`
- **Laptops**: `LAPTOP-[USERNAME]`, `ONEH-[USERNAME]-LAP`
- **Servers**: `[LOCATION]VMH[NUMBER]`, `SERVER-[PURPOSE]`
- **Network**: `SWITCH-[LOCATION]-[NUMBER]`, `FIREWALL-[NUMBER]`

### 2. Serial Numbers
- Always enter serial numbers when available
- This prevents duplicate assets
- Used for warranty tracking

### 3. Departments
- Assign to correct department for accurate reporting
- Use department dropdown (populated from database)

### 4. Security Status Fields
For **Desktops and Laptops**, always update:
- ✅ **Sentinel One Status**: Track antivirus installation
- ✅ **Ninja RMM Status**: Track remote management
- ✅ **Domain Status**: Track domain join status

### 5. Network Information
For **Servers, Switches, and Network Equipment**:
- ✅ Always enter **IP Address**
- ✅ Always enter **MAC Address**
- ✅ For servers, enter **ILO IP** for remote management

### 6. Financial Information
- Enter purchase details for warranty tracking
- Keep current value updated for asset reports
- Set warranty expiry dates for alerts

## Data Validation

The form includes validation for:
- ✅ Required fields (Name, Category, Location)
- ⚠️ Numeric fields (Purchase Cost, Current Value, Year)
- ⚠️ Date fields (Purchase Date, Warranty Expiry, etc.)

## Success & Error Handling

### Success
- ✅ Green success message appears
- ✅ Asset is created in database
- ✅ Automatic redirect to Assets list (2 seconds)

### Errors
- ❌ Red error message with details
- ❌ Form stays open for corrections
- ❌ Check console for detailed error logs

## Examples

### Example 1: Adding a Desktop Computer

```
Basic Information:
- Asset Name: ONEH-JOHN
- Category: Desktop
- Location: Head Office
- In-Office Location: Finance Office

Hardware:
- Manufacturer: HP
- Model: HP Pro Tower 290 G9 Desktop PC
- Serial Number: 4CE323CR0Q

Specifications:
- OS Version: Windows 11 Pro
- CPU Type: Intel Core i7-12700
- Memory: 16 GB
- Storage: 512 GB

Assignment:
- Assigned To: John Doe
- Department: Finance

Status:
- Status: Active
- Condition: Good

Security:
- Sentinel Status: Done
- Ninja Status: Done
- Domain Status: Domain

Function: Admin
```

### Example 2: Adding a Server

```
Basic Information:
- Asset Name: ONEHVMH1
- Asset Code: 1H-00001
- Category: Server
- Location: Head Office

Hardware:
- Manufacturer: HP
- Model: HP ProLiant DL380 Gen 11
- Serial Number: CZ2D2507J3

Specifications:
- OS Version: Windows Server 2022
- CPU Type: 2x Intel Xeon Gold 6430
- Memory: 128 GB
- Storage: 8 TB
- Specifications: RAID 10 | Redundant PSU | Hot-swap drives

Network:
- IP Address: 192.168.1.11
- MAC Address: 00:1A:2B:3C:4D:5F
- ILO IP: 192.168.1.101

Status:
- Status: Active
- Condition: Excellent

Additional:
- Physical/Virtual: Physical
- Function: Operation
```

## Keyboard Shortcuts

- **Tab**: Move to next field
- **Shift + Tab**: Move to previous field
- **Enter**: Submit form (when focused on button)
- **Esc**: Cancel and return to assets list

## Mobile Support

The form is fully responsive and works on:
- 📱 Mobile phones (optimized single column)
- 📱 Tablets (2-column layout)
- 💻 Desktops (2-column layout)

## Related Features

- **View Assets**: See all assets in the main Assets page
- **Edit Assets**: Edit existing assets (inline or detail modal)
- **Import Assets**: Bulk import via CSV (asset-import page)
- **Export Assets**: Export to CSV for backup

## Troubleshooting

### Problem: "Failed to create asset"
**Solution**: Check that:
- ✅ All required fields are filled
- ✅ Serial number is unique (no duplicates)
- ✅ Database connection is working
- ✅ Check browser console for details

### Problem: Departments not loading
**Solution**:
- ✅ Ensure departments table has data
- ✅ Run departments_table.sql if needed
- ✅ Check Supabase connection

### Problem: Form not submitting
**Solution**:
- ✅ Check required fields (marked with red asterisk)
- ✅ Check browser console for validation errors
- ✅ Ensure JavaScript is enabled

## API Integration

The form uses the following API endpoints:

```typescript
// Create asset
POST /api/assets
Body: { name, category, location, ... all fields }

// Load categories
GET /api/categories

// Load departments
GET /api/departments
```

## Database Schema

All fields map directly to the `assets` table V2 schema:

```sql
assets (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  asset_code VARCHAR(50),
  category VARCHAR(100) NOT NULL,
  location VARCHAR(255) NOT NULL,
  in_office_location VARCHAR(255),
  manufacturer VARCHAR(100),
  model VARCHAR(200),
  serial_number VARCHAR(100),
  os_version VARCHAR(100),
  cpu_type VARCHAR(200),
  memory VARCHAR(50),
  storage VARCHAR(50),
  specifications TEXT,
  ip_address VARCHAR(45),
  mac_address VARCHAR(17),
  ilo_ip VARCHAR(45),
  assigned_to TEXT,
  department_id UUID REFERENCES departments(id),
  previous_owner VARCHAR(255),
  status VARCHAR(50),
  condition VARCHAR(20),
  purchase_date DATE,
  warranty_expiry DATE,
  purchase_cost DECIMAL(12,2),
  current_value DECIMAL(12,2),
  sentinel_status VARCHAR(20),
  ninja_status VARCHAR(20),
  domain_status VARCHAR(50),
  issue_date DATE,
  transferred_date DATE,
  year_of_purchase INTEGER,
  function VARCHAR(100),
  physical_virtual VARCHAR(20),
  notes TEXT,
  maintenance_schedule VARCHAR(50),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

## Next Steps

After adding assets via the frontend:

1. ✅ **View Assets**: Check the Assets page to see your new asset
2. ✅ **Generate Reports**: Use the Reports page for analytics
3. ✅ **Track Warranty**: Set up alerts for expiring warranties
4. ✅ **Assign Assets**: Assign to users and departments
5. ✅ **Maintenance**: Schedule maintenance using the form data

---

**Version**: 1.0  
**Last Updated**: November 2025  
**Schema Version**: V2 (40+ fields)
