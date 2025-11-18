# 🧪 RBAC Backend Testing Guide

## Quick Test Commands

### 1. Start Backend Server

```bash
cd backend
npm start
```

Server should start on http://localhost:3001

---

## 2. Test with Different Roles

### Admin User (Full Access)

```bash
# Set admin token
ADMIN_TOKEN="admin@assetflow.com:admin:IT:user-admin-001"

# Get all assets (should work)
curl -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:3001/api/assets

# Create asset (should work)
curl -X POST \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Laptop",
    "category": "Laptop",
    "location": "Dubai Office",
    "purchase_date": "2025-01-01",
    "purchase_cost": 5000,
    "current_value": 4500,
    "condition": "excellent"
  }' \
  http://localhost:3001/api/assets

# Get all users (should work - admin only)
curl -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:3001/api/users

# Get system access requests (should see ALL)
curl -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:3001/api/system-access
```

---

### Manager User (Department Access)

```bash
# Set manager token
MANAGER_TOKEN="it.manager@assetflow.com:manager:IT:user-mgr-001"

# Get assets (should only see IT department)
curl -H "Authorization: Bearer $MANAGER_TOKEN" \
  http://localhost:3001/api/assets

# Try to create asset (should FAIL with 403)
curl -X POST \
  -H "Authorization: Bearer $MANAGER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Laptop",
    "category": "Laptop",
    "location": "Dubai Office",
    "purchase_date": "2025-01-01",
    "purchase_cost": 5000,
    "current_value": 4500,
    "condition": "excellent"
  }' \
  http://localhost:3001/api/assets

# Try to get all users (should FAIL with 403)
curl -H "Authorization: Bearer $MANAGER_TOKEN" \
  http://localhost:3001/api/users

# Get system access requests (should only see IT department)
curl -H "Authorization: Bearer $MANAGER_TOKEN" \
  http://localhost:3001/api/system-access
```

---

### Regular User (Self Access)

```bash
# Set user token
USER_TOKEN="developer1@assetflow.com:user:IT:user-dev-001"

# Get assets (should only see own assets)
curl -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/assets

# Try to create asset (should FAIL with 403)
curl -X POST \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Laptop",
    "category": "Laptop",
    "location": "Dubai Office",
    "purchase_date": "2025-01-01",
    "purchase_cost": 5000,
    "current_value": 4500,
    "condition": "excellent"
  }' \
  http://localhost:3001/api/assets

# Try to get all users (should FAIL with 403)
curl -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/users

# Get system access requests (should only see own requests)
curl -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/system-access
```

---

## 3. Expected Results

### ✅ Admin Should:
- See ALL assets (all departments)
- CREATE new assets
- UPDATE/DELETE any asset
- Access Users endpoint
- See ALL system access requests
- APPROVE/REJECT requests

### 🟡 Manager Should:
- See ONLY IT department assets (if IT manager)
- NOT be able to create assets (403 error)
- NOT access Users endpoint (403 error)
- See ONLY IT department system access requests
- NOT be able to approve/reject requests

### 🔴 User Should:
- See ONLY assets assigned to them
- NOT be able to create assets (403 error)
- NOT access Users endpoint (403 error)
- See ONLY their own system access requests
- NOT be able to approve/reject requests

---

## 4. Test RBAC Filtering

### Cross-Department Test

```bash
# IT Manager token
IT_MGR="it.manager@assetflow.com:manager:IT:user-mgr-001"

# Sales Manager token
SALES_MGR="sales.manager@assetflow.com:manager:Sales:user-mgr-002"

# Get assets as IT Manager (should see only IT)
curl -H "Authorization: Bearer $IT_MGR" \
  http://localhost:3001/api/assets

# Get assets as Sales Manager (should see only Sales)
curl -H "Authorization: Bearer $SALES_MGR" \
  http://localhost:3001/api/assets

# These should return different results!
```

---

## 5. Test Error Responses

### Test 401 (Unauthorized)

```bash
# No token
curl http://localhost:3001/api/assets

# Expected: {"error":"No token provided"}
```

### Test 403 (Forbidden)

```bash
# User trying to access admin endpoint
USER_TOKEN="developer1@assetflow.com:user:IT:user-dev-001"

curl -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/users

# Expected: {"error":"Forbidden"}
```

---

## 6. Verify Data Scope Filtering

```bash
# Admin - No filters applied
ADMIN_TOKEN="admin@assetflow.com:admin:IT:user-admin-001"
curl -H "Authorization: Bearer $ADMIN_TOKEN" \
  http://localhost:3001/api/assets | jq '.data | map(.department) | unique'

# Expected: ["IT", "Sales", "HR", "Finance", "Operations"]

# Manager - Department filter applied
MANAGER_TOKEN="it.manager@assetflow.com:manager:IT:user-mgr-001"
curl -H "Authorization: Bearer $MANAGER_TOKEN" \
  http://localhost:3001/api/assets | jq '.data | map(.department) | unique'

# Expected: ["IT"] only

# User - User ID filter applied  
USER_TOKEN="developer1@assetflow.com:user:IT:user-dev-001"
curl -H "Authorization: Bearer $USER_TOKEN" \
  http://localhost:3001/api/assets | jq '.data | map(.assigned_to) | unique'

# Expected: ["user-dev-001"] only
```

---

## 7. Integration Checklist

- [ ] Backend starts without errors
- [ ] Admin can access all endpoints
- [ ] Manager gets 403 on admin-only endpoints
- [ ] User gets 403 on admin/manager endpoints
- [ ] Assets are filtered by department for managers
- [ ] Assets are filtered by user_id for users
- [ ] System access requests are filtered correctly
- [ ] Users endpoint is admin-only
- [ ] All error responses include proper messages

---

## 🎉 Success Criteria

Your RBAC backend is working if:

✅ Admin sees all data  
✅ Manager sees only department data  
✅ User sees only own data  
✅ Non-admins get 403 on protected endpoints  
✅ Data filtering happens automatically  
✅ Error messages are clear  

---

## 📚 Next Steps

After backend testing passes:

1. **Update Frontend** - Add RBAC hooks to pages
2. **Test UI** - Verify buttons hide/show correctly
3. **Deploy Backend** - Push to production
4. **Deploy Frontend** - Update with backend URL

See `NEXT_STEPS.md` for frontend integration guide!
