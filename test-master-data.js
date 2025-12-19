// Test script for master data APIs
// Run with: node test-master-data.js

const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://lcehnjkqoozwxhkzwrna.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxjZWhuamtxb296d3hoa3p3cm5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMxODk3ODIsImV4cCI6MjA3ODc2NTc4Mn0.fA-3CQT2NreBKw4tsufZsDs3v0SZ3iBmmXBi3b15v6o'
);

async function testMasterData() {
  console.log('=================================');
  console.log('Testing Master Data Tables');
  console.log('=================================\n');

  const tables = ['locations', 'manufacturers', 'models', 'os_versions', 'cpu_types', 'ram_sizes', 'storage_sizes'];
  
  for (const table of tables) {
    const { data, error } = await supabase.from(table).select('id, name').limit(3);
    
    if (error) {
      console.log('[X] ' + table + ': Error - ' + error.message);
    } else if (!data || data.length === 0) {
      console.log('[!] ' + table + ': Table exists but NO DATA');
    } else {
      console.log('[OK] ' + table + ': ' + data.length + ' items - ' + data.map(d => d.name).join(', '));
    }
  }

  console.log('\n=================================');
  console.log('Testing Asset Creation');
  console.log('=================================\n');
  
  const testAsset = {
    name: 'Test Asset ' + Date.now(),
    category: 'Desktop',
    location: 'Head Office',
    status: 'active',
    condition: 'good'
  };
  
  const { data: asset, error: assetError } = await supabase
    .from('assets')
    .insert([testAsset])
    .select()
    .single();
  
  if (assetError) {
    console.log('[X] Asset Creation Error:', assetError.message);
  } else {
    console.log('[OK] Asset Created Successfully!');
    console.log('    ID:', asset.id);
    console.log('    Name:', asset.name);
    console.log('    Category:', asset.category);
    console.log('    Location:', asset.location);
    
    // Cleanup
    await supabase.from('assets').delete().eq('id', asset.id);
    console.log('    (Test asset cleaned up)');
  }

  console.log('\n=================================');
  console.log('Testing Add New Location');
  console.log('=================================\n');

  const newLocName = 'New Test Location ' + Date.now();
  const { data: newLoc, error: locError } = await supabase
    .from('locations')
    .insert([{ name: newLocName }])
    .select('id, name')
    .single();

  if (locError) {
    console.log('[X] Add Location Error:', locError.message);
  } else {
    console.log('[OK] Location Added:', newLoc.name);
    // Cleanup
    await supabase.from('locations').delete().eq('id', newLoc.id);
    console.log('    (Test location cleaned up)');
  }

  console.log('\n=================================');
  console.log('All Tests Complete!');
  console.log('=================================');
}

testMasterData().catch(console.error);
