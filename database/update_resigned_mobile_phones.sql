-- ============================================================================
-- UPDATE MOBILE PHONES - Mark as Unassigned for Resigned Employees
-- Add previous_user tracking for resignation history
-- ============================================================================

-- STEP 1: Add previous_user column to assets table (if not exists)
-- ============================================================================

-- Add previous_user column to track who previously had the asset
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS previous_user VARCHAR(255);

-- Add resigned_date to track when the user resigned
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS resigned_date DATE;

-- Add notes about resignation
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS resignation_notes TEXT;

-- Verify columns were added
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'assets' 
AND column_name IN ('previous_user', 'resigned_date', 'resignation_notes');

-- ============================================================================
-- STEP 2: Identify Mobile Phones with Resigned Users
-- ============================================================================

-- First, let's see which mobile phones have assigned users
SELECT 
  id,
  name,
  serial_number,
  category,
  assigned_to,
  status,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND assigned_to IS NOT NULL
  AND assigned_to != ''
ORDER BY name;

-- ============================================================================
-- STEP 3: Update Mobile Phones - Move to Previous User & Mark Unassigned
-- ============================================================================

-- Option A: Update ALL mobile phones with assigned users
-- (Use this if all assigned users have resigned)

UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = CURRENT_DATE,
  status = 'in_stock',
  resignation_notes = 'User resigned - Asset returned to inventory on ' || CURRENT_DATE::text
WHERE category = 'Mobile Phone'
  AND assigned_to IS NOT NULL
  AND assigned_to != '';

-- ============================================================================
-- STEP 4: Update Specific Mobile Phones by User Name
-- ============================================================================

-- Option B: Update mobile phones for specific resigned users
-- Replace 'User Name' with actual names of resigned employees

-- Example 1: Single user
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-16',
  status = 'in_stock',
  resignation_notes = 'Employee resigned - Device returned to IT inventory'
WHERE category = 'Mobile Phone'
  AND assigned_to = 'John Doe';

-- Example 2: Multiple users (use IN clause)
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-16',
  status = 'in_stock',
  resignation_notes = 'Employee resigned - Device returned to IT inventory'
WHERE category = 'Mobile Phone'
  AND assigned_to IN ('John Doe', 'Jane Smith', 'Bob Johnson');

-- ============================================================================
-- STEP 5: Update by Serial Number or Asset Name
-- ============================================================================

-- If you have specific mobile phone serial numbers or names
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-16',
  status = 'in_stock',
  resignation_notes = 'Employee resigned - Device cleared and ready for reassignment'
WHERE serial_number IN ('MP-001', 'MP-002', 'MP-003');

-- ============================================================================
-- STEP 6: Verification Queries
-- ============================================================================

-- Check mobile phones that were updated
SELECT 
  'Updated Mobile Phones' as report,
  name,
  serial_number,
  previous_user,
  resigned_date,
  status,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND previous_user IS NOT NULL
ORDER BY resigned_date DESC;

-- Summary of mobile phones by status
SELECT 
  'Mobile Phone Status Summary' as report,
  status,
  COUNT(*) as count,
  array_agg(name ORDER BY name) as devices
FROM assets
WHERE category = 'Mobile Phone'
GROUP BY status
ORDER BY count DESC;

-- Mobile phones available for reassignment (unassigned + in_stock)
SELECT 
  'Available Mobile Phones' as report,
  name,
  serial_number,
  model,
  previous_user,
  resigned_date,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND (assigned_to IS NULL OR assigned_to = '')
  AND status = 'in_stock'
ORDER BY name;

-- Mobile phones with resignation history
SELECT 
  'Resignation History' as report,
  name,
  serial_number,
  previous_user,
  resigned_date,
  resignation_notes
FROM assets
WHERE category = 'Mobile Phone'
  AND previous_user IS NOT NULL
ORDER BY resigned_date DESC;

-- ============================================================================
-- STEP 7: Additional Updates for Different Resignation Scenarios
-- ============================================================================

-- Scenario 1: Device needs maintenance before reassignment
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = CURRENT_DATE,
  status = 'maintenance',
  resignation_notes = 'Requires factory reset and security wipe before reassignment'
WHERE category = 'Mobile Phone'
  AND assigned_to = 'Resigned User Name';

-- Scenario 2: Device to be retired/disposed
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = CURRENT_DATE,
  status = 'retired',
  resignation_notes = 'Device outdated - scheduled for disposal'
WHERE category = 'Mobile Phone'
  AND assigned_to = 'Resigned User Name'
  AND purchase_date < '2020-01-01';  -- Old devices

-- Scenario 3: Bulk update with different resignation dates
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-10-31',  -- Specific resignation date
  status = 'in_stock',
  resignation_notes = 'Q4 2025 resignation - Device returned and inventoried'
WHERE category = 'Mobile Phone'
  AND assigned_to IN (
    'Employee1', 
    'Employee2', 
    'Employee3'
  );

-- ============================================================================
-- STEP 8: Create View for Easy Tracking
-- ============================================================================

-- Create a view to easily see resigned user devices
CREATE OR REPLACE VIEW resigned_user_mobile_phones AS
SELECT 
  id,
  name,
  serial_number,
  model,
  manufacturer,
  previous_user,
  resigned_date,
  status,
  location,
  current_value,
  condition,
  resignation_notes,
  CASE 
    WHEN status = 'in_stock' THEN 'Available for Reassignment'
    WHEN status = 'maintenance' THEN 'Needs Service Before Reassignment'
    WHEN status = 'retired' THEN 'Scheduled for Disposal'
    ELSE 'Check Status'
  END as availability_status
FROM assets
WHERE category = 'Mobile Phone'
  AND previous_user IS NOT NULL
ORDER BY resigned_date DESC;

-- Query the view
SELECT * FROM resigned_user_mobile_phones;

-- ============================================================================
-- STEP 9: Statistics and Reporting
-- ============================================================================

-- Total mobile phones and their assignment status
SELECT 
  'Mobile Phone Inventory Report' as report,
  COUNT(*) as total_mobile_phones,
  COUNT(CASE WHEN assigned_to IS NOT NULL THEN 1 END) as currently_assigned,
  COUNT(CASE WHEN assigned_to IS NULL AND previous_user IS NOT NULL THEN 1 END) as resigned_user_devices,
  COUNT(CASE WHEN assigned_to IS NULL AND previous_user IS NULL THEN 1 END) as never_assigned,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as available_stock,
  COUNT(CASE WHEN status = 'maintenance' THEN 1 END) as in_maintenance
FROM assets
WHERE category = 'Mobile Phone';

-- Devices by resignation month
SELECT 
  'Resignations by Month' as report,
  TO_CHAR(resigned_date, 'YYYY-MM') as resignation_month,
  COUNT(*) as devices_returned,
  array_agg(previous_user) as resigned_users
FROM assets
WHERE category = 'Mobile Phone'
  AND resigned_date IS NOT NULL
GROUP BY TO_CHAR(resigned_date, 'YYYY-MM')
ORDER BY resignation_month DESC;

-- ============================================================================
-- STEP 10: Clean Up Test Data (Optional)
-- ============================================================================

-- If you need to revert changes (BE CAREFUL!)
/*
UPDATE assets
SET 
  assigned_to = previous_user,
  previous_user = NULL,
  resigned_date = NULL,
  resignation_notes = NULL,
  status = 'active'
WHERE category = 'Mobile Phone'
  AND previous_user IS NOT NULL;
*/

-- ============================================================================
-- DONE! Mobile phones updated with resignation tracking
-- ============================================================================

-- Final verification
SELECT 
  '✅ FINAL STATUS' as report,
  category,
  COUNT(*) as total,
  COUNT(assigned_to) as assigned,
  COUNT(previous_user) as with_resignation_history,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as available
FROM assets
WHERE category = 'Mobile Phone'
GROUP BY category;
