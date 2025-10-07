const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/database');
const router = express.Router();

// Get all users
router.get('/', async (req, res) => {
  try {
    const { page = 1, limit = 10, role, department } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('users')
      .select('id, email, name, role, department, created_at, updated_at')
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    if (role) query = query.eq('role', role);
    if (department) query = query.eq('department', department);

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
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get single user
router.get('/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('id, email, name, role, department, created_at, updated_at')
      .eq('id', req.params.id)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'User not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update user
router.put('/:id', [
  body('name').optional().trim().isLength({ min: 1, max: 255 }).withMessage('Name must be between 1 and 255 characters'),
  body('role').optional().isIn(['admin', 'manager', 'user']).withMessage('Role must be admin, manager, or user'),
  body('department').optional().trim().isLength({ max: 100 }).withMessage('Department must be less than 100 characters'),
], async (req, res) => {
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
      .from('users')
      .update(updateData)
      .eq('id', req.params.id)
      .select('id, email, name, role, department, created_at, updated_at')
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'User not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get current user profile
router.get('/me/profile', async (req, res) => {
  try {
    const userId = req.user.id; // Assuming auth middleware sets req.user

    const { data, error } = await supabase
      .from('users')
      .select('id, email, name, role, department, created_at, updated_at')
      .eq('id', userId)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'User not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;