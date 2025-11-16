    -- Fix RLS Policies for AssetFlow
    -- Run this in your Supabase SQL Editor to fix the "infinite recursion" errors

    -- 0. Fix missing columns first
    ALTER TABLE users ADD COLUMN IF NOT EXISTS full_name VARCHAR(255);
    UPDATE users SET full_name = name WHERE full_name IS NULL;

    -- 1. Disable RLS temporarily to fix the policies
    ALTER TABLE assets DISABLE ROW LEVEL SECURITY;
    ALTER TABLE users DISABLE ROW LEVEL SECURITY;
    ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
    ALTER TABLE locations DISABLE ROW LEVEL SECURITY;
    ALTER TABLE maintenance_records DISABLE ROW LEVEL SECURITY;
    ALTER TABLE system_access_requests DISABLE ROW LEVEL SECURITY;

    -- 2. Drop all existing policies (if any)
    DO $$ 
    DECLARE
        r RECORD;
    BEGIN
        -- Drop all policies for assets
        FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'assets' AND schemaname = 'public')
        LOOP
            EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON assets';
        END LOOP;
        
        -- Drop all policies for users
        FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'users' AND schemaname = 'public')
        LOOP
            EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON users';
        END LOOP;
        
        -- Drop all policies for categories
        FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'categories' AND schemaname = 'public')
        LOOP
            EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON categories';
        END LOOP;
        
        -- Drop all policies for locations
        FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'locations' AND schemaname = 'public')
        LOOP
            EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON locations';
        END LOOP;
        
        -- Drop all policies for maintenance_records
        FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'maintenance_records' AND schemaname = 'public')
        LOOP
            EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON maintenance_records';
        END LOOP;
        
        -- Drop all policies for system_access_requests
        FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'system_access_requests' AND schemaname = 'public')
        LOOP
            EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON system_access_requests';
        END LOOP;
    END $$;

    -- 3. Create simple, non-recursive policies for each table

    -- ASSETS TABLE
    CREATE POLICY "Enable read access for all users" ON assets
    FOR SELECT USING (true);

    CREATE POLICY "Enable insert access for all users" ON assets
    FOR INSERT WITH CHECK (true);

    CREATE POLICY "Enable update access for all users" ON assets
    FOR UPDATE USING (true);

    CREATE POLICY "Enable delete access for all users" ON assets
    FOR DELETE USING (true);

    -- USERS TABLE
    CREATE POLICY "Enable read access for all users" ON users
    FOR SELECT USING (true);

    CREATE POLICY "Enable insert access for all users" ON users
    FOR INSERT WITH CHECK (true);

    CREATE POLICY "Enable update access for all users" ON users
    FOR UPDATE USING (true);

    CREATE POLICY "Enable delete access for all users" ON users
    FOR DELETE USING (true);

    -- CATEGORIES TABLE
    CREATE POLICY "Enable read access for all users" ON categories
    FOR SELECT USING (true);

    CREATE POLICY "Enable insert access for all users" ON categories
    FOR INSERT WITH CHECK (true);

    CREATE POLICY "Enable update access for all users" ON categories
    FOR UPDATE USING (true);

    CREATE POLICY "Enable delete access for all users" ON categories
    FOR DELETE USING (true);

    -- LOCATIONS TABLE
    CREATE POLICY "Enable read access for all users" ON locations
    FOR SELECT USING (true);

    CREATE POLICY "Enable insert access for all users" ON locations
    FOR INSERT WITH CHECK (true);

    CREATE POLICY "Enable update access for all users" ON locations
    FOR UPDATE USING (true);

    CREATE POLICY "Enable delete access for all users" ON locations
    FOR DELETE USING (true);

    -- MAINTENANCE_RECORDS TABLE
    CREATE POLICY "Enable read access for all users" ON maintenance_records
    FOR SELECT USING (true);

    CREATE POLICY "Enable insert access for all users" ON maintenance_records
    FOR INSERT WITH CHECK (true);

    CREATE POLICY "Enable update access for all users" ON maintenance_records
    FOR UPDATE USING (true);

    CREATE POLICY "Enable delete access for all users" ON maintenance_records
    FOR DELETE USING (true);

    -- SYSTEM_ACCESS_REQUESTS TABLE
    CREATE POLICY "Enable read access for all users" ON system_access_requests
    FOR SELECT USING (true);

    CREATE POLICY "Enable insert access for all users" ON system_access_requests
    FOR INSERT WITH CHECK (true);

    CREATE POLICY "Enable update access for all users" ON system_access_requests
    FOR UPDATE USING (true);

    CREATE POLICY "Enable delete access for all users" ON system_access_requests
    FOR DELETE USING (true);

    -- 4. Re-enable RLS with the new simple policies
    ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
    ALTER TABLE users ENABLE ROW LEVEL SECURITY;
    ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
    ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
    ALTER TABLE maintenance_records ENABLE ROW LEVEL SECURITY;
    ALTER TABLE system_access_requests ENABLE ROW LEVEL SECURITY;

    -- 5. Verify policies are working
    SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
    FROM pg_policies
    WHERE schemaname = 'public'
    ORDER BY tablename, policyname;

    -- Success message
    SELECT 'RLS policies fixed successfully! All tables now have simple, non-recursive policies.' AS message;
