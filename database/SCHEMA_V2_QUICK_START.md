# 🚀 Quick Start - Database Schema V2

## Installation Order (5 Files)

```bash
# Copy and paste these in Supabase SQL Editor, one at a time:

1️⃣  /database/departments_table.sql
    ↓ Creates 19 departments (IT, HR, Finance, etc.)

2️⃣  /database/department_helper.sql
    ↓ Creates get_department_id() function

3️⃣  /database/assets_table_v2.sql
    ↓ Creates assets table with 40+ fields

4️⃣  /database/asset_categories.sql
    ↓ Creates 12 categories

5️⃣  /database/import_assets_desktops_v3.sql
    ↓ Imports 20 desktop samples
```

## ✅ Verification Checklist

After running each script, verify:

```sql
-- After step 1: Check departments
SELECT COUNT(*) FROM departments;  -- Should be 19

-- After step 2: Test helper function
SELECT get_department_id('Finance');  -- Should return UUID

-- After step 3: Check assets table exists
SELECT COUNT(*) FROM assets;  -- Should be 0

-- After step 4: Check categories
SELECT COUNT(*) FROM categories;  -- Should be 12

-- After step 5: Check desktop imports
SELECT COUNT(*) FROM assets WHERE category = 'Desktop';  -- Should be 20
```

## 📊 What Changed from Old Schema

### Added Fields (30+ new fields!):
- **Hardware**: `os_version`, `cpu_type`, `memory`, `storage`
- **Network**: `ip_address`, `mac_address`, `ilo_ip`
- **Security**: `sentinel_status`, `ninja_status`, `domain_status`
- **Location**: `in_office_location`
- **Tracking**: `previous_owner`, `issue_date`, `function`, `physical_virtual`

### Improved:
- Better indexes for performance
- Complete field mapping from inventory.txt
- Comprehensive documentation
- Rich querying capabilities

## 🎯 Key Differences V2 vs V1

| Feature | V1 (Old) | V2 (New) |
|---------|----------|----------|
| Fields | 20 fields | 40+ fields |
| Hardware Specs | In description | Separate columns |
| Network Info | No | Yes (IP, MAC, ILO) |
| Security Status | No | Yes (Sentinel, Ninja, Domain) |
| Office Location | Generic | Specific location |
| Function | No | Admin/Operation |
| Previous Owner | No | Yes |

## 💡 Sample Queries (V2 Only)

```sql
-- Non-domain-joined assets
SELECT name, assigned_to FROM assets 
WHERE domain_status = 'Non Domain';

-- Assets with 16GB+ RAM
SELECT name, memory FROM assets 
WHERE memory LIKE '16 GB' OR memory LIKE '32 GB' OR memory LIKE '63 GB';

-- Virtual servers with IPs
SELECT name, ip_address, ilo_ip FROM assets 
WHERE physical_virtual = 'Virtual';

-- Pending security software
SELECT name, sentinel_status, ninja_status FROM assets 
WHERE sentinel_status = 'Pending' OR ninja_status = 'Pending';

-- Assets by function
SELECT function, COUNT(*) FROM assets GROUP BY function;
```

## 🔧 Troubleshooting

### Error: "relation departments does not exist"
→ Run `departments_table.sql` first

### Error: "function get_department_id() does not exist"
→ Run `department_helper.sql` second

### Error: "column xyz does not exist"
→ You're using old import scripts. Use V3 versions!

### Error: "invalid input syntax for type uuid"
→ Check column order matches the INSERT statement

## 📝 File Reference

| File | Purpose | Run Order |
|------|---------|-----------|
| `departments_table.sql` | Creates departments | 1st |
| `department_helper.sql` | Helper function | 2nd |
| `assets_table_v2.sql` | **NEW! Assets table** | 3rd |
| `asset_categories.sql` | Categories | 4th |
| `import_assets_desktops_v3.sql` | **NEW! Desktop import** | 5th |
| `SCHEMA_V2_MIGRATION_GUIDE.md` | Full guide | Read first |
| `SCHEMA_V2_SUMMARY.md` | Overview | Reference |

## 🎨 Frontend TODO

After database migration, update frontend:

- [ ] Add fields: OS Version, CPU, Memory, Storage
- [ ] Add fields: IP Address, MAC Address
- [ ] Add fields: Sentinel Status, Ninja Status, Domain Status
- [ ] Add field: In Office Location
- [ ] Add field: Function (Admin/Operation)
- [ ] Add filters for new fields
- [ ] Update TypeScript interfaces
- [ ] Add network info display for servers
- [ ] Add security status dashboard

## ⚡ Quick Commands

```bash
# Backup existing data (if you have any)
CREATE TABLE assets_backup AS SELECT * FROM assets;

# Count assets by category
SELECT category, COUNT(*) FROM assets GROUP BY category;

# See all columns in new table
\d assets;  -- In psql
# OR
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'assets' ORDER BY ordinal_position;

# Test department lookup
SELECT get_department_id('Finance'), get_department_id('IT');

# See recent imports
SELECT name, manufacturer, model, assigned_to 
FROM assets 
ORDER BY created_at DESC LIMIT 10;
```

## 🎉 Success Indicators

You'll know it's working when:
- ✅ 19 departments created
- ✅ Helper function works
- ✅ Assets table has 40+ columns
- ✅ 12 categories exist
- ✅ 20 desktops imported successfully
- ✅ JOIN queries with departments work
- ✅ All new fields are queryable

## 📚 Next Steps

1. ✅ Run the 5 SQL files in order
2. ✅ Verify each step
3. ✅ Test sample queries
4. ✅ Update remaining import scripts (servers, laptops, etc.)
5. ✅ Update frontend to show new fields
6. ✅ Enjoy your complete asset tracking system!

---

**Need help?** Check `SCHEMA_V2_MIGRATION_GUIDE.md` for detailed instructions!

**Questions?** All fields are documented in `assets_table_v2.sql` with comments!
