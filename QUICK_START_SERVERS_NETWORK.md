# 🚀 Quick Start - Import Servers & Network Equipment

## ⚡ 3-Step Process

### STEP 1: Fix RLS Policies (URGENT - Fixes 500 Errors!)
```sql
-- Copy contents of: database/fix_rls_complete.sql
-- Paste into: Supabase SQL Editor
-- Click: Run

-- Expected: "✅ RLS policies fixed successfully!"
```

### STEP 2: Import Servers (9 devices)
```sql
-- Copy contents of: database/import_assets_servers_v3.sql
-- Paste into: Supabase SQL Editor
-- Click: Run

-- Expected: "✅ Server import complete! 2 physical + 7 virtual = 9 total"
```

### STEP 3: Import Network Equipment (9 devices)
```sql
-- Copy contents of: database/import_assets_switches_v3.sql
-- Paste into: Supabase SQL Editor
-- Click: Run

-- Expected: "✅ Network equipment import complete! 2 switches + 1 firewall + 6 APs = 9 total"
```

---

## 📊 What You'll Get

### Servers (9)
**Physical:**
- ONEHVMH2 (Gen 10) - 192.168.1.95
- ONEHVMH1 (Gen 11) - 192.168.1.89

**Virtual:**
- ONEHVMH1-VM - Application Server
- 1H-FOCUS - Focus ERP
- ONEH-CHECKSCM - SCM System
- 1H-SERVER - Main App Server
- ONEHVMH2-VM - App Server
- ONEH-PDC - Domain Controller
- OHEH-BACKUP - Backup Server

### Network (9)
**Switches:**
- HP Switch 1H-00099
- HP Switch 1H-00098

**Firewall:**
- SonicWall NSa 2650 (192.168.1.253)

**Access Points:**
- 4x UniFi AC Pro (Reception, West, East, Conference)
- 2x UniFi AC Lite (Warehouse, Parking)

---

## ✅ After Import

### Total Assets
```
Before: 20 desktops
After:  20 desktops + 9 servers + 9 network = 38 total
```

### Check Frontend
1. Refresh browser: `Cmd + Shift + R`
2. Go to `/assets` page
3. Should see 38 assets (no 500 errors!)
4. Try filtering by category

### Test Add Asset
1. Click "Add New Asset"
2. Try creating a new server/network device
3. Verify it appears in list

---

## 🐛 Troubleshooting

**Still seeing 500 errors?**
→ Run Step 1 again (fix_rls_complete.sql)

**Duplicate serial number error?**
→ Normal! Script skips duplicates automatically

**Wrong column order error?**
→ V3 scripts already have correct order

**Frontend not updating?**
→ Hard refresh: `Cmd + Shift + R`

---

## 📁 Files Created Today

✅ `database/import_assets_servers_v3.sql` (9 servers)  
✅ `database/import_assets_switches_v3.sql` (9 network devices)  
✅ `database/fix_rls_complete.sql` (fixes 500 errors)  
✅ `IMPORT_SCRIPTS_V3_SUMMARY.md` (detailed guide)  
✅ `QUICK_START_SERVERS_NETWORK.md` (this file)

---

**Ready to import? Start with Step 1!** 🚀
