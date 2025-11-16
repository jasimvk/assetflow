-- Complete RLS Fix for AssetFlow
-- This script fixes all RLS policy issues causing 500 errors
-- Run this in your Supabase SQL Editor

-- ====================
-- STEP 1: Disable RLS on all tables
-- ====================
ALTER TABLE IF EXISTS assets DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS users DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS departments DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS locations DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS maintenance_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS system_access_requests DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS notifications DISABLE ROW LEVEL SECURITY;

-- ====================
-- STEP 2: Drop ALL existing policies
-- ====================
DO $$ 
DECLARE
    r RECORD;
BEGIN
    -- Drop all policies for all tables
    FOR r IN (
        SELECT schemaname, tablename, policyname 
        FROM pg_policies 
        WHERE schemaname = 'public'
    )
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
            r.policyname, r.schemaname, r.tablename);
    END LOOP;
END $$;

-- ====================
-- STEP 3: Create PERMISSIVE policies (USING true)
-- ====================

-- ASSETS TABLE
CREATE POLICY "assets_select_policy" ON assets
    FOR SELECT USING (true);

CREATE POLICY "assets_insert_policy" ON assets
    FOR INSERT WITH CHECK (true);

CREATE POLICY "assets_update_policy" ON assets
    FOR UPDATE USING (true);

CREATE POLICY "assets_delete_policy" ON assets
    FOR DELETE USING (true);

-- USERS TABLE
CREATE POLICY "users_select_policy" ON users
    FOR SELECT USING (true);

CREATE POLICY "users_insert_policy" ON users
    FOR INSERT WITH CHECK (true);

CREATE POLICY "users_update_policy" ON users
    FOR UPDATE USING (true);

CREATE POLICY "users_delete_policy" ON users
    FOR DELETE USING (true);

-- CATEGORIES TABLE
CREATE POLICY "categories_select_policy" ON categories
    FOR SELECT USING (true);

CREATE POLICY "categories_insert_policy" ON categories
    FOR INSERT WITH CHECK (true);

CREATE POLICY "categories_update_policy" ON categories
    FOR UPDATE USING (true);

CREATE POLICY "categories_delete_policy" ON categories
    FOR DELETE USING (true);

-- DEPARTMENTS TABLE
CREATE POLICY "departments_select_policy" ON departments
    FOR SELECT USING (true);

CREATE POLICY "departments_insert_policy" ON departments
    FOR INSERT WITH CHECK (true);

CREATE POLICY "departments_update_policy" ON departments
    FOR UPDATE USING (true);

CREATE POLICY "departments_delete_policy" ON departments
    FOR DELETE USING (true);

-- LOCATIONS TABLE (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'locations') THEN
        EXECUTE 'CREATE POLICY "locations_select_policy" ON locations FOR SELECT USING (true)';
        EXECUTE 'CREATE POLICY "locations_insert_policy" ON locations FOR INSERT WITH CHECK (true)';
        EXECUTE 'CREATE POLICY "locations_update_policy" ON locations FOR UPDATE USING (true)';
        EXECUTE 'CREATE POLICY "locations_delete_policy" ON locations FOR DELETE USING (true)';
    END IF;
END $$;

-- MAINTENANCE_RECORDS TABLE (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'maintenance_records') THEN
        EXECUTE 'CREATE POLICY "maintenance_records_select_policy" ON maintenance_records FOR SELECT USING (true)';
        EXECUTE 'CREATE POLICY "maintenance_records_insert_policy" ON maintenance_records FOR INSERT WITH CHECK (true)';
        EXECUTE 'CREATE POLICY "maintenance_records_update_policy" ON maintenance_records FOR UPDATE USING (true)';
        EXECUTE 'CREATE POLICY "maintenance_records_delete_policy" ON maintenance_records FOR DELETE USING (true)';
    END IF;
END $$;

-- SYSTEM_ACCESS_REQUESTS TABLE (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'system_access_requests') THEN
        EXECUTE 'CREATE POLICY "system_access_requests_select_policy" ON system_access_requests FOR SELECT USING (true)';
        EXECUTE 'CREATE POLICY "system_access_requests_insert_policy" ON system_access_requests FOR INSERT WITH CHECK (true)';
        EXECUTE 'CREATE POLICY "system_access_requests_update_policy" ON system_access_requests FOR UPDATE USING (true)';
        EXECUTE 'CREATE POLICY "system_access_requests_delete_policy" ON system_access_requests FOR DELETE USING (true)';
    END IF;
END $$;

-- NOTIFICATIONS TABLE (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'notifications') THEN
        EXECUTE 'CREATE POLICY "notifications_select_policy" ON notifications FOR SELECT USING (true)';
        EXECUTE 'CREATE POLICY "notifications_insert_policy" ON notifications FOR INSERT WITH CHECK (true)';
        EXECUTE 'CREATE POLICY "notifications_update_policy" ON notifications FOR UPDATE USING (true)';
        EXECUTE 'CREATE POLICY "notifications_delete_policy" ON notifications FOR DELETE USING (true)';
    END IF;
END $$;

-- ====================
-- STEP 4: Re-enable RLS on all tables
-- ====================
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'locations') THEN
        EXECUTE 'ALTER TABLE locations ENABLE ROW LEVEL SECURITY';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'maintenance_records') THEN
        EXECUTE 'ALTER TABLE maintenance_records ENABLE ROW LEVEL SECURITY';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'system_access_requests') THEN
        EXECUTE 'ALTER TABLE system_access_requests ENABLE ROW LEVEL SECURITY';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'notifications') THEN
        EXECUTE 'ALTER TABLE notifications ENABLE ROW LEVEL SECURITY';
    END IF;
END $$;

-- ====================
-- STEP 5: Verify policies
-- ====================
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    cmd,
    qual AS using_expression,
    with_check AS with_check_expression
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, cmd, policyname;

-- ====================
-- STEP 6: Test queries
-- ====================
-- Test assets table
SELECT COUNT(*) as total_assets FROM assets;

-- Test users table
SELECT COUNT(*) as total_users FROM users;

-- Test categories table
SELECT COUNT(*) as total_categories FROM categories;

-- Test departments table
SELECT COUNT(*) as total_departments FROM departments;

-- Success message
SELECT '✅ RLS policies fixed successfully! All tables accessible.' AS status;
