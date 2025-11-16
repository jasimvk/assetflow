-- ============================================================================
-- Windows Upgrade Status Update Script
-- AssetFlow - Update existing assets with Windows 11 upgrade assessment
-- ============================================================================
-- This script UPDATES existing assets with upgrade assessment information
-- instead of inserting new records (to avoid duplicate key errors)
-- 
-- Use this script when devices already exist in the database
-- ============================================================================

BEGIN;

-- Update devices with Windows upgrade assessment status

-- 1. DESKTOP-ALRAKNA - HP 250 G7 Notebook (Not Upgradable)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Windows 11 Assessment Required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i3-1005G1 CPU @ 1.20GHz'),
    memory = COALESCE(memory, '4GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'CND03624ZT';

-- 2. ONEH-SECURITY-SVE - HP ProBook 440 G6 (Not Upgradable)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Not meet minimum requirements',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i7-8565U CPU @ 1.80GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '5CD9229NMV';

-- 3. DESKTOP-M98OH3O - Lenovo ThinkPad E580 (Not Upgradable)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Windows 11 Assessment Required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'PF0Y6NKH';

-- 4. ONEH-RASHEED - Dell XPS 15 9530 (Change License - Already Windows 11)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Change License - Upgrade Home to Pro',
    os_version = COALESCE(os_version, 'Windows 11 Home'),
    cpu_type = COALESCE(cpu_type, '13th Gen Intel(R) Core(TM) i7-13700H'),
    memory = COALESCE(memory, '16GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '626MBY3';

-- 5. DESKTOP-9SE3UD1 - Kitchen Desktop (Unknown Model)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Model and specs unknown - Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '16789414745';

-- 6. DESKTOP-ALRAKNA-2 - Al Rakna Desktop (Duplicate name, different serial)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Model and specs unknown - Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'CNDO3624ZT';

-- 7. ONEH-FEMALE-SEC - HP Laptop 15 (Not Upgradable)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Insufficient RAM (4GB minimum for Win11)',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz'),
    memory = COALESCE(memory, '4GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'CND0336J4D';

-- 8. Laptop-5CD0493H2B - Souria Latroch F&B (Unknown Model)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Model and specs unknown - Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '5CD0493H2B';

-- 9. Laptop-PF44JFV5 - Shecill Manzano F&B (ThinkPad E14)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Specs unknown - Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'PF44JFV5';

-- 10. LAPTOP-HK-ALYAS - HP Laptop 15 Al Yasat
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'To be verified - Upgrade eligibility assessment pending',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'CND009294H';

-- 11. ONEH-ADINA - Dell XPS 15 9520 (Change License - Already Windows 11)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Change License - Upgrade Home to Pro',
    os_version = COALESCE(os_version, 'Windows 11 Home'),
    cpu_type = COALESCE(cpu_type, '12th Gen Intel(R) Core(TM) i7-12700H'),
    memory = COALESCE(memory, '16GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '67LFTV3';

-- 12. ONEH-BABU - Dell XPS 15 9520 (Change License - Already Windows 11)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Change License - Upgrade Home to Pro',
    os_version = COALESCE(os_version, 'Windows 11 Home'),
    cpu_type = COALESCE(cpu_type, '12th Gen Intel(R) Core(TM) i7-12700H'),
    memory = COALESCE(memory, '16GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'IT9GTV3';

-- 13. ONEH-OSHBAH - HP ProBook 450 G5 (Old Stock)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Old Stock - Assessment required before redeployment',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain'),
    status = 'in_stock'
WHERE serial_number = '5CD815723K';

-- 14. ONEH-ASHOK - Lenovo ThinkPad E580 Laundry
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'PF0Y6NH7';

-- 15. ONEH-FARAH - Finance Desktop (Upgradable)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Upgradable - Ready for Windows 11',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '4CE142B9RK';

-- 16. DESKTOP-Security Gate HO - HP 290 G4 Microtower (On Process)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Onprocess - Upgrade in progress',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '4CE124X5F0';

-- 17. DESKTOP-ALRAKNA-HP290 - HP 290 G4 Al Rakna
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '4CE124X56D';

-- 18. DESKTOP-ILDS3T1 - HP 290 G4 Al Rawda
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '4CE124X57G';

-- 19. Desktop-4CE9091SJC - White Villa Desktop
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Model and specs unknown - Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '4CE9091SJC';

-- 20. SVE-HK-EXTERIOR - Dell OptiPlex 7050 (Not Upgradable - 7th Gen)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Processor not supported windows 11 (7th Gen Intel)',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz'),
    memory = COALESCE(memory, '12GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'G3P9TJ2';

-- 21. DESKTOP-ANNALIZA - HP 290 G2 MT Barari Villa
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Assessment required',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-8400 CPU @ 2.80GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = '8CG915BY3Q';

-- 22. DESKTOP-ANSAR - HP ProDesk 400 G1 (Not Upgradable - 4th Gen)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Very old hardware (4th Gen Intel, 2014)',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i5-4570 CPU @ 3.20GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain'),
    condition = 'fair'
WHERE serial_number = 'CZC4393PXN';

-- 23. LAPTOP-SVE-HKE - HP Laptop 15 Spanish Villa (Not Upgradable)
UPDATE assets SET
    notes = COALESCE(notes || ' | ', '') || 'Not Upgradable - Not meet minimum requirements',
    os_version = COALESCE(os_version, 'Windows 10 Pro'),
    cpu_type = COALESCE(cpu_type, 'Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz'),
    memory = COALESCE(memory, '8GB'),
    domain_status = COALESCE(domain_status, 'Non Domain')
WHERE serial_number = 'CND009296N';

COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Count updated assets
SELECT COUNT(*) as updated_assets 
FROM assets 
WHERE serial_number IN (
    'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
    'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
    '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
    '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
    '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
);

-- View updated devices with upgrade status
SELECT 
    name,
    model,
    os_version,
    cpu_type,
    memory,
    assigned_to,
    location,
    notes
FROM assets 
WHERE serial_number IN (
    'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
    'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
    '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
    '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
    '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
)
ORDER BY 
    CASE 
        WHEN notes LIKE '%Not Upgradable%' THEN 1
        WHEN notes LIKE '%Assessment required%' THEN 2
        WHEN notes LIKE '%Upgradable%' THEN 3
        WHEN notes LIKE '%Change License%' THEN 4
        ELSE 5
    END,
    name;

-- Summary by upgrade status
SELECT 
    CASE 
        WHEN notes LIKE '%Not Upgradable%' THEN 'Not Upgradable'
        WHEN notes LIKE '%Upgradable%' AND notes NOT LIKE '%Not Upgradable%' THEN 'Upgradable'
        WHEN notes LIKE '%Change License%' THEN 'License Change Required'
        WHEN notes LIKE '%Onprocess%' THEN 'Upgrade In Progress'
        WHEN notes LIKE '%Assessment%' THEN 'Assessment Required'
        ELSE 'Unknown'
    END as upgrade_status,
    COUNT(*) as count
FROM assets 
WHERE serial_number IN (
    'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
    'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
    '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
    '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
    '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
)
GROUP BY upgrade_status
ORDER BY count DESC;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
DECLARE
    updated_count INTEGER;
    not_upgradable INTEGER;
    upgradable INTEGER;
    license_change INTEGER;
    assessment_needed INTEGER;
BEGIN
    SELECT COUNT(*) INTO updated_count 
    FROM assets 
    WHERE serial_number IN (
        'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
        'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
        '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
        '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
        '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
    );
    
    SELECT COUNT(*) INTO not_upgradable 
    FROM assets 
    WHERE notes LIKE '%Not Upgradable%'
      AND serial_number IN (
        'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
        'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
        '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
        '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
        '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
    );
    
    SELECT COUNT(*) INTO upgradable 
    FROM assets 
    WHERE notes LIKE '%Upgradable%' 
      AND notes NOT LIKE '%Not Upgradable%'
      AND serial_number IN (
        'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
        'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
        '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
        '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
        '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
    );
    
    SELECT COUNT(*) INTO license_change 
    FROM assets 
    WHERE notes LIKE '%Change License%'
      AND serial_number IN (
        'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
        'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
        '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
        '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
        '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
    );
    
    SELECT COUNT(*) INTO assessment_needed 
    FROM assets 
    WHERE notes LIKE '%Assessment%'
      AND notes NOT LIKE '%Not Upgradable%'
      AND serial_number IN (
        'CND03624ZT', '5CD9229NMV', 'PF0Y6NKH', '626MBY3', '16789414745',
        'CNDO3624ZT', 'CND0336J4D', '5CD0493H2B', 'PF44JFV5', 'CND009294H',
        '67LFTV3', 'IT9GTV3', '5CD815723K', 'PF0Y6NH7', '4CE142B9RK',
        '4CE124X5F0', '4CE124X56D', '4CE124X57G', '4CE9091SJC', 'G3P9TJ2',
        '8CG915BY3Q', 'CZC4393PXN', 'CND009296N'
    );

    RAISE NOTICE '✅ Windows Upgrade Assessment Update Complete!';
    RAISE NOTICE '💻 Total Devices Updated: %', updated_count;
    RAISE NOTICE '❌ Not Upgradable (Replacement Needed): %', not_upgradable;
    RAISE NOTICE '✅ Upgradable (Can Install Windows 11): %', upgradable;
    RAISE NOTICE '🔑 License Change Required (Already Windows 11): %', license_change;
    RAISE NOTICE '⚠️  Assessment Required: %', assessment_needed;
    RAISE NOTICE '';
    RAISE NOTICE '📋 Key Actions Required:';
    RAISE NOTICE '   1. Replace % devices with incompatible hardware', not_upgradable;
    RAISE NOTICE '   2. Upgrade % devices to Windows 11 Pro', upgradable;
    RAISE NOTICE '   3. Change license for % Dell XPS devices from Home to Pro', license_change;
    RAISE NOTICE '   4. Complete assessment for % devices with unknown specs', assessment_needed;
END $$;
