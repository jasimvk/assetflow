-- Assets Table Setup for Supabase
-- This SQL script sets up the assets table for AssetFlow
-- Run this script in your Supabase SQL Editor to create the assets table with all necessary configurations

-- ============================================================================
-- STEP 1: Create Assets Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS assets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    asset_code VARCHAR(50), -- Organization asset code (e.g., 1H-00026)
    description TEXT,
    category VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    serial_number VARCHAR(100), -- Nullable, no unique constraint (multiple assets may not have serial numbers)
    model VARCHAR(100),
    manufacturer VARCHAR(100),
    purchase_date DATE, -- Nullable for assets without purchase records
    purchase_cost DECIMAL(12, 2) DEFAULT 0 CHECK (purchase_cost >= 0), -- Nullable with default
    current_value DECIMAL(12, 2) DEFAULT 0 CHECK (current_value >= 0), -- Nullable with default
    condition VARCHAR(20) CHECK (condition IN ('excellent', 'good', 'fair', 'poor')) DEFAULT 'good',
    status VARCHAR(50) CHECK (status IN ('active', 'in_stock', 'maintenance', 'retired', 'disposed')) DEFAULT 'active',
    assigned_to TEXT, -- User name or email
    department_id UUID REFERENCES departments(id) ON DELETE SET NULL, -- Foreign key to departments table
    maintenance_schedule VARCHAR(50), -- e.g., 'monthly', 'quarterly', 'annually'
    warranty_expiry DATE,
    notes TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- STEP 2: Create Indexes for Performance
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);                                                 
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status);
CREATE INDEX IF NOT EXISTS idx_assets_serial_number ON assets(serial_number) WHERE serial_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_assigned_to ON assets(assigned_to) WHERE assigned_to IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_department_id ON assets(department_id) WHERE department_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_asset_code ON assets(asset_code) WHERE asset_code IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_condition ON assets(condition);
CREATE INDEX IF NOT EXISTS idx_assets_manufacturer ON assets(manufacturer) WHERE manufacturer IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_model ON assets(model) WHERE model IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_created_at ON assets(created_at);

-- ============================================================================
-- STEP 3: Create Trigger for Updated_At Timestamp
-- ============================================================================

-- Function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_assets_updated_at ON assets;

-- Create trigger to update updated_at on row update
CREATE TRIGGER update_assets_updated_at
    BEFORE UPDATE ON assets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STEP 4: Drop Existing RLS Policies (if any)
-- ============================================================================

DROP POLICY IF EXISTS "Enable read access for all users" ON assets;
DROP POLICY IF EXISTS "Enable insert access for all users" ON assets;
DROP POLICY IF EXISTS "Enable update access for all users" ON assets;
DROP POLICY IF EXISTS "Enable delete access for all users" ON assets;

-- ============================================================================
-- STEP 5: Enable Row Level Security (RLS)
-- ============================================================================

ALTER TABLE assets ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 6: Create RLS Policies
-- ============================================================================

-- Allow all authenticated users to read assets
CREATE POLICY "Enable read access for all users" ON assets
    FOR SELECT
    USING (true);

-- Allow all authenticated users to insert assets (admin-controlled in app)
CREATE POLICY "Enable insert access for all users" ON assets
    FOR INSERT
    WITH CHECK (true);

-- Allow all authenticated users to update assets (admin-controlled in app)
CREATE POLICY "Enable update access for all users" ON assets
    FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- Allow all authenticated users to delete assets (admin-controlled in app)
CREATE POLICY "Enable delete access for all users" ON assets
    FOR DELETE
    USING (true);

-- ============================================================================
-- STEP 7: Verification Queries
-- ============================================================================

-- View table structure
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'assets' 
ORDER BY ordinal_position;

-- Count total assets
SELECT COUNT(*) as total_assets FROM assets;

-- Count assets by status
SELECT 
    status,
    COUNT(*) as count
FROM assets 
GROUP BY status 
ORDER BY count DESC;

-- Count assets by category
SELECT 
    category,
    COUNT(*) as count
FROM assets 
GROUP BY category 
ORDER BY count DESC;

-- View recent assets
SELECT 
    id,
    name,
    category,
    location,
    status,
    created_at
FROM assets 
ORDER BY created_at DESC 
LIMIT 10;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. Categories are stored as VARCHAR values (not foreign keys to categories table)
-- 2. Location is stored as VARCHAR (not foreign key to locations table)
-- 3. assigned_to is TEXT to store user names/emails directly
-- 4. department_id is a FOREIGN KEY to departments table for data integrity
-- 5. serial_number is nullable and not unique (some assets may not have serial numbers)
-- 6. purchase_cost and current_value have CHECK constraints to ensure non-negative values
-- 7. Condition must be one of: 'excellent', 'good', 'fair', 'poor'
-- 8. Status must be one of: 'active', 'in_stock', 'maintenance', 'retired', 'disposed'
-- 9. RLS policies allow all authenticated users, but actual permissions should be
--    controlled at the application level (admin users only for modifications)
-- 10. updated_at is automatically updated via trigger on any row update
-- 11. This script is idempotent - safe to run multiple times
-- 12. IMPORTANT: Run departments_table.sql BEFORE running this script
-- ============================================================================

-- ============================================================================
-- OPTIONAL: Sample Asset Data (uncomment to insert test data)
-- ============================================================================

-- INSERT INTO assets (name, category, location, manufacturer, model, status, condition) VALUES
-- ('Dell PowerEdge R740', 'Server', 'Data Center A - Rack 1', 'Dell', 'PowerEdge R740', 'active', 'excellent'),
-- ('HP ProLiant DL380', 'Server', 'Data Center A - Rack 2', 'HP', 'ProLiant DL380 Gen10', 'active', 'good'),
-- ('Cisco Catalyst 2960', 'Switch', 'Network Room - Floor 1', 'Cisco', 'Catalyst 2960-X', 'active', 'good'),
-- ('Lenovo ThinkPad X1', 'Laptop', 'IT Department', 'Lenovo', 'ThinkPad X1 Carbon Gen 9', 'active', 'excellent'),
-- ('Dell OptiPlex 7090', 'Desktop', 'Finance Department', 'Dell', 'OptiPlex 7090', 'active', 'good'),
-- ('Dell UltraSharp U2720Q', 'Monitor', 'Marketing Department', 'Dell', 'UltraSharp U2720Q 27"', 'active', 'excellent'),
-- ('Synology DS920+', 'Storage', 'Data Center B', 'Synology', 'DS920+', 'active', 'excellent'),
-- ('HP LaserJet Pro M404dn', 'Printer', 'Admin Office', 'HP', 'LaserJet Pro M404dn', 'active', 'good'),
-- ('Apple iPad Pro 12.9"', 'Tablet', 'Executive Office', 'Apple', 'iPad Pro 12.9" (5th gen)', 'active', 'excellent'),
-- ('iPhone 13 Pro', 'Mobile Phone', 'Sales Department', 'Apple', 'iPhone 13 Pro', 'active', 'good');
