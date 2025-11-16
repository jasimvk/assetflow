-- ============================================================================
-- Walkie Talkie Assets Import Script V3
-- AssetFlow - Complete Walkie Talkie Inventory
-- ============================================================================
-- This script imports 90+ walkie talkies with full V2 schema support
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
-- - specifications (Configuration details like "W/ earpiece", "W/ earpiece and charger")
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
-- WALKIE TALKIE ASSETS IMPORT
-- ============================================================================

BEGIN;

-- Delete existing walkie talkie assets to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Walkie Talkie';

-- 1-5. Early 2022-2023 Walkie Talkies (F&B and Housekeeping)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-546TSH1080', 'Walkie Talkie', 'White Villa', '546TSH1080', 'Motorola SL1600e', 'Motorola', '2022-01-01', 'good', 'active', 'Amber Leigh', get_department_id('F&B'), '2024-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2022-11-23', '2022-11-23', 'Anastassiya Gondareva', NULL),
('Motorola-546TSH0891', 'Walkie Talkie', 'Spanish Villa', '546TSH0891', 'Motorola SL1600e', 'Motorola', '2022-01-01', 'good', 'active', 'Judy Anne Gallardo', get_department_id('F&B'), '2024-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2022-11-23', NULL, NULL, NULL),
('Motorola-546TSF4071', 'Walkie Talkie', 'White Villa', '546TSF4071', 'Motorola SL1600', 'Motorola', '2022-01-01', 'good', 'active', 'Manita Pakhrin', get_department_id('Housekeeping'), '2024-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2022-11-23', NULL, NULL, NULL),
('Motorola-546TSH1052', 'Walkie Talkie', 'Head Office', '546TSH1052', 'Motorola SL1600e', 'Motorola', '2022-01-01', 'good', 'active', 'Valeriya Shilina', get_department_id('F&B'), '2024-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2022-11-23', '2022-11-23', 'Amber Leigh', NULL),
('Motorola-546TSH1122', 'Walkie Talkie', 'White Villa', '546TSH1122', 'Motorola SL1600e', 'Motorola', '2023-01-01', 'good', 'active', 'Jowelyn Cator', get_department_id('Spa and Recreation'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2023-02-22', NULL, NULL, NULL);

-- 6-10. Mid 2023 Walkie Talkies
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-546TTK2891', 'Walkie Talkie', 'Spanish Villa', '546TTK2891', 'Motorola SL1600e', 'Motorola', '2022-11-23', 'good', 'active', 'Akcholpon Zhadigerova', get_department_id('F&B'), '2024-11-23', 0, 0, NULL, 'Walkie Talkie', '2023-06-16', '2022-11-23', 'Jessie Dalisay', NULL),
('Motorola-682TVD1299', 'Walkie Talkie', 'Spanish Villa', '682TVD1299', 'Motorola SL400e', 'Motorola', '2023-01-01', 'good', 'active', 'Sophie Chester', get_department_id('F&B'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-07-13', NULL, NULL, NULL),
('Motorola-682TVD1726', 'Walkie Talkie', 'Spanish Villa', '682TVD1726', 'Motorola SL4000e', 'Motorola', '2023-01-01', 'good', 'active', 'Shecill Manzano', get_department_id('F&B'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-08-14', NULL, NULL, NULL),
('Motorola-682TVD1468', 'Walkie Talkie', 'Spanish Villa', '682TVD1468', 'Motorola SL4000e', 'Motorola', '2023-01-01', 'good', 'active', 'Sairish Lim Lalaguna', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-09-15', '2023-09-15', 'Aizada Kubatbekova', NULL),
('Motorola-6812TVD1736', 'Walkie Talkie', 'Spanish Villa', '6812TVD1736', 'Motorola SL400e', 'Motorola', '2023-01-01', 'good', 'active', 'Abegail Guibo', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-09-22', NULL, NULL, NULL);

-- 11-15. Late 2023 Walkie Talkies
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVD1703', 'Walkie Talkie', 'White Villa', '682TVD1703', 'Motorola SL400e', 'Motorola', '2023-01-01', 'good', 'active', 'Matet Omilig', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-09-22', NULL, NULL, NULL),
('Motorola-6812TVB0673', 'Walkie Talkie', 'Spanish Villa', '6812TVB0673', 'Motorola SL400e', 'Motorola', '2023-01-01', 'good', 'active', 'Rose Ann Aala', get_department_id('Housekeeping'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-09-22', NULL, NULL, NULL),
('Motorola-682TVB0725', 'Walkie Talkie', 'White Villa', '682TVB0725', 'Motorola SL400e', 'Motorola', '2023-09-11', 'good', 'active', 'Anabelle Estrella', get_department_id('Housekeeping'), '2025-09-11', 0, 0, NULL, 'Walkie Talkie', '2023-11-16', '2023-09-11', 'Estelle Kudaibergen', NULL),
('Motorola-682TVD1732', 'Walkie Talkie', 'Spanish Villa', '682TVD1732', 'Motorola SL400e', 'Motorola', '2023-01-01', 'good', 'active', 'Svetlana Rossina', get_department_id('F&B'), '2025-01-01', 0, 0, NULL, 'Walkie Talkie', '2023-12-07', NULL, NULL, NULL),
('Motorola-682TTT0048', 'Walkie Talkie', 'Spanish Villa', '682TTT0048', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Cheska Ybanez', get_department_id('F&B'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-01-17', NULL, NULL, NULL);

-- 16-20. Early 2024 Walkie Talkies
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVB0818', 'Walkie Talkie', 'Spanish Villa', '682TVB0818', 'Motorola SL4000e', 'Motorola', '2023-05-23', 'good', 'active', 'Sezim Azamatova', get_department_id('F&B'), '2025-05-23', 0, 0, NULL, 'Walkie Talkie', '2024-01-17', '2023-05-23', 'Iuliana Anton', NULL),
('Motorola-682TSM2490', 'Walkie Talkie', 'Spanish Villa', '682TSM2490', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Dwi Ningsih', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-01-18', NULL, NULL, NULL),
('Motorola-682TST0467', 'Walkie Talkie', 'Spanish Villa', '682TST0467', 'Motorola SL4000e', 'Motorola', '2024-01-18', 'good', 'active', 'Violetta Shilina', get_department_id('F&B'), '2026-01-18', 0, 0, NULL, 'Walkie Talkie', '2025-11-05', '2024-01-18', 'Henny Setyowati', 'Previous: Housekeeping'),
('Motorola-682TSR1745', 'Walkie Talkie', 'Spanish Villa', '682TSR1745', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Iszuara Guinoo', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-01-18', NULL, NULL, NULL),
('Motorola-682TSR1744', 'Walkie Talkie', 'Spanish Villa', '682TSR1744', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Daniella Paramitha', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-02-28', NULL, NULL, NULL);

-- 21-25. Q1 2024 Walkie Talkies
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TSR1740', 'Walkie Talkie', 'Spanish Villa', '682TSR1740', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Mei Prehaten', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-02-28', NULL, NULL, NULL),
('Motorola-682TVD1421', 'Walkie Talkie', 'Spanish Villa', '682TVD1421', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Kathlene Moreno', get_department_id('F&B'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-02-29', NULL, NULL, NULL),
('Motorola-546TSH0915', 'Walkie Talkie', 'Spanish Villa', '546TSH0915', 'Motorola SL1600e', 'Motorola', '2023-03-02', 'good', 'active', 'Arra Tibay Dimagan', get_department_id('F&B'), '2025-03-02', 0, 0, NULL, 'Walkie Talkie', '2024-03-06', '2023-03-02', 'Nina Raimanova', NULL),
('Motorola-682TSR743', 'Walkie Talkie', 'Head Office', '682TSR743', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Iuliana Anton', get_department_id('F&B'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-04-01', NULL, NULL, NULL),
('Motorola-682TVB0635', 'Walkie Talkie', 'Spanish Villa', '682TVB0635', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Robina Calindas', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie', '2024-04-19', NULL, NULL, NULL);

-- 26-30. Q2 2024 Walkie Talkies with Earpiece
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVD1657', 'Walkie Talkie', 'White Villa', '682TVD1657', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Christine Gutierrez', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2024-05-01', NULL, NULL, NULL),
('Motorola-546TSH1170', 'Walkie Talkie', 'Spanish Villa', '546TSH1170', 'Motorola SL1600e', 'Motorola', '2022-11-24', 'good', 'active', 'Dahlla David', get_department_id('F&B'), '2024-11-24', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-05-16', '2022-11-24', 'Dahlla David', NULL),
('Motorola-682TVD1733', 'Walkie Talkie', 'Spanish Villa', '682TVD1733', 'Motorola SL1600', 'Motorola', '2023-09-15', 'good', 'active', 'Marimar Montoya', get_department_id('Housekeeping'), '2025-09-15', 0, 0, NULL, 'Walkie Talkie', '2024-06-12', '2023-09-15', 'Sushma Rana', NULL),
('Motorola-682TVD0937', 'Walkie Talkie', 'Spanish Villa', '682TVD0937', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Aadhinath Harikumar', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL),
('Motorola-682TVD1531', 'Walkie Talkie', 'Spanish Villa', '682TVD1531', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Amrit Pal Signh', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL);

-- 31-35. June 2024 Housekeeping Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVB0841', 'Walkie Talkie', 'Spanish Villa', '682TVB0841', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Laxman Reddy', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL),
('Motorola-682TVB0661', 'Walkie Talkie', 'Spanish Villa', '682TVB0661', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Mark Kenneth Pilit', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL),
('Motorola-682TVB0802', 'Walkie Talkie', 'Spanish Villa', '682TVB0802', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Naveen Gaje', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL),
('Motorola-682TVB0765', 'Walkie Talkie', 'Spanish Villa', '682TVB0765', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Rajesh Kyatham', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL),
('Motorola-682TVD0996', 'Walkie Talkie', 'Spanish Villa', '682TVD0996', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Rasheed Mohammad', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL);

-- 36-40. Late June 2024 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVD1557', 'Walkie Talkie', 'Spanish Villa', '682TVD1557', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Sagar Mehta', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-13', NULL, NULL, NULL),
('Motorola-682TVB0842', 'Walkie Talkie', 'Spanish Villa', '682TVB0842', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Mark Kenneth Pilit', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-06-25', NULL, 'Arun Rajarapu', NULL),
('Motorola-682TVB0783', 'Walkie Talkie', 'Spanish Villa', '682TVB0783', 'Motorola SL400e', 'Motorola', '2023-09-15', 'good', 'active', 'Mujeeb Syed', get_department_id('Housekeeping'), '2025-09-15', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-09', '2023-09-15', 'Bermet Kenzhebekoba', NULL),
('Motorola-682TVD1721', 'Walkie Talkie', 'Spanish Villa', '682TVD1721', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Prashant Kunta', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-09', NULL, NULL, NULL),
('Motorola-682TVB0309', 'Walkie Talkie', 'Spanish Villa', '682TVB0309', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Shashi Sara', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-09', NULL, NULL, NULL);

-- 41-45. July 2024 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-546TTK2948', 'Walkie Talkie', 'Spanish Villa', '546TTK2948', 'Motorola SL1600e', 'Motorola', '2023-12-29', 'good', 'active', 'Cheska Ybanez', get_department_id('F&B'), '2025-12-29', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-11', '2023-12-29', 'Aibat Massgutova', NULL),
('Motorola-682TVB0845', 'Walkie Talkie', 'White Villa', '682TVB0845', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Indunil Bandara', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-11', NULL, NULL, NULL),
('Motorola-682TVB0671', 'Walkie Talkie', 'White Villa', '682TVB0671', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Prashant Godike', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-11', NULL, NULL, NULL),
('Motorola-682TBD1706', 'Walkie Talkie', 'White Villa', '682TBD1706', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Shenhan Priyaka', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-07-11', NULL, NULL, NULL),
('Motorola-682TVD1549', 'Walkie Talkie', 'Spanish Villa', '682TVD1549', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Dwi Sintia', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-08-07', NULL, NULL, NULL);

-- 46-50. Late 2024 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVB0608', 'Walkie Talkie', 'Spanish Villa', '682TVB0608', 'Motorola SL400e', 'Motorola', '2024-01-01', 'good', 'active', 'Fernanda Gelu', get_department_id('Housekeeping'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2024-08-07', NULL, NULL, NULL),
('Motorola-682TTX0571', 'Walkie Talkie', 'Spanish Villa', '682TTX0571', 'Motorola SL400e', 'Motorola', '2024-06-12', 'good', 'active', 'Charith Wijethunga', get_department_id('F&B'), '2026-06-12', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2024-09-23', '2024-06-12', 'Zara Yardimci', NULL),
('Motorola-682TVD0997', 'Walkie Talkie', 'Spanish Villa', '682TVD0997', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Piyawan Suwannasang', get_department_id('F&B'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2024-10-17', NULL, NULL, NULL),
('Motorola-682TSR1743', 'Walkie Talkie', 'Spanish Villa', '682TSR1743', 'Motorola SL4000e', 'Motorola', '2024-01-01', 'good', 'active', 'Judy Anne Gallardo', get_department_id('F&B'), '2026-01-01', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2024-11-13', NULL, NULL, NULL),
('Motorola-682TVD1569', 'Walkie Talkie', 'Spanish Villa', '682TVD1569', 'Motorola SL4000e', 'Motorola', '2024-02-29', 'good', 'active', 'Pallavi Laxman Bhoir', get_department_id('Housekeeping'), '2026-02-28', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2024-11-13', '2024-02-29', 'Maria Sole', NULL);

-- 51-55. December 2024 - January 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVD1731', 'Walkie Talkie', 'Spanish Villa', '682TVD1731', 'Motorola SL4000e', 'Motorola', '2024-07-11', 'good', 'active', 'Ashika Gurung', get_department_id('Housekeeping'), '2026-07-11', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2024-12-05', '2024-07-11', 'Siyabul Hameed', NULL),
('Motorola-546TTK2873', 'Walkie Talkie', 'Spanish Villa', '546TTK2873', 'Motorola SL1600', 'Motorola', '2022-11-23', 'good', 'active', 'Marilize Marais', get_department_id('F&B'), '2024-11-23', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2025-01-14', '2022-11-23', 'Siyabul Hameed', NULL),
('Motorola-682TTT0064', 'Walkie Talkie', 'Spanish Villa', '682TTT0064', 'Motorola SL4000e', 'Motorola', '2023-06-16', 'good', 'active', 'Lizel Rivera', get_department_id('F&B'), '2025-06-16', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2025-01-15', '2023-06-16', 'Iana Bicova', NULL),
('Motorola-682TVD0767', 'Walkie Talkie', 'Spanish Villa', '682TVD0767', 'Motorola SL4000e', 'Motorola', '2025-01-01', 'good', 'active', 'Thi Da', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2025-02-03', NULL, NULL, NULL),
('Motorola-871TYT4088', 'Walkie Talkie', 'Head Office', '871TYT4088', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Marjulyn Doce', get_department_id('Maintenance'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-02-06', NULL, NULL, NULL);

-- 56-60. Q1 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVD1341', 'Walkie Talkie', 'Head Office', '682TVD1341', 'Motorola SL400e', 'Motorola', '2024-06-13', 'good', 'active', 'Lucy Njoroge', get_department_id('Housekeeping'), '2026-06-13', 0, 0, NULL, 'Walkie Talkie W/ earpiece and charger', '2025-03-27', '2024-06-13', 'Rohan Victor', NULL),
('Motorola-682TVD1693', 'Walkie Talkie', 'Spanish Villa', '682TVD1693', 'Motorola SL4000e', 'Motorola', '2024-02-28', 'good', 'active', 'Agustina Ose Lamury', get_department_id('Housekeeping'), '2026-02-28', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2025-03-28', '2024-02-28', 'Kimberly Abing', NULL),
('Motorola-682TVB0771', 'Walkie Talkie', 'Spanish Villa', '682TVB0771', 'Motorola SL4000e', 'Motorola', '2025-01-01', 'good', 'active', 'Shehan Arachchige', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2025-04-09', NULL, NULL, NULL),
('Motorola-682TVB0257', 'Walkie Talkie', 'Spanish Villa', '682TVB0257', 'Motorola SL4000e', 'Motorola', '2025-01-01', 'good', 'active', 'Win Min Thant', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2025-04-09', NULL, NULL, NULL),
('Motorola-682TVB0740', 'Walkie Talkie', 'Spanish Villa', '682TVB0740', 'Motorola SL4000e', 'Motorola', '2024-10-17', 'good', 'active', 'Lokendra Kumar', get_department_id('Housekeeping'), '2026-10-17', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2025-04-14', '2024-10-17', 'Thet Htar Phyu', NULL);

-- 61-65. Q2 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TSR1749', 'Walkie Talkie', 'Spanish Villa', '682TSR1749', 'Motorola SL4000e', 'Motorola', '2025-01-01', 'good', 'active', 'Ainhoa Mella', get_department_id('F&B'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2025-04-24', NULL, NULL, NULL),
('Motorola-682TSM2554', 'Walkie Talkie', 'Spanish Villa', '682TSM2554', 'Motorola SL400', 'Motorola', '2024-01-17', 'good', 'active', 'Dyah Wulandari', get_department_id('Housekeeping'), '2026-01-17', 0, 0, NULL, 'Walkie Talkie', '2025-05-02', '2024-01-17', 'Anneri Pretorius', NULL),
('Motorola-871TYT3624', 'Walkie Talkie', 'Spanish Villa', '871TYT3624', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Francine Uwamahoro', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-05-23', NULL, NULL, NULL),
('Motorola-871TYT3170', 'Walkie Talkie', 'Spanish Villa', '871TYT3170', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Raymond Agustine Solomon', get_department_id('Laundry'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-05-23', NULL, NULL, NULL),
('Motorola-871TYT3137', 'Walkie Talkie', 'Al Rowda', '871TYT3137', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Man Sunar', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-05-27', NULL, NULL, NULL);

-- 66-70. Late May 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-871TYT4020', 'Walkie Talkie', 'Al Rowda', '871TYT4020', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Suman Gudelli', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-05-27', NULL, NULL, NULL),
('Motorola-871TYT5179', 'Walkie Talkie', 'Al Rowda', '871TYT5179', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Suresh Puliveni', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-05-27', NULL, NULL, NULL),
('Motorola-682TVB0657', 'Walkie Talkie', 'Spanish Villa', '682TVB0657', 'Motorola SL400e', 'Motorola', '2023-12-07', 'good', 'active', 'Josa Constantino', get_department_id('F&B'), '2025-12-07', 0, 0, NULL, 'Walkie Talkie', '2025-05-29', '2023-12-07', 'Marina Sukhankina', NULL),
('Motorola-682TVB0683', 'Walkie Talkie', 'Head Office', '682TVB0683', 'Motorola SL400e', 'Motorola', '2023-07-13', 'good', 'active', 'Alyona Kubatbekova', get_department_id('F&B'), '2025-07-13', 0, 0, NULL, 'Walkie Talkie W/ earpiece', '2025-06-24', '2023-07-13', 'Naimakhon Abduvikhidova', NULL),
('Motorola-871TYT3561', 'Walkie Talkie', 'Spanish Villa', '871TYT3561', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Joanna Marie Bautista', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-07-02', NULL, NULL, NULL);

-- 71-75. July 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TSM2254', 'Walkie Talkie', 'White Villa', '682TSM2254', 'Motorola SL4000e', 'Motorola', '2025-02-05', 'good', 'active', 'Marriane Marcelo', get_department_id('Housekeeping'), '2027-02-05', 0, 0, NULL, 'Walkie Talkie', '2025-07-17', '2025-02-05', 'Dyan Wulandari', NULL),
('Motorola-682TSX0162', 'Walkie Talkie', 'Spanish Villa', '682TSX0162', 'Motorola SL4000e', 'Motorola', '2023-05-23', 'good', 'active', 'Violetta Shilina', get_department_id('F&B'), '2025-05-23', 0, 0, NULL, 'Walkie Talkie w/ Earpiece and Charger', '2025-07-17', '2023-05-23', 'Kathmuthu Chinnaiyan', NULL),
('Motorola-871TYT3101', 'Walkie Talkie', 'White Villa', '871TYT3101', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Abhishek Sharma', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-07-31', '2025-07-02', 'Violetta Shilina', NULL),
('Motorola-871TYT3642', 'Walkie Talkie', 'White Villa', '871TYT3642', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Daminda Mudiyanselage', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-07-31', '2025-07-01', 'Cahyani Caca', NULL),
('Motorola-871TYT3454', 'Walkie Talkie', 'White Villa', '871TYT3454', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Harish Gaje', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-07-31', NULL, NULL, NULL);

-- 76-80. August 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-871TYT3658', 'Walkie Talkie', 'White Villa', '871TYT3658', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Nalusiba Angella', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-07-31', NULL, NULL, NULL),
('Motorola-871TYT6706', 'Walkie Talkie', 'White Villa', '871TYT6706', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Rajesh Etyala', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-07-31', NULL, NULL, NULL),
('Motorola-871TYT3551', 'Walkie Talkie', 'White Villa', '871TYT3551', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Han Thu Lin', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-08-05', NULL, NULL, NULL),
('Motorola-682TVB0240', 'Walkie Talkie', 'Spanish Villa', '682TVB0240', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Judy Ann Galardo', get_department_id('F&B'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-09-09', NULL, NULL, NULL),
('Motorola-682TTM3715', 'Walkie Talkie', 'Head Office', '682TTM3715', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Kelly Jane Gawal', get_department_id('F&B'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-09-09', NULL, NULL, NULL);

-- 81-85. September 2025 Batch
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVD0950', 'Walkie Talkie', 'White Villa', '682TVD0950', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Catherine Reotorio', get_department_id('Housekeeping'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-09-22', NULL, NULL, NULL),
('Motorola-682TVD1440', 'Walkie Talkie', 'Spanish Villa', '682TVD1440', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Emelita Pingot', get_department_id('Housekeeping'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-09-22', NULL, NULL, NULL),
('Motorola-871TYT3401', 'Walkie Talkie', 'Spanish Villa', '871TYT3401', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Vibin Thomas Menachery Thomas', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-09-22', NULL, NULL, NULL),
('Motorola-682TVB0766', 'Walkie Talkie', 'Al Rakna', '682TVB0766', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Javyee Cancino', get_department_id('Housekeeping'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie', '2025-09-25', NULL, NULL, NULL),
('Motorola-682TTR3919', 'Walkie Talkie', 'White Villa', '682TTR3919', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Marriane Marcelo', get_department_id('Housekeeping'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie', '2025-09-25', NULL, NULL, NULL);

-- 86-90. October-November 2025 Batch (Latest)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    specifications, issue_date, transferred_date, previous_owner, notes
) VALUES
('Motorola-682TVB0840', 'Walkie Talkie', 'Spanish Villa', '682TVB0840', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Angela Ilona Kotan', get_department_id('Housekeeping'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-10-13', NULL, NULL, NULL),
('Motorola-682TTH2217', 'Walkie Talkie', 'Spanish Villa', '682TTH2217', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Maria Laeticia Santhosh', get_department_id('Housekeeping'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-10-13', NULL, NULL, NULL),
('Motorola-871TYT4187', 'Walkie Talkie', 'Spanish Villa', '871TYT4187', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Sagar Chepuri', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-10-13', '2025-06-24', 'Edgeline May Rafael', NULL),
('Motorola-682TVB0247', 'Walkie Talkie', 'Spanish Villa', '682TVB0247', 'Motorola SL4000E', 'Motorola', '2025-09-01', 'good', 'active', 'Anastasiia Kotliarova', get_department_id('F&B'), '2027-09-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-11-11', NULL, NULL, NULL),
('Motorola-871TYT5323', 'Walkie Talkie', 'Spanish Villa', '871TYT5323', 'Motorola DP4800E', 'Motorola', '2025-01-01', 'good', 'active', 'Dyah Wulandari', get_department_id('Housekeeping'), '2027-01-01', 0, 0, NULL, 'Walkie Talkie w/Earpiece and Charger', '2025-11-16', NULL, NULL, NULL);

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count walkie talkie assets
SELECT COUNT(*) as total_walkie_talkies FROM assets WHERE category = 'Walkie Talkie';

-- Walkie talkie summary by model
SELECT 
    model,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count
FROM assets 
WHERE category = 'Walkie Talkie'
GROUP BY model
ORDER BY count DESC;

-- Walkie talkie summary by department
SELECT 
    d.name as department,
    COUNT(a.id) as walkie_talkie_count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Walkie Talkie'
GROUP BY d.name
ORDER BY walkie_talkie_count DESC;

-- Recently issued walkie talkies (2025)
SELECT 
    name,
    model,
    assigned_to,
    location,
    issue_date,
    specifications
FROM assets 
WHERE category = 'Walkie Talkie' 
  AND issue_date >= '2025-01-01'
ORDER BY issue_date DESC
LIMIT 20;

-- Walkie talkies with transfers (previous owners)
SELECT 
    name,
    model,
    assigned_to,
    previous_owner,
    transferred_date,
    location
FROM assets 
WHERE category = 'Walkie Talkie' 
  AND previous_owner IS NOT NULL
ORDER BY transferred_date DESC;

-- Walkie talkies by location
SELECT 
    location,
    COUNT(*) as count
FROM assets 
WHERE category = 'Walkie Talkie'
GROUP BY location
ORDER BY count DESC;

-- View latest DP4800E models (professional grade)
SELECT 
    name,
    model,
    serial_number,
    assigned_to,
    location,
    issue_date
FROM assets 
WHERE category = 'Walkie Talkie'
  AND model LIKE '%DP4800E%'
ORDER BY issue_date DESC;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Walkie Talkie Import Complete!';
    RAISE NOTICE '📻 Total Walkie Talkies: %', (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie');
    RAISE NOTICE '🔧 Motorola SL400e/SL4000e: %', (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND model LIKE '%SL400%');
    RAISE NOTICE '🔧 Motorola SL1600/SL1600e: %', (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND model LIKE '%SL1600%');
    RAISE NOTICE '📡 Motorola DP4800E (Professional): %', (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND model LIKE '%DP4800E%');
    RAISE NOTICE '📍 Primary Locations: Spanish Villa (%), White Villa (%), Head Office (%)', 
        (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND location = 'Spanish Villa'),
        (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND location = 'White Villa'),
        (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND location = 'Head Office');
    RAISE NOTICE '🔄 Devices with Transfers: %', (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND previous_owner IS NOT NULL);
    RAISE NOTICE '✨ Active Devices: %', (SELECT COUNT(*) FROM assets WHERE category = 'Walkie Talkie' AND status = 'active');
    RAISE NOTICE '🏢 Top Departments: Housekeeping, F&B, Maintenance, Laundry';
END $$;
