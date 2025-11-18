-- Test Users Creation Script
-- AssetFlow Application
-- Date: November 18, 2025
-- Purpose: Create test users with different roles for testing approval/rejection flows

-- ============================================
-- TEST USERS FOR ASSETFLOW
-- ============================================

-- Note: These users are for testing purposes only
-- In production, users will authenticate via Azure AD (Entra ID)

-- ============================================
-- 1. ADMIN USERS (Can approve/reject requests)
-- ============================================

-- Admin 1: IT Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'admin@assetflow.com',
  'John Administrator',
  'admin',
  'IT',
  '+971-50-1234567',
  'IT Manager',
  TRUE,
  'azure-admin-001',
  NOW(),
  NOW()
);

-- Admin 2: HR Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'hr.admin@assetflow.com',
  'Sarah HR Lead',
  'admin',
  'Human Resources',
  '+971-50-2234567',
  'HR Manager',
  TRUE,
  'azure-admin-002',
  NOW(),
  NOW()
);

-- Admin 3: Finance Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'finance.admin@assetflow.com',
  'Michael Finance',
  'admin',
  'Finance',
  '+971-50-3234567',
  'Finance Manager',
  TRUE,
  'azure-admin-003',
  NOW(),
  NOW()
);

-- ============================================
-- 2. MANAGER USERS (Can view department requests)
-- ============================================

-- Manager 1: IT Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'it.manager@assetflow.com',
  'David IT Manager',
  'manager',
  'IT',
  '+971-50-4234567',
  'IT Team Lead',
  TRUE,
  'azure-mgr-001',
  NOW(),
  NOW()
);

-- Manager 2: Sales Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'sales.manager@assetflow.com',
  'Lisa Sales Manager',
  'manager',
  'Sales',
  '+971-50-5234567',
  'Sales Team Lead',
  TRUE,
  'azure-mgr-002',
  NOW(),
  NOW()
);

-- Manager 3: Operations Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'ops.manager@assetflow.com',
  'Tom Operations',
  'manager',
  'Operations',
  '+971-50-6234567',
  'Operations Manager',
  TRUE,
  'azure-mgr-003',
  NOW(),
  NOW()
);

-- ============================================
-- 3. REGULAR USERS (Can submit requests)
-- ============================================

-- User 1: IT Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'developer1@assetflow.com',
  'Alice Developer',
  'user',
  'IT',
  '+971-50-7234567',
  'Software Developer',
  TRUE,
  'azure-user-001',
  NOW(),
  NOW()
);

-- User 2: IT Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'developer2@assetflow.com',
  'Bob Developer',
  'user',
  'IT',
  '+971-50-8234567',
  'Senior Developer',
  TRUE,
  'azure-user-002',
  NOW(),
  NOW()
);

-- User 3: Sales Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'sales1@assetflow.com',
  'Emma Sales',
  'user',
  'Sales',
  '+971-50-9234567',
  'Sales Executive',
  TRUE,
  'azure-user-003',
  NOW(),
  NOW()
);

-- User 4: Sales Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'sales2@assetflow.com',
  'James Sales',
  'user',
  'Sales',
  '+971-50-0234567',
  'Senior Sales Executive',
  TRUE,
  'azure-user-004',
  NOW(),
  NOW()
);

-- User 5: HR Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'hr1@assetflow.com',
  'Sophia HR',
  'user',
  'Human Resources',
  '+971-50-1134567',
  'HR Specialist',
  TRUE,
  'azure-user-005',
  NOW(),
  NOW()
);

-- User 6: Finance Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'finance1@assetflow.com',
  'Oliver Finance',
  'user',
  'Finance',
  '+971-50-1234667',
  'Financial Analyst',
  TRUE,
  'azure-user-006',
  NOW(),
  NOW()
);

-- User 7: Operations Department
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'ops1@assetflow.com',
  'Ava Operations',
  'user',
  'Operations',
  '+971-50-1234767',
  'Operations Coordinator',
  TRUE,
  'azure-user-007',
  NOW(),
  NOW()
);

-- ============================================
-- 4. TEST USER (For quick testing)
-- ============================================

-- Test User: Generic test account
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  phone,
  job_title,
  active,
  azure_user_id,
  created_at,
  updated_at
) VALUES (
  gen_random_uuid(),
  'test@assetflow.com',
  'Test User',
  'user',
  'IT',
  '+971-50-9999999',
  'Test Account',
  TRUE,
  'azure-test-001',
  NOW(),
  NOW()
);

-- ============================================
-- SUMMARY
-- ============================================
-- Total Users Created: 14
--
-- Admins (3):
--   - admin@assetflow.com (IT)
--   - hr.admin@assetflow.com (HR)
--   - finance.admin@assetflow.com (Finance)
--
-- Managers (3):
--   - it.manager@assetflow.com (IT)
--   - sales.manager@assetflow.com (Sales)
--   - ops.manager@assetflow.com (Operations)
--
-- Users (7):
--   - developer1@assetflow.com (IT)
--   - developer2@assetflow.com (IT)
--   - sales1@assetflow.com (Sales)
--   - sales2@assetflow.com (Sales)
--   - hr1@assetflow.com (HR)
--   - finance1@assetflow.com (Finance)
--   - ops1@assetflow.com (Operations)
--
-- Test User (1):
--   - test@assetflow.com (IT)
--
-- ============================================
-- TESTING SCENARIOS
-- ============================================
--
-- 1. APPROVAL FLOW:
--    Login as: admin@assetflow.com
--    Action: Approve a system access request
--    Expected: Status → approved, notification sent
--
-- 2. REJECTION FLOW:
--    Login as: hr.admin@assetflow.com
--    Action: Reject a request with reason
--    Expected: Modal opens, reason required, status → rejected
--
-- 3. USER SUBMISSION:
--    Login as: developer1@assetflow.com
--    Action: Submit new system access request
--    Expected: Request created, notification to admins
--
-- 4. MANAGER VIEW:
--    Login as: it.manager@assetflow.com
--    Action: View requests from IT department
--    Expected: See only IT department requests
--
-- 5. ROLE PERMISSIONS:
--    Login as: sales1@assetflow.com
--    Action: Try to approve a request
--    Expected: No approve/reject buttons visible
--
-- ============================================
-- NOTE: Default Password
-- ============================================
-- These users are created for testing only.
-- Once Azure AD authentication is implemented,
-- users will authenticate through Entra ID.
-- For now, use mock authentication in development.
