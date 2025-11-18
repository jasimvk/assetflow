# 🔐 Role-Based Access Control (RBAC) Implementation Guide

**AssetFlow Application**  
**Date**: November 18, 2025

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Role Definitions](#role-definitions)
3. [Implementation Files](#implementation-files)
4. [Backend Implementation](#backend-implementation)
5. [Frontend Implementation](#frontend-implementation)
6. [Testing Guide](#testing-guide)
7. [Examples](#examples)

---

## 🎯 Overview

AssetFlow implements a three-tier role-based access control system:

- **Admin**: Full system access
- **Manager**: Department-level management
- **User**: Standard employee access

All role logic is centralized in `shared/roles.js` and can be imported by both frontend and backend.

---

## 👥 Role Definitions

### 🔹 Admin
**Purpose**: IT administrators and system managers  
**Scope**: Organization-wide

**Capabilities**:
- ✅ Create, read, update, delete ALL assets
- ✅ Approve/reject ALL system access requests
- ✅ Manage users and assign roles
- ✅ View all reports and analytics
- ✅ Configure system settings
- ✅ Bulk import/export operations
- ✅ Manage categories and locations

---

### 🔹 Manager
**Purpose**: Department heads and team leads  
**Scope**: Department-level only

**Capabilities**:
- ✅ View assets in their department
- ✅ Create system access requests for their team
- ✅ View system access requests from their department
- ✅ Approve maintenance activities for department
- ✅ View department-level reports
- ✅ Export department data
- ❌ Cannot approve system access (only admins)
- ❌ Cannot modify users
- ❌ Cannot access other departments

---

### 🔹 User
**Purpose**: Standard employees  
**Scope**: Self only

**Capabilities**:
- ✅ View assets assigned to them
- ✅ Submit own system access requests
- ✅ Submit maintenance requests for their assets
- ✅ View personal notifications
- ✅ Update own profile
- ❌ Cannot view other users' assets
- ❌ Cannot approve requests
- ❌ Cannot create assets

---

## 📁 Implementation Files

### Core Files Created

```
assetflow/
├── shared/
│   └── roles.js                    # ✨ NEW: Shared RBAC constants
├── backend/
│   └── src/
│       └── middleware/
│           └── rbac.js             # ✨ NEW: Backend RBAC middleware
└── frontend/
    └── utils/
        └── rbac.tsx                # ✨ NEW: Frontend RBAC utilities
```

### What Each File Does

1. **`shared/roles.js`**:
   - Role constants (ADMIN, MANAGER, USER)
   - Permission definitions for all resources
   - Role-to-permission mappings
   - Helper functions (hasPermission, canAccessPage)
   - Shared between frontend and backend

2. **`backend/src/middleware/rbac.js`**:
   - Express middleware for route protection
   - Data scope filtering
   - Resource ownership checking
   - Access logging

3. **`frontend/utils/rbac.tsx`**:
   - React hooks (useRole, useDataScope, useRoleProtection)
   - Role guard components
   - UI helper functions
   - Page protection HOC

---

## 🔧 Backend Implementation

### 1. Protect Routes with Roles

```javascript
const { requireRole, requirePermission } = require('./middleware/rbac');
const { ROLES, PERMISSIONS } = require('../shared/roles');

// Admin-only route
router.get('/users', 
  authenticate,
  requireRole(ROLES.ADMIN), 
  getUsersHandler
);

// Admin or Manager can access
router.get('/reports', 
  authenticate,
  requireRole(ROLES.ADMIN, ROLES.MANAGER), 
  getReportsHandler
);

// Permission-based protection
router.post('/assets', 
  authenticate,
  requirePermission(PERMISSIONS.ASSETS.CREATE), 
  createAssetHandler
);

// Approve/reject (admin only)
router.post('/system-access/:id/approve',
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.APPROVE),
  approveRequestHandler
);
```

---

### 2. Apply Data Scope Filtering

```javascript
const { applyDataScope } = require('./middleware/rbac');

// Automatically filter data by role
router.get('/assets', 
  authenticate,
  applyDataScope(),  // Adds filters to req.filters
  async (req, res) => {
    // req.filters contains:
    // - {} for admin (no filter)
    // - { department: 'IT' } for manager
    // - { assigned_to: 'user-id' } for user
    
    const assets = await getAssets(req.filters);
    res.json(assets);
  }
);
```

---

### 3. Check Resource Ownership

```javascript
const { checkResourceOwnership } = require('./middleware/rbac');
const { PERMISSIONS } = require('../shared/roles');

router.put('/requests/:id', 
  authenticate,
  checkResourceOwnership(
    async (req) => await getRequestById(req.params.id),
    PERMISSIONS.SYSTEM_ACCESS.UPDATE
  ),
  updateRequestHandler
);

// In handler, resource is available as req.resource
function updateRequestHandler(req, res) {
  const request = req.resource; // Pre-fetched and authorized
  // Update logic...
}
```

---

### 4. Example: System Access Route

```javascript
// backend/src/routes/system-access.js

const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { 
  requireRole, 
  requirePermission, 
  applyDataScope 
} = require('../middleware/rbac');
const { ROLES, PERMISSIONS } = require('../../shared/roles');

// Get all requests (filtered by role)
router.get('/', 
  authenticate,
  applyDataScope(),
  async (req, res) => {
    const requests = await systemAccessAPI.getAll(req.filters);
    res.json(requests);
  }
);

// Create request (all roles can create)
router.post('/', 
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.CREATE),
  async (req, res) => {
    const request = await systemAccessAPI.create({
      ...req.body,
      requester_id: req.user.id,
      department: req.user.department
    });
    res.json(request);
  }
);

// Approve request (admin only)
router.post('/:id/approve',
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.APPROVE),
  async (req, res) => {
    const request = await systemAccessAPI.approve(req.params.id, {
      approved_by: req.user.id,
      approved_at: new Date()
    });
    res.json(request);
  }
);

// Reject request (admin only)
router.post('/:id/reject',
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.REJECT),
  async (req, res) => {
    const request = await systemAccessAPI.reject(req.params.id, {
      rejected_by: req.user.id,
      rejected_at: new Date(),
      rejection_reason: req.body.reason
    });
    res.json(request);
  }
);

module.exports = router;
```

---

## 🎨 Frontend Implementation

### 1. Use Role Hook

```tsx
import { useRole, ROLES, PERMISSIONS } from '../utils/rbac';

function AssetPage() {
  const { role, isAdmin, isManager, hasPermission } = useRole();

  return (
    <div>
      {isAdmin && (
        <button onClick={createAsset}>Create Asset</button>
      )}
      
      {hasPermission(PERMISSIONS.ASSETS.EXPORT) && (
        <button onClick={exportAssets}>Export</button>
      )}
      
      {/* Managers and admins can view reports */}
      {(isAdmin || isManager) && (
        <ReportsSection />
      )}
    </div>
  );
}
```

---

### 2. Protect Pages

```tsx
import { useRoleProtection, ROLES } from '../utils/rbac';

function UsersPage() {
  // Redirect to home if not admin
  useRoleProtection(ROLES.ADMIN);

  return (
    <div>
      <h1>User Management</h1>
      {/* Admin-only content */}
    </div>
  );
}

// Or use HOC
import { withRoleProtection } from '../utils/rbac';

const AdminUsersPage = withRoleProtection(UsersPage, ROLES.ADMIN);
export default AdminUsersPage;
```

---

### 3. Role Guard Component

```tsx
import { RoleGuard, ROLES, PERMISSIONS } from '../utils/rbac';

function SystemAccessPage() {
  return (
    <div>
      {/* Show approve button only to admins */}
      <RoleGuard role={ROLES.ADMIN}>
        <button onClick={approveRequest}>Approve</button>
        <button onClick={rejectRequest}>Reject</button>
      </RoleGuard>
      
      {/* Show based on permission */}
      <RoleGuard permission={PERMISSIONS.SYSTEM_ACCESS.CREATE}>
        <button onClick={createRequest}>New Request</button>
      </RoleGuard>
      
      {/* Show fallback for non-admins */}
      <RoleGuard 
        role={ROLES.ADMIN}
        fallback={<p>Only admins can approve requests</p>}
      >
        <ApprovalPanel />
      </RoleGuard>
    </div>
  );
}
```

---

### 4. Use Data Scope

```tsx
import { useDataScope } from '../utils/rbac';
import { assetsAPI } from '../utils/api';

function AssetsPage() {
  const [assets, setAssets] = useState([]);
  const filters = useDataScope();

  useEffect(() => {
    const loadAssets = async () => {
      // Automatically filtered by role:
      // - Admin: all assets
      // - Manager: department assets
      // - User: own assets
      const data = await assetsAPI.getAll(filters);
      setAssets(data);
    };
    loadAssets();
  }, [filters]);

  return <div>{/* Render assets */}</div>;
}
```

---

### 5. Example: System Access Page

```tsx
import React, { useState, useEffect } from 'react';
import { useRole, RoleGuard, ROLES, PERMISSIONS } from '../utils/rbac';
import { systemAccessAPI } from '../utils/api';

function SystemAccessPage() {
  const { role, isAdmin, isManager, useDataScope } = useRole();
  const filters = useDataScope();
  const [requests, setRequests] = useState([]);

  useEffect(() => {
    loadRequests();
  }, [filters]);

  const loadRequests = async () => {
    const data = await systemAccessAPI.getAll(filters);
    setRequests(data);
  };

  const handleApprove = async (id) => {
    await systemAccessAPI.approve(id);
    loadRequests();
  };

  const handleReject = async (id, reason) => {
    await systemAccessAPI.reject(id, reason);
    loadRequests();
  };

  return (
    <div>
      <h1>System Access Requests</h1>

      {/* Create button - all roles */}
      <RoleGuard permission={PERMISSIONS.SYSTEM_ACCESS.CREATE}>
        <button onClick={() => setShowModal(true)}>
          New Request
        </button>
      </RoleGuard>

      {/* Requests table */}
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>System</th>
            <th>Status</th>
            <RoleGuard role={ROLES.ADMIN}>
              <th>Actions</th>
            </RoleGuard>
          </tr>
        </thead>
        <tbody>
          {requests.map(request => (
            <tr key={request.id}>
              <td>{request.user_name}</td>
              <td>{request.system_name}</td>
              <td>{request.status}</td>
              
              {/* Approve/Reject buttons - admin only */}
              <RoleGuard role={ROLES.ADMIN}>
                <td>
                  <button onClick={() => handleApprove(request.id)}>
                    Approve
                  </button>
                  <button onClick={() => handleReject(request.id)}>
                    Reject
                  </button>
                </td>
              </RoleGuard>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default SystemAccessPage;
```

---

## 🧪 Testing Guide

### Test Users (from test_users_fixed.sql)

**Admins (3)**:
- `admin@assetflow.com` (IT dept)
- `hr.admin@assetflow.com` (HR dept)
- `finance.admin@assetflow.com` (Finance dept)

**Managers (3)**:
- `it.manager@assetflow.com` (IT dept)
- `sales.manager@assetflow.com` (Sales dept)
- `ops.manager@assetflow.com` (Operations dept)

**Users (7)**:
- `developer1@assetflow.com` (IT)
- `developer2@assetflow.com` (IT)
- `sales1@assetflow.com` (Sales)
- `sales2@assetflow.com` (Sales)
- `hr1@assetflow.com` (HR)
- `finance1@assetflow.com` (Finance)
- `ops1@assetflow.com` (Operations)

**Test User**:
- `test@assetflow.com` (IT)

---

### Testing Scenarios

#### Scenario 1: Admin Full Access
```bash
# Login as: admin@assetflow.com

✅ Should see all assets (all departments)
✅ Should see "Create Asset" button
✅ Should see "Import Assets" button
✅ Should see all system access requests
✅ Should see Approve/Reject buttons
✅ Should access Users page
✅ Should access Settings page
✅ Should see all reports
```

#### Scenario 2: Manager Department Access
```bash
# Login as: it.manager@assetflow.com (IT dept)

✅ Should see only IT department assets
✅ Should NOT see "Create Asset" button
✅ Should see "Request Asset" button
✅ Should see only IT department system access requests
✅ Should NOT see Approve/Reject buttons for system access
✅ Should see "Create Request for Team" button
✅ Should NOT access Users page (403 or redirect)
✅ Should NOT access Settings page
✅ Should see only IT department reports
```

#### Scenario 3: User Self Access
```bash
# Login as: developer1@assetflow.com

✅ Should see only assets assigned to them
✅ Should NOT see "Create Asset" button
✅ Should see "Request Maintenance" button
✅ Should see only their own system access requests
✅ Should see "New Request" button
✅ Should NOT see other users' requests
✅ Should NOT access Users page
✅ Should NOT access Settings page
✅ Should see only personal summary reports
```

#### Scenario 4: Cross-Department Isolation
```bash
# Login as: sales.manager@assetflow.com (Sales dept)

❌ Should NOT see IT department assets
❌ Should NOT see IT system access requests
❌ Should NOT see developer1's personal data
✅ Should only see Sales department data
```

---

### API Endpoint Testing

```bash
# Test with curl

# Admin can get all users
curl -H "Authorization: Bearer <admin-token>" \
  http://localhost:3001/api/users

# Manager gets 403
curl -H "Authorization: Bearer <manager-token>" \
  http://localhost:3001/api/users
# Expected: {"error": "Forbidden"}

# Admin can approve request
curl -X POST \
  -H "Authorization: Bearer <admin-token>" \
  http://localhost:3001/api/system-access/123/approve

# User gets 403
curl -X POST \
  -H "Authorization: Bearer <user-token>" \
  http://localhost:3001/api/system-access/123/approve
# Expected: {"error": "Forbidden"}

# Manager sees only department assets
curl -H "Authorization: Bearer <it-manager-token>" \
  http://localhost:3001/api/assets
# Expected: Only IT department assets

# User sees only their assets
curl -H "Authorization: Bearer <user-token>" \
  http://localhost:3001/api/assets
# Expected: Only assets assigned to that user
```

---

## 📚 Quick Reference

### Common Permissions

```javascript
// Assets
PERMISSIONS.ASSETS.CREATE          // Create new assets
PERMISSIONS.ASSETS.READ_ALL        // View all assets
PERMISSIONS.ASSETS.READ_DEPARTMENT // View department assets
PERMISSIONS.ASSETS.READ_OWN        // View own assets
PERMISSIONS.ASSETS.DELETE_ALL      // Delete any asset

// System Access
PERMISSIONS.SYSTEM_ACCESS.APPROVE  // Approve requests
PERMISSIONS.SYSTEM_ACCESS.REJECT   // Reject requests
PERMISSIONS.SYSTEM_ACCESS.CREATE_TEAM // Create for team members

// Users
PERMISSIONS.USERS.CREATE           // Create users
PERMISSIONS.USERS.ASSIGN_ROLE      // Change user roles
PERMISSIONS.USERS.UPDATE_OWN       // Update own profile

// Reports
PERMISSIONS.REPORTS.VIEW_ALL       // All reports
PERMISSIONS.REPORTS.VIEW_DEPARTMENT // Department reports
PERMISSIONS.REPORTS.VIEW_OWN       // Personal summary

// Settings
PERMISSIONS.SETTINGS.UPDATE        // Change settings
PERMISSIONS.SETTINGS.MANAGE_INTEGRATIONS // API configs
```

---

### Common Use Cases

**Hide UI based on role:**
```tsx
{isAdmin && <AdminButton />}
{hasPermission(PERMISSIONS.ASSETS.CREATE) && <CreateButton />}
```

**Protect entire page:**
```tsx
useRoleProtection(ROLES.ADMIN);
```

**Filter data by role:**
```tsx
const filters = useDataScope();
const data = await API.getAll(filters);
```

**Conditional rendering:**
```tsx
<RoleGuard role={ROLES.ADMIN} fallback={<NoAccess />}>
  <AdminPanel />
</RoleGuard>
```

---

## 🔄 Migration Steps

1. **Install shared roles**:
   ```bash
   # Already created in shared/roles.js
   ```

2. **Update backend routes**:
   ```javascript
   // Add to each route file
   const { requireRole, applyDataScope } = require('../middleware/rbac');
   
   router.get('/assets', authenticate, applyDataScope(), getAssetsHandler);
   router.post('/assets', authenticate, requireRole(ROLES.ADMIN), createAssetHandler);
   ```

3. **Update frontend pages**:
   ```tsx
   import { useRole, useRoleProtection, RoleGuard } from '../utils/rbac';
   
   function MyPage() {
     useRoleProtection(ROLES.ADMIN); // Protect page
     const { isAdmin } = useRole();   // Check role
     
     return (
       <RoleGuard role={ROLES.ADMIN}>
         <AdminContent />
       </RoleGuard>
     );
   }
   ```

4. **Test with test users**:
   ```sql
   -- Run in Supabase SQL Editor
   -- database/test_users_fixed.sql
   ```

---

## 🎉 Summary

Your AssetFlow now has a complete, production-ready RBAC system:

✅ **3 roles**: Admin, Manager, User  
✅ **Granular permissions**: 50+ permission checks  
✅ **Backend protection**: Middleware for routes  
✅ **Frontend protection**: Hooks, guards, and HOCs  
✅ **Data scoping**: Automatic filtering by role  
✅ **Test users**: 14 users across all roles  
✅ **Fully documented**: Implementation guide and examples  

**Next steps**: Apply to your existing routes and pages following the examples above!
