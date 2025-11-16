# Database Schema V2 - Migration Guide

## Overview
This is an improved database schema that better matches your actual inventory structure from `inventory.txt`. The new schema includes all the fields you need for comprehensive asset tracking.

## 🎯 What's New in V2

### New Fields Added
1. **Technical Specifications**
   - `os_version` - Operating system (Windows 11 Pro, MacOS, etc.)
   - `cpu_type` - Processor details
   - `memory` - RAM capacity
   - `storage` - Storage capacity
   - `specifications` - Flexible text field for additional specs

2. **Network Information**
   - `ip_address` - IP address (for servers, switches)
   - `mac_address` - MAC address
   - `ilo_ip` - ILO/iDRAC IP for servers

3. **Software & Security Status**
   - `sentinel_status` - Sentinel One antivirus (Done, Pending, Not Installed)
   - `ninja_status` - Ninja RMM status (Done, Pending, Not Installed)
   - `domain_status` - Domain join status (Domain, Non Domain, Workgroup)

4. **Enhanced Tracking**
   - `in_office_location` - Specific location within office
   - `previous_owner` - Track previous user
   - `function` - Admin, Operation classification
   - `physical_virtual` - For servers (Physical, Virtual)
   - `issue_date` - Date issued to user
   - `transferred_date` - Date transferred
   - `year_of_purchase` - Purchase year

## 📋 Migration Steps

### Option 1: Fresh Installation (Recommended for New Database)

1. **Run these scripts in order:**
   ```sql
   -- Step 1: Create departments table
   /database/departments_table.sql
   
   -- Step 2: Create department helper function
   /database/department_helper.sql
   
   -- Step 3: Create new assets table V2
   /database/assets_table_v2.sql
   
   -- Step 4: Create categories
   /database/asset_categories.sql
   
   -- Step 5: Import data
   /database/import_assets_desktops_v3.sql
   ```

### Option 2: Migrate Existing Data

If you already have data in the old assets table:

```sql
-- 1. Backup your existing data
CREATE TABLE assets_backup AS SELECT * FROM assets;

-- 2. Drop old assets table
DROP TABLE assets CASCADE;

-- 3. Run assets_table_v2.sql to create new structure

-- 4. Migrate data from backup (adjust columns as needed)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, warranty_expiry, status, condition,
    assigned_to, department_id, notes, description
)
SELECT 
    name, category, location, serial_number, model, manufacturer,
    purchase_date, warranty_expiry, status, condition,
    assigned_to, department_id, notes, description
FROM assets_backup;

-- 5. Verify data
SELECT COUNT(*) FROM assets;
SELECT COUNT(*) FROM assets_backup;

-- 6. Drop backup once verified (optional)
-- DROP TABLE assets_backup;
```

## 🔑 Key Improvements

### 1. Better Match with Inventory Structure
All fields from your Excel inventory are now properly mapped:
- ✅ OS Version, Memory, CPU, Storage as separate columns
- ✅ Network fields (IP, MAC, ILO) for servers
- ✅ Sentinel/Ninja/Domain status tracking
- ✅ Previous owner tracking
- ✅ Function and Physical/Virtual classification

### 2. Enhanced Queries
The new schema enables better reporting:

```sql
-- Find all assets not domain joined
SELECT name, assigned_to, location 
FROM assets 
WHERE domain_status = 'Non Domain' AND status = 'active';

-- Find assets with pending security software
SELECT name, assigned_to, sentinel_status, ninja_status
FROM assets 
WHERE sentinel_status = 'Pending' OR ninja_status = 'Pending';

-- Find all virtual servers
SELECT name, ip_address, ilo_ip 
FROM assets 
WHERE category = 'Server' AND physical_virtual = 'Virtual';

-- Department asset distribution
SELECT 
    d.name as department,
    COUNT(*) as total_assets,
    COUNT(CASE WHEN a.function = 'Admin' THEN 1 END) as admin_assets,
    COUNT(CASE WHEN a.function = 'Operation' THEN 1 END) as operation_assets
FROM assets a
JOIN departments d ON a.department_id = d.id
GROUP BY d.name;
```

### 3. Better Performance
- Added indexes for new fields
- Optimized for common queries
- Better support for filtering and searching

## 📊 Field Mapping from Inventory

Here's how your inventory columns map to the new database:

| Inventory Column | Database Column | Type |
|-----------------|-----------------|------|
| Asset Name | name | VARCHAR(255) |
| Location | location | VARCHAR(255) |
| Model Name | model | VARCHAR(200) |
| OS Version | os_version | VARCHAR(100) |
| Memory | memory | VARCHAR(50) |
| CPU Type | cpu_type | VARCHAR(200) |
| Storage | storage | VARCHAR(50) |
| Serial No | serial_number | VARCHAR(100) |
| Year Of Purchase | year_of_purchase | INTEGER |
| Warranty end | warranty_expiry | DATE |
| Transferred To | assigned_to | TEXT |
| Department | department_id | UUID (FK) |
| Issue Date | issue_date | DATE |
| Asset Code | asset_code | VARCHAR(50) |
| Previous Owner | previous_owner | VARCHAR(255) |
| Sentinel | sentinel_status | VARCHAR(20) |
| Ninja | ninja_status | VARCHAR(20) |
| Domain/Non Domain | domain_status | VARCHAR(50) |
| In Office Location | in_office_location | VARCHAR(255) |
| Function | function | VARCHAR(100) |
| IP Address | ip_address | VARCHAR(45) |
| Mac Address | mac_address | VARCHAR(17) |
| ILO IP | ilo_ip | VARCHAR(45) |
| Physical/Virtual | physical_virtual | VARCHAR(20) |

## 🚀 Next Steps

1. **Test the new schema** in a development environment
2. **Run import_assets_desktops_v3.sql** to see the improved structure
3. **Update remaining import scripts** (servers, laptops, etc.) to use V3 format
4. **Update frontend** to display new fields (OS, Memory, CPU, etc.)
5. **Add filters** for Sentinel/Ninja/Domain status in the UI

## ⚠️ Important Notes

1. **Run departments_table.sql FIRST** - The assets table depends on it
2. **Backup your data** before migrating existing databases
3. **Test thoroughly** before running on production
4. **Update API endpoints** to handle new fields
5. **Update TypeScript interfaces** in frontend

## 📝 Example Data

The new schema supports rich asset data:

```json
{
  "name": "ONEH-RANJEET",
  "category": "Desktop",
  "manufacturer": "HP",
  "model": "HP Pro Tower 290 G9",
  "serial_number": "4CE323CR0Q",
  "os_version": "Windows 11 Pro",
  "memory": "8 GB",
  "cpu_type": "12th Gen Intel Core i5-12400",
  "storage": "500 GB",
  "assigned_to": "Ranjeet Yadav",
  "department": "Finance",
  "location": "Head Office",
  "in_office_location": "Document Control Office",
  "status": "active",
  "condition": "good",
  "domain_status": "Domain",
  "sentinel_status": "Done",
  "ninja_status": "Done",
  "function": "Admin",
  "purchase_date": "2023-10-19",
  "warranty_expiry": "2025-10-18"
}
```

## 🎓 Benefits

1. **Complete Data** - All inventory fields properly stored
2. **Better Reporting** - Rich queries on any field
3. **Security Tracking** - Monitor Sentinel/Ninja/Domain status
4. **Network Visibility** - Track IPs and MACs
5. **Transfer History** - Previous owner tracking
6. **Flexible Specs** - Store any technical details

---

**Ready to migrate?** Follow the steps above and your database will perfectly match your inventory structure! 🎉
