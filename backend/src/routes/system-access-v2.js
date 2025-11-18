const express = require('express');
const router = express.Router();
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// ============================================
// SYSTEMS MANAGEMENT
// ============================================

// Get all systems
router.get('/systems', async (req, res) => {
  try {
    const { category, status } = req.query;
    
    let query = supabase
      .from('systems')
      .select('*')
      .order('name');
    
    if (category) query = query.eq('category', category);
    if (status) query = query.eq('status', status);
    
    const { data, error } = await query;
    
    if (error) throw error;
    res.json(data);
  } catch (error) {
    console.error('Error fetching systems:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get system by ID with detailed info
router.get('/systems/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    // Get system details
    const { data: system, error: systemError } = await supabase
      .from('systems')
      .select('*')
      .eq('id', id)
      .single();
    
    if (systemError) throw systemError;
    
    // Get active users count
    const { count: activeUsers } = await supabase
      .from('user_access')
      .select('*', { count: 'exact', head: true })
      .eq('system_id', id)
      .eq('status', 'active');
    
    // Get pending requests count
    const { count: pendingRequests } = await supabase
      .from('access_requests')
      .select('*', { count: 'exact', head: true })
      .eq('system_id', id)
      .eq('status', 'pending');
    
    res.json({
      ...system,
      active_users: activeUsers || 0,
      pending_requests: pendingRequests || 0
    });
  } catch (error) {
    console.error('Error fetching system:', error);
    res.status(500).json({ error: error.message });
  }
});

// Create new system
router.post('/systems', async (req, res) => {
  try {
    const systemData = req.body;
    
    // Set available_licenses equal to total_licenses initially
    if (systemData.total_licenses) {
      systemData.available_licenses = systemData.total_licenses;
    }
    
    const { data, error } = await supabase
      .from('systems')
      .insert([systemData])
      .select()
      .single();
    
    if (error) throw error;
    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating system:', error);
    res.status(500).json({ error: error.message });
  }
});

// Update system
router.put('/systems/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updates = req.body;
    
    const { data, error } = await supabase
      .from('systems')
      .update(updates)
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    res.json(data);
  } catch (error) {
    console.error('Error updating system:', error);
    res.status(500).json({ error: error.message });
  }
});

// Delete system
router.delete('/systems/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const { error } = await supabase
      .from('systems')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
    res.json({ message: 'System deleted successfully' });
  } catch (error) {
    console.error('Error deleting system:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get dashboard statistics
router.get('/dashboard-stats', async (req, res) => {
  try {
    // Total systems
    const { count: totalSystems } = await supabase
      .from('systems')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'active');
    
    // Total active users
    const { count: totalUsers } = await supabase
      .from('user_access')
      .select('user_id', { count: 'exact', head: true })
      .eq('status', 'active');
    
    // Pending requests
    const { count: pendingRequests } = await supabase
      .from('access_requests')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'pending');
    
    // Expiring soon (next 30 days)
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);
    
    const { count: expiringSoon } = await supabase
      .from('systems')
      .select('*', { count: 'exact', head: true })
      .lte('renewal_date', thirtyDaysFromNow.toISOString().split('T')[0])
      .gte('renewal_date', new Date().toISOString().split('T')[0]);
    
    res.json({
      total_systems: totalSystems || 0,
      total_active_users: totalUsers || 0,
      pending_requests: pendingRequests || 0,
      expiring_soon: expiringSoon || 0
    });
  } catch (error) {
    console.error('Error fetching dashboard stats:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
