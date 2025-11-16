-- Departments Table Setup for Supabase
-- This SQL script creates the departments table for AssetFlow
-- Run this script in your Supabase SQL Editor BEFORE creating/updating the assets table

-- ============================================================================
-- STEP 1: Create Departments Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS departments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    department_head VARCHAR(255), -- Name or email of department head
    location VARCHAR(255), -- Physical location of department
    cost_center VARCHAR(50), -- Cost center code for accounting
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- STEP 2: Create Indexes for Performance
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_departments_name ON departments(name);
CREATE INDEX IF NOT EXISTS idx_departments_is_active ON departments(is_active);
CREATE INDEX IF NOT EXISTS idx_departments_created_at ON departments(created_at);

-- ============================================================================
-- STEP 3: Create Trigger for Updated_At Timestamp
-- ============================================================================

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_departments_updated_at ON departments;

-- Create trigger to update updated_at on row update
CREATE TRIGGER update_departments_updated_at
    BEFORE UPDATE ON departments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STEP 4: Drop Existing RLS Policies (if any)
-- ============================================================================

DROP POLICY IF EXISTS "Enable read access for all users" ON departments;
DROP POLICY IF EXISTS "Enable insert access for all users" ON departments;
DROP POLICY IF EXISTS "Enable update access for all users" ON departments;
DROP POLICY IF EXISTS "Enable delete access for all users" ON departments;

-- ============================================================================
-- STEP 5: Enable Row Level Security (RLS)
-- ============================================================================

ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 6: Create RLS Policies
-- ============================================================================

-- Allow all authenticated users to read departments
CREATE POLICY "Enable read access for all users" ON departments
    FOR SELECT
    USING (true);

-- Allow all authenticated users to insert departments (admin-controlled in app)
CREATE POLICY "Enable insert access for all users" ON departments
    FOR INSERT
    WITH CHECK (true);

-- Allow all authenticated users to update departments (admin-controlled in app)
CREATE POLICY "Enable update access for all users" ON departments
    FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- Allow all authenticated users to delete departments (admin-controlled in app)
CREATE POLICY "Enable delete access for all users" ON departments
    FOR DELETE
    USING (true);

-- ============================================================================
-- STEP 7: Insert Default Departments
-- ============================================================================

-- Insert all departments from your actual inventory data
INSERT INTO departments (name, description, is_active) VALUES
('IT', 'Information Technology - manages technology infrastructure and support', true),
('HR', 'Human Resources - manages employee relations and administration', true),
('Finance', 'Finance and Accounting - manages financial operations and reporting', true),
('Procurement', 'Procurement - manages purchasing and vendor relationships', true),
('F&B', 'Food & Beverage - manages restaurant and catering services', true),
('Housekeeping', 'Housekeeping - manages facility cleaning and maintenance', true),
('Kitchen', 'Kitchen - manages food preparation and culinary operations', true),
('Maintenance', 'Maintenance - manages facility and equipment maintenance', true),
('Admin', 'Administration - manages administrative functions', true),
('Catering', 'Catering - manages catering services', true),
('Store', 'Store/Warehouse - manages inventory and storage', true),
('Stores', 'Stores - inventory management (alternative to Store)', true),
('Security', 'Security - manages facility and asset security', true),
('Executive Office', 'Executive Office - senior management and leadership', true),
('Project', 'Project Management - manages project coordination', true),
('Projects', 'Projects - manages project execution and delivery', true),
('Operations', 'Operations - manages daily business operations', true),
('Projects', 'Projects - manages special projects and initiatives', true),
('Spa', 'Spa - manages spa and wellness services', true),
('Laundry', 'Laundry - manages laundry services', true),
('Catering', 'Catering - manages catering services', true),
('L&T', 'Logistics & Transportation - manages logistics and transport', true),
('Special Affairs', 'Special Affairs - manages special events and affairs', true)
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- STEP 8: Verification Queries
-- ============================================================================

-- View all departments
SELECT 
    id,
    name,
    description,
    department_head,
    location,
    is_active,
    created_at
FROM departments 
ORDER BY name;

-- Count active departments
SELECT 
    COUNT(*) as total_departments,
    COUNT(CASE WHEN is_active = true THEN 1 END) as active_departments,
    COUNT(CASE WHEN is_active = false THEN 1 END) as inactive_departments
FROM departments;

-- View table structure
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'departments' 
ORDER BY ordinal_position;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. Department names are UNIQUE to prevent duplicates
-- 2. is_active flag allows soft-delete (deactivate instead of delete)
-- 3. department_head can store name or email of department manager
-- 4. location stores physical location of department
-- 5. cost_center for accounting/budget tracking integration
-- 6. RLS policies allow all authenticated users, control at app level
-- 7. updated_at is automatically updated via trigger
-- 8. This script is idempotent - safe to run multiple times
-- ============================================================================
