-- ============================================================================
-- Tablet Assets Import Script V3
-- AssetFlow - Complete Tablet and Accessories Inventory
-- ============================================================================
-- This script imports tablets (iPads) and their accessories
-- 
-- IMPORTANT NOTES:
-- 1. Column order matches ALTER TABLE ADD COLUMN sequence (V1: 1-22, V2: 23-40)
-- 2. All condition values MUST be lowercase: 'excellent', 'good', 'fair', 'poor'
-- 3. All status values MUST be lowercase: 'active', 'in_stock', 'maintenance', 'retired'
-- 4. purchase_cost and current_value are required (use 0 if unknown)
-- 5. Uses get_department_id() helper function for department lookup
-- 6. assigned_to is TEXT field (stores employee names directly)
--
-- V2 SCHEMA FIELDS INCLUDED:
-- - storage (512GB, 256GB for iPads)
-- - specifications (Configuration details like "Wi-Fi", "Wi-Fi + Cellular")
-- - issue_date (Date issued to user)
-- - notes (Additional information)
--
-- DEVICE TYPES:
-- - iPad Pro (M4 chip) - Latest professional tablets
-- - iPad Air 5th Gen - Mid-range tablets
-- - Accessories: Apple Pencil Pro, Magic Keyboard
--
-- RUN ORDER:
-- 1. Ensure departments table is populated (run departments_table.sql)
-- 2. Run populate_locations.sql to populate locations table
-- 3. Run fix_assigned_to_column.sql (if not already done - fixes UUID to TEXT)
-- 4. Run this script
-- ============================================================================

-- Helper function to get department ID by name
CREATE OR REPLACE FUNCTION get_department_id(dept_name TEXT)
RETURNS UUID AS $$
DECLARE
    dept_id UUID;
BEGIN
    SELECT id INTO dept_id
    FROM departments
    WHERE LOWER(name) = LOWER(dept_name)
    LIMIT 1;
    
    RETURN dept_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TABLET ASSETS IMPORT
-- ============================================================================

BEGIN;

-- Delete existing tablet assets to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Tablet';

-- 1. iPad Pro 11-inch (M4) - Varynia Wankhar F&B
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, specifications, notes
) VALUES (
    'iPad-XX73VD2TCG', 'Tablet', 'Head Office', 'XX73VD2TCG',
    'iPad Pro 11-inch (M4)', 'Apple',
    '2024-01-01', 'excellent', 'active', 'VARYNIA WANKHAR', get_department_id('F&B'),
    '2025-01-01', 0, 0, '1H-00164',
    '512GB', 'Wi-Fi', 'Latest M4 chip, 11-inch display'
);

-- 2. iPad Pro 13-Inch Wi-Fi+Cellular - Jenny Estacio
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, specifications, notes
) VALUES (
    'iPad-D7V9H6GKC6', 'Tablet', 'Head Office', 'D7V9H6GKC6',
    'iPad Pro 13-inch', 'Apple',
    '2024-01-01', 'excellent', 'active', 'Jenny Estacio', get_department_id('Executive Office'),
    '2025-01-01', 0, 0, NULL,
    '512GB', 'Wi-Fi + Cellular', 'Largest iPad Pro, cellular capability'
);

-- 3. iPad Air 5th Gen 256GB - Adina Schiopu
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, specifications, issue_date, notes
) VALUES (
    'iPad-FVRPF67TYY', 'Tablet', 'Head Office', 'FVRPF67TYY',
    'iPad Air 5th Gen', 'Apple',
    '2023-01-01', 'excellent', 'active', 'Adina Schiopu', get_department_id('Executive Office'),
    '2024-01-01', 0, 0, NULL,
    '256GB', 'Wi-Fi', NULL, 'M1 chip, 10.9-inch display'
);

-- 4. iPad Air 5th Gen 256GB - Joweley Cator
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, specifications, issue_date, notes
) VALUES (
    'iPad-KWF14HQWKH', 'Tablet', 'Head Office', 'KWF14HQWKH',
    'iPad Air 5th Gen', 'Apple',
    '2025-01-01', 'excellent', 'active', 'Joweley Cator', get_department_id('Spa and Recreation'),
    '2026-01-01', 0, 0, NULL,
    '256GB', 'Wi-Fi', '2025-04-18', 'M1 chip, 10.9-inch display'
);

COMMIT;

-- ============================================================================
-- TABLET ACCESSORIES IMPORT (Optional - can be tracked separately)
-- ============================================================================

BEGIN;

-- Delete existing accessories to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Accessory' AND model LIKE '%iPad%';

-- 1. iPad Magic Keyboard - Jenny Estacio
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES (
    'Keyboard-DP9PF7WQDL', 'Accessory', 'Head Office', 'DP9PF7WQDL',
    'iPad Magic Keyboard', 'Apple',
    '2024-01-01', 'excellent', 'active', 'Jenny Estacio', get_department_id('Executive Office'),
    '2025-01-01', 0, 0, NULL,
    'For iPad Pro', 'Backlit keyboard with trackpad, attaches magnetically'
);

-- 2. Apple Pencil Pro - Jenny Estacio
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES (
    'Pencil-CT4PY9J7KD', 'Accessory', 'Head Office', 'CT4PY9J7KD',
    'Apple Pencil Pro', 'Apple',
    '2024-01-01', 'excellent', 'active', 'Jenny Estacio', get_department_id('Executive Office'),
    '2025-01-01', 0, 0, NULL,
    'Latest generation stylus', 'Barrel roll, haptic feedback, squeeze gesture'
);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count tablet assets
SELECT COUNT(*) as total_tablets FROM assets WHERE category = 'Tablet';

-- Count tablet accessories
SELECT COUNT(*) as total_accessories FROM assets WHERE category = 'Accessory' AND model LIKE '%iPad%';

-- Tablet summary by model
SELECT 
    model,
    storage,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count
FROM assets 
WHERE category = 'Tablet'
GROUP BY model, storage
ORDER BY 
    CASE 
        WHEN model LIKE '%Pro%' THEN 1
        WHEN model LIKE '%Air%' THEN 2
        ELSE 3
    END,
    storage DESC;

-- Tablets by assigned user
SELECT 
    name,
    model,
    storage,
    specifications,
    assigned_to,
    location,
    issue_date,
    asset_code
FROM assets 
WHERE category = 'Tablet'
ORDER BY assigned_to;

-- Tablet accessories by user
SELECT 
    name,
    model,
    assigned_to,
    location,
    specifications
FROM assets 
WHERE category = 'Accessory' 
  AND (model LIKE '%iPad%' OR model LIKE '%Apple Pencil%')
ORDER BY assigned_to, model;

-- Complete iPad setup by user (tablets + accessories)
SELECT 
    a.assigned_to,
    STRING_AGG(a.model || ' (' || a.serial_number || ')', ', ' ORDER BY a.category, a.model) as devices
FROM assets a
WHERE (a.category = 'Tablet' OR (a.category = 'Accessory' AND a.model LIKE '%iPad%'))
  AND a.assigned_to IS NOT NULL
GROUP BY a.assigned_to
ORDER BY a.assigned_to;

-- View all tablets with key details
SELECT 
    name,
    model,
    storage,
    specifications,
    serial_number,
    assigned_to,
    location,
    asset_code,
    issue_date
FROM assets 
WHERE category = 'Tablet'
ORDER BY 
    CASE 
        WHEN model LIKE '%Pro%' THEN 1
        WHEN model LIKE '%Air%' THEN 2
        ELSE 3
    END,
    model;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    tablet_count INTEGER;
    accessory_count INTEGER;
    ipad_pro_count INTEGER;
    ipad_air_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO tablet_count FROM assets WHERE category = 'Tablet';
    SELECT COUNT(*) INTO accessory_count FROM assets WHERE category = 'Accessory' AND (model LIKE '%iPad%' OR model LIKE '%Apple Pencil%');
    SELECT COUNT(*) INTO ipad_pro_count FROM assets WHERE category = 'Tablet' AND model LIKE '%Pro%';
    SELECT COUNT(*) INTO ipad_air_count FROM assets WHERE category = 'Tablet' AND model LIKE '%Air%';

    RAISE NOTICE '✅ Tablet Import Complete!';
    RAISE NOTICE '📱 Total Tablets: %', tablet_count;
    RAISE NOTICE '🎨 Tablet Accessories: %', accessory_count;
    RAISE NOTICE '';
    RAISE NOTICE '💎 iPad Pro (M4/Professional): %', ipad_pro_count;
    RAISE NOTICE '✈️  iPad Air (5th Gen): %', ipad_air_count;
    RAISE NOTICE '';
    RAISE NOTICE '🔋 Storage Configurations:';
    RAISE NOTICE '   - 512GB iPads: %', (SELECT COUNT(*) FROM assets WHERE category = 'Tablet' AND storage = '512GB');
    RAISE NOTICE '   - 256GB iPads: %', (SELECT COUNT(*) FROM assets WHERE category = 'Tablet' AND storage = '256GB');
    RAISE NOTICE '';
    RAISE NOTICE '📍 All tablets assigned to Head Office staff';
    RAISE NOTICE '👥 Users: Varynia Wankhar (F&B), Jenny Estacio (Executive), Adina Schiopu (Executive), Joweley Cator (Spa)';
    RAISE NOTICE '';
    RAISE NOTICE '🎯 Premium Features:';
    RAISE NOTICE '   - Latest M4 chip (iPad Pro 11")';
    RAISE NOTICE '   - Cellular capability (iPad Pro 13")';
    RAISE NOTICE '   - Magic Keyboard & Apple Pencil Pro (Jenny Estacio)';
END $$;
