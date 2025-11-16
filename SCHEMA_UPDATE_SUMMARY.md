# AssetFlow Database Schema Update Summary

**Date:** November 16, 2025  
**Status:** ✅ Complete

---

## 📋 Changes Made to Main Schema

### 1. **Assets Table Structure Updates**

#### Modified Columns:
- ✅ `serial_number` - Changed from `UNIQUE NOT NULL` to nullable without unique constraint
  - **Reason:** Many monitors and peripherals don't have serial numbers
  
- ✅ `purchase_date` - Changed from `NOT NULL` to nullable
  - **Reason:** Some assets lack complete purchase records
  
- ✅ `purchase_cost` - Changed from `NOT NULL` to nullable with `DEFAULT 0`
  - **Reason:** Historical assets may not have cost information
  
- ✅ `current_value` - Changed from `NOT NULL` to nullable with `DEFAULT 0`
  - **Reason:** Value estimation may not be available for all assets

- ✅ `assigned_to` - Changed from `UUID REFERENCES users(id)` to `TEXT`
  - **Reason:** Store user names directly instead of foreign key reference
  - **Benefit:** Simpler imports, no need to lookup user IDs
  
#### New Columns:
- ✅ `status` - `VARCHAR(50)` with CHECK constraint
  - **Values:** `active`, `in_stock`, `maintenance`, `retired`, `disposed`
  - **Default:** `active`
  - **Purpose:** Track asset lifecycle status

---

### 2. **Default Categories (11 Asset Types)**

Replaced old generic categories with specific IT asset types:

| Category | Description |
|----------|-------------|
| **Server** | Physical and virtual servers including ProLiant, Dell, HP models with IP addresses |
| **Switch** | Network switches, firewalls, and networking equipment |
| **Storage** | Network Attached Storage (NAS), SAN, and storage devices |
| **Laptop** | Laptop computers with OS, memory, CPU specifications and user assignments |
| **Desktop** | Desktop computers with OS, memory, CPU specifications and user assignments |
| **Monitor** | Display monitors assigned to users across departments |
| **Mobile Phone** | Mobile phones and smartphones with IMEI numbers |
| **Walkie Talkie** | Two-way radios and walkie talkie devices |
| **Tablet** | Tablet devices including iPads and Android tablets |
| **Printer** | Printers including laser, inkjet, and multifunction devices |
| **IT Peripherals** | Keyboards, mice, webcams, and other computer peripherals |
| **Other** | Other assets not fitting into standard categories |

---

### 3. **Default Locations (9 Locations)**

Updated from generic locations to actual property locations:

| Location | Address |
|----------|---------|
| Head Office | Main Office Location |
| Spanish Villa | Spanish Villa Property |
| White Villa | White Villa Property |
| Saadiyat Villa 07 | Saadiyat Villa Property |
| Main Store | Main Store Location |
| Store | Store Location |
| Office - Floor 1 | First Floor |
| Office - Floor 2 | Second Floor |
| Warehouse | Warehouse Location |

---

### 4. **Performance Indexes Added**

Created indexes for frequently queried columns:

```sql
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status);
CREATE INDEX IF NOT EXISTS idx_assets_serial_number ON assets(serial_number) WHERE serial_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_assets_assigned_to ON assets(assigned_to) WHERE assigned_to IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_maintenance_records_asset_id ON maintenance_records(asset_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_status ON maintenance_records(status);
CREATE INDEX IF NOT EXISTS idx_asset_history_asset_id ON asset_history(asset_id);
```

**Benefits:**
- ⚡ Faster category filtering
- ⚡ Faster location filtering
- ⚡ Faster status filtering
- ⚡ Faster serial number lookups
- ⚡ Faster assigned user searches
- ⚡ Faster maintenance record queries
- ⚡ Faster asset history retrieval

---

## 🔄 Migration Path

### For New Installations:
Simply run `/database/schema.sql` in Supabase SQL Editor - it includes all updates.

### For Existing Installations:
Run `/database/update_assets_table.sql` which:
1. Drops dependent views
2. Alters columns safely
3. Adds new status column
4. Updates categories
5. Updates locations
6. Creates indexes
7. Recreates views

---

## 📊 Assets Table Final Structure

```sql
CREATE TABLE assets (
    -- Primary Key
    id UUID PRIMARY KEY,
    
    -- Basic Information
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    
    -- Identification
    serial_number VARCHAR(100),              -- Nullable, no unique constraint
    model VARCHAR(100),
    manufacturer VARCHAR(100),
    
    -- Financial
    purchase_date DATE,                      -- Nullable
    purchase_cost DECIMAL(12,2) DEFAULT 0,   -- Nullable, default 0
    current_value DECIMAL(12,2) DEFAULT 0,   -- Nullable, default 0
    
    -- Status & Condition
    condition VARCHAR(20) DEFAULT 'good',    -- excellent, good, fair, poor
    status VARCHAR(50) DEFAULT 'active',     -- active, in_stock, maintenance, retired, disposed
    
    -- Assignment
    assigned_to TEXT,                        -- User name as text
    
    -- Maintenance
    maintenance_schedule VARCHAR(50),
    warranty_expiry DATE,
    
    -- Additional Info
    notes TEXT,
    image_url VARCHAR(500),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## ✅ Validation Checklist

After running the updated schema:

- [ ] Assets table has 19 columns
- [ ] Status column exists with CHECK constraint
- [ ] serial_number is nullable (no unique constraint)
- [ ] assigned_to is TEXT type (not UUID)
- [ ] 12 categories exist (11 + Other)
- [ ] 9 locations exist
- [ ] 8 indexes created on assets and related tables
- [ ] No foreign key constraint on assigned_to
- [ ] purchase_date, purchase_cost, current_value are nullable

---

## 🎯 Benefits of Updated Schema

### 1. **Flexibility**
- ✅ Can import assets without serial numbers
- ✅ Can import assets without purchase information
- ✅ Can assign to users by name (no need for user ID lookup)

### 2. **Real-World Alignment**
- ✅ Categories match actual IT asset types
- ✅ Locations match actual company properties
- ✅ Status tracking reflects asset lifecycle

### 3. **Performance**
- ✅ Indexes speed up common queries
- ✅ Faster filtering by category, location, status
- ✅ Efficient serial number and assigned user lookups

### 4. **Import Friendly**
- ✅ CSV imports work smoothly
- ✅ Minimal required fields
- ✅ Handles incomplete data gracefully

### 5. **Extensible**
- ✅ Easy to add new categories
- ✅ Easy to add new locations
- ✅ Easy to add new status values
- ✅ Notes field for category-specific metadata

---

## 📁 Related Files

- `/database/schema.sql` - Main database schema (UPDATED)
- `/database/update_assets_table.sql` - Migration script for existing databases
- `/frontend/pages/assets.tsx` - Assets page (UPDATED with new categories)
- `/frontend/pages/asset-import.tsx` - Import page (UPDATED with 11 templates)

---

## 🚀 Next Steps

1. **Run the Schema**
   - New installation: Run `schema.sql`
   - Existing database: Run `update_assets_table.sql`

2. **Import Assets**
   - Run import SQL files for servers, laptops, desktops, monitors, etc.
   - Or use web interface at `/asset-import`

3. **Verify**
   - Check that assets page loads
   - Test filtering by new categories
   - Test asset creation/editing

4. **Fix RLS Policies** (if needed)
   - Run `/database/fix_rls_policies.sql` if you encounter permission errors

---

## 📝 Notes

- The schema is backward compatible with existing asset records
- All existing assets will have `status = 'active'` by default
- NULL values in new nullable fields are handled gracefully
- Indexes are created with `IF NOT EXISTS` so re-running is safe

---

**Schema update complete! Database is now ready for all 11 asset categories! 🎉**
