const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/database');
const { sendMaintenanceNotification } = require('../services/notificationService');
const router = express.Router();

// Validation middleware
const validateMaintenanceRecord = [
  body('asset_id').isUUID().withMessage('Valid asset ID is required'),
  body('maintenance_type').trim().isLength({ min: 1, max: 100 }).withMessage('Maintenance type is required'),
  body('scheduled_date').isISO8601().withMessage('Valid scheduled date is required'),
  body('cost').isFloat({ min: 0 }).withMessage('Cost must be a positive number'),
  body('status').isIn(['scheduled', 'in_progress', 'completed', 'cancelled']).withMessage('Invalid status'),
];

// Get all maintenance records
router.get('/', async (req, res) => {
  try {
    const { page = 1, limit = 10, asset_id, status } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('maintenance_records')
      .select(`
        *,
        assets!inner(id, name, category, location)
      `)
      .range(offset, offset + limit - 1)
      .order('scheduled_date', { ascending: false });

    if (asset_id) query = query.eq('asset_id', asset_id);
    if (status) query = query.eq('status', status);

    const { data, error, count } = await query;

    if (error) throw error;

    res.json({
      data,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Error fetching maintenance records:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get single maintenance record
router.get('/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('maintenance_records')
      .select(`
        *,
        assets!inner(id, name, category, location)
      `)
      .eq('id', req.params.id)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'Maintenance record not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error fetching maintenance record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new maintenance record
router.post('/', validateMaintenanceRecord, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    // Verify asset exists
    const { data: asset, error: assetError } = await supabase
      .from('assets')
      .select('id, name, assigned_to')
      .eq('id', req.body.asset_id)
      .single();

    if (assetError) {
      return res.status(400).json({ error: 'Asset not found' });
    }

    const maintenanceData = {
      ...req.body,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    const { data, error } = await supabase
      .from('maintenance_records')
      .insert([maintenanceData])
      .select()
      .single();

    if (error) throw error;

    // Send notification if asset is assigned to someone
    if (asset.assigned_to) {
      try {
        await sendMaintenanceNotification(asset.assigned_to, {
          assetName: asset.name,
          maintenanceType: data.maintenance_type,
          scheduledDate: data.scheduled_date
        });
      } catch (notificationError) {
        console.error('Failed to send maintenance notification:', notificationError);
      }
    }

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating maintenance record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update maintenance record
router.put('/:id', validateMaintenanceRecord, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const updateData = {
      ...req.body,
      updated_at: new Date().toISOString()
    };

    // If status is being updated to completed, set completed_date
    if (req.body.status === 'completed' && !req.body.completed_date) {
      updateData.completed_date = new Date().toISOString();
    }

    const { data, error } = await supabase
      .from('maintenance_records')
      .update(updateData)
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'Maintenance record not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error updating maintenance record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete maintenance record
router.delete('/:id', async (req, res) => {
  try {
    const { error } = await supabase
      .from('maintenance_records')
      .delete()
      .eq('id', req.params.id);

    if (error) throw error;

    res.status(204).send();
  } catch (error) {
    console.error('Error deleting maintenance record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get maintenance statistics
router.get('/stats/summary', async (req, res) => {
  try {
    const { data: maintenanceRecords, error } = await supabase
      .from('maintenance_records')
      .select('status, cost, scheduled_date, completed_date');

    if (error) throw error;

    const now = new Date();
    const stats = {
      totalRecords: maintenanceRecords.length,
      totalCost: maintenanceRecords.reduce((sum, record) => sum + record.cost, 0),
      byStatus: {
        scheduled: 0,
        in_progress: 0,
        completed: 0,
        cancelled: 0
      },
      overdue: 0,
      upcoming: 0
    };

    maintenanceRecords.forEach(record => {
      stats.byStatus[record.status]++;
      
      if (record.status === 'scheduled') {
        const scheduledDate = new Date(record.scheduled_date);
        if (scheduledDate < now) {
          stats.overdue++;
        } else if (scheduledDate <= new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000)) {
          stats.upcoming++;
        }
      }
    });

    res.json(stats);
  } catch (error) {
    console.error('Error fetching maintenance statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;