-- Fix RLS Policies for Master Data Tables
-- Run this in Supabase SQL Editor to enable insert/update on master data tables

-- ============================================
-- DROP EXISTING POLICIES (if any)
-- ============================================

-- Locations policies
DROP POLICY IF EXISTS "Allow all access to locations" ON locations;
DROP POLICY IF EXISTS "locations_select_policy" ON locations;
DROP POLICY IF EXISTS "locations_insert_policy" ON locations;
DROP POLICY IF EXISTS "locations_update_policy" ON locations;
DROP POLICY IF EXISTS "locations_delete_policy" ON locations;
DROP POLICY IF EXISTS "Enable read access for all users" ON locations;
DROP POLICY IF EXISTS "Enable insert for all users" ON locations;

-- Manufacturers policies
DROP POLICY IF EXISTS "Allow all access to manufacturers" ON manufacturers;

-- Models policies
DROP POLICY IF EXISTS "Allow all access to models" ON models;

-- OS Versions policies
DROP POLICY IF EXISTS "Allow all access to os_versions" ON os_versions;

-- CPU Types policies
DROP POLICY IF EXISTS "Allow all access to cpu_types" ON cpu_types;

-- RAM Sizes policies
DROP POLICY IF EXISTS "Allow all access to ram_sizes" ON ram_sizes;

-- Storage Sizes policies
DROP POLICY IF EXISTS "Allow all access to storage_sizes" ON storage_sizes;

-- ============================================
-- ENABLE RLS ON ALL TABLES
-- ============================================
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE manufacturers ENABLE ROW LEVEL SECURITY;
ALTER TABLE models ENABLE ROW LEVEL SECURITY;
ALTER TABLE os_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cpu_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE ram_sizes ENABLE ROW LEVEL SECURITY;
ALTER TABLE storage_sizes ENABLE ROW LEVEL SECURITY;

-- ============================================
-- CREATE PERMISSIVE POLICIES FOR ALL OPERATIONS
-- ============================================

-- LOCATIONS - Full access for all users (authenticated or anonymous)
CREATE POLICY "locations_full_access" ON locations
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- MANUFACTURERS - Full access
CREATE POLICY "manufacturers_full_access" ON manufacturers
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- MODELS - Full access
CREATE POLICY "models_full_access" ON models
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- OS_VERSIONS - Full access
CREATE POLICY "os_versions_full_access" ON os_versions
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- CPU_TYPES - Full access
CREATE POLICY "cpu_types_full_access" ON cpu_types
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- RAM_SIZES - Full access
CREATE POLICY "ram_sizes_full_access" ON ram_sizes
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- STORAGE_SIZES - Full access
CREATE POLICY "storage_sizes_full_access" ON storage_sizes
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- ============================================
-- VERIFY POLICIES ARE CREATED
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '✅ RLS Policies Updated Successfully!';
    RAISE NOTICE '';
    RAISE NOTICE 'Tables with full access policies:';
    RAISE NOTICE '  ✓ locations';
    RAISE NOTICE '  ✓ manufacturers';
    RAISE NOTICE '  ✓ models';
    RAISE NOTICE '  ✓ os_versions';
    RAISE NOTICE '  ✓ cpu_types';
    RAISE NOTICE '  ✓ ram_sizes';
    RAISE NOTICE '  ✓ storage_sizes';
    RAISE NOTICE '';
    RAISE NOTICE 'All tables now allow SELECT, INSERT, UPDATE, DELETE for all users.';
END $$;

-- ============================================
-- TEST: Verify you can insert into locations
-- ============================================
-- Uncomment to test:
-- INSERT INTO locations (name) VALUES ('Test Location') ON CONFLICT (name) DO NOTHING;
-- SELECT * FROM locations WHERE name = 'Test Location';
-- DELETE FROM locations WHERE name = 'Test Location';
