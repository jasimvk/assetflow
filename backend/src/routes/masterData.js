const express = require('express');
const supabase = require('../config/database');
const router = express.Router();

// ============================================
// LOCATIONS API
// ============================================

// Get all locations
router.get('/locations', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('locations')
      .select('id, name, address, building, floor, room')
      .order('name', { ascending: true });

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching locations:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new location
router.post('/locations', async (req, res) => {
  try {
    const { name, address, building, floor, room } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Location name is required' });
    }

    const { data, error } = await supabase
      .from('locations')
      .insert([{ name, address, building, floor, room }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'Location already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating location:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// MANUFACTURERS API
// ============================================

// Get all manufacturers
router.get('/manufacturers', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('manufacturers')
      .select('id, name')
      .order('name', { ascending: true });

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching manufacturers:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new manufacturer
router.post('/manufacturers', async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Manufacturer name is required' });
    }

    const { data, error } = await supabase
      .from('manufacturers')
      .insert([{ name }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'Manufacturer already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating manufacturer:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// MODELS API
// ============================================

// Get all models (optionally filter by manufacturer)
router.get('/models', async (req, res) => {
  try {
    const { manufacturer_id } = req.query;
    
    let query = supabase
      .from('models')
      .select('id, name, manufacturer_id')
      .order('name', { ascending: true });

    if (manufacturer_id) {
      query = query.eq('manufacturer_id', manufacturer_id);
    }

    const { data, error } = await query;

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching models:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new model
router.post('/models', async (req, res) => {
  try {
    const { name, manufacturer_id } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Model name is required' });
    }

    const { data, error } = await supabase
      .from('models')
      .insert([{ name, manufacturer_id }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'Model already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating model:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// OS VERSIONS API
// ============================================

// Get all OS versions
router.get('/os-versions', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('os_versions')
      .select('id, name')
      .order('name', { ascending: true });

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching OS versions:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new OS version
router.post('/os-versions', async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'OS version name is required' });
    }

    const { data, error } = await supabase
      .from('os_versions')
      .insert([{ name }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'OS version already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating OS version:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// CPU TYPES API
// ============================================

// Get all CPU types
router.get('/cpu-types', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('cpu_types')
      .select('id, name')
      .order('name', { ascending: true });

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching CPU types:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new CPU type
router.post('/cpu-types', async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'CPU type name is required' });
    }

    const { data, error } = await supabase
      .from('cpu_types')
      .insert([{ name }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'CPU type already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating CPU type:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// RAM SIZES API
// ============================================

// Get all RAM sizes
router.get('/ram-sizes', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('ram_sizes')
      .select('id, name')
      .order('name', { ascending: true });

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching RAM sizes:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new RAM size
router.post('/ram-sizes', async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'RAM size is required' });
    }

    const { data, error } = await supabase
      .from('ram_sizes')
      .insert([{ name }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'RAM size already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating RAM size:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// STORAGE SIZES API
// ============================================

// Get all storage sizes
router.get('/storage-sizes', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('storage_sizes')
      .select('id, name')
      .order('name', { ascending: true });

    if (error) throw error;
    res.json(data || []);
  } catch (error) {
    console.error('Error fetching storage sizes:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new storage size
router.post('/storage-sizes', async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Storage size is required' });
    }

    const { data, error } = await supabase
      .from('storage_sizes')
      .insert([{ name }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(409).json({ error: 'Storage size already exists' });
      }
      throw error;
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating storage size:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// ASSET CODE GENERATION
// ============================================

// Generate next asset code for a category
router.get('/generate-asset-code/:category', async (req, res) => {
  try {
    const { category } = req.params;
    
    // Define category prefixes
    const categoryPrefixes = {
      'Desktop': 'DSK',
      'Laptop': 'LPT',
      'Server': 'SRV',
      'Monitor': 'MON',
      'Printer': 'PRT',
      'Switch': 'SWT',
      'Storage': 'STR',
      'Mobile Phone': 'MOB',
      'Walkie Talkie': 'WLK',
      'Tablet': 'TBL',
      'IT Peripherals': 'PER',
      'Other': 'OTH'
    };

    const prefix = categoryPrefixes[category] || 'AST';
    const year = new Date().getFullYear().toString().slice(-2);

    // Get the latest asset code for this category/prefix
    const { data: latestAssets, error } = await supabase
      .from('assets')
      .select('asset_code')
      .like('asset_code', `${prefix}-${year}-%`)
      .order('asset_code', { ascending: false })
      .limit(1);

    if (error) throw error;

    let nextNumber = 1;
    if (latestAssets && latestAssets.length > 0) {
      const lastCode = latestAssets[0].asset_code;
      const lastNumber = parseInt(lastCode.split('-')[2]) || 0;
      nextNumber = lastNumber + 1;
    }

    const assetCode = `${prefix}-${year}-${String(nextNumber).padStart(4, '0')}`;

    res.json({ asset_code: assetCode });
  } catch (error) {
    console.error('Error generating asset code:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ============================================
// GET ALL MASTER DATA (COMBINED)
// ============================================

// Get all master data in one request (for form initialization)
router.get('/all', async (req, res) => {
  try {
    const [
      locationsRes,
      manufacturersRes,
      modelsRes,
      osVersionsRes,
      cpuTypesRes,
      ramSizesRes,
      storageSizesRes,
      departmentsRes
    ] = await Promise.all([
      supabase.from('locations').select('id, name').order('name'),
      supabase.from('manufacturers').select('id, name').order('name'),
      supabase.from('models').select('id, name, manufacturer_id').order('name'),
      supabase.from('os_versions').select('id, name').order('name'),
      supabase.from('cpu_types').select('id, name').order('name'),
      supabase.from('ram_sizes').select('id, name').order('name'),
      supabase.from('storage_sizes').select('id, name').order('name'),
      supabase.from('departments').select('id, name').order('name')
    ]);

    res.json({
      locations: locationsRes.data || [],
      manufacturers: manufacturersRes.data || [],
      models: modelsRes.data || [],
      osVersions: osVersionsRes.data || [],
      cpuTypes: cpuTypesRes.data || [],
      ramSizes: ramSizesRes.data || [],
      storageSizes: storageSizesRes.data || [],
      departments: departmentsRes.data || []
    });
  } catch (error) {
    console.error('Error fetching master data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
