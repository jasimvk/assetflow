-- Import Network Equipment Assets to Supabase
-- Category: Switch (includes switches, firewalls, access points)
-- Run this script in your Supabase SQL Editor

-- Ensure Switch category exists
INSERT INTO categories (name, description) VALUES
('Switch', 'Network switches, firewalls, access points, and networking equipment')
ON CONFLICT (name) DO NOTHING;

-- Import Network Equipment
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
  purchase_cost,
  current_value,
  description,
  notes,
  asset_code
) VALUES
-- Switches
(
  'HP Switch 1',
  'Switch',
  'Head Office',
  'CN34DRW029',
  'HP 2620-48 POE+ Switch J9624J',
  'HP',
  'active',
  'good',
  '2019-01-01',
  0,
  0,
  'HP 2620-48 POE+ Switch',
  '48-port PoE+ managed switch',
  '1H-00099'
),
(
  'HP Switch 2',
  'Switch',
  'Head Office',
  'CN33DRW1N0',
  'HP 2620-48 POE+ Switch J9624J',
  'HP',
  'active',
  'good',
  '2019-01-01',
  0,
  0,
  'HP 2620-48 POE+ Switch',
  '48-port PoE+ managed switch',
  '1H-00098'
),

-- Firewall
(
  'SonicWall Firewall',
  'Switch',
  'Head Office',
  'SNC-2650-001',
  'SonicWall NSa 2650',
  'SonicWall',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Enterprise Firewall',
  'IP: 192.168.1.253 | MAC: 2C:B8:ED:29:97:40',
  'FW-001'
),

-- Access Points
(
  'UniFi AP Pro 1',
  'Switch',
  'Head Office',
  'UAP-AC-PRO-001',
  'UniFi AC Pro',
  'Ubiquiti',
  'active',
  'good',
  '2020-01-01',
  0,
  0,
  'WiFi Access Point',
  'IP: 192.168.0.8 | MAC: 68:D7:9A:8C:BE:6C',
  'AP-001'
),
(
  'UniFi AP Pro 2',
  'Switch',
  'Head Office',
  'UAP-AC-PRO-002',
  'UniFi AC Pro',
  'Ubiquiti',
  'active',
  'good',
  '2020-01-01',
  0,
  0,
  'WiFi Access Point',
  'IP: 192.168.0.246 | MAC: 68:D7:9A:8C:C1:96',
  'AP-002'
),
(
  'UniFi AP Pro 3',
  'Switch',
  'Head Office',
  'UAP-AC-PRO-003',
  'UniFi AC Pro',
  'Ubiquiti',
  'active',
  'good',
  '2020-01-01',
  0,
  0,
  'WiFi Access Point',
  'IP: 192.168.1.151 | MAC: 68:D7:9A:8C:C4:02',
  'AP-003'
),
(
  'UniFi AP Pro 4',
  'Switch',
  'Head Office',
  'UAP-AC-PRO-004',
  'UniFi AC Pro',
  'Ubiquiti',
  'active',
  'good',
  '2020-01-01',
  0,
  0,
  'WiFi Access Point',
  'IP: 192.168.0.130 | MAC: 68:D7:9A:8C:C1:BB',
  'AP-004'
),
(
  'UniFi AP Lite 1',
  'Switch',
  'Head Office',
  'UAP-AC-LITE-001',
  'UniFi AC Lite',
  'Ubiquiti',
  'active',
  'good',
  '2020-01-01',
  0,
  0,
  'WiFi Access Point',
  'IP: 192.168.1.161 | MAC: E4:38:83:E9:DF:B4',
  'AP-005'
),
(
  'UniFi AP Lite 2',
  'Switch',
  'Head Office',
  'UAP-AC-LITE-002',
  'UniFi AC Lite',
  'Ubiquiti',
  'active',
  'good',
  '2020-01-01',
  0,
  0,
  'WiFi Access Point',
  'IP: 192.168.0.89 | MAC: E4:38:83:E9:DF:F0',
  'AP-006'
)
ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  model,
  manufacturer,
  serial_number,
  status,
  notes,
  asset_code
FROM assets 
WHERE category = 'Switch'
ORDER BY model, name;

-- Summary by type
SELECT 
  CASE 
    WHEN model LIKE '%Switch%' THEN 'Switch'
    WHEN model LIKE '%SonicWall%' OR model LIKE '%Firewall%' THEN 'Firewall'
    WHEN model LIKE '%UniFi%' OR model LIKE '%Access%' THEN 'Access Point'
    ELSE 'Other'
  END as device_type,
  COUNT(*) as count
FROM assets 
WHERE category = 'Switch'
GROUP BY device_type;
