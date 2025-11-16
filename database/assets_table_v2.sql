-- Assets Table V2 - Redesigned for AssetFlow
-- This matches the actual inventory structure with all necessary fields
-- Run this script in your Supabase SQL Editor

-- ============================================================================
-- STEP 1: Create Improved Assets Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS assets (
    -- Core Identity Fields
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,                          -- Asset Name (e.g., ONEH-RANJEET, LAPTOP-001)
    asset_code VARCHAR(50),                              -- Organization asset code (e.g., 1H-00026)
    
    -- Category & Classification
    category VARCHAR(100) NOT NULL,                      -- Server, Laptop, Desktop, Monitor, etc.
    
    -- Hardware Details
    manufacturer VARCHAR(100),                           -- HP, Lenovo, Dell, etc.
    model VARCHAR(200),                                  -- Full model name
    serial_number VARCHAR(100),                          -- Serial number
    
    -- Technical Specifications (stored as TEXT for flexibility)
    os_version VARCHAR(100),                             -- Windows 11 Pro, MacOS, etc.
    cpu_type VARCHAR(200),                               -- Processor details
    memory VARCHAR(50),                                  -- RAM (e.g., 16 GB)
    storage VARCHAR(50),                                 -- Storage capacity (e.g., 512 GB)
    specifications TEXT,                                 -- Additional specs in pipe-delimited format
    
    -- Network Information (for servers, switches, etc.)
    ip_address VARCHAR(45),                              -- IPv4 or IPv6
    mac_address VARCHAR(17),                             -- MAC address
    ilo_ip VARCHAR(45),                                  -- ILO/iDRAC IP for servers
    
    -- Location
    location VARCHAR(255) NOT NULL,                      -- Physical location
    in_office_location VARCHAR(255),                     -- Specific office location
    
    -- Assignment & Ownership
    assigned_to TEXT,                                    -- Current user/person assigned
    department_id UUID REFERENCES departments(id) ON DELETE SET NULL,  -- Department foreign key
    previous_owner VARCHAR(255),                         -- Previous owner/user
    
    -- Status & Condition
    status VARCHAR(50) CHECK (status IN ('active', 'in_stock', 'maintenance', 'retired', 'disposed', 'not_upgradable')) DEFAULT 'active',
    condition VARCHAR(20) CHECK (condition IN ('excellent', 'good', 'fair', 'poor')) DEFAULT 'good',
    
    -- Financial & Warranty
    purchase_date DATE,                                  -- Date of purchase
    warranty_expiry DATE,                                -- Warranty end date
    purchase_cost DECIMAL(12, 2) DEFAULT 0 CHECK (purchase_cost >= 0),
    current_value DECIMAL(12, 2) DEFAULT 0 CHECK (current_value >= 0),
    
    -- Software & Security (for laptops/desktops)
    sentinel_status VARCHAR(20),                         -- Done, Pending, Not Installed
    ninja_status VARCHAR(20),                            -- Done, Pending, Not Installed
    domain_status VARCHAR(50),                           -- Domain, Non Domain, Workgroup
    
    -- Dates & Tracking
    issue_date DATE,                                     -- Date issued to user
    transferred_date DATE,                               -- Date transferred to current user
    year_of_purchase INTEGER,                            -- Year purchased
    
    -- Additional Information
    function VARCHAR(100),                               -- Admin, Operation, etc.
    physical_virtual VARCHAR(20),                        -- Physical, Virtual (for servers)
    notes TEXT,                                          -- General notes
    description TEXT,                                    -- Detailed description
    
    -- Maintenance
    maintenance_schedule VARCHAR(50),                    -- monthly, quarterly, annually
    
    -- Media
    image_url VARCHAR(500),                              -- Asset image URL
    
    -- Audit Fields
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- STEP 2: Add Column Comments for Documentation
-- ============================================================================

COMMENT ON TABLE assets IS 'Main assets table storing all IT hardware and equipment';
COMMENT ON COLUMN assets.name IS 'Asset identifier/hostname (e.g., ONEH-RANJEET, 1H-SERVER)';
COMMENT ON COLUMN assets.asset_code IS 'Organization asset code (e.g., 1H-00026)';
COMMENT ON COLUMN assets.specifications IS 'Technical specs in pipe-delimited format (e.g., Windows 11 Pro | 16 GB | i7-12700 | 512 GB)';
COMMENT ON COLUMN assets.ip_address IS 'Primary IP address for network devices and servers';
COMMENT ON COLUMN assets.mac_address IS 'MAC address for network identification';
COMMENT ON COLUMN assets.ilo_ip IS 'ILO/iDRAC/BMC IP address for servers';
COMMENT ON COLUMN assets.in_office_location IS 'Specific location within office (e.g., Finance Office, Admin Office)';
COMMENT ON COLUMN assets.sentinel_status IS 'Sentinel One antivirus installation status';
COMMENT ON COLUMN assets.ninja_status IS 'Ninja RMM installation status';
COMMENT ON COLUMN assets.domain_status IS 'Domain join status (Domain, Non Domain, Workgroup)';
COMMENT ON COLUMN assets.function IS 'Functional category (Admin, Operation, etc.)';
COMMENT ON COLUMN assets.physical_virtual IS 'Physical or Virtual (for servers)';

-- ============================================================================
-- STEP 3: Create Comprehensive Indexes for Performance
-- ============================================================================

-- Core lookup indexes
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status);
CREATE INDEX IF NOT EXISTS idx_assets_condition ON assets(condition);
CREATE INDEX IF NOT EXISTS idx_assets_asset_code ON assets(asset_code) WHERE asset_code IS NOT NULL;

-- Hardware indexes
CREATE INDEX IF NOT EXISTS idx_assets_serial_number ON assets(serial_number) WHERE serial_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_manufacturer ON assets(manufacturer) WHERE manufacturer IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_model ON assets(model) WHERE model IS NOT NULL;

-- Assignment indexes
CREATE INDEX IF NOT EXISTS idx_assets_assigned_to ON assets(assigned_to) WHERE assigned_to IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_department_id ON assets(department_id) WHERE department_id IS NOT NULL;

-- Network indexes
CREATE INDEX IF NOT EXISTS idx_assets_ip_address ON assets(ip_address) WHERE ip_address IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_mac_address ON assets(mac_address) WHERE mac_address IS NOT NULL;

-- Date indexes
CREATE INDEX IF NOT EXISTS idx_assets_purchase_date ON assets(purchase_date) WHERE purchase_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_warranty_expiry ON assets(warranty_expiry) WHERE warranty_expiry IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_created_at ON assets(created_at);

-- Status indexes
CREATE INDEX IF NOT EXISTS idx_assets_domain_status ON assets(domain_status) WHERE domain_status IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_function ON assets(function) WHERE function IS NOT NULL;

-- ============================================================================
-- STEP 4: Create Trigger for Updated_At Timestamp
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_assets_updated_at ON assets;

CREATE TRIGGER update_assets_updated_at
    BEFORE UPDATE ON assets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STEP 5: Enable Row Level Security (RLS)
-- ============================================================================

ALTER TABLE assets ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON assets;
DROP POLICY IF EXISTS "Enable insert access for all users" ON assets;
DROP POLICY IF EXISTS "Enable update access for all users" ON assets;
DROP POLICY IF EXISTS "Enable delete access for all users" ON assets;

-- Create new policies
CREATE POLICY "Enable read access for all users" ON assets
    FOR SELECT USING (true);

CREATE POLICY "Enable insert access for all users" ON assets
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update access for all users" ON assets
    FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Enable delete access for all users" ON assets
    FOR DELETE USING (true);

-- ============================================================================
-- STEP 6: Verification Queries
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

-- Count assets by category
SELECT 
    category,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count
FROM assets 
GROUP BY category 
ORDER BY count DESC;

-- Count assets by department (with names)
SELECT 
    d.name as department,
    COUNT(a.id) as asset_count,
    COUNT(CASE WHEN a.status = 'active' THEN 1 END) as active_count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
GROUP BY d.name
ORDER BY asset_count DESC;

-- View recent assets with department
SELECT 
    a.name,
    a.category,
    a.manufacturer,
    a.model,
    a.assigned_to,
    d.name as department,
    a.location,
    a.status,
    a.created_at
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
ORDER BY a.created_at DESC 
LIMIT 10;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. This schema matches your actual inventory structure from inventory.txt
-- 2. All fields from your Excel inventory are now properly mapped
-- 3. Department relationships use foreign keys for data integrity
-- 4. Network fields (IP, MAC, ILO) added for servers and network equipment
-- 5. Software status fields (Sentinel, Ninja, Domain) added for tracking
-- 6. Flexible specifications field for variable technical details
-- 7. Previous owner tracking for transfer history
-- 8. Function field for Admin/Operation classification
-- 9. Physical/Virtual distinction for servers
-- 10. IMPORTANT: Run departments_table.sql BEFORE this script
-- 11. This script is idempotent - safe to run multiple times
-- ============================================================================
