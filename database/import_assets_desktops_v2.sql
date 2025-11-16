-- Import Desktop Assets to Supabase (WITH DEPARTMENT FOREIGN KEYS)
-- Category: Desktop
-- Run this script in your Supabase SQL Editor
-- NOTE: Due to large volume (30+ desktops), this is a representative sample
-- IMPORTANT: Run departments_table.sql and department_helper.sql FIRST!

-- Ensure Desktop category exists
INSERT INTO categories (name, description) VALUES
('Desktop', 'Desktop computers and workstations')
ON CONFLICT (name) DO NOTHING;

-- Import Desktops (Representative Sample - 20 desktops)
INSERT INTO assets (
  name, 
  description,
  category, 
  location, 
  serial_number,
  model,
  manufacturer,
  purchase_date,
  condition,
  status,
  assigned_to,
  department_id,
  warranty_expiry,
  notes
) VALUES
-- HP Pro Tower 290 G9
('ONEH-RANJEET', 'Windows 11 Pro | 8 GB | i5-12400 | 500 GB', 'Desktop', 'Head Office', '4CE323CR0Q', 'Pro Tower 290 G9', 'HP', '2023-10-19', 'good', 'active', 'Ranjeet Yadav', get_department_id('Finance'), '2025-10-18', 'Assigned to: Ranjeet Yadav | Department: Finance | Location: Document Control Office | Domain joined'),
('ONEH-SUNITA', 'Windows 11 Pro | 16 GB | i7-12700 | 512 GB', 'Desktop', 'Head Office', '4CE334D27Y', 'Pro Tower 290 G9', 'HP', '2023-11-14', 'good', 'active', 'Sunita Ghale', get_department_id('Finance'), '2025-12-13', 'Assigned to: Sunita Ghale | Department: Finance | Domain joined'),
('ONEH-MARIAM', 'Windows 11 Pro | 16 GB | i7-12700 | 512 GB', 'Desktop', 'Head Office', '4CE334D25V', 'Pro Tower 290 G9', 'HP', '2023-11-15', 'good', 'active', 'Mariam Eissa Amer Abdulla Alsaadi', get_department_id('Finance'), '2025-12-14', 'Assigned to: Mariam Eissa Amer Abdulla Alsaadi | Department: Finance | Domain joined | Location: Admin Office'),
('ONEH-KLAITHEM', 'Windows 11 Pro | 16 GB | i7-12700 | 512 GB', 'Desktop', 'Head Office', '4CE334D214', 'Pro Tower 290 G9', 'HP', '2023-11-14', 'good', 'active', 'Klaithem Alneyadi', get_department_id('Procurement'), '2025-11-13', 'Assigned to: Klaithem Alneyadi | Department: Procurement | Domain joined | Location: Admin Office'),

-- HP ProDesk 400 G7
('ONEH-ANGELA', 'Desktop', 'Head Office', '4CE202CCMY', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2022-03-31', '2023-03-30', 'Assigned to: Angela Joy Tabuan | Department: Finance | Domain joined | Location: Finance Office', 'Windows 11 Pro | 16 GB | i7-10700 | 500 GB', 'Angela Joy Tabuan', get_department_id('Finance')),
('DESKTOP-GAYAN', 'Desktop', 'Main Store', 'CZC10471XX', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2021-02-02', '2022-03-03', 'Assigned to: Gayan Gamage | Department: Store | Location: Main Store', 'Windows 11 Pro | 16 GB | i7-10700 | 1 TB', 'Gayan Gamage', get_department_id('Store')),
('ONEH-ALANOOD', 'Desktop', 'Head Office', 'CZC1249Z9F', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2021-07-29', '2022-07-28', 'Assigned to: Alanood Alsaadi | Department: HR | Domain joined | Location: Admin Office', 'Windows 11 Pro | 8 GB | i5-10500 | 500 GB', 'Alanood Alsaadi', get_department_id('HR')),

-- HP 290 G4
('ONEH-FARAH', 'Desktop', 'Head Office', '4CE142B9RK', 'HP 290 G4 Microtower', 'HP', 'active', 'good', '2021-12-29', '2022-12-28', 'Assigned to: Farah Hammami | Department: Finance | Domain joined | Location: Finance Office', 'Windows 11 Pro | 16 GB | i7-10700 | 500 GB', 'Farah Hammami', get_department_id('Finance')),
('ONEH-MAHMOOD', 'Desktop', 'Head Office', 'CZC1058FS0', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2021-02-08', '2022-03-09', 'Assigned to: Moahmoud Albalushi | Department: HR | Domain joined | Location: Admin Office', 'Windows 11 Pro | 8 GB | i5-10500 | 500 GB', 'Moahmoud Albalushi', get_department_id('HR')),
('DESKTOP-Security Gate HO', 'Desktop', 'Head Office', '4CE124X5F0', 'HP 290 G4 Microtower', 'HP', 'active', 'good', '2021-08-22', '2023-08-21', 'Assigned to: Rohit | Department: Security', 'Windows 11 Pro | 8 GB | i5-10500 | 500 GB', 'Rohit', get_department_id('Security')),

-- Lenovo ThinkCentre M70q G4 (2025 batch)
('ONEH-WVE-INTERI', 'Desktop', 'White Villa', 'GM0N9B25', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: WVE-INTERIOR C/O Leah Capin | Department: Housekeeping | Location: White Villa', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Leah Capin', get_department_id('Housekeeping')),
('ONEH-WVE-EXT', 'Desktop', 'White Villa', 'GM0N9B24', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: WVE EXTERIOR C/O Shen Priyankara | Department: Housekeeping | Location: White Villa', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Shen Priyankara', get_department_id('Housekeeping')),
('ONEH-MIJO', 'Desktop', 'Main Office', 'GM0N9B2W', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: Mijo Jose | Department: Procurement | Domain joined | Location: Procurement Office', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Mijo Jose', get_department_id('Procurement')),
('ONEH-SREEJITH', 'Desktop', 'Main Office', 'GM0N9B2D', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: Sreejith Achuthan | Department: Procurement | Domain joined | Location: Procurement Office', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Sreejith Achuthan', get_department_id('Procurement')),
('SVE-HK-INTERIOR', 'Desktop', 'Spanish Villa', 'GM0N9B2B', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: SVE-HK | Department: Housekeeping | Location: Spanish Villa', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'SVE-HK', get_department_id('Housekeeping')),
('DESKTOP-SYV-HK', 'Desktop', 'Saadiyat Villa 7', 'GM0N9B1L', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: Ishani Yonili | Department: Housekeeping | Location: Saadiyat', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Ishani Yonili', get_department_id('Housekeeping')),
('ONEH-HASNA-DESK', 'Desktop', 'Head Office', 'GM0N9B1R', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Assigned to: Hasna | Department: HR | Domain joined | Location: HR Office', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Hasna', get_department_id('HR')),

-- Kitchen Desktops
('QURAMKITCHEN', 'Desktop', 'Muroor Kitchen', 'CZC008DFTX', 'ProDesk 400 G6 MT', 'HP', 'active', 'good', '2020-02-26', '2021-03-27', 'Assigned to: Jeo George | Department: Kitchen | Location: Muroor Kitchen', 'Windows 11 Pro | 16 GB | i7-9700', 'Jeo George', get_department_id('Kitchen')),
('DESKTOP-JIO', 'Desktop', 'Wathba Kitchen', '4CE335BY51', 'Pro Tower 290 G9', 'HP', 'active', 'good', '2024-01-11', '2025-10-01', 'Assigned to: Kitchen Store | Department: Kitchen | Location: Muroor Kitchen', 'Windows 11 Pro | 16 GB | i7-12700', 'Kitchen Store', get_department_id('Kitchen')),
('DESKTOP-WKITCHEN', 'Desktop', 'Wathba Kitchen', '4CE345DKNY', 'Pro SFF 290 G9', 'HP', 'active', 'excellent', '2024-12-03', '2025-02-12', 'Assigned to: Rubin Thomas | Department: Kitchen | Location: Muroor Kitchen', 'Windows 11 Pro | 16 GB | i7-13700', 'Rubin Thomas', get_department_id('Kitchen')),

-- Special Systems
('1H-Babu', 'Desktop', 'Main Office', '20250122084', 'HOT Ultra 9', 'HOT_Systems', 'active', 'excellent', '2025-05-01', '2026-05-01', 'Assigned to: Babu Mohamed | Department: Projects | Location: Admin Office | High-performance workstation', 'Windows 11 Pro | 63 GB | Intel Ultra 9 285K | 1 TB', 'Babu Mohamed', get_department_id('Projects'))

ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries WITH DEPARTMENT NAMES
SELECT 
  a.name,
  a.manufacturer,
  a.model,
  a.serial_number,
  a.assigned_to,
  d.name as department,
  a.status
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Desktop'
ORDER BY a.manufacturer, a.model, a.name;

-- Summary by manufacturer
SELECT 
  manufacturer,
  COUNT(*) as count,
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active
FROM assets 
WHERE category = 'Desktop'
GROUP BY manufacturer
ORDER BY count DESC;

-- Summary by department (with names)
SELECT 
  d.name as department,
  COUNT(a.id) as count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Desktop'
GROUP BY d.name
ORDER BY count DESC;
