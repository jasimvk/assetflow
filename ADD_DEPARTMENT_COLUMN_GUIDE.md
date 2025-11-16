# Add Department Relationship to Assets Table

## Problem
The `department` column was added to the frontend table display but doesn't exist in the Supabase database, causing it to show as empty.

Your database has a **separate departments table** (`departments_table.sql`), so the proper solution is to add a foreign key relationship between assets and departments.

## Solution
Add `department_id` as a foreign key to the assets table, linking to the departments table.

## Steps to Fix

### Option 1: Using Supabase Dashboard (Recommended)

1. **Ensure Departments Table Exists**
   - First, verify the departments table is created
   - If not, run `/database/departments_table.sql` first

2. **Open Supabase Dashboard**
   - Go to your Supabase project
   - Navigate to **SQL Editor** in the left sidebar

3. **Run the Migration**
   - Copy the contents of `/database/add_department_column.sql`
   - Paste into the SQL Editor
   - Click **Run** to execute
   - This will add `department_id` column as a foreign key to departments table

4. **Verify the Column**
   ```sql
   SELECT column_name, data_type, is_nullable 
   FROM information_schema.columns 
   WHERE table_name = 'assets' AND column_name = 'department_id';
   
   -- Check foreign key constraint
   SELECT conname, conrelid::regclass, confrelid::regclass
   FROM pg_constraint
   WHERE conname LIKE '%department%';
   ```

### Option 2: Using Command Line

If you have `psql` installed and Supabase connection string:

```bash
cd database
psql "your-supabase-connection-string" -f add_department_column.sql
```

## After Migration

Once the `department_id` column is added:

### 1. Populate Departments Table (if needed)
```sql
-- Check existing departments
SELECT * FROM departments ORDER BY name;

-- Add any missing departments
INSERT INTO departments (name, description, is_active) VALUES
('IT', 'Information Technology Department', true),
('HR', 'Human Resources Department', true),
('Finance', 'Finance Department', true),
('Procurement', 'Procurement Department', true),
('F&B', 'Food & Beverage Department', true),
('Housekeeping', 'Housekeeping Department', true),
('Kitchen', 'Kitchen Department', true),
('Maintenance', 'Maintenance Department', true),
('Admin', 'Administration Department', true),
('Catering', 'Catering Department', true)
ON CONFLICT (name) DO NOTHING;
```

### 2. Link Existing Assets to Departments
If your laptop import SQL already has department data as text, migrate it:
```sql
-- Update assets with department_id based on asset category or location
UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'IT')
WHERE category IN ('Server', 'Network Device', 'Desktop', 'Laptop');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Operations')
WHERE category IN ('Printer', 'Mobile Phone', 'Walkie Talkie');

-- Or bulk update based on assigned_to if you have that data
UPDATE assets a
SET department_id = d.id
FROM departments d
WHERE a.assigned_to LIKE '%IT%' AND d.name = 'IT';
```

### 3. Update Frontend to Use Department Relationship
The frontend currently displays `(asset as any).department` which won't work with the foreign key. You need to either:

**Option A: Join departments in the query** (Recommended)
- Modify the Supabase query to join departments table
- Return department name along with asset data

**Option B: Store department name directly** 
- Keep a simple VARCHAR department field instead of foreign key
- Easier for frontend but less data integrity

## What Changed

### Database Schema
- Added `department VARCHAR(100)` column to assets table
- Added index on department for faster filtering
- Updated main schema.sql file for future reference

### Frontend (Already Done)
- Department column already displays in the table
- Column is positioned between Location and Assigned To
- Shows "-" when department is null/empty

## Next Steps

After running the migration, you can:

1. **Update the add-asset form** to include department field
2. **Update the edit-asset modal** to include department field
3. **Add department filter** to the search filters
4. **Populate department** for existing assets based on category or location

Would you like me to update the add/edit forms to include the department field?
