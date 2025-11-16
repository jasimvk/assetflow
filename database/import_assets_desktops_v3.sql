-- ============================================================================
-- Desktop Assets Import Script V3
-- AssetFlow - Complete Desktop Inventory
-- ============================================================================
-- This script imports 34 desktop computers with full V2 schema support
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
-- - os_version, cpu_type, memory, storage (Technical specs)
-- - sentinel_status, ninja_status, domain_status (Security/Domain tracking)
-- - in_office_location (Specific office location)
-- - function (Admin/Operation classification)
-- - issue_date (Date issued to user)
-- - notes (Additional information)
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
-- DESKTOP ASSETS IMPORT
-- ============================================================================

BEGIN;

-- Delete existing desktop assets to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Desktop';

-- 1. ONEH-RANJEET - Finance Document Control
INSERT INTO assets (
    -- V1 Core Fields (positions 1-22)
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    -- V2 Extended Fields (positions 23-40)
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function,
    notes
) VALUES (
    'ONEH-RANJEET', 'Desktop', 'Head Office', '4CE323CR0Q', 
    'HP Pro Tower 290 G9 Desktop PC', 'HP',
    '2023-10-19', 'good', 'active', 'Ranjeet Yadav', get_department_id('Finance'),
    '2025-10-18', 0, 0, NULL,
    'Windows 11 Pro', '12th Gen Intel(R) Core(TM) i5-12400', '8 GB', '500 GB',
    'Done', 'Done', 'Domain',
    'Document Controll Office', 'Admin',
    NULL
);

-- 2. ONEH-SUNITA - Finance Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-SUNITA', 'Desktop', 'Head Office', '4CE334D27Y',
    'HP Pro Tower 290 G9 Desktop PC', 'HP',
    '2023-11-14', 'good', 'active', 'Sunita Ghale', get_department_id('Finance'),
    '2025-12-13', 0, 0, NULL,
    'Windows 11 Pro', '12th Gen Intel(R) Core(TM) i7-12700', '16 GB', '512 GB',
    'Done', 'Done', 'Domain',
    'Finance Office', 'Admin', NULL
);

-- 3. ONEH-MARIAM - Admin Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-MARIAM', 'Desktop', 'Head Office', '4CE334D25V',
    'HP Pro Tower 290 G9 Desktop PC', 'HP',
    '2023-11-15', 'good', 'active', 'Mariam Eissa Amer Abdulla Alsaadi', get_department_id('Finance'),
    '2025-12-14', 0, 0, NULL,
    'Windows 11 Pro', '12th Gen Intel(R) Core(TM) i7-12700', '16 GB', '512 GB',
    'Done', 'Done', 'Domain',
    'Admin Office', 'Admin', NULL
);

-- 4. ONEH-KLAITHEM - Admin Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-KLAITHEM', 'Desktop', 'Head Office', '4CE334D214',
    'HP Pro Tower 290 G9 Desktop PC', 'HP',
    '2023-11-14', 'good', 'active', 'Klaithem Alneyadi', get_department_id('Procurement'),
    '2025-11-13', 0, 0, NULL,
    'Windows 11 Pro', '12th Gen Intel(R) Core(TM) i7-12700', '16 GB', '512 GB',
    'Done', 'Done', 'Domain',
    'Admin Office', 'Admin', NULL
);

-- 5. ONEH-ANGELA - Finance Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-ANGELA', 'Desktop', 'Head Office', '4CE202CCMY',
    'HP ProDesk 400 G7 Microtower PC', 'HP',
    '2022-03-31', 'good', 'active', 'Angela Joy Tabuan', get_department_id('Finance'),
    '2023-03-30', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz', '16 GB', '500 GB',
    'Done', 'Done', 'Domain',
    'Finance Office', 'Admin', NULL
);

-- 6. ONEH-FARAH - Finance Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, issue_date, notes
) VALUES (
    'ONEH-FARAH', 'Desktop', 'Head Office', '4CE142B9RK',
    'HP 290 G4 Microtower PC', 'HP',
    '2021-12-29', 'good', 'active', 'Farah Hammami', get_department_id('Finance'),
    '2022-12-28', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz', '16 GB', '500 GB',
    'Done', 'Done', 'Domain',
    'Finance Office', 'Admin', NULL,
    'Mitendra Maidawat'
);

-- 7. ONEH-MAHMOOD - Admin Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-MAHMOOD', 'Desktop', 'Head Office', 'CZC1058FS0',
    'HP ProDesk 400 G7 Microtower PC', 'HP',
    '2021-02-08', 'good', 'active', 'Moahmoud Albalushi', get_department_id('HR'),
    '2022-03-09', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8 GB', '500 GB',
    'Done', 'Done', 'Domain',
    'Admin Office', 'Admin', NULL
);

-- 8. DESKTOP-GAYAN - Main Store
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-GAYAN', 'Desktop', 'MAIN STORE', 'CZC10471XX',
    'HP ProDesk 400 G7 Microtower PC', 'HP',
    '2021-02-02', 'good', 'active', 'Gayan Gamage', get_department_id('Store'),
    '2022-03-03', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz', '16 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'Main Store', 'Operation', NULL
);

-- 9. DESKTOP-LOGISTI - Main Store Kitchen
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-LOGISTI', 'Desktop', 'MAIN STORE', '4CE95127SC',
    'HP ProDesk 400 G6 MT', 'HP',
    '2020-02-27', 'good', 'active', 'Vinu George', get_department_id('Kitchen'),
    '2020-05-26', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz', '8 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    NULL, 'Operation', NULL
);

-- 10. DESKTOP-Security Gate HO - Head Office Security
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-Security Gate HO', 'Desktop', 'Head Office', '4CE124X5F0',
    'HP 290 G4 Microtower PC', 'HP',
    '2021-08-22', 'good', 'active', 'Rohit', get_department_id('Security'),
    '2023-08-21', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8 GB', '500 GB',
    'Done', 'Done', 'Non Domain',
    NULL, 'Operation', NULL
);

-- 11. DESKTOP-ALRAKNA - Al Rawda Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-ALRAKNA', 'Desktop', 'ALRAKNA', '4CE124X56D',
    'HP 290 G4 Microtower PC', 'HP',
    '2021-08-22', 'good', 'active', 'ALRAKNA', NULL,
    '2022-08-21', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8 GB', '500 GB',
    'Done', 'Done', 'Non Domain',
    'AL RAWDA VILLA', 'Operation', NULL
);

-- 12. DESKTOP-ILDS3T1 - Main Store Security
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-ILDS3T1', 'Desktop', 'MAIN STORE', '4CE124X57G',
    'HP 290 G4 Microtower PC', 'HP',
    '2021-08-22', 'good', 'active', 'Store Security', get_department_id('Security'),
    '2022-08-21', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8 GB', '500 GB',
    'Done', 'Done', 'Non Domain',
    'Main Store', 'Operation', NULL
);

-- 13. Desktop - White Villa Housekeeping
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'Desktop', 'Desktop', 'WHITE VILLA', '4CE9091SJC',
    'HP ProDesk 400 G5 Microtower PC', 'HP',
    '2019-03-19', 'good', 'active', 'Leah Capin', get_department_id('Housekeeping'),
    '2020-05-07', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-8400 CPU @ 2.80GHz', '8 GB', '1 TB',
    'Pending', 'Pending', 'Non Domain',
    NULL, 'Operation', NULL
);

-- 14. DESKTOP-SAADIYA-VILLA7 - Saadiyat Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, issue_date, notes
) VALUES (
    'DESKTOP-SAADIYA-VILLA7', 'Desktop', 'SAADIYAT VILLA 7', '4CE9261LKM',
    'HP ProDesk 400 G5 Microtower PC', 'HP',
    '2019-06-29', 'good', 'active', 'Ishani Yonili', get_department_id('Housekeeping'),
    '2019-11-15', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i5-8400 CPU @ 2.80GHz', '8 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'Saadiyat', 'Operation', NULL,
    'SVE HK Exterior'
);

-- 15. SVE-HK-EXTERIOR - Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'SVE-HK-EXTERIOR', 'Desktop', 'SPANISH VILLA', 'G3P9TJ2',
    'Dell OptiPlex 7050', 'Dell Inc.',
    '2017-12-12', 'good', 'active', 'SVE Manager PC', get_department_id('Housekeeping'),
    '2018-12-12', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz', '12 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'Spanish Villa', 'Operation', NULL
);

-- 16. ONEH-ALANOOD - Admin Office HR
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-ALANOOD', 'Desktop', 'Head Office', 'CZC1249Z9F',
    'HP ProDesk 400 G7 Microtower PC', 'HP',
    '2021-07-29', 'good', 'active', 'Alanood Alsaadi', get_department_id('HR'),
    '2022-07-28', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz', '8 GB', '500 GB',
    'Done', 'Done', 'Domain',
    'Admin Office', 'Admin', NULL
);

-- 17. ONEH-WVE-INTERI - White Villa Interior
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-WVE-INTERI', 'Desktop', 'WHITE VILLA', 'GM0N9B25',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'WVE-INTERIOR C/O Leah Capin', get_department_id('Housekeeping'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'White Villa', 'Operation', NULL
);

-- 18. ONEH-WVE-EXT - White Villa Exterior
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-WVE-EXT', 'Desktop', 'WHITE VILLA', 'GM0N9B24',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'WVE EXTERIOR C/O Shen Priyankara', get_department_id('Housekeeping'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'White Villa', 'Operation', NULL
);

-- 19. ONEH-MIJO - Procurement Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-MIJO', 'Desktop', 'Main Office', 'GM0N9B2W',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'Mijo Jose', get_department_id('Procurement'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Domain',
    'Procurement Office', 'Admin', NULL
);

-- 20. ONEH-SREEJITH - Procurement Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-SREEJITH', 'Desktop', 'Main Office', 'GM0N9B2D',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'Sreejith Achuthan', get_department_id('Procurement'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Domain',
    'Procurement Office', 'Admin', NULL
);

-- 21. DESKTOP-ANNALIZA - Al Barari Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-ANNALIZA', 'Desktop', 'BARARI VILLA 1504', '8CG915BY3Q',
    'HP 290 G2 MT Business PC', 'HP',
    '2019-04-16', 'good', 'active', 'Anna Liza Arresgado', get_department_id('Housekeeping'),
    '2020-04-15', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-8400 CPU @ 2.80GHz', '8 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'Al Barari', 'Operation', NULL
);

-- 22. DESKTOP-ANSAR - Main Store
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-ANSAR', 'Desktop', 'Store', 'CZC4393PXN',
    'HP ProDesk 400 G1 SFF', 'Hewlett-Packard',
    '2014-10-26', 'good', 'active', 'Ansar', get_department_id('Store'),
    '2015-10-26', 0, 0, NULL,
    'Windows 10 Pro', 'Intel(R) Core(TM) i5-4570 CPU @ 3.20GHz', '8 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'Main Store', 'Operation',
    'Gayan Gamage'
);

-- 23. QURAMKITCHEN - Muroor Kitchen
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'QURAMKITCHEN', 'Desktop', 'MUROOR KITCHEN', 'CZC008DFTX',
    'HP ProDesk 400 G6 MT', 'HP',
    '2020-02-26', 'good', 'active', 'Jeo George', get_department_id('Kitchen'),
    '2021-03-27', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz', '16 GB', NULL,
    'Done', 'Done', 'Non Domain',
    'Muroor Kitchen', 'Operation', NULL
);

-- 24. DESKTOP-JIO - Wathba Kitchen
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-JIO', 'Desktop', 'WATHBA KITCHEN', '4CE335BY51',
    'HP Pro Tower 290 G9 Desktop PC', 'HP',
    '2024-01-11', 'good', 'active', 'Kitchen Store', get_department_id('Kitchen'),
    '2025-10-01', 0, 0, NULL,
    'Windows 11 Pro', '12th Gen Intel(R) Core(TM) i7-12700', '16 GB', NULL,
    'Done', 'Done', 'Non Domain',
    'Muroor Kitchen', 'Operation', NULL
);

-- 25. DESKTOP-WKITCHEN - Wathba Kitchen
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-WKITCHEN', 'Desktop', 'WATHBA KITCHEN', '4CE345DKNY',
    'HP Pro SFF 290 G9 Desktop PC', 'HP',
    '2024-12-03', 'good', 'active', 'Rubin Thomas', get_department_id('Kitchen'),
    '2025-02-12', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700', '16 GB', NULL,
    'Done', 'Done', 'Non Domain',
    'Muroor Kitchen', 'Operation', NULL
);

-- 26. ONEH-SHAFI - Finance Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-SHAFI', 'Desktop', 'HEAD OFFICE', '4CE8361N15',
    'HP ProDesk 400 G5 MT IDS APJ', 'HP',
    '2019-05-29', 'good', 'active', 'Mohammed Shafi', get_department_id('Finance'),
    '2020-05-28', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz', '8 GB', NULL,
    'Done', 'Done', 'Domain',
    'Finance Office', 'Admin', NULL
);

-- 27. DESKTOP-DORI - Wathba Kitchen
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-DORI', 'Desktop', 'WATHBA KITCHEN', '4CE345DKN8',
    'HP Pro SFF 290 G9 Desktop PC', 'HP',
    '2024-12-03', 'good', 'active', 'Dori Eltahchi', get_department_id('Kitchen'),
    '2025-02-03', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700', '16 GB', NULL,
    'Done', 'Done', 'Non Domain',
    'Muroor Kitchen', 'Operation', NULL
);

-- 28. 1H-Babu - Admin Office Projects
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, issue_date, notes
) VALUES (
    '1H-Babu', 'Desktop', 'Main Office', '20250122084',
    'HOT Ultra 9', 'HOT_Systems',
    '2025-05-01', 'excellent', 'active', 'Babu Mohamed', get_department_id('Projects'),
    '2026-05-01', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) Ultra 9 285K', '63 GB', '1 TB',
    'Done', 'Done', 'Non Domain',
    'Admin Office', 'Operation',
    '2025-02-05',
    NULL
);

-- 29. SVE-HK-INTERIOR - Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'SVE-HK-INTERIOR', 'Desktop', 'SPANISH VILLA', 'GM0N9B2B',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'SVE-HK', get_department_id('Housekeeping'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'Spanish Villa', 'Operation', NULL
);

-- 30. DESKTOP-SYV-HK - Saadiyat Villa 7
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, issue_date, notes
) VALUES (
    'DESKTOP-SYV-HK', 'Desktop', 'SAADIYAT VILLA 7', 'GM0N9B1L',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'Ishani Yonili', get_department_id('Housekeeping'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'Saadiyat', 'Operation',
    '2025-05-21',
    NULL
);

-- 31. ONEH-SVE-FNB - Spanish Villa F&B
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'ONEH-SVE-FNB', 'Desktop', 'SPANISH VILLA', 'GM0N9B2L',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'SVE-F&B', get_department_id('F&B'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'Spanish Villa', 'Operation', NULL
);

-- 32. ONEH-HASNA-DESK - HR Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, issue_date, notes
) VALUES (
    'ONEH-HASNA-DESK', 'Desktop', 'Head Office', 'GM0N9B1R',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'Hasna', get_department_id('HR'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Domain',
    'HR Office', 'Admin',
    '2025-08-31',
    NULL
);

-- 33. WVE-HK-INTERIOR - White Villa Housekeeping
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, issue_date, notes
) VALUES (
    'WVE-HK-INTERIOR', 'Desktop', 'WHITE VILLA', 'GM0N9B22',
    'Lenovo ThinkCentre M70q G4', 'Lenovo',
    '2025-02-10', 'good', 'active', 'WVE EXTERIOR', get_department_id('Housekeeping'),
    '2028-02-09', 0, 0, NULL,
    'Windows 11 Pro', '13th Gen Intel(R) Core(TM) i7-13700T', '16 GB', '512 GB',
    'Done', 'Done', 'Non Domain',
    'White Villa', 'Operation',
    '2025-09-06',
    NULL
);

-- 34. DESKTOP-KITCHEN-YASAT - Al Yasat Kitchen
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    os_version, cpu_type, memory, storage,
    sentinel_status, ninja_status, domain_status,
    in_office_location, function, notes
) VALUES (
    'DESKTOP-KITCHEN-YASAT', 'Desktop', 'YASAT', '4CE151DSTN',
    'HP EliteDesk 800 G6 Tower PC', 'HP',
    '2020-01-01', 'good', 'active', 'Kitchen Yasat', get_department_id('Kitchen'),
    '2023-01-01', 0, 0, NULL,
    'Windows 11 Pro', 'Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz', '16 GB', NULL,
    'Done', 'Done', 'Non Domain',
    'Al Yasat', 'Operation', NULL
);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count desktop assets
SELECT COUNT(*) as total_desktops FROM assets WHERE category = 'Desktop';

-- Desktop summary by location
SELECT 
    location,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count
FROM assets 
WHERE category = 'Desktop'
GROUP BY location
ORDER BY count DESC;

-- Desktop summary by manufacturer
SELECT 
    manufacturer,
    COUNT(*) as count,
    COUNT(CASE WHEN domain_status = 'Domain' THEN 1 END) as domain_joined
FROM assets 
WHERE category = 'Desktop'
GROUP BY manufacturer
ORDER BY count DESC;

-- Recently issued desktops
SELECT 
    name,
    assigned_to,
    location,
    model,
    issue_date
FROM assets 
WHERE category = 'Desktop' 
  AND issue_date IS NOT NULL
ORDER BY issue_date DESC
LIMIT 10;

-- Security software status summary
SELECT 
    sentinel_status,
    ninja_status,
    COUNT(*) as count
FROM assets 
WHERE category = 'Desktop'
GROUP BY sentinel_status, ninja_status
ORDER BY count DESC;

-- Domain vs Non-Domain distribution
SELECT 
    domain_status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM assets WHERE category = 'Desktop'), 2) as percentage
FROM assets 
WHERE category = 'Desktop'
GROUP BY domain_status
ORDER BY count DESC;

-- View all desktops with key details
SELECT 
    name,
    manufacturer,
    model,
    assigned_to,
    location,
    in_office_location,
    domain_status,
    sentinel_status,
    function,
    issue_date
FROM assets 
WHERE category = 'Desktop'
ORDER BY name;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Desktop Import Complete!';
    RAISE NOTICE '📊 Total Desktops: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop');
    RAISE NOTICE '🖥️  HP Desktops: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop' AND manufacturer = 'HP');
    RAISE NOTICE '💻 Lenovo Desktops: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop' AND manufacturer = 'Lenovo');
    RAISE NOTICE '🏢 Dell Desktops: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop' AND manufacturer = 'Dell Inc.');
    RAISE NOTICE '🔐 Domain Joined: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop' AND domain_status = 'Domain');
    RAISE NOTICE '🏠 Non-Domain: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop' AND domain_status = 'Non Domain');
    RAISE NOTICE '✨ Active Desktops: %', (SELECT COUNT(*) FROM assets WHERE category = 'Desktop' AND status = 'active');
END $$;

-- Summary by function
SELECT 
  function,
  COUNT(*) as count,
  COUNT(CASE WHEN domain_status = 'Domain' THEN 1 END) as domain_joined
FROM assets 
WHERE category = 'Desktop'
GROUP BY function
ORDER BY count DESC;

-- Warranty expiring soon (within 3 months)
SELECT 
  name,
  manufacturer,
  model,
  assigned_to,
  warranty_expiry,
  warranty_expiry - CURRENT_DATE as days_remaining
FROM assets
WHERE category = 'Desktop'
  AND warranty_expiry IS NOT NULL
  AND warranty_expiry BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '3 months'
ORDER BY warranty_expiry;
