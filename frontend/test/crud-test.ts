// ============================================================================
// CRUD Testing Suite for AssetFlow - Supabase API
// Run this file to test all Create, Read, Update, Delete operations
// ============================================================================

import { getSupabaseClient } from '../utils/supabase';

const supabase = getSupabaseClient();

// Test data
const testAsset = {
  name: 'TEST-Laptop-CRUD-' + Date.now(),
  category: 'Laptop',
  location: 'Office - Floor 1',
  serial_number: 'TEST-SN-' + Date.now(),
  model: 'Test Model X1',
  manufacturer: 'Test Manufacturer',
  current_value: 5000,
  condition: 'excellent',
  status: 'active',
  purchase_date: '2024-01-15',
  purchase_cost: 5500,
  warranty_expiry: '2027-01-15',
  assigned_to: 'Test User',
  description: 'This is a test asset for CRUD operations',
  notes: 'Created by automated test suite'
};

// ============================================================================
// TEST 1: CREATE Operation
// ============================================================================
async function testCreate() {
  console.log('\n🧪 TEST 1: CREATE Operation');
  console.log('=' .repeat(60));
  
  try {
    const { data, error } = await supabase
      .from('assets')
      .insert([testAsset])
      .select()
      .single();
    
    if (error) {
      console.error('❌ CREATE Failed:', error);
      return null;
    }
    
    console.log('✅ CREATE Success!');
    console.log('Created Asset ID:', data.id);
    console.log('Asset Name:', data.name);
    console.log('Serial Number:', data.serial_number);
    console.log('Category:', data.category);
    console.log('Current Value:', data.current_value);
    
    return data.id;
  } catch (err) {
    console.error('❌ CREATE Exception:', err);
    return null;
  }
}

// ============================================================================
// TEST 2: READ Operation (Single Asset)
// ============================================================================
async function testReadSingle(assetId: string) {
  console.log('\n🧪 TEST 2: READ Operation (Single Asset)');
  console.log('=' .repeat(60));
  
  try {
    const { data, error } = await supabase
      .from('assets')
      .select('*')
      .eq('id', assetId)
      .single();
    
    if (error) {
      console.error('❌ READ Failed:', error);
      return false;
    }
    
    console.log('✅ READ Success!');
    console.log('Found Asset:', data.name);
    console.log('Status:', data.status);
    console.log('Condition:', data.condition);
    console.log('Assigned To:', data.assigned_to);
    
    return true;
  } catch (err) {
    console.error('❌ READ Exception:', err);
    return false;
  }
}

// ============================================================================
// TEST 3: READ Operation (All Assets with Department JOIN)
// ============================================================================
async function testReadAll() {
  console.log('\n🧪 TEST 3: READ Operation (All Assets with Department JOIN)');
  console.log('=' .repeat(60));
  
  try {
    const { data, error } = await supabase
      .from('assets')
      .select(`
        *,
        department:department_id (
          id,
          name,
          description
        )
      `)
      .order('created_at', { ascending: false })
      .limit(5);
    
    if (error) {
      console.error('❌ READ ALL Failed:', error);
      return false;
    }
    
    console.log('✅ READ ALL Success!');
    console.log(`Found ${data.length} assets (showing first 5)`);
    
    data.forEach((asset, index) => {
      console.log(`\n  Asset ${index + 1}:`);
      console.log(`    Name: ${asset.name}`);
      console.log(`    Category: ${asset.category}`);
      console.log(`    Department: ${asset.department?.name || 'N/A'}`);
      console.log(`    Value: AED ${asset.current_value}`);
    });
    
    return true;
  } catch (err) {
    console.error('❌ READ ALL Exception:', err);
    return false;
  }
}

// ============================================================================
// TEST 4: UPDATE Operation
// ============================================================================
async function testUpdate(assetId: string) {
  console.log('\n🧪 TEST 4: UPDATE Operation');
  console.log('=' .repeat(60));
  
  const updates = {
    name: 'TEST-Laptop-UPDATED-' + Date.now(),
    current_value: 4500,
    condition: 'good',
    status: 'maintenance',
    assigned_to: 'Updated Test User',
    notes: 'Updated by automated test suite at ' + new Date().toISOString()
  };
  
  try {
    const { data, error } = await supabase
      .from('assets')
      .update(updates)
      .eq('id', assetId)
      .select()
      .single();
    
    if (error) {
      console.error('❌ UPDATE Failed:', error);
      return false;
    }
    
    console.log('✅ UPDATE Success!');
    console.log('Updated Asset Name:', data.name);
    console.log('New Value:', data.current_value);
    console.log('New Condition:', data.condition);
    console.log('New Status:', data.status);
    console.log('New Assigned To:', data.assigned_to);
    
    return true;
  } catch (err) {
    console.error('❌ UPDATE Exception:', err);
    return false;
  }
}

// ============================================================================
// TEST 5: DELETE Operation
// ============================================================================
async function testDelete(assetId: string) {
  console.log('\n🧪 TEST 5: DELETE Operation');
  console.log('=' .repeat(60));
  
  try {
    const { error } = await supabase
      .from('assets')
      .delete()
      .eq('id', assetId);
    
    if (error) {
      console.error('❌ DELETE Failed:', error);
      return false;
    }
    
    console.log('✅ DELETE Success!');
    console.log('Deleted Asset ID:', assetId);
    
    // Verify deletion
    const { data: verifyData } = await supabase
      .from('assets')
      .select('id')
      .eq('id', assetId);
    
    if (verifyData && verifyData.length === 0) {
      console.log('✅ Verified: Asset no longer exists in database');
      return true;
    } else {
      console.error('❌ Verification Failed: Asset still exists!');
      return false;
    }
  } catch (err) {
    console.error('❌ DELETE Exception:', err);
    return false;
  }
}

// ============================================================================
// TEST 6: Filter and Search Operations
// ============================================================================
async function testFilterAndSearch() {
  console.log('\n🧪 TEST 6: Filter and Search Operations');
  console.log('=' .repeat(60));
  
  try {
    // Test 1: Filter by category
    console.log('\n  📋 Testing category filter (Laptop)...');
    const { data: laptops, error: laptopError } = await supabase
      .from('assets')
      .select('id, name, category')
      .eq('category', 'Laptop')
      .limit(3);
    
    if (laptopError) {
      console.error('❌ Category filter failed:', laptopError);
    } else {
      console.log(`✅ Found ${laptops.length} laptops`);
    }
    
    // Test 2: Filter by status
    console.log('\n  📋 Testing status filter (active)...');
    const { data: activeAssets, error: activeError } = await supabase
      .from('assets')
      .select('id, name, status')
      .eq('status', 'active')
      .limit(3);
    
    if (activeError) {
      console.error('❌ Status filter failed:', activeError);
    } else {
      console.log(`✅ Found ${activeAssets.length} active assets`);
    }
    
    // Test 3: Search by name (ILIKE for case-insensitive)
    console.log('\n  🔍 Testing search (name contains "Laptop")...');
    const { data: searchResults, error: searchError } = await supabase
      .from('assets')
      .select('id, name, category')
      .ilike('name', '%Laptop%')
      .limit(3);
    
    if (searchError) {
      console.error('❌ Search failed:', searchError);
    } else {
      console.log(`✅ Found ${searchResults.length} assets matching search`);
    }
    
    // Test 4: Range query (value between)
    console.log('\n  💰 Testing value range (AED 1000-5000)...');
    const { data: rangeResults, error: rangeError } = await supabase
      .from('assets')
      .select('id, name, current_value')
      .gte('current_value', 1000)
      .lte('current_value', 5000)
      .limit(3);
    
    if (rangeError) {
      console.error('❌ Range query failed:', rangeError);
    } else {
      console.log(`✅ Found ${rangeResults.length} assets in price range`);
    }
    
    return true;
  } catch (err) {
    console.error('❌ Filter/Search Exception:', err);
    return false;
  }
}

// ============================================================================
// TEST 7: Department Integration
// ============================================================================
async function testDepartmentIntegration() {
  console.log('\n🧪 TEST 7: Department Integration');
  console.log('=' .repeat(60));
  
  try {
    // Check if departments table exists and has data
    const { data: departments, error: deptError } = await supabase
      .from('departments')
      .select('id, name, is_active')
      .limit(5);
    
    if (deptError) {
      console.error('❌ Departments fetch failed:', deptError);
      return false;
    }
    
    console.log(`✅ Found ${departments.length} departments`);
    departments.forEach(dept => {
      console.log(`  - ${dept.name} (Active: ${dept.is_active})`);
    });
    
    // Check assets with department relationships
    const { data: assetsWithDept, error: assetDeptError } = await supabase
      .from('assets')
      .select(`
        id,
        name,
        department:department_id (
          id,
          name
        )
      `)
      .not('department_id', 'is', null)
      .limit(5);
    
    if (assetDeptError) {
      console.error('❌ Assets with departments fetch failed:', assetDeptError);
      return false;
    }
    
    console.log(`\n✅ Found ${assetsWithDept.length} assets with departments:`);
    assetsWithDept.forEach((asset: any) => {
      console.log(`  - ${asset.name}: ${asset.department?.name || 'N/A'}`);
    });
    
    return true;
  } catch (err) {
    console.error('❌ Department Integration Exception:', err);
    return false;
  }
}

// ============================================================================
// TEST 8: Bulk Operations
// ============================================================================
async function testBulkOperations() {
  console.log('\n🧪 TEST 8: Bulk Operations');
  console.log('=' .repeat(60));
  
  try {
    // Create multiple test assets
    const bulkAssets = [
      {
        name: 'BULK-TEST-1-' + Date.now(),
        category: 'Desktop',
        location: 'Office - Floor 1',
        serial_number: 'BULK-SN-1-' + Date.now(),
        current_value: 3000,
        condition: 'good',
        status: 'active',
        purchase_date: '2024-01-01',
        purchase_cost: 3200
      },
      {
        name: 'BULK-TEST-2-' + Date.now(),
        category: 'Monitor',
        location: 'Office - Floor 2',
        serial_number: 'BULK-SN-2-' + Date.now(),
        current_value: 800,
        condition: 'excellent',
        status: 'active',
        purchase_date: '2024-01-01',
        purchase_cost: 900
      }
    ];
    
    console.log('\n  📦 Creating bulk assets...');
    const { data: createdAssets, error: createError } = await supabase
      .from('assets')
      .insert(bulkAssets)
      .select();
    
    if (createError) {
      console.error('❌ Bulk create failed:', createError);
      return false;
    }
    
    console.log(`✅ Created ${createdAssets.length} assets`);
    const assetIds = createdAssets.map(a => a.id);
    
    // Bulk update
    console.log('\n  ✏️ Bulk updating status...');
    const { data: updatedAssets, error: updateError } = await supabase
      .from('assets')
      .update({ status: 'maintenance' })
      .in('id', assetIds)
      .select();
    
    if (updateError) {
      console.error('❌ Bulk update failed:', updateError);
    } else {
      console.log(`✅ Updated ${updatedAssets.length} assets to maintenance`);
    }
    
    // Bulk delete
    console.log('\n  🗑️ Bulk deleting test assets...');
    const { error: deleteError } = await supabase
      .from('assets')
      .delete()
      .in('id', assetIds);
    
    if (deleteError) {
      console.error('❌ Bulk delete failed:', deleteError);
      return false;
    }
    
    console.log(`✅ Deleted ${assetIds.length} test assets`);
    
    return true;
  } catch (err) {
    console.error('❌ Bulk Operations Exception:', err);
    return false;
  }
}

// ============================================================================
// Main Test Runner
// ============================================================================
async function runAllTests() {
  console.log('\n╔════════════════════════════════════════════════════════════╗');
  console.log('║     AssetFlow CRUD Test Suite - Supabase API Testing      ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log(`\nStarted at: ${new Date().toISOString()}\n`);
  
  const results = {
    passed: 0,
    failed: 0,
    total: 8
  };
  
  let testAssetId: string | null = null;
  
  // Test 1: CREATE
  testAssetId = await testCreate();
  if (testAssetId) {
    results.passed++;
  } else {
    results.failed++;
    console.log('\n⚠️ Skipping remaining tests due to CREATE failure');
    printSummary(results);
    return;
  }
  
  // Test 2: READ Single
  if (await testReadSingle(testAssetId)) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Test 3: READ All with JOIN
  if (await testReadAll()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Test 4: UPDATE
  if (await testUpdate(testAssetId)) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Test 5: DELETE
  if (await testDelete(testAssetId)) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Test 6: Filter and Search
  if (await testFilterAndSearch()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Test 7: Department Integration
  if (await testDepartmentIntegration()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  // Test 8: Bulk Operations
  if (await testBulkOperations()) {
    results.passed++;
  } else {
    results.failed++;
  }
  
  printSummary(results);
}

// ============================================================================
// Print Summary
// ============================================================================
function printSummary(results: { passed: number; failed: number; total: number }) {
  console.log('\n\n╔════════════════════════════════════════════════════════════╗');
  console.log('║                      TEST SUMMARY                          ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log(`\nTotal Tests: ${results.total}`);
  console.log(`✅ Passed: ${results.passed}`);
  console.log(`❌ Failed: ${results.failed}`);
  console.log(`📊 Success Rate: ${((results.passed / results.total) * 100).toFixed(1)}%`);
  console.log(`\nCompleted at: ${new Date().toISOString()}\n`);
  
  if (results.failed === 0) {
    console.log('🎉 All tests passed! CRUD operations are working correctly.\n');
  } else {
    console.log('⚠️ Some tests failed. Please check the errors above.\n');
  }
}

// Run tests
if (typeof window !== 'undefined') {
  console.log('⚠️ This test suite should be run in a Node.js environment.');
  console.log('Run: ts-node frontend/test/crud-test.ts');
} else {
  runAllTests().catch(console.error);
}

export { runAllTests };
