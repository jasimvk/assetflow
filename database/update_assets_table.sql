-- Update Assets Table for AssetFlow
-- This script updates the assets table to support all 11 asset categories
-- Run this in your Supabase SQL Editor

-- Step 1: Add status column if it doesn't exist
ALTER TABLE assets 
ADD COLUMN IF NOT EXISTS status VARCHAR(50) 
CHECK (status IN ('active', 'in_stock', 'maintenance', 'retired', 'disposed')) 
DEFAULT 'active';

-- Step 2: Make serial_number nullable and non-unique for cases where multiple assets don't have serial numbers
-- First drop the existing UNIQUE constraint
ALTER TABLE assets DROP CONSTRAINT IF EXISTS assets_serial_number_key;

-- Now make serial_number nullable (it might already be, but this ensures it)
ALTER TABLE assets ALTER COLUMN serial_number DROP NOT NULL;

-- Step 3: Make purchase_date nullable for assets without purchase records
ALTER TABLE assets ALTER COLUMN purchase_date DROP NOT NULL;

-- Step 4: Make purchase_cost nullable and set default to 0
ALTER TABLE assets ALTER COLUMN purchase_cost DROP NOT NULL;
ALTER TABLE assets ALTER COLUMN purchase_cost SET DEFAULT 0;

-- Step 5: Make current_value nullable and set default to 0
ALTER TABLE assets ALTER COLUMN current_value DROP NOT NULL;
ALTER TABLE assets ALTER COLUMN current_value SET DEFAULT 0;

-- Step 6: Drop dependent views before altering assigned_to column
-- Views that depend on the assigned_to column must be dropped first
DROP VIEW IF EXISTS vw_assets_with_users CASCADE;

-- Step 7: Make assigned_to a TEXT field instead of UUID reference for flexibility
-- Store user names directly instead of foreign key
ALTER TABLE assets DROP CONSTRAINT IF EXISTS assets_assigned_to_fkey;
ALTER TABLE assets ALTER COLUMN assigned_to TYPE TEXT USING assigned_to::TEXT;

-- Step 8: Recreate the view if it was being used (optional - only if you need it)
-- This view is now simpler since assigned_to is just text
CREATE OR REPLACE VIEW vw_assets_with_users AS
SELECT 
    a.*,
    a.assigned_to as assigned_user_name
FROM assets a;

-- Step 9: Update or insert all 11 asset categories
INSERT INTO categories (name, description) VALUES
('Server', 'Physical and virtual servers including ProLiant, Dell, HP models with IP addresses')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Switch', 'Network switches, firewalls, and networking equipment')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Storage', 'Network Attached Storage (NAS), SAN, and storage devices')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Laptop', 'Laptop computers with OS, memory, CPU specifications and user assignments')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Desktop', 'Desktop computers with OS, memory, CPU specifications and user assignments')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Monitor', 'Display monitors assigned to users across departments')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Mobile Phone', 'Mobile phones and smartphones with IMEI numbers')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Walkie Talkie', 'Two-way radios and walkie talkie devices')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Tablet', 'Tablet devices including iPads and Android tablets')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Printer', 'Printers including laser, inkjet, and multifunction devices')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('IT Peripherals', 'Keyboards, mice, webcams, and other computer peripherals')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO categories (name, description) VALUES
('Other', 'Other assets not fitting into standard categories')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

-- Step 10: Insert common locations if they don't exist
INSERT INTO locations (name, address) VALUES
('Head Office', 'Main Office Location')
ON CONFLICT (name) DO NOTHING;

INSERT INTO locations (name, address) VALUES
('Spanish Villa', 'Spanish Villa Property')
ON CONFLICT (name) DO NOTHING;

INSERT INTO locations (name, address) VALUES
('White Villa', 'White Villa Property')
ON CONFLICT (name) DO NOTHING;

INSERT INTO locations (name, address) VALUES
('Saadiyat Villa 07', 'Saadiyat Villa Property')
ON CONFLICT (name) DO NOTHING;

INSERT INTO locations (name, address) VALUES
('Main Store', 'Main Store Location')
ON CONFLICT (name) DO NOTHING;

INSERT INTO locations (name, address) VALUES
('Store', 'Store Location')
ON CONFLICT (name) DO NOTHING;

-- Step 11: Add index for better performance on common queries
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status);
CREATE INDEX IF NOT EXISTS idx_assets_serial_number ON assets(serial_number) WHERE serial_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_assigned_to ON assets(assigned_to) WHERE assigned_to IS NOT NULL;

-- Step 12: Verify the changes
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'assets' 
ORDER BY ordinal_position;

-- Step 13: Show all categories
SELECT * FROM categories ORDER BY name;

-- Step 14: Show all locations
SELECT * FROM locations ORDER BY name;

-- Step 15: Show asset counts by category (will be 0 initially)
SELECT 
    category,
    COUNT(*) as count
FROM assets
GROUP BY category
ORDER BY count DESC;

-- Migration complete!
-- You can now:
-- 1. Import assets using the SQL import files in /database/ folder
-- 2. Use the web interface to add assets via CSV import
-- 3. Manually add assets through the Assets page

COMMIT;
