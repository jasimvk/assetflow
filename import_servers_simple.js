const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './backend/.env' });

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

console.log('📋 Supabase Configuration:');
console.log(`URL: ${supabaseUrl ? supabaseUrl.substring(0, 30) + '...' : '❌ Missing'}`);
console.log(`Service Key: ${supabaseServiceKey ? '✅ Set (' + supabaseServiceKey.length + ' chars)' : '❌ Missing'}\n`);

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing Supabase credentials');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

// Server data
const servers = [
  {
    name: 'ONEHVMH2',
    category_id: null, // Will be set after finding Server category
    location_id: null, // Will be set after finding HEAD OFFICE location  
    serial_number: 'CZJ1020F01',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 10',
      configuration: 'Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
      physical_virtual: 'Physical',
      ip_address: '192.168.1.95',
      mac_address: 'D4:F5:EF:3D:34:B8',
      ilo_ip: '192.168.1.92'
    })
  },
  {
    name: 'ONEHVMH1',
    category_id: null,
    location_id: null,
    serial_number: 'CZ2D2507J3',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 11',
      configuration: 'Xeon 3.30GHz 48CPUs Gold 6444Y, 128GB RAM, 15TB SSD Drive',
      physical_virtual: 'Physical',
      ip_address: '192.168.1.94',
      mac_address: 'B4:7A:F1:27:05:2C',
      ilo_ip: '192.168.1.91'
    })
  },
  {
    name: '1H-FOCUS',
    category_id: null,
    location_id: null,
    serial_number: 'VM-FOCUS',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 10',
      configuration: 'Xeon 3.00GHz, 32GB RAM, 1TB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.87',
      mac_address: '00:50:56:96:95:E5'
    })
  },
  {
    name: 'ONEH-CHECKSCM',
    category_id: null,
    location_id: null,
    serial_number: 'VM-CHECKSCM',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 11',
      configuration: 'Xeon 3.30GHz, 16GB RAM, 500GB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.88',
      mac_address: '00:50:56:96:71:BA'
    })
  },
  {
    name: 'ONEH-PAYROLL',
    category_id: null,
    location_id: null,
    serial_number: 'VM-PAYROLL',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 10',
      configuration: 'Xeon 3.00GHz, 16GB RAM, 500GB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.89',
      mac_address: '00:50:56:96:AB:53'
    })
  },
  {
    name: 'ONEH-BIOMETRIC',
    category_id: null,
    location_id: null,
    serial_number: 'VM-BIOMETRIC',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 10',
      configuration: 'Xeon 3.00GHz, 8GB RAM, 250GB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.90',
      mac_address: '00:50:56:96:C2:3F'
    })
  },
  {
    name: 'ONEH-BACKUPDC',
    category_id: null,
    location_id: null,
    serial_number: 'VM-BACKUPDC',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 11',
      configuration: 'Xeon 3.30GHz, 16GB RAM, 1TB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.91',
      mac_address: '00:50:56:96:15:A7'
    })
  },
  {
    name: 'ONEH-DC2012',
    category_id: null,
    location_id: null,
    serial_number: 'VM-DC2012',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 10',
      configuration: 'Xeon 3.00GHz, 16GB RAM, 500GB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.92',
      mac_address: '00:50:56:96:88:2D'
    })
  },
  {
    name: 'ONEH-TEST01',
    category_id: null,
    location_id: null,
    serial_number: 'VM-TEST01',
    purchase_date: new Date().toISOString().split('T')[0],
    condition: 'excellent',
    status: 'active',
    description: JSON.stringify({
      model: 'HP Prolaint GL360 Gen 11',
      configuration: 'Xeon 3.30GHz, 8GB RAM, 250GB SSD Drive',
      physical_virtual: 'Virtual',
      ip_address: '192.168.1.93',
      mac_address: '00:50:56:96:F4:11'
    })
  }
];

async function importServers() {
  try {
    console.log('🚀 Starting server import...\n');
    
    // Test connection
    console.log('📝 Testing connection...');
    const { data: testData, error: testError } = await supabase
      .from('assets')
      .select('count')
      .limit(1);
    
    if (testError) {
      console.error('❌ Connection test failed:', testError);
      console.log('Full error:', JSON.stringify(testError, null, 2));
      return;
    }
    
    console.log('✅ Connection successful\n');
    
    // Get or create Server category
    console.log('📋 Step 1: Finding/Creating Server category...');
    let { data: categories, error: catError } = await supabase
      .from('categories')
      .select('id, name')
      .eq('name', 'Server')
      .single();
    
    if (catError && catError.code === 'PGRST116') {
      // Category doesn't exist, create it
      console.log('Creating Server category...');
      const { data: newCat, error: createError } = await supabase
        .from('categories')
        .insert({ name: 'Server', description: 'Server hardware' })
        .select()
        .single();
      
      if (createError) {
        console.error('❌ Error creating category:', createError);
        return;
      }
      categories = newCat;
    } else if (catError) {
      console.error('❌ Error fetching category:', catError);
      return;
    }
    
    console.log(`✅ Server category ID: ${categories.id}\n`);
    
    // Get or create HEAD OFFICE location
    console.log('📋 Step 2: Finding/Creating HEAD OFFICE location...');
    let { data: location, error: locError } = await supabase
      .from('locations')
      .select('id, name')
      .eq('name', 'HEAD OFFICE')
      .single();
    
    if (locError && locError.code === 'PGRST116') {
      // Location doesn't exist, create it
      console.log('Creating HEAD OFFICE location...');
      const { data: newLoc, error: createError } = await supabase
        .from('locations')
        .insert({ name: 'HEAD OFFICE', address: 'Main Office' })
        .select()
        .single();
      
      if (createError) {
        console.error('❌ Error creating location:', createError);
        return;
      }
      location = newLoc;
    } else if (locError) {
      console.error('❌ Error fetching location:', locError);
      return;
    }
    
    console.log(`✅ HEAD OFFICE location ID: ${location.id}\n`);
    
    // Update servers with IDs
    const serversWithIds = servers.map(server => ({
      ...server,
      category_id: categories.id,
      location_id: location.id
    }));
    
    // Insert servers
    console.log('📋 Step 3: Inserting servers...');
    const { data, error } = await supabase
      .from('assets')
      .insert(serversWithIds)
      .select();
    
    if (error) {
      console.error('❌ Error inserting servers:', error);
      console.log('Full error:', JSON.stringify(error, null, 2));
      return;
    }
    
    console.log(`✅ Successfully imported ${data.length} servers!\n`);
    console.log('📋 Imported servers:');
    data.forEach((server, index) => {
      console.log(`  ${index + 1}. ${server.name} (${server.serial_number})`);
    });
    
    console.log('\n✅ Import complete!');
    
  } catch (error) {
    console.error('❌ Unexpected error:', error.message);
    console.log('Full error:', error);
  }
}

importServers();
