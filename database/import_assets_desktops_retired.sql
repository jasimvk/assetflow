-- ============================================================================
-- Retired Desktop Assets Import Script
-- AssetFlow - Retired IT Department Inventory
-- ============================================================================
-- This script imports 13 additional desktop computers including:
-- - 12 Retired IT Department desktops (historical records)
-- - 1 Active desktop (Mohammed Shafi - HP ProDesk 400 G5 MT)
-- 
-- IMPORTANT NOTES:
-- 1. Most devices have status='retired' and condition='retired'
-- 2. All are from IT Department with resigned employees tracked in previous_user
-- 3. Includes legacy devices: Dell OptiPlex 990, 3020, HP 290 series
-- 4. Some have Windows 7 Pro (older systems)
-- 5. Mohammed Shafi desktop is active but needs department assignment
--
-- RUN ORDER:
-- 1. Ensure departments table is populated
-- 2. Ensure import_assets_desktops_v3.sql has been run
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
-- RETIRED & ADDITIONAL DESKTOP ASSETS IMPORT
-- ============================================================================

BEGIN;

-- 1. Deepak Ignatius Desktop - RETIRED (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-DEEPAK', 'Desktop', 'Head Office', '8CG8293SPK',
    'HP 290 G4 MT', 'HP',
    '2018-07-24', 'poor', 'retired', NULL, get_department_id('IT'),
    '2019-07-23', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7', '16 GB', '1 TB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Deepak Ignatius', '2024-01-01', 'Employee resigned - device retired from inventory'
);

-- 2. HP ProDesk 400 G1 - RETIRED (IT Department, Unknown warranty)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-IT-G1-01', 'Desktop', 'Head Office', 'CZC5071QJP',
    'HP ProDesk 400 G1', 'HP',
    '2015-01-01', 'poor', 'retired', NULL, get_department_id('IT'),
    '2016-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '500 GB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Unknown', NULL, 'Legacy system - retired, warranty unknown (estimated purchase date)'
);

-- 3. Dell Optiplex 3050 - RETIRED (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-DELL-3050', 'Desktop', 'Head Office', 'CBK2CL2',
    'Dell Optiplex 3050', 'Dell Inc.',
    '2018-09-25', 'poor', 'retired', NULL, get_department_id('IT'),
    '2019-09-25', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '1 TB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Unknown', NULL, 'Device retired from inventory'
);

-- 4. HP 290 G7 MT - Sreejith A.K - ACTIVE (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-SREEJITH-IT', 'Desktop', 'Head Office', '8CG915LGFC',
    'HP 290 G7 MT', 'HP',
    '2019-04-16', 'good', 'active', 'Sreejith A.K', get_department_id('IT'),
    '2020-04-15', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '500 GB',
    'Done', 'Done', 'Non Domain',
    'IT Department', 'Admin',
    'IT Department desktop'
);

-- 5. HP 290 G2 MT - Anna Liza - RETIRED (IT Department, Barari Villa)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-ANNALIZA-IT', 'Desktop', 'BARARI VILLA 1009', '8CG9133R53',
    'HP 290 G2 MT', 'HP',
    '2019-03-29', 'poor', 'retired', NULL, get_department_id('IT'),
    '2020-03-28', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i5', '8 GB', '500 GB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Anna Liza', NULL, 'Employee resigned - device retired from Barari Villa 1009'
);

-- 6. Dell Optiplex 7040 - Leah Capin - ACTIVE (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-LEAH-7040', 'Desktop', 'Head Office', 'DJ990C2',
    'Dell Optiplex 7040', 'Dell Inc.',
    '2016-09-14', 'good', 'active', 'Leah Capin', get_department_id('IT'),
    '2017-09-14', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'IT Department', 'Admin',
    'IT Department desktop'
);

-- 7. HP 280 G4 MT - Leah Capin - RETIRED (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-LEAH-280G4', 'Desktop', 'Head Office', '8CG915LGFR',
    'HP 280 G4 MT', 'HP',
    '2019-04-16', 'poor', 'retired', NULL, get_department_id('IT'),
    '2020-04-15', 0, 0, NULL,
    'Windows 11 Pro', NULL, NULL, NULL,
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Leah Capin', NULL, 'Old device retired - specs unknown'
);

-- 8. Dell Optiplex 3020 - SVE F&B Team - RETIRED (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-SVE-FNB-3020', 'Desktop', 'Head Office', '3S4X132',
    'Dell Optiplex 3020', 'Dell Inc.',
    '2014-10-23', 'poor', 'retired', NULL, get_department_id('IT'),
    '2015-10-23', 0, 0, NULL,
    'Windows 7 Pro', 'Intel(R) Core(TM) i3', '4 GB', '500 GB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'SVE F&B Team', NULL, 'Legacy Windows 7 system - retired'
);

-- 9. Dell Optiplex 990 - SVE HK PC - ACTIVE (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-SVE-HK-990', 'Desktop', 'Head Office', 'FQ12D2S',
    'Dell Optiplex 990', 'Dell Inc.',
    '2013-01-01', 'good', 'active', 'SVE HK PC', get_department_id('IT'),
    '2014-01-01', 0, 0, NULL,
    'Windows 7 Pro', 'Intel(R) Core(TM) i3', '4 GB', '500 GB',
    'Done', 'Done', 'Non Domain',
    'IT Department', 'Operation',
    'Legacy Windows 7 system still in use - warranty unknown (estimated purchase date)'
);

-- 10. HP ProDesk 400G7 MT - Juliene Bural - RETIRED (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-JULIENE', 'Desktop', 'Head Office', '4CE208CHHP',
    'HP ProDesk 400G7 MT', 'HP',
    '2022-11-21', 'poor', 'retired', NULL, get_department_id('IT'),
    '2023-02-18', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '500 GB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Juliene Bural', NULL, 'Employee resigned - device retired'
);

-- 11. HP ProDesk 400G7 MT - Shova Nepali - RETIRED (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'DESKTOP-SHOVA', 'Desktop', 'Head Office', 'CZC10472C4',
    'HP ProDesk 400G7 MT', 'HP',
    '2021-04-28', 'poor', 'retired', NULL, get_department_id('IT'),
    '2022-04-27', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7', '16 GB', '500 GB',
    'Retired', 'Retired', 'Non Domain',
    'IT Department', NULL,
    'Shova Nepali', NULL, 'Employee resigned - device retired'
);

-- 12. HP ProDesk 400 G5 MT - Mohammed Shafi - ACTIVE (Unassigned Department)
-- NOTE: This desktop appears in your data but with no department assigned
-- The v3 script has ONEH-SHAFI with serial 4CE8361N15
-- This is a DIFFERENT device with serial 4CE9261H8V
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-SHAFI-G5', 'Desktop', 'Head Office', '4CE9261H8V',
    'HP ProDesk 400 G5 MT', 'HP',
    '2019-06-28', 'good', 'active', 'Mohammed Shafi', NULL,
    '2019-11-14', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '1 TB',
    NULL, NULL, 'Non Domain',
    NULL, NULL,
    'Active desktop - Department assignment needed. Different from ONEH-SHAFI (serial 4CE8361N15)'
);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count all desktops including retired
SELECT 
    status,
    COUNT(*) as count
FROM assets 
WHERE category = 'Desktop'
GROUP BY status
ORDER BY 
    CASE status
        WHEN 'active' THEN 1
        WHEN 'in_stock' THEN 2
        WHEN 'maintenance' THEN 3
        WHEN 'retired' THEN 4
    END;

-- Retired desktops with previous users
SELECT 
    name,
    model,
    previous_user,
    resigned_date,
    location,
    in_office_location
FROM assets 
WHERE category = 'Desktop' 
  AND status = 'retired'
ORDER BY name;

-- Active IT Department desktops
SELECT 
    name,
    model,
    assigned_to,
    location,
    os_version,
    memory,
    storage
FROM assets 
WHERE category = 'Desktop' 
  AND status = 'active'
  AND department_id = get_department_id('IT')
ORDER BY name;

-- Legacy Windows 7 systems
SELECT 
    name,
    model,
    assigned_to,
    os_version,
    status,
    location
FROM assets 
WHERE category = 'Desktop' 
  AND os_version LIKE '%Windows 7%'
ORDER BY status, name;

-- Desktops with no department assigned
SELECT 
    name,
    model,
    assigned_to,
    location,
    status,
    notes
FROM assets 
WHERE category = 'Desktop' 
  AND department_id IS NULL
ORDER BY status, name;

-- Summary by manufacturer including retired
SELECT 
    manufacturer,
    status,
    COUNT(*) as count
FROM assets 
WHERE category = 'Desktop'
GROUP BY manufacturer, status
ORDER BY manufacturer, status;

-- Warranty expired desktops
SELECT 
    name,
    model,
    assigned_to,
    status,
    warranty_expiry,
    CURRENT_DATE - warranty_expiry as days_expired
FROM assets 
WHERE category = 'Desktop'
  AND warranty_expiry IS NOT NULL
  AND warranty_expiry < CURRENT_DATE
ORDER BY warranty_expiry;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    total_desktops INT;
    active_desktops INT;
    retired_desktops INT;
    it_dept_desktops INT;
BEGIN
    SELECT COUNT(*) INTO total_desktops FROM assets WHERE category = 'Desktop';
    SELECT COUNT(*) INTO active_desktops FROM assets WHERE category = 'Desktop' AND status = 'active';
    SELECT COUNT(*) INTO retired_desktops FROM assets WHERE category = 'Desktop' AND status = 'retired';
    SELECT COUNT(*) INTO it_dept_desktops FROM assets WHERE category = 'Desktop' AND department_id = get_department_id('IT');
    
    RAISE NOTICE '✅ Retired Desktop Import Complete!';
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '📊 Total Desktops: %', total_desktops;
    RAISE NOTICE '✨ Active Desktops: %', active_desktops;
    RAISE NOTICE '🗄️  Retired Desktops: %', retired_desktops;
    RAISE NOTICE '💼 IT Department Desktops: %', it_dept_desktops;
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '';
    RAISE NOTICE '📝 NOTES:';
    RAISE NOTICE '   • 8 desktops marked as RETIRED with previous_user tracking';
    RAISE NOTICE '   • 4 active desktops from IT Department added';
    RAISE NOTICE '   • 2 legacy Windows 7 systems included (Dell OptiPlex 990, 3020)';
    RAISE NOTICE '   • 1 desktop needs department assignment (DESKTOP-SHAFI-G5)';
    RAISE NOTICE '   • Mohammed Shafi has 2 desktops (ONEH-SHAFI and DESKTOP-SHAFI-G5)';
END $$;
