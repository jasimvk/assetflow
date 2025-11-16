-- Migration Script: Upgrade Assets Table to V2 Schema
-- This adds all new columns to your existing assets table
-- Run this in your Supabase SQL Editor if you already have an assets table

-- ============================================================================
-- STEP 1: Add New Columns to Existing Assets Table
-- ============================================================================

-- Core Identity
ALTER TABLE assets ADD COLUMN IF NOT EXISTS asset_code VARCHAR(50);

-- Technical Specifications
ALTER TABLE assets ADD COLUMN IF NOT EXISTS os_version VARCHAR(100);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS cpu_type VARCHAR(200);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS memory VARCHAR(50);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS storage VARCHAR(50);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS specifications TEXT;

-- Network Information
ALTER TABLE assets ADD COLUMN IF NOT EXISTS ip_address VARCHAR(45);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS mac_address VARCHAR(17);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS ilo_ip VARCHAR(45);

-- Enhanced Location
ALTER TABLE assets ADD COLUMN IF NOT EXISTS in_office_location VARCHAR(255);

-- Transfer History
ALTER TABLE assets ADD COLUMN IF NOT EXISTS previous_owner VARCHAR(255);

-- Software & Security Status
ALTER TABLE assets ADD COLUMN IF NOT EXISTS sentinel_status VARCHAR(20);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS ninja_status VARCHAR(20);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS domain_status VARCHAR(50);

-- Date Tracking
ALTER TABLE assets ADD COLUMN IF NOT EXISTS issue_date DATE;
ALTER TABLE assets ADD COLUMN IF NOT EXISTS transferred_date DATE;
ALTER TABLE assets ADD COLUMN IF NOT EXISTS year_of_purchase INTEGER;

-- Classification
ALTER TABLE assets ADD COLUMN IF NOT EXISTS function VARCHAR(100);
ALTER TABLE assets ADD COLUMN IF NOT EXISTS physical_virtual VARCHAR(20);

-- ============================================================================
-- STEP 2: Update Status Column to Include New Values
-- ============================================================================

-- Drop old constraint
ALTER TABLE assets DROP CONSTRAINT IF EXISTS assets_status_check;

-- Add new constraint with additional status values
ALTER TABLE assets ADD CONSTRAINT assets_status_check 
CHECK (status IN ('active', 'in_stock', 'maintenance', 'retired', 'disposed', 'not_upgradable'));

-- ============================================================================
-- STEP 3: Create New Indexes for Performance
-- ============================================================================

-- Core indexes (skip if already exist)
CREATE INDEX IF NOT EXISTS idx_assets_asset_code ON assets(asset_code) WHERE asset_code IS NOT NULL;

-- Network indexes
CREATE INDEX IF NOT EXISTS idx_assets_ip_address ON assets(ip_address) WHERE ip_address IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_mac_address ON assets(mac_address) WHERE mac_address IS NOT NULL;

-- Date indexes
CREATE INDEX IF NOT EXISTS idx_assets_purchase_date ON assets(purchase_date) WHERE purchase_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_warranty_expiry ON assets(warranty_expiry) WHERE warranty_expiry IS NOT NULL;

-- Status indexes
CREATE INDEX IF NOT EXISTS idx_assets_domain_status ON assets(domain_status) WHERE domain_status IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_function ON assets(function) WHERE function IS NOT NULL;

-- ============================================================================
-- STEP 4: Add Column Comments for Documentation
-- ============================================================================

COMMENT ON COLUMN assets.asset_code IS 'Organization asset code (e.g., 1H-00026)';
COMMENT ON COLUMN assets.os_version IS 'Operating system (Windows 11 Pro, MacOS, etc.)';
COMMENT ON COLUMN assets.cpu_type IS 'Processor details';
COMMENT ON COLUMN assets.memory IS 'RAM capacity (e.g., 16 GB)';
COMMENT ON COLUMN assets.storage IS 'Storage capacity (e.g., 512 GB)';
COMMENT ON COLUMN assets.specifications IS 'Technical specs in pipe-delimited format';
COMMENT ON COLUMN assets.ip_address IS 'Primary IP address for network devices';
COMMENT ON COLUMN assets.mac_address IS 'MAC address';
COMMENT ON COLUMN assets.ilo_ip IS 'ILO/iDRAC/BMC IP for servers';
COMMENT ON COLUMN assets.in_office_location IS 'Specific office location (e.g., Finance Office)';
COMMENT ON COLUMN assets.previous_owner IS 'Previous user/owner';
COMMENT ON COLUMN assets.sentinel_status IS 'Sentinel One antivirus status';
COMMENT ON COLUMN assets.ninja_status IS 'Ninja RMM status';
COMMENT ON COLUMN assets.domain_status IS 'Domain join status (Domain, Non Domain, Workgroup)';
COMMENT ON COLUMN assets.issue_date IS 'Date issued to user';
COMMENT ON COLUMN assets.transferred_date IS 'Date transferred to current user';
COMMENT ON COLUMN assets.year_of_purchase IS 'Year purchased';
COMMENT ON COLUMN assets.function IS 'Functional category (Admin, Operation, etc.)';
COMMENT ON COLUMN assets.physical_virtual IS 'Physical or Virtual (for servers)';

-- ============================================================================
-- STEP 5: Verification Queries
-- ============================================================================

-- View updated table structure
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'assets' 
ORDER BY ordinal_position;

-- Count total columns
SELECT COUNT(*) as total_columns
FROM information_schema.columns 
WHERE table_name = 'assets';

-- Verify new columns exist
SELECT 
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_name = 'assets' 
  AND column_name IN (
    'asset_code', 'os_version', 'cpu_type', 'memory', 'storage',
    'ip_address', 'mac_address', 'ilo_ip', 'in_office_location',
    'sentinel_status', 'ninja_status', 'domain_status', 'function'
  )
ORDER BY column_name;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$ 
BEGIN
    RAISE NOTICE '✅ Migration to V2 schema completed successfully!';
    RAISE NOTICE '✅ Added 18 new columns to assets table';
    RAISE NOTICE '✅ Created new indexes for performance';
    RAISE NOTICE '✅ Updated status constraint';
    RAISE NOTICE '';
    RAISE NOTICE '📋 Next steps:';
    RAISE NOTICE '1. Run import_assets_desktops_v3.sql to import desktop data';
    RAISE NOTICE '2. Update remaining import scripts to use V3 format';
    RAISE NOTICE '3. Update frontend to display new fields';
END $$;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. This script is SAFE to run on existing databases
-- 2. Uses ADD COLUMN IF NOT EXISTS - won't fail if columns already exist
-- 3. Preserves all existing data
-- 4. Adds new columns as nullable - won't break existing records
-- 5. You can now use import_assets_desktops_v3.sql
-- 6. All new fields are optional - existing data remains valid
-- ============================================================================
