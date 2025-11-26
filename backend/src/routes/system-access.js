const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/database');
const { requirePermission, applyDataScope } = require('../middleware/rbac');
const { PERMISSIONS } = require('../../../shared/roles');
const mockAuth = require('../middleware/mockAuth');
const router = express.Router();

// Generate request number
const generateRequestNumber = async () => {
  const year = new Date().getFullYear();
  const { data, error } = await supabase
    .from('system_access_requests')
    .select('request_number')
    .like('request_number', `SAR-${year}-%`)
    .order('created_at', { ascending: false })
    .limit(1);

  if (error) throw error;

  const lastNumber = data && data.length > 0
    ? parseInt(data[0].request_number.split('-')[2])
    : 0;

  return `SAR-${year}-${String(lastNumber + 1).padStart(3, '0')}`;
};

// Create audit history entry
const createHistoryEntry = async (requestId, action, description, performedBy, metadata = {}) => {
  const { error } = await supabase
    .from('access_request_history')
    .insert([{
      access_request_id: requestId,
      action,
      description,
      performed_by: performedBy,
      metadata
    }]);

  if (error) console.error('Error creating history entry:', error);
};

// GET all requests (with RBAC filtering)
router.get('/', mockAuth, applyDataScope(), async (req, res) => {
  try {
    const { page = 1, limit = 20, status, department, search } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('system_access_requests')
      .select('*, requested_by_user:users!requested_by(name, email)', { count: 'exact' })
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    // Apply RBAC filters
    if (req.filters) {
      if (req.filters.department) {
        query = query.eq('department', req.filters.department);
      }
      if (req.filters.user_id) {
        query = query.eq('requested_by', req.filters.user_id);
      }
    }

    // Additional filters
    if (status) query = query.eq('status', status);
    if (department) query = query.eq('department', department);
    if (search) {
      query = query.or(`employee_first_name.ilike.%${search}%,employee_last_name.ilike.%${search}%,request_number.ilike.%${search}%`);
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
    console.error('Error fetching requests:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET single request with full details
router.get('/:id', mockAuth, async (req, res) => {
  try {
    const { data: request, error: requestError } = await supabase
      .from('system_access_requests')
      .select(`
        *,
        requested_by_user:users!requested_by(name, email),
        approved_by_user:users!approved_by(name, email),
        assigned_to_user:users!assigned_to(name, email)
      `)
      .eq('id', req.params.id)
      .single();

    if (requestError) throw requestError;
    if (!request) return res.status(404).json({ error: 'Request not found' });

    // Fetch related details
    const [systemDetails, assetHandovers, approvals, history, oracleFusion, timetec, networkEmail] = await Promise.all([
      supabase.from('system_access_details').select('*, system:systems(*)').eq('access_request_id', req.params.id),
      supabase.from('it_asset_handover').select('*, asset:assets(*)').eq('access_request_id', req.params.id),
      supabase.from('access_request_approvals').select('*, approver:users(name, email)').eq('access_request_id', req.params.id),
      supabase.from('access_request_history').select('*, performed_by_user:users(name, email)').eq('access_request_id', req.params.id).order('performed_at', { ascending: false }),
      supabase.from('oracle_fusion_access').select('*').eq('access_request_id', req.params.id).maybeSingle(),
      supabase.from('timetec_access').select('*').eq('access_request_id', req.params.id).maybeSingle(),
      supabase.from('network_email_access').select('*').eq('access_request_id', req.params.id).maybeSingle()
    ]);

    res.json({
      ...request,
      system_details: systemDetails.data || [],
      asset_handovers: assetHandovers.data || [],
      approvals: approvals.data || [],
      history: history.data || [],
      oracle_fusion: oracleFusion.data,
      timetec: timetec.data,
      network_email: networkEmail.data
    });
  } catch (error) {
    console.error('Error fetching request details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST - Create new request (from wizard)
router.post('/', mockAuth, async (req, res) => {
  try {
    const {
      employee_first_name,
      employee_last_name,
      employee_id,
      entra_id,
      department,
      department_head,
      email,
      date_of_joining,
      request_type,
      priority,
      notes,
      network_email,
      oracle_fusion,
      timetec,
      hardware_requests
    } = req.body;

    // Generate request number
    const request_number = await generateRequestNumber();

    // Create main request
    const { data: newRequest, error: requestError } = await supabase
      .from('system_access_requests')
      .insert([{
        request_number,
        employee_first_name,
        employee_last_name,
        employee_id,
        entra_id,
        department,
        department_head,
        email,
        date_of_joining,
        request_type,
        priority: priority || 'medium',
        notes,
        requested_by: req.user.id,
        status: 'pending'
      }])
      .select()
      .single();

    if (requestError) throw requestError;

    // Create Network & Email Access if requested
    if (network_email) {
      const { error: networkError } = await supabase
        .from('network_email_access')
        .insert([{
          access_request_id: newRequest.id,
          network_login: network_email.network_login || false,
          email_generic: network_email.email_generic || false,
          email_personal: network_email.email_personal || false,
          status: 'pending'
        }]);

      if (networkError) throw networkError;
    }

    // Create Oracle Fusion Access if requested
    if (oracle_fusion) {
      const { error: oracleError } = await supabase
        .from('oracle_fusion_access')
        .insert([{
          access_request_id: newRequest.id,
          ...oracle_fusion,
          status: 'pending'
        }]);

      if (oracleError) throw oracleError;
    }

    // Create Timetec Access if requested
    if (timetec) {
      const { error: timetecError } = await supabase
        .from('timetec_access')
        .insert([{
          access_request_id: newRequest.id,
          ...timetec,
          status: 'pending'
        }]);

      if (timetecError) throw timetecError;
    }

    // Create hardware requests (IT asset handover records)
    if (hardware_requests && hardware_requests.length > 0) {
      const handoverRecords = hardware_requests.map(hr => ({
        access_request_id: newRequest.id,
        asset_type: hr.asset_type,
        asset_details: hr.notes,
        status: 'pending'
      }));

      const { error: handoverError } = await supabase
        .from('it_asset_handover')
        .insert(handoverRecords);

      if (handoverError) throw handoverError;
    }

    // Create history entry
    await createHistoryEntry(
      newRequest.id,
      'created',
      `Request ${request_number} created`,
      req.user.id,
      {
        request_type,
        priority,
        has_network_email: !!network_email,
        has_oracle_fusion: !!oracle_fusion,
        has_timetec: !!timetec,
        hardware_count: hardware_requests?.length || 0
      }
    );

    res.status(201).json({
      message: 'Request created successfully',
      request: newRequest
    });
  } catch (error) {
    console.error('Error creating request:', error);
    res.status(500).json({ error: 'Failed to create request', details: error.message });
  }
});

// PATCH - Update request status / approval
router.patch('/:id/status', mockAuth, async (req, res) => {
  try {
    const { status, comments, rejection_reason } = req.body;

    const validStatuses = ['pending', 'under_review', 'approved', 'rejected', 'in_progress', 'completed', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }

    const updateData = { status };
    let historyAction = 'status_changed';
    let historyDesc = `Status changed to ${status}`;

    // Handle approval
    if (status === 'approved') {
      updateData.approved_by = req.user.id;
      updateData.approval_date = new Date().toISOString();
      historyAction = 'approved';
      historyDesc = `Request approved${comments ? ': ' + comments : ''}`;
    }

    // Handle rejection
    if (status === 'rejected') {
      updateData.rejected_by = req.user.id;
      updateData.rejection_date = new Date().toISOString();
      updateData.rejection_reason = rejection_reason || comments;
      historyAction = 'rejected';
      historyDesc = `Request rejected: ${rejection_reason || 'No reason provided'}`;
    }

    // Handle assignment
    if (status === 'in_progress' && req.body.assigned_to) {
      updateData.assigned_to = req.body.assigned_to;
      historyAction = 'assigned';
      historyDesc = `Request assigned to user ${req.body.assigned_to}`;
    }

    // Handle completion
    if (status === 'completed') {
      updateData.completed_by = req.user.id;
      updateData.completed_at = new Date().toISOString();
      historyAction = 'completed';
      historyDesc = 'Request marked as completed';
    }

    // Update request
    const { data, error } = await supabase
      .from('system_access_requests')
      .update(updateData)
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) throw error;

    // Create history entry
    await createHistoryEntry(
      req.params.id,
      historyAction,
      historyDesc,
      req.user.id,
      { status, comments, rejection_reason }
    );

    // Create approval record
    if (status === 'approved' || status === 'rejected') {
      await supabase
        .from('access_request_approvals')
        .insert([{
          access_request_id: req.params.id,
          approver_id: req.user.id,
          approver_role: req.user.role,
          decision: status === 'approved' ? 'approved' : 'rejected',
          decision_date: new Date().toISOString(),
          comments: comments || rejection_reason
        }]);
    }

    res.json({
      message: 'Request updated successfully',
      request: data
    });
  } catch (error) {
    console.error('Error updating request:', error);
    res.status(500).json({ error: 'Failed to update request' });
  }
});

// PATCH - Link asset to handover
router.patch('/:id/link-asset', mockAuth, async (req, res) => {
  try {
    const { handover_id, asset_id } = req.body;

    if (!handover_id || !asset_id) {
      return res.status(400).json({ error: 'handover_id and asset_id are required' });
    }

    // Fetch asset details
    const { data: asset, error: assetError } = await supabase
      .from('assets')
      .select('*')
      .eq('id', asset_id)
      .single();

    if (assetError || !asset) {
      return res.status(404).json({ error: 'Asset not found' });
    }

    // Check if asset is available
    if (asset.status !== 'available') {
      return res.status(400).json({ error: 'Asset is not available' });
    }

    // Update handover record
    const { data, error } = await supabase
      .from('it_asset_handover')
      .update({
        asset_id,
        serial_number: asset.serial_number,
        condition: asset.condition
      })
      .eq('id', handover_id)
      .select()
      .single();

    if (error) throw error;

    // Create history entry
    await createHistoryEntry(
      req.params.id,
      'asset_linked',
      `Asset ${asset.asset_tag} linked to request`,
      req.user.id,
      { asset_id, asset_tag: asset.asset_tag }
    );

    res.json({
      message: 'Asset linked successfully',
      handover: data
    });
  } catch (error) {
    console.error('Error linking asset:', error);
    res.status(500).json({ error: 'Failed to link asset' });
  }
});

// GET - Available assets by type
router.get('/assets/available/:type', mockAuth, async (req, res) => {
  try {
    const { type } = req.params;

    const { data, error } = await supabase
      .from('assets')
      .select('*')
      .eq('category', type)
      .eq('status', 'available')
      .order('created_at', { ascending: false });

    if (error) throw error;

    res.json({
      type,
      count: data.length,
      assets: data
    });
  } catch (error) {
    console.error('Error fetching available assets:', error);
    res.status(500).json({ error: 'Failed to fetch assets' });
  }
});

// GET - Statistics
router.get('/stats/summary', mockAuth, async (req, res) => {
  try {
    const [total, pending, approved, rejected, inProgress] = await Promise.all([
      supabase.from('system_access_requests').select('id', { count: 'exact', head: true }),
      supabase.from('system_access_requests').select('id', { count: 'exact', head: true }).eq('status', 'pending'),
      supabase.from('system_access_requests').select('id', { count: 'exact', head: true }).eq('status', 'approved'),
      supabase.from('system_access_requests').select('id', { count: 'exact', head: true }).eq('status', 'rejected'),
      supabase.from('system_access_requests').select('id', { count: 'exact', head: true }).eq('status', 'in_progress')
    ]);

    res.json({
      total: total.count || 0,
      pending: pending.count || 0,
      approved: approved.count || 0,
      rejected: rejected.count || 0,
      in_progress: inProgress.count || 0
    });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

module.exports = router;
