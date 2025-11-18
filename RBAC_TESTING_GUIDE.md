# 🧪 RBAC Testing Guide

**AssetFlow Application**  
**Date**: November 18, 2025

---

## 📋 Overview

This guide provides comprehensive testing scenarios for the Role-Based Access Control (RBAC) system in AssetFlow. Use the 14 test users to verify proper role enforcement across all features.

---

## 👥 Test Users Reference

### 🔴 Admin Users (Full Access)

| Email | Password | Department | Purpose |
|-------|----------|------------|---------|
| `admin@assetflow.com` | `Admin123!` | IT | Primary system admin |
| `hr.admin@assetflow.com` | `HRAdmin123!` | HR | HR department admin |
| `finance.admin@assetflow.com` | `FinAdmin123!` | Finance | Finance department admin |

**Expected Capabilities**: ALL features, ALL data, ALL departments

---

### 🟡 Manager Users (Department Access)

| Email | Password | Department | Purpose |
|-------|----------|------------|---------|
| `it.manager@assetflow.com` | `ITMgr123!` | IT | IT department manager |
| `sales.manager@assetflow.com` | `SalesMgr123!` | Sales | Sales department manager |
| `ops.manager@assetflow.com` | `OpsMgr123!` | Operations | Operations department manager |

**Expected Capabilities**: Department-level access, team request creation, department reports

---

### 🟢 Standard Users (Self Access)

| Email | Password | Department | Purpose |
|-------|----------|------------|---------|
| `developer1@assetflow.com` | `Dev123!` | IT | IT developer |
| `developer2@assetflow.com` | `Dev123!` | IT | IT developer |
| `sales1@assetflow.com` | `Sales123!` | Sales | Sales representative |
| `sales2@assetflow.com` | `Sales123!` | Sales | Sales representative |
| `hr1@assetflow.com` | `HR123!` | HR | HR coordinator |
| `finance1@assetflow.com` | `Finance123!` | Finance | Finance analyst |
| `ops1@assetflow.com` | `Ops123!` | Operations | Operations coordinator |

**Expected Capabilities**: View own assets, submit requests, personal notifications

---

### 🔵 Test User (Special)

| Email | Password | Department | Purpose |
|-------|----------|------------|---------|
| `test@assetflow.com` | `Test123!` | IT | General testing account |

---

## 🧪 Test Scenarios

### Test 1: Admin Full Access ✅

**Login**: `admin@assetflow.com` / `Admin123!`

#### Assets Page
```
✅ Should see "All Assets" filter option
✅ Should see assets from ALL departments (IT, Sales, HR, Finance, Operations)
✅ Should see "Create Asset" button
✅ Should see "Import Assets" button
✅ Should see "Bulk Actions" dropdown
✅ Should be able to click "Edit" on any asset
✅ Should be able to click "Delete" on any asset
✅ Should see total asset count across organization
```

#### System Access Page
```
✅ Should see ALL system access requests (all departments)
✅ Should see "Approve" button on pending requests
✅ Should see "Reject" button on pending requests
✅ Should see "New Request" button
✅ Should see requests from all users (not just IT)
✅ Clicking "Approve" should change status to approved
✅ Clicking "Reject" should show rejection reason modal
```

#### Users Page
```
✅ Page should load (not redirect or 403)
✅ Should see all 14 test users
✅ Should see "Add User" button
✅ Should see "Edit" button on each user
✅ Should see role dropdown on edit (Admin/Manager/User)
✅ Should be able to change user roles
✅ Should see "Deactivate" button
```

#### Settings Page
```
✅ Page should load
✅ Should see "System Settings" section
✅ Should see "Category Management"
✅ Should see "Location Management"
✅ Should see "Integration Settings"
✅ Should be able to save changes
```

#### Reports & Analytics
```
✅ Should see "All Departments" in department filter
✅ Should see organization-wide asset counts
✅ Should see all department breakdowns
✅ Should see complete utilization metrics
✅ Should see all maintenance history
✅ Export should include all data
```

---

### Test 2: Manager Department Scope 🔒

**Login**: `it.manager@assetflow.com` / `ITMgr123!`

#### Assets Page
```
✅ Should see ONLY IT department assets
❌ Should NOT see Sales department assets
❌ Should NOT see HR department assets
❌ Should NOT see Finance department assets
❌ Should NOT see Operations department assets
❌ Should NOT see "Create Asset" button
✅ Should see "Request Asset" button
✅ Should see asset count for IT department only
✅ Filter should default to "My Department"
```

**Verify Department Isolation**:
```bash
# Test with different manager
Login as: sales.manager@assetflow.com

✅ Should see ONLY Sales department assets
❌ Should NOT see IT department assets
```

#### System Access Page
```
✅ Should see "New Request" button
✅ Should see "Create for Team Member" option
✅ Should see ONLY IT department requests
❌ Should NOT see requests from Sales/HR/Finance/Operations
❌ Should NOT see "Approve" button
❌ Should NOT see "Reject" button
✅ Should be able to create request for team (developer1, developer2)
```

#### Users Page
```
❌ Should redirect to home page OR show 403 Forbidden
❌ Should not be able to access /users route
```

#### Settings Page
```
❌ Should redirect to home page OR show 403 Forbidden
❌ Should not be able to access /settings route
```

#### Reports & Analytics
```
✅ Should see "My Department" filter only
✅ Should see only IT department metrics
✅ Asset count should match IT department count
✅ Export should include only IT department data
❌ Should NOT see "All Departments" option
```

#### Maintenance Requests
```
✅ Should see maintenance requests for IT assets
✅ Should see "Approve Maintenance" button for own dept
✅ Should be able to approve maintenance for IT assets
❌ Should NOT see maintenance for other departments
```

---

### Test 3: User Self Access 🔐

**Login**: `developer1@assetflow.com` / `Dev123!`

#### Assets Page
```
✅ Should see ONLY assets assigned to developer1
❌ Should NOT see developer2's assets (same department!)
❌ Should NOT see unassigned IT assets
❌ Should NOT see other department assets
❌ Should NOT see "Create Asset" button
❌ Should NOT see "Import Assets" button
✅ Should see "Request Maintenance" button for own assets
✅ Filter should show "My Assets" only
```

**Verify User Isolation (Same Department)**:
```bash
# Login as different user in same department
Login as: developer2@assetflow.com

✅ Should see ONLY developer2's assets
❌ Should NOT see developer1's assets (even though same IT dept)
```

#### System Access Page
```
✅ Should see "New Request" button
✅ Should see ONLY own system access requests
❌ Should NOT see requests from developer2
❌ Should NOT see requests from it.manager
❌ Should NOT see "Approve" button
❌ Should NOT see "Reject" button
✅ Should be able to create new request for self
❌ Should NOT see "Create for Team" option
```

#### Users Page
```
❌ Should redirect to home page OR show 403 Forbidden
❌ Should not be able to access /users route
```

#### Settings Page
```
❌ Should redirect to home page OR show 403 Forbidden
❌ Should not be able to access /settings route
```

#### Profile Page
```
✅ Should see own profile information
✅ Should see "Edit Profile" button
✅ Should be able to update name, email, phone
❌ Should NOT see "Change Role" dropdown
❌ Should NOT be able to change own role
```

#### Reports & Analytics
```
✅ Should see personal summary only
✅ Should see count of assets assigned to them
✅ Should see their own request history
❌ Should NOT see department-wide metrics
❌ Should NOT see other users' data
```

#### Notifications
```
✅ Should see only own notifications
✅ Should see notifications about their assets
✅ Should see updates on their system access requests
❌ Should NOT see notifications for developer2
```

---

### Test 4: Cross-Department Isolation 🚫

**Purpose**: Verify managers and users cannot access other departments

#### Test A: Sales Manager → IT Data
```bash
Login as: sales.manager@assetflow.com

Navigate to: /assets
✅ Should see only Sales department assets
❌ Should NOT see any IT assets
❌ Should NOT see assets assigned to developer1 or developer2

Navigate to: /system-access  
✅ Should see only Sales department requests
❌ Should NOT see IT department requests
❌ Should NOT see requests from it.manager

Navigate to: /reports
✅ Should see only Sales metrics
❌ Should NOT see IT department metrics
```

#### Test B: Sales User → Sales Manager Data
```bash
Login as: sales1@assetflow.com

Navigate to: /assets
✅ Should see only assets assigned to sales1
❌ Should NOT see assets of sales2 (same department!)
❌ Should NOT see unassigned Sales department assets
❌ Should NOT see sales.manager's view

Navigate to: /system-access
✅ Should see only own requests
❌ Should NOT see sales2's requests
❌ Should NOT see sales.manager's requests
```

#### Test C: User → Another Department
```bash
Login as: hr1@assetflow.com (HR department)

Navigate to: /assets
❌ Should NOT see any IT, Sales, Finance, or Operations assets
✅ Should see only own HR assets

Navigate to: /system-access
❌ Should NOT see requests from other departments
✅ Should see only own requests
```

---

### Test 5: Permission-Based Actions ✋

#### Create Asset Permission
```
Admin (admin@assetflow.com):
  ✅ "Create Asset" button visible
  ✅ Can open create modal
  ✅ Can save new asset

Manager (it.manager@assetflow.com):
  ❌ "Create Asset" button hidden
  ❌ Direct POST to /api/assets returns 403

User (developer1@assetflow.com):
  ❌ "Create Asset" button hidden
  ❌ Direct POST to /api/assets returns 403
```

#### Approve System Access Permission
```
Admin (admin@assetflow.com):
  ✅ "Approve" button visible on pending requests
  ✅ Can click approve
  ✅ Request status changes to approved

Manager (it.manager@assetflow.com):
  ❌ "Approve" button hidden
  ❌ Direct POST to /api/system-access/:id/approve returns 403

User (developer1@assetflow.com):
  ❌ "Approve" button hidden
  ❌ Direct POST to /api/system-access/:id/approve returns 403
```

#### Manage Users Permission
```
Admin (admin@assetflow.com):
  ✅ Can access /users page
  ✅ Can see "Edit" button
  ✅ Can change user roles
  ✅ Can deactivate users

Manager (it.manager@assetflow.com):
  ❌ /users page redirects or shows 403
  ❌ Direct GET to /api/users returns 403

User (developer1@assetflow.com):
  ❌ /users page redirects or shows 403
  ❌ Direct GET to /api/users returns 403
```

---

### Test 6: Data Scope API Testing 🔧

Use these curl commands to verify backend filtering:

#### Test Admin (No Filter)
```bash
# Login to get token
TOKEN=$(curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@assetflow.com","password":"Admin123!"}' \
  | jq -r '.token')

# Get assets (should return ALL)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/assets | jq '.length'
# Expected: ~50+ assets (all departments)

# Get system access (should return ALL)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/system-access | jq '.length'
# Expected: All requests from all departments
```

#### Test Manager (Department Filter)
```bash
# Login as IT manager
TOKEN=$(curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"it.manager@assetflow.com","password":"ITMgr123!"}' \
  | jq -r '.token')

# Get assets (should return only IT)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/assets | jq '[.[] | .department] | unique'
# Expected: ["IT"] only

# Get system access (should return only IT)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/system-access | jq '[.[] | .department] | unique'
# Expected: ["IT"] only
```

#### Test User (User Filter)
```bash
# Login as developer1
TOKEN=$(curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"developer1@assetflow.com","password":"Dev123!"}' \
  | jq -r '.token')

# Get assets (should return only assigned to developer1)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/assets | jq '[.[] | .assigned_to] | unique'
# Expected: ["<developer1-user-id>"] only

# Get system access (should return only developer1's requests)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/system-access | jq '[.[] | .requester_id] | unique'
# Expected: ["<developer1-user-id>"] only
```

---

### Test 7: UI Component Visibility 👁️

Verify UI elements show/hide based on role:

#### Admin UI Elements
```
Login as: admin@assetflow.com

Assets Page:
  ✅ "Create Asset" button
  ✅ "Import Assets" button
  ✅ "Bulk Actions" dropdown
  ✅ "Delete" button on rows
  ✅ "Export All" button

System Access Page:
  ✅ "Approve" button
  ✅ "Reject" button
  ✅ "Bulk Approve" option

Sidebar:
  ✅ "Users" link
  ✅ "Settings" link
  ✅ "Reports" link
  ✅ "Analytics" link
```

#### Manager UI Elements
```
Login as: it.manager@assetflow.com

Assets Page:
  ❌ NO "Create Asset" button
  ❌ NO "Import Assets" button
  ❌ NO "Bulk Actions" dropdown
  ❌ NO "Delete" button on rows
  ✅ "Export Department" button
  ✅ "Request Asset" button

System Access Page:
  ❌ NO "Approve" button
  ❌ NO "Reject" button
  ✅ "Create Request" button
  ✅ "Create for Team" option

Sidebar:
  ❌ NO "Users" link
  ❌ NO "Settings" link
  ✅ "Reports" link (department only)
  ✅ "Team" submenu
```

#### User UI Elements
```
Login as: developer1@assetflow.com

Assets Page:
  ❌ NO "Create Asset" button
  ❌ NO "Import Assets" button
  ❌ NO "Export" button
  ✅ "Request Maintenance" button (on own assets)

System Access Page:
  ❌ NO "Approve" button
  ❌ NO "Reject" button
  ❌ NO "Create for Team" option
  ✅ "New Request" button (for self)

Sidebar:
  ❌ NO "Users" link
  ❌ NO "Settings" link
  ❌ NO "Reports" link (or personal summary only)
  ✅ "My Assets" link
  ✅ "My Requests" link
  ✅ "Profile" link
```

---

## ✅ Testing Checklist

Use this checklist to verify full RBAC implementation:

### Backend Testing
```
□ Admin can access all endpoints
□ Manager gets 403 on admin-only endpoints (/users, /settings)
□ User gets 403 on admin/manager endpoints
□ Assets API filters by department for managers
□ Assets API filters by user_id for users
□ System access API filters by department for managers
□ System access API filters by requester_id for users
□ Approve/reject endpoints require admin role
□ Delete endpoints require appropriate permissions
□ Audit logs record access attempts
```

### Frontend Testing
```
□ Admin sees all UI elements
□ Manager sees limited UI elements (no user management)
□ User sees minimal UI elements (self-service only)
□ Page protection redirects work (useRoleProtection)
□ RoleGuard components hide/show correctly
□ Data scope hook filters API calls
□ hasPermission checks work in components
□ Role badges display correctly
□ Unauthorized routes show 403 or redirect
```

### Cross-Role Testing
```
□ Admin can see all departments' data
□ IT manager cannot see Sales data
□ Sales manager cannot see IT data
□ developer1 cannot see developer2's assets (same dept!)
□ sales1 cannot see sales2's requests (same dept!)
□ Users from different departments are fully isolated
```

### Permission Testing
```
□ ASSETS.CREATE - Admin only
□ ASSETS.DELETE_ALL - Admin only
□ SYSTEM_ACCESS.APPROVE - Admin only
□ SYSTEM_ACCESS.CREATE_TEAM - Admin + Manager
□ USERS.ASSIGN_ROLE - Admin only
□ REPORTS.VIEW_ALL - Admin only
□ REPORTS.VIEW_DEPARTMENT - Admin + Manager
□ SETTINGS.UPDATE - Admin only
```

---

## 🐛 Common Issues & Debugging

### Issue 1: User Sees Other Department's Data
**Symptom**: Manager sees assets from multiple departments

**Debug Steps**:
1. Check backend middleware:
   ```javascript
   // In route: should have applyDataScope()
   router.get('/assets', authenticate, applyDataScope(), handler);
   ```

2. Check req.filters in handler:
   ```javascript
   console.log('Filters:', req.filters);
   // Should show: { department: 'IT' } for manager
   ```

3. Verify database query uses filters:
   ```javascript
   const assets = await db.assets.findAll({ where: req.filters });
   ```

---

### Issue 2: Admin Sees 403 Error
**Symptom**: Admin gets forbidden on legitimate endpoints

**Debug Steps**:
1. Check user role in token:
   ```javascript
   console.log('User:', req.user);
   // Should show: { id: '...', role: 'admin', ... }
   ```

2. Verify middleware order:
   ```javascript
   // Correct order:
   router.get('/users',
     authenticate,      // ← Must be first
     requireRole(ROLES.ADMIN),
     handler
   );
   ```

3. Check role constant spelling:
   ```javascript
   // Correct:
   requireRole(ROLES.ADMIN)  // ← Use constant
   
   // Wrong:
   requireRole('Admin')      // ← Case sensitive!
   ```

---

### Issue 3: UI Button Shows But API Returns 403
**Symptom**: User sees "Approve" button but API call fails

**Debug Steps**:
1. Check frontend role check:
   ```tsx
   const { hasPermission } = useRole();
   
   // Should use actual permission:
   {hasPermission(PERMISSIONS.SYSTEM_ACCESS.APPROVE) && (
     <button>Approve</button>
   )}
   ```

2. Verify backend permission matches:
   ```javascript
   router.post('/approve',
     requirePermission(PERMISSIONS.SYSTEM_ACCESS.APPROVE),
     handler
   );
   ```

3. Check shared/roles.js permission mapping:
   ```javascript
   [ROLES.USER]: [
     // Should NOT include:
     PERMISSIONS.SYSTEM_ACCESS.APPROVE  // ← Admin only
   ]
   ```

---

## 📊 Testing Summary Report Template

```markdown
## RBAC Testing Report
**Date**: [Date]
**Tester**: [Name]

### Admin Testing (admin@assetflow.com)
- [ ] Full access to all features: ✅ / ❌
- [ ] Can manage users: ✅ / ❌
- [ ] Can approve requests: ✅ / ❌
- [ ] Sees all departments: ✅ / ❌

### Manager Testing (it.manager@assetflow.com)
- [ ] Sees only IT department: ✅ / ❌
- [ ] Cannot manage users: ✅ / ❌
- [ ] Cannot approve system access: ✅ / ❌
- [ ] Can create team requests: ✅ / ❌

### User Testing (developer1@assetflow.com)
- [ ] Sees only own assets: ✅ / ❌
- [ ] Cannot see developer2's data: ✅ / ❌
- [ ] Can create own requests: ✅ / ❌
- [ ] Cannot access admin pages: ✅ / ❌

### Cross-Department Testing
- [ ] Sales manager isolated from IT: ✅ / ❌
- [ ] HR user isolated from Finance: ✅ / ❌

### Issues Found
1. [Issue description]
2. [Issue description]

### Conclusion
- Overall RBAC Status: ✅ PASS / ❌ FAIL
- Notes: [Additional notes]
```

---

## 🎉 Success Criteria

Your RBAC implementation is successful when:

✅ **All 14 test users** can login  
✅ **Admins** see everything (all departments, all features)  
✅ **Managers** see only their department (IT, Sales, Operations)  
✅ **Users** see only their own data (not even same department colleagues)  
✅ **403 errors** occur when accessing unauthorized endpoints  
✅ **UI elements** hide/show based on role  
✅ **API calls** automatically filter data  
✅ **Cross-department** access is blocked  
✅ **Permissions** are enforced on both frontend and backend  

---

## 📚 Related Documentation

- [RBAC Implementation Guide](./RBAC_IMPLEMENTATION_GUIDE.md) - How to use RBAC system
- [shared/roles.js](./shared/roles.js) - Role and permission constants
- [backend/src/middleware/rbac.js](./backend/src/middleware/rbac.js) - Backend middleware
- [frontend/utils/rbac.tsx](./frontend/utils/rbac.tsx) - Frontend utilities

---

**Happy Testing! 🚀**
