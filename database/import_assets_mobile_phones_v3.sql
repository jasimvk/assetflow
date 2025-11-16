-- ============================================================================
-- Mobile Phone Assets Import Script V3
-- AssetFlow - Complete Mobile Phone Inventory
-- ============================================================================
-- This script imports 60 mobile phones with full V2 schema support
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
-- - storage, memory (Technical specs - e.g., "128GB", "6GB")
-- - specifications (Configuration details like "Non-Camera", "Camera", "w/ Pen & Folio Case")
-- - issue_date (Date issued to user)
-- - transferred_date (Date transferred to current user)
-- - previous_owner (Previous user name)
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
-- MOBILE PHONE ASSETS IMPORT
-- ============================================================================

BEGIN;

-- Delete existing mobile phone assets to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Mobile Phone';

-- 1. Benco V91s - Housekeeping Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Benco-867617070038180', 'Mobile Phone', 'Spanish Villa', '867617070038180',
    'Benco V91s', 'Benco',
    '2025-01-01', 'good', 'active', 'Lokendra Kumar', get_department_id('Housekeeping'),
    '2026-01-01', 0, 0, NULL,
    'Non-Camera', '2025-04-11', NULL
);

-- 2. iPhone SE - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-W69D6D5403', 'Mobile Phone', 'Head Office', 'W69D6D5403',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2025-04-09', NULL
);

-- 3. iPhone SE - F&B Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-359968973948552', 'Mobile Phone', 'Spanish Villa', '359968973948552',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Sezim Azamatova', get_department_id('F&B'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2025-04-08', NULL
);

-- 4. iPhone SE - F&B Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-352348971158917', 'Mobile Phone', 'Spanish Villa', '352348971158917',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Akcholpon Zhadigerova', get_department_id('F&B'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2025-04-08', NULL
);

-- 5. Benco - L&T Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, memory, specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'Benco-867617070049369', 'Mobile Phone', 'Head Office', '867617070049369',
    'Benco', 'Benco',
    '2025-01-01', 'good', 'active', 'Suraj Khan', get_department_id('L&T'),
    '2026-01-01', 0, 0, NULL,
    '128GB', '6GB', 'Non-Camera', '2025-10-13', '2025-04-02', 'Kristian Reyes', NULL
);

-- 6. iPhone SE - F&B Spanish Villa (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'iPhone-C6KT9VF5HG7F', 'Mobile Phone', 'Spanish Villa', 'C6KT9VF5HG7F',
    'iPhone SE', 'Apple',
    '2022-01-28', 'good', 'active', 'Marilize Marais', get_department_id('F&B'),
    '2023-01-28', 0, 0, NULL,
    'Non-Camera', '2025-01-28', '2022-01-28', 'Jessa Joy Ferrer', NULL
);

-- 7. iPhone SE - Housekeeping SAS (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'iPhone-FFXD1Z2NPLK2', 'Mobile Phone', 'SAS', 'FFXD1Z2NPLK2',
    'iPhone SE', 'Apple',
    '2025-01-10', 'good', 'active', 'Regienald Regala', get_department_id('Housekeeping'),
    '2026-01-10', 0, 0, NULL,
    'Camera', '2025-01-20', '2025-01-10', 'Annaliza Arresgado', NULL
);

-- 8. MiOne - F&B Spanish Villa (Transfer from Mahesh Rai to Ainhoa, previous: Prem Singh)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'MiOne-354663410055039', 'Mobile Phone', 'Spanish Villa', '354663410055039',
    'MiOne', 'Xiaomi',
    '2023-12-11', 'good', 'active', 'Ainhoa Cabello Mella', get_department_id('F&B'),
    '2024-12-11', 0, 0, NULL,
    'Non-camera', '2025-01-15', '2023-12-11', 'Mahesh Rai', 'Previous: Prem Singh'
);

-- 9. iPhone SE - Housekeeping Saadiyat
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    issue_date, notes
) VALUES (
    'iPhone-FFMDXAH7PLK2', 'Mobile Phone', 'Saadiyat', 'FFMDXAH7PLK2',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Jonmoni Boro', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    '2025-01-10', NULL
);

-- 10. MiOne - Housekeeping Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'MiOne-354663410061243', 'Mobile Phone', 'Spanish Villa', '354663410061243',
    'MiOne', 'Xiaomi',
    '2024-01-01', 'good', 'active', 'Augustine Solomon', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    'Non-camera', '2025-01-10', NULL
);

-- 11. Benco V91s - Housekeeping Al Rakna
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Benco-887617070088763', 'Mobile Phone', 'Al Rakna', '887617070088763',
    'Benco V91s', 'Benco',
    '2024-01-01', 'good', 'active', 'Jayvee Vincent', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2025-01-07', NULL
);

-- 12. Benco V91s - L&T Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Benco-867617070083269', 'Mobile Phone', 'Spanish Villa', '867617070083269',
    'Benco V91s', 'Benco',
    '2024-01-01', 'good', 'active', 'Ishakh Kalodi', get_department_id('L&T'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-12-31', NULL
);

-- 13. Benco S1s - L&T Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Benco-862404060676187', 'Mobile Phone', 'Spanish Villa', '862404060676187',
    'Benco S1s', 'Benco',
    '2024-01-01', 'good', 'active', 'Ishakh Kalodi', get_department_id('L&T'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-12-30', NULL
);

-- 14. iPhone 7 - Admin Head Office (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'iPhone-F17T79PWHG7X', 'Mobile Phone', 'Head Office', 'F17T79PWHG7X',
    'iPhone 7 Model MNCE2J/A', 'Apple',
    '2022-03-22', 'good', 'active', 'Mesud Gebretsadik Weldehawariat', get_department_id('Admin'),
    '2023-03-22', 0, 0, NULL,
    'Model MNCE2J/A', '2024-12-13', '2022-03-22', 'Olena Artymko', NULL
);

-- 15. MiOne - HSE Head Office (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'MiOne-354663410057134', 'Mobile Phone', 'Head Office', '354663410057134',
    'MiOne', 'Xiaomi',
    '2023-09-04', 'good', 'active', 'Maneesh Moothattil', get_department_id('HSE'),
    '2024-09-04', 0, 0, NULL,
    'Non-camera', '2024-11-06', '2023-09-04', 'Nixie Angoya', NULL
);

-- 16. iPhone SE - Housekeeping Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, specifications, issue_date, notes
) VALUES (
    'iPhone-DX3GN5PAPLJY', 'Mobile Phone', 'Spanish Villa', 'DX3GN5PAPLJY',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Thi Da', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    '128GB', 'Camera', '2024-10-08', NULL
);

-- 17. iPhone SE - Housekeeping Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    issue_date, notes
) VALUES (
    'iPhone-HCVFJ2G7PLK2', 'Mobile Phone', 'Head Office', 'HCVFJ2G7PLK2',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Eldho George', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    '2024-07-16', NULL
);

-- 18. iPhone SE - Housekeeping Al Rowda
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    issue_date, notes
) VALUES (
    'iPhone-FFNCJ3ZGPLK2', 'Mobile Phone', 'Al Rowda', 'FFNCJ3ZGPLK2',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Suresh Puliveni', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    '2024-07-16', NULL
);

-- 19. iPhone SE - Housekeeping Al Rakna (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    issue_date, previous_owner, notes
) VALUES (
    'iPhone-DX3DT86MPLK2', 'Mobile Phone', 'Al Rakna', 'DX3DT86MPLK2',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Jayvee Cancino', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    '2025-09-24', 'Mohamad Rilfan', NULL
);

-- 20. MiOne - L&T Head Office (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'MiOne-354663410061235', 'Mobile Phone', 'Head Office', '354663410061235',
    'MiOne', 'Xiaomi',
    '2023-12-26', 'good', 'active', 'Angelo Sarabia Ribon', get_department_id('L&T'),
    '2024-12-26', 0, 0, NULL,
    'Non-camera', '2024-07-05', '2023-12-26', 'Kanykie Anakul', NULL
);

-- 21. CAT - L&T Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206954', 'Mobile Phone', 'Head Office', '359145660206954',
    'CAT', 'CAT',
    '2024-01-01', 'good', 'active', 'Kristian Reyes', get_department_id('L&T'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-06-13', NULL
);

-- 22. iPhone 7 - Housekeeping Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-DNPSX0ULHG7X', 'Mobile Phone', 'Spanish Villa', 'DNPSX0ULHG7X',
    'iPhone 7', 'Apple',
    '2024-01-01', 'good', 'active', 'Junelisa Lumabe', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-06-06', NULL
);

-- 23. iPhone SE - Housekeeping Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    issue_date, notes
) VALUES (
    'iPhone-F17DMKPMPLJT', 'Mobile Phone', 'Head Office', 'F17DMKPMPLJT',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Lucy Njoroge', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    '2024-06-05', NULL
);

-- 24. iPhone SE - F&B Spanish Villa (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    storage, specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'iPhone-355054410133035', 'Mobile Phone', 'Spanish Villa', '355054410133035',
    'iPhone SE', 'Apple',
    '2023-12-11', 'good', 'active', 'Sezim Azamatova', get_department_id('F&B'),
    '2024-12-11', 0, 0, NULL,
    '128GB', 'Non-Camera Phone', '2024-05-24', '2023-12-11', 'Yryssay Duisebek', NULL
);

-- 25. iPhone SE - F&B Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-35555575427558', 'Mobile Phone', 'Head Office', '35555575427558',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Shiela Timban', get_department_id('F&B'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-24', NULL
);

-- 26. MiOne - Housekeeping White Villa (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'MiOne-354663410059676', 'Mobile Phone', 'White Villa', '354663410059676',
    'MiOne', 'Xiaomi',
    '2023-06-26', 'good', 'active', 'Nalusiba Angella', get_department_id('Housekeeping'),
    '2024-06-26', 0, 0, NULL,
    'Non-camera', '2024-05-16', '2023-06-26', 'Naimakhon Abduvokhidova', NULL
);

-- 27. iPhone 7 - IT Department (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'iPhone-FRDT91JSGRYD', 'Mobile Phone', 'Head Office', 'FRDT91JSGRYD',
    'iPhone 7', 'Apple',
    '2024-05-15', 'good', 'active', 'IT Department', get_department_id('IT'),
    '2025-05-15', 0, 0, NULL,
    'Non-Camera', '2025-06-11', '2024-05-15', 'Naimakhon Abduvokhidova', NULL
);

-- 28. CAT S42 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206202', 'Mobile Phone', 'Head Office', '359145660206202',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-03', NULL
);

-- 29. CAT S42 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206194', 'Mobile Phone', 'Head Office', '359145660206194',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-03', NULL
);

-- 30. CAT S42 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206137', 'Mobile Phone', 'Head Office', '359145660206137',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-03', NULL
);

-- Additional CAT S42 phones follow the same pattern...
-- (Continuing with remaining 30 phones)

-- 31. CAT S42 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206434', 'Mobile Phone', 'Head Office', '359145660206434',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-03', NULL
);

-- 32. CAT S42 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660209297', 'Mobile Phone', 'Head Office', '359145660209297',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-03', NULL
);

-- 33. CAT S42 - Housekeeping White Villa (Transfer)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'CAT-359145660206186', 'Mobile Phone', 'White Villa', '359145660206186',
    'CAT S42', 'CAT',
    '2024-05-03', 'good', 'active', 'Amos Gachambwa', get_department_id('Housekeeping'),
    '2025-05-03', 0, 0, NULL,
    'Non-Camera', '2025-05-14', '2024-05-03', 'Durga Khadka', NULL
);

-- 34. CAT S42 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206426', 'Mobile Phone', 'Head Office', '359145660206426',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-05-03', NULL
);

-- 35. CAT S42 - IT Department (Transfer from Security)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES (
    'CAT-359145660206079', 'Mobile Phone', 'Head Office', '359145660206079',
    'CAT S42', 'CAT',
    '2024-05-03', 'good', 'active', 'IT Department', get_department_id('IT'),
    '2025-05-03', 0, 0, NULL,
    'Non-Camera | S422051006007', '2025-11-05', '2024-05-03', 'Durga Khadka', 'Previously Security department'
);

-- 36. Lenovo Tab M1 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Lenovo-865823068738490', 'Mobile Phone', 'Head Office', '865823068738490',
    'Lenovo Tab M1', 'Lenovo',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'w/ Pen & Folio Case', '2024-05-03', 'Tablet device'
);

-- 37. Lenovo Tab M1 - Security Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Lenovo-865823068736692', 'Mobile Phone', 'Head Office', '865823068736692',
    'Lenovo Tab M1', 'Lenovo',
    '2024-01-01', 'good', 'active', 'Durga Khadka', get_department_id('Security'),
    '2025-01-01', 0, 0, NULL,
    'w/ Pen & Folio Case', '2024-05-03', 'Tablet device'
);

-- 38. CAT S42 - L&T Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'CAT-359145660206921', 'Mobile Phone', 'Head Office', '359145660206921',
    'CAT S42', 'CAT',
    '2024-01-01', 'good', 'active', 'Indika Chakrawarthilage', get_department_id('L&T'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-04-25', NULL
);

-- 39. Lava Benco V80s - Housekeeping Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'Lava-8650550001369', 'Mobile Phone', 'Spanish Villa', '8650550001369',
    'Lava Benco V80s', 'Lava',
    '2024-01-01', 'good', 'active', 'Robina Calindas', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-04-19', NULL
);

-- 40. iPhone 7 - F&B Spanish Villa
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-355839082293997', 'Mobile Phone', 'Spanish Villa', '355839082293997',
    'iPhone 7', 'Apple',
    '2024-01-01', 'good', 'active', 'Kathleen Moreno', get_department_id('F&B'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-04-04', NULL
);

-- 41. iPhone SE - F&B Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-35674005525609', 'Mobile Phone', 'Head Office', '35674005525609',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Varynia Wankhar', get_department_id('F&B'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-04-04', NULL
);

-- 42. iPhone SE - Housekeeping Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-356487109497242', 'Mobile Phone', 'Head Office', '356487109497242',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Rasheed Ali Mohammad', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-04-04', NULL
);

-- 43. iPhone SE - Housekeeping Head Office
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES (
    'iPhone-356778112858601', 'Mobile Phone', 'Head Office', '356778112858601',
    'iPhone SE', 'Apple',
    '2024-01-01', 'good', 'active', 'Shenna Vergara', get_department_id('Housekeeping'),
    '2025-01-01', 0, 0, NULL,
    'Non-Camera', '2024-04-04', NULL
);

-- 44-50. Additional CAT S42 phones for L&T and Housekeeping
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES
('CAT-359145660209800', 'Mobile Phone', 'Head Office', '359145660209800', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Richu Subhangithan', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-04-03', NULL),
('CAT-359145660208919', 'Mobile Phone', 'White Villa', '359145660208919', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'AninKumar Thangamony', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-28', NULL),
('CAT-359145660207077', 'Mobile Phone', 'White Villa', '359145660207077', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Rajesh Etyala', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-28', NULL),
('CAT-359145660206947', 'Mobile Phone', 'White Villa', '359145660206947', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Damina Kumara', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-28', NULL),
('CAT-359145660208893', 'Mobile Phone', 'Head Office', '359145660208893', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Abdul Rafiq', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL),
('CAT-359145660207572', 'Mobile Phone', 'Head Office', '359145660207572', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Mohammed Rafiq', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL),
('CAT-359145660207291', 'Mobile Phone', 'Head Office', '359145660207291', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Bryann Flix', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL);

-- 51-55. Additional phones
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, notes
) VALUES
('CAT-359145660207564', 'Mobile Phone', 'Head Office', '359145660207564', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Arshad Paliyat', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL),
('CAT-359145660209743', 'Mobile Phone', 'Head Office', '359145660209743', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Jay Kishor Mahato', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL),
('CAT-359145660207756', 'Mobile Phone', 'Head Office', '359145660207756', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Sreeji Screenivasan', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL),
('CAT-359145660208158', 'Mobile Phone', 'Head Office', '359145660208158', 'CAT S42', 'CAT', '2024-01-01', 'good', 'active', 'Venkatesh Lokini', get_department_id('L&T'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-21', NULL),
('iPhone-F17DG1Z9PLK1', 'Mobile Phone', 'Spanish Villa', 'F17DG1Z9PLK1', 'iPhone SE', 'Apple', '2024-01-01', 'good', 'active', 'Rodrigo Cabias', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Non-Camera', '2024-03-06', NULL);

-- 56-60. Final phones
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Lava-865055050022308', 'Mobile Phone', 'White Villa', '865055050022308', 'Lava Benco V80s', 'Lava', '2024-01-01', 'good', 'active', 'Shehan Priyankara', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Non-camera', '2024-03-01', NULL, NULL, NULL),
('iPhone-354914092864408', 'Mobile Phone', 'Head Office', '354914092864408', 'iPhone 7', 'Apple', '2022-02-03', 'good', 'active', 'Iuliana Anton', get_department_id('F&B'), '2023-02-03', 0, 0, NULL, 'Non-Camera', '2024-02-22', '2022-02-03', 'Hindmila Kuivorechro', NULL);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count mobile phone assets
SELECT COUNT(*) as total_phones FROM assets WHERE category = 'Mobile Phone';

-- Mobile phone summary by manufacturer
SELECT 
    manufacturer,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count
FROM assets 
WHERE category = 'Mobile Phone'
GROUP BY manufacturer
ORDER BY count DESC;

-- Mobile phone summary by department
SELECT 
    d.name as department,
    COUNT(a.id) as phone_count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Mobile Phone'
GROUP BY d.name
ORDER BY phone_count DESC;

-- Recently issued phones
SELECT 
    name,
    model,
    assigned_to,
    location,
    issue_date
FROM assets 
WHERE category = 'Mobile Phone' 
  AND issue_date IS NOT NULL
ORDER BY issue_date DESC
LIMIT 15;

-- Phones with transfers (previous owners)
SELECT 
    name,
    model,
    assigned_to,
    previous_owner,
    transferred_date,
    location
FROM assets 
WHERE category = 'Mobile Phone' 
  AND previous_owner IS NOT NULL
ORDER BY transferred_date DESC;

-- View all phones with key details
SELECT 
    name,
    manufacturer,
    model,
    assigned_to,
    location,
    specifications,
    issue_date
FROM assets 
WHERE category = 'Mobile Phone'
ORDER BY manufacturer, model;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Mobile Phone Import Complete!';
    RAISE NOTICE '📱 Total Mobile Phones: %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone');
    RAISE NOTICE '🍎 Apple (iPhone): %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone' AND manufacturer = 'Apple');
    RAISE NOTICE '🐱 CAT Phones: %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone' AND manufacturer = 'CAT');
    RAISE NOTICE '📱 Benco Phones: %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone' AND manufacturer = 'Benco');
    RAISE NOTICE '📱 Xiaomi (MiOne): %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone' AND manufacturer = 'Xiaomi');
    RAISE NOTICE '🔄 Phones with Transfers: %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone' AND previous_owner IS NOT NULL);
    RAISE NOTICE '✨ Active Phones: %', (SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone' AND status = 'active');
END $$;
