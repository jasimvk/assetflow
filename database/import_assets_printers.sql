-- Import Printer Assets to Supabase
-- Category: Printer
-- Run this script in your Supabase SQL Editor
-- NOTE: Due to large volume (30+ printers), this is a representative sample

-- Ensure Printer category exists
INSERT INTO categories (name, description) VALUES
('Printer', 'Printers, scanners, copiers, and multifunction devices')
ON CONFLICT (name) DO NOTHING;

-- Import Printers (Representative Sample - 25 printers)
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
  description,
  notes,
  asset_code,
  assigned_to,
  department
) VALUES
-- Sharp Printers
('Sharp BP-50C30 Full-Colour MFP', 'Printer', 'Head Office', '3508684700', 'BP-50C30 SHARP FULL-COLOUR MULTIFUNCTIONAL PRINTER A4/A3', 'Sharp', 'active', 'good', '2020-01-01', 'Full-colour A3/A4 multifunction printer', 'IP: 192.168.1.20 | Assigned to: Document controller', '1H-00158', 'Document controller', 'Admin'),
('Sharp BP-30C25 Full-Colour MFP', 'Printer', 'Head Office', '35001536', 'BP-30C25 SHARP FULL-COLOUR MULTIFUNCTIONAL PRINTER A4/A3', 'Sharp', 'active', 'good', '2020-01-01', 'Full-colour A3/A4 multifunction printer', '', '1H-00156', NULL, NULL),
('Sharp MX-3051 Copier', 'Printer', 'Head Office', '1509108500', 'MX-3051 Copier Machine', 'Sharp', 'active', 'good', '2020-01-01', 'Multifunction copier', 'IP: 192.168.1.22 | Assigned to: Admin Dept. | Location: Naresh admin office', '1H-00071', 'Admin Dept.', 'Admin'),

-- HP Color LaserJet Pro MFP M479 Series
('HP M479fnw Color LaserJet Pro MFP', 'Printer', 'Head Office', 'CNCRR1C84R', 'Color LaserJet Pro MFP M479fnw', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer with network and wireless', '', '1H-00157', NULL, NULL),
('HP M479FDW Color LaserJet Pro MFP', 'Printer', 'Head Office', 'CNCRQ8D4DC', 'Color LaserJet Pro MFP M479FDW', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer with duplex and wireless', '', '1H-00117', NULL, NULL),
('HP M479fdn Color LaserJet Pro MFP', 'Printer', 'Head Office', 'CNCRNCP1CC', 'Color LaserJet Pro MFP M479fdn', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer with duplex and network', 'USB connection', '1H-00091', NULL, NULL),
('HP M479fdn Color LaserJet Pro MFP 2', 'Printer', 'Head Office', 'CNCRN8558B', 'Color LaserJet Pro MFP M479fdn', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer with duplex and network', 'USB connection', '1H-00078', NULL, NULL),

-- HP Color LaserJet Pro MFP M477 Series
('HP M477fdw Color LaserJet Pro MFP 1', 'Printer', 'Head Office', 'VNCKM1163K', 'Color LaserJet Pro MFP M477fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00089', NULL, NULL),
('HP M477fdw Color LaserJet Pro MFP 2', 'Printer', 'Head Office', 'VNCKM1162Q', 'Color LaserJet Pro MFP M477fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00088', NULL, NULL),
('HP M477fdw Color LaserJet Pro MFP 3', 'Printer', 'Head Office', 'VNCKLDFGCB', 'Color LaserJet Pro MFP M477fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00086', NULL, NULL),
('HP M477fdw Color LaserJet Pro MFP 4', 'Printer', 'Head Office', 'VNBKK56688', 'Color LaserJet Pro MFP M477fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00081', NULL, NULL),
('HP M477FDW - Store', 'Printer', 'Main Store', 'VNBKL8P23K', 'Color LaserJet MFP M4777FDW', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection | Assigned to: Store', '1H-00076', 'Store', 'Store'),
('HP M477fdw - SVE Manager', 'Printer', 'Spanish Villa', 'VNBKKD23CP', 'Color LaserJet Pro MFP M477fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'IP: 10.10.9.142 | Network from Villa IT support | Assigned to: SVE Manager Office', '1H-00075', 'SVE Manager Office', 'Housekeeping'),

-- HP Color LaserJet Pro MFP M283 Series
('HP M283fdw Color LaserJet Pro MFP 1', 'Printer', 'Head Office', 'VNBRN9D07L', 'Color LaserJet Pro MFP M283fdw', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer', 'USB connection', '1H-00080', NULL, NULL),
('HP M283fdw Color LaserJet Pro MFP 2', 'Printer', 'Head Office', 'VNBKN7D2PC', 'Color LaserJet Pro MFP M283fdw', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer', 'USB connection', '1H-00079', NULL, NULL),
('HP M283FDW - Kitchen', 'Printer', 'Head Office', 'VNBRP390XF', 'Color LaserJet MFP M283FDW', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer', 'IP: 192.168.1.75 | Within HQ premises | Assigned to: Kitchen', '1H-00072', 'Kitchen', 'Kitchen'),
('HP M283fdw - Store', 'Printer', 'Main Store', 'VNBRP1GG03', 'Color LaserJet MFP M283fdw', 'HP', 'active', 'good', '2021-01-01', 'Color multifunction printer', 'USB connection | Within HQ premises | Assigned to: Store', '1H-00073', 'Store', 'Store'),

-- HP Color LaserJet Pro MFP M281 Series
('HP M281fdw Color LaserJet Pro MFP 1', 'Printer', 'Head Office', 'VNBNL1H8FY', 'Color LaserJet Pro MFP M281fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00092', NULL, NULL),
('HP M281fdw Color LaserJet Pro MFP 2', 'Printer', 'Head Office', 'VNBNL6S9HZ', 'Color LaserJet Pro MFP M281fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00083', NULL, NULL),
('HP M281fdw Color LaserJet Pro MFP 3', 'Printer', 'Head Office', 'VNBNM1W89Q', 'Color LaserJet Pro MFP M281fdw', 'HP', 'active', 'good', '2020-01-01', 'Color multifunction printer', 'USB connection', '1H-00082', NULL, NULL),

-- HP Color LaserJet M554 Series
('HP M554 - HR Department', 'Printer', 'Head Office', 'JPBRP4485G', 'Color LaserJet M554 Printer', 'HP', 'active', 'good', '2021-01-01', 'Color LaserJet Printer', 'IP: 192.168.1.192 | Assigned to: HR Department | Location: Disha', '1H-00067', 'HR Department', 'HR'),
('HP M554 - Operation', 'Printer', 'Head Office', 'JPBRP4480V', 'Color LaserJet M554 Printer', 'HP', 'active', 'good', '2021-01-01', 'Color LaserJet Printer', 'IP: 192.168.1.68 | Assigned to: Operation Dept. | Location: Adina office', '1H-00066', 'Operation Dept.', 'Operation'),
('HP M554 - Finance', 'Printer', 'Head Office', 'JPBRP4485S', 'Color LaserJet M554 Printer', 'HP', 'active', 'good', '2021-01-01', 'Color LaserJet Printer', 'Assigned to: Finance Department', '1H-00065', 'Finance Department', 'Finance'),
('HP M554 - Admin', 'Printer', 'Head Office', 'JPBRP448CS', 'Color LaserJet M554 Printer', 'HP', 'active', 'good', '2021-01-01', 'Color LaserJet Printer', 'IP: 192.168.156 | Assigned to: Admin Office | Location: Salim', '1H-00064', 'Admin Office', 'Admin'),
('HP M554 - CEO Office', 'Printer', 'Head Office', 'JPBRP44866', 'Color LaserJet M554 Printer', 'HP', 'active', 'good', '2021-01-01', 'Color LaserJet Printer', 'IP: 192.168.1.80 | Assigned to: CEO Office | Location: Rudy', '1H-00063', 'CEO Office', 'Executive Office'),

-- Specialty Printers
('Fargo HDP5000 ID Card Printer', 'Printer', 'Head Office', 'C3050205', 'Fargo HDP5000 Dual Sided ID Card Printer', 'Fargo', 'active', 'good', '2020-01-01', 'Dual-sided ID card printer', '', '1H-00155', NULL, 'IT'),
('Zebra ZD220 Label Printer', 'Printer', 'Head Office', 'D5J223303059', 'Zebra ZD220 Lebel Printer', 'Zebra', 'active', 'good', '2021-01-01', 'Label printer', 'USB connection', '1H-00094', NULL, NULL)

ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  manufacturer,
  model,
  serial_number,
  assigned_to,
  department,
  status,
  asset_code
FROM assets 
WHERE category = 'Printer'
ORDER BY manufacturer, model;

-- Summary by manufacturer
SELECT 
  manufacturer,
  COUNT(*) as count
FROM assets 
WHERE category = 'Printer'
GROUP BY manufacturer
ORDER BY count DESC;

-- Summary by department
SELECT 
  department,
  COUNT(*) as count
FROM assets 
WHERE category = 'Printer' AND department IS NOT NULL
GROUP BY department
ORDER BY count DESC;
