# 📱 Mobile Phone Resignation Management Guide

## Overview
Comprehensive guide for managing mobile phones when employees resign, including tracking previous users and resignation history.

---

## 🎯 What This Does

When an employee resigns, you need to:
1. ✅ **Unassign** the mobile phone from the resigned user
2. ✅ **Track** who previously had the device (previous_user)
3. ✅ **Record** resignation date and notes
4. ✅ **Update** status to "in_stock" or "maintenance"
5. ✅ **Prepare** device for reassignment

---

## 📊 New Fields Added

### Database Schema Changes

Three new columns added to `assets` table:

| Field | Type | Purpose |
|-------|------|---------|
| `previous_user` | VARCHAR(255) | Name of employee who resigned |
| `resigned_date` | DATE | Date when employee resigned |
| `resignation_notes` | TEXT | Notes about device return, condition, etc. |

### Frontend Interface Updated

```typescript
interface Asset {
  // ... existing fields
  assigned_to: string | null;
  previous_user?: string | null;      // NEW
  resigned_date?: string | null;      // NEW
  resignation_notes?: string | null;  // NEW
}
```

---

## 🚀 How to Use

### Step 1: Run SQL Script in Supabase

**File:** `/database/update_resigned_mobile_phones.sql`

1. Open Supabase Dashboard
2. Go to SQL Editor
3. Copy entire script
4. Run sections based on your needs

---

### Step 2: Choose Update Strategy

#### **Option A: Update ALL Mobile Phones**
Use this if all currently assigned mobile phone users have resigned:

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = CURRENT_DATE,
  status = 'in_stock',
  resignation_notes = 'User resigned - Asset returned to inventory'
WHERE category = 'Mobile Phone'
  AND assigned_to IS NOT NULL;
```

**Result:** All mobile phones become unassigned and marked as available.

---

#### **Option B: Update Specific Users**
Use this for specific resigned employees:

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-16',
  status = 'in_stock',
  resignation_notes = 'Employee resigned - Device returned to IT'
WHERE category = 'Mobile Phone'
  AND assigned_to IN ('John Doe', 'Jane Smith', 'Bob Johnson');
```

**Result:** Only mobile phones assigned to listed users are updated.

---

#### **Option C: Update by Serial Number**
Use this when you know specific device serial numbers:

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-16',
  status = 'in_stock',
  resignation_notes = 'Employee resigned - Device cleared'
WHERE serial_number IN ('MP-001', 'MP-002', 'MP-003');
```

**Result:** Only devices with specified serial numbers are updated.

---

### Step 3: Choose Device Status

#### **Status Options:**

**`in_stock`** - Device ready for immediate reassignment
```sql
status = 'in_stock',
resignation_notes = 'Device cleared and ready for reassignment'
```

**`maintenance`** - Device needs servicing before reassignment
```sql
status = 'maintenance',
resignation_notes = 'Requires factory reset and security wipe'
```

**`retired`** - Device too old, schedule for disposal
```sql
status = 'retired',
resignation_notes = 'Device outdated - scheduled for disposal'
```

---

## 📋 Example Scenarios

### Scenario 1: Single Employee Resigned Today

**Situation:** John Doe resigned today, return his mobile phone.

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-16',
  status = 'in_stock',
  resignation_notes = 'John Doe resigned on 2025-11-16. Device returned, cleared, and ready for reassignment.'
WHERE category = 'Mobile Phone'
  AND assigned_to = 'John Doe';
```

---

### Scenario 2: Multiple Resignations in October

**Situation:** 5 employees resigned in October, return all their devices.

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-10-31',
  status = 'in_stock',
  resignation_notes = 'October 2025 resignations - Devices returned and inventoried'
WHERE category = 'Mobile Phone'
  AND assigned_to IN (
    'Employee A',
    'Employee B', 
    'Employee C',
    'Employee D',
    'Employee E'
  );
```

---

### Scenario 3: Device Needs Factory Reset

**Situation:** Device returned but needs IT to wipe it first.

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = CURRENT_DATE,
  status = 'maintenance',
  resignation_notes = 'Requires factory reset, iCloud removal, and security wipe before reassignment'
WHERE category = 'Mobile Phone'
  AND assigned_to = 'Jane Smith';
```

---

### Scenario 4: Bulk Update - Mass Layoff

**Situation:** Company layoff, 20+ employees, return all mobile phones.

```sql
UPDATE assets
SET 
  previous_user = assigned_to,
  assigned_to = NULL,
  resigned_date = '2025-11-15',
  status = 'in_stock',
  resignation_notes = 'November 2025 organizational restructuring - Device returned to IT'
WHERE category = 'Mobile Phone'
  AND assigned_to IS NOT NULL;
```

---

## 🔍 Verification Queries

### Check Updated Mobile Phones

```sql
SELECT 
  name,
  serial_number,
  previous_user,
  resigned_date,
  status,
  resignation_notes
FROM assets
WHERE category = 'Mobile Phone'
  AND previous_user IS NOT NULL
ORDER BY resigned_date DESC;
```

---

### Find Available Devices for Reassignment

```sql
SELECT 
  name,
  serial_number,
  model,
  previous_user,
  resigned_date,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND assigned_to IS NULL
  AND status = 'in_stock'
ORDER BY name;
```

---

### Resignation Statistics

```sql
SELECT 
  COUNT(*) as total_mobile_phones,
  COUNT(assigned_to) as currently_assigned,
  COUNT(previous_user) as resigned_user_devices,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as available_stock
FROM assets
WHERE category = 'Mobile Phone';
```

---

### Monthly Resignation Report

```sql
SELECT 
  TO_CHAR(resigned_date, 'YYYY-MM') as month,
  COUNT(*) as devices_returned,
  array_agg(previous_user) as resigned_users
FROM assets
WHERE category = 'Mobile Phone'
  AND resigned_date IS NOT NULL
GROUP BY TO_CHAR(resigned_date, 'YYYY-MM')
ORDER BY month DESC;
```

---

## 📊 Reporting Views

### Create Resigned User View

```sql
CREATE OR REPLACE VIEW resigned_user_mobile_phones AS
SELECT 
  id,
  name,
  serial_number,
  model,
  previous_user,
  resigned_date,
  status,
  location,
  current_value,
  resignation_notes,
  CASE 
    WHEN status = 'in_stock' THEN 'Available for Reassignment'
    WHEN status = 'maintenance' THEN 'Needs Service'
    WHEN status = 'retired' THEN 'Scheduled for Disposal'
    ELSE 'Check Status'
  END as availability_status
FROM assets
WHERE category = 'Mobile Phone'
  AND previous_user IS NOT NULL
ORDER BY resigned_date DESC;
```

**Query the view:**
```sql
SELECT * FROM resigned_user_mobile_phones;
```

---

## 🎨 Frontend Display

### Assets Table - Show Previous User

The assets page will now display:
- **Assigned To:** Current user (if any)
- **Previous User:** Shows in detail modal
- **Resigned Date:** When user resigned
- **Resignation Notes:** Additional context

### Filter by Status

Users can filter:
- **In Stock** - Available devices from resigned users
- **Maintenance** - Devices needing service
- **Active** - Currently assigned devices

---

## 📝 Best Practices

### When Employee Resigns:

1. **Immediate Actions:**
   - Run SQL to unassign device
   - Record resignation date
   - Update status appropriately

2. **Device Processing:**
   - If ready: Set to `in_stock`
   - If needs work: Set to `maintenance`
   - If too old: Set to `retired`

3. **Documentation:**
   - Add detailed resignation notes
   - Include device condition
   - Note any issues found

4. **Security:**
   - Factory reset device
   - Remove accounts (iCloud, Google)
   - Wipe company data
   - Update status when complete

---

## 🔄 Workflow Example

### Complete Resignation Workflow:

```
Employee Resigns
      ↓
Collect Device
      ↓
Run SQL Update (unassign + track previous user)
      ↓
Physical Inspection
      ↓
If OK → Set status: in_stock
If Broken → Set status: maintenance
If Old → Set status: retired
      ↓
Document in resignation_notes
      ↓
Device Ready for Reassignment
```

---

## 📈 Reports You Can Generate

### 1. Devices by Status
```sql
SELECT status, COUNT(*) 
FROM assets 
WHERE category = 'Mobile Phone' 
GROUP BY status;
```

### 2. Resignation Timeline
```sql
SELECT resigned_date, COUNT(*) as devices_returned
FROM assets 
WHERE category = 'Mobile Phone' AND resigned_date IS NOT NULL
GROUP BY resigned_date 
ORDER BY resigned_date DESC;
```

### 3. Available Inventory
```sql
SELECT name, model, location 
FROM assets 
WHERE category = 'Mobile Phone' 
  AND status = 'in_stock' 
  AND assigned_to IS NULL;
```

### 4. Devices Needing Maintenance
```sql
SELECT name, previous_user, resignation_notes 
FROM assets 
WHERE category = 'Mobile Phone' 
  AND status = 'maintenance';
```

---

## 🚨 Important Notes

### Data Preservation
- ✅ Original `assigned_to` moves to `previous_user`
- ✅ Historical data preserved
- ✅ Can track device history over time

### Reversibility
If you need to revert (BE CAREFUL!):
```sql
UPDATE assets
SET 
  assigned_to = previous_user,
  previous_user = NULL,
  resigned_date = NULL,
  resignation_notes = NULL,
  status = 'active'
WHERE category = 'Mobile Phone'
  AND previous_user = 'Specific User Name';
```

---

## 🎯 Quick Reference Commands

### Unassign ALL mobile phones:
```sql
UPDATE assets SET previous_user = assigned_to, assigned_to = NULL, 
resigned_date = CURRENT_DATE, status = 'in_stock' 
WHERE category = 'Mobile Phone' AND assigned_to IS NOT NULL;
```

### Unassign SPECIFIC user:
```sql
UPDATE assets SET previous_user = assigned_to, assigned_to = NULL, 
resigned_date = '2025-11-16', status = 'in_stock' 
WHERE category = 'Mobile Phone' AND assigned_to = 'User Name';
```

### Check results:
```sql
SELECT name, previous_user, resigned_date, status 
FROM assets WHERE category = 'Mobile Phone' AND previous_user IS NOT NULL;
```

---

## ✅ Success Checklist

After running updates, verify:

- [ ] Mobile phones unassigned (assigned_to = NULL)
- [ ] Previous users tracked (previous_user filled)
- [ ] Resignation dates recorded
- [ ] Status updated appropriately
- [ ] Resignation notes added
- [ ] Available devices count correct
- [ ] Frontend displays updated data
- [ ] No data loss (previous_user has original assignments)

---

## 📞 Support

If you need help:
1. Check verification queries in SQL script
2. Review resignation_notes for device status
3. Use the resigned_user_mobile_phones view
4. Check frontend assets page for updated display

---

**Status:** ✅ Ready to Use  
**Database Updates:** Required (run SQL script)  
**Frontend Updates:** Already applied  
**Date:** November 16, 2025
