const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/database');
const router = express.Router();

// Validation middleware for system access requests
const validateAccessRequest = [
  body('employee_first_name').trim().isLength({ min: 1, max: 100 }).withMessage('First name is required'),
  body('employee_last_name').trim().isLength({ min: 1, max: 100 }).withMessage('Last name is required'),
  body('employee_id').trim().isLength({ min: 1, max: 50 }).withMessage('Employee ID is required'),
  body('department').trim().isLength({ min: 1, max: 100 }).withMessage('Department is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('date_of_joining').isISO8601().withMessage('Valid joining date is required'),
];

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

// Get all system access requests
router.get('/', async (req, res) => {
  try {
    const { page = 1, limit = 10, status, department } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('system_access_requests')
      .select(`
        *,
        requested_by_user:requested_by(name, email),
        approved_by_user:approved_by(name, email)
      `)
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    if (status) query = query.eq('status', status);
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
    console.error('Error fetching system access requests:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get single system access request with details
router.get('/:id', async (req, res) => {
  try {
    const { data: request, error: requestError } = await supabase
      .from('system_access_requests')
      .select(`
        *,
        requested_by_user:requested_by(name, email),
        approved_by_user:approved_by(name, email)
      `)
      .eq('id', req.params.id)
      .single();

    if (requestError) {
      if (requestError.code === 'PGRST116') {
        return res.status(404).json({ error: 'Access request not found' });
      }
      throw requestError;
    }

    // Get system access details
    const { data: systemAccess, error: systemError } = await supabase
      .from('system_access_details')
      .select('*')
      .eq('access_request_id', req.params.id);

    if (systemError) throw systemError;

    // Get Oracle Fusion access details
    const { data: oracleAccess, error: oracleError } = await supabase
      .from('oracle_fusion_access')
      .select('*')
      .eq('access_request_id', req.params.id)
      .single();

    // Get IT asset handover details
    const { data: itAssets, error: assetsError } = await supabase
      .from('it_asset_handover')
      .select(`
        *,
        asset:asset_id(name, serial_number)
      `)
      .eq('access_request_id', req.params.id);

    if (assetsError) throw assetsError;

    // Get time & attendance access
    const { data: timeAttendance, error: timeError } = await supabase
      .from('time_attendance_access')
      .select('*')
      .eq('access_request_id', req.params.id)
      .single();

    res.json({
      ...request,
      system_access: systemAccess || [],
      oracle_fusion: oracleAccess || null,
      it_assets: itAssets || [],
      time_attendance: timeAttendance || null
    });
  } catch (error) {
    console.error('Error fetching access request:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new system access request
router.post('/', validateAccessRequest, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const requestNumber = await generateRequestNumber();

    const requestData = {
      request_number: requestNumber,
      employee_first_name: req.body.employee_first_name,
      employee_last_name: req.body.employee_last_name,
      employee_id: req.body.employee_id,
      department: req.body.department,
      department_head: req.body.department_head,
      email: req.body.email,
      date_of_joining: req.body.date_of_joining,
      status: 'pending',
      requested_by: req.user?.id,
    };

    const { data: request, error: requestError } = await supabase
      .from('system_access_requests')
      .insert([requestData])
      .select()
      .single();

    if (requestError) throw requestError;

    // Insert system access details if provided
    if (req.body.system_access && req.body.system_access.length > 0) {
      const systemAccessData = req.body.system_access.map(access => ({
        ...access,
        access_request_id: request.id
      }));

      const { error: systemError } = await supabase
        .from('system_access_details')
        .insert(systemAccessData);

      if (systemError) throw systemError;
    }

    // Insert Oracle Fusion access if provided
    if (req.body.oracle_fusion) {
      const oracleData = {
        ...req.body.oracle_fusion,
        access_request_id: request.id
      };

      const { error: oracleError } = await supabase
        .from('oracle_fusion_access')
        .insert([oracleData]);

      if (oracleError) throw oracleError;
    }

    // Insert IT asset handover requests if provided
    if (req.body.it_assets && req.body.it_assets.length > 0) {
      const assetsData = req.body.it_assets.map(asset => ({
        ...asset,
        access_request_id: request.id
      }));

      const { error: assetsError } = await supabase
        .from('it_asset_handover')
        .insert(assetsData);

      if (assetsError) throw assetsError;
    }

    // Insert time & attendance access if provided
    if (req.body.time_attendance) {
      const timeData = {
        ...req.body.time_attendance,
        access_request_id: request.id
      };

      const { error: timeError } = await supabase
        .from('time_attendance_access')
        .insert([timeData]);

      if (timeError) throw timeError;
    }

    // Log the action
    await supabase
      .from('access_request_history')
      .insert([{
        access_request_id: request.id,
        action: 'created',
        description: `System access request created for ${req.body.employee_first_name} ${req.body.employee_last_name}`,
        new_status: 'pending',
        performed_by: req.user?.id
      }]);

    res.status(201).json(request);
  } catch (error) {
    console.error('Error creating system access request:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update system access request status
router.patch('/:id/status', async (req, res) => {
  try {
    const { status, comments, reason } = req.body;
    
    if (!['pending', 'in_progress', 'approved', 'rejected', 'completed', 'cancelled'].includes(status)) {
      return res.status(400).json({ error: 'Invalid status' });
    }

    const updateData = {
      status,
      updated_at: new Date().toISOString()
    };

    if (status === 'approved') {
      updateData.approved_at = new Date().toISOString();
      updateData.approved_by = req.user?.id;
    }

    if (status === 'rejected') {
      updateData.rejected_at = new Date().toISOString();
      updateData.rejection_reason = reason || comments || 'No reason provided';
    }

    if (status === 'completed') {
      updateData.completed_at = new Date().toISOString();
      updateData.completed_by = req.user?.id;
    }

    const { data, error } = await supabase
      .from('system_access_requests')
      .update(updateData)
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) throw error;

    // Log the action to history
    const historyData = {
      access_request_id: req.params.id,
      action: status === 'approved' ? 'approved' : status === 'rejected' ? 'rejected' : 'status_changed',
      description: status === 'rejected' 
        ? `Request rejected: ${updateData.rejection_reason}`
        : `Status changed to ${status}`,
      new_status: status,
      performed_by: req.user?.id
    };

    if (comments) {
      historyData.comments = comments;
    }

    await supabase
      .from('access_request_history')
      .insert([historyData]);

    // Create notification for the requester
    if (status === 'approved' || status === 'rejected') {
      const { data: requestData } = await supabase
        .from('system_access_requests')
        .select('requested_by, employee_first_name, employee_last_name, request_number')
        .eq('id', req.params.id)
        .single();

      if (requestData && requestData.requested_by) {
        await supabase
          .from('notifications')
          .insert([{
            user_id: requestData.requested_by,
            title: status === 'approved' ? 'Access Request Approved' : 'Access Request Rejected',
            message: status === 'approved'
              ? `Your access request #${requestData.request_number} has been approved.`
              : `Your access request #${requestData.request_number} has been rejected. Reason: ${updateData.rejection_reason}`,
            type: status === 'approved' ? 'success' : 'warning',
            related_id: req.params.id,
            related_type: 'access_request'
          }]);
      }
    }

    res.json(data);
  } catch (error) {
    console.error('Error updating request status:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update system access provisioning status
router.patch('/:id/system-access/:systemId', async (req, res) => {
  try {
    const { status, username, notes } = req.body;

    const updateData = {
      status,
      username,
      notes,
      provisioned_at: status === 'provisioned' ? new Date().toISOString() : null,
      provisioned_by: status === 'provisioned' ? req.user?.id : null
    };

    const { data, error } = await supabase
      .from('system_access_details')
      .update(updateData)
      .eq('id', req.params.systemId)
      .select()
      .single();

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error updating system access:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update IT asset handover status
router.patch('/:id/assets/:assetHandoverId', async (req, res) => {
  try {
    const { status, asset_id, serial_number, condition, notes } = req.body;

    const updateData = {
      status,
      asset_id,
      serial_number,
      condition,
      notes,
      handover_date: status === 'handed_over' ? new Date().toISOString() : null,
      handed_over_by: status === 'handed_over' ? req.user?.id : null
    };

    const { data, error } = await supabase
      .from('it_asset_handover')
      .update(updateData)
      .eq('id', req.params.assetHandoverId)
      .select()
      .single();

    if (error) throw error;

    // If asset is handed over, update the asset assignment
    if (status === 'handed_over' && asset_id) {
      const { data: request } = await supabase
        .from('system_access_requests')
        .select('employee_id')
        .eq('id', req.params.id)
        .single();

      if (request) {
        await supabase
          .from('assets')
          .update({ assigned_to: request.employee_id })
          .eq('id', asset_id);
      }
    }

    res.json(data);
  } catch (error) {
    console.error('Error updating asset handover:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get request history
router.get('/:id/history', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('access_request_history')
      .select(`
        *,
        performed_by_user:performed_by(name, email)
      `)
      .eq('access_request_id', req.params.id)
      .order('performed_at', { ascending: false });

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error fetching request history:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
