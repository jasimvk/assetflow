# Asset Import SQL Files - Complete Guide

## Overview
This directory contains 10 category-specific SQL import scripts that populate your Supabase database with real inventory data from your organization. Each file is designed to be run independently in the Supabase SQL Editor.

## Files Created

### 1. **import_assets_servers.sql**
- **Category**: Server
- **Count**: 9 assets (2 physical hosts, 7 virtual machines)
- **Key Features**:
  - Physical servers: ONEHVMH2, ONEHVMH1 with ILO management IPs
  - Virtual machines running on physical hosts
  - Includes IP addresses, MAC addresses, and detailed specifications
  - Asset codes for tracking

### 2. **import_assets_network.sql**
- **Category**: Switch (includes all network equipment)
- **Count**: 9 devices
- **Breakdown**:
  - 2× HP 2620-48 POE+ Switches
  - 1× SonicWall NSa 2650 Firewall
  - 6× UniFi Access Points (4× AC Pro, 2× AC Lite)
- **Key Features**:
  - IP and MAC addresses for all devices
  - Network infrastructure tracking

### 3. **import_assets_storage.sql**
- **Category**: Storage
- **Count**: 3 NAS devices
- **Breakdown**:
  - 2× Synology DS720+ (2-bay NAS)
  - 1× Synology RS1221+ (8-bay rackmount)
- **Key Features**:
  - IP addresses for network access
  - Storage capacity tracking

### 4. **import_assets_laptops.sql**
- **Category**: Laptop
- **Count**: 20 representative samples (out of 40+ total)
- **Breakdown**:
  - Lenovo ThinkPad series (E14, E15, E16, T14s Gen 5)
  - HP ProBook 440 G7
  - Dell XPS 15
  - Microsoft Surface Laptop 5
  - Apple MacBook Pro M4
- **Key Features**:
  - Full specifications (OS, RAM, CPU, Storage)
  - Assigned users and departments
  - Warranty expiry dates
  - Domain status tracking
  - Asset codes for 1H organization

### 5. **import_assets_desktops.sql**
- **Category**: Desktop
- **Count**: 20 representative samples (out of 30+ total)
- **Breakdown**:
  - HP Pro Tower 290 G9 series
  - HP ProDesk 400 G7/G6 series
  - HP 290 G4 Microtower
  - Lenovo ThinkCentre M70q G4 (2025 batch)
  - HOT Ultra 9 workstation
- **Key Features**:
  - Computer names (ONEH-USERNAME format)
  - Assigned users and departments
  - Location tracking (Head Office, kitchens, villas)
  - Warranty information

### 6. **import_assets_monitors.sql**
- **Category**: Monitor
- **Count**: 25 representative samples (out of 40+ total)
- **Breakdown**:
  - HP X24ih, V24i, P24v series (24-inch)
  - HP 27es (27-inch)
  - Dell E2218HN, P2422h, S2721QS
  - Lenovo T27i-30 (27-inch, 2025 batch)
  - Apple Studio Display (27-inch 5K)
- **Key Features**:
  - Screen sizes and resolutions
  - Assigned users matching desktop/laptop assignments
  - Asset codes
  - Department tracking

### 7. **import_assets_mobile.sql**
- **Category**: Mobile Phone (includes walkie talkies)
- **Count**: 25 representative samples (out of 60+ total)
- **Breakdown**:
  - Motorola DP4800E (2025 model)
  - Motorola SL4000E/SL4000e
- **Key Features**:
  - Serial numbers for tracking
  - Assigned to housekeeping and F&B staff
  - Location tracking (Spanish Villa, White Villa, etc.)
  - Issue dates recorded
  - Includes earpiece and charger information

### 8. **import_assets_tablets.sql**
- **Category**: Tablet
- **Count**: 6 devices (complete inventory)
- **Breakdown**:
  - 1× iPad Pro 11-inch M4 (512GB)
  - 1× iPad Pro 13-Inch WiFi+Cellular
  - 2× iPad Air 5th Gen (256GB)
  - 1× iPad Magic Keyboard
  - 1× Apple Pencil Pro
- **Key Features**:
  - Complete Apple ecosystem tracking
  - Assigned users
  - Asset codes
  - Accessories included

### 9. **import_assets_printers.sql**
- **Category**: Printer
- **Count**: 25 representative samples (out of 30+ total)
- **Breakdown**:
  - HP Color LaserJet Pro MFP (M479, M477, M283, M281 series)
  - HP Color LaserJet M554 (departmental printers)
  - Sharp multifunction copiers (BP-50C30, BP-30C25, MX-3051)
  - Fargo HDP5000 (ID card printer)
  - Zebra ZD220 (label printer)
- **Key Features**:
  - IP addresses for network printers
  - USB connection notes
  - Department assignments
  - Location details (office names)
  - Asset codes

### 10. **import_assets_peripherals.sql**
- **Category**: IT Peripherals
- **Count**: 36 representative samples (out of 40+ total)
- **Breakdown**:
  - 15× Logitech M196 mice
  - 3× Logitech M90 mice
  - 5× Logitech MK295 keyboard/mouse combos
  - 5× MOWSIL HDMI cables (1M)
  - 5× Mars MCA1000 data cables
  - 4× Heatz ZA34 power adapters (18W)
- **Key Features**:
  - Serial number tracking
  - Type categorization in notes field
  - 2025 purchase dates
  - Support equipment inventory

## How to Use These Files

### Prerequisites
1. **Run these first** (in order):
   - `asset_categories.sql` - Creates all category records
   - `assets_table.sql` - Creates the assets table structure

### Import Order (Recommended)
While the files can be run in any order after prerequisites, here's a logical sequence:

1. **Infrastructure**: Servers → Network → Storage
2. **User Equipment**: Laptops → Desktops → Monitors
3. **Mobile Devices**: Tablets → Mobile Phones/Walkie Talkies
4. **Support Equipment**: Printers → Peripherals

### Running Each File
1. Log into your Supabase project
2. Navigate to **SQL Editor**
3. Copy and paste the content of one SQL file
4. Click **Run** to execute
5. Check the verification queries at the end of each file
6. Review the summary statistics

### What Each File Does
Each import file follows this pattern:

```sql
-- 1. Ensure category exists (idempotent)
INSERT INTO categories (name, description) VALUES (...) 
ON CONFLICT (name) DO NOTHING;

-- 2. Import asset records
INSERT INTO assets (...) VALUES (...)
ON CONFLICT (serial_number) DO NOTHING;  -- Prevents duplicates

-- 3. Verification queries (run automatically)
SELECT ... FROM assets WHERE category = '...'

-- 4. Summary statistics
SELECT manufacturer, COUNT(*) ...
```

## Important Notes

### Idempotent Design
- **Safe to re-run**: All files use `ON CONFLICT DO NOTHING`
- **No duplicates**: Serial numbers are unique identifiers
- **Category protection**: Categories won't be duplicated

### Data Quality
- **Representative samples**: Large categories (laptops, desktops, monitors, mobile, printers, peripherals) include representative samples
- **Complete small sets**: Servers, network, storage, and tablets include all assets
- **Real data**: All serial numbers, IPs, MACs, and assignments are from actual inventory

### Customization
To add more assets to any category:
1. Open the relevant SQL file
2. Copy an existing INSERT statement
3. Modify the values with your new asset data
4. Run the file again

### Sample Entry Structure

```sql
INSERT INTO assets (
  name,                  -- Descriptive name
  category,              -- Must match categories table
  location,              -- Physical location
  serial_number,         -- Unique identifier
  model,                 -- Product model
  manufacturer,          -- Brand/maker
  status,                -- active|in_stock|maintenance|retired|disposed
  condition,             -- excellent|good|fair|poor
  purchase_date,         -- YYYY-MM-DD format
  warranty_expiry,       -- YYYY-MM-DD format (optional)
  description,           -- Short description
  notes,                 -- Detailed notes, IP addresses, assignments
  asset_code,            -- Organization asset code (optional)
  assigned_to,           -- User name (optional)
  department             -- Department name (optional)
) VALUES (
  'HP ProDesk 400 - Angela',
  'Desktop',
  'Head Office',
  '4CE202CCMY',
  'ProDesk 400 G7 Microtower',
  'HP',
  'active',
  'good',
  '2022-03-31',
  '2023-03-30',
  'Windows 11 Pro | 16 GB | i7-10700 | 500 GB',
  'Assigned to: Angela Joy Tabuan | Department: Finance | Domain joined',
  NULL,
  'Angela Joy Tabuan',
  'Finance'
);
```

## Verification After Import

### Check Total Assets by Category
```sql
SELECT 
  category,
  COUNT(*) as total_assets,
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as in_stock
FROM assets
GROUP BY category
ORDER BY total_assets DESC;
```

### Check Assets by Location
```sql
SELECT 
  location,
  COUNT(*) as count
FROM assets
GROUP BY location
ORDER BY count DESC;
```

### Check Assets by Department
```sql
SELECT 
  department,
  COUNT(*) as count
FROM assets
WHERE department IS NOT NULL
GROUP BY department
ORDER BY count DESC;
```

### Check Assets with Expired Warranties
```sql
SELECT 
  name,
  category,
  warranty_expiry,
  assigned_to
FROM assets
WHERE warranty_expiry < CURRENT_DATE
  AND status = 'active'
ORDER BY warranty_expiry;
```

## Summary Statistics

After importing all files, you should have approximately:

| Category | Sample Size | Notes |
|----------|------------|-------|
| Server | 9 | Complete |
| Switch | 9 | Complete |
| Storage | 3 | Complete |
| Laptop | 20 | ~50% of total inventory |
| Desktop | 20 | ~67% of total inventory |
| Monitor | 25 | ~63% of total inventory |
| Mobile Phone | 25 | ~42% of total inventory |
| Tablet | 6 | Complete |
| Printer | 25 | ~83% of total inventory |
| IT Peripherals | 36 | ~90% of total inventory |
| **TOTAL** | **178** | Representative sample |

## Next Steps

1. **Import the data**: Run all 10 SQL files in Supabase
2. **Verify imports**: Check the verification queries in each file
3. **Test the frontend**: Open the assets management page to see the imported data
4. **Add missing assets**: Use the import files as templates to add remaining assets
5. **Update assignments**: Use the frontend to update asset assignments as they change
6. **Track maintenance**: Update status to 'maintenance' when assets need service
7. **Retire old assets**: Change status to 'retired' or 'disposed' when appropriate

## Troubleshooting

### Error: "category does not exist"
- **Solution**: Run `asset_categories.sql` first

### Error: "table assets does not exist"
- **Solution**: Run `assets_table.sql` first

### Error: "duplicate key value"
- **Issue**: Trying to import an asset that already exists
- **Solution**: The `ON CONFLICT DO NOTHING` should prevent this, but if it occurs, check for duplicate serial numbers

### Assets not showing in frontend
- **Check**: Verify the category name matches exactly (case-sensitive)
- **Check**: Ensure status is valid: active, in_stock, maintenance, retired, or disposed
- **Check**: Verify the asset was actually imported (run verification queries)

## Asset Code Conventions

The organization uses the following asset code format:
- **Format**: `1H-XXXXX`
- **Example**: `1H-00026`, `1H-00158`
- **Purpose**: Internal tracking and identification
- **Note**: Not all assets have asset codes assigned yet

## Contact

For questions about the import process or data structure, refer to:
- `ASSET_MODULE_COMPLETE_FIX.md` - Frontend documentation
- `ASSET_MODULE_QUICK_REFERENCE.md` - Quick reference guide
- `DATABASE_SETUP.md` - Database schema documentation

---

**Last Updated**: February 2025  
**Import Files Version**: 1.0  
**Total Import Scripts**: 10 files  
**Total Assets (Sample)**: 178 records
