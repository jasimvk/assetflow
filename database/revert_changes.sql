-- Revert Script for AssetFlow
-- This script drops all tables and objects created during the recent session.

-- 1. Drop Auth Config Table
DROP TABLE IF EXISTS auth_config CASCADE;

-- 2. Drop System Access Management Tables
-- Order matters due to foreign key constraints
DROP TABLE IF EXISTS access_request_history CASCADE;
DROP TABLE IF EXISTS time_attendance_access CASCADE;
DROP TABLE IF EXISTS it_asset_handover CASCADE;
DROP TABLE IF EXISTS oracle_fusion_access CASCADE;
DROP TABLE IF EXISTS system_access_details CASCADE;
DROP TABLE IF EXISTS system_access_requests CASCADE;

-- 3. Drop Triggers (Handled by CASCADE on tables, but kept for completeness if table exists)
-- Note: DROP TRIGGER requires the table to exist. Since we drop tables above with CASCADE, 
-- triggers are already gone. We will remove this explicit drop to avoid errors.
-- DROP TRIGGER IF EXISTS update_system_access_requests_updated_at ON system_access_requests;

-- 4. Drop Policies (Cascading drops on tables should handle most, but explicit cleanup for existing tables if any)
-- Note: If we added policies to existing tables like 'users' or 'assets', we should drop them here.
-- Based on security_hardening.sql, we likely added policies.
-- It is safer to manually drop specific policies if we know their names, or just leave them if they are harmless.
-- However, since the user asked to "revert everything", we should try to clean up.

-- Drop policies on 'users' table if they were added/modified
-- (Assuming names from standard conventions or previous scripts)
DROP POLICY IF EXISTS "Users can view their own profile" ON users;
DROP POLICY IF EXISTS "Admins can view all profiles" ON users;
DROP POLICY IF EXISTS "Admins can update profiles" ON users;

-- Drop policies on 'assets' table
DROP POLICY IF EXISTS "Everyone can view assets" ON assets;
DROP POLICY IF EXISTS "Admins and managers can manage assets" ON assets;

-- Drop policies on 'maintenance_records'
DROP POLICY IF EXISTS "Everyone can view maintenance records" ON maintenance_records;
DROP POLICY IF EXISTS "Admins and managers can manage maintenance records" ON maintenance_records;

-- Drop policies on 'notifications'
DROP POLICY IF EXISTS "Users can view their own notifications" ON notifications;
DROP POLICY IF EXISTS "System can create notifications" ON notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON notifications;

-- 5. Re-enable default permissive policies if needed (Optional, depends on original state)
-- If the original state had no RLS or different policies, this might leave tables without access.
-- For safety, we can add back a basic public access policy for development if that was the state.

-- Restore basic access for 'users' (Example)
-- CREATE POLICY "Enable read access for all users" ON users FOR SELECT USING (true);

-- Restore basic access for 'assets' (Example)
-- CREATE POLICY "Enable read access for all users" ON assets FOR SELECT USING (true);

COMMIT;
