# AssetFlow - Database Import Order Guide

## 📋 Correct Script Execution Order

Follow this exact order to successfully import all asset data into your Supabase database.

---

## ✅ Step-by-Step Import Process

### **Phase 1: Schema Setup** (One-time setup)

1. **`departments_table.sql`** - Create and populate departments
   - Creates departments table
   - Populates with IT, HR, Finance, Kitchen, Housekeeping, etc.
   - Required: Run first, all other tables reference this

2. **`populate_locations.sql`** ⭐ **NEW - Run this!**
   - Populates locations table with all physical locations
   - Includes: Head Office, Villas, Kitchens, Stores, Data Center
   - Required: Assets reference locations as foreign keys

3. **`fix_rls_complete.sql`** - Fix RLS policies
   - Disables restrictive RLS policies causing 500 errors
   - Creates permissive policies with `USING (true)`
   - Run once to fix authentication issues

4. **`fix_assigned_to_column.sql`** ⭐ **CRITICAL - Run this!**
   - Converts `assigned_to` column from UUID to TEXT
   - Drops dependent views and foreign key constraints
   - Recreates views with TEXT-based logic
   - **Required before importing laptops/desktops**

---

### **Phase 2: Asset Imports** (Run in any order after Phase 1)

5. **`import_assets_desktops_v3.sql`** - Import 34 desktop computers
   - HP, Lenovo, Dell desktops
   - Full V2 schema with OS, CPU, RAM, storage
   - Domain status, security software tracking

6. **`import_assets_laptops_v3.sql`** - Import 30 laptop computers
   - Lenovo ThinkPads, Dell XPS, MacBooks, Surface
   - Latest models with Gen 5 specs
   - Transfer tracking and previous owners

7. **`import_assets_servers_v3.sql`** - Import 9 servers
   - 2 physical HP ProLiant servers
   - 7 virtual machines
   - Network specs, ILO IPs, domain status

8. **`import_assets_switches_v3.sql`** - Import 9 network devices
   - 2 HP switches (48-port PoE+)
   - 1 SonicWall firewall
   - 6 UniFi access points

9. **`import_assets_storage_v3.sql`** - Import 3 storage devices
   - 3 Synology NAS units (DS720+, RS1221+)
   - Network storage specifications
   - IP addresses and capacities

---

## 🚨 Common Issues & Solutions

### Issue 1: "Location does not exist"
**Solution:** Run `populate_locations.sql` before importing assets

### Issue 2: "invalid input syntax for type uuid: 'Name'"
**Solution:** Run `fix_assigned_to_column.sql` to convert UUID to TEXT

### Issue 3: "RLS policy violation" or "500 error"
**Solution:** Run `fix_rls_complete.sql` to fix restrictive policies

### Issue 4: "null value in column 'purchase_cost' violates not-null constraint"
**Solution:** All import scripts now include `purchase_cost` and `current_value` (set to 0)

### Issue 5: "new row violates check constraint 'assets_condition_check'"
**Solution:** Use lowercase values: 'excellent', 'good', 'fair', 'poor' (not 'Excellent')

---

## 📊 Expected Results

After completing all imports, you should have:

| Category | Count | Status |
|----------|-------|--------|
| Desktops | 34 | ✅ Ready |
| Laptops | 30 | ✅ Ready |
| Servers | 9 | ✅ Ready |
| Network Equipment | 9 | ✅ Ready |
| Storage | 3 | ✅ Ready |
| **Total Assets** | **85** | ✅ Complete |

---

## 🔍 Verification Queries

Run these after imports to verify success:

```sql
-- Count all assets by category
SELECT 
    category,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active
FROM assets 
GROUP BY category 
ORDER BY count DESC;

-- Check locations are populated
SELECT COUNT(*) FROM locations;
-- Expected: 14 locations

-- Check departments are populated
SELECT COUNT(*) FROM departments;
-- Expected: 15+ departments

-- View recent imports
SELECT 
    name,
    category,
    manufacturer,
    model,
    assigned_to,
    location,
    created_at
FROM assets
ORDER BY created_at DESC
LIMIT 20;

-- Check assigned_to column type (should be TEXT)
SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'assets' AND column_name = 'assigned_to';
-- Expected: data_type = 'text'
```

---

## 💡 Pro Tips

1. **Run scripts one at a time** - Don't run multiple import scripts simultaneously
2. **Check for errors** - Read the Supabase SQL Editor output after each script
3. **Use verification queries** - Confirm each import before moving to the next
4. **Backup first** - Export existing data before running new imports
5. **Transaction safety** - Scripts use `BEGIN/COMMIT` for rollback capability

---

## 📝 Quick Start Checklist

- [ ] Run `departments_table.sql`
- [ ] Run `populate_locations.sql` ⭐ **NEW**
- [ ] Run `fix_rls_complete.sql`
- [ ] Run `fix_assigned_to_column.sql` ⭐ **CRITICAL**
- [ ] Run `import_assets_desktops_v3.sql`
- [ ] Run `import_assets_laptops_v3.sql`
- [ ] Run `import_assets_servers_v3.sql`
- [ ] Run `import_assets_switches_v3.sql`
- [ ] Run `import_assets_storage_v3.sql`
- [ ] Verify with count queries above

---

## 🎯 Next Steps After Import

1. **Update Frontend** - Modify `assets.tsx` to display V2 schema fields
2. **Import Remaining Assets** - Monitors, mobile devices, printers, peripherals
3. **Import Historical Data** - 50+ additional laptops from inventory
4. **Configure Filters** - Add filters for domain status, security software, locations
5. **Dashboard Updates** - Update statistics to reflect new asset counts

---

**Last Updated:** November 16, 2025  
**Total Scripts:** 9 files  
**Expected Import Time:** ~5-10 minutes
