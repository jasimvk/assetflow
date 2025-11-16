# 🧪 Testing Guide - Master Data & Department Display

## Pre-Testing Checklist

✅ Frontend running on http://localhost:3000  
✅ Backend connected to Supabase  
✅ SQL file ready: `/database/link_assets_to_departments.sql`

---

## Test 1: Run SQL Script (5 minutes)

### Steps:

1. **Open Supabase Dashboard**
   - Go to https://supabase.com
   - Open your AssetFlow project
   - Click **SQL Editor** in the left sidebar

2. **Create New Query**
   - Click **"New Query"** button
   - Name it: "Link Assets to Departments"

3. **Copy SQL Script**
   - Open: `/database/link_assets_to_departments.sql`
   - Select all (Cmd+A)
   - Copy (Cmd+C)

4. **Paste and Run**
   - Paste into Supabase SQL Editor
   - Click **"Run"** button (or Cmd+Enter)
   - Wait for execution (should take 2-5 seconds)

5. **Review Results**
   - Check 3 verification reports in output:
     - **Department Distribution** - Shows asset count per department
     - **Summary** - Shows total assets, with_department, coverage %
     - **Sample Linked Assets** - Shows 10 example assets with departments

### Expected Results:

```
Department Distribution:
IT: 80 assets (25%)
HR: 45 assets (14%)
Finance: 30 assets (9%)
...

Summary:
Total Assets: 325
With Department: 280
Coverage: 86.2%

Sample Assets:
Laptop-001 | Laptop | IT | John Doe
Monitor-045 | Monitor | HR | Jane Smith
...
```

### ✅ Success Criteria:
- [ ] All 17 departments inserted
- [ ] 250-300+ assets linked (80%+ coverage)
- [ ] No error messages
- [ ] Sample data shows department names

---

## Test 2: Master Data Page - Departments (10 minutes)

### Access:
Navigate to: http://localhost:3000/master-data

### Test Cases:

#### 2.1 View Departments
- [ ] Page loads without errors
- [ ] See all 17 departments in card grid
- [ ] "Departments" tab shows count badge (e.g., "17")
- [ ] Cards show: name, description, active status
- [ ] Edit and Delete icons visible on each card

#### 2.2 Add New Department
1. Click **"Add Department"** button (top right)
2. Modal opens with form
3. Fill in:
   - Name: `Test Department`
   - Description: `This is a test department for QA`
   - Department Head: `Test Manager`
   - Location: `Building A`
   - Active: ✓ (checked)
4. Click **"Save"**

**Expected:**
- [ ] Modal closes
- [ ] New department appears in grid
- [ ] Count badge increases to 18
- [ ] Success message or smooth transition

#### 2.3 Edit Department
1. Find "Test Department" card
2. Click **Edit** icon (pencil)
3. Modal opens with current data
4. Change:
   - Description: `Updated test department`
   - Department Head: `New Manager`
5. Click **"Save"**

**Expected:**
- [ ] Modal closes
- [ ] Card shows updated information
- [ ] Changes persist (refresh page to verify)

#### 2.4 Toggle Active Status
1. Edit "Test Department" again
2. Uncheck **"Active"** checkbox
3. Save

**Expected:**
- [ ] Department marked as inactive (visual indicator)
- [ ] Still appears in list (not deleted)

#### 2.5 Delete Department
1. Click **Delete** icon (trash) on "Test Department"
2. Confirmation dialog appears
3. Confirm deletion

**Expected:**
- [ ] Department removed from grid
- [ ] Count badge decreases to 17
- [ ] If department has assets linked, delete might fail (good!)

### ✅ Success Criteria:
- [ ] All CRUD operations work smoothly
- [ ] No console errors
- [ ] Data persists after page refresh
- [ ] Loading states appear during operations

---

## Test 3: Master Data Page - Categories (5 minutes)

### Access:
Click **"Categories"** tab

### Test Cases:

#### 3.1 View Categories
- [ ] Tab switches smoothly
- [ ] See existing categories (Laptop, Desktop, Monitor, etc.)
- [ ] Count badge shows number

#### 3.2 Add Category
1. Click **"Add Category"**
2. Fill in:
   - Name: `Test Device`
   - Description: `Test category for new device type`
3. Save

**Expected:**
- [ ] New category appears
- [ ] Count increases

#### 3.3 Edit & Delete
1. Edit the test category
2. Change description
3. Save and verify
4. Delete the test category
5. Confirm deletion

**Expected:**
- [ ] Changes save correctly
- [ ] Delete works without errors

### ✅ Success Criteria:
- [ ] All operations work
- [ ] UI consistent with Departments tab

---

## Test 4: Master Data Page - Locations (5 minutes)

### Access:
Click **"Locations"** tab

### Test Cases:

#### 4.1 View Locations
- [ ] Tab switches smoothly
- [ ] See existing locations
- [ ] Cards show: name, address, building, floor, room

#### 4.2 Add Location
1. Click **"Add Location"**
2. Fill in:
   - Name: `Test Room`
   - Address: `123 Test Street`
   - Building: `Test Building`
   - Floor: `5`
   - Room: `505`
3. Save

**Expected:**
- [ ] New location appears with all details
- [ ] Address info displays correctly

#### 4.3 Edit & Delete
1. Edit test location
2. Change room to `506`
3. Save and verify
4. Delete test location

**Expected:**
- [ ] Updates work
- [ ] Delete successful

### ✅ Success Criteria:
- [ ] All location fields save correctly
- [ ] Building/floor/room display properly

---

## Test 5: Department Display in Assets Table (5 minutes)

### Access:
Navigate to: http://localhost:3000/assets

### Test Cases:

#### 5.1 View Department Column
- [ ] Assets table loads
- [ ] **Department** column visible (should be 11th column)
- [ ] Department names displayed (e.g., "IT", "HR", "Finance")
- [ ] No "(asset as any).department" type errors in console
- [ ] No "[object Object]" displayed

#### 5.2 Check Multiple Assets
Scroll through assets and verify:
- [ ] Laptops show departments (IT, HR, Finance, etc.)
- [ ] Monitors show departments
- [ ] Desktops show departments
- [ ] Assets without department show "-"
- [ ] No empty cells or undefined values

#### 5.3 Horizontal Scroll
- [ ] Table scrolls horizontally smoothly
- [ ] Department column stays visible during scroll
- [ ] All 17 columns work properly

#### 5.4 Search with Department
1. Search for an asset with a known department
2. Open detail modal (click asset row)
3. Check if department info visible anywhere

**Expected:**
- [ ] Department data consistent across table and modal
- [ ] No errors in browser console

### ✅ Success Criteria:
- [ ] Department column shows proper names
- [ ] No "undefined" or "[object Object]"
- [ ] Data matches SQL query results
- [ ] 80%+ of assets show department names

---

## Test 6: Integration Test (5 minutes)

### Test Department Assignment Flow:

#### 6.1 Create Department → Assign to Asset
1. Go to Master Data → Departments
2. Add new department: `Test Integration Dept`
3. Go to Assets page
4. Note: Currently can't assign departments from Assets page
   (This is a future enhancement)

#### 6.2 Check Department in Database
1. Go back to Supabase SQL Editor
2. Run query:
```sql
SELECT a.name, d.name as department 
FROM assets a 
LEFT JOIN departments d ON a.department_id = d.id 
LIMIT 20;
```

**Expected:**
- [ ] See assets with department names
- [ ] JOIN working correctly
- [ ] No NULL departments for recently imported assets

### ✅ Success Criteria:
- [ ] Master Data changes reflect in Assets table
- [ ] Database JOIN query works
- [ ] Data consistency across UI and database

---

## Troubleshooting

### Issue: SQL Script Fails

**Error: "relation 'departments' does not exist"**
- **Fix:** Run `/database/departments_table.sql` first to create table

**Error: "column 'department_id' does not exist"**
- **Fix:** Run `/database/schema.sql` to update assets table

**Error: "duplicate key value violates unique constraint"**
- **Fix:** Departments already exist, script is idempotent, safe to continue

### Issue: Master Data Page Won't Load

**Check:**
1. Supabase connection working?
2. RLS policies allow access?
3. Browser console for errors?
4. Network tab shows 401/403 errors?

**Fix:**
- Check `/frontend/utils/supabase.ts` for correct credentials
- Verify RLS policies in Supabase dashboard
- Try logout/login if auth required

### Issue: Department Shows "-" in Assets Table

**Possible Causes:**
1. SQL script not run yet → Run the script
2. Asset has no department_id → Normal for some assets
3. Frontend not updated → Clear cache, restart dev server

**Check:**
```sql
-- In Supabase SQL Editor
SELECT COUNT(*) as with_dept FROM assets WHERE department_id IS NOT NULL;
```

If result is 0, the SQL script wasn't run successfully.

### Issue: Console Errors

**"Module has no exported member 'supabase'"**
- **Fix:** Already fixed in code, restart dev server

**"Cannot read property 'name' of undefined"**
- **Fix:** Asset has no department, this is normal, UI shows "-"

---

## Performance Checks

### Page Load Times:
- [ ] Master Data page: < 2 seconds
- [ ] Assets table with departments: < 3 seconds
- [ ] Switching Master Data tabs: < 500ms

### Database Query Performance:
- [ ] Department JOIN adds minimal overhead
- [ ] Table with 300+ assets loads smoothly
- [ ] No lag when scrolling assets table

---

## Final Verification

### Screenshots to Take:
1. ✅ Supabase SQL output (department distribution)
2. ✅ Master Data page - Departments tab
3. ✅ Master Data page - Categories tab
4. ✅ Master Data page - Locations tab
5. ✅ Assets table with Department column populated
6. ✅ Browser console (no errors)

### Reports to Generate:
```sql
-- Department Coverage Report
SELECT 
  d.name as department,
  COUNT(a.id) as asset_count,
  array_agg(DISTINCT a.category) as categories
FROM departments d
LEFT JOIN assets a ON d.id = a.department_id
GROUP BY d.name
ORDER BY asset_count DESC;
```

---

## Success Checklist

### Feature: Master Data Management
- [ ] Can add departments, categories, locations
- [ ] Can edit all entity types
- [ ] Can delete entities (with confirmation)
- [ ] UI responsive and professional
- [ ] No console errors
- [ ] Data persists correctly

### Feature: Department Display
- [ ] Department column shows in assets table
- [ ] Names display correctly (not undefined/null)
- [ ] 80%+ coverage after SQL script
- [ ] JOIN query performs well
- [ ] TypeScript types work properly

### Overall System
- [ ] No breaking changes to existing features
- [ ] Bulk operations still work
- [ ] QR code generation still works
- [ ] Filters and search still work
- [ ] No regression bugs

---

## Testing Complete! 🎉

If all tests pass:
- ✅ Master Data Management is production-ready
- ✅ Department Display is working correctly
- ✅ Database architecture is solid
- ✅ UI is user-friendly

**Next:** Proceed with remaining TODO items (Bulk QR, Timeline, Dashboard, etc.)

---

**Estimated Total Testing Time:** ~35 minutes  
**Date:** November 16, 2025  
**Tester:** _______________  
**Result:** ⬜ Pass | ⬜ Fail | ⬜ Needs Fixes
