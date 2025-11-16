-- Import Storage Assets to Supabase
-- Category: Storage (NAS, SAN, Storage Arrays)
-- Run this script in your Supabase SQL Editor

-- Ensure Storage category exists
INSERT INTO categories (name, description) VALUES
('Storage', 'Network Attached Storage (NAS), SAN, and storage arrays')
ON CONFLICT (name) DO NOTHING;

-- Import Storage Devices
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
(
  'NAS Synology 1',
  'Storage',
  'Head Office',
  '1960NWN002809',
  'Synology DS720+',
  'Synology',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Network Attached Storage - DS720+',
  'IP: 192.168.1.10 | 2-bay NAS',
  'NAS-001'
),
(
  'NAS Synology 2',
  'Storage',
  'Head Office',
  '1BP0Q04808',
  'Synology DS720+',
  'Synology',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Network Attached Storage - DS720+',
  'IP: 192.168.1.108 | 2-bay NAS',
  'NAS-002'
),
(
  'NAS Synology Rack',
  'Storage',
  'Head Office',
  '20F0Q07026',
  'Synology RS1221+',
  'Synology',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Rack-Mount Network Attached Storage',
  'IP: 192.168.0.27 | 8-bay rackmount NAS',
  'NAS-003'
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
WHERE category = 'Storage'
ORDER BY model, name;

-- Summary
SELECT 
  model,
  COUNT(*) as count
FROM assets 
WHERE category = 'Storage'
GROUP BY model;
