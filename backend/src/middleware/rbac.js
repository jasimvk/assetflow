/**
 * Backend RBAC Middleware
 * Express middleware for role-based access control
 */

const {
  ROLES,
  PERMISSIONS,
  hasPermission,
  hasAnyPermission,
  canPerformAction
} = require('../../../shared/roles');

/**
 * Middleware to require specific role(s)
 * @param {...string} allowedRoles - One or more roles allowed to access the route
 * @returns {Function} Express middleware
 * 
 * @example
 * router.get('/users', requireRole(ROLES.ADMIN), getUsersHandler);
 * router.post('/assets', requireRole(ROLES.ADMIN, ROLES.MANAGER), createAssetHandler);
 */
function requireRole(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Authentication required'
      });
    }

    if (!req.user.role || !allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You do not have permission to access this resource',
        required_role: allowedRoles,
        your_role: req.user.role
      });
    }

    next();
  };
}

/**
 * Middleware to require specific permission(s)
 * @param {...string} requiredPermissions - One or more permissions required
 * @returns {Function} Express middleware
 * 
 * @example
 * router.post('/assets', requirePermission(PERMISSIONS.ASSETS.CREATE), createAssetHandler);
 * router.delete('/assets/:id', requirePermission(PERMISSIONS.ASSETS.DELETE_ALL), deleteAssetHandler);
 */
function requirePermission(...requiredPermissions) {
  return (req, res, next) => {
    if (!req.user || !req.user.role) {
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Authentication required'
      });
    }

    const hasRequiredPermission = requiredPermissions.some(permission =>
      hasPermission(req.user.role, permission)
    );

    if (!hasRequiredPermission) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You do not have permission to perform this action',
        required_permissions: requiredPermissions,
        your_role: req.user.role
      });
    }

    next();
  };
}

/**
 * Middleware to restrict data access based on role
 * Adds query filters to req.filters for use in database queries
 * @returns {Function} Express middleware
 * 
 * @example
 * router.get('/assets', authenticate, applyDataScope, getAssetsHandler);
 * // Inside handler: const assets = await getAssets(req.filters);
 */
function applyDataScope() {
  return (req, res, next) => {
    req.filters = req.filters || {};

    if (!req.user || !req.user.role) {
      return next();
    }

    switch (req.user.role) {
      case ROLES.ADMIN:
        // No filters - can see everything
        break;

      case ROLES.MANAGER:
        // Filter by department
        if (req.user.department) {
          req.filters.department = req.user.department;
        }
        break;

      case ROLES.USER:
        // Filter to only their own resources
        req.filters.user_id = req.user.id;
        // For assets, filter by assigned_to
        req.filters.assigned_to = req.user.id;
        break;

      default:
        break;
    }

    next();
  };
}

/**
 * Middleware to check resource ownership before allowing access
 * Used for update/delete operations
 * @param {Function} getResourceFn - Async function to fetch the resource
 * @param {string} permission - The permission being checked
 * @returns {Function} Express middleware
 * 
 * @example
 * router.put('/requests/:id', 
 *   checkResourceOwnership(
 *     async (req) => await getRequestById(req.params.id),
 *     PERMISSIONS.SYSTEM_ACCESS.UPDATE
 *   ),
 *   updateRequestHandler
 * );
 */
function checkResourceOwnership(getResourceFn, permission) {
  return async (req, res, next) => {
    try {
      if (!req.user) {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'Authentication required'
        });
      }

      // Fetch the resource
      const resource = await getResourceFn(req);

      if (!resource) {
        return res.status(404).json({
          error: 'Not Found',
          message: 'Resource not found'
        });
      }

      // Check if user can perform action on this resource
      if (!canPerformAction(req.user, permission, resource)) {
        return res.status(403).json({
          error: 'Forbidden',
          message: 'You do not have permission to access this resource',
          reason: req.user.role === ROLES.MANAGER ? 'Resource not in your department' : 'Resource not owned by you'
        });
      }

      // Attach resource to request for use in handler
      req.resource = resource;
      next();
    } catch (error) {
      console.error('Error checking resource ownership:', error);
      res.status(500).json({
        error: 'Internal Server Error',
        message: 'Error checking permissions'
      });
    }
  };
}

/**
 * Middleware to log access attempts for auditing
 * @returns {Function} Express middleware
 */
function logAccess() {
  return (req, res, next) => {
    const timestamp = new Date().toISOString();
    const user = req.user ? `${req.user.name} (${req.user.role})` : 'Anonymous';
    const action = `${req.method} ${req.path}`;

    console.log(`[ACCESS] ${timestamp} | User: ${user} | Action: ${action}`);

    // You can also log to database here
    // await logAccessAttempt({
    //   user_id: req.user?.id,
    //   action: action,
    //   timestamp: timestamp,
    //   ip: req.ip
    // });

    next();
  };
}

/**
 * Helper to get user role info
 * @param {object} req - Express request object
 * @returns {object} User role information
 */
function getUserRoleInfo(req) {
  if (!req.user) {
    return { authenticated: false };
  }

  return {
    authenticated: true,
    role: req.user.role,
    department: req.user.department,
    user_id: req.user.id,
    is_admin: req.user.role === ROLES.ADMIN,
    is_manager: req.user.role === ROLES.MANAGER,
    is_user: req.user.role === ROLES.USER
  };
}

module.exports = {
  requireRole,
  requirePermission,
  applyDataScope,
  checkResourceOwnership,
  logAccess,
  getUserRoleInfo
};
