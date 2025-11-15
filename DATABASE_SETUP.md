# 🗄️ Database Setup Instructions

## Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up / Log in
3. Create a new project
4. Note down your:
   - Project URL (e.g., `https://your-project.supabase.co`)
   - Anon/Public Key

## Step 2: Create Assets Table

Run this SQL in Supabase SQL Editor:

```sql
-- Create assets table
CREATE TABLE IF NOT EXISTS assets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  location VARCHAR(255),
  purchase_date DATE,
  purchase_cost DECIMAL(10, 2),
  current_value DECIMAL(10, 2),
  condition VARCHAR(50) CHECK (condition IN ('excellent', 'good', 'fair', 'poor')),
  assigned_to VARCHAR(255),
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster searches
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_condition ON assets(condition);

-- Enable Row Level Security
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for demo purposes)
CREATE POLICY "Allow all operations" ON assets
  FOR ALL
  USING (true)
  WITH CHECK (true);
```

## Step 3: Update Environment Variables

Update `frontend/.env.local` with your actual credentials:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-actual-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-actual-anon-key
NEXT_PUBLIC_API_BASE_URL=http://localhost:3002
```

## Step 4: Import Excel Data

Once you have configured Supabase credentials, run:

```bash
source venv/bin/activate
python import_excel_to_supabase.py
```

## Alternative: Manual Import via CSV

If you prefer to import via CSV:

1. Convert Excel sheets to CSV
2. Import directly in Supabase dashboard
3. Use the Table Editor to import CSV files

## Quick Start Without Database

Your app currently works without a database (demo mode). The assets are stored in local state. If you want to add database persistence:

1. Complete steps 1-3 above
2. Redeploy to Vercel with environment variables set
3. The app will automatically connect to Supabase

## Excel File Structure

Your Excel file has these sheets:
- Server (11 items)
- Switch (9 items)
- Storage (3 items)
- Laptop (101 items)
- Desktop (54 items)
- Monitor (50 items)
- Mobile Phones (298 items)
- Walkie Talkie (166 items)
- Tablet (6 items)
- Printer (38 items)
- iPhones (23 items)
- IT Peripherals (37 items)

**Total: ~796 assets** ready to import!
