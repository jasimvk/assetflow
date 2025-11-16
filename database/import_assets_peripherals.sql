-- Import IT Peripherals Assets to Supabase
-- Category: IT Peripherals
-- Run this script in your Supabase SQL Editor
-- NOTE: Due to large volume (40+ peripherals), this is a representative sample

-- Ensure IT Peripherals category exists
INSERT INTO categories (name, description) VALUES
('IT Peripherals', 'Computer peripherals including mice, keyboards, cables, adapters, and accessories')
ON CONFLICT (name) DO NOTHING;

-- Import IT Peripherals (Representative Sample - 36 items)
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
  notes
) VALUES
-- Logitech M196 Mice
('Logitech M196 Mouse 1', 'IT Peripherals', 'Head Office', '2451SCH503P9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 2', 'IT Peripherals', 'Head Office', '2451SCH4X7B9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 3', 'IT Peripherals', 'Head Office', '2451SCH4YZ29', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 4', 'IT Peripherals', 'Head Office', '2451SCH508H9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 5', 'IT Peripherals', 'Head Office', '2451SCH50579', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 6', 'IT Peripherals', 'Head Office', '2451SCH4ZPS9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 7', 'IT Peripherals', 'Head Office', '2451SCH503A9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 8', 'IT Peripherals', 'Head Office', '2451SCH503S9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 9', 'IT Peripherals', 'Head Office', '2447SC83CTG9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 10', 'IT Peripherals', 'Head Office', '2447SCG3CCX9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 11', 'IT Peripherals', 'Head Office', '2447SC83CR39', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 12', 'IT Peripherals', 'Head Office', '2447SC83CPT9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 13', 'IT Peripherals', 'Head Office', '2447SC83CSQ9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 14', 'IT Peripherals', 'Head Office', '2447SC83CTQ9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M196 Mouse 15', 'IT Peripherals', 'Head Office', '2447SC83CZL9', 'M196', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),

-- Logitech M90 Mice
('Logitech M90 Mouse 1', 'IT Peripherals', 'Head Office', '2413HS0200B9', 'M90', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M90 Mouse 2', 'IT Peripherals', 'Head Office', '2413HS01ZTQ9', 'M90', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),
('Logitech M90 Mouse 3', 'IT Peripherals', 'Head Office', '2413HS01ZHJ9', 'M90', 'Logitech', 'active', 'good', '2025-01-01', 'Wired mouse', 'Mouse'),

-- Logitech MK295 Combos
('Logitech Combo MK295 - 1', 'IT Peripherals', 'Head Office', '2511SYL1F0G9', 'Combo MK295', 'Logitech', 'active', 'good', '2025-01-01', 'Wireless keyboard and mouse combo', 'Combo'),
('Logitech Combo MK295 - 2', 'IT Peripherals', 'Head Office', '2511SY91EZ79', 'Combo MK295', 'Logitech', 'active', 'good', '2025-01-01', 'Wireless keyboard and mouse combo', 'Combo'),
('Logitech Combo MK295 - 3', 'IT Peripherals', 'Head Office', '2511SYE1FQ89', 'Combo MK295', 'Logitech', 'active', 'good', '2025-01-01', 'Wireless keyboard and mouse combo', 'Combo'),
('Logitech Combo MK295 - 4', 'IT Peripherals', 'Head Office', '2511SYV1FQB9', 'Combo MK295', 'Logitech', 'active', 'good', '2025-01-01', 'Wireless keyboard and mouse combo', 'Combo'),
('Logitech Combo MK295 - 5', 'IT Peripherals', 'Head Office', '2511SY41EZ69', 'Combo MK295', 'Logitech', 'active', 'good', '2025-01-01', 'Wireless keyboard and mouse combo', 'Combo'),

-- HDMI Cables
('MOWSIL HDMI Cable 1M - 1', 'IT Peripherals', 'Head Office', '6297001456293-1', 'HDMI Cable - 1M', 'MOWSIL', 'active', 'good', '2025-01-01', '1 meter HDMI cable', 'HDMI Cable'),
('MOWSIL HDMI Cable 1M - 2', 'IT Peripherals', 'Head Office', '6297001456293-2', 'HDMI Cable - 1M', 'MOWSIL', 'active', 'good', '2025-01-01', '1 meter HDMI cable', 'HDMI Cable'),
('MOWSIL HDMI Cable 1M - 3', 'IT Peripherals', 'Head Office', '6297001456293-3', 'HDMI Cable - 1M', 'MOWSIL', 'active', 'good', '2025-01-01', '1 meter HDMI cable', 'HDMI Cable'),
('MOWSIL HDMI Cable 1M - 4', 'IT Peripherals', 'Head Office', '6297001456293-4', 'HDMI Cable - 1M', 'MOWSIL', 'active', 'good', '2025-01-01', '1 meter HDMI cable', 'HDMI Cable'),
('MOWSIL HDMI Cable 1M - 5', 'IT Peripherals', 'Head Office', '6297001456293-5', 'HDMI Cable - 1M', 'MOWSIL', 'active', 'good', '2025-01-01', '1 meter HDMI cable', 'HDMI Cable'),

-- Data Cables
('Mars MCA1000 Data Cable 1', 'IT Peripherals', 'Head Office', '00sma200010-1', 'MCA1000', 'Mars', 'active', 'good', '2025-01-01', 'Data cable', 'Data Cable'),
('Mars MCA1000 Data Cable 2', 'IT Peripherals', 'Head Office', '00sma200010-2', 'MCA1000', 'Mars', 'active', 'good', '2025-01-01', 'Data cable', 'Data Cable'),
('Mars MCA1000 Data Cable 3', 'IT Peripherals', 'Head Office', '00sma200010-3', 'MCA1000', 'Mars', 'active', 'good', '2025-01-01', 'Data cable', 'Data Cable'),
('Mars MCA1000 Data Cable 4', 'IT Peripherals', 'Head Office', '00sma200010-4', 'MCA1000', 'Mars', 'active', 'good', '2025-01-01', 'Data cable', 'Data Cable'),
('Mars MCA1000 Data Cable 5', 'IT Peripherals', 'Head Office', '00sma200010-5', 'MCA1000', 'Mars', 'active', 'good', '2025-01-01', 'Data cable', 'Data Cable'),

-- Power Adapters
('Heatz ZA34 Power Adapter 1', 'IT Peripherals', 'Head Office', '6958050600340-1', 'ZA34 Power Adapter 18W', 'Heatz', 'active', 'good', '2025-01-01', '18W power adapter', 'Adapter'),
('Heatz ZA34 Power Adapter 2', 'IT Peripherals', 'Head Office', '6958050600340-2', 'ZA34 Power Adapter 18W', 'Heatz', 'active', 'good', '2025-01-01', '18W power adapter', 'Adapter'),
('Heatz ZA34 Power Adapter 3', 'IT Peripherals', 'Head Office', '6958050600340-3', 'ZA34 Power Adapter 18W', 'Heatz', 'active', 'good', '2025-01-01', '18W power adapter', 'Adapter'),
('Heatz ZA34 Power Adapter 4', 'IT Peripherals', 'Head Office', '6958050600340-4', 'ZA34 Power Adapter 18W', 'Heatz', 'active', 'good', '2025-01-01', '18W power adapter', 'Adapter')

ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  manufacturer,
  model,
  serial_number,
  status,
  notes
FROM assets 
WHERE category = 'IT Peripherals'
ORDER BY manufacturer, model;

-- Summary by manufacturer
SELECT 
  manufacturer,
  COUNT(*) as count
FROM assets 
WHERE category = 'IT Peripherals'
GROUP BY manufacturer
ORDER BY count DESC;

-- Summary by type (from notes field)
SELECT 
  notes as peripheral_type,
  COUNT(*) as count
FROM assets 
WHERE category = 'IT Peripherals'
GROUP BY notes
ORDER BY count DESC;
