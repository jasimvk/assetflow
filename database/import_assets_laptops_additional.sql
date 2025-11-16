-- ============================================================================
-- Additional Laptop Assets Import Script
-- AssetFlow - Laptop Inventory (Active & Resigned)
-- ============================================================================
-- This script imports 7 additional laptop computers including:
-- - 2 Retired laptops (Emily Smith, Retired IT)
-- - 1 Laptop with resigned user (Rubin Thomas)
-- - 4 Active laptops (M1 Security, IT Admin, Housekeeping, Al Rakna)
-- 
-- IMPORTANT NOTES:
-- 1. Retired laptops have status='retired' and condition='poor'
-- 2. Resigned users tracked in previous_user field
-- 3. Mixed vendors: Lenovo ThinkPad, HP, Dell Inspiron
-- 4. Some have unclear department assignments (to be verified)
-- 5. Active laptops assigned to various departments
--
-- RUN ORDER:
-- 1. Ensure departments table is populated
-- 2. Ensure locations table is populated
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
-- ADDITIONAL LAPTOP ASSETS IMPORT
-- ============================================================================

BEGIN;

-- 1. Lenovo ThinkPad E16 Gen1 - Emily Smith - RETIRED (Not 1H department)
-- NOTE: "Not 1H" suggests this was not from main organization, possibly external/temporary
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'LAPTOP-EMILY-E16', 'Laptop', 'M1', 'PF4HWA6S',
    'LENOVO THINKPAD E16 GEN1', 'Lenovo',
    '2024-01-01', 'poor', 'retired', NULL, NULL,
    '2025-01-01', 0, 0, '1H-00142',
    NULL, '13th Gen Intel(R) Core(TM) i7-1355U', '16 GB', '512 GB',
    NULL, NULL, NULL,
    NULL, NULL,
    'Emily Smith', NULL, 'External assignment - Not 1H organization. Device retired.'
);

-- 2. HP Notebook 15 (DESKTOP-4L0TNA2) - M1 Security - ACTIVE (Security Department)
-- NOTE: Named as DESKTOP but it's actually a laptop/notebook
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-4L0TNA2', 'Laptop', 'M1', 'CND92204RS',
    'HP Notebook 15', 'HP',
    '2023-04-30', 'good', 'active', 'Rodrigo Cabias', get_department_id('Security'),
    '2024-04-29', 0, 0, NULL,
    NULL, 'Intel(R) Core(TM) i5-8265U CPU @ 1.60GHz', '8 GB', NULL,
    'Done', 'Done', 'Non Domain',
    'To be verified', 'Operation',
    'M1 Security laptop - Location to be verified'
);

-- 3. HP ENVY x360 - RETIRED (IT Department)
-- NOTE: No assigned user, just marked as "Retired" department
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'LAPTOP-ENVY-X360', 'Laptop', 'Head Office', 'CND1352D4X',
    'HP ENVY x360', 'HP',
    '2022-01-14', 'poor', 'retired', NULL, get_department_id('IT'),
    '2025-01-13', 0, 0, '1H-00023',
    NULL, 'Intel(R) Core(TM) i7', '8 GB', '1 TB',
    NULL, NULL, 'Non Domain',
    'IT', NULL,
    'Retired', NULL, 'Device retired from IT department'
);

-- 4. Dell Inspiron 5558 - Rubin Thomas - RETIRED (IT Department)
-- NOTE: Assigned to Rubin Thomas but marked as retired
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'LAPTOP-DELL-5558', 'Laptop', 'Head Office', 'GD9QY52',
    'Dell Inspiron 5558', 'Dell Inc.',
    '2015-09-12', 'poor', 'retired', NULL, get_department_id('IT'),
    '2016-09-11', 0, 0, '1H-00125',
    NULL, 'Intel(R) Core(TM) i7', '8 GB', '500 GB',
    NULL, NULL, 'Non Domain',
    'IT', NULL,
    'Rubin Thomas', NULL, 'Employee resigned - device retired from IT'
);

-- 5. IT-Admin (Lenovo ThinkPad T570) - Gobinda - ACTIVE (IT Department)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'IT-Admin', 'Laptop', 'Main Office', 'R90NMD78',
    'Lenovo ThinkPad T570', 'Lenovo',
    '2017-07-22', 'good', 'active', 'Gobinda', get_department_id('IT'),
    '2020-01-10', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz', '8 GB', NULL,
    'Done', 'Done', 'Domain',
    'Server Room', 'Admin',
    'IT Admin laptop - Server Room'
);

-- 6. Lenovo ThinkPad E15 Gen2 - Leah Capin - ACTIVE (Housekeeping)
-- NOTE: Previously used by Katrina Dela Cruz (resigned)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    previous_user, resigned_date, resignation_notes
) VALUES (
    'LAPTOP-LEAH-E15', 'Laptop', 'WHITE VILLA', 'PF3FFN1K',
    'Lenovo ThinkPad E15 Gen2', 'Lenovo',
    '2025-04-01', 'good', 'active', 'Leah Capin', get_department_id('Housekeeping'),
    '2025-08-01', 0, 0, '1H-00044',
    'Windows 10 Pro', 'Intel(R) Core(TM) i5', '8 GB', '500 GB',
    'Pending', 'Pending', 'Non Domain',
    'Spanish Villa', 'Operation',
    'Katrina Dela Cruz', NULL, 'Previous user resigned - reassigned to Leah Capin'
);

-- 7. HP 250 G7 Notebook (DESKTOP-ALRAKNA) - HK-AL RAKNA - ACTIVE (Housekeeping)
-- NOTE: Named as DESKTOP but it's a notebook/laptop
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-ALRAKNA', 'Laptop', 'AL RAKHNA VILLA', 'CND03624ZT',
    'HP 250 G7 Notebook PC', 'HP',
    '2020-09-08', 'good', 'active', 'HK-AL RAKNA', get_department_id('Housekeeping'),
    '2021-10-07', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i3-1005G1 CPU @ 1.20GHz', '4 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'Al Rakna', 'Operation',
    'Housekeeping laptop at Al Rakna Villa'
);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count all laptops including retired
SELECT 
    status,
    COUNT(*) as count
FROM assets 
WHERE category = 'Laptop'
GROUP BY status
ORDER BY 
    CASE status
        WHEN 'active' THEN 1
        WHEN 'in_stock' THEN 2
        WHEN 'maintenance' THEN 3
        WHEN 'retired' THEN 4
    END;

-- Retired laptops with previous users
SELECT 
    name,
    model,
    previous_user,
    resigned_date,
    location,
    asset_code,
    resignation_notes
FROM assets 
WHERE category = 'Laptop' 
  AND status = 'retired'
ORDER BY name;

-- Active laptops by department
SELECT 
    d.name as department,
    COUNT(*) as laptop_count,
    STRING_AGG(a.assigned_to, ', ') as users
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Laptop' 
  AND a.status = 'active'
GROUP BY d.name
ORDER BY laptop_count DESC;

-- Laptops with previous users (resigned/reassigned)
SELECT 
    name,
    model,
    assigned_to as current_user,
    previous_user,
    location,
    in_office_location,
    resignation_notes
FROM assets 
WHERE category = 'Laptop' 
  AND previous_user IS NOT NULL
ORDER BY name;

-- Laptops without department assignment
SELECT 
    name,
    model,
    assigned_to,
    location,
    status,
    asset_code
FROM assets 
WHERE category = 'Laptop' 
  AND department_id IS NULL
ORDER BY status, name;

-- Summary by manufacturer
SELECT 
    manufacturer,
    status,
    COUNT(*) as count
FROM assets 
WHERE category = 'Laptop'
GROUP BY manufacturer, status
ORDER BY manufacturer, status;

-- Laptops by location
SELECT 
    location,
    in_office_location,
    COUNT(*) as count,
    STRING_AGG(assigned_to, ', ') as users
FROM assets 
WHERE category = 'Laptop'
  AND status = 'active'
GROUP BY location, in_office_location
ORDER BY count DESC;

-- Security and Admin status summary
SELECT 
    sentinel_status,
    ninja_status,
    domain_status,
    COUNT(*) as count
FROM assets 
WHERE category = 'Laptop'
GROUP BY sentinel_status, ninja_status, domain_status
ORDER BY count DESC;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    total_laptops INT;
    active_laptops INT;
    retired_laptops INT;
    with_previous_user INT;
BEGIN
    SELECT COUNT(*) INTO total_laptops FROM assets WHERE category = 'Laptop';
    SELECT COUNT(*) INTO active_laptops FROM assets WHERE category = 'Laptop' AND status = 'active';
    SELECT COUNT(*) INTO retired_laptops FROM assets WHERE category = 'Laptop' AND status = 'retired';
    SELECT COUNT(*) INTO with_previous_user FROM assets WHERE category = 'Laptop' AND previous_user IS NOT NULL;
    
    RAISE NOTICE '✅ Additional Laptop Import Complete!';
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '📊 Total Laptops: %', total_laptops;
    RAISE NOTICE '✨ Active Laptops: %', active_laptops;
    RAISE NOTICE '🗄️  Retired Laptops: %', retired_laptops;
    RAISE NOTICE '👥 Laptops with Previous User: %', with_previous_user;
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '';
    RAISE NOTICE '📝 NOTES:';
    RAISE NOTICE '   • 3 laptops marked as RETIRED with previous_user tracking';
    RAISE NOTICE '   • 4 active laptops from Security, IT, and Housekeeping';
    RAISE NOTICE '   • 1 laptop reassigned (Katrina → Leah Capin)';
    RAISE NOTICE '   • 1 laptop from external org (Emily Smith - Not 1H)';
    RAISE NOTICE '   • 2 devices named DESKTOP but categorized as Laptop';
    RAISE NOTICE '   • Vendors: Lenovo (3), HP (3), Dell (1)';
END $$;
