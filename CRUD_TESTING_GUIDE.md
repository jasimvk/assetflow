# 🧪 CRUD Testing Guide - AssetFlow Supabase API

## Overview

Comprehensive testing suite to verify all Create, Read, Update, Delete operations work correctly with Supabase backend.

---

## Quick Start - Browser-Based Testing

### Access Test Page:
**URL:** http://localhost:3000/test-crud

### How to Use:
1. Open the test page in your browser
2. Click **"Run All Tests"** button
3. Watch tests execute in real-time
4. View pass/fail results for each operation

### What Gets Tested:
✅ **CREATE** - Add new test asset  
✅ **READ** - Fetch single asset by ID  
✅ **READ** - Fetch all assets with department JOIN  
✅ **UPDATE** - Modify asset fields  
✅ **DELETE** - Remove asset and verify  
✅ **FILTER** - Category filtering  
✅ **SEARCH** - Name search (ILIKE)  
✅ **DEPARTMENT** - Verify foreign key integration  

---

## Test Suite Details

### Test 1: CREATE Operation
**Purpose:** Verify asset creation via API

**Test Data:**
```javascript
{
  name: 'TEST-Laptop-[timestamp]',
  category: 'Laptop',
  location: 'Office - Floor 1',
  serial_number: 'TEST-SN-[timestamp]',
  model: 'Test Model X1',
  manufacturer: 'Test Manufacturer',
  current_value: 5000,
  condition: 'excellent',
  status: 'active',
  purchase_date: '2024-01-15',
  purchase_cost: 5500
}
```

**Expected Result:**
- ✅ Asset created in Supabase
- ✅ Returns asset ID
- ✅ All fields saved correctly

**Supabase Query:**
```typescript
await supabase
  .from('assets')
  .insert([testAsset])
  .select()
  .single();
```

---

### Test 2: READ Operation (Single)
**Purpose:** Fetch individual asset by ID

**Expected Result:**
- ✅ Asset found using created ID
- ✅ All fields match creation data
- ✅ No errors returned

**Supabase Query:**
```typescript
await supabase
  .from('assets')
  .select('*')
  .eq('id', assetId)
  .single();
```

---

### Test 3: READ Operation (All with JOIN)
**Purpose:** Verify department JOIN works correctly

**Expected Result:**
- ✅ Returns array of assets
- ✅ Department data included via foreign key
- ✅ Nested department object with id, name, description

**Supabase Query:**
```typescript
await supabase
  .from('assets')
  .select(`
    *,
    department:department_id (
      id,
      name,
      description
    )
  `)
  .limit(5);
```

**Sample Response:**
```json
[
  {
    "id": "123",
    "name": "Laptop-001",
    "category": "Laptop",
    "department": {
      "id": "dept-1",
      "name": "IT",
      "description": "Information Technology Department"
    }
  }
]
```

---

### Test 4: UPDATE Operation
**Purpose:** Modify existing asset fields

**Updates Applied:**
```javascript
{
  current_value: 4500,
  condition: 'good',
  status: 'maintenance'
}
```

**Expected Result:**
- ✅ Fields updated successfully
- ✅ Returns updated asset
- ✅ Changes persist in database

**Supabase Query:**
```typescript
await supabase
  .from('assets')
  .update(updates)
  .eq('id', assetId)
  .select()
  .single();
```

---

### Test 5: DELETE Operation
**Purpose:** Remove asset and verify deletion

**Expected Result:**
- ✅ Asset deleted from database
- ✅ No error returned
- ✅ Subsequent query returns empty result

**Supabase Queries:**
```typescript
// Delete
await supabase
  .from('assets')
  .delete()
  .eq('id', assetId);

// Verify
await supabase
  .from('assets')
  .select('id')
  .eq('id', assetId);  // Should return []
```

---

### Test 6: FILTER Operation
**Purpose:** Test category filtering

**Filter Applied:** Category = 'Laptop'

**Expected Result:**
- ✅ Returns only laptops
- ✅ Correct count
- ✅ All results match filter

**Supabase Query:**
```typescript
await supabase
  .from('assets')
  .select('id, name, category')
  .eq('category', 'Laptop')
  .limit(5);
```

---

### Test 7: SEARCH Operation
**Purpose:** Test case-insensitive search

**Search Term:** '%Laptop%' (case-insensitive)

**Expected Result:**
- ✅ Returns assets with "laptop" in name
- ✅ Works with any case (Laptop, LAPTOP, laptop)
- ✅ Partial matches work

**Supabase Query:**
```typescript
await supabase
  .from('assets')
  .select('id, name')
  .ilike('name', '%Laptop%')
  .limit(5);
```

---

### Test 8: DEPARTMENT Integration
**Purpose:** Verify departments table and foreign key relationships

**Checks Performed:**
1. Departments table exists and has data
2. Assets can join departments via department_id
3. Department name displays correctly

**Expected Result:**
- ✅ Departments table accessible
- ✅ Multiple departments exist
- ✅ Assets linked to departments
- ✅ JOIN returns department names

**Supabase Queries:**
```typescript
// Check departments
await supabase
  .from('departments')
  .select('id, name')
  .limit(5);

// Check assets with departments
await supabase
  .from('assets')
  .select(`
    id,
    name,
    department:department_id (name)
  `)
  .not('department_id', 'is', null)
  .limit(5);
```

---

## Success Criteria

### All Tests Pass When:
- ✅ CREATE successfully adds asset to database
- ✅ READ single returns correct asset
- ✅ READ all includes department JOIN data
- ✅ UPDATE modifies fields correctly
- ✅ DELETE removes asset and verifies removal
- ✅ FILTER returns only matching records
- ✅ SEARCH finds partial matches (case-insensitive)
- ✅ DEPARTMENT integration works (foreign key + JOIN)

### Expected Results:
```
Total Tests: 8
✅ Passed: 8
❌ Failed: 0
📊 Success Rate: 100%
```

---

## Manual Testing Checklist

### In the Browser (http://localhost:3000/test-crud):

- [ ] Page loads without errors
- [ ] "Run All Tests" button visible
- [ ] Click button to start tests
- [ ] Watch each test execute (running status)
- [ ] All 8 tests show ✅ PASSED
- [ ] Summary shows 8/8 passed
- [ ] Test Asset ID displayed
- [ ] No console errors

### In Supabase Dashboard:

- [ ] Go to Table Editor → assets
- [ ] Check if test asset was created (then deleted)
- [ ] Verify no orphaned test data
- [ ] Check departments table has data
- [ ] Verify foreign key relationship exists

---

## Troubleshooting

### Issue: CREATE Test Fails

**Possible Causes:**
1. Supabase connection not configured
2. RLS policies blocking insert
3. Missing required fields

**Solutions:**
- Check `/frontend/utils/supabase.ts` has correct credentials
- Verify Supabase RLS allows authenticated inserts
- Check assets table schema matches test data

---

### Issue: READ with JOIN Fails

**Possible Causes:**
1. Departments table doesn't exist
2. department_id column missing
3. Foreign key not set up

**Solutions:**
- Run `/database/link_assets_to_departments.sql`
- Verify assets.department_id exists
- Check foreign key constraint in Supabase

---

### Issue: Tests Pass but Assets Table Still Shows Dashes

**Cause:** Frontend not updated or SQL not run

**Solutions:**
1. Run `/database/link_assets_to_departments.sql` in Supabase
2. Refresh frontend
3. Clear browser cache
4. Restart dev server

---

### Issue: DELETE Test Fails

**Possible Causes:**
1. RLS policy blocks delete
2. Foreign key constraint prevents deletion
3. Asset referenced elsewhere

**Solutions:**
- Check RLS policies allow delete
- Remove foreign key dependencies first
- Verify test asset has no references

---

## Advanced Testing

### Manual SQL Testing in Supabase:

```sql
-- Check if test assets exist
SELECT * FROM assets 
WHERE name LIKE 'TEST-%' 
ORDER BY created_at DESC;

-- Verify department JOIN works
SELECT 
  a.name, 
  a.category, 
  d.name as department
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
LIMIT 10;

-- Test filter
SELECT name, category 
FROM assets 
WHERE category = 'Laptop' 
LIMIT 5;

-- Test search
SELECT name 
FROM assets 
WHERE name ILIKE '%laptop%' 
LIMIT 5;
```

---

## Performance Testing

### Expected Performance:
- CREATE: < 200ms
- READ single: < 100ms
- READ all (5 records): < 300ms
- UPDATE: < 200ms
- DELETE: < 200ms
- FILTER: < 300ms
- SEARCH: < 300ms
- DEPARTMENT: < 400ms

### Total Test Suite: < 2 seconds

---

## Files Created

1. **`/frontend/pages/test-crud.tsx`** - Browser-based test page
2. **`/frontend/test/crud-test.ts`** - Node.js test suite (optional)
3. **`/CRUD_TESTING_GUIDE.md`** - This documentation

---

## API Endpoints Tested

All tests use Supabase JavaScript Client:

- `supabase.from('assets').insert()` - CREATE
- `supabase.from('assets').select()` - READ
- `supabase.from('assets').update()` - UPDATE
- `supabase.from('assets').delete()` - DELETE
- `supabase.from('assets').eq()` - FILTER
- `supabase.from('assets').ilike()` - SEARCH
- `supabase.from('departments').select()` - DEPARTMENT

---

## Next Steps After Testing

### If All Tests Pass:
1. ✅ CRUD operations confirmed working
2. ✅ Department integration verified
3. ✅ Ready for production use
4. ✅ Proceed with remaining features (Bulk QR, Timeline, etc.)

### If Tests Fail:
1. Check error messages in test results
2. Verify Supabase connection
3. Check RLS policies
4. Review database schema
5. Check browser console for errors

---

## Testing Frequency

**Recommended:**
- Run after schema changes
- Run after API modifications
- Run before deploying
- Run weekly for regression testing

---

## Status: ✅ READY TO TEST

Open http://localhost:3000/test-crud and click "Run All Tests" to verify your CRUD operations! 🚀

**Date:** November 16, 2025  
**Coverage:** 8 core operations  
**Expected Duration:** < 2 seconds
