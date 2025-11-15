# AssetFlow Database Setup Guide

Complete guide for setting up Supabase database for AssetFlow System Access Management.

## 📋 Prerequisites

- Supabase account (sign up at https://supabase.com)
- AssetFlow application code (frontend and backend)
- Text editor for environment configuration

---

## 🚀 Quick Setup Steps

### 1. Create Supabase Project

1. Go to https://supabase.com and sign in
2. Click **"New Project"**
3. Fill in project details:
   - **Name**: `assetflow-production` (or your preferred name)
   - **Database Password**: Create a strong password (save this!)
   - **Region**: Choose closest to your users
   - **Pricing Plan**: Select appropriate tier
4. Click **"Create new project"**
5. Wait 2-3 minutes for project provisioning

### 2. Get API Credentials

Once project is ready:

1. Go to **Settings** → **API** in left sidebar
2. Copy these values (you'll need them):
   ```
   Project URL: https://xxxxx.supabase.co
   anon public key: eyJhbGc...
   service_role key: eyJhbGc... (keep secret!)
   ```

### 3. Configure Environment Variables

#### Frontend Configuration

Create/update `/frontend/.env.local`:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...your-anon-key...
```

#### Backend Configuration

Create/update `/backend/.env`:

```bash
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...your-service-role-key...
SUPABASE_ANON_KEY=eyJhbGc...your-anon-key...

# Database direct connection (optional, for advanced usage)
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
```

⚠️ **SECURITY WARNING**: Never commit `.env` files to git! They're already in `.gitignore`.

### 4. Execute Database Schema

1. In Supabase Dashboard, go to **SQL Editor** (left sidebar)
2. Click **"New query"**
3. Open the file `/database/supabase_setup.sql` from this project
4. Copy the entire contents (600+ lines)
5. Paste into SQL Editor
6. Click **"Run"** (or press Cmd/Ctrl + Enter)
7. Wait for execution (should take 5-10 seconds)
8. Verify success message: **"Success. No rows returned"**

### 5. Verify Tables Created

1. Go to **Table Editor** (left sidebar)
2. You should see these tables:
   - ✅ users
   - ✅ categories
   - ✅ locations
   - ✅ assets
   - ✅ maintenance_records
   - ✅ asset_history
   - ✅ asset_attachments
   - ✅ maintenance_attachments
   - ✅ system_access_requests
   - ✅ system_access_history
   - ✅ system_access_assets
   - ✅ notifications

3. Click on **system_access_requests** table to verify columns

### 6. Create First Admin User

Run this SQL in **SQL Editor**:

```sql
-- Insert first admin user
INSERT INTO users (
    id,
    email,
    full_name,
    role,
    department,
    is_active
) VALUES (
    gen_random_uuid(),
    'admin@yourcompany.com',  -- Change to your email
    'System Administrator',     -- Change to your name
    'admin',
    'IT',
    true
);
```

### 7. Verify RLS Policies

1. Go to **Authentication** → **Policies** (left sidebar)
2. You should see policies for these tables:
   - users (3 policies)
   - assets (3 policies)
   - maintenance_records (3 policies)
   - system_access_requests (4 policies)
   - notifications (2 policies)

### 8. Test Database Connection

#### From Frontend

Create a test file `/frontend/test-db.js`:

```javascript
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function testConnection() {
  const { data, error } = await supabase
    .from('users')
    .select('count')
    .limit(1);
  
  if (error) {
    console.error('❌ Connection failed:', error.message);
  } else {
    console.log('✅ Database connected successfully!');
    console.log('Users table accessible');
  }
}

testConnection();
```

Run: `node frontend/test-db.js`

#### From Backend

Create a test file `/backend/test-db.js`:

```javascript
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function testConnection() {
  const { data, error } = await supabase
    .from('system_access_requests')
    .select('count')
    .limit(1);
  
  if (error) {
    console.error('❌ Connection failed:', error.message);
  } else {
    console.log('✅ Backend connected successfully!');
    console.log('System access requests table accessible');
  }
}

testConnection();
```

Run: `node backend/test-db.js`

---

## 📊 Database Schema Overview

### Core Tables

**users** - Employee/user accounts
- Authentication and authorization
- Role-based access (admin, manager, user)

**system_access_requests** - Main system access requests
- Employee onboarding forms
- 27 Oracle Fusion access groups
- 6 IT asset types
- Priority and status tracking
- Auto-generated request numbers (SAR-YYYY-NNN)

**system_access_history** - Audit trail
- All status changes logged
- Automatic via trigger
- Immutable records

**system_access_assets** - Asset assignments
- Links IT assets to access requests
- Tracks assigned dates

### Asset Management Tables

**assets** - IT hardware inventory
- Laptops, desktops, mobiles, etc.
- Serial numbers, purchase info
- Assignment status

**maintenance_records** - Asset maintenance
- Service history
- Cost tracking

**categories** - Asset categories
- Pre-populated with 8 types

**locations** - Office locations
- Pre-populated with 5 locations

### Supporting Tables

**notifications** - System notifications
- User alerts
- Request updates

**asset_history** - Asset audit trail
- Assignment changes
- Status updates

**asset_attachments** - Asset documents
- Invoices, warranties
- File storage links

**maintenance_attachments** - Service documents
- Repair reports
- Receipts

### Automatic Features

✅ **UUID Primary Keys** - All tables use UUID for security

✅ **Timestamps** - Auto-managed `created_at` and `updated_at`

✅ **Request Numbers** - Auto-generated SAR-2025-001 format

✅ **Audit Logging** - Status changes tracked automatically

✅ **RLS Policies** - Row-level security enabled

✅ **Indexes** - 22 performance indexes created

✅ **Views** - 3 reporting views ready to use

---

## 🔒 Security Configuration

### Row Level Security (RLS)

All tables have RLS enabled with role-based policies:

**Admin Role** - Full access to all tables
**Manager Role** - Read all, write own department
**User Role** - Read own records only

### Environment Security

1. **Never commit** `.env` files to version control
2. **Use service_role key** only in backend (server-side)
3. **Use anon key** in frontend (public-facing)
4. **Rotate keys** if compromised (Settings → API → Reset)

### Database Backups

Supabase automatically backs up your database:
- **Free plan**: Daily backups, 7 days retention
- **Pro plan**: Daily backups, 30 days retention
- **Enterprise**: Custom backup schedules

Manual backup:
1. Go to **Database** → **Backups**
2. Click **"Create backup"**

---

## 🧪 Testing Checklist

After setup, verify these work:

- [ ] Can view tables in Table Editor
- [ ] Admin user exists in `users` table
- [ ] Can insert test system access request
- [ ] Request number auto-generates (SAR-YYYY-NNN)
- [ ] Frontend can connect (anon key)
- [ ] Backend can connect (service_role key)
- [ ] RLS policies active (check Authentication → Policies)
- [ ] Triggers working (insert request, check history table)
- [ ] Views accessible (query vw_system_access_requests_detailed)

### Test Query

Run in SQL Editor to verify everything works:

```sql
-- Insert test request
INSERT INTO system_access_requests (
    employee_first_name,
    employee_last_name,
    employee_id,
    department,
    position,
    priority,
    status
) VALUES (
    'John',
    'Doe',
    'EMP001',
    'IT',
    'Developer',
    'medium',
    'pending'
);

-- Verify request created
SELECT request_number, employee_first_name, status, created_at
FROM system_access_requests
ORDER BY created_at DESC
LIMIT 1;

-- Verify history logged
SELECT * FROM system_access_history
ORDER BY changed_at DESC
LIMIT 1;

-- Check dashboard view
SELECT * FROM vw_dashboard_stats;
```

Expected results:
1. Request inserted with auto-generated number like `SAR-2025-001`
2. History record created automatically
3. Dashboard stats show counts

---

## 🔧 Troubleshooting

### Issue: "relation does not exist"

**Solution**: Schema not executed properly
1. Go to SQL Editor
2. Re-run entire `supabase_setup.sql` file
3. Check for error messages in output

### Issue: "permission denied for table"

**Solution**: RLS policy issue
1. Verify RLS enabled: Go to table → Settings → Enable RLS
2. Check policies exist: Authentication → Policies
3. Verify user role in `users` table

### Issue: "Cannot connect from frontend/backend"

**Solution**: Environment variables incorrect
1. Double-check `.env` files have correct values
2. Verify URL format: `https://xxxxx.supabase.co` (no trailing slash)
3. Check API keys match Dashboard → Settings → API
4. Restart dev servers after changing `.env`

### Issue: "Request number not generating"

**Solution**: Trigger not created
1. Run this in SQL Editor:
```sql
-- Check if trigger exists
SELECT tgname FROM pg_trigger WHERE tgname = 'set_request_number_trigger';

-- If missing, create it
CREATE TRIGGER set_request_number_trigger
    BEFORE INSERT ON system_access_requests
    FOR EACH ROW
    EXECUTE FUNCTION generate_request_number();
```

### Issue: "Too many rows returned"

**Solution**: Add filters to queries
```sql
-- Instead of: SELECT * FROM system_access_requests;
-- Use: 
SELECT * FROM system_access_requests 
WHERE status = 'pending' 
LIMIT 100;
```

---

## 📚 Additional Resources

### Supabase Documentation
- [Database](https://supabase.com/docs/guides/database)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [SQL Editor](https://supabase.com/docs/guides/database/sql-editor)

### AssetFlow Documentation
- See `CLIENT_README.md` for user guide
- See `SYSTEM_ACCESS_IMPLEMENTATION.md` for technical details
- See `QUICK_REFERENCE_CARD.md` for quick reference

### Support
- Supabase Discord: https://discord.supabase.com
- Supabase Support: support@supabase.io

---

## 🎯 Next Steps

After database setup is complete:

1. **Start Backend Server**
   ```bash
   cd backend
   npm install
   npm start
   ```

2. **Start Frontend Application**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

3. **Test System Access Form**
   - Navigate to http://localhost:3000/system-access
   - Create a test request
   - Verify it saves to database

4. **Configure Azure AD** (for SSO)
   - See `CLIENT_README.md` Authentication section
   - Update Azure app registration
   - Add redirect URLs

5. **Deploy to Production**
   - Update environment variables for production URLs
   - Configure Vercel/hosting platform
   - Update Supabase CORS settings if needed

---

## ✅ Setup Complete!

Your AssetFlow database is now ready. The system can:

- ✅ Store system access requests
- ✅ Track 27 Oracle Fusion ERP access groups
- ✅ Manage 6 IT asset types
- ✅ Auto-generate request numbers
- ✅ Log all changes for audit
- ✅ Enforce role-based security
- ✅ Generate reports via views

**Start using the application and monitor in Supabase Dashboard!**

---

*Last Updated: November 15, 2025*
*Schema Version: 1.0*
*Tables: 12 | Views: 3 | Functions: 2 | Triggers: 2*
