const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/database');
const { sendMaintenanceNotification } = require('../services/notificationService');
const router = express.Router();

// Get user notifications
router.get('/', async (req, res) => {
  try {
    const userId = req.user.id; // Assuming auth middleware sets req.user
    const { page = 1, limit = 10, unread_only } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('notifications')
      .select('*')
      .eq('user_id', userId)
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    if (unread_only === 'true') {
      query = query.eq('read', false);
    }

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
    console.error('Error fetching notifications:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Mark notification as read
router.put('/:id/read', async (req, res) => {
  try {
    const userId = req.user.id;
    const notificationId = req.params.id;

    const { data, error } = await supabase
      .from('notifications')
      .update({ read: true, updated_at: new Date().toISOString() })
      .eq('id', notificationId)
      .eq('user_id', userId)
      .select()
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return res.status(404).json({ error: 'Notification not found' });
      }
      throw error;
    }

    res.json(data);
  } catch (error) {
    console.error('Error marking notification as read:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Mark all notifications as read
router.put('/mark-all-read', async (req, res) => {
  try {
    const userId = req.user.id;

    const { data, error } = await supabase
      .from('notifications')
      .update({ read: true, updated_at: new Date().toISOString() })
      .eq('user_id', userId)
      .eq('read', false)
      .select();

    if (error) throw error;

    res.json({ message: 'All notifications marked as read', updated_count: data.length });
  } catch (error) {
    console.error('Error marking all notifications as read:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create notification (admin only)
router.post('/', [
  body('user_id').isUUID().withMessage('Valid user ID is required'),
  body('title').trim().isLength({ min: 1, max: 255 }).withMessage('Title is required and must be less than 255 characters'),
  body('message').trim().isLength({ min: 1 }).withMessage('Message is required'),
  body('type').optional().isIn(['info', 'warning', 'error', 'success']).withMessage('Type must be info, warning, error, or success'),
], async (req, res) => {
  try {
    // Check if user has admin privileges
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Insufficient permissions' });
    }

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const notificationData = {
      ...req.body,
      created_at: new Date().toISOString()
    };

    const { data, error } = await supabase
      .from('notifications')
      .insert([notificationData])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating notification:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Send test notification
router.post('/test', async (req, res) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    await sendMaintenanceNotification(email, {
      assetName: 'Test Asset',
      maintenanceType: 'Test Maintenance',
      scheduledDate: new Date().toISOString()
    });

    res.json({ message: 'Test notification sent successfully' });
  } catch (error) {
    console.error('Error sending test notification:', error);
    res.status(500).json({ error: 'Failed to send test notification' });
  }
});

// Get notification statistics
router.get('/stats', async (req, res) => {
  try {
    const userId = req.user.id;

    const { data, error } = await supabase
      .from('notifications')
      .select('read, type, created_at')
      .eq('user_id', userId);

    if (error) throw error;

    const stats = {
      total: data.length,
      unread: data.filter(n => !n.read).length,
      read: data.filter(n => n.read).length,
      byType: {
        info: data.filter(n => n.type === 'info').length,
        warning: data.filter(n => n.type === 'warning').length,
        error: data.filter(n => n.type === 'error').length,
        success: data.filter(n => n.type === 'success').length,
      }
    };

    res.json(stats);
  } catch (error) {
    console.error('Error fetching notification statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;