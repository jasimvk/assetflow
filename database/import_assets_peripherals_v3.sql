-- ============================================================================
-- IT Peripherals Import Script V3
-- AssetFlow - IT Peripherals and Accessories Inventory
-- ============================================================================
-- This script imports IT peripherals including mice, keyboard/mouse combos, cables, and adapters
-- 
-- IMPORTANT NOTES:
-- 1. Column order matches ALTER TABLE ADD COLUMN sequence (V1: 1-22, V2: 23-40)
-- 2. All condition values MUST be lowercase: 'excellent', 'good', 'fair', 'poor'
-- 3. All status values MUST be lowercase: 'active', 'in_stock', 'maintenance', 'retired'
-- 4. purchase_cost and current_value are required (use 0 if unknown)
-- 5. Uses get_department_id() helper function for department lookup
-- 6. assigned_to is TEXT field (stores employee names or department names)
-- 7. Peripherals are accessories that support primary devices
--
-- V2 SCHEMA FIELDS INCLUDED:
-- - specifications (Device specifications and features)
-- - notes (Additional information about peripherals)
--
-- PERIPHERAL TYPES:
-- - Mice: Logitech M196 (15 units), Logitech M90 (3 units)
-- - Combo Sets: Logitech MK295 wireless keyboard/mouse combo (5 units)
-- - HDMI Cables: MOWSIL 1M HDMI cables (5 units)
-- - Data Cables: Mars MCA1000 (5 units)
-- - Power Adapters: Heatz ZA34 18W adapters (4 units)
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
-- IT PERIPHERALS IMPORT
-- ============================================================================

BEGIN;

-- Delete existing peripheral assets to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Peripheral';

-- 1-15. Logitech M196 Mice (2025 Purchase)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES
('Mouse-2451SCH503P9', 'Peripheral', 'Head Office', '2451SCH503P9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH4X7B9', 'Peripheral', 'Head Office', '2451SCH4X7B9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH4YZ29', 'Peripheral', 'Head Office', '2451SCH4YZ29', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH508H9', 'Peripheral', 'Head Office', '2451SCH508H9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH50579', 'Peripheral', 'Head Office', '2451SCH50579', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH4ZPS9', 'Peripheral', 'Head Office', '2451SCH4ZPS9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH503A9', 'Peripheral', 'Head Office', '2451SCH503A9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2451SCH503S9', 'Peripheral', 'Head Office', '2451SCH503S9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SC83CTG9', 'Peripheral', 'Head Office', '2447SC83CTG9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SCG3CCX9', 'Peripheral', 'Head Office', '2447SCG3CCX9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SC83CR39', 'Peripheral', 'Head Office', '2447SC83CR39', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SC83CPT9', 'Peripheral', 'Head Office', '2447SC83CPT9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SC83CSQ9', 'Peripheral', 'Head Office', '2447SC83CSQ9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SC83CTQ9', 'Peripheral', 'Head Office', '2447SC83CTQ9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase'),
('Mouse-2447SC83CZL9', 'Peripheral', 'Head Office', '2447SC83CZL9', 'Logitech M196', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless mouse', 'New 2025 purchase');

-- 16-18. Logitech M90 Mice (Budget model)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES
('Mouse-2413HS0200B9', 'Peripheral', 'Head Office', '2413HS0200B9', 'Logitech M90', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wired USB mouse', 'Budget model - New 2025 purchase'),
('Mouse-2413HS01ZTQ9', 'Peripheral', 'Head Office', '2413HS01ZTQ9', 'Logitech M90', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wired USB mouse', 'Budget model - New 2025 purchase'),
('Mouse-2413HS01ZHJ9', 'Peripheral', 'Head Office', '2413HS01ZHJ9', 'Logitech M90', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wired USB mouse', 'Budget model - New 2025 purchase');

-- 19-23. Logitech MK295 Combo (Wireless Keyboard + Mouse)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES
('Combo-2511SYL1F0G9', 'Peripheral', 'Head Office', '2511SYL1F0G9', 'Logitech Combo MK295', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless keyboard and mouse combo', 'New 2025 purchase'),
('Combo-2511SY91EZ79', 'Peripheral', 'Head Office', '2511SY91EZ79', 'Logitech Combo MK295', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless keyboard and mouse combo', 'New 2025 purchase'),
('Combo-2511SYE1FQ89', 'Peripheral', 'Head Office', '2511SYE1FQ89', 'Logitech Combo MK295', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless keyboard and mouse combo', 'New 2025 purchase'),
('Combo-2511SYV1FQB9', 'Peripheral', 'Head Office', '2511SYV1FQB9', 'Logitech Combo MK295', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless keyboard and mouse combo', 'New 2025 purchase'),
('Combo-2511SY41EZ69', 'Peripheral', 'Head Office', '2511SY41EZ69', 'Logitech Combo MK295', 'Logitech', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'Wireless keyboard and mouse combo', 'New 2025 purchase');

-- 24-28. HDMI Cables (1 Meter)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES
('HDMI-6297001456293-1', 'Peripheral', 'Head Office', '6297001456293-1', 'MOWSIL HDMI Cable - 1M', 'MOWSIL', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '1 meter HDMI cable', 'New 2025 purchase'),
('HDMI-6297001456293-2', 'Peripheral', 'Head Office', '6297001456293-2', 'MOWSIL HDMI Cable - 1M', 'MOWSIL', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '1 meter HDMI cable', 'New 2025 purchase'),
('HDMI-6297001456293-3', 'Peripheral', 'Head Office', '6297001456293-3', 'MOWSIL HDMI Cable - 1M', 'MOWSIL', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '1 meter HDMI cable', 'New 2025 purchase'),
('HDMI-6297001456293-4', 'Peripheral', 'Head Office', '6297001456293-4', 'MOWSIL HDMI Cable - 1M', 'MOWSIL', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '1 meter HDMI cable', 'New 2025 purchase'),
('HDMI-6297001456293-5', 'Peripheral', 'Head Office', '6297001456293-5', 'MOWSIL HDMI Cable - 1M', 'MOWSIL', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '1 meter HDMI cable', 'New 2025 purchase');

-- 29-33. Data Cables (Mars MCA1000)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES
('DataCable-00sma200010-1', 'Peripheral', 'Head Office', '00sma200010-1', 'Mars MCA1000', 'Mars', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'USB data cable', 'New 2025 purchase'),
('DataCable-00sma200010-2', 'Peripheral', 'Head Office', '00sma200010-2', 'Mars MCA1000', 'Mars', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'USB data cable', 'New 2025 purchase'),
('DataCable-00sma200010-3', 'Peripheral', 'Head Office', '00sma200010-3', 'Mars MCA1000', 'Mars', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'USB data cable', 'New 2025 purchase'),
('DataCable-00sma200010-4', 'Peripheral', 'Head Office', '00sma200010-4', 'Mars MCA1000', 'Mars', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'USB data cable', 'New 2025 purchase'),
('DataCable-00sma200010-5', 'Peripheral', 'Head Office', '00sma200010-5', 'Mars MCA1000', 'Mars', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, 'USB data cable', 'New 2025 purchase');

-- 34-37. Power Adapters (Heatz ZA34 18W)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, notes
) VALUES
('Adapter-6958050600340-1', 'Peripheral', 'Head Office', '6958050600340-1', 'Heatz ZA34 Power Adapter 18W', 'Heatz', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '18W power adapter', 'New 2025 purchase'),
('Adapter-6958050600340-2', 'Peripheral', 'Head Office', '6958050600340-2', 'Heatz ZA34 Power Adapter 18W', 'Heatz', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '18W power adapter', 'New 2025 purchase'),
('Adapter-6958050600340-3', 'Peripheral', 'Head Office', '6958050600340-3', 'Heatz ZA34 Power Adapter 18W', 'Heatz', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '18W power adapter', 'New 2025 purchase'),
('Adapter-6958050600340-4', 'Peripheral', 'Head Office', '6958050600340-4', 'Heatz ZA34 Power Adapter 18W', 'Heatz', '2025-01-01', 'excellent', 'in_stock', 'IT Department', get_department_id('IT'), '2026-01-01', 0, 0, NULL, '18W power adapter', 'New 2025 purchase');

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count peripheral assets
SELECT COUNT(*) as total_peripherals FROM assets WHERE category = 'Peripheral';

-- Peripherals summary by type
SELECT 
    CASE 
        WHEN model LIKE '%Mouse%' OR model LIKE '%M196%' OR model LIKE '%M90%' THEN 'Mouse'
        WHEN model LIKE '%Combo%' OR model LIKE '%MK295%' THEN 'Keyboard/Mouse Combo'
        WHEN model LIKE '%HDMI%' THEN 'HDMI Cable'
        WHEN model LIKE '%MCA1000%' OR model LIKE '%Data Cable%' THEN 'Data Cable'
        WHEN model LIKE '%Adapter%' OR model LIKE '%ZA34%' THEN 'Power Adapter'
        ELSE 'Other'
    END as peripheral_type,
    COUNT(*) as count
FROM assets 
WHERE category = 'Peripheral'
GROUP BY peripheral_type
ORDER BY count DESC;

-- Peripherals by manufacturer
SELECT 
    manufacturer,
    COUNT(*) as count
FROM assets 
WHERE category = 'Peripheral'
GROUP BY manufacturer
ORDER BY count DESC;

-- Logitech devices breakdown
SELECT 
    model,
    COUNT(*) as count,
    CASE 
        WHEN model LIKE '%M196%' THEN 'Wireless Mouse'
        WHEN model LIKE '%M90%' THEN 'Wired Mouse (Budget)'
        WHEN model LIKE '%MK295%' THEN 'Wireless Keyboard/Mouse Combo'
        ELSE 'Other'
    END as device_type
FROM assets 
WHERE category = 'Peripheral'
  AND manufacturer = 'Logitech'
GROUP BY model
ORDER BY count DESC;

-- Cables and adapters inventory
SELECT 
    model,
    manufacturer,
    COUNT(*) as quantity,
    specifications
FROM assets 
WHERE category = 'Peripheral'
  AND (model LIKE '%Cable%' OR model LIKE '%Adapter%')
GROUP BY model, manufacturer, specifications
ORDER BY model;

-- All peripherals in stock
SELECT 
    name,
    model,
    manufacturer,
    serial_number,
    status,
    specifications
FROM assets 
WHERE category = 'Peripheral'
  AND status = 'in_stock'
ORDER BY model, serial_number;

-- Peripheral inventory summary (ready for distribution)
SELECT 
    model,
    manufacturer,
    COUNT(*) as total_quantity,
    status
FROM assets 
WHERE category = 'Peripheral'
GROUP BY model, manufacturer, status
ORDER BY model;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    total_count INTEGER;
    mice_count INTEGER;
    combo_count INTEGER;
    cable_count INTEGER;
    adapter_count INTEGER;
    logitech_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM assets WHERE category = 'Peripheral';
    SELECT COUNT(*) INTO mice_count FROM assets WHERE category = 'Peripheral' AND (model LIKE '%M196%' OR model LIKE '%M90%');
    SELECT COUNT(*) INTO combo_count FROM assets WHERE category = 'Peripheral' AND model LIKE '%MK295%';
    SELECT COUNT(*) INTO cable_count FROM assets WHERE category = 'Peripheral' AND (model LIKE '%Cable%' OR model LIKE '%HDMI%' OR model LIKE '%MCA1000%');
    SELECT COUNT(*) INTO adapter_count FROM assets WHERE category = 'Peripheral' AND model LIKE '%Adapter%';
    SELECT COUNT(*) INTO logitech_count FROM assets WHERE category = 'Peripheral' AND manufacturer = 'Logitech';

    RAISE NOTICE '✅ IT Peripherals Import Complete!';
    RAISE NOTICE '🖱️  Total Peripherals: %', total_count;
    RAISE NOTICE '';
    RAISE NOTICE '📊 By Device Type:';
    RAISE NOTICE '   - Mice: % (Logitech M196 + M90)', mice_count;
    RAISE NOTICE '   - Keyboard/Mouse Combos: % (Logitech MK295)', combo_count;
    RAISE NOTICE '   - HDMI Cables: % (MOWSIL 1M)', (SELECT COUNT(*) FROM assets WHERE category = 'Peripheral' AND model LIKE '%HDMI%');
    RAISE NOTICE '   - Data Cables: % (Mars MCA1000)', (SELECT COUNT(*) FROM assets WHERE category = 'Peripheral' AND model LIKE '%MCA1000%');
    RAISE NOTICE '   - Power Adapters: % (Heatz ZA34 18W)', adapter_count;
    RAISE NOTICE '';
    RAISE NOTICE '🏭 By Manufacturer:';
    RAISE NOTICE '   - Logitech (Mice & Combos): %', logitech_count;
    RAISE NOTICE '   - MOWSIL (HDMI Cables): %', (SELECT COUNT(*) FROM assets WHERE category = 'Peripheral' AND manufacturer = 'MOWSIL');
    RAISE NOTICE '   - Mars (Data Cables): %', (SELECT COUNT(*) FROM assets WHERE category = 'Peripheral' AND manufacturer = 'Mars');
    RAISE NOTICE '   - Heatz (Power Adapters): %', adapter_count;
    RAISE NOTICE '';
    RAISE NOTICE '📦 Status:';
    RAISE NOTICE '   - All peripherals in stock, ready for distribution';
    RAISE NOTICE '   - New 2025 purchase batch';
    RAISE NOTICE '   - Managed by IT Department';
END $$;
