-- ============================================================================
-- LINK ASSETS TO DEPARTMENTS
-- Run this in Supabase SQL Editor to populate department_id for all assets
-- ============================================================================

-- STEP 1: Ensure all departments exist
-- ============================================================================
INSERT INTO departments (name, description, is_active) VALUES
('IT', 'Information Technology Department', true),
('HR', 'Human Resources Department', true),
('Finance', 'Finance and Accounting Department', true),
('Procurement', 'Procurement Department', true),
('F&B', 'Food & Beverage Department', true),
('Housekeeping', 'Housekeeping Department', true),
('Kitchen', 'Kitchen Department', true),
('Maintenance', 'Maintenance Department', true),
('Admin', 'Administration Department', true),
('Catering', 'Catering Department', true),
('Store', 'Store/Warehouse Department', true),
('Stores', 'Stores Department', true),
('Security', 'Security Department', true),
('Executive Office', 'Executive Office', true),
('Project', 'Project Management Department', true),
('Projects', 'Projects Department', true),
('Operations', 'Operations Department', true)
ON CONFLICT (name) DO NOTHING;

-- STEP 2: Link assets to departments based on description/notes
-- ============================================================================

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

UPDATE assets 
SET department_id = (SELECT id FROM departments WHERE name = 'Operations')
WHERE department_id IS NULL 
  AND (description ILIKE '%Department: Operations%' OR notes ILIKE '%Department: Operations%');

-- STEP 3: Verify the results
-- ============================================================================

-- Check overall department distribution
SELECT 
  'Department Distribution' as report,
  COALESCE(d.name, '[No Department]') as department_name,
  COUNT(*) as asset_count,
  ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM assets) * 100, 1) as percentage
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
GROUP BY d.name
ORDER BY asset_count DESC;

-- Summary statistics
SELECT 
  'Summary' as report,
  COUNT(*) as total_assets,
  COUNT(department_id) as with_department,
  COUNT(*) - COUNT(department_id) as without_department,
  ROUND(COUNT(department_id)::numeric / COUNT(*) * 100, 1) as coverage_percentage
FROM assets;

-- Sample of linked assets
SELECT 
  'Sample Linked Assets' as report,
  a.name as asset_name,
  a.category,
  d.name as department_name,
  a.assigned_to
FROM assets a
INNER JOIN departments d ON a.department_id = d.id
LIMIT 10;

-- ============================================================================
-- DONE! Departments are now linked to assets.
-- The frontend has been updated to display department names via JOIN.
-- ============================================================================
