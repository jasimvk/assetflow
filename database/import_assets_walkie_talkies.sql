-- ============================================================================
-- Walkie Talkie Assets Import Script
-- AssetFlow - Communication Equipment Inventory
-- ============================================================================
-- This script imports 16 Motorola walkie talkie units including:
-- - 3 Resigned users (Angela Agnas, Anxhela Kita, Olivia Svetlana)
-- - 13 Active units assigned to various staff
-- 
-- IMPORTANT NOTES:
-- 1. Category: 'Walkie Talkie' (Communication Equipment)
-- 2. Manufacturer: Motorola (all units)
-- 3. Models: SL1600e, SL400e, SL4000e, SL1600
-- 4. Most include earpieces, some with chargers
-- 5. Resigned users tracked in previous_user field
-- 6. Purchase dates from Nov 2022 to Mar 2025
-- 7. Some have issue_date tracking (Amber Leigh, Annette Maka, Vasylysa Korobeinikova)
--
-- RUN ORDER:
-- 1. Ensure departments table is populated
-- 2. Ensure categories table includes 'Walkie Talkie'
-- 3. Run this script
-- ============================================================================

-- Helper function (reuse if needed)
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
-- WALKIE TALKIE ASSETS IMPORT
-- ============================================================================

BEGIN;

-- 1. Motorola SL1600e - Ekatenino Shinia - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    issue_date, notes
) VALUES (
    'WT-546TSH0908', 'Walkie Talkie', 'Head Office', '546TSH0908',
    'Motorola SL1600e', 'Motorola',
    '2022-11-23', 'good', 'active', 'Ekatenino Shinia', NULL,
    '2023-11-23', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    '2022-11-23', 'Walkie Talkie W/ earpiece - Issued by Amber Leigh'
);

-- 2. Motorola SL1600e - Famaele Nica - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-546TTK2904', 'Walkie Talkie', 'Head Office', '546TTK2904',
    'Motorola SL1600e', 'Motorola',
    '2022-11-23', 'good', 'active', 'Famaele Nica', NULL,
    '2023-11-23', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie W/ earpiece'
);

-- 3. Motorola SL1600e - Khalikova Violetta - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    issue_date, notes
) VALUES (
    'WT-546TTK2917', 'Walkie Talkie', 'Head Office', '546TTK2917',
    'Motorola SL1600e', 'Motorola',
    '2022-11-23', 'good', 'active', 'Khalikova Violetta', NULL,
    '2023-11-23', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    '2022-11-23', 'Walkie Talkie W/ earpiece - Issued by Amber Leigh'
);

-- 4. Motorola SL1600e - Sofia Romanenko - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-546TSH1413', 'Walkie Talkie', 'Head Office', '546TSH1413',
    'Motorola SL1600e', 'Motorola',
    '2022-11-23', 'good', 'active', 'Sofia Romanenko', NULL,
    '2023-11-23', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie W/ earpiece'
);

-- 5. Motorola SL400e - Vitaliia Zanudina - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-682TKS0755', 'Walkie Talkie', 'Head Office', '682TKS0755',
    'Motorola SL400e', 'Motorola',
    '2023-01-30', 'good', 'active', 'Vitaliia Zanudina', NULL,
    '2024-01-30', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie'
);

-- 6. Motorola SL400e - Evghenia Ginju - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-682TMS2254', 'Walkie Talkie', 'Head Office', '682TMS2254',
    'Motorola SL400e', 'Motorola',
    '2023-01-31', 'good', 'active', 'Evghenia Ginju', NULL,
    '2024-01-31', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie'
);

-- 7. Motorola SL4000e - Dene Lemmer - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-682TTT0571', 'Walkie Talkie', 'Head Office', '682TTT0571',
    'Motorola SL4000e', 'Motorola',
    '2023-06-16', 'good', 'active', 'Dene Lemmer', NULL,
    '2024-06-16', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie'
);

-- 8. Motorola SL4000e - Gulshan Durusbekova - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-682TVBD1732', 'Walkie Talkie', 'Head Office', '682TVBD1732',
    'Motorola SL4000e', 'Motorola',
    '2023-09-11', 'good', 'active', 'Gulshan Durusbekova', NULL,
    '2024-09-11', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie'
);

-- 9. Motorola SL1600e - Dewan Reza - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-546THS1052', 'Walkie Talkie', 'Head Office', '546THS1052',
    'Motorola SL1600e', 'Motorola',
    '2024-02-28', 'good', 'active', 'Dewan Reza', NULL,
    '2025-02-28', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie'
);

-- 10. Motorola SL400e - Shrijana Sherpa - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-682TVD1525', 'Walkie Talkie', 'Head Office', '682TVD1525',
    'Motorola SL400e', 'Motorola',
    '2024-05-16', 'good', 'active', 'Shrijana Sherpa', NULL,
    '2025-05-16', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie W/ earpiece'
);

-- 11. Motorola SL4000e - Violetta Khalikova - ACTIVE (F&B)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    issue_date, notes
) VALUES (
    'WT-682TVB0698', 'Walkie Talkie', 'Head Office', '682TVB0698',
    'Motorola SL4000e', 'Motorola',
    '2024-05-24', 'good', 'active', 'Violetta Khalikova', get_department_id('F&B'),
    '2025-05-24', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    '2023-11-01', 'Walkie Talkie W/ earpiece - Issued by Annette Maka'
);

-- 12. Motorola SL1600 - Angela Agnas - RESIGNED (Housekeeping)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'WT-682TVB0639', 'Walkie Talkie', 'Head Office', '682TVB0639',
    'Motorola SL1600', 'Motorola',
    '2024-06-12', 'good', 'in_stock', NULL, get_department_id('Housekeeping'),
    '2025-06-12', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Angela Agnas', '2024-06-12', 'Employee resigned - Walkie Talkie returned to stock'
);

-- 13. Motorola SL1600 - Michelle Cruz - ACTIVE (Housekeeping)
-- NOTE: Previously issued to Vasylysa Korobeinikova
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    issue_date, previous_user, notes
) VALUES (
    'WT-546TSF4054', 'Walkie Talkie', 'Head Office', '546TSF4054',
    'Motorola SL1600', 'Motorola',
    '2024-06-12', 'good', 'active', 'Michelle Cruz', get_department_id('Housekeeping'),
    '2025-06-12', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    '2022-11-23', 'Vasylysa Korobeinikova', 'Walkie Talkie - Previously issued to Vasylysa Korobeinikova, reassigned to Michelle Cruz'
);

-- 14. Motorola SL4000e - Anxhela Kita - RESIGNED (F&B)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'WT-682TVD0657', 'Walkie Talkie', 'Head Office', '682TVD0657',
    'Motorola SL4000e', 'Motorola',
    '2024-06-24', 'good', 'in_stock', NULL, get_department_id('F&B'),
    '2025-06-24', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Anxhela Kita', '2024-06-24', 'Employee resigned - Walkie Talkie w/ Earpiece and Charger returned to stock'
);

-- 15. Motorola SL400e - Sheila Malihan - ACTIVE
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'WT-682TVB0767', 'Walkie Talkie', 'Head Office', '682TVB0767',
    'Motorola SL400e', 'Motorola',
    '2024-07-02', 'good', 'active', 'Sheila Malihan', NULL,
    '2025-07-02', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Walkie Talkie W/ earpiece and charger'
);

-- 16. Motorola SL4000e - Olivia Svetlana - RESIGNED (F&B)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'WT-682TST0445', 'Walkie Talkie', 'Head Office', '682TST0445',
    'Motorola SL4000e', 'Motorola',
    '2025-03-27', 'good', 'in_stock', NULL, get_department_id('F&B'),
    '2026-03-27', 0, 0, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, 'Operation',
    'Olivia Svetlana', '2025-03-27', 'Employee resigned - Walkie Talkie W/ earpiece returned to stock'
);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count walkie talkies by status
SELECT 
    a.status,
    COUNT(*) as count
FROM assets a
WHERE a.category = 'Walkie Talkie'
GROUP BY a.status
ORDER BY 
    CASE a.status
        WHEN 'active' THEN 1
        WHEN 'in_stock' THEN 2
        WHEN 'maintenance' THEN 3
        WHEN 'retired' THEN 4
    END;

-- Resigned users - Walkie Talkies returned to stock
SELECT 
    a.name,
    a.model,
    a.previous_user,
    a.resigned_date,
    a.department_id,
    a.resignation_notes
FROM assets a
WHERE a.category = 'Walkie Talkie' 
  AND a.status = 'in_stock'
  AND a.previous_user IS NOT NULL
ORDER BY a.resigned_date DESC;

-- Active walkie talkies by user
SELECT 
    a.name,
    a.model,
    a.assigned_to,
    d.name as department,
    a.purchase_date,
    a.notes
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Walkie Talkie' 
  AND a.status = 'active'
ORDER BY a.assigned_to;

-- Walkie talkies by model
SELECT 
    a.model,
    a.status,
    COUNT(*) as count
FROM assets a
WHERE a.category = 'Walkie Talkie'
GROUP BY a.model, a.status
ORDER BY a.model, a.status;

-- Walkie talkies by department
SELECT 
    COALESCE(d.name, 'Unassigned') as department,
    COUNT(*) as count,
    STRING_AGG(a.assigned_to, ', ') as users
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Walkie Talkie'
  AND a.status = 'active'
GROUP BY d.name
ORDER BY COUNT(*) DESC;

-- Walkie talkies with issue tracking
SELECT 
    a.name,
    a.assigned_to,
    a.issue_date,
    SUBSTRING(a.notes FROM 'Issued by ([^-]+)') as issued_by
FROM assets a
WHERE a.category = 'Walkie Talkie'
  AND a.issue_date IS NOT NULL
ORDER BY a.issue_date DESC;

-- Accessories summary (with earpiece/charger)
SELECT 
    CASE 
        WHEN a.notes LIKE '%earpiece and charger%' THEN 'Earpiece + Charger'
        WHEN a.notes LIKE '%earpiece%' OR a.notes LIKE '%Earpiece%' THEN 'Earpiece Only'
        ELSE 'No Accessories'
    END as accessories,
    COUNT(*) as count
FROM assets a
WHERE a.category = 'Walkie Talkie'
GROUP BY 
    CASE 
        WHEN a.notes LIKE '%earpiece and charger%' THEN 'Earpiece + Charger'
        WHEN a.notes LIKE '%earpiece%' OR a.notes LIKE '%Earpiece%' THEN 'Earpiece Only'
        ELSE 'No Accessories'
    END
ORDER BY COUNT(*) DESC;

-- Warranty status
SELECT 
    a.name,
    a.assigned_to,
    a.warranty_expiry,
    CASE 
        WHEN a.warranty_expiry > CURRENT_DATE THEN 'Active'
        WHEN a.warranty_expiry <= CURRENT_DATE THEN 'Expired'
        ELSE 'Unknown'
    END as warranty_status,
    a.warranty_expiry - CURRENT_DATE as days_remaining
FROM assets a
WHERE a.category = 'Walkie Talkie'
  AND a.status = 'active'
ORDER BY a.warranty_expiry;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    total_walkies INT;
    active_walkies INT;
    in_stock_walkies INT;
    resigned_users INT;
BEGIN
    SELECT COUNT(*) INTO total_walkies FROM assets WHERE category = 'Walkie Talkie';
    SELECT COUNT(*) INTO active_walkies FROM assets WHERE category = 'Walkie Talkie' AND status = 'active';
    SELECT COUNT(*) INTO in_stock_walkies FROM assets WHERE category = 'Walkie Talkie' AND status = 'in_stock';
    SELECT COUNT(*) INTO resigned_users FROM assets WHERE category = 'Walkie Talkie' AND previous_user IS NOT NULL;
    
    RAISE NOTICE '✅ Walkie Talkie Import Complete!';
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '📻 Total Walkie Talkies: %', total_walkies;
    RAISE NOTICE '✨ Active (In Use): %', active_walkies;
    RAISE NOTICE '📦 In Stock (Available): %', in_stock_walkies;
    RAISE NOTICE '👥 With Previous User (Resigned): %', resigned_users;
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '';
    RAISE NOTICE '📝 INVENTORY SUMMARY:';
    RAISE NOTICE '   • Motorola SL1600e: 5 units';
    RAISE NOTICE '   • Motorola SL400e: 5 units';
    RAISE NOTICE '   • Motorola SL4000e: 5 units';
    RAISE NOTICE '   • Motorola SL1600: 1 unit';
    RAISE NOTICE '';
    RAISE NOTICE '📋 RESIGNATION TRACKING:';
    RAISE NOTICE '   • Angela Agnas (Housekeeping) - Resigned';
    RAISE NOTICE '   • Anxhela Kita (F&B) - Resigned';
    RAISE NOTICE '   • Olivia Svetlana (F&B) - Resigned';
    RAISE NOTICE '   • Michelle Cruz - Reassigned from Vasylysa Korobeinikova';
    RAISE NOTICE '';
    RAISE NOTICE '🎯 ACCESSORIES:';
    RAISE NOTICE '   • Most units include earpieces';
    RAISE NOTICE '   • Some include chargers';
    RAISE NOTICE '   • Issue dates tracked for 4 units';
END $$;
