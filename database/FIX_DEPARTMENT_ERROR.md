# 🚨 QUICK FIX: Department ID Error

## Error You're Getting
```
ERROR: 42703: column "department_id" of relation "assets" does not exist
```

## ⚡ Quick Fix (Run These in Order)

### Step 1: Create Departments Table
```sql
-- Run this in Supabase SQL Editor:
database/departments_table.sql
```
This creates the departments table with all 19 departments.

### Step 2: Create Helper Function
```sql
-- Run this in Supabase SQL Editor:
database/department_helper.sql
```
This creates the `get_department_id()` function.

### Step 3: Add department_id Column
```sql
-- Run this in Supabase SQL Editor:
database/add_department_id_quick.sql
```
This adds the `department_id` column to your existing assets table.

### Step 4: Now Run Your Import
```sql
-- Now this will work:
database/import_assets_desktops_v2.sql
```

## 📋 Complete Order (For Your Existing Database)

Since you already have:
- ✅ categories table
- ✅ assets table (but without department_id)

You need to run:

1. **departments_table.sql** (creates departments table)
2. **department_helper.sql** (creates helper function)
3. **add_department_id_quick.sql** ⚡ (adds department_id column)
4. **import_assets_desktops_v2.sql** (now will work!)

## 🔍 Verify After Step 3

Run this to check if department_id was added:

```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'assets' 
  AND column_name IN ('department', 'department_id')
ORDER BY column_name;
```

Expected output:
```
department    | character varying  ✅ (old column, kept for safety)
department_id | uuid              ✅ (new column, just added)
```

## ✅ Then You Can Import

After running steps 1-3, your import files will work:
- import_assets_desktops_v2.sql
- (And any other import files updated to use department_id)

## 💡 Why This Happened

Your assets table was created with the OLD schema (department VARCHAR).
The import_assets_desktops_v2.sql file uses the NEW schema (department_id UUID).

The quick fix script bridges the gap by adding the new column to your existing table.

---

**TL;DR**: Run these 3 files in order in Supabase SQL Editor:
1. departments_table.sql
2. department_helper.sql  
3. add_department_id_quick.sql ⚡

Then your import will work! 🎉
