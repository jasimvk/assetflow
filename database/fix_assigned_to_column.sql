-- Fix assigned_to Column Type - Change from UUID to TEXT
-- Run this BEFORE importing laptops if you get UUID error

-- This fixes the issue where assigned_to is still UUID instead of TEXT
-- The V2 schema should have TEXT, but if your database still has UUID, run this:

-- ====================
-- STEP 1: Check current type
-- ====================
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'assets' AND column_name = 'assigned_to';

-- ====================
-- STEP 2: Drop ALL dependent views
-- ====================
DROP VIEW IF EXISTS vw_assets_with_users CASCADE;
DROP VIEW IF EXISTS vw_dashboard_stats CASCADE;
DROP VIEW IF EXISTS vw_asset_summary CASCADE;
DROP VIEW IF EXISTS vw_maintenance_due CASCADE;

-- ====================
-- STEP 3: Drop foreign key constraint on assigned_to
-- ====================
ALTER TABLE assets DROP CONSTRAINT IF EXISTS assets_assigned_to_fkey CASCADE;

-- ====================
-- STEP 4: Convert assigned_to from UUID to TEXT
-- ====================
ALTER TABLE assets 
ALTER COLUMN assigned_to TYPE TEXT 
USING assigned_to::TEXT;

-- ====================
-- STEP 5: Recreate the views (simplified - assigned_to is now TEXT)
-- ====================

-- View 1: Assets with users (simplified)
CREATE OR REPLACE VIEW vw_assets_with_users AS
SELECT 
    a.*,
    a.assigned_to as user_name  -- Now just an alias since assigned_to is already TEXT
FROM assets a;

-- View 2: Dashboard stats (recreate if it existed)
CREATE OR REPLACE VIEW vw_dashboard_stats AS
SELECT 
    COUNT(*) as total_assets,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_assets,
    COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_assets,
    COUNT(CASE WHEN status = 'maintenance' THEN 1 END) as maintenance_assets,
    COUNT(CASE WHEN assigned_to IS NOT NULL AND assigned_to != '' THEN 1 END) as assigned_assets,
    COUNT(CASE WHEN assigned_to IS NULL OR assigned_to = '' THEN 1 END) as unassigned_assets
FROM assets;

-- ====================
-- STEP 6: Verify the change
-- ====================
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'assets' AND column_name = 'assigned_to';

-- Expected result: data_type should be 'text' or 'character varying'

-- ====================
-- STEP 7: Test the view
-- ====================
SELECT COUNT(*) as total_assets FROM vw_assets_with_users;

SELECT '✅ assigned_to column converted from UUID to TEXT and view recreated' AS status;
