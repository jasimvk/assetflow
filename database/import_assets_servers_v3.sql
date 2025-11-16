-- Import Server Assets to Supabase - V3 (V2 Schema Compatible)
-- Category: Server
-- Run this script in your Supabase SQL Editor AFTER running fix_rls_complete.sql

-- ====================
-- PREREQUISITES
-- ====================
-- 1. V2 schema migration completed (migrate_to_v2_schema.sql)
-- 2. RLS policies fixed (fix_rls_complete.sql)
-- 3. Categories and departments tables exist

-- ====================
-- STEP 1: Ensure Server category exists
-- ====================
INSERT INTO categories (name, description) 
VALUES ('Server', 'Physical and virtual servers including HP ProLiant, Dell models with IP addresses')
ON CONFLICT (name) DO NOTHING;

-- ====================
-- STEP 2: Import Server Assets with V2 Schema
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
  -- V2 New Columns (positions 23-40, added at END by ALTER TABLE)
  os_version,
  cpu_type,
  memory,
  storage,
  in_office_location,
  ip_address,
  mac_address,
  ilo_ip,
  sentinel_status,
  ninja_status,
  domain_status,
  function,
  physical_virtual,
  specifications,
  notes
) VALUES

-- ====================
-- PHYSICAL SERVERS (2 servers)
-- ====================

-- Physical Server 1: ONEHVMH2
(
  'ONEHVMH2',                                    -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'CZJ1020F01',                                 -- serial_number
  'HP ProLiant DL360 Gen 10',                   -- model
  'HP',                                          -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to (servers not assigned to individuals)
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2019',                        -- os_version
  'Intel Xeon Gold 6248 (24 CPUs @ 3.00GHz)',  -- cpu_type
  '64 GB',                                       -- memory
  '7.5 TB SSD',                                  -- storage
  'Server Room',                                 -- in_office_location
  '192.168.1.95',                               -- ip_address
  'D4:F5:EF:3D:34:B8',                          -- mac_address
  '192.168.1.92',                               -- ilo_ip (iLO management IP)
  NULL,                                          -- sentinel_status (servers may not have Sentinel)
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Virtualization Host',                         -- function
  'Physical',                                    -- physical_virtual
  'HP ProLiant DL360 Gen 10 - Primary virtualization host', -- specifications
  'Physical Server - Hosts multiple VMs including ONEHVMH2-VM, ONEH-PDC, OHEH-BACKUP' -- notes
),

-- Physical Server 2: ONEHVMH1
(
  'ONEHVMH1',                                    -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'CZ2D2507J3',                                 -- serial_number
  'HP ProLiant DL360 Gen 11',                   -- model
  'HP',                                          -- manufacturer
  '2025-02-03',                                 -- purchase_date
  'Excellent',                                   -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  '2028-02-02',                                 -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2022',                        -- os_version
  'Intel Xeon (Gen 11)',                        -- cpu_type
  '128 GB',                                      -- memory
  '10 TB',                                       -- storage
  'Server Room',                                 -- in_office_location
  '192.168.1.89',                               -- ip_address
  '8C:84:74:E5:D3:64',                          -- mac_address
  '192.168.1.91',                               -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Virtualization Host',                         -- function
  'Physical',                                    -- physical_virtual
  'HP ProLiant DL360 Gen 11 - Latest generation server', -- specifications
  'Physical Server - New 2025 - Hosts VMs: ONEHVMH1-VM, 1H-FOCUS, ONEH-CHECKSCM, 1H-SERVER' -- notes
),

-- ====================
-- VIRTUAL SERVERS (7 VMs)
-- ====================

-- VM 1: ONEHVMH1-VM
(
  'ONEHVMH1-VM',                                 -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'CZ2D2507J3-VM1',                             -- serial_number (VM serial)
  'HP ProLiant DL360 Gen 11 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2025-02-03',                                 -- purchase_date
  'Excellent',                                   -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  '2028-02-02',                                 -- warranty_expiry (same as host)
  -- V2 New Columns
  'Windows Server 2022',                        -- os_version
  'Virtual CPU',                                 -- cpu_type
  '32 GB',                                       -- memory
  '2 TB',                                        -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.1.88',                               -- ip_address
  '00:0C:29:E7:BE:7D',                          -- mac_address
  NULL,                                          -- ilo_ip (VMs don't have iLO)
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Application Server',                          -- function
  'Virtual',                                     -- physical_virtual
  'Virtual Machine running on ONEHVMH1',        -- specifications
  'VM on ONEHVMH1 - General application server' -- notes
),

-- VM 2: 1H-FOCUS
(
  '1H-FOCUS',                                    -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'FOCUS-VM',                                    -- serial_number
  'HP ProLiant DL360 Gen 11 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2025-02-03',                                 -- purchase_date
  'Excellent',                                   -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  '2028-02-02',                                 -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2022',                        -- os_version
  'Virtual CPU',                                 -- cpu_type
  '16 GB',                                       -- memory
  '500 GB',                                      -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.1.87',                               -- ip_address
  '00:0C:29:70:C7:65',                          -- mac_address
  NULL,                                          -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Focus System Server',                         -- function
  'Virtual',                                     -- physical_virtual
  'Virtual Machine - Focus ERP System',         -- specifications
  'VM on ONEHVMH1 - Runs Focus business management system' -- notes
),

-- VM 3: ONEH-CHECKSCM
(
  'ONEH-CHECKSCM',                               -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'CHECKSCM-VM',                                 -- serial_number
  'HP ProLiant DL360 Gen 11 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2025-02-03',                                 -- purchase_date
  'Excellent',                                   -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  '2028-02-02',                                 -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2022',                        -- os_version
  'Virtual CPU',                                 -- cpu_type
  '8 GB',                                        -- memory
  '250 GB',                                      -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.0.182',                              -- ip_address
  NULL,                                          -- mac_address
  NULL,                                          -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Check SCM System',                            -- function
  'Virtual',                                     -- physical_virtual
  'Virtual Machine - Check/SCM System',         -- specifications
  'VM on ONEHVMH1 - Supply Chain Management system' -- notes
),

-- VM 4: 1H-SERVER
(
  '1H-SERVER',                                   -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  '1H-SERVER-VM',                                -- serial_number
  'HP ProLiant DL360 Gen 11 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2025-02-03',                                 -- purchase_date
  'Excellent',                                   -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  '2028-02-02',                                 -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2022',                        -- os_version
  'Virtual CPU',                                 -- cpu_type
  '24 GB',                                       -- memory
  '1 TB',                                        -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.1.89',                               -- ip_address (same IP as host)
  '8C:84:74:E5:D3:64',                          -- mac_address
  NULL,                                          -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Main Application Server',                     -- function
  'Virtual',                                     -- physical_virtual
  'Virtual Machine - Primary application server', -- specifications
  'VM on ONEHVMH1 - Main business application server' -- notes
),

-- VM 5: ONEHVMH2-VM
(
  'ONEHVMH2-VM',                                 -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'ONEHVMH2-VM1',                                -- serial_number
  'HP ProLiant DL360 Gen 10 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2019',                        -- os_version
  'Virtual CPU (Xeon Gold 6248 host)',          -- cpu_type
  '32 GB',                                       -- memory
  '2 TB',                                        -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.1.95',                               -- ip_address
  'D4:F5:EF:3D:34:B8',                          -- mac_address
  NULL,                                          -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Application Server',                          -- function
  'Virtual',                                     -- physical_virtual
  'VM on ONEHVMH2 - Xeon 3.00GHz 24CPUs, 64GB host RAM, 7.5TB host storage', -- specifications
  'Virtual Machine on ONEHVMH2 (Gen 10 host)' -- notes
),

-- VM 6: ONEH-PDC
(
  'ONEH-PDC',                                    -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'PDC-VM',                                      -- serial_number
  'HP ProLiant DL360 Gen 10 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2019',                        -- os_version
  'Virtual CPU (Xeon Gold 6248 host)',          -- cpu_type
  '16 GB',                                       -- memory
  '500 GB',                                      -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.1.100',                              -- ip_address
  '00:15:5D:01:5F:01',                          -- mac_address
  NULL,                                          -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain Controller',                           -- domain_status
  'Primary Domain Controller',                   -- function
  'Virtual',                                     -- physical_virtual
  'Primary Domain Controller - Active Directory', -- specifications
  'VM on ONEHVMH2 - PDC for Active Directory domain management' -- notes
),

-- VM 7: OHEH-BACKUP
(
  'OHEH-BACKUP',                                 -- name
  'Server',                                      -- category
  'Head Office',                                 -- location
  'BACKUP-VM',                                   -- serial_number
  'HP ProLiant DL360 Gen 10 (Virtual)',         -- model
  'HP',                                          -- manufacturer
  '2020-01-01',                                 -- purchase_date
  'Good',                                        -- condition
  'Active',                                      -- status
  NULL,                                          -- assigned_to
  NULL,                                          -- department_id
  NULL,                                          -- warranty_expiry
  -- V2 New Columns
  'Windows Server 2019',                        -- os_version
  'Virtual CPU (Xeon Gold 6248 host)',          -- cpu_type
  '64 GB',                                       -- memory
  '5 TB',                                        -- storage
  'Virtual - Server Room',                       -- in_office_location
  '192.168.1.97',                               -- ip_address
  '00:15:5D:01:5F:00',                          -- mac_address
  NULL,                                          -- ilo_ip
  NULL,                                          -- sentinel_status
  NULL,                                          -- ninja_status
  'Domain',                                      -- domain_status
  'Backup Server',                               -- function
  'Virtual',                                     -- physical_virtual
  'Backup and Disaster Recovery Server - Large storage capacity', -- specifications
  'VM on ONEHVMH2 - Enterprise backup solution with 5TB storage' -- notes
)

ON CONFLICT (serial_number) DO NOTHING;

-- ====================
-- STEP 3: Verification Queries
-- ====================

-- Count total servers imported
SELECT COUNT(*) as total_servers_imported 
FROM assets 
WHERE category = 'Server';

-- Show all servers with key details
SELECT 
  name,
  model,
  serial_number,
  physical_virtual,
  ip_address,
  ilo_ip,
  cpu_type,
  memory,
  storage,
  os_version,
  function,
  status
FROM assets 
WHERE category = 'Server'
ORDER BY physical_virtual DESC, name;

-- Summary by type
SELECT 
  physical_virtual,
  COUNT(*) as count,
  STRING_AGG(name, ', ' ORDER BY name) as server_names
FROM assets 
WHERE category = 'Server'
GROUP BY physical_virtual
ORDER BY physical_virtual DESC;

-- Network information summary
SELECT 
  name,
  ip_address,
  mac_address,
  ilo_ip,
  physical_virtual
FROM assets 
WHERE category = 'Server'
ORDER BY physical_virtual DESC, ip_address;

-- Success message
SELECT '✅ Server import complete! 2 physical servers + 7 virtual servers = 9 total servers' AS status;
