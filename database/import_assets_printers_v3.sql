-- ============================================================================
-- Printer Assets Import Script V3
-- AssetFlow - Complete Printer and MFP Inventory
-- ============================================================================
-- This script imports 40+ printers including multifunction printers, copiers, and specialty printers
-- 
-- IMPORTANT NOTES:
-- 1. Column order matches ALTER TABLE ADD COLUMN sequence (V1: 1-22, V2: 23-40)
-- 2. All condition values MUST be lowercase: 'excellent', 'good', 'fair', 'poor'
-- 3. All status values MUST be lowercase: 'active', 'in_stock', 'maintenance', 'retired'
-- 4. purchase_cost and current_value are required (use 0 if unknown)
-- 5. Uses get_department_id() helper function for department lookup
-- 6. assigned_to is TEXT field (stores employee names or department names)
--
-- V2 SCHEMA FIELDS INCLUDED:
-- - ip_address (Network IP addresses for networked printers)
-- - mac_address (Network MAC addresses)
-- - specifications (Configuration details like "A4/A3", "Color", "MFP")
-- - in_office_location (Specific office location within building)
-- - notes (Additional information about network setup, status, users)
--
-- PRINTER TYPES:
-- - Sharp Multifunctional Printers (High-end copier/scanner/printer combos)
-- - HP LaserJet M554 Series (Department printers)
-- - HP LaserJet Pro MFP (Villa and kitchen multifunction printers)
-- - Specialty: Fargo ID Card Printer, Zebra Label Printer, Magicard
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
-- PRINTER ASSETS IMPORT
-- ============================================================================

BEGIN;

-- Delete existing printer assets to avoid duplicates (optional - comment out if appending)
-- DELETE FROM assets WHERE category = 'Printer';

-- 1-5. High-End Multifunctional Printers and Specialty Printers
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('Sharp-3508684700', 'Printer', 'Head Office', '3508684700', 'BP-50C30 SHARP FULL-COLOUR MULTIFUNCTIONAL PRINTER', 'Sharp', '2022-01-01', 'good', 'active', 'Document controller', get_department_id('Admin'), '2025-01-01', 0, 0, '1H-00158', '192.168.1.20', 'A4/A3 Full-Colour MFP', 'Document Control', 'High-capacity copier/scanner/printer'),
('HP-CNCRR1C84R', 'Printer', 'Muroor Kitchen', 'CNCRR1C84R', 'HP Color LaserJet Pro MFP M479fnw', 'HP', '2022-01-01', 'good', 'active', 'Kitchen', get_department_id('Kitchen'), '2025-01-01', 0, 0, '1H-00157', NULL, 'Color MFP with wireless', 'Kitchen Office', NULL),
('Sharp-35001536', 'Printer', 'Spanish Villa', '35001536', 'BP-30C25 SHARP FULL-COLOUR MULTIFUNCTIONAL PRINTER', 'Sharp', '2022-01-01', 'good', 'active', 'Spanish Villa Estate', get_department_id('Housekeeping'), '2025-01-01', 0, 0, '1H-00156', NULL, 'A4/A3 Full-Colour MFP', 'Estate Office', NULL),
('Fargo-C3050205', 'Printer', 'Head Office', 'C3050205', 'Fargo HDP5000 Dual Sided ID Card Printer', 'Fargo', '2020-01-01', 'good', 'active', 'HR Department', get_department_id('HR'), '2023-01-01', 0, 0, '1H-00155', NULL, 'Dual-sided ID card printer', 'HR Office', 'For employee ID cards'),
('HP-CNCRQ8D4DC', 'Printer', 'Main Store', 'CNCRQ8D4DC', 'HP Color LaserJet Pro MFP M479FDW', 'HP', '2021-01-01', 'good', 'active', 'Store', get_department_id('Store'), '2024-01-01', 0, 0, '1H-00117', NULL, 'Color MFP with wireless', 'Store Office', NULL);

-- 6-10. Label Printers and Kitchen Printers
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('Zebra-D5J223303059', 'Printer', 'Head Office', 'D5J223303059', 'Zebra ZD220 Label Printer', 'Zebra', '2020-01-01', 'good', 'active', 'IT Department', get_department_id('IT'), '2023-01-01', 0, 0, '1H-00094', 'USB', 'Thermal label printer', 'IT Office', 'USB connected'),
('Magicard-74F6007', 'Printer', 'Head Office', '74F6007', 'Enduro NEO by Magicard', 'Magicard', '2020-01-01', 'good', 'active', 'HR Department', get_department_id('HR'), '2023-01-01', 0, 0, '1H-00093', 'USB', 'ID card printer', 'HR Office', 'USB connected'),
('HP-VNBNL1H8FY', 'Printer', 'Wathba Kitchen', 'VNBNL1H8FY', 'HP Color LaserJet Pro MFP M281fdw', 'HP', '2020-01-01', 'good', 'active', 'Kitchen', get_department_id('Kitchen'), '2023-01-01', 0, 0, '1H-00092', 'USB', 'Color MFP', 'Kitchen Office', 'USB connected'),
('HP-CNCRNCP1CC', 'Printer', 'Catering Kitchen', 'CNCRNCP1CC', 'HP Color LaserJet Pro MFP M479fdn', 'HP', '2020-01-01', 'good', 'active', 'Kitchen', get_department_id('Kitchen'), '2023-01-01', 0, 0, '1H-00091', 'USB', 'Color MFP', 'Catering Kitchen', 'USB connected'),
('HP-1H00090', 'Printer', 'Al Rakna', NULL, 'HP Color LaserJet Pro MFP M283fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00090', NULL, 'Color MFP', 'Villa Office', 'Serial number unknown');

-- 11-15. Villa Printers (Barari, Saadiyat)
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('HP-VNCKM1163K', 'Printer', 'Barari Villa 1504', 'VNCKM1163K', 'HP Color LaserJet Pro MFP M477fdw', 'HP', '2019-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2022-01-01', 0, 0, '1H-00089', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-VNCKM1162Q', 'Printer', 'Barari Villa 1009', 'VNCKM1162Q', 'HP Color LaserJet Pro MFP M477fdw', 'HP', '2019-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2022-01-01', 0, 0, '1H-00088', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-1H00087', 'Printer', 'Saadiyat Villa 43', NULL, 'HP Color LaserJet Pro MFP M477fdw', 'HP', '2019-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2022-01-01', 0, 0, '1H-00087', NULL, 'Color MFP', 'Villa Office', 'Serial number unknown'),
('HP-VNCKLDFGCB', 'Printer', 'Saadiyat Villa 7', 'VNCKLDFGCB', 'HP Color LaserJet Pro MFP M477fdw', 'HP', '2019-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2022-01-01', 0, 0, '1H-00086', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-1H00085', 'Printer', 'Saadiyat Apartment 5202', NULL, 'HP Color LaserJet Pro MFP M283fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00085', NULL, 'Color MFP', 'Apartment Office', 'Serial number unknown');

-- 16-20. White Villa Printers
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('HP-1H00084', 'Printer', 'White Villa', NULL, 'HP Color LaserJet Pro MFP M281fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00084', NULL, 'Color MFP', 'Villa Office', 'Serial number unknown'),
('HP-VNBNL6S9HZ', 'Printer', 'White Villa', 'VNBNL6S9HZ', 'HP Color LaserJet Pro MFP M281fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00083', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-VNBNM1W89Q', 'Printer', 'White Villa', 'VNBNM1W89Q', 'HP Color LaserJet Pro MFP M281fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00082', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-VNB8JCHFQL', 'Printer', 'White Villa', 'VNB8JCHFQL', 'HP Color LaserJet Pro MFP M277fdw', 'HP', '2018-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2021-01-01', 0, 0, '1H-00077', 'USB', 'Color MFP', 'Villa Office', 'USB connected - Older model'),
('HP-VNBKL8P23K', 'Printer', 'Head Office', 'VNBKL8P23K', 'HP Color LaserJet MFP M4777FDW', 'HP', '2019-01-01', 'good', 'active', 'Store', get_department_id('Store'), '2022-01-01', 0, 0, '1H-00076', 'USB', 'Color MFP', 'Store', 'USB connected');

-- 21-25. Al Rawda and Al Rakna Villa Printers
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('HP-VNBKK56688', 'Printer', 'Al Rowda', 'VNBKK56688', 'HP Color LaserJet Pro MFP M477fdw', 'HP', '2019-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2022-01-01', 0, 0, '1H-00081', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-VNBRN9D07L', 'Printer', 'Al Rakna', 'VNBRN9D07L', 'HP Color LaserJet Pro MFP M283fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00080', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-VNBKN7D2PC', 'Printer', 'Al Rakna', 'VNBKN7D2PC', 'HP Color LaserJet Pro MFP M283fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, '1H-00079', 'USB', 'Color MFP', 'Villa Office', 'USB connected'),
('HP-CNCRN8558B', 'Printer', 'Ladies Staff Accommodation', 'CNCRN8558B', 'HP Color LaserJet Pro MFP M479fdn', 'HP', '2020-01-01', 'good', 'active', 'Security', get_department_id('Security'), '2023-01-01', 0, 0, '1H-00078', 'USB', 'Color MFP', 'Staff Accommodation Office', 'USB connected'),
('HP-VNBKKD23CP', 'Printer', 'Spanish Villa', 'VNBKKD23CP', 'HP Color LaserJet Pro MFP M477fdw', 'HP', '2019-01-01', 'good', 'active', 'SVE Manager Office', get_department_id('Housekeeping'), '2022-01-01', 0, 0, '1H-00075', '10.10.9.142', 'Color MFP', 'SVE Manager Office', 'Network from Villa IT support');

-- 26-30. Spanish Villa, Store, and Kitchen Network Printers
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('HP-CNBKKC7K4S', 'Printer', 'Spanish Villa', 'CNBKKC7K4S', 'HP LaserJet Pro 500 Color MFP M570dn', 'HP', '2018-01-01', 'good', 'active', 'Spanish Villa Estate Office', get_department_id('Housekeeping'), '2021-01-01', 0, 0, '1H-00074', '10.10.9.75', 'Color MFP', 'Estate Office', 'Network from Villa IT support'),
('HP-VNBRP1GG03', 'Printer', 'Main Store', 'VNBRP1GG03', 'HP Color LaserJet MFP M283fdw', 'HP', '2020-01-01', 'good', 'active', 'Store', get_department_id('Store'), '2023-01-01', 0, 0, '1H-00073', 'USB', 'Color MFP', 'Store', 'USB - within HQ premises'),
('HP-VNBRP390XF', 'Printer', 'Muroor Kitchen', 'VNBRP390XF', 'HP Color LaserJet MFP M283FDW', 'HP', '2020-01-01', 'good', 'active', 'Kitchen', get_department_id('Kitchen'), '2023-01-01', 0, 0, '1H-00072', '192.168.1.75', 'Color MFP', 'Kitchen Office', 'Within HQ premises'),
('Sharp-1509108500', 'Printer', 'Head Office', '1509108500', 'Sharp MX-3051 Copier Machine', 'Sharp', '2019-01-01', 'good', 'active', 'Admin Dept.', get_department_id('Admin'), '2022-01-01', 0, 0, '1H-00071', '192.168.1.22', 'High-capacity copier', 'Admin Office', 'Naresh - admin office'),
('HP-JPBBQ1B07X', 'Printer', 'Head Office', 'JPBBQ1B07X', 'HP Color LaserJet MFP M578', 'HP', '2020-01-01', 'good', 'active', 'Operation Dept.', get_department_id('Operations'), '2023-01-01', 0, 0, '1H-00070', '192.168.1.77', 'Color MFP', 'Operation next to Flori office', NULL);

-- 31-35. Head Office Department Printers
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('HP-VNC5233548', 'Printer', 'Head Office', 'VNC5233548', 'HP Color LaserJet M254NW', 'HP', '2019-01-01', 'good', 'active', 'Procurement Dept.', get_department_id('Procurement'), '2022-01-01', 0, 0, '1H-00069', '192.168.1.76', 'Color Printer', 'Htet office', NULL),
('HP-CNCKL869QN', 'Printer', 'Head Office', 'CNCKL869QN', 'HP LaserJet 500 Color MFP M570DN', 'HP', '2018-01-01', 'fair', 'retired', 'Operation Dept.', get_department_id('Operations'), '2021-01-01', 0, 0, '1H-00068', '192.168.1.79', 'Color MFP', 'Operation', 'Removed'),
('HP-JPBRP4485G', 'Printer', 'Head Office', 'JPBRP4485G', 'HP Color LaserJet M554 Printer', 'HP', '2021-01-01', 'excellent', 'active', 'HR Department', get_department_id('HR'), '2024-01-01', 0, 0, '1H-00067', '192.168.1.192', 'Color Printer', 'HR Office', 'Disha'),
('HP-JPBRP4480V', 'Printer', 'Head Office', 'JPBRP4480V', 'HP Color LaserJet M554 Printer', 'HP', '2021-01-01', 'excellent', 'active', 'Operation Dept.', get_department_id('Operations'), '2024-01-01', 0, 0, '1H-00066', '192.168.1.68', 'Color Printer', 'Adina office', NULL),
('HP-JPBRP4485S', 'Printer', 'Head Office', 'JPBRP4485S', 'HP Color LaserJet M554 Printer', 'HP', '2021-01-01', 'excellent', 'active', 'Finance Department', get_department_id('Finance'), '2024-01-01', 0, 0, '1H-00065', NULL, 'Color Printer', 'Finance', NULL);

-- 36-38. Executive Office Printers and Santorini
INSERT INTO assets (
    name, category, location, serial_number, model, manufacturer,
    purchase_date, condition, status, assigned_to, department_id,
    warranty_expiry, purchase_cost, current_value, asset_code,
    ip_address, specifications, in_office_location, notes
) VALUES
('HP-JPBRP448CS', 'Printer', 'Head Office', 'JPBRP448CS', 'HP Color LaserJet M554 Printer', 'HP', '2021-01-01', 'excellent', 'active', 'Admin Office', get_department_id('Admin'), '2024-01-01', 0, 0, '1H-00064', '192.168.156', 'Color Printer', 'Salim office', NULL),
('HP-JPBRP44866', 'Printer', 'Head Office', 'JPBRP44866', 'HP Color LaserJet M554 Printer', 'HP', '2021-01-01', 'excellent', 'active', 'CEO Office', get_department_id('Executive Office'), '2024-01-01', 0, 0, '1H-00063', '192.168.1.80', 'Color Printer', 'Rudy office', 'CEO office printer'),
('HP-VNBKN3Y1X2', 'Printer', 'Santorini Villa', 'VNBKN3Y1X2', 'HP Color LaserJet Pro MFP M283fdw', 'HP', '2020-01-01', 'good', 'active', 'Housekeeping', get_department_id('Housekeeping'), '2023-01-01', 0, 0, NULL, 'USB', 'Color MFP', 'Villa Office', 'USB connected');

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count printer assets
SELECT COUNT(*) as total_printers FROM assets WHERE category = 'Printer';

-- Printer summary by manufacturer
SELECT 
    manufacturer,
    COUNT(*) as count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count
FROM assets 
WHERE category = 'Printer'
GROUP BY manufacturer
ORDER BY count DESC;

-- Printers by location type
SELECT 
    CASE 
        WHEN location = 'Head Office' THEN 'Head Office'
        WHEN location LIKE '%Villa%' THEN 'Villas'
        WHEN location LIKE '%Kitchen%' THEN 'Kitchens'
        WHEN location LIKE '%Store%' THEN 'Stores'
        ELSE 'Other'
    END as location_type,
    COUNT(*) as count
FROM assets 
WHERE category = 'Printer'
GROUP BY location_type
ORDER BY count DESC;

-- Network vs USB connected printers
SELECT 
    CASE 
        WHEN ip_address IS NOT NULL AND ip_address NOT LIKE '%USB%' THEN 'Network'
        WHEN ip_address = 'USB' OR ip_address IS NULL THEN 'USB/Local'
        ELSE 'Unknown'
    END as connection_type,
    COUNT(*) as count
FROM assets 
WHERE category = 'Printer'
GROUP BY connection_type
ORDER BY count DESC;

-- High-end printers (M554 series, Sharp MFP, specialty)
SELECT 
    name,
    model,
    location,
    ip_address,
    in_office_location,
    assigned_to,
    notes
FROM assets 
WHERE category = 'Printer'
  AND (model LIKE '%M554%' OR model LIKE '%Sharp%' OR model LIKE '%Fargo%' OR model LIKE '%Zebra%' OR model LIKE '%Magicard%')
ORDER BY model;

-- Villa printers
SELECT 
    name,
    model,
    location,
    serial_number,
    asset_code,
    ip_address
FROM assets 
WHERE category = 'Printer'
  AND location LIKE '%Villa%'
ORDER BY location, asset_code;

-- Retired/removed printers
SELECT 
    name,
    model,
    location,
    status,
    notes
FROM assets 
WHERE category = 'Printer'
  AND (status = 'retired' OR notes LIKE '%Removed%')
ORDER BY location;

-- Printers by department
SELECT 
    d.name as department,
    COUNT(a.id) as printer_count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Printer'
  AND a.status = 'active'
GROUP BY d.name
ORDER BY printer_count DESC;

-- Network printers with IP addresses
SELECT 
    name,
    model,
    ip_address,
    location,
    in_office_location,
    assigned_to
FROM assets 
WHERE category = 'Printer'
  AND ip_address IS NOT NULL
  AND ip_address NOT LIKE '%USB%'
ORDER BY ip_address;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    total_count INTEGER;
    hp_count INTEGER;
    sharp_count INTEGER;
    specialty_count INTEGER;
    network_count INTEGER;
    villa_count INTEGER;
    hq_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM assets WHERE category = 'Printer';
    SELECT COUNT(*) INTO hp_count FROM assets WHERE category = 'Printer' AND manufacturer = 'HP';
    SELECT COUNT(*) INTO sharp_count FROM assets WHERE category = 'Printer' AND manufacturer = 'Sharp';
    SELECT COUNT(*) INTO specialty_count FROM assets WHERE category = 'Printer' AND (manufacturer IN ('Fargo', 'Zebra', 'Magicard'));
    SELECT COUNT(*) INTO network_count FROM assets WHERE category = 'Printer' AND ip_address IS NOT NULL AND ip_address NOT LIKE '%USB%';
    SELECT COUNT(*) INTO villa_count FROM assets WHERE category = 'Printer' AND location LIKE '%Villa%';
    SELECT COUNT(*) INTO hq_count FROM assets WHERE category = 'Printer' AND location = 'Head Office';

    RAISE NOTICE '✅ Printer Import Complete!';
    RAISE NOTICE '🖨️  Total Printers: %', total_count;
    RAISE NOTICE '';
    RAISE NOTICE '📊 By Manufacturer:';
    RAISE NOTICE '   - HP Printers: %', hp_count;
    RAISE NOTICE '   - Sharp MFP Copiers: %', sharp_count;
    RAISE NOTICE '   - Specialty (Fargo/Zebra/Magicard): %', specialty_count;
    RAISE NOTICE '';
    RAISE NOTICE '🌐 By Connection Type:';
    RAISE NOTICE '   - Network Printers (IP): %', network_count;
    RAISE NOTICE '   - USB/Local Printers: %', total_count - network_count;
    RAISE NOTICE '';
    RAISE NOTICE '📍 By Location:';
    RAISE NOTICE '   - Head Office: %', hq_count;
    RAISE NOTICE '   - Villas: %', villa_count;
    RAISE NOTICE '   - Kitchens: %', (SELECT COUNT(*) FROM assets WHERE category = 'Printer' AND location LIKE '%Kitchen%');
    RAISE NOTICE '';
    RAISE NOTICE '🎯 Key Features:';
    RAISE NOTICE '   - HP M554 Series (Department printers): %', (SELECT COUNT(*) FROM assets WHERE category = 'Printer' AND model LIKE '%M554%');
    RAISE NOTICE '   - Sharp High-End MFP Copiers: %', sharp_count;
    RAISE NOTICE '   - ID Card Printers (Fargo, Magicard): %', (SELECT COUNT(*) FROM assets WHERE category = 'Printer' AND (model LIKE '%Fargo%' OR model LIKE '%Magicard%'));
    RAISE NOTICE '   - Label Printer (Zebra): %', (SELECT COUNT(*) FROM assets WHERE category = 'Printer' AND model LIKE '%Zebra%');
END $$;
