-- Quick Diagnostic and Fix for Department Field
-- Run this in Supabase SQL Editor to diagnose and fix the department issue

-- ============================================================================
-- STEP 1: DIAGNOSTIC - Check Current State
-- ============================================================================

-- Check if department column exists
SELECT 
  '1. Column Check' as step,
  column_name, 
  data_type, 
  is_nullable,
  CASE 
    WHEN column_name IS NOT NULL THEN '✅ Column exists'
    ELSE '❌ Column missing'
  END as status
FROM information_schema.columns 
WHERE table_name = 'assets' 
  AND column_name IN ('department', 'department_id');

-- Check if any assets have department data
SELECT 
  '2. Data Check' as step,
  COUNT(*) as total_assets,
  COUNT(department_id) as has_department_fk,
  ROUND(COUNT(department_id)::numeric / NULLIF(COUNT(*), 0) * 100, 2) as percentage_with_dept
FROM assets;

-- Show sample data with department join
SELECT 
  '3. Sample Data' as step,
  a.name, 
  a.category, 
  d.name as department_name,
  a.assigned_to
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category IN ('Laptop', 'Monitor', 'Mobile Phone')
LIMIT 5;

-- ============================================================================
-- STEP 2: IMPORTANT - Your database uses department_id (foreign key)
-- ============================================================================

-- Your assets table already has department_id as a foreign key to departments table
-- This is the CORRECT approach! No need to add a separate "department" column.
-- The frontend just needs to join the departments table to display the name.

-- Verify the foreign key exists
SELECT 
  '2a. Foreign Key Check' as step,
  conname as constraint_name,
  conrelid::regclass as table_name,
  confrelid::regclass as referenced_table
FROM pg_constraint
WHERE conname LIKE '%department%' AND conrelid::regclass::text = 'assets';

-- ============================================================================
-- STEP 3: CHECK - Department Distribution
-- ============================================================================

-- Check department distribution (using proper join)
SELECT 
  '4. Department Distribution' as step,
  COALESCE(d.name, '[No Department]') as department_name,
  COUNT(*) as asset_count,
  array_agg(DISTINCT a.category) as categories
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
GROUP BY d.name
ORDER BY asset_count DESC;

-- ============================================================================
-- STEP 4: POPULATE DEPARTMENTS TABLE (if needed)
-- ============================================================================

-- Add all departments from your import data
INSERT INTO departments (name, description, is_active) VALUES
('IT', 'Information Technology - manages technology infrastructure and support', true),
('HR', 'Human Resources - employee relations and administration', true),
('Finance', 'Finance and Accounting - financial operations and reporting', true),
('Procurement', 'Procurement - purchasing and vendor relationships', true),
('F&B', 'Food & Beverage - restaurant and catering services', true),
('Housekeeping', 'Housekeeping - facility cleaning and maintenance', true),
('Kitchen', 'Kitchen - food preparation and culinary operations', true),
('Maintenance', 'Maintenance - facility and equipment maintenance', true),
('Admin', 'Administration - administrative functions', true),
('Catering', 'Catering - catering services', true),
('Store', 'Store/Warehouse - inventory and storage', true),
('Stores', 'Stores - inventory management', true),
('Security', 'Security - facility and asset security', true),
('Executive Office', 'Executive Office - senior management and leadership', true),
('Project', 'Project Management - project coordination', true),
('Projects', 'Projects - project execution and delivery', true)
ON CONFLICT (name) DO NOTHING;

-- Verify departments were added
SELECT '5. Departments Check' as step, name, is_active 
FROM departments 
ORDER BY name;

-- ============================================================================
-- STEP 5: LINK ASSETS TO DEPARTMENTS (if department_id is NULL)
-- ============================================================================

-- If assets don't have department_id populated, you can link them based on notes/descriptions
-- Your import SQLs have department info in the description field

-- Option 1: Link based on description/notes containing department name
UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'IT')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: IT%' OR notes ILIKE '%Department: IT%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'HR')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: HR%' OR notes ILIKE '%Department: HR%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Finance')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Finance%' OR notes ILIKE '%Department: Finance%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Procurement')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Procurement%' OR notes ILIKE '%Department: Procurement%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'F&B')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: F&B%' OR notes ILIKE '%Department: F&B%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Housekeeping')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Housekeeping%' OR notes ILIKE '%Department: Housekeeping%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Kitchen')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Kitchen%' OR notes ILIKE '%Department: Kitchen%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Maintenance')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Maintenance%' OR notes ILIKE '%Department: Maintenance%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Admin')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Admin%' OR notes ILIKE '%Department: Admin%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Catering')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Catering%' OR notes ILIKE '%Department: Catering%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Security')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Security%' OR notes ILIKE '%Department: Security%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Executive Office')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Executive Office%' OR notes ILIKE '%Department: Executive Office%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Project')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Project%' OR notes ILIKE '%Department: Project%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Projects')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Projects%' OR notes ILIKE '%Department: Projects%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Store')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Store%' OR notes ILIKE '%Department: Store%');

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Stores')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Stores%' OR notes ILIKE '%Department: Stores%');

-- Verify updates
SELECT 
  '6. After Update Check' as step,
  COUNT(*) as total_assets,
  COUNT(department_id) as with_department,
  COUNT(*) - COUNT(department_id) as without_department
FROM assets;

-- ============================================================================
-- DONE! Your database uses the CORRECT foreign key approach
-- Now you need to update the FRONTEND to join departments table
-- ============================================================================
