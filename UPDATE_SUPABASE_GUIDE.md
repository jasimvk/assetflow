# Update Supabase Assets Table - Step by Step Guide

**Date:** November 16, 2025  
**Purpose:** Update assets table to support all 11 asset categories and required columns

---

## 🎯 What This Update Does

1. ✅ Adds `status` column (active, in_stock, maintenance, retired, disposed)
2. ✅ Makes `serial_number` nullable and removes UNIQUE constraint (for monitors without serial numbers)
3. ✅ Makes `purchase_date`, `purchase_cost`, `current_value` nullable (for incomplete records)
4. ✅ Changes `assigned_to` from UUID to TEXT (for storing user names directly)
5. ✅ Inserts all 11 asset categories
6. ✅ Inserts 6 common locations
7. ✅ Adds performance indexes
8. ✅ Shows verification queries

---

## 📋 Prerequisites

Before running the update:
- [ ] Access to Supabase dashboard
- [ ] Admin/Owner role in Supabase project
- [ ] Backup of existing data (if any)

---

## 🚀 How to Update

### Step 1: Open Supabase SQL Editor

1. Go to your Supabase dashboard: https://app.supabase.com
2. Select your AssetFlow project
3. Click on **SQL Editor** in the left sidebar
4. Click **+ New query**

### Step 2: Run the Update Script

1. Open the file: `/database/update_assets_table.sql`
2. **Copy the entire contents** of the file
3. **Paste** into the Supabase SQL Editor
4. Click **Run** (or press Cmd/Ctrl + Enter)

### Step 3: Verify the Update

The script will automatically show you:
- ✅ All columns in the assets table with their data types
- ✅ All 12 categories (11 new + Other)
- ✅ All 6 locations
- ✅ Asset count by category (0 initially)

### Step 4: Check for Errors

If you see any errors:

**Common Error 1: "column already exists"**
```
ERROR: column "status" of relation "assets" already exists
```
✅ **Solution:** This is fine! It means the column was already there. The script will continue.

**Common Error 2: "constraint does not exist"**
```
NOTICE: constraint "assets_serial_number_key" does not exist, skipping
```
✅ **Solution:** This is fine! It means the constraint wasn't there. The script will continue.

**Common Error 3: "relation does not exist"**
```
ERROR: relation "assets" does not exist
```
❌ **Problem:** Your database schema isn't set up yet.
🔧 **Fix:** First run `/database/schema.sql` to create all tables, then run this update script.

---

## 📊 What You Should See

After successful execution, you should see output like:

### Column Verification
```
column_name       | data_type           | is_nullable | column_default
------------------|---------------------|-------------|----------------
id                | uuid                | NO          | uuid_generate_v4()
name              | character varying   | NO          | 
description       | text                | YES         | 
category          | character varying   | NO          | 
location          | character varying   | NO          | 
serial_number     | character varying   | YES         | 
model             | character varying   | YES         | 
manufacturer      | character varying   | YES         | 
purchase_date     | date                | YES         | 
purchase_cost     | numeric             | YES         | 0
current_value     | numeric             | YES         | 0
condition         | character varying   | YES         | 'good'
assigned_to       | text                | YES         | 
status            | character varying   | YES         | 'active'
warranty_expiry   | date                | YES         | 
notes             | text                | YES         | 
image_url         | character varying   | YES         | 
created_at        | timestamp with tz   | YES         | now()
updated_at        | timestamp with tz   | YES         | now()
```

### Categories List
```
name              | description
------------------|----------------------------------------------------------
Desktop           | Desktop computers with OS, memory, CPU specifications...
IT Peripherals    | Keyboards, mice, webcams, and other computer peripherals
Laptop            | Laptop computers with OS, memory, CPU specifications...
Mobile Phone      | Mobile phones and smartphones with IMEI numbers
Monitor           | Display monitors assigned to users across departments
Other             | Other assets not fitting into standard categories
Printer           | Printers including laser, inkjet, and multifunction...
Server            | Physical and virtual servers including ProLiant, Dell...
Storage           | Network Attached Storage (NAS), SAN, and storage devices
Switch            | Network switches, firewalls, and networking equipment
Tablet            | Tablet devices including iPads and Android tablets
Walkie Talkie     | Two-way radios and walkie talkie devices
```

### Locations List
```
name              | address
------------------|---------------------------
Head Office       | Main Office Location
Main Store        | Main Store Location
Saadiyat Villa 07 | Saadiyat Villa Property
Spanish Villa     | Spanish Villa Property
Store             | Store Location
White Villa       | White Villa Property
```

---

## ✅ Post-Update Checklist

After running the update script:

- [ ] Verify all columns are present in assets table
- [ ] Check that 12 categories exist
- [ ] Check that 6 locations exist
- [ ] No errors in the SQL Editor
- [ ] Ready to import assets

---

## 🔄 Next Steps After Update

### Option 1: Import Assets via SQL Files (Recommended for bulk)

Run these files in order in Supabase SQL Editor:

1. **Servers (9 assets)**
   ```sql
   -- Run: /database/import_server_inventory.sql
   ```

2. **Network Equipment (9 switches/firewalls)**
   ```sql
   -- Run: /database/import_network_equipment.sql
   ```

3. **Storage (3 NAS devices)**
   ```sql
   -- Run: /database/import_storage_inventory.sql
   ```

4. **Laptops (80+ laptops)**
   ```sql
   -- Run: /database/import_laptop_inventory.sql
   ```

5. **Desktops (43+ desktops)**
   ```sql
   -- Run: /database/import_desktop_inventory.sql
   ```

6. **Monitors (51 monitors)**
   ```sql
   -- Run: /database/import_monitor_inventory.sql
   ```

**Expected Result:** 191+ assets imported

### Option 2: Import Assets via Web Interface (Recommended for small batches)

1. Go to: http://localhost:3000/asset-import
2. Select category (Server, Laptop, Desktop, etc.)
3. Download CSV template
4. Fill in your data
5. Upload and import

---

## 🐛 Troubleshooting

### Issue: Import fails with "violates check constraint"

**Cause:** The status value doesn't match allowed values

**Fix:** Ensure status is one of: `active`, `in_stock`, `maintenance`, `retired`, `disposed`

### Issue: "Foreign key constraint violation"

**Cause:** The assigned_to field is trying to reference a UUID that doesn't exist

**Fix:** This shouldn't happen anymore since we changed assigned_to to TEXT. If it does, re-run the update script.

### Issue: RLS Policy errors after update

**Cause:** Row Level Security policies need updating

**Fix:** Run `/database/fix_rls_policies.sql` (after updating it with DROP statements)

---

## 📈 Performance Notes

The update script adds these indexes for better performance:

- `idx_assets_category` - Fast filtering by category
- `idx_assets_location` - Fast filtering by location  
- `idx_assets_status` - Fast filtering by status
- `idx_assets_serial_number` - Fast lookup by serial number
- `idx_assets_assigned_to` - Fast lookup by assigned user

These indexes will make the Assets page filters and searches much faster!

---

## 🔒 Security Note

After updating the table structure, you may need to:

1. Update RLS (Row Level Security) policies
2. Grant proper permissions to authenticated users
3. Test that the frontend can read/write to the updated table

See `/database/fix_rls_policies.sql` for RLS policy fixes.

---

## 💡 Tips

1. **Backup First:** Before running any SQL on production, backup your data
2. **Test in Dev:** If you have a dev/staging environment, test there first
3. **Run Verification:** Always check the verification queries at the end
4. **Check Indexes:** Use `EXPLAIN ANALYZE` to verify indexes are being used
5. **Monitor Performance:** Watch query performance after importing many assets

---

## 📞 Need Help?

If you encounter issues:

1. Check the Supabase logs (Logs section in dashboard)
2. Verify RLS policies are correct
3. Check that your API URL and anon key are correct in frontend
4. Review the console errors in browser developer tools

---

## ✨ Success Indicators

You'll know the update was successful when:

- ✅ Assets page loads without errors
- ✅ Category filter shows all 11 categories
- ✅ Location filter shows all 6 locations
- ✅ Can add new assets through the form
- ✅ Can import assets via CSV
- ✅ Status filter works (active, in_stock, etc.)
- ✅ Search and filters are fast

---

**Update complete! Your AssetFlow database is now ready for all 11 asset categories! 🎉**
