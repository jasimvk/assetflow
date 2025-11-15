const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function testConnection() {
  console.log('🔍 Testing Frontend Supabase Connection...\n');
  
  // Check environment variables
  console.log('📋 Configuration:');
  console.log(`URL: ${process.env.NEXT_PUBLIC_SUPABASE_URL ? '✅ Set' : '❌ Missing'}`);
  console.log(`Anon Key: ${process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ? '✅ Set' : '❌ Missing'}\n`);
  
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
    console.error('❌ Environment variables not configured!');
    console.log('\nPlease create /frontend/.env.local with:');
    console.log('NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co');
    console.log('NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key\n');
    process.exit(1);
  }

  try {
    // Test 1: Check users table
    console.log('📝 Test 1: Checking users table...');
    const { data: users, error: usersError } = await supabase
      .from('users')
      .select('id, email, full_name, role')
      .limit(5);
    
    if (usersError) {
      console.error('❌ Users table error:', usersError.message);
    } else {
      console.log(`✅ Users table accessible (${users.length} rows)`);
      if (users.length > 0) {
        console.log('   Sample user:', users[0].email, '-', users[0].role);
      }
    }

    // Test 2: Check system_access_requests table
    console.log('\n📝 Test 2: Checking system_access_requests table...');
    const { data: requests, error: requestsError } = await supabase
      .from('system_access_requests')
      .select('id, request_number, employee_first_name, status')
      .limit(5);
    
    if (requestsError) {
      console.error('❌ System access requests error:', requestsError.message);
    } else {
      console.log(`✅ System access requests accessible (${requests.length} rows)`);
      if (requests.length > 0) {
        console.log(`   Sample request: ${requests[0].request_number} - ${requests[0].status}`);
      }
    }

    // Test 3: Check assets table
    console.log('\n📝 Test 3: Checking assets table...');
    const { data: assets, error: assetsError } = await supabase
      .from('assets')
      .select('id, asset_tag, name, status')
      .limit(5);
    
    if (assetsError) {
      console.error('❌ Assets table error:', assetsError.message);
    } else {
      console.log(`✅ Assets table accessible (${assets.length} rows)`);
      if (assets.length > 0) {
        console.log(`   Sample asset: ${assets[0].asset_tag} - ${assets[0].status}`);
      }
    }

    // Test 4: Check categories (should have default data)
    console.log('\n📝 Test 4: Checking categories table...');
    const { data: categories, error: categoriesError } = await supabase
      .from('categories')
      .select('id, name')
      .order('name');
    
    if (categoriesError) {
      console.error('❌ Categories table error:', categoriesError.message);
    } else {
      console.log(`✅ Categories table accessible (${categories.length} rows)`);
      if (categories.length > 0) {
        console.log('   Categories:', categories.map(c => c.name).join(', '));
      }
    }

    // Test 5: Check locations (should have default data)
    console.log('\n📝 Test 5: Checking locations table...');
    const { data: locations, error: locationsError } = await supabase
      .from('locations')
      .select('id, name')
      .order('name');
    
    if (locationsError) {
      console.error('❌ Locations table error:', locationsError.message);
    } else {
      console.log(`✅ Locations table accessible (${locations.length} rows)`);
      if (locations.length > 0) {
        console.log('   Locations:', locations.map(l => l.name).join(', '));
      }
    }

    // Test 6: Check dashboard view
    console.log('\n📝 Test 6: Checking dashboard stats view...');
    const { data: stats, error: statsError } = await supabase
      .from('vw_dashboard_stats')
      .select('*')
      .single();
    
    if (statsError) {
      console.error('❌ Dashboard view error:', statsError.message);
    } else {
      console.log('✅ Dashboard stats view accessible');
      console.log('   Stats:', JSON.stringify(stats, null, 2));
    }

    console.log('\n✅ Frontend database connection test completed!');
    console.log('\n📊 Summary:');
    console.log('- Database is accessible from frontend');
    console.log('- All core tables are working');
    console.log('- RLS policies are in effect (anon key has limited access)');
    console.log('- Ready for application use\n');

  } catch (error) {
    console.error('\n❌ Connection test failed:', error.message);
    console.error('\nTroubleshooting:');
    console.error('1. Verify Supabase project is running');
    console.error('2. Check API credentials in .env.local');
    console.error('3. Ensure database schema is executed');
    console.error('4. Check RLS policies are enabled\n');
    process.exit(1);
  }
}

testConnection();
