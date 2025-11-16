# Asset Import SQL Files - Quick Start

## 🚀 Quick Import Instructions

### Step 1: Prerequisites
Run these files first in your Supabase SQL Editor:
```
1. asset_categories.sql     (creates all 12 categories)
2. assets_table.sql          (creates the assets table structure)
```

### Step 2: Import Assets by Category
Run these 10 files in any order (each is independent):

| # | File Name | Category | Assets | Time |
|---|-----------|----------|---------|------|
| 1 | `import_assets_servers.sql` | Server | 9 | ~30s |
| 2 | `import_assets_network.sql` | Switch | 9 | ~30s |
| 3 | `import_assets_storage.sql` | Storage | 3 | ~15s |
| 4 | `import_assets_laptops.sql` | Laptop | 20 | ~1m |
| 5 | `import_assets_desktops.sql` | Desktop | 20 | ~1m |
| 6 | `import_assets_monitors.sql` | Monitor | 25 | ~1m |
| 7 | `import_assets_mobile.sql` | Mobile Phone | 25 | ~1m |
| 8 | `import_assets_tablets.sql` | Tablet | 6 | ~20s |
| 9 | `import_assets_printers.sql` | Printer | 25 | ~1m |
| 10 | `import_assets_peripherals.sql` | IT Peripherals | 36 | ~1m |

**Total Time**: ~7-8 minutes  
**Total Assets**: 178 records

## 📊 What Gets Imported

### Infrastructure (21 assets)
- **Servers**: 2 physical hosts + 7 VMs with IPs and MAC addresses
- **Network**: 2 switches, 1 firewall, 6 access points
- **Storage**: 3 Synology NAS devices

### User Equipment (65 assets)
- **Laptops**: 20 devices (Lenovo, HP, Dell, Microsoft, Apple)
- **Desktops**: 20 computers (HP, Lenovo)
- **Monitors**: 25 displays (HP, Dell, Lenovo, Apple)

### Mobile & Tablets (31 assets)
- **Walkie Talkies**: 25 Motorola radios (DP4800E, SL4000E)
- **Tablets**: 6 iPads (Pro, Air + accessories)

### Support Equipment (61 assets)
- **Printers**: 25 devices (HP, Sharp, Zebra, Fargo)
- **Peripherals**: 36 items (mice, keyboards, cables, adapters)

## ✅ Verification Commands

After importing, run these in Supabase SQL Editor to verify:

### Total Assets by Category
```sql
SELECT category, COUNT(*) as count
FROM assets
GROUP BY category
ORDER BY count DESC;
```

Expected output:
```
IT Peripherals  | 36
Printer         | 25
Monitor         | 25
Mobile Phone    | 25
Desktop         | 20
Laptop          | 20
Server          | 9
Switch          | 9
Tablet          | 6
Storage         | 3
```

### Active Assets by Status
```sql
SELECT status, COUNT(*) as count
FROM assets
GROUP BY status;
```

### Assets by Department
```sql
SELECT department, COUNT(*) as count
FROM assets
WHERE department IS NOT NULL
GROUP BY department
ORDER BY count DESC;
```

## 🎯 Key Features

### Idempotent (Safe to Re-run)
- ✅ Uses `ON CONFLICT DO NOTHING`
- ✅ Won't create duplicates
- ✅ Serial numbers are unique identifiers

### Real Data
- ✅ Actual serial numbers from inventory
- ✅ Real IP and MAC addresses
- ✅ Current user assignments
- ✅ Valid warranty dates
- ✅ Actual locations and departments

### Complete Information
- ✅ Full specifications (CPU, RAM, Storage, OS)
- ✅ Manufacturer and model details
- ✅ Purchase and warranty dates
- ✅ Asset codes (1H-XXXXX format)
- ✅ Assigned users and departments

## 🔧 Sample Asset Entry

Here's what each asset record contains:

```sql
(
  'Lenovo ThinkPad T14s Gen 5 - Nasif',  -- Name
  'Laptop',                               -- Category
  'Head Office',                          -- Location
  'GM0VWYR5',                            -- Serial Number (unique)
  'ThinkPad T14s Gen 5',                 -- Model
  'Lenovo',                              -- Manufacturer
  'active',                              -- Status
  'excellent',                           -- Condition
  '2025-01-01',                          -- Purchase Date
  '2028-02-03',                          -- Warranty Expiry
  'Windows 11 Pro | 16 GB | Intel Ultra 7 155U | 512 GB',  -- Description
  'Assigned to: Nasif | Department: IT | Domain joined',    -- Notes
  NULL,                                   -- Asset Code
  'Nasif',                               -- Assigned To
  'IT'                                   -- Department
)
```

## 📝 Status Values

Assets can have these status values:
- `active` - Currently in use
- `in_stock` - Available but not assigned
- `maintenance` - Under repair
- `retired` - No longer in use
- `disposed` - Removed from inventory

## 🏷️ Categories Available

All 12 categories are ready:
1. Server
2. Switch
3. Storage
4. Laptop
5. Desktop
6. Monitor
7. Mobile Phone
8. Tablet
9. Printer
10. IT Peripherals
11. Walkie Talkie (alternative for Mobile Phone)
12. Other

## 🌐 Frontend Integration

After importing:
1. Open your AssetFlow application
2. Navigate to **Assets** page
3. You'll see all 178 imported assets
4. Use filters to view by:
   - Category
   - Location
   - Status
   - Condition
5. Search by name or serial number
6. Export to CSV for reporting

## 📂 File Locations

All SQL files are in:
```
/database/
  ├── asset_categories.sql           (prerequisite)
  ├── assets_table.sql              (prerequisite)
  ├── import_assets_servers.sql
  ├── import_assets_network.sql
  ├── import_assets_storage.sql
  ├── import_assets_laptops.sql
  ├── import_assets_desktops.sql
  ├── import_assets_monitors.sql
  ├── import_assets_mobile.sql
  ├── import_assets_tablets.sql
  ├── import_assets_printers.sql
  ├── import_assets_peripherals.sql
  ├── IMPORT_GUIDE.md              (detailed guide)
  └── IMPORT_QUICK_START.md        (this file)
```

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| "category does not exist" | Run `asset_categories.sql` first |
| "table assets does not exist" | Run `assets_table.sql` first |
| "duplicate key value" | Normal - `ON CONFLICT` prevents this |
| Assets not showing | Check category name spelling (case-sensitive) |
| Wrong data | Files are safe to re-run after fixing |

## 🎉 Success Indicators

You'll know the import worked when:
- ✅ All 10 files run without errors
- ✅ Verification queries show correct counts
- ✅ Assets appear in the frontend
- ✅ Filters and search work correctly
- ✅ Asset details display properly

## 📊 Next Steps

After successful import:
1. **Review data** in frontend Assets page
2. **Update assignments** as needed
3. **Add missing assets** using same format
4. **Track maintenance** by updating status
5. **Generate reports** using CSV export
6. **Monitor warranties** for expiring assets

## 🔗 Related Documentation

- `IMPORT_GUIDE.md` - Comprehensive import documentation
- `ASSET_MODULE_COMPLETE_FIX.md` - Frontend features
- `ASSET_MODULE_QUICK_REFERENCE.md` - User guide
- `DATABASE_SETUP.md` - Database schema details

---

**Ready to import?** Start with Step 1 above! 🚀

**Estimated completion time**: 10 minutes  
**Result**: 178 assets ready to manage
