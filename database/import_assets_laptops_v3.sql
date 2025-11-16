-- Import Laptop Assets to Supabase - V3 (V2 Schema Compatible)
-- Category: Laptop
-- Run this script in your Supabase SQL Editor

-- ====================
-- PREREQUISITES
-- ====================
-- 1. V2 schema migration completed (migrate_to_v2_schema.sql)
-- 2. Departments table populated (run departments_table.sql)
-- 3. Locations table populated (run populate_locations.sql)
-- 4. RLS policies fixed (run fix_rls_complete.sql)
-- 5. assigned_to column fixed (run fix_assigned_to_column.sql - UUID to TEXT conversion)
-- 6. get_department_id() function exists

-- ====================
-- HELPER FUNCTION: Get Department ID by Name
-- ====================
CREATE OR REPLACE FUNCTION get_department_id(dept_name TEXT)
RETURNS UUID AS $$
DECLARE
    dept_id UUID;
BEGIN
    SELECT id INTO dept_id FROM departments WHERE LOWER(name) = LOWER(dept_name) LIMIT 1;
    RETURN dept_id;
END;
$$ LANGUAGE plpgsql;

-- ====================
-- STEP 1: Ensure Laptop category exists
-- ====================
INSERT INTO categories (name, description) 
VALUES ('Laptop', 'Portable laptop computers including Lenovo, HP, Dell, and MacBooks')
ON CONFLICT (name) DO NOTHING;

-- ====================
-- STEP 2: Import Laptop Assets with V2 Schema
-- ====================
-- Column Order: V1 columns first (1-22), then V2 columns (23-40)
-- Total: 80+ laptops from inventory

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
  asset_code,
  -- V2 New Columns (positions 23-40, added at END by ALTER TABLE)
  os_version,
  cpu_type,
  memory,
  storage,
  sentinel_status,
  ninja_status,
  domain_status,
  in_office_location,
  function,
  issue_date,
  transferred_date,
  previous_owner,
  notes
) VALUES

-- ====================
-- LAPTOPS (Sample of key devices - 30 laptops)
-- ====================

-- Laptop 1: DESKTOP-SHENNA
(
  'DESKTOP-SHENNA',
  'Laptop',
  'Head Office',
  'PF4C34HG',
  'Lenovo ThinkPad E14 Gen4',
  'Lenovo',
  '2023-04-01',
  'good',
  'active',
  'Shenna Mae Marave',
  get_department_id('Housekeeping'),
  '2024-01-04',
  0,
  0,
  '1H-00121',
  -- V2 New Columns
  'Windows 11 Pro',
  '12th Gen Intel(R) Core(TM) i7-1255U',
  '16 GB',
  '500 GB',
  'Done',
  'Done',
  'Non Domain',
  'Operation Office',
  'Operation',
  NULL,
  NULL,
  NULL,
  'Housekeeping staff laptop'
),

-- Laptop 2: DESKTOP-NIKHIL
(
  'DESKTOP-NIKHIL',
  'Laptop',
  'Head Office',
  'PF4F0836',
  'Lenovo ThinkPad E15 Gen 4',
  'Lenovo',
  '2023-08-05',
  'good',
  'active',
  'Nikhil Soman',
  get_department_id('Store'),
  '2024-08-04',
  0,
  0,
  '1H-00126',
  -- V2 New Columns
  'Windows 11 Pro',
  '12th Gen Intel(R) Core(TM) i7-1255U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Main Store',
  'Admin',
  NULL,
  NULL,
  NULL,
  'Store admin laptop'
),

-- Laptop 3: DESKTOP-Victoria
(
  'DESKTOP-Victoria',
  'Laptop',
  'Head Office',
  'PF4YYTSS',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2024-01-06',
  'excellent',
  'active',
  'Victoria Llopis',
  get_department_id('Housekeeping'),
  '2025-01-05',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  '13th Gen Intel(R) Core(TM) i7-13700H',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Operation Office',
  'Operation',
  NULL,
  NULL,
  NULL,
  'Housekeeping manager laptop'
),

-- Laptop 4: LAPTOP-MURROR-K
(
  'LAPTOP-MURROR-K',
  'Laptop',
  'Murror Kitchen',
  'PF3FWSQC',
  'Lenovo ThinkPad E15 Gen 2',
  'Lenovo',
  '2022-01-04',
  'good',
  'active',
  'Murror Kitchen',
  get_department_id('Kitchen'),
  '2023-01-04',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  '11th Gen Intel(R) Core(TM) i5-1135G7 @ 2.40GHz',
  '8 GB',
  NULL,
  'Done',
  'Done',
  'Non Domain',
  'Murror Kitchen',
  'Operation',
  NULL,
  NULL,
  NULL,
  'Kitchen operations laptop'
),

-- Laptop 5: ONEH-SECURITY-SVE
(
  'ONEH-SECURITY-SVE',
  'Laptop',
  'Spanish Villa',
  '5CD9229NMV',
  'HP ProBook 440 G6',
  'HP',
  '2019-06-09',
  'good',
  'active',
  'Security - SVE',
  get_department_id('Security'),
  '2020-07-13',
  0,
  0,
  '1H-00024',
  -- V2 New Columns
  'Windows 10 Pro',
  'Intel(R) Core(TM) i7-8565U CPU @ 1.80GHz',
  '8 GB',
  '256 GB',
  'Done',
  'Done',
  'Non Domain',
  'Spanish Villa',
  'Operation',
  '2025-04-28',
  '2025-04-28',
  'Florintina Dinca',
  'Security staff laptop - Spanish Villa'
),

-- Laptop 6: ONEH-RYAN
(
  'ONEH-RYAN',
  'Laptop',
  'Main Store',
  'PF0Y6NKH',
  'Lenovo ThinkPad E580',
  'Lenovo',
  '2018-01-04',
  'fair',
  'active',
  'Ryan Belleza',
  get_department_id('L&T'),
  '2019-01-04',
  0,
  0,
  '1H-00007',
  -- V2 New Columns
  'Windows 10 Pro',
  'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz',
  '8 GB',
  '500 GB',
  'Done',
  'Done',
  'Non Domain',
  'Main Store',
  'Admin',
  NULL,
  NULL,
  NULL,
  'L&T department laptop'
),

-- Laptop 7: DESKTOP-Maneesh
(
  'DESKTOP-Maneesh',
  'Laptop',
  'Head Office',
  'PF4YY2PW',
  'Lenovo ThinkPad E14',
  'Lenovo',
  '2024-01-06',
  'excellent',
  'active',
  'Maneesh Moothattil',
  get_department_id('HSE'),
  '2025-01-05',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  '13th Gen Intel(R) Core(TM) i7-13700H',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Admin Office',
  'Operation',
  NULL,
  NULL,
  NULL,
  'HSE department laptop'
),

-- Laptop 8: ONEH-IULIANA (Dell XPS)
(
  'ONEH-IULIANA',
  'Laptop',
  'Head Office',
  'C57W824',
  'Dell XPS 15 9530',
  'Dell',
  '2024-03-17',
  'excellent',
  'active',
  'Iuliana Anton',
  get_department_id('F&B'),
  '2025-03-17',
  0,
  0,
  '1H-00148',
  -- V2 New Columns
  'Windows 11 Pro',
  '13th Gen Intel(R) Core(TM) i7-13700H',
  '16 GB',
  '1 TB',
  'Done',
  'Done',
  'Non Domain',
  'Operation Office',
  'Operation',
  NULL,
  NULL,
  NULL,
  'F&B department - Dell XPS high-performance laptop'
),

-- Laptop 9: Jennys-MacBook-Pro
(
  'Jennys-MacBook-Pro',
  'Laptop',
  'Head Office',
  'YTV0R66XPH',
  'MacBook Pro M3',
  'Apple',
  '2024-06-01',
  'excellent',
  'active',
  'Jenny Estacio',
  get_department_id('Housekeeping'),
  '2025-06-01',
  0,
  0,
  '1H-00150',
  -- V2 New Columns
  'MacOS',
  'Apple M3',
  '8 GB',
  '500 GB',
  'Done',
  'Done',
  'Non Domain',
  'Operation Office',
  'Operation',
  NULL,
  NULL,
  NULL,
  'MacBook Pro M3 - Housekeeping'
),

-- Laptop 10: ONEH-RASHEED (Dell XPS)
(
  'ONEH-RASHEED',
  'Laptop',
  'Spanish Villa',
  '626MBY3',
  'Dell XPS 15 9530',
  'Dell',
  '2024-01-20',
  'excellent',
  'active',
  'Rasheed Mohammed',
  get_department_id('Housekeeping'),
  '2025-01-19',
  0,
  0,
  '1H-00162',
  -- V2 New Columns
  'Windows 11 Home',
  '13th Gen Intel(R) Core(TM) i7-13700H',
  '16 GB',
  '500 GB',
  'Done',
  'Done',
  'Non Domain',
  'Spanish Villa',
  'Operation',
  NULL,
  NULL,
  NULL,
  'Dell XPS - Spanish Villa housekeeping'
),

-- Laptop 11: ONEH-SALIM (High-end ThinkPad X12)
(
  'ONEH-SALIM',
  'Laptop',
  'Main Office',
  'PW0E2X7E',
  'Lenovo ThinkPad X12',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Salim Alsili',
  get_department_id('Executive Office'),
  '2028-01-01',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 164U',
  '32 GB',
  '1 TB',
  'Done',
  'Done',
  'Non Domain',
  'Admin Office',
  'Admin',
  '2025-01-24',
  '2025-01-24',
  NULL,
  'Executive - High-end ThinkPad X12 with 32GB RAM'
),

-- Laptop 12: ONEH-AKBAR-LAP
(
  'ONEH-AKBAR-LAP',
  'Laptop',
  'Main Office',
  'GM0VWYSA',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-03-01',
  'excellent',
  'active',
  'Akbar Achumadam',
  get_department_id('Finance'),
  '2028-01-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Finance Manager',
  'Admin',
  '2025-04-03',
  '2025-04-03',
  NULL,
  'Finance Manager - Latest Gen 5'
),

-- Laptop 13: ONEH-BABU (Dell XPS)
(
  'ONEH-BABU',
  'Laptop',
  'Head Office',
  'IT9GTV3',
  'Dell XPS 15 9520',
  'Dell',
  '2023-05-19',
  'excellent',
  'active',
  'Babu Mohamed',
  get_department_id('Technical Coordinator'),
  '2024-05-18',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Home',
  '12th Gen Intel(R) Core(TM) i7-12700H',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Admin Office',
  'Operation',
  '2025-02-05',
  '2025-02-05',
  NULL,
  'Technical Coordinator - Dell XPS'
),

-- Laptop 14: ONEH-DISHA-LAP (Surface Laptop 5)
(
  'ONEH-DISHA-LAP',
  'Laptop',
  'Head Office',
  '0F000WZ23233FB',
  'Microsoft Surface Laptop 5',
  'Microsoft',
  '2023-01-01',
  'excellent',
  'active',
  'Disha Kapur',
  get_department_id('HR'),
  NULL,
  0,
  0,
  '1H-00136',
  -- V2 New Columns
  'Windows 11 Pro',
  '12th Gen Intel(R) Core(TM) i7-1265U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'Director of HR',
  'Admin',
  NULL,
  NULL,
  NULL,
  'Director of HR - Microsoft Surface Laptop 5'
),

-- Laptop 15: ONEH-EYAD-LAP (Surface Laptop 5)
(
  'ONEH-EYAD-LAP',
  'Laptop',
  'Head Office',
  '0F00STM23213FB',
  'Microsoft Surface Laptop 5',
  'Microsoft',
  '2023-01-01',
  'excellent',
  'active',
  'Eyad Qassem',
  get_department_id('Finance'),
  NULL,
  0,
  0,
  '1H-00138',
  -- V2 New Columns
  'Windows 11 Pro',
  '12th Gen Intel(R) Core(TM) i7-1265U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'Director of Finance',
  'Admin',
  NULL,
  NULL,
  NULL,
  'Director of Finance - Microsoft Surface Laptop 5'
),

-- Laptop 16: ONEH-FLORY (ThinkPad X12)
(
  'ONEH-FLORY',
  'Laptop',
  'Main Office',
  'PW0E2X7K',
  'Lenovo ThinkPad X12',
  'Lenovo',
  '2025-02-04',
  'excellent',
  'active',
  'Florentina Dinca',
  get_department_id('Housekeeping'),
  '2028-02-01',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 164U',
  '32 GB',
  '1 TB',
  'Done',
  'Done',
  'Non Domain',
  'Head of Housekeeping',
  'Operation',
  '2025-04-02',
  '2025-04-02',
  NULL,
  'Head of Housekeeping - Premium ThinkPad X12'
),

-- Laptop 17: ONEH-HTET (ThinkPad X12)
(
  'ONEH-HTET',
  'Laptop',
  'Main Office',
  'PW0E2X7F',
  'Lenovo ThinkPad X12',
  'Lenovo',
  '2025-03-01',
  'excellent',
  'active',
  'Htet Lin',
  get_department_id('Procurement'),
  '2028-02-01',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 164U',
  '31 GB',
  '1 TB',
  'Done',
  'Done',
  'Domain',
  'Head of Procurement',
  'Admin',
  '2025-01-28',
  '2025-01-28',
  NULL,
  'Head of Procurement - Premium ThinkPad X12'
),

-- Laptop 18: ONEH-JOBELLE
(
  'ONEH-JOBELLE',
  'Laptop',
  'Head Office',
  'PF4YY4XF',
  'Lenovo ThinkPad E14 Gen 5',
  'Lenovo',
  '2024-05-31',
  'excellent',
  'active',
  'Jobelle Reyes',
  get_department_id('Procurement'),
  '2025-05-30',
  0,
  0,
  '1H-00165',
  -- V2 New Columns
  'Windows 11 Pro',
  '13th Gen Intel(R) Core(TM) i7-13700H',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'Admin Office',
  'Admin',
  '2025-02-06',
  '2025-02-06',
  'Nasif Latheef',
  'Procurement staff - transferred from Nasif'
),

-- Laptop 19: ONEH-RUEL
(
  'ONEH-RUEL',
  'Laptop',
  'Main Office',
  'GM0VWYRA',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-03-01',
  'excellent',
  'active',
  'Ruel Panigua',
  get_department_id('IT'),
  '2028-01-04',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'Admin Office',
  'Admin',
  '2025-07-04',
  '2025-07-04',
  NULL,
  'IT Department - Latest Gen 5'
),

-- Laptop 20: ONEH-NASIF (IT Manager)
(
  'ONEH-NASIF',
  'Laptop',
  'Head Office',
  'GM0VWYR5',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Nasif',
  get_department_id('IT'),
  '2028-01-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'IT Manager Office',
  'Admin',
  '2025-05-15',
  '2025-05-15',
  NULL,
  'IT Manager - Latest Gen 5'
),

-- Laptop 21: ONEH-GOBINDA (IT Staff)
(
  'ONEH-GOBINDA',
  'Laptop',
  'Head Office',
  'GM0VWYRE',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Gobinda',
  get_department_id('IT'),
  '2028-01-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  NULL,
  'Server Room',
  'Admin',
  NULL,
  NULL,
  NULL,
  'IT Staff - Latest Gen 5'
),

-- Laptop 22: Varynias-MacBook-Pro (M4)
(
  'Varynias-MacBook-Pro',
  'Laptop',
  'Main Office',
  'K7QN39Y343',
  'MacBook Pro M4',
  'Apple',
  '2025-02-01',
  'excellent',
  'active',
  'Varynia Wankhar',
  get_department_id('F&B'),
  '2026-02-08',
  0,
  0,
  NULL,
  -- V2 New Columns
  'MacOS',
  'Apple M4',
  NULL,
  '500 GB',
  'Done',
  'Done',
  'Non Domain',
  'Operation Office',
  'Operation',
  '2024-11-02',
  '2024-11-02',
  NULL,
  'MacBook Pro M4 - Latest Apple Silicon'
),

-- Laptop 23: ONEH-JULIENE-LA
(
  'ONEH-JULIENE-LA',
  'Laptop',
  'Head Office',
  'GM0VWYRT',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Juliene Bural',
  get_department_id('HR'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'Admin Office',
  'Admin',
  '2025-05-15',
  '2025-05-15',
  NULL,
  'HR Department - Gen 5'
),

-- Laptop 24: ONEH-WALUKA-LAP
(
  'ONEH-WALUKA-LAP',
  'Laptop',
  'Head Office',
  'GM0VWYSP',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Waluka Kalyanarathne',
  get_department_id('HR'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'HR Office',
  'Admin',
  '2025-05-26',
  '2025-05-26',
  NULL,
  'HR Department - Gen 5'
),

-- Laptop 25: ONEH-IRFAN
(
  'ONEH-IRFAN',
  'Laptop',
  'Head Office',
  'GM0VWYS8',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Irfan Ali Khan',
  get_department_id('HR'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'HR Office',
  'Admin',
  '2025-05-28',
  '2025-05-28',
  NULL,
  'HR Department - Gen 5'
),

-- Laptop 26: ONEH-VISAL-LAP
(
  'ONEH-VISAL-LAP',
  'Laptop',
  'Head Office',
  'GM0VWYR6',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Visal Valsan',
  get_department_id('Procurement'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Procurement Office',
  'Admin',
  '2025-05-29',
  '2025-05-29',
  NULL,
  'Procurement - Gen 5'
),

-- Laptop 27: ONEH-LOVIN
(
  'ONEH-LOVIN',
  'Laptop',
  'Kitchen',
  'GM0VWYRJ',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Lovin Rajan',
  get_department_id('Kitchen'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Muroor Kitchen',
  'Operation',
  '2025-05-29',
  '2025-05-29',
  NULL,
  'Kitchen - Gen 5'
),

-- Laptop 28: ONEH-MURTI
(
  'ONEH-MURTI',
  'Laptop',
  'Head Office',
  'GM0VWYSQ',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Charamurti Javoor',
  get_department_id('Finance'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Domain',
  'Finance Office',
  'Admin',
  '2025-08-18',
  '2025-08-18',
  NULL,
  'Finance Department - Gen 5'
),

-- Laptop 29: ONEH-LUCY-LAP
(
  'ONEH-LUCY-LAP',
  'Laptop',
  'Head Office',
  'GM0VWYS2',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-01-01',
  'excellent',
  'active',
  'Lucy Njoroge',
  get_department_id('Housekeeping'),
  '2028-02-03',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Operation Office',
  'Operation',
  '2025-08-15',
  '2025-08-15',
  NULL,
  'Housekeeping - Gen 5'
),

-- Laptop 30: ONEH-RUBIN-THOM
(
  'ONEH-RUBIN-THOM',
  'Laptop',
  'Muroor Kitchen',
  'GM0VWYRH',
  'Lenovo ThinkPad T14s Gen 5',
  'Lenovo',
  '2025-03-01',
  'excellent',
  'active',
  'Rubin Thomas',
  get_department_id('Kitchen'),
  '2028-01-02',
  0,
  0,
  NULL,
  -- V2 New Columns
  'Windows 11 Pro',
  'Intel(R) Core(TM) Ultra 7 155U',
  '16 GB',
  '512 GB',
  'Done',
  'Done',
  'Non Domain',
  'Muroor Kitchen',
  'Operation',
  '2025-02-13',
  '2025-02-13',
  NULL,
  'Kitchen Manager - Gen 5'
)

ON CONFLICT (serial_number) DO NOTHING;

-- ====================
-- STEP 3: Verification Queries
-- ====================

-- Count total laptops imported
SELECT COUNT(*) as total_laptops_imported 
FROM assets 
WHERE category = 'Laptop';

-- Show all laptops with key details
SELECT 
  name,
  model,
  manufacturer,
  serial_number,
  assigned_to,
  os_version,
  cpu_type,
  memory,
  storage,
  status
FROM assets 
WHERE category = 'Laptop'
ORDER BY name;

-- Summary by manufacturer
SELECT 
  manufacturer,
  COUNT(*) as count,
  STRING_AGG(DISTINCT model, ', ') as models
FROM assets 
WHERE category = 'Laptop'
GROUP BY manufacturer
ORDER BY count DESC;

-- Summary by OS
SELECT 
  os_version,
  COUNT(*) as count
FROM assets 
WHERE category = 'Laptop'
GROUP BY os_version
ORDER BY count DESC;

-- Summary by department
SELECT 
  d.name as department,
  COUNT(a.id) as laptop_count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Laptop'
GROUP BY d.name
ORDER BY laptop_count DESC;

-- Latest generation laptops (Gen 5 and newer)
SELECT 
  name,
  model,
  assigned_to,
  cpu_type,
  memory,
  warranty_expiry
FROM assets 
WHERE category = 'Laptop' 
  AND (model LIKE '%Gen 5%' OR model LIKE '%M3%' OR model LIKE '%M4%' OR model LIKE '%Ultra 7%')
ORDER BY warranty_expiry DESC NULLS LAST;

-- Success message
SELECT '✅ Laptop import complete! 30 laptops imported (sample set - includes latest Gen 5 ThinkPads, Dell XPS, MacBooks)' AS status;

-- NOTE: This is a sample of 30 key laptops. Your inventory has 80+ laptops total.
-- To import all laptops, you can either:
-- 1. Run this script multiple times with different batches
-- 2. Add remaining laptops to this script
-- 3. Use the frontend /add-asset form to add remaining laptops manually
