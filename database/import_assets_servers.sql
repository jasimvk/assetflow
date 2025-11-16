-- Import Server Assets to Supabase
-- Category: Server
-- Run this script in your Supabase SQL Editor

-- Ensure Server category exists
INSERT INTO categories (name, description) VALUES
('Server', 'Physical and virtual servers including HP ProLiant, Dell models with IP addresses')
ON CONFLICT (name) DO NOTHING;

-- Import Server Assets
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
  notes
) VALUES
-- Physical Servers
(
  'ONEHVMH2',
  'Server',
  'Head Office',
  'CZJ1020F01',
  'HP ProLiant DL360 Gen 10',
  'HP',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
  'Physical Server | IP: 192.168.1.95 | MAC: D4:F5:EF:3D:34:B8 | ILO IP: 192.168.1.92'
),
(
  'ONEHVMH1',
  'Server',
  'Head Office',
  'CZ2D2507J3',
  'HP ProLiant DL360 Gen 11',
  'HP',
  'active',
  'excellent',
  '2025-02-03',
  0,
  0,
  'HP ProLiant DL360 Gen 11',
  'Physical Server | IP: 192.168.1.89 | MAC: 8C:84:74:E5:D3:64 | ILO IP: 192.168.1.91 | Warranty: 02/02/2028'
),

-- Virtual Servers
(
  'ONEHVMH1-VM',
  'Server',
  'Head Office',
  'CZ2D2507J3-VM1',
  'HP ProLiant DL360 Gen 11 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2025-02-03',
  0,
  0,
  'Virtual Machine on ONEHVMH1',
  'Virtual Server | IP: 192.168.1.88 | MAC: 00:0C:29:E7:BE:7D'
),
(
  '1H-FOCUS',
  'Server',
  'Head Office',
  'FOCUS-VM',
  'HP ProLiant DL360 Gen 11 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2025-02-03',
  0,
  0,
  'Virtual Machine - Focus System',
  'Virtual Server | IP: 192.168.1.87 | MAC: 00:0C:29:70:C7:65'
),
(
  'ONEH-CHECKSCM',
  'Server',
  'Head Office',
  'CHECKSCM-VM',
  'HP ProLiant DL360 Gen 11 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2025-02-03',
  0,
  0,
  'Virtual Machine - Check SCM System',
  'Virtual Server | IP: 192.168.0.182'
),
(
  '1H-SERVER',
  'Server',
  'Head Office',
  '1H-SERVER-VM',
  'HP ProLiant DL360 Gen 11 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2025-02-03',
  0,
  0,
  'Virtual Machine - Main Server',
  'Virtual Server | IP: 192.168.1.89 | MAC: 8C:84:74:E5:D3:64'
),
(
  'ONEHVMH2-VM',
  'Server',
  'Head Office',
  'ONEHVMH2-VM1',
  'HP ProLiant DL360 Gen 10 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Virtual Machine on ONEHVMH2 | Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
  'Virtual Server | IP: 192.168.1.95 | MAC: D4:F5:EF:3D:34:B8'
),
(
  'ONEH-PDC',
  'Server',
  'Head Office',
  'PDC-VM',
  'HP ProLiant DL360 Gen 10 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Virtual Machine - Primary Domain Controller | Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
  'Virtual Server | IP: 192.168.1.100 | MAC: 00:15:5D:01:5F:01'
),
(
  'OHEH-BACKUP',
  'Server',
  'Head Office',
  'BACKUP-VM',
  'HP ProLiant DL360 Gen 10 (Virtual)',
  'HP',
  'active',
  'excellent',
  '2020-01-01',
  0,
  0,
  'Virtual Machine - Backup Server | Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
  'Virtual Server | IP: 192.168.1.97 | MAC: 00:15:5D:01:5F:00'
)
ON CONFLICT (serial_number) DO NOTHING;

-- Verification queries
SELECT 
  name,
  model,
  manufacturer,
  serial_number,
  status,
  notes
FROM assets 
WHERE category = 'Server'
ORDER BY name;

-- Summary
SELECT 
  COUNT(*) as total_servers,
  COUNT(CASE WHEN notes LIKE '%Physical%' THEN 1 END) as physical_servers,
  COUNT(CASE WHEN notes LIKE '%Virtual%' THEN 1 END) as virtual_servers
FROM assets 
WHERE category = 'Server';
