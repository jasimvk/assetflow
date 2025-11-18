-- ============================================
-- RESET TEST USERS (OPTIONAL)
-- ============================================
-- Only run this if you need to recreate test users
-- WARNING: This will delete existing test users
-- AssetFlow Application

-- ============================================
-- STEP 1: DELETE EXISTING TEST USERS
-- ============================================

-- Delete test users (preserves production users)
DELETE FROM users
WHERE email IN (
  'admin@assetflow.com',
  'hr.admin@assetflow.com',
  'finance.admin@assetflow.com',
  'it.manager@assetflow.com',
  'sales.manager@assetflow.com',
  'ops.manager@assetflow.com',
  'developer1@assetflow.com',
  'developer2@assetflow.com',
  'sales1@assetflow.com',
  'sales2@assetflow.com',
  'hr1@assetflow.com',
  'finance1@assetflow.com',
  'ops1@assetflow.com',
  'test@assetflow.com'
);

-- Verify deletion
SELECT COUNT(*) as deleted_count
FROM users
WHERE email LIKE '%@assetflow.com';

-- ============================================
-- STEP 2: RUN test_users_fixed.sql
-- ============================================
-- After running this, execute test_users_fixed.sql
-- to recreate all 14 test users
