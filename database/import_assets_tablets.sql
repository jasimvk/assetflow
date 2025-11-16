-- Import Tablet Assets to Supabase
-- Category: Tablet
-- Run this script in your Supabase SQL Editor

-- Ensure Tablet category exists
INSERT INTO categories (name, description) VALUES
('Tablet', 'Tablet devices including iPads')
ON CONFLICT (name) DO NOTHING;

-- Import Tablets
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
('iPad Pro 11-inch M4 - Varynia', 'Tablet', 'Head Office', 'XX73VD2TCG', 'iPad Pro 11-inch (M4) Wi-Fi - 512GB', 'Apple', 'active', 'excellent', '2024-01-01', 'iPad Pro 11-inch M4 with 512GB storage', 'Assigned to: VARYNIA WANKHAR', '1H-00164', 'VARYNIA WANKHAR', NULL),
('iPad Pro 13-Inch - Jenny', 'Tablet', 'Head Office', 'D7V9H6GKC6', 'iPad Pro 13-Inch Wifi+Cellular', 'Apple', 'active', 'excellent', '2024-01-01', 'iPad Pro 13-Inch with WiFi and Cellular', 'Assigned to: Jenny Estacio', NULL, 'Jenny Estacio', NULL),
('iPad Magic Keyboard - Jenny', 'Tablet', 'Head Office', 'DP9PF7WQDL', 'iPad Magic Keyboard', 'Apple', 'active', 'excellent', '2024-01-01', 'Magic Keyboard for iPad', 'Assigned to: Jenny Estacio | Accessory for iPad', NULL, 'Jenny Estacio', NULL),
('Apple Pencil Pro - Jenny', 'Tablet', 'Head Office', 'CT4PY9J7KD', 'Apple Pencil Pro', 'Apple', 'active', 'excellent', '2024-01-01', 'Apple Pencil Pro stylus', 'Assigned to: Jenny Estacio | Accessory for iPad', NULL, 'Jenny Estacio', NULL),
('iPad Air 5th Gen - Adina', 'Tablet', 'Head Office', 'FVRPF67TYY', 'iPad Air 5Th Gen 256GB', 'Apple', 'active', 'excellent', '2024-01-01', 'iPad Air 5th Generation with 256GB storage', 'Assigned to: Adina Schiopu', NULL, 'Adina Schiopu', NULL),
('iPad Air 5th Gen - Joweley', 'Tablet', 'Head Office', 'KWF14HQWKH', 'iPad Air 5Th Gen 256GB', 'Apple', 'active', 'excellent', '2024-01-01', 'iPad Air 5th Generation with 256GB storage', 'Assigned to: Joweley Cator | Issued: April 18, 2025', NULL, 'Joweley Cator', NULL)
ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  model,
  serial_number,
  assigned_to,
  status,
  asset_code
FROM assets 
WHERE category = 'Tablet'
ORDER BY name;

-- Summary
SELECT 
  model,
  COUNT(*) as count
FROM assets 
WHERE category = 'Tablet'
GROUP BY model;
