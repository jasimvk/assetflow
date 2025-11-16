-- Migration: Add department_id foreign key to assets table
-- Date: November 16, 2025
-- Description: Adds department_id field with foreign key to departments table

-- OPTION 1: Add department_id as foreign key (RECOMMENDED)
-- This maintains referential integrity with the departments table
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS department_id UUID REFERENCES departments(id) ON DELETE SET NULL;

-- Add comment to explain the column
COMMENT ON COLUMN assets.department_id IS 'Foreign key to departments table - which department owns/uses this asset';

-- Create an index for faster department-based queries
CREATE INDEX IF NOT EXISTS idx_assets_department_id ON assets(department_id);

-- OPTION 2: If you prefer simple text department (for flexibility)
-- Uncomment the following if you want VARCHAR instead of foreign key:
-- ALTER TABLE assets 
-- ADD COLUMN IF NOT EXISTS department VARCHAR(100);
-- COMMENT ON COLUMN assets.department IS 'Department name (simple text field)';
-- CREATE INDEX IF NOT EXISTS idx_assets_department ON assets(department);

-- ===========================================================================
-- MIGRATION HELPER: Update existing assets with department data
-- ===========================================================================
-- If your laptop import SQL already populated a 'department' VARCHAR column,
-- you'll need to migrate that data to department_id:

-- Step 1: First ensure departments table has all the departments from your data
-- INSERT INTO departments (name, is_active) 
-- SELECT DISTINCT department, true 
-- FROM assets 
-- WHERE department IS NOT NULL 
-- ON CONFLICT (name) DO NOTHING;

-- Step 2: Update assets with correct department_id
-- UPDATE assets a
-- SET department_id = d.id
-- FROM departments d
-- WHERE a.department = d.name;

-- Step 3: Drop the old department VARCHAR column if you migrated successfully
-- ALTER TABLE assets DROP COLUMN IF EXISTS department;

-- Verify the column was added
-- SELECT column_name, data_type, is_nullable, column_default
-- FROM information_schema.columns 
-- WHERE table_name = 'assets' AND column_name IN ('department_id', 'department')
-- ORDER BY column_name;
