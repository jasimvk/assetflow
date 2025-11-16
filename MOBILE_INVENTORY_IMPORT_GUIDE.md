# 📱 Mobile Phone Inventory Import - Complete Guide

## 🎯 What This Does

Imports 70+ mobile phones from `inventroy.txt` with automatic resignation tracking:
- ✅ All users marked as resigned (previous_user field)
- ✅ Devices set to "in_stock" status (available for reassignment)
- ✅ Resignation date set to 2024-11-16
- ✅ Department assignments preserved
- ✅ Complete device history tracked

---

## 📊 Inventory Summary

### Total Devices: **70+ Mobile Phones**

### Device Models:
- **iPhone SE** (13 devices) - AED 1,200-1,400 each
- **Lava Benco V80s** (31 devices) - AED 300-400 each  
- **iPhone 7** (8 devices) - AED 400-900 each
- **Mione Pro** (5 devices) - AED 600 each
- **MiOne Pro Plus** (4 devices) - AED 700 each
- **Vivo** (3 devices) - AED 500 each
- **Benco/Lava** (2 devices) - AED 400 each
- **Other models** (4 devices)

### Department Distribution:
- **Housekeeping**: 26 devices
- **F&B**: 19 devices
- **IT**: 10 devices
- **Project**: 3 devices
- **Maintenance**: 4 devices
- **Catering**: 1 device
- **Admin**: 1 device

### Location Distribution:
- **Office - Floor 1**: 38 devices
- **White Villa**: 28 devices
- **Spanish Villa**: 2 devices

---

## 🚀 How to Import

### Step 1: Run SQL Script in Supabase

**File:** `/database/import_mobile_phone_inventory.sql`

1. Open Supabase Dashboard
2. Go to SQL Editor
3. Copy entire script content
4. Click **"Run"**
5. Wait for completion (~5-10 seconds)

### Step 2: Verify Import

Check the verification queries at the end of the script output:

```sql
-- Total imported
SELECT COUNT(*) FROM assets 
WHERE category = 'Mobile Phone' 
AND name LIKE 'Mobile-%';
```

**Expected Result:** ~70 devices

---

## 📋 What Gets Imported

### Each Mobile Phone Includes:

| Field | Example | Description |
|-------|---------|-------------|
| `name` | Mobile-iPhone-SE-001 | Unique identifier |
| `category` | Mobile Phone | Asset type |
| `model` | iPhone SE | Device model |
| `serial_number` | 356552960554897 | IMEI/Serial |
| `location` | Office - Floor 1 | Physical location |
| `status` | in_stock | Available for reassignment |
| `condition` | good | Device condition |
| `purchase_date` | 2023-11-29 | Original purchase date |
| `purchase_cost` | 1500 | Original cost (AED) |
| `current_value` | 1200 | Current value (AED) |
| `assigned_to` | NULL | Currently unassigned |
| `previous_user` | Chanelle Erwee | Previous employee (resigned) |
| `resigned_date` | 2024-11-16 | Resignation date |
| `resignation_notes` | Employee resigned... | Return notes |
| `department_id` | IT Dept UUID | Department reference |
| `description` | 128GB, Non-Camera | Device specs |

---

## 🔍 Sample Devices

### iPhone SE Devices (13 total)
```
Mobile-iPhone-SE-001 → Chanelle Erwee (IT)
Mobile-iPhone-SE-002 → Kara Conyers (IT)
Mobile-iPhone-SE-003 → Mario Fico (IT)
Mobile-iPhone-SE-004 → Anoj Rodrigo (IT)
... and 9 more
```

### Lava Benco V80s (31 total)
```
Mobile-Lava-Benco-001 → Iana Bicova (F&B)
Mobile-Lava-Benco-002 → Dane Lemmer (F&B)
Mobile-Lava-Benco-003 → Chanida Pannue (F&B)
... and 28 more
```

### iPhone 7 (8 total)
```
Mobile-iPhone-7-001 → Maria Sole (F&B)
Mobile-iPhone-7-002 → Sofia Romanenko (F&B)
... and 6 more
```

---

## 📊 Reports You Can Generate

### 1. All Available Mobile Phones
```sql
SELECT 
  name,
  model,
  serial_number,
  previous_user,
  location,
  current_value
FROM assets
WHERE category = 'Mobile Phone'
  AND status = 'in_stock'
  AND assigned_to IS NULL
ORDER BY model, name;
```

### 2. Devices by Department
```sql
SELECT 
  d.name as department,
  COUNT(*) as device_count,
  array_agg(a.model) as models,
  SUM(a.current_value) as total_value
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Mobile Phone'
  AND a.name LIKE 'Mobile-%'
GROUP BY d.name
ORDER BY device_count DESC;
```

### 3. Devices by Model
```sql
SELECT 
  model,
  COUNT(*) as count,
  AVG(current_value) as avg_value,
  MIN(purchase_date) as oldest,
  MAX(purchase_date) as newest
FROM assets
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
GROUP BY model
ORDER BY count DESC;
```

### 4. High Value Devices (>AED 1000)
```sql
SELECT 
  name,
  model,
  serial_number,
  current_value,
  previous_user,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND current_value > 1000
ORDER BY current_value DESC;
```

### 5. Recently Added Devices (2024+)
```sql
SELECT 
  name,
  model,
  purchase_date,
  current_value,
  previous_user,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND purchase_date >= '2024-01-01'
ORDER BY purchase_date DESC;
```

---

## 🎨 Frontend Display

### Assets Page Will Show:
- ✅ All 70+ mobile phones in the table
- ✅ Status: "In Stock" (green badge)
- ✅ Assigned To: "-" (unassigned)
- ✅ Department names (via JOIN)
- ✅ Location, Model, Serial Number
- ✅ Current Value in AED

### Detail Modal Will Show:
- ✅ Previous User: Name of resigned employee
- ✅ Resigned Date: 2024-11-16
- ✅ Resignation Notes: "Employee resigned - Device returned to inventory"
- ✅ Complete device history

### Filters Work:
- ✅ Category: Mobile Phone
- ✅ Status: In Stock
- ✅ Location: Office/White Villa/Spanish Villa
- ✅ Department: IT, HR, F&B, Housekeeping, etc.

---

## 💡 What To Do Next

### Option 1: Reassign Devices
Use the frontend to assign devices to new employees:
1. Filter by Status = "In Stock"
2. Select multiple devices (bulk selection)
3. Use "Bulk Assign" to assign to new users

### Option 2: Update Device Status
Some devices may need maintenance:
```sql
UPDATE assets
SET 
  status = 'maintenance',
  notes = 'Requires factory reset before reassignment'
WHERE serial_number IN ('serial1', 'serial2');
```

### Option 3: Retire Old Devices
Retire devices purchased before 2022:
```sql
UPDATE assets
SET 
  status = 'retired',
  notes = 'Device too old - scheduled for disposal'
WHERE category = 'Mobile Phone'
  AND purchase_date < '2022-01-01';
```

### Option 4: Export Inventory
Use the Export CSV button to download:
- Complete device list
- Available for reassignment
- By department/location
- For audit purposes

---

## 🔄 Data Flow

```
inventroy.txt
      ↓
Parse Data
      ↓
Create SQL INSERT statements
      ↓
Set all as: status = 'in_stock'
Set all as: assigned_to = NULL
Move current user to: previous_user
Add: resigned_date = 2024-11-16
Add: resignation_notes
      ↓
Import to Supabase
      ↓
Display in Frontend
      ↓
Ready for Reassignment
```

---

## ✅ Verification Checklist

After import, verify:

- [ ] ~70 mobile phones imported
- [ ] All have status = "in_stock"
- [ ] All have assigned_to = NULL
- [ ] All have previous_user filled
- [ ] All have resigned_date = 2024-11-16
- [ ] Department assignments correct
- [ ] Locations match source data
- [ ] Serial numbers unique (no duplicates)
- [ ] Current values reasonable
- [ ] Frontend displays all devices
- [ ] Filters work correctly
- [ ] Search finds devices
- [ ] Department column shows names

---

## 🚨 Important Notes

### Serial Number Handling
- ✅ Script uses `ON CONFLICT (serial_number) DO NOTHING`
- ✅ Prevents duplicate imports
- ✅ Safe to run multiple times

### Data Preservation
- ✅ Original user names saved in `previous_user`
- ✅ Historical data preserved
- ✅ Can track device usage over time

### No Active Users
- ✅ All devices marked as resigned users
- ✅ All available for immediate reassignment
- ✅ No conflicts with active employees

---

## 📈 Value Summary

### Total Inventory Value (Estimated)

| Model | Count | Avg Value | Total Value |
|-------|-------|-----------|-------------|
| iPhone SE | 13 | AED 1,200 | AED 15,600 |
| iPhone 7 | 8 | AED 650 | AED 5,200 |
| Lava Benco V80s | 31 | AED 380 | AED 11,780 |
| Mione Pro | 5 | AED 600 | AED 3,000 |
| MiOne Pro Plus | 4 | AED 700 | AED 2,800 |
| Vivo | 3 | AED 500 | AED 1,500 |
| Other | 6 | AED 450 | AED 2,700 |

**Total Estimated Value: ~AED 42,580**

---

## 🎯 Quick Reference

### Import Command:
```bash
Run: /database/import_mobile_phone_inventory.sql
```

### Check Total:
```sql
SELECT COUNT(*) FROM assets WHERE category = 'Mobile Phone';
```

### Check Available:
```sql
SELECT COUNT(*) FROM assets 
WHERE category = 'Mobile Phone' AND status = 'in_stock';
```

### Find Device by Serial:
```sql
SELECT * FROM assets WHERE serial_number = 'SERIAL_HERE';
```

### Find by Previous User:
```sql
SELECT * FROM assets WHERE previous_user ILIKE '%name%';
```

---

## 📞 Support

If import fails:
1. Check if departments table exists
2. Run `/database/link_assets_to_departments.sql` first
3. Verify Supabase connection
4. Check RLS policies allow insert
5. Review error message for specific issue

---

**Status:** ✅ Ready to Import  
**Total Devices:** 70+  
**Total Value:** ~AED 42,580  
**All Available:** Yes (in_stock)  
**Date:** November 16, 2025
