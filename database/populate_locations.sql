-- ============================================================================
-- Populate Locations Table
-- AssetFlow - Location Master Data
-- ============================================================================
-- This script populates the locations table with all physical locations
-- from the asset inventory
--
-- RUN ORDER:
-- 1. Run this script BEFORE importing any assets
-- 2. Locations are used as foreign keys in assets table
-- ============================================================================

BEGIN;

-- Clear existing locations (optional - comment out if appending)
-- DELETE FROM locations;

-- Insert all locations from inventory
INSERT INTO locations (name, address, building, floor, room) VALUES
-- Main Office Locations
('Head Office', NULL, 'Main Building', NULL, NULL),
('Main Office', NULL, 'Main Building', NULL, NULL),

-- Villa Locations
('WHITE VILLA', NULL, 'White Villa', NULL, NULL),
('SPANISH VILLA', NULL, 'Spanish Villa', NULL, NULL),
('SAADIYAT VILLA 7', NULL, 'Saadiyat Villa 7', NULL, NULL),
('BARARI VILLA 1504', NULL, 'Al Barari Villa 1504', NULL, NULL),
('ALRAKNA', NULL, 'Al Rakna Villa', NULL, NULL),

-- Kitchen Locations
('MUROOR KITCHEN', NULL, 'Muroor Kitchen', NULL, NULL),
('WATHBA KITCHEN', NULL, 'Wathba Kitchen', NULL, NULL),
('YASAT', NULL, 'Al Yasat Kitchen', NULL, NULL),

-- Store Locations
('MAIN STORE', NULL, 'Main Store', NULL, NULL),
('Store', NULL, 'Store Building', NULL, NULL),

-- Data Center / Server Room
('Data Center', NULL, 'Main Building', NULL, 'Data Center'),
('Server Room', NULL, 'Main Building', NULL, 'Server Room')

ON CONFLICT (name) DO NOTHING;

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count all locations
SELECT COUNT(*) as total_locations FROM locations;

-- View all locations
SELECT 
    name,
    building,
    address,
    floor,
    room,
    created_at
FROM locations
ORDER BY name;

-- Group by building
SELECT 
    building,
    COUNT(*) as count
FROM locations
WHERE building IS NOT NULL
GROUP BY building
ORDER BY count DESC;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Locations Populated!';
    RAISE NOTICE '📍 Total Locations: %', (SELECT COUNT(*) FROM locations);
    RAISE NOTICE '🏢 Main Buildings: %', (SELECT COUNT(*) FROM locations WHERE building LIKE '%Main%');
    RAISE NOTICE '🏠 Villas: %', (SELECT COUNT(*) FROM locations WHERE building LIKE '%Villa%');
    RAISE NOTICE '🍳 Kitchens: %', (SELECT COUNT(*) FROM locations WHERE building LIKE '%Kitchen%');
    RAISE NOTICE '📦 Stores: %', (SELECT COUNT(*) FROM locations WHERE building LIKE '%Store%');
END $$;
