const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './backend/.env' });

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing Supabase credentials');
  console.log('Please set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in backend/.env file');
  console.log('You can copy from backend/.env.example and fill in your credentials');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

// Server inventory data from the Excel sheet
const serverInventory = [
  {
    asset_name: 'ONEHVMH2',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 10',
    configuration: 'Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
    serial_no: 'CZJ1020F01',
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Physical',
    ip_address: '192.168.1.95',
    mac_address: 'D4:F5:EF:3D:34:B8',
    ilo_ip: '192.168.1.92'
  },
  {
    asset_name: 'ONEHVMH1',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 11',
    configuration: null,
    serial_no: 'CZ2D2507J3',
    year_of_purchase: '2025-03-02',
    warranty_end: '2028-02-02',
    asset_code: null,
    physical_virtual: 'Physical',
    ip_address: '192.168.1.89',
    mac_address: '8C:84:74:E5:D3:64',
    ilo_ip: '192.168.1.91'
  },
  {
    asset_name: 'ONEHVMH1',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 11',
    configuration: null,
    serial_no: 'CZ2D2507J3',
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.1.88',
    mac_address: '00:0C:29:E7:BE:7D',
    ilo_ip: '192.168.1.88'
  },
  {
    asset_name: '1H-FOCUS',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 11',
    configuration: null,
    serial_no: null,
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.1.87',
    mac_address: '00:0C:29:70:C7:65',
    ilo_ip: '192.168.1.87'
  },
  {
    asset_name: 'ONEH-CHECKSCM',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 11',
    configuration: null,
    serial_no: null,
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.0.182',
    mac_address: null,
    ilo_ip: '192.168.0.182'
  },
  {
    asset_name: '1H-SERVER',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 11',
    configuration: null,
    serial_no: null,
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.1.89',
    mac_address: '8C:84:74:E5:D3:64',
    ilo_ip: '192.168.1.89'
  },
  {
    asset_name: 'ONEHVMH2',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 10',
    configuration: 'Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
    serial_no: null,
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.1.95',
    mac_address: 'D4:F5:EF:3D:34:B8',
    ilo_ip: '192.168.1.95'
  },
  {
    asset_name: 'ONEH-PDC',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 10',
    configuration: 'Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
    serial_no: null,
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.1.100',
    mac_address: '00:15:5D:01:5F:01',
    ilo_ip: '192.168.1.100'
  },
  {
    asset_name: 'OHEH-BACKUP',
    location: 'HEAD OFFICE',
    model_name: 'HP Prolaint GL360 Gen 10',
    configuration: 'Xeon 3.00GHz 24CPUs Gold 6248, 64GB RAM, 7.5TB SSD Drive',
    serial_no: null,
    year_of_purchase: null,
    warranty_end: null,
    asset_code: null,
    physical_virtual: 'Virtual',
    ip_address: '192.168.1.97',
    mac_address: '00:15:5D:01:5F:00',
    ilo_ip: '192.168.1.97'
  }
];

async function importServerInventory() {
  console.log('🚀 Starting server inventory import...\n');

  try {
    // Step 1: Ensure "Server" category exists
    console.log('📋 Step 1: Checking categories...');
    let { data: serverCategory, error: categoryError } = await supabase
      .from('categories')
      .select('id, name')
      .eq('name', 'Server')
      .maybeSingle();

    if (categoryError) {
      console.error('Error checking category:', categoryError);
      throw categoryError;
    }

    if (!serverCategory) {
      console.log('   Creating "Server" category...');
      const { data: newCategory, error: createError } = await supabase
        .from('categories')
        .insert([{ name: 'Server', description: 'Server infrastructure assets' }])
        .select()
        .single();

      if (createError) {
        console.error('Error creating category:', createError);
        throw createError;
      }
      serverCategory = newCategory;
      console.log('   ✅ Created "Server" category');
    } else {
      console.log('   ✅ "Server" category already exists');
    }

    // Step 2: Ensure "HEAD OFFICE" location exists
    console.log('\n📍 Step 2: Checking locations...');
    let { data: headOfficeLocation, error: locationError } = await supabase
      .from('locations')
      .select('id, name')
      .eq('name', 'HEAD OFFICE')
      .maybeSingle();

    if (locationError) {
      console.error('Error checking location:', locationError);
      throw locationError;
    }

    if (!headOfficeLocation) {
      console.log('   Creating "HEAD OFFICE" location...');
      const { data: newLocation, error: createError } = await supabase
        .from('locations')
        .insert([{ 
          name: 'HEAD OFFICE', 
          address: 'Main Office',
          description: 'Head office location'
        }])
        .select()
        .single();

      if (createError) {
        console.error('Error creating location:', createError);
        throw createError;
      }
      headOfficeLocation = newLocation;
      console.log('   ✅ Created "HEAD OFFICE" location');
    } else {
      console.log('   ✅ "HEAD OFFICE" location already exists');
    }

    // Step 3: Transform and import server assets
    console.log('\n💾 Step 3: Importing server assets...');
    
    const assetsToImport = serverInventory.map((server, index) => ({
      name: server.asset_name,
      description: `${server.model_name}${server.configuration ? ' - ' + server.configuration : ''}${server.physical_virtual ? ' (' + server.physical_virtual + ')' : ''}`,
      category_id: serverCategory.id,
      location_id: headOfficeLocation.id,
      serial_number: server.serial_no,
      asset_tag: server.asset_code || `SERVER-${String(index + 1).padStart(3, '0')}`,
      purchase_date: server.year_of_purchase || new Date().toISOString().split('T')[0],
      purchase_cost: 25000, // Estimated server cost
      current_value: 20000, // Estimated current value
      condition: 'excellent',
      status: 'active',
      assigned_to: null,
      warranty_expiry: server.warranty_end,
      notes: JSON.stringify({
        model: server.model_name,
        configuration: server.configuration,
        serial_number: server.serial_no,
        physical_virtual: server.physical_virtual,
        ip_address: server.ip_address,
        mac_address: server.mac_address,
        ilo_ip: server.ilo_ip
      }, null, 2)
    }));

    console.log(`   Importing ${assetsToImport.length} server assets...`);

    const { data: importedAssets, error: importError } = await supabase
      .from('assets')
      .insert(assetsToImport)
      .select();

    if (importError) {
      console.error('Error importing assets:', importError);
      throw importError;
    }

    console.log(`   ✅ Successfully imported ${importedAssets.length} server assets\n`);

    // Step 4: Display summary
    console.log('📊 Import Summary:');
    console.log('═══════════════════════════════════════════');
    console.log(`Total servers imported: ${importedAssets.length}`);
    console.log('\nImported servers:');
    importedAssets.forEach((asset, index) => {
      const notes = JSON.parse(asset.notes);
      console.log(`\n${index + 1}. ${asset.name}`);
      console.log(`   Model: ${notes.model}`);
      console.log(`   Type: ${notes.physical_virtual}`);
      console.log(`   IP: ${notes.ip_address}`);
      console.log(`   MAC: ${notes.mac_address}`);
      console.log(`   Asset Tag: ${asset.asset_tag}`);
    });

    console.log('\n═══════════════════════════════════════════');
    console.log('✅ Import completed successfully!');
    console.log('\n🌐 View in Supabase Dashboard:');
    console.log(`   ${supabaseUrl}/project/_/editor`);
    console.log('\n📱 View in AssetFlow:');
    console.log('   http://localhost:3000/assets');

  } catch (error) {
    console.error('\n❌ Import failed:', error.message);
    console.error('\nFull error:', error);
    process.exit(1);
  }
}

// Run the import
importServerInventory();
