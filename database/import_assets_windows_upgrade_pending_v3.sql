-- ============================================================================
-- Windows Upgrade Pending Assets Import Script V3
-- AssetFlow - Windows 10/11 Upgrade Assessment Devices
-- ============================================================================
-- This script imports 24 laptops and desktops requiring Windows 11 upgrade assessment
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
-- - os_version (Windows 10 Pro, Windows 11 Home, Windows 11 Pro)
-- - cpu_type (Full processor specifications)
-- - memory (4GB, 8GB, 12GB, 16GB)
-- - domain_status (Domain vs Non Domain classification)
-- - notes (Upgrade status: "Not Upgradable", "Upgradable", "Change License", etc.)
--
-- SPECIAL NOTES:
-- - This section tracks devices needing Windows 11 upgrade assessment
-- - Status field contains upgrade eligibility: "Not Upgradable", "Upgradable", "Change License", "Onprocess"
-- - Some devices already upgraded to Windows 11 but need license changes
-- - Older processors (7th gen Intel, 4th gen Intel) not compatible with Windows 11
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
-- WINDOWS UPGRADE PENDING ASSETS IMPORT
-- ============================================================================

BEGIN;

-- Note: These devices may already exist in the main laptop/desktop imports
-- This script uses ON CONFLICT to update existing records instead of failing
-- It will update the notes field to add upgrade assessment status

-- 1. DESKTOP-ALRAKNA - HP 250 G7 Notebook (Not Upgradable)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-ALRAKNA', 'Laptop', 'Al Rakna', 'CND03624ZT',
    'HP 250 G7 Notebook PC', 'HP',
    '2020-01-01', 'good', 'active', 'HK-AL RAKNA', get_department_id('Housekeeping'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i3-1005G1 CPU @ 1.20GHz', '4GB', 'Non Domain',
    'Not Upgradable - Windows 11 Assessment Required'
)
ON CONFLICT (serial_number) DO UPDATE SET
    notes = CASE 
        WHEN assets.notes IS NULL OR assets.notes = '' THEN EXCLUDED.notes
        ELSE assets.notes || ' | ' || EXCLUDED.notes
    END,
    os_version = COALESCE(assets.os_version, EXCLUDED.os_version),
    cpu_type = COALESCE(assets.cpu_type, EXCLUDED.cpu_type),
    memory = COALESCE(assets.memory, EXCLUDED.memory);

-- 2. ONEH-SECURITY-SVE - HP ProBook 440 G6 (Not Upgradable)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-SECURITY-SVE', 'Laptop', 'Spanish Villa', '5CD9229NMV',
    'HP ProBook 440 G6', 'HP',
    '2019-01-01', 'good', 'active', 'Security - SVE', get_department_id('Security'),
    '2021-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7-8565U CPU @ 1.80GHz', '8GB', 'Non Domain',
    'Not Upgradable - Not meet minimum requirements'
);

-- 3. DESKTOP-M98OH3O - Lenovo ThinkPad E580 (Not Upgradable)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-M98OH3O', 'Laptop', 'Main Store', 'PF0Y6NKH',
    'Lenovo ThinkPad E580', 'Lenovo',
    '2019-01-01', 'good', 'active', 'Ryan Belleza', get_department_id('L&T'),
    '2021-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz', '8GB', 'Non Domain',
    'Not Upgradable - Windows 11 Assessment Required'
);

-- 4. ONEH-RASHEED - Dell XPS 15 9530 (Change License - Already Windows 11)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-RASHEED', 'Laptop', 'Spanish Villa', '626MBY3',
    'Dell XPS 15 9530', 'Dell',
    '2023-01-01', 'excellent', 'active', 'Rasheed Mohammed', get_department_id('Housekeeping'),
    '2026-01-01', 0, 0, NULL,
    'Windows 11 Home', '13th Gen Intel(R) Core(TM) i7-13700H', '16GB', 'Non Domain',
    'Change License - Upgrade Home to Pro'
);

-- 5. DESKTOP-9SE3UD1 - Kitchen Desktop (Unknown Model)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-9SE3UD1', 'Desktop', 'Muroor Kitchen', '16789414745',
    'Desktop PC', 'Generic',
    '2020-01-01', 'good', 'active', 'Dori Eltachi', get_department_id('Kitchen'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', NULL, NULL, 'Non Domain',
    'Model and specs unknown - Assessment required'
);

-- 6. DESKTOP-ALRAKNA-2 - Al Rakna Desktop (Duplicate name, different serial)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-ALRAKNA-2', 'Desktop', 'Al Rakna', 'CNDO3624ZT',
    'Desktop PC', 'Generic',
    '2020-01-01', 'good', 'active', 'Gopal Luitel', get_department_id('Housekeeping'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', NULL, NULL, 'Non Domain',
    'Model and specs unknown - Assessment required'
);

-- 7. ONEH-FEMALE-SEC - HP Laptop 15 (Not Upgradable)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-FEMALE-SEC', 'Laptop', 'Ladies Staff Accommodation', 'CND0336J4D',
    'HP Laptop 15-da2xxx', 'HP',
    '2020-01-01', 'good', 'active', 'Female Security', get_department_id('Security'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz', '4GB', 'Non Domain',
    'Not Upgradable - Insufficient RAM (4GB minimum for Win11)'
);

-- 8. Laptop-5CD0493H2B - Souria Latroch F&B (Unknown Model)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'Laptop-5CD0493H2B', 'Laptop', 'Head Office', '5CD0493H2B',
    'HP Laptop', 'HP',
    '2020-01-01', 'good', 'active', 'Souria Latroch', get_department_id('F&B'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', NULL, NULL, 'Non Domain',
    'Model and specs unknown - Assessment required'
);

-- 9. Laptop-PF44JFV5 - Shecill Manzano F&B (ThinkPad E14)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'Laptop-PF44JFV5', 'Laptop', 'Head Office', 'PF44JFV5',
    'Lenovo ThinkPad E14', 'Lenovo',
    '2020-01-01', 'good', 'active', 'Shecill Manzano', get_department_id('F&B'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', NULL, NULL, 'Non Domain',
    'Specs unknown - Assessment required'
);

-- 10. LAPTOP-HK-ALYAS - HP Laptop 15 Al Yasat
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'LAPTOP-HK-ALYAS', 'Laptop', 'Al Yasat', 'CND009294H',
    'HP Laptop 15-da2xxx', 'HP',
    '2020-01-01', 'good', 'active', 'HK-AL YASAT', get_department_id('Housekeeping'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz', '8GB', 'Non Domain',
    'To be verified - Upgrade eligibility assessment pending'
);

-- 11. ONEH-ADINA - Dell XPS 15 9520 (Change License - Already Windows 11)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-ADINA', 'Laptop', 'Head Office', '67LFTV3',
    'Dell XPS 15 9520', 'Dell',
    '2022-01-01', 'excellent', 'active', 'Adina Schiopu', get_department_id('Executive Office'),
    '2025-01-01', 0, 0, NULL,
    'Windows 11 Home', '12th Gen Intel(R) Core(TM) i7-12700H', '16GB', 'Non Domain',
    'Change License - Upgrade Home to Pro'
);

-- 12. ONEH-BABU - Dell XPS 15 9520 (Change License - Already Windows 11)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-BABU', 'Laptop', 'Head Office', 'IT9GTV3',
    'Dell XPS 15 9520', 'Dell',
    '2022-01-01', 'excellent', 'active', 'Babu Mohamed', get_department_id('Technical Coordinator'),
    '2025-01-01', 0, 0, NULL,
    'Windows 11 Home', '12th Gen Intel(R) Core(TM) i7-12700H', '16GB', 'Non Domain',
    'Change License - Upgrade Home to Pro'
);

-- 13. ONEH-OSHBAH - HP ProBook 450 G5 (Old Stock)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-OSHBAH', 'Laptop', 'Head Office', '5CD815723K',
    'HP ProBook 450 G5', 'HP',
    '2018-01-01', 'good', 'in_stock', 'Old - Stock', get_department_id('IT'),
    '2020-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz', '8GB', 'Non Domain',
    'Old Stock - Assessment required before redeployment'
);

-- 14. ONEH-ASHOK - Lenovo ThinkPad E580 Laundry
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-ASHOK', 'Laptop', 'Spanish Villa', 'PF0Y6NH7',
    'Lenovo ThinkPad E580', 'Lenovo',
    '2019-01-01', 'good', 'active', 'Ashok', get_department_id('Laundry'),
    '2021-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz', '8GB', 'Non Domain',
    'Assessment required'
);

-- 15. ONEH-FARAH - Finance Desktop (Upgradable)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'ONEH-FARAH', 'Desktop', 'Head Office', '4CE142B9RK',
    'Desktop PC', 'Generic',
    '2020-01-01', 'good', 'active', 'Farah Hammami', get_department_id('Finance'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', NULL, NULL, 'Non Domain',
    'Upgradable - Ready for Windows 11'
);

-- 16. DESKTOP-Security Gate HO - HP 290 G4 Microtower (On Process)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-Security-Gate-HO', 'Desktop', 'Muroor Kitchen', '4CE124X5F0',
    'HP 290 G4 Microtower PC', 'HP',
    '2020-01-01', 'good', 'active', 'Rohit', get_department_id('Security'),
    '2023-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8GB', 'Non Domain',
    'Onprocess - Upgrade in progress'
);

-- 17. DESKTOP-ALRAKNA-HP290 - HP 290 G4 Al Rakna
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-ALRAKNA-HP290', 'Desktop', 'Al Rakna', '4CE124X56D',
    'HP 290 G4 Microtower PC', 'HP',
    '2020-01-01', 'good', 'active', 'ALRAKNA', get_department_id('Housekeeping'),
    '2023-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8GB', 'Non Domain',
    'Assessment required'
);

-- 18. DESKTOP-ILDS3T1 - HP 290 G4 Al Rawda
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-ILDS3T1', 'Desktop', 'Al Rowda', '4CE124X57G',
    'HP 290 G4 Microtower PC', 'HP',
    '2020-01-01', 'good', 'active', 'AL RAWDA VILLA', get_department_id('Housekeeping'),
    '2023-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8GB', 'Non Domain',
    'Assessment required'
);

-- 19. Desktop-4CE9091SJC - White Villa Desktop
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'Desktop-4CE9091SJC', 'Desktop', 'White Villa', '4CE9091SJC',
    'Desktop PC', 'Generic',
    '2020-01-01', 'good', 'active', 'Leah Capin', get_department_id('Housekeeping'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', NULL, NULL, 'Non Domain',
    'Model and specs unknown - Assessment required'
);

-- 20. SVE-HK-EXTERIOR - Dell OptiPlex 7050 (Not Upgradable - 7th Gen)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'SVE-HK-EXTERIOR', 'Desktop', 'Spanish Villa', 'G3P9TJ2',
    'Dell OptiPlex 7050', 'Dell',
    '2017-01-01', 'good', 'active', 'SVE Manager PC', get_department_id('Housekeeping'),
    '2020-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz', '12GB', 'Non Domain',
    'Not Upgradable - Processor not supported windows 11 (7th Gen Intel)'
);

-- 21. DESKTOP-ANNALIZA - HP 290 G2 MT Barari Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-ANNALIZA', 'Desktop', 'Barari Villa 1504', '8CG915BY3Q',
    'HP 290 G2 MT Business PC', 'HP',
    '2018-01-01', 'good', 'active', 'Anna Liza Arresgado', get_department_id('Housekeeping'),
    '2021-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-8400 CPU @ 2.80GHz', '8GB', 'Non Domain',
    'Assessment required'
);

-- 22. DESKTOP-ANSAR - HP ProDesk 400 G1 (Not Upgradable - 4th Gen)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'DESKTOP-ANSAR', 'Desktop', 'Main Office', 'CZC4393PXN',
    'HP ProDesk 400 G1 SFF', 'HP',
    '2014-01-01', 'fair', 'active', 'Ansar', get_department_id('Store'),
    '2017-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-4570 CPU @ 3.20GHz', '8GB', 'Non Domain',
    'Not Upgradable - Very old hardware (4th Gen Intel, 2014)'
);

-- 23. LAPTOP-SVE-HKE - HP Laptop 15 Spanish Villa (Not Upgradable)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, domain_status, notes
) VALUES (
    'LAPTOP-SVE-HKE', 'Laptop', 'Spanish Villa', 'CND009296N',
    'HP Laptop 15-da2xxx', 'HP',
    '2020-01-01', 'good', 'active', 'LAPTOP-SVE-HKE', get_department_id('Housekeeping'),
    '2022-01-01', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz', '8GB', 'Non Domain',
    'Not Upgradable - Not meet minimum requirements'
);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count Windows upgrade pending assets
SELECT COUNT(*) as total_upgrade_pending FROM assets WHERE notes LIKE '%Upgradable%' OR notes LIKE '%Change License%';

-- Summary by upgrade status
SELECT 
    CASE 
        WHEN notes LIKE '%Not Upgradable%' THEN 'Not Upgradable'
        WHEN notes LIKE '%Upgradable%' THEN 'Upgradable'
        WHEN notes LIKE '%Change License%' THEN 'License Change Required'
        WHEN notes LIKE '%Onprocess%' THEN 'Upgrade In Progress'
        ELSE 'Assessment Required'
    END as upgrade_status,
    COUNT(*) as count
FROM assets 
WHERE notes LIKE '%Upgradable%' 
   OR notes LIKE '%Change License%' 
   OR notes LIKE '%Assessment%'
   OR notes LIKE '%Onprocess%'
GROUP BY upgrade_status
ORDER BY count DESC;

-- Windows 10 vs Windows 11 devices needing attention
SELECT 
    os_version,
    COUNT(*) as count
FROM assets 
WHERE notes LIKE '%Upgradable%' 
   OR notes LIKE '%Change License%' 
   OR notes LIKE '%Assessment%'
GROUP BY os_version
ORDER BY count DESC;

-- Devices by manufacturer needing upgrade assessment
SELECT 
    manufacturer,
    COUNT(*) as count
FROM assets 
WHERE notes LIKE '%Upgradable%' 
   OR notes LIKE '%Change License%' 
   OR notes LIKE '%Assessment%'
GROUP BY manufacturer
ORDER BY count DESC;

-- Not upgradable devices (need replacement planning)
SELECT 
    name,
    model,
    cpu_type,
    memory,
    assigned_to,
    location,
    notes
FROM assets 
WHERE notes LIKE '%Not Upgradable%'
ORDER BY manufacturer, model;

-- Devices needing license changes (already Windows 11)
SELECT 
    name,
    model,
    os_version,
    assigned_to,
    location,
    notes
FROM assets 
WHERE notes LIKE '%Change License%'
ORDER BY assigned_to;

-- Old devices by purchase date (replacement candidates)
SELECT 
    name,
    model,
    purchase_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, purchase_date)) as age_years,
    assigned_to,
    location,
    notes
FROM assets 
WHERE notes LIKE '%Upgradable%' 
   OR notes LIKE '%Assessment%'
ORDER BY purchase_date ASC
LIMIT 10;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    total_count INTEGER;
    not_upgradable INTEGER;
    upgradable INTEGER;
    license_change INTEGER;
    win10_count INTEGER;
    win11_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count 
    FROM assets 
    WHERE notes LIKE '%Upgradable%' 
       OR notes LIKE '%Change License%' 
       OR notes LIKE '%Assessment%'
       OR notes LIKE '%Onprocess%';
    
    SELECT COUNT(*) INTO not_upgradable 
    FROM assets 
    WHERE notes LIKE '%Not Upgradable%';
    
    SELECT COUNT(*) INTO upgradable 
    FROM assets 
    WHERE notes LIKE '%Upgradable%' 
      AND notes NOT LIKE '%Not Upgradable%';
    
    SELECT COUNT(*) INTO license_change 
    FROM assets 
    WHERE notes LIKE '%Change License%';
    
    SELECT COUNT(*) INTO win10_count 
    FROM assets 
    WHERE os_version LIKE '%Windows 10%' 
      AND (notes LIKE '%Upgradable%' 
       OR notes LIKE '%Assessment%');
    
    SELECT COUNT(*) INTO win11_count 
    FROM assets 
    WHERE os_version LIKE '%Windows 11%' 
      AND notes LIKE '%Change License%';

    RAISE NOTICE '✅ Windows Upgrade Assessment Import Complete!';
    RAISE NOTICE '💻 Total Devices Needing Attention: %', total_count;
    RAISE NOTICE '❌ Not Upgradable (Replacement Needed): %', not_upgradable;
    RAISE NOTICE '✅ Upgradable (Can Install Windows 11): %', upgradable;
    RAISE NOTICE '🔑 License Change Required (Already Windows 11): %', license_change;
    RAISE NOTICE '🪟 Windows 10 Devices: %', win10_count;
    RAISE NOTICE '🪟 Windows 11 Devices (License Issue): %', win11_count;
    RAISE NOTICE '';
    RAISE NOTICE '📋 Key Actions Required:';
    RAISE NOTICE '   1. Replace % devices with incompatible hardware', not_upgradable;
    RAISE NOTICE '   2. Upgrade % devices to Windows 11 Pro', upgradable;
    RAISE NOTICE '   3. Change license for % Dell XPS devices from Home to Pro', license_change;
    RAISE NOTICE '   4. Complete assessment for devices with unknown specs';
END $$;
