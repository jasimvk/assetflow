# Supabase Testing Guide

## 🎯 Quick Summary

Two test scripts have been created to verify your Supabase database connection:
- **Frontend Test**: `/frontend/test-db.js` (uses anon key, limited access)
- **Backend Test**: `/backend/test-db.js` (uses service role key, full access)

---

## ⚠️ IMPORTANT: Configure Supabase First

Before running tests, you **MUST** complete these steps:

### Step 1: Create Supabase Project
1. Go to https://supabase.com
2. Create a new project (takes 2-3 minutes)
3. Go to **Settings → API** and copy:
   - Project URL
   - anon public key
   - service_role key

### Step 2: Execute Database Schema
1. In Supabase Dashboard, go to **SQL Editor**
2. Copy the entire `/database/supabase_setup.sql` file (600+ lines)
3. Paste and click **"Run"**
4. Verify success message

### Step 3: Configure Environment Variables

You have **two options**:

#### Option A: Use Setup Script (Recommended)
```bash
./setup-supabase.sh
```
The script will prompt you for your credentials and configure both frontend and backend.

#### Option B: Manual Configuration

**Backend** - Create/edit `/backend/.env`:
```bash
NODE_ENV=development
PORT=3001

SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SUPABASE_ANON_KEY=your-anon-key

FRONTEND_URL=http://localhost:3000
```

**Frontend** - Create/edit `/frontend/.env.local`:
```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key

NEXT_PUBLIC_API_BASE_URL=http://localhost:3001
```

---

## 🧪 Running Tests

### Backend Test (Service Role - Full Access)

```bash
cd backend
node test-db.js
```

**What it tests:**
- ✅ Environment variables configured
- ✅ Database connection (service role key)
- ✅ All 12 tables accessible
- ✅ Full CRUD operations (INSERT, SELECT, UPDATE, DELETE)
- ✅ Automatic request number generation (SAR-YYYY-NNN)
- ✅ Audit trail trigger (system_access_history)
- ✅ Dashboard views
- ✅ RLS policies (bypassed by service role)

**Expected Output:**
```
🔍 Testing Backend Supabase Connection...

📋 Configuration:
URL: ✅ Set
Service Role Key: ✅ Set
Anon Key: ✅ Set

📝 Test 1: Checking users table (admin access)...
✅ Users table accessible with service role (1 rows)
   Admin users: 1
   Manager users: 0
   Regular users: 0

📝 Test 2: Checking system_access_requests table...
✅ System access requests accessible (0 total)

📝 Test 3: Testing INSERT permission...
✅ INSERT successful
   Created request: SAR-2025-001
   Request number auto-generated: ✅

📝 Test 4: Checking audit trail...
✅ Audit trail working (1 entries)
   Latest: status → pending

📝 Test 5: Testing UPDATE permission...
✅ UPDATE successful
   Status changed: pending → in_progress

📝 Test 6: Testing DELETE permission and cleanup...
✅ DELETE successful (test data cleaned up)

[... more tests ...]

✅ Backend database connection test completed successfully!

📊 Summary:
- ✅ Service role key has full admin access
- ✅ All tables accessible (12 tables verified)
- ✅ CRUD operations working
- ✅ Automatic request number generation working
- ✅ Audit trail trigger working
- ✅ Ready for production API integration
```

### Frontend Test (Anon Key - Limited Access)

First, install dotenv:
```bash
cd frontend
npm install dotenv
```

Then run test:
```bash
node test-db.js
```

**What it tests:**
- ✅ Environment variables configured
- ✅ Database connection (anon key)
- ✅ Read access to public tables
- ✅ RLS policies enforcing security
- ✅ Categories and locations (default data)
- ✅ Dashboard views accessible

**Expected Output:**
```
🔍 Testing Frontend Supabase Connection...

📋 Configuration:
URL: ✅ Set
Anon Key: ✅ Set

📝 Test 1: Checking users table...
✅ Users table accessible (1 rows)
   Sample user: admin@yourcompany.com - admin

📝 Test 2: Checking system_access_requests table...
✅ System access requests accessible (0 rows)

📝 Test 3: Checking assets table...
✅ Assets table accessible (0 rows)

📝 Test 4: Checking categories table...
✅ Categories table accessible (8 rows)
   Categories: Computer, Laptop, Monitor, Printer, Mobile Device, Network Equipment, Office Equipment, Other

📝 Test 5: Checking locations table...
✅ Locations table accessible (5 rows)
   Locations: Head Office, Branch Office A, Branch Office B, Warehouse, Remote

📝 Test 6: Checking dashboard stats view...
✅ Dashboard stats view accessible
   Stats: {
     "total_assets": 0,
     "active_assets": 0,
     "total_users": 1,
     "pending_system_access_requests": 0
   }

✅ Frontend database connection test completed!

📊 Summary:
- Database is accessible from frontend
- All core tables are working
- RLS policies are in effect (anon key has limited access)
- Ready for application use
```

---

## 🔍 Test Details

### Backend Test (`backend/test-db.js`)

**Comprehensive testing with full admin access:**

1. **Configuration Check** - Verifies all environment variables
2. **Users Table** - Counts admin/manager/user roles
3. **System Access Requests** - Lists recent requests
4. **INSERT Test** - Creates test request with auto-generated number
5. **Audit Trail** - Verifies history logging trigger
6. **UPDATE Test** - Changes status to test triggers
7. **DELETE Test** - Cleanup and permission check
8. **Assets Table** - Counts by status
9. **Dashboard Stats** - Aggregated metrics
10. **Maintenance Records** - Service history access
11. **Notifications** - Alert system check

### Frontend Test (`frontend/test-db.js`)

**User-level testing with limited access:**

1. **Configuration Check** - Verifies public environment variables
2. **Users Table** - Read-only access
3. **System Access Requests** - User's own requests
4. **Assets Table** - Assigned assets only
5. **Categories** - Reference data (8 categories)
6. **Locations** - Reference data (5 locations)
7. **Dashboard View** - Public statistics

---

## ❌ Common Issues & Solutions

### Issue: "Environment variables not configured"

**Symptoms:**
```
❌ Environment variables not configured!
URL: ❌ Missing
```

**Solution:**
1. Run the setup script: `./setup-supabase.sh`
2. Or manually create `.env` files (see Step 3 above)
3. Make sure file names are exact: `.env` (backend) and `.env.local` (frontend)

### Issue: "relation does not exist"

**Symptoms:**
```
❌ Users table error: relation "public.users" does not exist
```

**Solution:**
1. Database schema not executed
2. Go to Supabase Dashboard → SQL Editor
3. Run entire `/database/supabase_setup.sql` file
4. Wait for "Success. No rows returned" message

### Issue: "fetch failed" or "TypeError"

**Symptoms:**
```
❌ Users table error: TypeError: fetch failed
```

**Solutions:**
1. **Check Supabase URL** - Must be `https://xxxxx.supabase.co` (no trailing slash)
2. **Verify project is running** - Check Supabase Dashboard (green indicator)
3. **Check API keys** - Re-copy from Settings → API
4. **Network issue** - Try: `curl https://your-project.supabase.co` to test connectivity
5. **Node.js version** - Upgrade to Node 20+ (you'll see a warning)

### Issue: "permission denied for table"

**Symptoms:**
```
❌ System access requests error: permission denied for table system_access_requests
```

**Solutions:**
1. **Frontend (anon key)** - RLS policies may be blocking access
   - Check Authentication → Policies in Supabase
   - Verify policies exist for the table
2. **Backend (service_role key)** - Wrong key used
   - Make sure using `SUPABASE_SERVICE_ROLE_KEY` not `SUPABASE_ANON_KEY`
   - Service role should bypass all RLS

### Issue: "Request number not generating"

**Symptoms:**
```
✅ INSERT successful
   Created request: null (should be SAR-2025-001)
```

**Solution:**
1. Trigger not created properly
2. Re-run the database schema
3. Or manually create trigger:
```sql
CREATE TRIGGER set_request_number_trigger
    BEFORE INSERT ON system_access_requests
    FOR EACH ROW
    EXECUTE FUNCTION generate_request_number();
```

### Issue: "No users found - create admin user"

**Symptoms:**
```
⚠️  No users found - you should create an admin user
```

**Solution:**
1. Run this SQL in Supabase SQL Editor:
```sql
INSERT INTO users (
    id, email, full_name, role, department, is_active
) VALUES (
    gen_random_uuid(),
    'admin@yourcompany.com',
    'System Administrator',
    'admin',
    'IT',
    true
);
```

---

## 📊 Understanding Test Results

### ✅ All Tests Passed

Both tests complete successfully = Database is fully operational

**Next steps:**
1. Start backend: `cd backend && npm start`
2. Start frontend: `cd frontend && npm run dev`
3. Visit: http://localhost:3000/system-access
4. Create a test request to verify end-to-end

### ⚠️ Partial Success

Some tests pass, some fail = Configuration issue or incomplete setup

**Action:**
- Review error messages
- Check troubleshooting section above
- Verify database schema executed completely

### ❌ All Tests Failed

Complete failure = Connection or credentials issue

**Action:**
1. Verify Supabase project is running
2. Double-check all credentials
3. Test basic connectivity: `curl https://your-project.supabase.co`
4. Try creating a new API key in Supabase Dashboard

---

## 🎯 Next Steps After Testing

Once both tests pass:

### 1. Create Admin User
```sql
-- Run in Supabase SQL Editor
INSERT INTO users (id, email, full_name, role, department, is_active)
VALUES (gen_random_uuid(), 'admin@yourcompany.com', 'Admin Name', 'admin', 'IT', true);
```

### 2. Start Development Servers

**Terminal 1 - Backend:**
```bash
cd backend
npm install  # if not done
npm start
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm install  # if not done
npm run dev
```

### 3. Test in Browser
1. Open http://localhost:3000
2. Navigate to System Access page
3. Create a test request
4. Verify it appears in Supabase Table Editor

### 4. Production Deployment
- Update environment variables for production
- Deploy frontend to Vercel
- Deploy backend to your server
- Update Supabase CORS settings if needed

---

## 📁 Files Reference

**Test Scripts:**
- `/frontend/test-db.js` - Frontend connection test
- `/backend/test-db.js` - Backend connection test

**Configuration:**
- `/backend/.env` - Backend environment (NOT in git)
- `/backend/.env.example` - Backend template
- `/frontend/.env.local` - Frontend environment (NOT in git)
- `/frontend/.env.example` - Frontend template

**Helper:**
- `/setup-supabase.sh` - Automated configuration script

**Documentation:**
- `/DATABASE_SETUP.md` - Complete setup guide
- `/database/supabase_setup.sql` - Database schema (600+ lines)

---

## 🔒 Security Reminders

⚠️ **NEVER commit these files to git:**
- `/backend/.env`
- `/frontend/.env.local`

⚠️ **Service Role Key:**
- Only use in backend (server-side)
- Never expose to frontend
- Can bypass ALL security policies

✅ **Anon Key:**
- Safe to use in frontend (public)
- Limited by RLS policies
- Cannot bypass security

---

## 📞 Support

If tests fail after following all troubleshooting steps:

1. Check Supabase status: https://status.supabase.com
2. Review Supabase docs: https://supabase.com/docs
3. Check error logs in Supabase Dashboard → Logs
4. Verify your table structure in Table Editor

---

**Created:** November 15, 2025
**Last Updated:** November 15, 2025
**Version:** 1.0
