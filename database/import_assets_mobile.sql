-- Import Mobile Phone & Walkie Talkie Assets to Supabase
-- Category: Mobile Phone
-- Run this script in your Supabase SQL Editor
-- NOTE: Due to large volume (60+ devices), this is a representative sample

-- Ensure Mobile Phone category exists
INSERT INTO categories (name, description) VALUES
('Mobile Phone', 'Mobile phones, smartphones, walkie talkies, and two-way radios')
ON CONFLICT (name) DO NOTHING;

-- Import Mobile Phones & Walkie Talkies (Representative Sample - 25 devices)
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
  assigned_to,
  department
) VALUES
-- Motorola DP4800E
('Motorola DP4800E - Joanna', 'Mobile Phone', 'Spanish Villa', '871TYT3561', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Joanna Marie Bautista | Department: Housekeeping | Issued: 2 Jul 2025', 'Joanna Marie Bautista', 'Housekeeping'),
('Motorola DP4800E - Abhishek', 'Mobile Phone', 'White Villa', '871TYT3101', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Abhishek Sharma | Department: Housekeeping | Issued: 31 Jul 2025', 'Abhishek Sharma', 'Housekeeping'),
('Motorola DP4800E - Daminda', 'Mobile Phone', 'White Villa', '871TYT3642', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Daminda Mudiyanselage | Department: Housekeeping | Issued: 31 Jul 2025', 'Daminda Mudiyanselage', 'Housekeeping'),
('Motorola DP4800E - Harish', 'Mobile Phone', 'White Villa', '871TYT3454', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Harish Gaje | Department: Housekeeping | Issued: 31 Jul 2025', 'Harish Gaje', 'Housekeeping'),
('Motorola DP4800E - Angella', 'Mobile Phone', 'White Villa', '871TYT3658', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Nalusiba Angella | Department: Housekeeping | Issued: 31 Jul 2025', 'Nalusiba Angella', 'Housekeeping'),
('Motorola DP4800E - Rajesh', 'Mobile Phone', 'White Villa', '871TYT6706', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Rajesh Etyala | Department: Housekeeping | Issued: 31 Jul 2025', 'Rajesh Etyala', 'Housekeeping'),
('Motorola DP4800E - Han Thu', 'Mobile Phone', 'White Villa', '871TYT3551', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Han Thu Lin | Department: Housekeeping | Issued: 5 Aug 2025', 'Han Thu Lin', 'Housekeeping'),
('Motorola DP4800E - Vibin', 'Mobile Phone', 'Spanish Villa', '871TYT3401', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Vibin Thomas Menachery Thomas | Department: Housekeeping | Issued: 22 Sep 2025', 'Vibin Thomas Menachery Thomas', 'Housekeeping'),
('Motorola DP4800E - Sagar', 'Mobile Phone', 'Spanish Villa', '871TYT4187', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Sagar Chepuri | Department: Housekeeping | Issued: 13 Oct 2025', 'Sagar Chepuri', 'Housekeeping'),
('Motorola DP4800E - Dyah', 'Mobile Phone', 'Spanish Villa', '871TYT5323', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Dyah Wulandari | Department: Housekeeping', 'Dyah Wulandari', 'Housekeeping'),
('Motorola DP4800E - Regienald 1', 'Mobile Phone', 'SAS-D', '871TYT4107', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Regienald Regala | Department: Housekeeping', 'Regienald Regala', 'Housekeeping'),
('Motorola DP4800E - Regienald 2', 'Mobile Phone', 'SAS-D', '871TYT4014', 'DP4800E', 'Motorola', 'active', 'good', '2025-01-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Regienald Regala | Department: Housekeeping', 'Regienald Regala', 'Housekeeping'),

-- Motorola SL4000E
('Motorola SL4000E - Marriane', 'Mobile Phone', 'White Villa', '682TSM2254', 'SL4000e', 'Motorola', 'active', 'good', '2023-01-01', 'Walkie Talkie', 'Assigned to: Marriane Marcelo | Department: Housekeeping | Issued: 17 Jul 2025', 'Marriane Marcelo', 'Housekeeping'),
('Motorola SL4000E - Violetta', 'Mobile Phone', 'Spanish Villa', '682TSX0162', 'SL4000e', 'Motorola', 'active', 'good', '2023-01-01', 'Walkie Talkie w/ Earpiece and Charger', 'Assigned to: Violetta Shilina | Department: F&B | Issued: 17 Jul 2025', 'Violetta Shilina', 'F&B'),
('Motorola SL4000E - Judy Ann', 'Mobile Phone', 'Spanish Villa', '682TVB0240', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Judy Ann Galardo | Department: F&B | Issued: 9 Sep 2025', 'Judy Ann Galardo', 'F&B'),
('Motorola SL4000E - Kelly Jane', 'Mobile Phone', 'Head Office', '682TTM3715', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Kelly Jane Gawal | Department: F&B | Issued: 9 Sep 2025', 'Kelly Jane Gawal', 'F&B'),
('Motorola SL4000E - Catherine', 'Mobile Phone', 'White Villa', '682TVD0950', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Catherine Reotorio | Department: Housekeeping | Issued: 22 Sep 2025', 'Catherine Reotorio', 'Housekeeping'),
('Motorola SL4000E - Emelita', 'Mobile Phone', 'Spanish Villa', '682TVD1440', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Emelita Pingot | Department: Housekeeping | Issued: 22 Sep 2025', 'Emelita Pingot', 'Housekeeping'),
('Motorola SL4000E - Anastasiia', 'Mobile Phone', 'Spanish Villa', '682TVB0247', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Anastasiia Kotliarova | Department: F&B | Issued: 11 Nov 2025', 'Anastasiia Kotliarova', 'F&B'),
('Motorola SL4000E - Javyee', 'Mobile Phone', 'Al Rakna', '682TVB0766', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie', 'Assigned to: Javyee Cancino | Department: Housekeeping | Issued: 25 Sep 2025', 'Javyee Cancino', 'Housekeeping'),
('Motorola SL4000E - Angela Ilona', 'Mobile Phone', 'Spanish Villa', '682TVB0840', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Angela Ilona Kotan | Department: Housekeeping | Issued: 13 Oct 2025', 'Angela Ilona Kotan', 'Housekeeping'),
('Motorola SL4000E - Maria', 'Mobile Phone', 'Spanish Villa', '682TTH2217', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Maria Laeticia Santhosh | Department: Housekeeping | Issued: 13 Oct 2025', 'Maria Laeticia Santhosh', 'Housekeeping'),
('Motorola SL4000E - Jessica', 'Mobile Phone', 'Head Office', '682TVB0781', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Jessica Morate | Department: Housekeeping', 'Jessica Morate', 'Housekeeping'),
('Motorola SL4000E - Simranjit', 'Mobile Phone', 'White Villa', '682TVB0852', 'SL4000E', 'Motorola', 'active', 'good', '2025-09-01', 'Walkie Talkie w/Earpiece and Charger', 'Assigned to: Simranjit Kaur | Department: Housekeeping | Issued: 23 Oct 2025', 'Simranjit Kaur', 'Housekeeping'),
('Motorola SL4000E - Shanti', 'Mobile Phone', 'Spanish Villa', '682TSK0056', 'SL4000E', 'Motorola', 'active', 'good', '2023-01-01', 'Walkie Talkie', 'Assigned to: Shanti Blon | Department: Housekeeping', 'Shanti Blon', 'Housekeeping')

ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  model,
  manufacturer,
  serial_number,
  assigned_to,
  department,
  location,
  status
FROM assets 
WHERE category = 'Mobile Phone'
ORDER BY model, name;

-- Summary by model
SELECT 
  model,
  COUNT(*) as count,
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as in_stock
FROM assets 
WHERE category = 'Mobile Phone'
GROUP BY model
ORDER BY model;

-- Summary by department
SELECT 
  department,
  COUNT(*) as count
FROM assets 
WHERE category = 'Mobile Phone' AND assigned_to IS NOT NULL
GROUP BY department
ORDER BY count DESC;
