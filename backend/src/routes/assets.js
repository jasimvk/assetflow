const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/database');
const router = express.Router();

// Validation middleware
const validateAsset = [
  body('name').trim().isLength({ min: 1, max: 255 }).withMessage('Name is required and must be less than 255 characters'),
  body('category').trim().isLength({ min: 1, max: 100 }).withMessage('Category is required'),
  body('location').trim().isLength({ min: 1, max: 255 }).withMessage('Location is required'),
  body('purchase_date').isISO8601().withMessage('Valid purchase date is required'),
  body('purchase_cost').isFloat({ min: 0 }).withMessage('Purchase cost must be a positive number'),
  body('current_value').isFloat({ min: 0 }).withMessage('Current value must be a positive number'),
  body('condition').isIn(['excellent', 'good', 'fair', 'poor']).withMessage('Condition must be excellent, good, fair, or poor'),
];

// Get all assets
router.get('/', async (req, res) => {
  try {
    const { page = 1, limit = 10, category, location, condition } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('assets')
      .select('*')
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    if (category) query = query.eq('category', category);
    if (location) query = query.eq('location', location);
    if (condition) query = query.eq('condition', condition);

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
    console.error('Error fetching assets:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get single asset
router.get('/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('assets')
      .select('*')
      .eq('id', req.params.id)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'Asset not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error fetching asset:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new asset
router.post('/', validateAsset, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const assetData = {
      ...req.body,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    const { data, error } = await supabase
      .from('assets')
      .insert([assetData])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating asset:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update asset
router.put('/:id', validateAsset, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const updateData = {
      ...req.body,
      updated_at: new Date().toISOString()
    };

    const { data, error } = await supabase
      .from('assets')
      .update(updateData)
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'Asset not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error updating asset:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete asset
router.delete('/:id', async (req, res) => {
  try {
    const { error } = await supabase
      .from('assets')
      .delete()
      .eq('id', req.params.id);

    if (error) throw error;

    res.status(204).send();
  } catch (error) {
    console.error('Error deleting asset:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get asset statistics
router.get('/stats/summary', async (req, res) => {
  try {
    const { data: assets, error } = await supabase
      .from('assets')
      .select('category, condition, current_value');

    if (error) throw error;

    const stats = {
      totalAssets: assets.length,
      totalValue: assets.reduce((sum, asset) => sum + asset.current_value, 0),
      byCategory: {},
      byCondition: {
        excellent: 0,
        good: 0,
        fair: 0,
        poor: 0
      }
    };

    assets.forEach(asset => {
      // Count by category
      stats.byCategory[asset.category] = (stats.byCategory[asset.category] || 0) + 1;
      
      // Count by condition
      stats.byCondition[asset.condition]++;
    });

    res.json(stats);
  } catch (error) {
    console.error('Error fetching asset statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;