# 🚀 AssetFlow Next Steps - RBAC Integration

**Date**: November 18, 2025  
**Status**: RBAC System Built ✅ | Integration Pending ⏳

---

## 📊 Current Status

### ✅ What's Complete
- **RBAC Core Files**: All 3 files created and ready
  - `shared/roles.js` - Permission constants
  - `backend/src/middleware/rbac.js` - Express middleware
  - `frontend/utils/rbac.tsx` - React hooks/components
- **Documentation**: Complete guides available
- **Test Users**: 14 users already in database
- **Frontend**: Deployed to Vercel (production)
- **Backend**: Running locally (not deployed yet)

### ⏳ What's Next
1. Integrate RBAC into backend routes
2. Integrate RBAC into frontend pages
3. Test with different user roles
4. Deploy backend to production
5. End-to-end testing

---

## 🎯 Immediate Next Steps (Priority Order)

### Step 1: Integrate Backend RBAC (30 minutes)

Apply RBAC middleware to your API routes to enforce permissions.

#### 1.1 Update Assets Routes
**File**: `backend/src/routes/assets.js`

```javascript
const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { 
  requireRole, 
  requirePermission, 
  applyDataScope 
} = require('../middleware/rbac');
const { ROLES, PERMISSIONS } = require('../../shared/roles');

// Get all assets (filtered by role)
router.get('/', 
  authenticate,
  applyDataScope(),  // ← ADD THIS: Automatically filters data
  async (req, res) => {
    try {
      // req.filters will contain:
      // - {} for admin (no filter)
      // - { department: 'IT' } for manager
      // - { assigned_to: 'user-id' } for user
      
      const assets = await assetsService.getAll(req.filters);
      res.json(assets);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Create asset (admin only)
router.post('/', 
  authenticate,
  requireRole(ROLES.ADMIN),  // ← ADD THIS: Block non-admins
  async (req, res) => {
    try {
      const asset = await assetsService.create(req.body);
      res.json(asset);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Update asset (admin only)
router.put('/:id',
  authenticate,
  requirePermission(PERMISSIONS.ASSETS.UPDATE_ALL),  // ← ADD THIS
  async (req, res) => {
    try {
      const asset = await assetsService.update(req.params.id, req.body);
      res.json(asset);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Delete asset (admin only)
router.delete('/:id',
  authenticate,
  requirePermission(PERMISSIONS.ASSETS.DELETE_ALL),  // ← ADD THIS
  async (req, res) => {
    try {
      await assetsService.delete(req.params.id);
      res.json({ message: 'Asset deleted' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

module.exports = router;
```

#### 1.2 Update System Access Routes
**File**: `backend/src/routes/system-access.js`

```javascript
const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { 
  requirePermission, 
  applyDataScope 
} = require('../middleware/rbac');
const { PERMISSIONS } = require('../../shared/roles');

// Get all requests (filtered by role)
router.get('/', 
  authenticate,
  applyDataScope(),  // ← ADD THIS
  async (req, res) => {
    try {
      const requests = await systemAccessService.getAll(req.filters);
      res.json(requests);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Create request (all authenticated users)
router.post('/', 
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.CREATE),  // ← ADD THIS
  async (req, res) => {
    try {
      const request = await systemAccessService.create({
        ...req.body,
        requester_id: req.user.id,
        department: req.user.department
      });
      res.json(request);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Approve request (admin only)
router.post('/:id/approve',
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.APPROVE),  // ← ADD THIS
  async (req, res) => {
    try {
      const request = await systemAccessService.approve(req.params.id, {
        approved_by: req.user.id,
        approved_at: new Date()
      });
      res.json(request);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Reject request (admin only)
router.post('/:id/reject',
  authenticate,
  requirePermission(PERMISSIONS.SYSTEM_ACCESS.REJECT),  // ← ADD THIS
  async (req, res) => {
    try {
      const request = await systemAccessService.reject(req.params.id, {
        rejected_by: req.user.id,
        rejected_at: new Date(),
        rejection_reason: req.body.reason
      });
      res.json(request);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

module.exports = router;
```

#### 1.3 Update User Routes
**File**: `backend/src/routes/users.js`

```javascript
const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { requireRole } = require('../middleware/rbac');
const { ROLES } = require('../../shared/roles');

// Get all users (admin only)
router.get('/', 
  authenticate,
  requireRole(ROLES.ADMIN),  // ← ADD THIS
  async (req, res) => {
    try {
      const users = await usersService.getAll();
      res.json(users);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Update user role (admin only)
router.put('/:id/role',
  authenticate,
  requireRole(ROLES.ADMIN),  // ← ADD THIS
  async (req, res) => {
    try {
      const user = await usersService.updateRole(req.params.id, req.body.role);
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

module.exports = router;
```

---

### Step 2: Integrate Frontend RBAC (30 minutes)

Add role-based UI controls to your pages.

#### 2.1 Update Assets Page
**File**: `frontend/pages/assets.tsx`

Add these imports at the top:
```tsx
import { useRole, useDataScope, RoleGuard } from '../utils/rbac';
import { ROLES, PERMISSIONS } from '../utils/rbac';
```

Then update your component:
```tsx
function AssetsPage() {
  const [assets, setAssets] = useState([]);
  const { isAdmin, hasPermission } = useRole();
  const filters = useDataScope();  // ← ADD THIS
  
  useEffect(() => {
    const loadAssets = async () => {
      // Pass filters - API will return only allowed assets
      const data = await assetsAPI.getAll(filters);  // ← UPDATE THIS
      setAssets(data);
    };
    loadAssets();
  }, [filters]);  // ← ADD filters to dependency
  
  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1>Assets</h1>
        
        {/* Only show create button to admins */}
        <RoleGuard permission={PERMISSIONS.ASSETS.CREATE}>
          <button onClick={() => setShowCreateModal(true)}>
            Create Asset
          </button>
        </RoleGuard>
      </div>
      
      {/* Asset table */}
      <table>
        <thead>
          <tr>
            <th>Asset</th>
            <th>Status</th>
            <th>Department</th>
            <RoleGuard role={ROLES.ADMIN}>
              <th>Actions</th>
            </RoleGuard>
          </tr>
        </thead>
        <tbody>
          {assets.map(asset => (
            <tr key={asset.id}>
              <td>{asset.name}</td>
              <td>{asset.status}</td>
              <td>{asset.department}</td>
              
              {/* Only show actions to admins */}
              <RoleGuard role={ROLES.ADMIN}>
                <td>
                  <button onClick={() => editAsset(asset)}>Edit</button>
                  <button onClick={() => deleteAsset(asset.id)}>Delete</button>
                </td>
              </RoleGuard>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

#### 2.2 Update System Access Page
**File**: `frontend/pages/system-access.tsx`

```tsx
import { useRole, useDataScope, RoleGuard } from '../utils/rbac';
import { ROLES, PERMISSIONS } from '../utils/rbac';

function SystemAccessPage() {
  const [requests, setRequests] = useState([]);
  const { isAdmin } = useRole();
  const filters = useDataScope();  // ← ADD THIS
  
  useEffect(() => {
    const loadRequests = async () => {
      const data = await systemAccessAPI.getAll(filters);  // ← UPDATE THIS
      setRequests(data);
    };
    loadRequests();
  }, [filters]);
  
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
      <div className="flex justify-between items-center mb-6">
        <h1>System Access Requests</h1>
        
        {/* All users can create */}
        <RoleGuard permission={PERMISSIONS.SYSTEM_ACCESS.CREATE}>
          <button onClick={() => setShowModal(true)}>
            New Request
          </button>
        </RoleGuard>
      </div>
      
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>System</th>
            <th>Status</th>
            <th>Date</th>
            {/* Only show actions column to admins */}
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
              <td>{request.created_at}</td>
              
              {/* Only admins see approve/reject */}
              <RoleGuard role={ROLES.ADMIN}>
                <td>
                  {request.status === 'pending' && (
                    <>
                      <button onClick={() => handleApprove(request.id)}>
                        Approve
                      </button>
                      <button onClick={() => handleReject(request.id)}>
                        Reject
                      </button>
                    </>
                  )}
                </td>
              </RoleGuard>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

#### 2.3 Protect Users Page
**File**: `frontend/pages/users.tsx`

Add at the top of the file:
```tsx
import { useRoleProtection } from '../utils/rbac';
import { ROLES } from '../utils/rbac';
```

Then at the start of your component:
```tsx
function UsersPage() {
  // Redirect non-admins to home
  useRoleProtection(ROLES.ADMIN);  // ← ADD THIS LINE
  
  // Rest of your existing code...
  const [users, setUsers] = useState([]);
  // ...
}
```

---

### Step 3: Test Locally (15 minutes)

#### 3.1 Start Backend
```bash
cd backend
npm start
```

#### 3.2 Start Frontend
```bash
cd frontend
npm run dev
```

#### 3.3 Test with Different Users

**Test 1: Admin User**
```
Login as: admin@assetflow.com
Expected:
✅ See "Create Asset" button
✅ See all departments' assets
✅ See Approve/Reject buttons
✅ Can access Users page
```

**Test 2: Manager User**
```
Login as: it.manager@assetflow.com
Expected:
✅ See only IT department assets
❌ No "Create Asset" button
❌ No Approve/Reject buttons
❌ Users page redirects to home
```

**Test 3: Regular User**
```
Login as: developer1@assetflow.com
Expected:
✅ See only assets assigned to them
❌ No admin buttons visible
❌ Cannot access Users page
```

---

### Step 4: Verify API Protection (10 minutes)

Test that backend properly blocks unauthorized requests:

```bash
# Get admin token (login as admin)
ADMIN_TOKEN="<get-from-browser-devtools>"

# Get user token (login as developer1)
USER_TOKEN="<get-from-browser-devtools>"

# Test 1: User tries to get all users (should fail)
curl -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/users
# Expected: {"error": "Forbidden"}

# Test 2: Admin gets all users (should work)
curl -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:3001/api/users
# Expected: Array of all users

# Test 3: User tries to approve request (should fail)
curl -X POST \
  -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/system-access/123/approve
# Expected: {"error": "Forbidden"}

# Test 4: Admin approves request (should work)
curl -X POST \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:3001/api/system-access/123/approve
# Expected: Updated request object
```

---

### Step 5: Deploy Backend (20 minutes)

Once local testing passes, deploy your backend.

#### Option A: Deploy to Vercel

```bash
cd backend

# Install Vercel CLI (if not installed)
npm i -g vercel

# Deploy
vercel

# Set environment variables in Vercel dashboard:
# - SUPABASE_URL
# - SUPABASE_SERVICE_ROLE_KEY
# - JWT_SECRET
# - NODE_ENV=production
```

#### Option B: Deploy to Railway

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and init
railway login
railway init

# Deploy
railway up

# Add environment variables via Railway dashboard
```

#### Update Frontend API URL

After backend deployment, update frontend env:

```bash
# frontend/.env.production
NEXT_PUBLIC_API_URL=https://your-backend-url.vercel.app
```

Then redeploy frontend:
```bash
cd frontend
vercel --prod
```

---

## 📋 Complete Checklist

### Backend Integration
- [ ] Update `backend/src/routes/assets.js` with RBAC middleware
- [ ] Update `backend/src/routes/system-access.js` with RBAC middleware
- [ ] Update `backend/src/routes/users.js` with RBAC middleware
- [ ] Update `backend/src/routes/maintenance.js` with RBAC middleware (if exists)
- [ ] Update service layer to use `req.filters` from middleware
- [ ] Test all endpoints with curl

### Frontend Integration
- [ ] Update `frontend/pages/assets.tsx` with RBAC hooks
- [ ] Update `frontend/pages/system-access.tsx` with RBAC hooks
- [ ] Update `frontend/pages/users.tsx` with page protection
- [ ] Update `frontend/pages/settings.tsx` with page protection (if exists)
- [ ] Update `frontend/pages/reports.tsx` with RBAC (if exists)
- [ ] Test UI with all three roles

### Testing
- [ ] Login as admin - verify full access
- [ ] Login as manager - verify department-only access
- [ ] Login as user - verify self-only access
- [ ] Test cross-department isolation
- [ ] Test API returns 403 for unauthorized actions
- [ ] Test UI hides unauthorized buttons/pages

### Deployment
- [ ] Backend deployed to production
- [ ] Frontend environment updated with backend URL
- [ ] Frontend redeployed
- [ ] Production testing complete

---

## 🎯 Today's Goal

**Complete Steps 1-3** (Backend integration, Frontend integration, Local testing)

**Time Estimate**: ~75 minutes

This will give you a fully functional RBAC system running locally that you can test before deploying.

---

## 📚 Reference Documents

- **`RBAC_IMPLEMENTATION_GUIDE.md`** - Detailed examples and patterns
- **`RBAC_TESTING_GUIDE.md`** - Complete testing scenarios
- **`RBAC_SETUP_STATUS.md`** - Current status summary

---

## 🆘 Need Help?

If you encounter issues:

1. **Backend 403 errors**: Check that middleware is in correct order (authenticate before RBAC)
2. **Frontend shows wrong data**: Verify `useDataScope()` filters are passed to API
3. **UI buttons not hiding**: Check that you're using `RoleGuard` component
4. **TypeScript errors**: Make sure you're importing from correct paths

Refer to the implementation guide for detailed troubleshooting!

---

**Ready to start?** Begin with Step 1: Backend integration! 🚀
