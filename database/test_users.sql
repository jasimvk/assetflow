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
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'admin-001',
  'admin@assetflow.com',
  'John Administrator',
  'admin',
  'IT',
  'EMP-001',
  '+971-50-1234567',
  'active',
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
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'admin-002',
  'hr.admin@assetflow.com',
  'Sarah HR Manager',
  'admin',
  'HR',
  'EMP-002',
  '+971-50-2345678',
  'active',
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
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'admin-003',
  'finance.admin@assetflow.com',
  'Michael Finance',
  'admin',
  'Finance',
  'EMP-003',
  '+971-50-3456789',
  'active',
  NOW(),
  NOW()
);

-- ============================================
-- 2. MANAGER USERS (Department heads)
-- ============================================

-- Manager 1: IT Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'manager-001',
  'it.manager@assetflow.com',
  'David IT Manager',
  'manager',
  'IT',
  'EMP-101',
  '+971-50-4567890',
  'active',
  NOW(),
  NOW()
);

-- Manager 2: Operations Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'manager-002',
  'ops.manager@assetflow.com',
  'Lisa Operations',
  'manager',
  'Operations',
  'EMP-102',
  '+971-50-5678901',
  'active',
  NOW(),
  NOW()
);

-- Manager 3: Sales Manager
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'manager-003',
  'sales.manager@assetflow.com',
  'Robert Sales',
  'manager',
  'Sales',
  'EMP-103',
  '+971-50-6789012',
  'active',
  NOW(),
  NOW()
);

-- ============================================
-- 3. REGULAR USERS (Employees who request access)
-- ============================================

-- User 1: Junior Developer
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-001',
  'john.developer@assetflow.com',
  'John Developer',
  'user',
  'IT',
  'EMP-201',
  '+971-50-7890123',
  'active',
  NOW(),
  NOW()
);

-- User 2: HR Executive
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-002',
  'emma.hr@assetflow.com',
  'Emma HR Executive',
  'user',
  'HR',
  'EMP-202',
  '+971-50-8901234',
  'active',
  NOW(),
  NOW()
);

-- User 3: Accountant
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-003',
  'james.finance@assetflow.com',
  'James Accountant',
  'user',
  'Finance',
  'EMP-203',
  '+971-50-9012345',
  'active',
  NOW(),
  NOW()
);

-- User 4: Sales Executive
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-004',
  'sophia.sales@assetflow.com',
  'Sophia Sales Exec',
  'user',
  'Sales',
  'EMP-204',
  '+971-50-0123456',
  'active',
  NOW(),
  NOW()
);

-- User 5: Marketing Coordinator
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-005',
  'olivia.marketing@assetflow.com',
  'Olivia Marketing',
  'user',
  'Marketing',
  'EMP-205',
  '+971-50-1234098',
  'active',
  NOW(),
  NOW()
);

-- User 6: Operations Assistant
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-006',
  'william.ops@assetflow.com',
  'William Operations',
  'user',
  'Operations',
  'EMP-206',
  '+971-50-2345109',
  'active',
  NOW(),
  NOW()
);

-- User 7: New Hire (Pending)
INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'user-007',
  'newhire@assetflow.com',
  'Alex New Hire',
  'user',
  'IT',
  'EMP-207',
  '+971-50-3456210',
  'inactive',
  NOW(),
  NOW()
);

-- ============================================
-- 4. TEST USER (For development/debugging)
-- ============================================

INSERT INTO users (
  id,
  email,
  name,
  role,
  department,
  employee_id,
  phone,
  status,
  created_at,
  updated_at
) VALUES (
  'test-user-999',
  'test@assetflow.com',
  'Test User',
  'admin',
  'IT',
  'EMP-999',
  '+971-50-9999999',
  'active',
  NOW(),
  NOW()
);

-- ============================================
-- SUMMARY
-- ============================================
-- Total Users Created: 14
--   - 3 Admins (can approve/reject)
--   - 3 Managers (department heads)
--   - 7 Regular Users (employees)
--   - 1 Test User

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check all created users
SELECT 
  id,
  name,
  email,
  role,
  department,
  employee_id,
  status
FROM users
ORDER BY role, department, name;

-- Count users by role
SELECT 
  role,
  COUNT(*) as count
FROM users
GROUP BY role
ORDER BY role;

-- Count users by department
SELECT 
  department,
  COUNT(*) as count
FROM users
GROUP BY department
ORDER BY department;

-- Check active users
SELECT 
  COUNT(*) as active_users
FROM users
WHERE status = 'active';
