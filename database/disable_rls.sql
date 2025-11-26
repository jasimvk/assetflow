-- Disable RLS to restore visibility (Reverting Security Hardening)
-- Since we dropped policies but left RLS enabled, no data is visible.
-- This script disables RLS on core tables to allow full access again.

ALTER TABLE assets DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE systems DISABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE notifications DISABLE ROW LEVEL SECURITY;

-- If you have other tables that are hidden, add them here.
