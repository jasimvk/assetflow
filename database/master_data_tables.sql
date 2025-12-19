-- Master Data Tables for AssetFlow
-- Run this in Supabase SQL Editor
-- These tables support searchable dropdowns with "Add +" functionality

-- ============================================
-- LOCATIONS TABLE (Create if not exists)
-- ============================================
CREATE TABLE IF NOT EXISTS locations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    address TEXT,
    building VARCHAR(100),
    floor VARCHAR(50),
    room VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- MANUFACTURERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS manufacturers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert common manufacturers
INSERT INTO manufacturers (name) VALUES
    ('HP'),
    ('Dell'),
    ('Lenovo'),
    ('Apple'),
    ('Asus'),
    ('Acer'),
    ('Microsoft'),
    ('Samsung'),
    ('LG'),
    ('Cisco'),
    ('Synology'),
    ('QNAP'),
    ('Ubiquiti'),
    ('TP-Link'),
    ('Netgear'),
    ('Canon'),
    ('Epson'),
    ('Brother'),
    ('Motorola'),
    ('Zebra')
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- MODELS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS models (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(200) UNIQUE NOT NULL,
    manufacturer_id UUID REFERENCES manufacturers(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert common models
INSERT INTO models (name) VALUES
    ('ProDesk 400 G7 Microtower'),
    ('ProDesk 400 G6 Desktop Mini'),
    ('Pro Tower 290 G9 Desktop PC'),
    ('ThinkPad T14s Gen 5'),
    ('ThinkPad X1 Carbon Gen 11'),
    ('ThinkPad E14 Gen 5'),
    ('ThinkCentre M70q Gen 3'),
    ('ThinkCentre M720q'),
    ('Latitude 5540'),
    ('OptiPlex 7090'),
    ('PowerEdge R640'),
    ('PowerEdge R740'),
    ('ProLiant DL380 Gen10'),
    ('ProLiant DL360 Gen10'),
    ('MacBook Pro 14'),
    ('MacBook Air M2'),
    ('iMac 24'),
    ('E2422H'),
    ('P2422H'),
    ('P2419H'),
    ('E2222H'),
    ('L24e-30'),
    ('L22e-30'),
    ('ThinkVision T24i-20'),
    ('HP Z27'),
    ('LaserJet Pro M404dn'),
    ('LaserJet MFP M428fdw'),
    ('Color LaserJet Pro M454dw'),
    ('Catalyst 2960X'),
    ('Catalyst 3850'),
    ('DiskStation DS920+'),
    ('DiskStation DS1621+')
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- OS VERSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS os_versions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert common OS versions
INSERT INTO os_versions (name) VALUES
    ('Windows 11 Pro'),
    ('Windows 11 Home'),
    ('Windows 11 Enterprise'),
    ('Windows 10 Pro'),
    ('Windows 10 Home'),
    ('Windows 10 Enterprise'),
    ('Windows Server 2022'),
    ('Windows Server 2019'),
    ('Windows Server 2016'),
    ('macOS Sonoma'),
    ('macOS Ventura'),
    ('macOS Monterey'),
    ('Ubuntu 24.04 LTS'),
    ('Ubuntu 22.04 LTS'),
    ('Ubuntu 20.04 LTS'),
    ('CentOS Stream 9'),
    ('RHEL 9'),
    ('RHEL 8'),
    ('Debian 12'),
    ('VMware ESXi 8.0'),
    ('VMware ESXi 7.0'),
    ('Proxmox VE 8'),
    ('iOS 17'),
    ('iOS 16'),
    ('Android 14'),
    ('Android 13'),
    ('DSM 7.2')
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- CPU TYPES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS cpu_types (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(200) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert common CPU types
INSERT INTO cpu_types (name) VALUES
    ('Intel Core i3-12100'),
    ('Intel Core i3-13100'),
    ('Intel Core i5-12400'),
    ('Intel Core i5-12500'),
    ('Intel Core i5-13400'),
    ('Intel Core i5-13500'),
    ('Intel Core i7-12700'),
    ('Intel Core i7-13700'),
    ('Intel Core i7-14700'),
    ('Intel Core i9-12900'),
    ('Intel Core i9-13900'),
    ('Intel Core i9-14900'),
    ('Intel Core Ultra 5 125U'),
    ('Intel Core Ultra 7 155U'),
    ('Intel Core Ultra 9 185H'),
    ('Intel Xeon Silver 4210'),
    ('Intel Xeon Silver 4314'),
    ('Intel Xeon Gold 5218'),
    ('Intel Xeon Gold 6248'),
    ('AMD Ryzen 5 5600G'),
    ('AMD Ryzen 5 7600'),
    ('AMD Ryzen 7 5800X'),
    ('AMD Ryzen 7 7700X'),
    ('AMD Ryzen 9 7900X'),
    ('AMD EPYC 7302'),
    ('AMD EPYC 7542'),
    ('Apple M1'),
    ('Apple M1 Pro'),
    ('Apple M1 Max'),
    ('Apple M2'),
    ('Apple M2 Pro'),
    ('Apple M2 Max'),
    ('Apple M3'),
    ('Apple M3 Pro'),
    ('Apple M3 Max'),
    ('12th Gen Intel Core i5-12400'),
    ('13th Gen Intel Core i7-13700')
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- RAM SIZES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS ram_sizes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert common RAM sizes
INSERT INTO ram_sizes (name, sort_order) VALUES
    ('2 GB', 2),
    ('4 GB', 4),
    ('8 GB', 8),
    ('16 GB', 16),
    ('24 GB', 24),
    ('32 GB', 32),
    ('48 GB', 48),
    ('64 GB', 64),
    ('96 GB', 96),
    ('128 GB', 128),
    ('256 GB', 256),
    ('512 GB', 512),
    ('1 TB', 1024)
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- STORAGE SIZES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS storage_sizes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert common storage sizes
INSERT INTO storage_sizes (name, sort_order) VALUES
    ('128 GB SSD', 128),
    ('256 GB SSD', 256),
    ('500 GB SSD', 500),
    ('512 GB SSD', 512),
    ('1 TB SSD', 1000),
    ('2 TB SSD', 2000),
    ('4 TB SSD', 4000),
    ('128 GB HDD', 1128),
    ('256 GB HDD', 1256),
    ('500 GB HDD', 1500),
    ('1 TB HDD', 2000),
    ('2 TB HDD', 3000),
    ('4 TB HDD', 4000),
    ('8 TB HDD', 8000),
    ('12 TB HDD', 12000),
    ('16 TB HDD', 16000),
    ('256 GB NVMe', 10256),
    ('512 GB NVMe', 10512),
    ('1 TB NVMe', 11000),
    ('2 TB NVMe', 12000)
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- ENSURE LOCATIONS TABLE HAS DATA
-- ============================================
INSERT INTO locations (name) VALUES
    ('Head Office'),
    ('Branch Office'),
    ('Warehouse'),
    ('Data Center'),
    ('Remote Office'),
    ('Finance Office'),
    ('Admin Office'),
    ('IT Office'),
    ('HR Office'),
    ('Marketing Office'),
    ('Sales Office'),
    ('Operations Office'),
    ('Meeting Room 1'),
    ('Meeting Room 2'),
    ('Server Room'),
    ('Reception'),
    ('Training Room')
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- CREATE INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX IF NOT EXISTS idx_manufacturers_name ON manufacturers(name);
CREATE INDEX IF NOT EXISTS idx_models_name ON models(name);
CREATE INDEX IF NOT EXISTS idx_models_manufacturer ON models(manufacturer_id);
CREATE INDEX IF NOT EXISTS idx_os_versions_name ON os_versions(name);
CREATE INDEX IF NOT EXISTS idx_cpu_types_name ON cpu_types(name);
CREATE INDEX IF NOT EXISTS idx_ram_sizes_name ON ram_sizes(name);
CREATE INDEX IF NOT EXISTS idx_ram_sizes_sort ON ram_sizes(sort_order);
CREATE INDEX IF NOT EXISTS idx_storage_sizes_name ON storage_sizes(name);
CREATE INDEX IF NOT EXISTS idx_storage_sizes_sort ON storage_sizes(sort_order);
CREATE INDEX IF NOT EXISTS idx_locations_name ON locations(name);

-- ============================================
-- ENABLE RLS (Row Level Security)
-- ============================================
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE manufacturers ENABLE ROW LEVEL SECURITY;
ALTER TABLE models ENABLE ROW LEVEL SECURITY;
ALTER TABLE os_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cpu_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE ram_sizes ENABLE ROW LEVEL SECURITY;
ALTER TABLE storage_sizes ENABLE ROW LEVEL SECURITY;

-- Create policies for full access (SELECT, INSERT, UPDATE, DELETE)
DROP POLICY IF EXISTS "locations_full_access" ON locations;
CREATE POLICY "locations_full_access" ON locations FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "manufacturers_full_access" ON manufacturers;
CREATE POLICY "manufacturers_full_access" ON manufacturers FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "models_full_access" ON models;
CREATE POLICY "models_full_access" ON models FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "os_versions_full_access" ON os_versions;
CREATE POLICY "os_versions_full_access" ON os_versions FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "cpu_types_full_access" ON cpu_types;
CREATE POLICY "cpu_types_full_access" ON cpu_types FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "ram_sizes_full_access" ON ram_sizes;
CREATE POLICY "ram_sizes_full_access" ON ram_sizes FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "storage_sizes_full_access" ON storage_sizes;
CREATE POLICY "storage_sizes_full_access" ON storage_sizes FOR ALL USING (true) WITH CHECK (true);

-- ============================================
-- SUMMARY
-- ============================================
-- Tables created:
--   - manufacturers (20+ entries)
--   - models (30+ entries)
--   - os_versions (25+ entries)
--   - cpu_types (35+ entries)
--   - ram_sizes (13 entries)
--   - storage_sizes (20 entries)
--   - locations (17+ entries)
--
-- All tables support:
--   - Searchable dropdowns
--   - "Add +" functionality
--   - Auto-complete suggestions
