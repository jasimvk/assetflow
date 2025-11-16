-- QUICK FIX: Add department_id to existing assets table
-- Run this in Supabase SQL Editor RIGHT NOW to fix the error

-- Step 1: Add department_id column to assets table
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS department_id UUID REFERENCES departments(id) ON DELETE SET NULL;

-- Step 2: Create index for performance
CREATE INDEX IF NOT EXISTS idx_assets_department_id ON assets(department_id) WHERE department_id IS NOT NULL;

-- Step 3: Add comment
COMMENT ON COLUMN assets.department_id IS 'Foreign key to departments table - ensures referential integrity';

-- Step 4: Verify column was added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'assets'
  AND column_name = 'department_id';

-- DONE! Now you can run import_assets_desktops_v2.sql
