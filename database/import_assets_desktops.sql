-- Import Desktop Assets to Supabase
-- Category: Desktop
-- Run this script in your Supabase SQL Editor
-- NOTE: Due to large volume (30+ desktops), this is a representative sample

-- Ensure Desktop category exists
INSERT INTO categories (name, description) VALUES
('Desktop', 'Desktop computers and workstations')
ON CONFLICT (name) DO NOTHING;

-- Import Desktops (Representative Sample - 20 desktops)
INSERT INTO assets (
  name, 
  category, 
  location, 
  serial_number,
  model,
  manufacturer,
  status,
  condition,
  purchase_date,
  warranty_expiry,
  description,
  notes,
  assigned_to,
  department
) VALUES
-- HP Pro Tower 290 G9
('ONEH-RANJEET', 'Desktop', 'Head Office', '4CE323CR0Q', 'Pro Tower 290 G9', 'HP', 'active', 'good', '2023-10-19', '2025-10-18', 'Windows 11 Pro | 8 GB | i5-12400 | 500 GB', 'Assigned to: Ranjeet Yadav | Department: Finance | Location: Document Control Office | Domain joined', 'Ranjeet Yadav', 'Finance'),
('ONEH-SUNITA', 'Desktop', 'Head Office', '4CE334D27Y', 'Pro Tower 290 G9', 'HP', 'active', 'good', '2023-11-14', '2025-12-13', 'Windows 11 Pro | 16 GB | i7-12700 | 512 GB', 'Assigned to: Sunita Ghale | Department: Finance | Domain joined', 'Sunita Ghale', 'Finance'),
('ONEH-MARIAM', 'Desktop', 'Head Office', '4CE334D25V', 'Pro Tower 290 G9', 'HP', 'active', 'good', '2023-11-15', '2025-12-14', 'Windows 11 Pro | 16 GB | i7-12700 | 512 GB', 'Assigned to: Mariam Eissa Amer Abdulla Alsaadi | Department: Finance | Domain joined | Location: Admin Office', 'Mariam Eissa Amer Abdulla Alsaadi', 'Finance'),
('ONEH-KLAITHEM', 'Desktop', 'Head Office', '4CE334D214', 'Pro Tower 290 G9', 'HP', 'active', 'good', '2023-11-14', '2025-11-13', 'Windows 11 Pro | 16 GB | i7-12700 | 512 GB', 'Assigned to: Klaithem Alneyadi | Department: Procurement | Domain joined | Location: Admin Office', 'Klaithem Alneyadi', 'Procurement'),

-- HP ProDesk 400 G7
('ONEH-ANGELA', 'Desktop', 'Head Office', '4CE202CCMY', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2022-03-31', '2023-03-30', 'Windows 11 Pro | 16 GB | i7-10700 | 500 GB', 'Assigned to: Angela Joy Tabuan | Department: Finance | Domain joined | Location: Finance Office', 'Angela Joy Tabuan', 'Finance'),
('DESKTOP-GAYAN', 'Desktop', 'Main Store', 'CZC10471XX', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2021-02-02', '2022-03-03', 'Windows 11 Pro | 16 GB | i7-10700 | 1 TB', 'Assigned to: Gayan Gamage | Department: Store | Location: Main Store', 'Gayan Gamage', 'Store'),
('ONEH-ALANOOD', 'Desktop', 'Head Office', 'CZC1249Z9F', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2021-07-29', '2022-07-28', 'Windows 11 Pro | 8 GB | i5-10500 | 500 GB', 'Assigned to: Alanood Alsaadi | Department: HR | Domain joined | Location: Admin Office', 'Alanood Alsaadi', 'HR'),

-- HP 290 G4
('ONEH-FARAH', 'Desktop', 'Head Office', '4CE142B9RK', 'HP 290 G4 Microtower', 'HP', 'active', 'good', '2021-12-29', '2022-12-28', 'Windows 11 Pro | 16 GB | i7-10700 | 500 GB', 'Assigned to: Farah Hammami | Department: Finance | Domain joined | Location: Finance Office', 'Farah Hammami', 'Finance'),
('ONEH-MAHMOOD', 'Desktop', 'Head Office', 'CZC1058FS0', 'ProDesk 400 G7 Microtower', 'HP', 'active', 'good', '2021-02-08', '2022-03-09', 'Windows 11 Pro | 8 GB | i5-10500 | 500 GB', 'Assigned to: Moahmoud Albalushi | Department: HR | Domain joined | Location: Admin Office', 'Moahmoud Albalushi', 'HR'),
('DESKTOP-Security Gate HO', 'Desktop', 'Head Office', '4CE124X5F0', 'HP 290 G4 Microtower', 'HP', 'active', 'good', '2021-08-22', '2023-08-21', 'Windows 11 Pro | 8 GB | i5-10500 | 500 GB', 'Assigned to: Rohit | Department: Security', 'Rohit', 'Security'),

-- Lenovo ThinkCentre M70q G4 (2025 batch)
('ONEH-WVE-INTERI', 'Desktop', 'White Villa', 'GM0N9B25', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: WVE-INTERIOR C/O Leah Capin | Department: Housekeeping | Location: White Villa', 'Leah Capin', 'Housekeeping'),
('ONEH-WVE-EXT', 'Desktop', 'White Villa', 'GM0N9B24', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: WVE EXTERIOR C/O Shen Priyankara | Department: Housekeeping | Location: White Villa', 'Shen Priyankara', 'Housekeeping'),
('ONEH-MIJO', 'Desktop', 'Main Office', 'GM0N9B2W', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: Mijo Jose | Department: Procurement | Domain joined | Location: Procurement Office', 'Mijo Jose', 'Procurement'),
('ONEH-SREEJITH', 'Desktop', 'Main Office', 'GM0N9B2D', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: Sreejith Achuthan | Department: Procurement | Domain joined | Location: Procurement Office', 'Sreejith Achuthan', 'Procurement'),
('SVE-HK-INTERIOR', 'Desktop', 'Spanish Villa', 'GM0N9B2B', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: SVE-HK | Department: Housekeeping | Location: Spanish Villa', 'SVE-HK', 'Housekeeping'),
('DESKTOP-SYV-HK', 'Desktop', 'Saadiyat Villa 7', 'GM0N9B1L', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: Ishani Yonili | Department: Housekeeping | Location: Saadiyat', 'Ishani Yonili', 'Housekeeping'),
('ONEH-HASNA-DESK', 'Desktop', 'Head Office', 'GM0N9B1R', 'ThinkCentre M70q G4', 'Lenovo', 'active', 'excellent', '2025-02-10', '2028-02-09', 'Windows 11 Pro | 16 GB | i7-13700T | 512 GB', 'Assigned to: Hasna | Department: HR | Domain joined | Location: HR Office', 'Hasna', 'HR'),

-- Kitchen Desktops
('QURAMKITCHEN', 'Desktop', 'Muroor Kitchen', 'CZC008DFTX', 'ProDesk 400 G6 MT', 'HP', 'active', 'good', '2020-02-26', '2021-03-27', 'Windows 11 Pro | 16 GB | i7-9700', 'Assigned to: Jeo George | Department: Kitchen | Location: Muroor Kitchen', 'Jeo George', 'Kitchen'),
('DESKTOP-JIO', 'Desktop', 'Wathba Kitchen', '4CE335BY51', 'Pro Tower 290 G9', 'HP', 'active', 'good', '2024-01-11', '2025-10-01', 'Windows 11 Pro | 16 GB | i7-12700', 'Assigned to: Kitchen Store | Department: Kitchen | Location: Muroor Kitchen', 'Kitchen Store', 'Kitchen'),
('DESKTOP-WKITCHEN', 'Desktop', 'Wathba Kitchen', '4CE345DKNY', 'Pro SFF 290 G9', 'HP', 'active', 'excellent', '2024-12-03', '2025-02-12', 'Windows 11 Pro | 16 GB | i7-13700', 'Assigned to: Rubin Thomas | Department: Kitchen | Location: Muroor Kitchen', 'Rubin Thomas', 'Kitchen'),

-- Special Systems
('1H-Babu', 'Desktop', 'Main Office', '20250122084', 'HOT Ultra 9', 'HOT_Systems', 'active', 'excellent', '2025-05-01', '2026-05-01', 'Windows 11 Pro | 63 GB | Intel Ultra 9 285K | 1 TB', 'Assigned to: Babu Mohamed | Department: Projects | Location: Admin Office | High-performance workstation', 'Babu Mohamed', 'Projects')

ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  manufacturer,
  model,
  serial_number,
  assigned_to,
  department,
  status
FROM assets 
WHERE category = 'Desktop'
ORDER BY manufacturer, model, name;

-- Summary by manufacturer
SELECT 
  manufacturer,
  COUNT(*) as count,
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active
FROM assets 
WHERE category = 'Desktop'
GROUP BY manufacturer
ORDER BY count DESC;

-- Summary by location
SELECT 
  location,
  COUNT(*) as count
FROM assets 
WHERE category = 'Desktop'
GROUP BY location
ORDER BY count DESC;
