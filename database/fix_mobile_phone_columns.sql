-- ============================================================================
-- FIX: Clean up mobile phone data - Remove department text from notes/description
-- The department should only show in the Department column, not in Assigned To
-- ============================================================================

-- STEP 1: Check current state - See if department text is in wrong fields
-- ============================================================================

SELECT 
  'Current Mobile Phone Data' as report,
  name,
  assigned_to,
  previous_user,
  notes,
  description,
  d.name as department_name
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
LIMIT 10;

-- ============================================================================
-- STEP 2: Clean up notes field - Remove "Department: X" text
-- ============================================================================

-- The notes field should only contain relevant notes, not department info
-- Department is already tracked via department_id foreign key

UPDATE assets
SET notes = REGEXP_REPLACE(notes, 'Department: [A-Za-z& ]+', '', 'g')
WHERE category = 'Mobile Phone'
  AND notes LIKE '%Department:%';

-- Trim any leading/trailing whitespace or commas
UPDATE assets
SET notes = TRIM(BOTH ', ' FROM notes)
WHERE category = 'Mobile Phone'
  AND notes IS NOT NULL;

-- Set empty notes to NULL for cleaner data
UPDATE assets
SET notes = NULL
WHERE category = 'Mobile Phone'
  AND (notes = '' OR notes IS NULL OR TRIM(notes) = '');

-- ============================================================================
-- STEP 3: Clean up description field if needed
-- ============================================================================

-- Remove department text from description field too
UPDATE assets
SET description = REGEXP_REPLACE(description, 'Department: [A-Za-z& ]+', '', 'g')
WHERE category = 'Mobile Phone'
  AND description LIKE '%Department:%';

-- Trim and clean up description
UPDATE assets
SET description = TRIM(BOTH ', ' FROM description)
WHERE category = 'Mobile Phone'
  AND description IS NOT NULL;

-- ============================================================================
-- STEP 4: Ensure all mobile phones have correct department_id
-- ============================================================================

-- Verify department linkages are correct
SELECT 
  'Mobile Phones by Department' as report,
  d.name as department,
  COUNT(*) as device_count,
  array_agg(a.name ORDER BY a.name) as devices
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Mobile Phone'
  AND a.name LIKE 'Mobile-%'
GROUP BY d.name
ORDER BY device_count DESC;

-- ============================================================================
-- STEP 5: Verify Assigned To column is clean
-- ============================================================================

-- Check that assigned_to only contains user names or NULL
-- Should NOT contain department names
SELECT 
  'Assigned To Check' as report,
  name,
  assigned_to,
  previous_user,
  d.name as department_name,
  CASE 
    WHEN assigned_to IS NULL THEN '✅ Correctly Unassigned'
    WHEN assigned_to LIKE '%Department%' THEN '❌ Has Department Text - NEEDS FIX'
    ELSE '✅ Has User Name'
  END as status
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
ORDER BY status, name
LIMIT 20;

-- ============================================================================
-- STEP 6: Fix any assigned_to fields that have department text
-- ============================================================================

-- If any assigned_to fields accidentally have department text, clear them
UPDATE assets
SET 
  assigned_to = NULL,
  resignation_notes = COALESCE(resignation_notes, '') || ' [Data cleaned: removed department text from assigned_to]'
WHERE category = 'Mobile Phone'
  AND assigned_to LIKE '%Department%';

-- ============================================================================
-- STEP 7: Final Verification - Show clean data structure
-- ============================================================================

SELECT 
  '✅ FINAL CLEAN DATA' as report,
  name,
  model,
  serial_number,
  'Assigned To' as field_label,
  COALESCE(assigned_to, '(Unassigned)') as assigned_to_value,
  'Department' as dept_label,
  d.name as department_value,
  'Previous User' as prev_label,
  COALESCE(previous_user, '(None)') as previous_user_value
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
ORDER BY name
LIMIT 20;

-- Check for any remaining issues
SELECT 
  'Data Quality Check' as report,
  COUNT(*) as total_mobile_phones,
  COUNT(CASE WHEN assigned_to LIKE '%Department%' THEN 1 END) as has_dept_in_assigned_to,
  COUNT(CASE WHEN notes LIKE '%Department%' THEN 1 END) as has_dept_in_notes,
  COUNT(CASE WHEN description LIKE '%Department%' THEN 1 END) as has_dept_in_description,
  COUNT(department_id) as has_department_id,
  CASE 
    WHEN COUNT(CASE WHEN assigned_to LIKE '%Department%' THEN 1 END) = 0 THEN '✅ CLEAN'
    ELSE '❌ NEEDS CLEANUP'
  END as data_status
FROM assets
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%';

-- ============================================================================
-- STEP 8: Display summary by status
-- ============================================================================

SELECT 
  'Mobile Phone Summary' as report,
  status,
  COUNT(*) as count,
  COUNT(assigned_to) as currently_assigned,
  COUNT(previous_user) as has_resignation_history,
  COUNT(department_id) as linked_to_department
FROM assets
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
GROUP BY status
ORDER BY count DESC;

-- ============================================================================
-- DONE! Data cleaned and properly structured:
-- - Assigned To column: Only shows current user name or blank
-- - Department column: Shows department name via department_id join
-- - Previous User: Shows who had the device before resignation
-- ============================================================================
