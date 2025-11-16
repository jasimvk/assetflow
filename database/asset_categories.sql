    -- Asset Categories Setup for Supabase
    -- This SQL script sets up the categories table for asset categorization in AssetFlow
    -- Run this script in your Supabase SQL Editor to create and populate asset categories

    -- ============================================================================
    -- STEP 1: Create Categories Table
    -- ============================================================================

    CREATE TABLE IF NOT EXISTS categories (
        id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
        name VARCHAR(100) UNIQUE NOT NULL,
        description TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );

    -- ============================================================================
    -- STEP 2: Insert Default Asset Categories (14 Types)
    -- ============================================================================
    -- Updated to include all asset types from import scripts

    INSERT INTO categories (name, description) VALUES
    ('Accessory', 'Device accessories like keyboards, Apple Pencil, Magic Keyboard, chargers'),
    ('Desktop', 'Desktop computers with OS, memory, CPU specifications and user assignments'),
    ('Laptop', 'Laptop computers with OS, memory, CPU specifications and user assignments'),
    ('Mobile Phone', 'Mobile phones and smartphones with IMEI numbers and transfer tracking'),
    ('Monitor', 'Display monitors assigned to users across departments'),
    ('Network Device', 'Network switches, firewalls, routers, and networking equipment'),
    ('Peripheral', 'IT peripherals including mice, keyboard combos, cables, adapters, USB devices'),
    ('Printer', 'Printers including laser, inkjet, multifunction devices, ID card and label printers'),
    ('Server', 'Physical and virtual servers including ProLiant, Dell, HP models with IP addresses'),
    ('Storage', 'Network Attached Storage (NAS), SAN, and storage devices'),
    ('Switch', 'Network switches and managed switch infrastructure'),
    ('Tablet', 'Tablet devices including iPads with Wi-Fi and cellular connectivity'),
    ('Walkie Talkie', 'Two-way radios and walkie talkie devices with transfer history'),
    ('Other', 'Other assets not fitting into standard categories')
    ON CONFLICT (name) DO NOTHING;

    -- ============================================================================
    -- STEP 3: Create Indexes for Performance
    -- ============================================================================

    CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name);

-- ============================================================================
-- STEP 4: Drop Existing RLS Policies (if any)
-- ============================================================================

DROP POLICY IF EXISTS "Enable read access for all authenticated users" ON categories;
DROP POLICY IF EXISTS "Enable insert access for authenticated users" ON categories;
DROP POLICY IF EXISTS "Enable update access for authenticated users" ON categories;
DROP POLICY IF EXISTS "Enable delete access for authenticated users" ON categories;

-- ============================================================================
-- STEP 5: Enable Row Level Security (RLS)
-- ============================================================================

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 6: Create RLS Policies
-- ============================================================================

-- Allow all authenticated users to read categories
CREATE POLICY "Enable read access for all authenticated users" ON categories
    FOR SELECT
    USING (true);

-- Allow all authenticated users to insert categories (admin-controlled in app)
CREATE POLICY "Enable insert access for authenticated users" ON categories
    FOR INSERT
    WITH CHECK (true);

-- Allow all authenticated users to update categories (admin-controlled in app)
CREATE POLICY "Enable update access for authenticated users" ON categories
    FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- Allow all authenticated users to delete categories (admin-controlled in app)
CREATE POLICY "Enable delete access for authenticated users" ON categories
    FOR DELETE
    USING (true);

-- ============================================================================
-- STEP 7: Verification Queries
-- ============================================================================

-- View all categories
SELECT 
    id,
    name,
    description,
    created_at
FROM categories 
ORDER BY name;

    -- Count total categories
    SELECT COUNT(*) as total_categories FROM categories;

    -- ============================================================================
    -- NOTES:
    -- ============================================================================
    -- 1. Categories are used as VARCHAR values in the assets table (not foreign keys)
    -- 2. RLS policies allow all authenticated users, but actual permissions should be
    --    controlled at the application level (admin users only for modifications)
    -- 3. This script is idempotent - safe to run multiple times
    -- 4. The 'ON CONFLICT DO NOTHING' clause prevents duplicate category insertion
    -- 5. You can add custom categories by inserting new rows into this table
    -- ============================================================================

    -- Optional: Add custom categories (uncomment and modify as needed)
    -- INSERT INTO categories (name, description) VALUES
    -- ('Network Equipment', 'Routers, access points, and other network devices'),
    -- ('Audio/Video', 'Projectors, speakers, microphones, and AV equipment'),
    -- ('Software Licenses', 'Software licenses and subscriptions')
    -- ON CONFLICT (name) DO NOTHING;
