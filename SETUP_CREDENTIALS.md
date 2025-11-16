# Setting Up Supabase Credentials

## Issue
The import script cannot connect to Supabase because the `.env` file contains placeholder values.

## Solution

### Step 1: Get Your Supabase Credentials

1. Go to your Supabase project dashboard: https://supabase.com/dashboard
2. Select your project (or create a new one if you haven't yet)
3. Go to **Project Settings** (gear icon in sidebar)
4. Click on **API** section
5. Copy these values:
   - **Project URL** (looks like: `https://xxxxxxxxxxxxx.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)
   - **service_role key** (starts with `eyJ...` - **Keep this secret!**)

### Step 2: Update Backend `.env` File

Edit `/Users/admin/Desktop/Personal/projects/assetflow/backend/.env` and replace the placeholder values:

```bash
# Supabase Database Configuration
SUPABASE_URL=https://your-actual-project-id.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-actual-service-role-key-here
SUPABASE_ANON_KEY=your-actual-anon-key-here
```

### Step 3: Update Frontend `.env.local` File

Create `/Users/admin/Desktop/Personal/projects/assetflow/frontend/.env.local`:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-actual-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-actual-anon-key-here
NEXT_PUBLIC_API_URL=http://localhost:3001
```

### Step 4: Verify Database Schema is Set Up

Make sure your Supabase database has all the required tables. You can run the schema from:
- `/database/supabase_setup.sql` - Main database schema
- `/database/schema.sql` - Additional schema

To run the schema:
1. Go to Supabase Dashboard → SQL Editor
2. Copy the contents of `supabase_setup.sql`
3. Click "Run" to execute

### Step 5: Run the Import Script

Once credentials are set up:

```bash
cd /Users/admin/Desktop/Personal/projects/assetflow
node import_servers_simple.js
```

You should see output like:
```
✅ Connection successful
✅ Server category ID: 1
✅ HEAD OFFICE location ID: 1
✅ Successfully imported 9 servers!
```

## Current Status

❌ **Blocked**: Need real Supabase credentials
- Backend `.env` file has placeholder: `https://your-project.supabase....`
- Service role key only 21 characters (should be 200+)

Once you provide your Supabase project URL and keys, the import will work immediately!

## Alternative: Use Existing Supabase Project

If you already have a Supabase project with AssetFlow database:
1. Check if tables exist: Go to Supabase Dashboard → Table Editor
2. Look for tables: assets, categories, locations, users, etc.
3. If tables exist, just update the `.env` files with your credentials
4. If tables don't exist, run the SQL schema files first

## Security Note

⚠️ **Never commit real credentials to Git!**
- Backend uses `/backend/.env` (already in .gitignore)
- Frontend uses `/frontend/.env.local` (already in .gitignore)
- Only `.env.example` files should be in version control
