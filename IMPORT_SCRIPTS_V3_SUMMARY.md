# Import Scripts Summary - V3 (V2 Schema Compatible)

## 📋 Available Import Scripts

### ✅ COMPLETED
1. **`import_assets_desktops_v3.sql`** - 20 Desktop computers (TESTED & WORKING)
2. **`import_assets_servers_v3.sql`** - 9 Servers (2 physical + 7 virtual) (NEW)
3. **`import_assets_switches_v3.sql`** - 9 Network devices (2 switches + 1 firewall + 6 APs) (NEW)
4. **`import_assets_storage_v3.sql`** - 3 Storage devices (Synology NAS) (NEW)

### 🔄 TO BE CREATED
5. **`import_assets_laptops_v3.sql`** - Laptop computers (pending)
6. **`import_assets_monitors_v3.sql`** - Monitors and displays (pending)
7. **`import_assets_mobile_v3.sql`** - Mobile phones and tablets (pending)
8. **`import_assets_peripherals_v3.sql`** - Printers, scanners, etc. (pending)

---

## 🎯 Current Status

### What's Ready to Import:

#### 1. Servers (9 devices)
**File**: `database/import_assets_servers_v3.sql`

**Physical Servers (2):**
- ✅ ONEHVMH2 (HP ProLiant DL360 Gen 10)
  - CPU: Intel Xeon Gold 6248 (24 cores @ 3.00GHz)
  - RAM: 64 GB
  - Storage: 7.5 TB SSD
  - IP: 192.168.1.95 | ILO: 192.168.1.92

- ✅ ONEHVMH1 (HP ProLiant DL360 Gen 11)
  - CPU: Intel Xeon (Gen 11)
  - RAM: 128 GB
  - Storage: 10 TB
  - IP: 192.168.1.89 | ILO: 192.168.1.91
  - Warranty: Until 02/02/2028

**Virtual Servers (7):**
- ✅ ONEHVMH1-VM (Application Server)
- ✅ 1H-FOCUS (Focus ERP System)
- ✅ ONEH-CHECKSCM (Supply Chain Management)
- ✅ 1H-SERVER (Main Application Server)
- ✅ ONEHVMH2-VM (Application Server)
- ✅ ONEH-PDC (Primary Domain Controller)
- ✅ OHEH-BACKUP (Backup Server - 5TB storage)

**V2 Schema Fields Populated:**
- ✅ OS Version (Windows Server 2019/2022)
- ✅ CPU Type (Xeon processors)
- ✅ Memory (8GB - 128GB)
- ✅ Storage (250GB - 10TB)
- ✅ IP Address, MAC Address, ILO IP
- ✅ Domain Status
- ✅ Function (Virtualization Host, Application Server, etc.)
- ✅ Physical/Virtual designation
- ✅ In-Office Location (Server Room)

---

#### 2. Network Equipment (9 devices)
**File**: `database/import_assets_switches_v3.sql`

**Switches (2):**
- ✅ HP Switch 1H-00099 (CN34DRW029)
  - Model: HP 2620-48 POE+ Switch J9624J
  - 48 ports with PoE+

- ✅ HP Switch 1H-00098 (CN33DRW1N0)
  - Model: HP 2620-48 POE+ Switch J9624J
  - 48 ports with PoE+

**Firewall (1):**
- ✅ SonicWall Firewall (FW-001)
  - Model: SonicWall NSa 2650
  - IP: 192.168.1.253
  - MAC: 2C:B8:ED:29:97:40

**Access Points (6):**
- ✅ UniFi AP Pro AP-001 (192.168.0.8) - Reception
- ✅ UniFi AP Pro AP-002 (192.168.0.246) - West Wing
- ✅ UniFi AP Pro AP-003 (192.168.1.151) - East Wing
- ✅ UniFi AP Pro AP-004 (192.168.0.130) - Conference Room
- ✅ UniFi AP Lite AP-005 (192.168.1.161) - Warehouse
- ✅ UniFi AP Lite AP-006 (192.168.0.89) - Parking Area

**V2 Schema Fields Populated:**
- ✅ IP Address (all network devices)
- ✅ MAC Address (firewall and APs)
- ✅ Function (Firewall, Switch, WiFi AP)
- ✅ In-Office Location (Network Room, specific areas)
- ✅ Specifications (port counts, capabilities)
- ✅ Asset Codes (1H-00099, FW-001, AP-001, etc.)

---

## 🚀 How to Import

### Prerequisites (IMPORTANT!)
1. ✅ **Fix RLS policies first**:
   ```bash
   Run: database/fix_rls_complete.sql
   ```
   This fixes the 500 errors you're seeing in the frontend!

2. ✅ **Verify V2 migration completed**:
   ```sql
   SELECT column_name 
   FROM information_schema.columns 
   WHERE table_name = 'assets' 
   ORDER BY ordinal_position;
   ```
   Should show 40+ columns

### Import Steps

#### Step 1: Fix RLS (If not already done)
```sql
-- Run in Supabase SQL Editor
-- File: database/fix_rls_complete.sql
-- This will fix your 500 errors!
```

#### Step 2: Import Servers
```sql
-- Run in Supabase SQL Editor
-- File: database/import_assets_servers_v3.sql
-- Expected result: 9 servers imported
```

#### Step 3: Import Network Equipment
```sql
-- Run in Supabase SQL Editor
-- File: database/import_assets_switches_v3.sql
-- Expected result: 9 network devices imported
```

---

## 📊 Import Summary

### Already Imported ✅
| Category | Count | Status | Details |
|----------|-------|--------|---------|
| Desktop  | 20    | ✅ DONE | Via import_assets_desktops_v3.sql |

### Ready to Import 🎯
| Category | Count | Status | Script |
|----------|-------|--------|--------|
| Server   | 9     | 📝 READY | import_assets_servers_v3.sql |
| Switch   | 9     | 📝 READY | import_assets_switches_v3.sql |
| Storage  | 3     | 📝 READY | import_assets_storage_v3.sql |

**Total Ready**: 21 assets (9 servers + 9 network + 3 storage)

### Pending Creation 🔄
| Category | Count | Status | Notes |
|----------|-------|--------|-------|
| Laptop   | TBD   | ⏳ PENDING | Create import_assets_laptops_v3.sql |
| Monitor  | TBD   | ⏳ PENDING | Create import_assets_monitors_v3.sql |
| Mobile   | TBD   | ⏳ PENDING | Phones, tablets, walkie talkies |
| Printer  | TBD   | ⏳ PENDING | Printers and peripherals |

---

## 🔧 V3 Script Format

All V3 scripts follow this format:

### Column Order (CRITICAL!)
```sql
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
  
  -- V2 New Columns (positions 23-40)
  os_version,
  cpu_type,
  memory,
  storage,
  ip_address,
  mac_address,
  ilo_ip,
  sentinel_status,
  ninja_status,
  domain_status,
  in_office_location,
  function,
  physical_virtual,
  specifications,
  notes
) VALUES ...
```

### Why This Order?
When you ran `migrate_to_v2_schema.sql`, it used **ALTER TABLE ADD COLUMN**. This adds new columns **at the END** of the table, not in the CREATE TABLE order.

**Actual Table Structure:**
- Columns 1-22: Original V1 fields
- Columns 23-40: New V2 fields (added at end)

### Key Features
- ✅ **Conflict handling**: `ON CONFLICT (serial_number) DO NOTHING`
- ✅ **Category creation**: Ensures category exists before import
- ✅ **Verification queries**: Shows imported data
- ✅ **Summary statistics**: Counts and groupings
- ✅ **Detailed comments**: Explains each section

---

## 📈 Expected Results

After importing all available scripts:

```
Total Assets in Database:
- Desktops:           20 ✅ (IMPORTED)
- Servers:            9  🎯 (READY)
- Network Equipment:  9  🎯 (READY)
- Storage:            3  🎯 (READY)
- Laptops:            ?  ⏳ (PENDING)
- Monitors:           ?  ⏳ (PENDING)
- Other:              ?  ⏳ (PENDING)

TOTAL AVAILABLE: 41 assets (20 + 9 + 9 + 3)
```

---

## 🎯 Next Steps

### Immediate Actions:
1. ✅ **Fix RLS policies** (fixes 500 errors in frontend)
   - Run: `database/fix_rls_complete.sql`
   - This is URGENT - your frontend won't work until this is done!

2. 🎯 **Import servers**
   - Run: `database/import_assets_servers_v3.sql`
   - Result: 9 servers (2 physical + 7 virtual)

3. 🎯 **Import network equipment**
   - Run: `database/import_assets_switches_v3.sql`
   - Result: 9 devices (switches, firewall, APs)

4. 🔄 **Test frontend**
   - Navigate to `/assets` page
   - Should see 38 total assets (20 desktops + 9 servers + 9 network)
   - No more 500 errors!

### Future Actions:
5. Create remaining import scripts:
   - Laptops
   - Monitors
   - Storage devices
   - Mobile devices
   - Peripherals

6. Test frontend asset creation form (`/add-asset`)

---

## 🐛 Troubleshooting

### Issue: 500 Errors in Frontend
**Solution**: Run `fix_rls_complete.sql` first!
```sql
-- This creates permissive RLS policies
-- Allows all operations with USING (true)
```

### Issue: Column Order Errors
**Symptom**: `ERROR: invalid input syntax for type uuid`
**Solution**: V3 scripts already have correct column order
- V1 columns first (1-22)
- V2 columns after (23-40)

### Issue: Duplicate Serial Numbers
**Symptom**: `ERROR: duplicate key value violates unique constraint`
**Solution**: Script has `ON CONFLICT (serial_number) DO NOTHING`
- Skips duplicates automatically
- Check existing data first if needed

### Issue: Missing Categories
**Symptom**: `ERROR: insert or update violates foreign key constraint`
**Solution**: Each script creates its category first
```sql
INSERT INTO categories (name, description) 
VALUES ('Server', '...')
ON CONFLICT (name) DO NOTHING;
```

---

## 📚 Documentation Reference

- **V2 Schema**: `database/SCHEMA_V2_SUMMARY.md`
- **Migration Guide**: `database/SCHEMA_V2_MIGRATION_GUIDE.md`
- **RLS Fix Guide**: `FIX_RLS_500_ERRORS.md`
- **Frontend Guide**: `ADD_ASSET_FEATURE_GUIDE.md`
- **Complete Summary**: `FRONTEND_ASSET_CREATION_SUMMARY.md`

---

## ✅ Quality Checklist

Before importing, verify:
- [ ] RLS policies fixed (run fix_rls_complete.sql)
- [ ] V2 migration completed (40+ columns exist)
- [ ] Categories table has required categories
- [ ] No duplicate serial numbers in import data
- [ ] IP addresses are valid format (if provided)
- [ ] Column order matches migrated table structure

After importing, verify:
- [ ] Correct count of assets imported
- [ ] No error messages in SQL output
- [ ] Verification queries return expected data
- [ ] Frontend shows imported assets
- [ ] Asset details display correctly

---

**Status**: 🎯 Ready to import servers and network equipment!  
**Next Action**: Fix RLS policies, then run server and network import scripts  
**Created**: November 2025  
**Schema Version**: V2 (40+ fields)
