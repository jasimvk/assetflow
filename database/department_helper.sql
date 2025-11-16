-- Helper Script: Convert Import Files to Use Department Foreign Keys
-- This creates a helper function to convert department names to IDs in import scripts
-- Run this AFTER departments_table.sql and BEFORE running import files

-- ============================================================================
-- Create helper function to get department ID by name
-- ============================================================================

CREATE OR REPLACE FUNCTION get_department_id(dept_name VARCHAR)
RETURNS UUID AS $$
DECLARE
    dept_id UUID;
BEGIN
    SELECT id INTO dept_id
    FROM departments
    WHERE name = dept_name AND is_active = true
    LIMIT 1;
    
    RETURN dept_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Usage Example in Import Scripts
-- ============================================================================

-- Instead of:
-- INSERT INTO assets (name, category, department, ...) 
-- VALUES ('Asset Name', 'Laptop', 'IT', ...);

-- Use:
-- INSERT INTO assets (name, category, department_id, ...) 
-- VALUES ('Asset Name', 'Laptop', get_department_id('IT'), ...);

-- ============================================================================
-- Test the function
-- ============================================================================

SELECT 
    name,
    get_department_id(name) as department_id
FROM departments
WHERE is_active = true
ORDER BY name;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. This function makes it easy to convert department names to IDs
-- 2. Returns NULL if department doesn't exist or is inactive
-- 3. Use this in all import scripts for department_id field
-- 4. The function is permanent and can be used repeatedly
-- ============================================================================
