-- ============================================================================
-- Populate Categories Table - Quick Fix
-- ============================================================================
-- This script updates the categories table with all asset types
-- Run this in Supabase SQL Editor to fix missing categories
-- ============================================================================

-- Delete existing categories (optional - comment out if you want to keep existing)
-- DELETE FROM categories;

-- Insert or update all categories (14 types)
INSERT INTO categories (name, description) VALUES
    ('Accessory', 'Device accessories like keyboards, Apple Pencil, Magic Keyboard, chargers'),
    ('Desktop', 'Desktop computers with OS, memory, CPU specifications and user assignments'),
    ('Laptop', 'Laptop computers with OS, memory, CPU specifications and user assignments'),
    ('Mobile Phone', 'Mobile phones and smartphones with IMEI numbers and transfer tracking'),
    ('Monitor', 'Display monitors assigned to users across departments'),
    ('Network Device', 'Network switches, firewalls, routers, and networking equipment'),
    ('Peripheral', 'IT peripherals including mice, keyboard combos, cables, adapters, USB devices'),
    ('Printer', 'Printers including laser, inkjet, multifunction devices, ID card and label printers'),
    ('Server', 'Physical and virtual servers including ProLiant, Dell, HP models with IP addresses'),
    ('Storage', 'Network Attached Storage (NAS), SAN, and storage devices'),
    ('Switch', 'Network switches and managed switch infrastructure'),
    ('Tablet', 'Tablet devices including iPads with Wi-Fi and cellular connectivity'),
    ('Walkie Talkie', 'Two-way radios and walkie talkie devices with transfer history'),
    ('Other', 'Other assets not fitting into standard categories')
ON CONFLICT (name) 
DO UPDATE SET 
    description = EXCLUDED.description;

-- ============================================================================
-- Verification
-- ============================================================================

-- Show all categories
SELECT 
    id,
    name,
    description,
    created_at
FROM categories 
ORDER BY name;

-- Count categories
SELECT COUNT(*) as total_categories FROM categories;

-- Show categories with asset counts
SELECT 
    c.name as category,
    c.description,
    COUNT(a.id) as asset_count
FROM categories c
LEFT JOIN assets a ON a.category = c.name
GROUP BY c.id, c.name, c.description
ORDER BY c.name;

-- ============================================================================
-- Success Message
-- ============================================================================

DO $$
DECLARE
    cat_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO cat_count FROM categories;
    RAISE NOTICE '✅ Categories table updated successfully!';
    RAISE NOTICE '📊 Total categories: %', cat_count;
    RAISE NOTICE '';
    RAISE NOTICE '📋 Available categories:';
    RAISE NOTICE '   1. Accessory (keyboards, pencils, chargers)';
    RAISE NOTICE '   2. Desktop (desktop computers)';
    RAISE NOTICE '   3. Laptop (laptop computers)';
    RAISE NOTICE '   4. Mobile Phone (smartphones with IMEI)';
    RAISE NOTICE '   5. Monitor (display screens)';
    RAISE NOTICE '   6. Network Device (routers, firewalls)';
    RAISE NOTICE '   7. Peripheral (mice, cables, adapters)';
    RAISE NOTICE '   8. Printer (all printer types)';
    RAISE NOTICE '   9. Server (physical and virtual)';
    RAISE NOTICE '   10. Storage (NAS, SAN devices)';
    RAISE NOTICE '   11. Switch (network switches)';
    RAISE NOTICE '   12. Tablet (iPads and tablets)';
    RAISE NOTICE '   13. Walkie Talkie (two-way radios)';
    RAISE NOTICE '   14. Other (miscellaneous assets)';
    RAISE NOTICE '';
    RAISE NOTICE '✨ Your frontend category dropdown will now show all categories!';
END $$;
