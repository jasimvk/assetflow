# Assets Table Update - Added Department & Asset Code

## ✅ Changes Made

### New Columns Added
1. **department** - `VARCHAR(100)`
   - Stores department name (e.g., HR, IT, Finance, Operations, Housekeeping)
   - Nullable field
   - Indexed for performance

2. **asset_code** - `VARCHAR(50)`
   - Stores organization asset code (e.g., 1H-00026, 1H-00158)
   - Nullable field
   - Indexed for performance

### Files Updated

1. **assets_table.sql** ✅
   - Added `department` column after `assigned_to`
   - Added `asset_code` column after `department`
   - Added indexes for both new columns
   - Ready for fresh database setup

2. **add_department_asset_code.sql** ✅ (NEW)
   - Migration script for existing databases
   - Adds columns without recreating table
   - Safe to run on production databases
   - Includes verification query

## 🚀 How to Apply

### For NEW Databases (Fresh Setup)
Simply run `assets_table.sql` - it now includes both columns.

### For EXISTING Databases (Already Created)
Run the migration file:

```sql
-- In Supabase SQL Editor, run:
database/add_department_asset_code.sql
```

This will:
- Add `department` column if it doesn't exist
- Add `asset_code` column if it doesn't exist
- Create indexes for both columns
- Verify the columns were added successfully

## 📊 Import Files Compatibility

All 10 import SQL files now work correctly:
- ✅ import_assets_servers.sql
- ✅ import_assets_network.sql
- ✅ import_assets_storage.sql
- ✅ import_assets_laptops.sql (uses department)
- ✅ import_assets_desktops.sql (uses department)
- ✅ import_assets_monitors.sql (uses department)
- ✅ import_assets_mobile.sql (uses department)
- ✅ import_assets_tablets.sql
- ✅ import_assets_printers.sql (uses department)
- ✅ import_assets_peripherals.sql

## 🔍 Verification

After running the migration, verify with:

```sql
-- Check columns exist
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'assets'
  AND column_name IN ('department', 'asset_code')
ORDER BY column_name;

-- Check indexes exist
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'assets'
  AND indexname IN ('idx_assets_department', 'idx_assets_asset_code');
```

## 📝 Usage Examples

### Query by Department
```sql
SELECT name, category, assigned_to
FROM assets
WHERE department = 'IT'
  AND status = 'active';
```

### Query by Asset Code
```sql
SELECT name, serial_number, category, assigned_to
FROM assets
WHERE asset_code = '1H-00026';
```

### Department Summary
```sql
SELECT department, COUNT(*) as asset_count
FROM assets
WHERE department IS NOT NULL
GROUP BY department
ORDER BY asset_count DESC;
```

## 🎯 Frontend Integration

The frontend `assets.tsx` page should be updated to include these fields in the form. Add after the "Assigned To" field:

```typescript
{/* Department */}
<div>
  <label className="block text-sm font-medium mb-2">Department</label>
  <input
    type="text"
    name="department"
    value={formData.department || ''}
    onChange={handleInputChange}
    placeholder="e.g., IT, HR, Finance, Operations"
    className="w-full p-2 border rounded"
  />
</div>

{/* Asset Code */}
<div>
  <label className="block text-sm font-medium mb-2">Asset Code</label>
  <input
    type="text"
    name="asset_code"
    value={formData.asset_code || ''}
    onChange={handleInputChange}
    placeholder="e.g., 1H-00026"
    className="w-full p-2 border rounded"
  />
</div>
```

## ✨ Benefits

1. **Better Organization**: Track which department owns each asset
2. **Asset Tracking**: Organization-specific asset codes for inventory
3. **Reporting**: Generate department-specific reports
4. **Auditing**: Track asset distribution across departments
5. **Search**: Filter and search by department or asset code

---

**Status**: ✅ Ready to use  
**Migration Required**: Yes (for existing databases)  
**Breaking Changes**: None (columns are nullable)
