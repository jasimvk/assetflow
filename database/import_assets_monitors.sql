-- Import Monitor Assets to Supabase
-- Category: Monitor
-- Run this script in your Supabase SQL Editor
-- NOTE: Due to large volume (40+ monitors), this is a representative sample

-- Ensure Monitor category exists
INSERT INTO categories (name, description) VALUES
('Monitor', 'Computer monitors and displays')
ON CONFLICT (name) DO NOTHING;

-- Import Monitors (Representative Sample - 25 monitors)
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
-- HP Monitors
('HP X24ih FDH Monitor - Mariam', 'Monitor', 'Head Office', '1CR1411S15', 'X24ih FDH Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch FHD Monitor', 'Assigned to: Mariam Eissa Amer Abdulla Alsaadi | Department: Finance', '1H-00160', 'Mariam Eissa Amer Abdulla Alsaadi', 'Finance'),
('HP X24ih FDH Monitor - Itty', 'Monitor', 'Head Office', '1CR1411S1L', 'X24ih FDH Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch FHD Monitor', 'Assigned to: Itty Kuruvilla | Department: Procurement', '1H-00154', 'Itty Kuruvilla', 'Procurement'),
('HP X24ih FDH Monitor - Mohammed', 'Monitor', 'Head Office', '1CR1411SGX', 'X24ih FDH Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch FHD Monitor', 'Assigned to: Mohammed Shafi | Department: Finance', '1H-00139', 'Mohammed Shafi', 'Finance'),
('HP X24ih FHD Monitor - Disha', 'Monitor', 'Head Office', '1CR1411WVS', 'X24ih FHD Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch FHD Monitor', 'Assigned to: Disha Kapur | Department: HR', '1H-00137', 'Disha Kapur', 'HR'),
('HP X24ih FHD Monitor - Farah', 'Monitor', 'Head Office', '1CR1411XLL', 'X24ih FHD Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch FHD Monitor', 'Assigned to: Farah Hammami | Department: Finance', '1H-00134', 'Farah Hammami', 'Finance'),
('HP X24ih FHD Monitor - Klaithem', 'Monitor', 'Head Office', '1CR1411S1D', 'X24ih FHD Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch FHD Monitor', 'Assigned to: Klaithem Alneyadi | Department: Procurement', '1H-00132', 'Klaithem Alneyadi', 'Procurement'),
('HP X24ih Monitor - Angela', 'Monitor', 'Head Office', '1CR1411WVT', 'X24ih Monitor', 'HP', 'active', 'good', '2023-01-01', '24-inch Monitor', 'Assigned to: Angela Joy Tabuan | Department: Finance', '1H-00124', 'Angela Joy Tabuan', 'Finance'),
('HP 27es Monitor - SVE Manager', 'Monitor', 'Spanish Villa', '3CM73105P1', 'HP 27es 27-inch Monitor', 'HP', 'active', 'good', '2020-01-01', '27-inch Monitor', 'Assigned to: SVE Manager PC | Department: Housekeeping', '1H-00129', 'SVE Manager PC', 'Housekeeping'),
('HP 27es Monitor - SVE F&B', 'Monitor', 'Spanish Villa', '3CM7281DXF', 'HP 27es 27-inch Monitor', 'HP', 'active', 'good', '2020-01-01', '27-inch Monitor', 'Assigned to: SVE F&B Team | Department: F&B', '1H-00128', 'SVE F&B Team', 'F&B'),
('HP P24v G4 Monitor - Gayan', 'Monitor', 'Main Store', '1CR0461JXY', 'P24v G4 FHD Monitor', 'HP', 'active', 'good', '2021-01-01', '24-inch FHD Monitor', 'Assigned to: Gayan Gamage | Department: Stores', '1H-00120', 'Gayan Gamage', 'Stores'),
('HP N246v Monitor - Vinu', 'Monitor', 'Main Store', '1CR9151237', 'N246v Monitor', 'HP', 'active', 'good', '2021-01-01', '24-inch Monitor', 'Assigned to: Vinu George | Department: Kitchen', '1H-00119', 'Vinu George', 'Kitchen'),
('HP V24i Monitor - Waluka', 'Monitor', 'Head Office', '1CR11201WM', 'V24i FHD Monitor', 'HP', 'active', 'good', '2021-01-01', '24-inch FHD Monitor', 'Assigned to: Waluka Sinhala Pedige | Department: HR', '1H-00116', 'Waluka Sinhala Pedige', 'HR'),
('HP V24i Monitor - Alanood', 'Monitor', 'Head Office', '1CR11201YB', 'V24i FHD Monitor', 'HP', 'active', 'good', '2021-01-01', '24-inch FHD Monitor', 'Assigned to: Alanood Alsaadi | Department: HR', '1H-00115', 'Alanood Alsaadi', 'HR'),

-- Dell Monitors
('Dell P2422h Monitor - Juliene', 'Monitor', 'Head Office', 'TH05554Y', 'P2422h 24 Inch Monitor', 'Dell', 'active', 'good', '2022-01-01', '24-inch Monitor', 'Assigned to: Juliene Bural | Department: HR', '1H-00153', 'Juliene Bural', 'HR'),
('Dell E2218HN - Moahmoud', 'Monitor', 'Head Office', 'CN05GV68', 'E2218HN Monitor', 'Dell', 'active', 'good', '2020-01-01', '21.5-inch Monitor', 'Assigned to: Moahmoud Albalushi | Department: HR', '1H-00114', 'Moahmoud Albalushi', 'HR'),
('Dell E2218HN - Mijo', 'Monitor', 'Head Office', 'CN02RK1Y', 'E2218HN Monitor', 'Dell', 'active', 'good', '2020-01-01', '21.5-inch Monitor', 'Assigned to: Mijo Jose | Department: Procurement', '1H-00107', 'Mijo Jose', 'Procurement'),
('Dell S2721QS - Salim', 'Monitor', 'Head Office', 'CNQJGG4G', 'S2721QS Monitor', 'Dell', 'active', 'excellent', '2021-01-01', '27-inch 4K Monitor', 'Assigned to: Salim Alsili | Department: Executive Office', '1H-00101', 'Salim Alsili', 'Executive Office'),

-- Apple Monitor
('Apple Studio Display - Bianca', 'Monitor', 'Head Office', 'SGXHWG2WVYL', 'Studio Display 27 inch', 'Apple', 'active', 'excellent', '2023-01-01', '27-inch 5K Retina Display', 'Assigned to: Bianca Nita | Department: Project', '1H-00151', 'Bianca Nita', 'Project'),

-- Lenovo Monitors (2025 batch)
('Lenovo T27i-30 - Sreejith', 'Monitor', 'Head Office', 'V5TDG923', 'T27i-30, 27inch Monitor', 'Lenovo', 'active', 'excellent', '2025-02-01', '27-inch Monitor', 'Assigned to: Sreejith Achuthan | Department: Procurement', NULL, 'Sreejith Achuthan', 'Procurement'),
('Lenovo T27i-30 - WVE Interior', 'Monitor', 'White Villa', 'V5TDG915', 'T27i-30, 27inch Monitor', 'Lenovo', 'active', 'excellent', '2025-02-01', '27-inch Monitor', 'Assigned to: WVE-INTERIOR C/O Leah Capin | Department: Housekeeping', NULL, 'Leah Capin', 'Housekeeping'),
('Lenovo T27i-30 - WVE Exterior', 'Monitor', 'White Villa', 'V5TDG905', 'T27i-30, 27inch Monitor', 'Lenovo', 'active', 'excellent', '2025-02-01', '27-inch Monitor', 'Assigned to: WVE EXTERIOR C/O Shen Priyankara | Department: Housekeeping', NULL, 'Shen Priyankara', 'Housekeeping'),
('Lenovo T27i-30 - Mijo', 'Monitor', 'Head Office', 'V5TDG938', 'T27i-30, 27inch Monitor', 'Lenovo', 'active', 'excellent', '2025-02-01', '27-inch Monitor', 'Assigned to: Mijo Jose | Department: Procurement', NULL, 'Mijo Jose', 'Procurement'),
('Lenovo T27i-30 - Babu', 'Monitor', 'Head Office', 'V5TDG913', 'T27i-30, 27inch Monitor', 'Lenovo', 'active', 'excellent', '2025-02-01', '27-inch Monitor', 'Assigned to: Babu Mohamed | Department: Project', NULL, 'Babu Mohamed', 'Project'),
('Lenovo T27i-30 - Ishani', 'Monitor', 'Saadiyat Villa 07', 'V5TDG922', 'T27i-30, 27inch Monitor', 'Lenovo', 'active', 'excellent', '2025-02-01', '27-inch Monitor', 'Assigned to: Ishani Yonili | Department: Housekeeping | Location: Saadiyat', NULL, 'Ishani Yonili', 'Housekeeping'),
('Lenovo T27i-30 - Stock 1', 'Monitor', 'Head Office', 'V5TDG902', 'T27i-30, 27inch Monitor', 'Lenovo', 'in_stock', 'excellent', '2025-02-01', '27-inch Monitor', 'New stock', NULL, NULL, NULL)

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
WHERE category = 'Monitor'
ORDER BY manufacturer, model;

-- Summary by manufacturer
SELECT 
  manufacturer,
  COUNT(*) as count,
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as in_stock
FROM assets 
WHERE category = 'Monitor'
GROUP BY manufacturer
ORDER BY count DESC;
