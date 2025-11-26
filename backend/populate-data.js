const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

const categories = [
    { name: 'Accessory', description: 'Device accessories like keyboards, Apple Pencil, Magic Keyboard, chargers' },
    { name: 'Desktop', description: 'Desktop computers with OS, memory, CPU specifications and user assignments' },
    { name: 'Laptop', description: 'Laptop computers with OS, memory, CPU specifications and user assignments' },
    { name: 'Mobile Phone', description: 'Mobile phones and smartphones with IMEI numbers and transfer tracking' },
    { name: 'Monitor', description: 'Display monitors assigned to users across departments' },
    { name: 'Network Device', description: 'Network switches, firewalls, routers, and networking equipment' },
    { name: 'Peripheral', description: 'IT peripherals including mice, keyboard combos, cables, adapters, USB devices' },
    { name: 'Printer', description: 'Printers including laser, inkjet, multifunction devices, ID card and label printers' },
    { name: 'Server', description: 'Physical and virtual servers including ProLiant, Dell, HP models with IP addresses' },
    { name: 'Storage', description: 'Network Attached Storage (NAS), SAN, and storage devices' },
    { name: 'Switch', description: 'Network switches and managed switch infrastructure' },
    { name: 'Tablet', description: 'Tablet devices including iPads with Wi-Fi and cellular connectivity' },
    { name: 'Walkie Talkie', description: 'Two-way radios and walkie talkie devices with transfer history' },
    { name: 'Other', description: 'Other assets not fitting into standard categories' }
];

const locations = [
    { name: 'Head Office', building: 'Main Building' },
    { name: 'Main Office', building: 'Main Building' },
    { name: 'WHITE VILLA', building: 'White Villa' },
    { name: 'SPANISH VILLA', building: 'Spanish Villa' },
    { name: 'SAADIYAT VILLA 7', building: 'Saadiyat Villa 7' },
    { name: 'BARARI VILLA 1504', building: 'Al Barari Villa 1504' },
    { name: 'ALRAKNA', building: 'Al Rakna Villa' },
    { name: 'MUROOR KITCHEN', building: 'Muroor Kitchen' },
    { name: 'WATHBA KITCHEN', building: 'Wathba Kitchen' },
    { name: 'YASAT', building: 'Al Yasat Kitchen' },
    { name: 'MAIN STORE', building: 'Main Store' },
    { name: 'Store', building: 'Store Building' },
    { name: 'Data Center', building: 'Main Building', room: 'Data Center' },
    { name: 'Server Room', building: 'Main Building', room: 'Server Room' }
];

async function populateData() {
    console.log('🚀 Starting data population...\n');

    // Populate Categories
    console.log('📦 Populating Categories...');
    for (const cat of categories) {
        const { error } = await supabase
            .from('categories')
            .upsert(cat, { onConflict: 'name' });

        if (error) {
            console.error(`❌ Error inserting ${cat.name}:`, error.message);
        } else {
            console.log(`✅ Inserted/Updated: ${cat.name}`);
        }
    }

    // Populate Locations
    console.log('\n📍 Populating Locations...');
    for (const loc of locations) {
        const { error } = await supabase
            .from('locations')
            .upsert(loc, { onConflict: 'name' });

        if (error) {
            console.error(`❌ Error inserting ${loc.name}:`, error.message);
        } else {
            console.log(`✅ Inserted/Updated: ${loc.name}`);
        }
    }

    console.log('\n✨ Data population completed!');
}

populateData();
