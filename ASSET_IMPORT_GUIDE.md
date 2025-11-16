# Asset Import Guide

## Overview
The AssetFlow system now includes a comprehensive **Asset Import** feature that allows you to bulk upload hundreds of assets using CSV files or SQL scripts.

## Features

### 1. CSV Import (Web Interface)
- **Location**: `/asset-import` page in the frontend
- **Best for**: Small to medium imports (1-100 assets)
- **Format**: CSV (Comma-Separated Values)

#### How to Use CSV Import:

1. **Access the Import Page**
   - Navigate to "Import Assets" in the sidebar
   - Click "Download Template" to get the CSV template

2. **Fill Out the Template**
   ```csv
   name,category,location,serial_number,model,manufacturer,purchase_date,purchase_cost,current_value,warranty_expiry,condition,status,assigned_to,notes,description
   ONEH-LAPTOP-001,Computer,Head Office,ABC123456,ThinkPad T14s Gen 5,Lenovo,2024-01-15,35000,34000,2027-01-15,excellent,active,John Doe,Transfer from IT,Windows 11 Pro 16GB RAM
   ```

3. **Required Fields**
   - `name`: Asset name/identifier (e.g., ONEH-LAPTOP-001)
   - `category`: Computer, Server, Network Equipment, Storage, Other
   - `serial_number`: Unique serial number (must be unique across all assets)

4. **Optional Fields**
   - `location`: Where the asset is located
   - `model`: Product model number
   - `manufacturer`: HP, Dell, Lenovo, etc.
   - `purchase_date`: Format YYYY-MM-DD
   - `purchase_cost`: Original purchase price
   - `current_value`: Current depreciated value
   - `warranty_expiry`: Format YYYY-MM-DD
   - `condition`: excellent, good, fair, poor
   - `status`: active, in_stock, maintenance, retired, disposed
   - `assigned_to`: User name
   - `notes`: Additional notes
   - `description`: Detailed specifications

5. **Upload and Import**
   - Click "Choose a file" and select your CSV
   - Review the preview
   - Click "Import Assets"
   - View the results showing successful and failed imports

### 2. SQL Import (Supabase Dashboard)
- **Location**: `/database/` folder contains pre-built SQL files
- **Best for**: Large imports (100+ assets)
- **Format**: SQL INSERT statements

#### Available SQL Import Files:

1. **`import_server_inventory.sql`** - 9 servers
   - HP Proliant physical and virtual servers
   - Network details (IP, MAC, ILO)
   - Specifications (CPU, RAM, Storage)

2. **`import_network_equipment.sql`** - 9 devices
   - HP switches
   - SonicWall firewall
   - Ubiquiti access points

3. **`import_storage_inventory.sql`** - 3 devices
   - Synology NAS units
   - Network storage devices

4. **`import_laptop_inventory.sql`** - 80+ devices
   - Lenovo, HP, Dell, Microsoft laptops
   - Complete user assignments
   - Transfer history

5. **`import_desktop_inventory.sql`** - 40+ devices
   - HP Pro Towers, HP ProDesks
   - Lenovo ThinkCentres
   - Dell OptiPlex systems

#### How to Use SQL Import:

1. **Access Supabase Dashboard**
   - Log into your Supabase project
   - Navigate to SQL Editor

2. **Run Import Files in Order**
   ```sql
   -- Run these one at a time:
   1. import_server_inventory.sql
   2. import_network_equipment.sql
   3. import_storage_inventory.sql
   4. import_laptop_inventory.sql
   5. import_desktop_inventory.sql
   ```

3. **Verify Import**
   ```sql
   -- Check total assets imported
   SELECT category, COUNT(*) as count, SUM(current_value) as total_value
   FROM assets
   GROUP BY category
   ORDER BY count DESC;
   ```

## Data Validation

### Automatic Validations:
- ✅ Serial numbers must be unique
- ✅ Required fields cannot be empty
- ✅ Dates must be in YYYY-MM-DD format
- ✅ Numeric fields validated (costs, values)
- ✅ Category must match predefined list
- ✅ Status must match predefined list
- ✅ Condition must match predefined list

### Import Results:
The system will show:
- Total rows processed
- Successfully imported assets
- Failed imports with error messages
- Row-by-row detailed results

## Import Strategies

### Strategy 1: Small Imports (< 50 assets)
**Use CSV Import**
- Quick web-based interface
- Real-time validation
- Immediate feedback
- Easy to fix errors and re-import

### Strategy 2: Large Imports (100+ assets)
**Use SQL Import**
- Faster for bulk operations
- No timeout issues
- Can handle thousands of records
- Professional IT inventory import

### Strategy 3: Mixed Approach
1. Import bulk data via SQL (servers, laptops, desktops)
2. Use CSV for ongoing additions
3. Use web interface for single asset additions

## Best Practices

### 1. Prepare Your Data
- ✅ Ensure serial numbers are unique
- ✅ Standardize location names
- ✅ Use consistent date formats
- ✅ Validate manufacturer/model names
- ✅ Check for duplicate entries

### 2. Test First
- Import 5-10 assets as a test
- Verify they appear correctly
- Check all fields are populated
- Then proceed with full import

### 3. Backup Before Import
- Export existing assets
- Take Supabase backup
- Keep original import files

### 4. Error Handling
- Review failed imports carefully
- Common errors:
  - Duplicate serial numbers
  - Invalid dates
  - Missing required fields
  - Invalid category/status values

### 5. Post-Import Verification
```sql
-- Verify all imports
SELECT 
  category,
  status,
  COUNT(*) as count,
  SUM(current_value) as total_value
FROM assets
GROUP BY category, status
ORDER BY category, status;

-- Check for missing data
SELECT name, serial_number
FROM assets
WHERE manufacturer IS NULL OR model IS NULL;

-- Verify date ranges
SELECT MIN(purchase_date), MAX(purchase_date)
FROM assets;
```

## Complete Import Workflow

### For New System Setup:

```bash
# Step 1: Run all SQL files in Supabase SQL Editor
1. Open Supabase Dashboard
2. Go to SQL Editor
3. Copy contents of import_server_inventory.sql
4. Click "Run"
5. Repeat for all 5 SQL files

# Step 2: Verify Import
- Check Assets page shows all devices
- Verify total count matches expected
- Check categories are correct
- Verify locations are populated

# Step 3: Ongoing Additions
- Use CSV import for 1-50 new assets
- Use web form for single assets
- Use SQL for bulk updates
```

## Troubleshooting

### Issue: Duplicate Serial Number Error
**Solution**: 
- Check for existing serial in database
- Modify serial number in import file
- Or remove duplicate from import

### Issue: Import Timeout
**Solution**:
- Split CSV into smaller files (50 rows each)
- Use SQL import for large datasets
- Import during off-peak hours

### Issue: Invalid Category/Status
**Solution**:
- Valid categories: Computer, Server, Network Equipment, Storage, Other
- Valid statuses: active, in_stock, maintenance, retired, disposed
- Valid conditions: excellent, good, fair, poor

### Issue: Date Format Error
**Solution**:
- Use YYYY-MM-DD format only
- Example: 2024-01-15
- Leave blank if no date available

## Quick Reference

### CSV Template Header:
```
name,category,location,serial_number,model,manufacturer,purchase_date,purchase_cost,current_value,warranty_expiry,condition,status,assigned_to,notes,description
```

### Valid Values:

**Categories:**
- Computer
- Server
- Network Equipment
- Storage
- Other

**Statuses:**
- active
- in_stock
- maintenance
- retired
- disposed

**Conditions:**
- excellent
- good
- fair
- poor

**Date Format:**
- YYYY-MM-DD (e.g., 2024-01-15)

## Support

For issues with asset import:
1. Check this guide first
2. Review error messages carefully
3. Verify data format matches template
4. Test with small sample first
5. Contact system administrator if issues persist

## Summary

The AssetFlow import system provides:
- ✅ Web-based CSV import for easy uploads
- ✅ SQL import for bulk operations
- ✅ Real-time validation and error reporting
- ✅ Template downloads
- ✅ Detailed import results
- ✅ Support for 140+ pre-configured assets

Your complete IT inventory (servers, network equipment, storage, laptops, desktops) is ready to import with just a few clicks!
