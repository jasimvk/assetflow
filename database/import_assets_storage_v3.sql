-- Import Storage Assets to Supabase - V3 (V2 Schema Compatible)
-- Category: Storage (NAS, SAN, Storage Arrays)
-- Run this script in your Supabase SQL Editor AFTER running fix_rls_complete.sql

-- ====================
-- PREREQUISITES
-- ====================
-- 1. V2 schema migration completed (migrate_to_v2_schema.sql)
-- 2. RLS policies fixed (fix_rls_complete.sql)
-- 3. Categories table exists

-- ====================
-- STEP 1: Ensure Storage category exists
-- ====================
INSERT INTO categories (name, description) 
VALUES ('Storage', 'Network Attached Storage (NAS), SAN, and storage devices')
ON CONFLICT (name) DO NOTHING;

-- ====================
-- STEP 2: Import Storage Devices with V2 Schema
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
  purchase_cost,
  current_value,
  -- V2 New Columns (positions 23-40, added at END by ALTER TABLE)
  storage,
  ip_address,
  mac_address,
  in_office_location,
  function,
  specifications,
  notes
) VALUES

-- ====================
-- SYNOLOGY NAS DEVICES (3 devices)
-- ====================

-- NAS 1: ONEH-BACKUP (Synology DS720+)
(
  'ONEH-BACKUP',                                 -- name
  'Storage',                                     -- category
  'Head Office',                                 -- location
  '2110QWR9N711R',                              -- serial_number
  'Synology DS720+',                            -- model
  'Synology',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'excellent',                                   -- condition (lowercase!)
  'active',                                      -- status (lowercase!)
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  0,                                             -- purchase_cost
  0,                                             -- current_value
  -- V2 New Columns
  'Multi-TB',                                    -- storage (2-bay NAS with expandable storage)
  '192.168.1.94',                               -- ip_address
  '90:09:D0:6E:20:66',                          -- mac_address
  'Server Room',                                 -- in_office_location
  'Backup Storage',                              -- function
  'Synology DS720+ - 2-bay NAS, DiskStation, Expandable storage', -- specifications
  'Primary backup storage - 2-bay NAS with redundancy support' -- notes
),

-- NAS 2: FILESEERVER (Synology RS1221+)
(
  'FILESEERVER',                                 -- name
  'Storage',                                     -- category
  'Head Office',                                 -- location
  '2470RWR75W8CT',                              -- serial_number
  'Synology RS1221+',                           -- model
  'Synology',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'excellent',                                   -- condition (lowercase!)
  'active',                                      -- status (lowercase!)
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  0,                                             -- purchase_cost
  0,                                             -- current_value
  -- V2 New Columns
  'Multi-TB',                                    -- storage (8-bay rackmount NAS)
  '192.168.1.98',                               -- ip_address
  '90:09:D0:13:D9:22',                          -- mac_address
  'Server Room - Rack Mounted',                  -- in_office_location
  'File Server',                                 -- function
  'Synology RS1221+ - 8-bay Rackmount NAS, RackStation, Enterprise storage', -- specifications
  'Main file server - 8-bay rackmount NAS for centralized file storage' -- notes
),

-- NAS 3: DS720 (Synology DS720+)
(
  'DS720',                                       -- name
  'Storage',                                     -- category
  'Head Office',                                 -- location
  '2220TKR6B0SAF',                              -- serial_number
  'Synology DS720+',                            -- model
  'Synology',                                    -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'good',                                        -- condition (lowercase!)
  'active',                                      -- status (lowercase!)
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  0,                                             -- purchase_cost
  0,                                             -- current_value
  -- V2 New Columns
  'Multi-TB',                                    -- storage (2-bay NAS)
  '192.168.1.99',                               -- ip_address
  '00:11:32:EA:08:9A',                          -- mac_address
  'Server Room',                                 -- in_office_location
  'Secondary Storage',                           -- function
  'Synology DS720+ - 2-bay NAS, DiskStation, Backup and archive storage', -- specifications
  'Secondary storage device - 2-bay NAS for additional capacity and redundancy' -- notes
)

ON CONFLICT (serial_number) DO NOTHING;

-- ====================
-- STEP 3: Verification Queries
-- ====================

-- Count total storage devices imported
SELECT COUNT(*) as total_storage_devices_imported 
FROM assets 
WHERE category = 'Storage';

-- Show all storage devices with key details
SELECT 
  name,
  model,
  serial_number,
  ip_address,
  mac_address,
  in_office_location,
  function,
  storage,
  status
FROM assets 
WHERE category = 'Storage'
ORDER BY name;

-- Summary by model
SELECT 
  model,
  COUNT(*) as count,
  STRING_AGG(name, ', ' ORDER BY name) as device_names,
  STRING_AGG(ip_address, ', ' ORDER BY name) as ip_addresses
FROM assets 
WHERE category = 'Storage'
GROUP BY model
ORDER BY model;

-- Network information summary
SELECT 
  name,
  ip_address,
  mac_address,
  function,
  specifications
FROM assets 
WHERE category = 'Storage'
ORDER BY 
  SPLIT_PART(ip_address, '.', 1)::int,
  SPLIT_PART(ip_address, '.', 2)::int,
  SPLIT_PART(ip_address, '.', 3)::int,
  SPLIT_PART(ip_address, '.', 4)::int;

-- Storage capacity summary
SELECT 
  name,
  model,
  function,
  CASE 
    WHEN model LIKE '%DS720%' THEN '2-bay NAS'
    WHEN model LIKE '%RS1221%' THEN '8-bay Rackmount NAS'
    ELSE 'Unknown capacity'
  END as capacity_info
FROM assets 
WHERE category = 'Storage'
ORDER BY 
  CASE 
    WHEN model LIKE '%RS1221%' THEN 1  -- Largest first (8-bay)
    WHEN model LIKE '%DS720%' THEN 2   -- Then 2-bay
    ELSE 3
  END,
  name;

-- Success message
SELECT '✅ Storage import complete! 3 Synology NAS devices (1x RS1221+ 8-bay + 2x DS720+ 2-bay)' AS status;
