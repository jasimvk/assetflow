-- ============================================
-- VERIFY TEST USERS
-- ============================================
-- Run this to check if test users already exist
-- AssetFlow Application

-- Check all test users
SELECT 
  email,
  name,
  role,
  department,
  job_title,
  active,
  created_at
FROM users
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
)
ORDER BY 
  CASE role
    WHEN 'admin' THEN 1
    WHEN 'manager' THEN 2
    WHEN 'user' THEN 3
  END,
  email;

-- Count by role
SELECT 
  role,
  COUNT(*) as count
FROM users
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
)
GROUP BY role
ORDER BY 
  CASE role
    WHEN 'admin' THEN 1
    WHEN 'manager' THEN 2
    WHEN 'user' THEN 3
  END;
