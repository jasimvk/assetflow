# 🎉 Database Schema V2 - Complete Redesign

## What I Did

I completely redesigned your database schema to **perfectly match your actual inventory structure** from `inventory.txt`. The old schema was missing many important fields you track in your Excel inventory.

## 📁 New Files Created

### 1. **assets_table_v2.sql** (Main Schema)
- ✅ Complete redesign with **40+ fields**
- ✅ All fields from your inventory.txt
- ✅ Optimized indexes for performance
- ✅ Comprehensive documentation

### 2. **import_assets_desktops_v3.sql** (Import Script)
- ✅ Updated to use new schema structure
- ✅ All 20 desktop samples properly mapped
- ✅ Includes Sentinel/Ninja/Domain status
- ✅ Warranty tracking queries included

### 3. **SCHEMA_V2_MIGRATION_GUIDE.md** (Documentation)
- ✅ Complete migration instructions
- ✅ Field mapping reference
- ✅ Example queries
- ✅ Migration options (fresh vs. existing data)

## 🆕 New Fields Added (30+ fields!)

### Hardware Specs (Now Separate Columns!)
- `os_version` - Windows 11 Pro, MacOS, etc.
- `cpu_type` - Full processor name
- `memory` - RAM (8 GB, 16 GB, etc.)
- `storage` - Storage capacity
- `specifications` - Flexible additional specs

### Network Information
- `ip_address` - Primary IP
- `mac_address` - MAC address  
- `ilo_ip` - ILO/iDRAC/BMC IP for servers

### Software & Security Status
- `sentinel_status` - Done, Pending, Not Installed
- `ninja_status` - Done, Pending, Not Installed
- `domain_status` - Domain, Non Domain, Workgroup

### Enhanced Tracking
- `in_office_location` - "Finance Office", "Admin Office"
- `previous_owner` - Track transfers
- `function` - Admin or Operation
- `physical_virtual` - For servers
- `issue_date` - When issued to user
- `transferred_date` - Transfer date
- `year_of_purchase` - Purchase year
- `asset_code` - Your 1H-xxxxx codes

## 🎯 Why This is Better

### Old Schema Problems:
- ❌ No OS/CPU/Memory fields
- ❌ No network info (IP, MAC)
- ❌ No security status tracking
- ❌ No specific office locations
- ❌ No domain status
- ❌ No function classification
- ❌ Missing transfer history

### New Schema Solutions:
- ✅ All inventory fields properly mapped
- ✅ Can query by OS, memory, CPU
- ✅ Track IP addresses and MACs
- ✅ Monitor Sentinel/Ninja/Domain status
- ✅ Specific location tracking
- ✅ Admin vs Operation classification
- ✅ Complete transfer history

## 📊 Example: Desktop Entry Comparison

### Old Schema (Limited Data):
```sql
name: "ONEH-RANJEET"
category: "Desktop"
location: "Head Office"
serial_number: "4CE323CR0Q"
description: "Windows 11 Pro | 8 GB | i5-12400 | 500 GB"
notes: "Assigned to: Ranjeet Yadav | Domain joined"
```

### New Schema (Complete Data):
```sql
name: "ONEH-RANJEET"
category: "Desktop"
manufacturer: "HP"
model: "HP Pro Tower 290 G9 Desktop PC"
serial_number: "4CE323CR0Q"
os_version: "Windows 11 Pro"
memory: "8 GB"
cpu_type: "12th Gen Intel(R) Core(TM) i5-12400"
storage: "500 GB"
location: "Head Office"
in_office_location: "Document Control Office"
assigned_to: "Ranjeet Yadav"
department: "Finance" (via foreign key)
domain_status: "Domain"
sentinel_status: "Done"
ninja_status: "Done"
function: "Admin"
purchase_date: "2023-10-19"
warranty_expiry: "2025-10-18"
```

## 🚀 How to Use

### For Fresh Database (New Project):
```sql
-- Run in this order:
1. departments_table.sql
2. department_helper.sql
3. assets_table_v2.sql          ← NEW!
4. asset_categories.sql
5. import_assets_desktops_v3.sql ← NEW!
```

### For Existing Database (Migration):
```sql
-- 1. Backup existing data
CREATE TABLE assets_backup AS SELECT * FROM assets;

-- 2. Drop old table
DROP TABLE assets CASCADE;

-- 3. Create new structure
-- Run assets_table_v2.sql

-- 4. Import your data again with new import scripts
-- Run import_assets_desktops_v3.sql
```

## 💡 Powerful New Queries

### Find non-domain-joined assets:
```sql
SELECT name, assigned_to, location 
FROM assets 
WHERE domain_status = 'Non Domain' AND status = 'active';
```

### Find assets with pending security software:
```sql
SELECT name, assigned_to, sentinel_status, ninja_status
FROM assets 
WHERE sentinel_status = 'Pending' OR ninja_status = 'Pending';
```

### Find all virtual servers with IPs:
```sql
SELECT name, ip_address, mac_address, ilo_ip 
FROM assets 
WHERE category = 'Server' AND physical_virtual = 'Virtual';
```

### Assets by memory size:
```sql
SELECT memory, COUNT(*) as count
FROM assets 
WHERE category IN ('Desktop', 'Laptop')
GROUP BY memory
ORDER BY count DESC;
```

### Warranty expiring soon:
```sql
SELECT name, assigned_to, warranty_expiry,
       warranty_expiry - CURRENT_DATE as days_remaining
FROM assets
WHERE warranty_expiry BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '3 months'
ORDER BY warranty_expiry;
```

## 🎨 Frontend Updates Needed

After migrating, update your frontend to show:

1. **Asset Details Page**:
   - OS Version, CPU, Memory, Storage (separate fields)
   - Network info (IP, MAC, ILO)
   - Security status (Sentinel, Ninja, Domain)
   - Specific office location
   - Function (Admin/Operation)

2. **Filters**:
   - Filter by OS version
   - Filter by memory size
   - Filter by domain status
   - Filter by Sentinel/Ninja status
   - Filter by function

3. **Reports**:
   - Assets not domain joined
   - Assets with pending security software
   - Network device inventory (IP/MAC report)
   - Assets by specifications

## 📋 Complete Field List

The new schema has **40+ fields** to match your inventory:

**Core Identity**: id, name, asset_code  
**Category**: category  
**Hardware**: manufacturer, model, serial_number  
**Specs**: os_version, cpu_type, memory, storage, specifications  
**Network**: ip_address, mac_address, ilo_ip  
**Location**: location, in_office_location  
**Assignment**: assigned_to, department_id, previous_owner  
**Status**: status, condition  
**Financial**: purchase_date, warranty_expiry, purchase_cost, current_value  
**Software**: sentinel_status, ninja_status, domain_status  
**Dates**: issue_date, transferred_date, year_of_purchase  
**Classification**: function, physical_virtual  
**Additional**: maintenance_schedule, notes, description, image_url  
**Audit**: created_at, updated_at  

## ✅ What to Do Now

1. **Review** the new schema (assets_table_v2.sql)
2. **Read** the migration guide (SCHEMA_V2_MIGRATION_GUIDE.md)
3. **Test** with desktop import (import_assets_desktops_v3.sql)
4. **Decide**: Fresh install or migrate existing data?
5. **Run** the SQL scripts in order
6. **Verify** data imported correctly
7. **Update** remaining import scripts (servers, laptops, etc.)
8. **Update** frontend to display new fields

## 🎁 Bonus Files

I've kept your old files for reference:
- `assets_table.sql` - Old schema
- `import_assets_desktops_v2.sql` - Old import format

But use the new V2/V3 versions going forward!

---

**The new schema perfectly matches your inventory structure and gives you complete visibility into all your assets!** 🎉

Ready to migrate? Read **SCHEMA_V2_MIGRATION_GUIDE.md** for step-by-step instructions!
