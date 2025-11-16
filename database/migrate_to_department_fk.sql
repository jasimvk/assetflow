-- Migration: Convert department VARCHAR to department_id UUID foreign key
-- Run this in Supabase SQL Editor if you already have the assets table with department VARCHAR
-- This will preserve existing department data by matching with the departments table

-- ============================================================================
-- STEP 1: Ensure departments table exists
-- ============================================================================
-- Run departments_table.sql first if you haven't already!

-- ============================================================================
-- STEP 2: Add department_id column
-- ============================================================================

ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS department_id UUID REFERENCES departments(id) ON DELETE SET NULL;

-- ============================================================================
-- STEP 3: Migrate existing department data
-- ============================================================================

-- Update assets to use department_id based on existing department names
UPDATE assets a
SET department_id = d.id
FROM departments d
WHERE a.department = d.name
  AND a.department_id IS NULL
  AND a.department IS NOT NULL;

-- ============================================================================
-- STEP 4: Report on migration status
-- ============================================================================

-- Check how many assets were successfully migrated
SELECT 
    COUNT(*) as total_assets_with_department_name,
    COUNT(department_id) as successfully_migrated,
    COUNT(*) - COUNT(department_id) as failed_migrations
FROM assets
WHERE department IS NOT NULL;

-- Show any departments in assets that don't exist in departments table
SELECT DISTINCT a.department
FROM assets a
LEFT JOIN departments d ON a.department = d.name
WHERE a.department IS NOT NULL
  AND d.id IS NULL
ORDER BY a.department;

-- ============================================================================
-- STEP 5: Create index for department_id
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_assets_department_id ON assets(department_id) WHERE department_id IS NOT NULL;

-- ============================================================================
-- STEP 6: Optional - Remove old department VARCHAR column
-- ============================================================================

-- ⚠️ CAUTION: Only run this after verifying all data is migrated correctly!
-- Uncomment the line below to drop the old department column:

-- ALTER TABLE assets DROP COLUMN IF EXISTS department;

-- ============================================================================
-- STEP 7: Add comment for documentation
-- ============================================================================

COMMENT ON COLUMN assets.department_id IS 'Foreign key to departments table - ensures referential integrity';

-- ============================================================================
-- STEP 8: Verification queries
-- ============================================================================

-- View assets with their department names (via join)
SELECT 
    a.id,
    a.name as asset_name,
    a.category,
    d.name as department_name,
    a.assigned_to,
    a.status
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.department_id IS NOT NULL
LIMIT 10;

-- Count assets by department
SELECT 
    d.name as department,
    COUNT(a.id) as asset_count
FROM departments d
LEFT JOIN assets a ON d.id = a.department_id
GROUP BY d.name
ORDER BY asset_count DESC;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. This migration preserves existing department data
-- 2. Assets with departments not in the departments table will remain unmigrated
-- 3. The old department VARCHAR column is kept for safety (comment out to remove)
-- 4. department_id uses ON DELETE SET NULL, so deleting a department won't delete assets
-- 5. Run verification queries to ensure data integrity
-- 6. Add any missing departments to the departments table before running this migration
-- ============================================================================
