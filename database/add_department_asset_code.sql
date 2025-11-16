-- Migration: Add department and asset_code columns to assets table
-- Run this in Supabase SQL Editor if you already have the assets table created
-- This will add the missing columns without affecting existing data

-- Add department column
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS department VARCHAR(100);

-- Add asset_code column
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS asset_code VARCHAR(50);

-- Add indexes for the new columns
CREATE INDEX IF NOT EXISTS idx_assets_department ON assets(department) WHERE department IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_asset_code ON assets(asset_code) WHERE asset_code IS NOT NULL;

-- Add comments for documentation
COMMENT ON COLUMN assets.department IS 'Department name (e.g., HR, IT, Finance, Operations, Housekeeping)';
COMMENT ON COLUMN assets.asset_code IS 'Organization asset code for tracking (e.g., 1H-00026)';

-- Verify the columns were added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'assets'
  AND column_name IN ('department', 'asset_code')
ORDER BY column_name;
