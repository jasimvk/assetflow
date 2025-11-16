-- Import Network Equipment (Switch) Assets to Supabase - V3 (V2 Schema Compatible)
-- Category: Switch (includes switches, firewalls, access points)
-- Run this script in your Supabase SQL Editor AFTER running fix_rls_complete.sql

-- ====================
-- PREREQUISITES
-- ====================
-- 1. V2 schema migration completed (migrate_to_v2_schema.sql)
-- 2. RLS policies fixed (fix_rls_complete.sql)
-- 3. Categories table exists

-- ====================
-- STEP 1: Ensure Switch category exists
-- ====================
INSERT INTO categories (name, description) 
VALUES ('Switch', 'Network switches, firewalls, access points, and networking equipment')
ON CONFLICT (name) DO NOTHING;

-- ====================
-- STEP 2: Import Network Equipment with V2 Schema
-- ====================
-- Column Order: V1 columns first (1-22), then V2 columns (23-40)
-- This matches the actual table structure after ALTER TABLE ADD COLUMN

INSERT INTO assets (
  -- V1 Original Columns (positions 1-22)
  name,
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
  asset_code,
  -- V2 New Columns (positions 23-40, added at END by ALTER TABLE)
  ip_address,
  mac_address,
  in_office_location,
  function,
  specifications,
  notes
) VALUES

-- ====================
-- SWITCHES (2 devices)
-- ====================

-- Switch 1
(
  'HP Switch 1H-00099',                          -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'CN34DRW029',                                 -- serial_number
  'HP 2620-48 POE+ Switch J9624J',              -- model
  'HP',                                          -- manufacturer
  '2019-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  '1H-00099',                                   -- asset_code
  -- V2 New Columns
  NULL,                                          -- ip_address (managed via web interface)
  NULL,                                          -- mac_address
  'Network Room',                                -- in_office_location
  '48-Port PoE+ Managed Switch',                -- function
  '48 ports, Power over Ethernet Plus, Managed, Layer 2', -- specifications
  'HP 2620-48 POE+ Switch - Main network switch' -- notes
),

-- Switch 2
(
  'HP Switch 1H-00098',                          -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'CN33DRW1N0',                                 -- serial_number
  'HP 2620-48 POE+ Switch J9624J',              -- model
  'HP',                                          -- manufacturer
  '2019-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  '1H-00098',                                   -- asset_code
  -- V2 New Columns
  NULL,                                          -- ip_address
  NULL,                                          -- mac_address
  'Network Room',                                -- in_office_location
  '48-Port PoE+ Managed Switch',                -- function
  '48 ports, Power over Ethernet Plus, Managed, Layer 2', -- specifications
  'HP 2620-48 POE+ Switch - Secondary network switch' -- notes
),

-- ====================
-- FIREWALL (1 device)
-- ====================

-- Firewall
(
  'SonicWall Firewall',                          -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'SNC-2650-001',                                -- serial_number
  'SonicWall NSa 2650',                          -- model
  'SonicWall',                                   -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Excellent',                                   -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'FW-001',                                      -- asset_code
  -- V2 New Columns
  '192.168.1.253',                              -- ip_address
  '2C:B8:ED:29:97:40',                          -- mac_address
  'Network Room',                                -- in_office_location
  'Enterprise Firewall',                         -- function
  'SonicWall NSa 2650 - Enterprise firewall with intrusion prevention', -- specifications
  'Main perimeter firewall - Gateway security appliance' -- notes
),

-- ====================
-- ACCESS POINTS (6 devices)
-- ====================

-- Access Point 1 - UniFi AC Pro
(
  'UniFi AP Pro AP-001',                         -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'UAP-AC-PRO-001',                              -- serial_number
  'UniFi AC Pro',                                -- model
  'Ubiquiti',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'AP-001',                                      -- asset_code
  -- V2 New Columns
  '192.168.0.8',                                -- ip_address
  '68:D7:9A:8C:BE:6C',                          -- mac_address
  'Reception Area',                              -- in_office_location
  'WiFi Access Point',                           -- function
  'UniFi AC Pro - Dual-band 802.11ac Wave 1 AP, 3x3 MIMO', -- specifications
  'WiFi Access Point - Main reception coverage' -- notes
),

-- Access Point 2 - UniFi AC Pro
(
  'UniFi AP Pro AP-002',                         -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'UAP-AC-PRO-002',                              -- serial_number
  'UniFi AC Pro',                                -- model
  'Ubiquiti',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'AP-002',                                      -- asset_code
  -- V2 New Columns
  '192.168.0.246',                              -- ip_address
  '68:D7:9A:8C:C1:96',                          -- mac_address
  'Floor 1 - West Wing',                         -- in_office_location
  'WiFi Access Point',                           -- function
  'UniFi AC Pro - Dual-band 802.11ac Wave 1 AP, 3x3 MIMO', -- specifications
  'WiFi Access Point - West wing coverage' -- notes
),

-- Access Point 3 - UniFi AC Pro
(
  'UniFi AP Pro AP-003',                         -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'UAP-AC-PRO-003',                              -- serial_number
  'UniFi AC Pro',                                -- model
  'Ubiquiti',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'AP-003',                                      -- asset_code
  -- V2 New Columns
  '192.168.1.151',                              -- ip_address
  '68:D7:9A:8C:C4:02',                          -- mac_address
  'Floor 2 - East Wing',                         -- in_office_location
  'WiFi Access Point',                           -- function
  'UniFi AC Pro - Dual-band 802.11ac Wave 1 AP, 3x3 MIMO', -- specifications
  'WiFi Access Point - East wing coverage' -- notes
),

-- Access Point 4 - UniFi AC Pro
(
  'UniFi AP Pro AP-004',                         -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'UAP-AC-PRO-004',                              -- serial_number
  'UniFi AC Pro',                                -- model
  'Ubiquiti',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'AP-004',                                      -- asset_code
  -- V2 New Columns
  '192.168.0.130',                              -- ip_address
  '68:D7:9A:8C:C1:BB',                          -- mac_address
  'Conference Room',                             -- in_office_location
  'WiFi Access Point',                           -- function
  'UniFi AC Pro - Dual-band 802.11ac Wave 1 AP, 3x3 MIMO', -- specifications
  'WiFi Access Point - Conference room coverage' -- notes
),

-- Access Point 5 - UniFi AC Lite
(
  'UniFi AP Lite AP-005',                        -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'UAP-AC-LITE-001',                             -- serial_number
  'UniFi AC Lite',                               -- model
  'Ubiquiti',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'AP-005',                                      -- asset_code
  -- V2 New Columns
  '192.168.1.161',                              -- ip_address
  'E4:38:83:E9:DF:B4',                          -- mac_address
  'Warehouse',                                   -- in_office_location
  'WiFi Access Point',                           -- function
  'UniFi AC Lite - Dual-band 802.11ac Wave 1 AP, 2x2 MIMO', -- specifications
  'WiFi Access Point - Warehouse coverage' -- notes
),

-- Access Point 6 - UniFi AC Lite
(
  'UniFi AP Lite AP-006',                        -- name
  'Switch',                                      -- category
  'Head Office',                                 -- location
  'UAP-AC-LITE-002',                             -- serial_number
  'UniFi AC Lite',                               -- model
  'Ubiquiti',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  'AP-006',                                      -- asset_code
  -- V2 New Columns
  '192.168.0.89',                               -- ip_address
  'E4:38:83:E9:DF:F0',                          -- mac_address
  'Parking Area',                                -- in_office_location
  'WiFi Access Point',                           -- function
  'UniFi AC Lite - Dual-band 802.11ac Wave 1 AP, 2x2 MIMO', -- specifications
  'WiFi Access Point - Outdoor/parking coverage' -- notes
)

ON CONFLICT (serial_number) DO NOTHING;

-- ====================
-- STEP 3: Verification Queries
-- ====================

-- Count total network equipment imported
SELECT COUNT(*) as total_network_equipment_imported 
FROM assets 
WHERE category = 'Switch';

-- Show all network equipment with key details
SELECT 
  name,
  model,
  serial_number,
  asset_code,
  ip_address,
  mac_address,
  in_office_location,
  function,
  status
FROM assets 
WHERE category = 'Switch'
ORDER BY 
  CASE 
    WHEN function LIKE '%Firewall%' THEN 1
    WHEN function LIKE '%Switch%' THEN 2
    WHEN function LIKE '%WiFi%' THEN 3
    ELSE 4
  END,
  name;

-- Summary by equipment type
SELECT 
  CASE 
    WHEN model LIKE '%2620%' THEN 'Switch'
    WHEN model LIKE '%SonicWall%' THEN 'Firewall'
    WHEN model LIKE '%UniFi%' THEN 'Access Point'
    ELSE 'Other'
  END as equipment_type,
  COUNT(*) as count,
  STRING_AGG(name, ', ' ORDER BY name) as device_names
FROM assets 
WHERE category = 'Switch'
GROUP BY equipment_type
ORDER BY equipment_type;

-- Network information summary
SELECT 
  name,
  ip_address,
  mac_address,
  in_office_location,
  function
FROM assets 
WHERE category = 'Switch' AND ip_address IS NOT NULL
ORDER BY 
  SPLIT_PART(ip_address, '.', 1)::int,
  SPLIT_PART(ip_address, '.', 2)::int,
  SPLIT_PART(ip_address, '.', 3)::int,
  SPLIT_PART(ip_address, '.', 4)::int;

-- Success message
SELECT '✅ Network equipment import complete! 2 switches + 1 firewall + 6 access points = 9 total devices' AS status;
