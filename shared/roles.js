/**
 * Role-Based Access Control (RBAC) Configuration
 * AssetFlow Application
 * 
 * This file defines all role capabilities and permissions.
 * Import this in both frontend and backend for consistent role checking.
 */

// ============================================
// ROLE DEFINITIONS
// ============================================

const ROLES = {
  ADMIN: 'admin',
  MANAGER: 'manager',
  USER: 'user'
};

// ============================================
// PERMISSIONS BY RESOURCE
// ============================================

const PERMISSIONS = {
  // Asset Permissions
  ASSETS: {
    CREATE: 'assets:create',
    READ: 'assets:read',
    READ_ALL: 'assets:read:all',
    READ_DEPARTMENT: 'assets:read:department',
    READ_OWN: 'assets:read:own',
    UPDATE: 'assets:update',
    UPDATE_ALL: 'assets:update:all',
    UPDATE_DEPARTMENT: 'assets:update:department',
    DELETE: 'assets:delete',
    DELETE_ALL: 'assets:delete:all',
    IMPORT: 'assets:import',
    EXPORT: 'assets:export',
    BULK_OPERATIONS: 'assets:bulk'
  },
  
  // System Access Request Permissions
  SYSTEM_ACCESS: {
    CREATE: 'system_access:create',
    CREATE_OWN: 'system_access:create:own',
    CREATE_TEAM: 'system_access:create:team',
    READ: 'system_access:read',
    READ_ALL: 'system_access:read:all',
    READ_DEPARTMENT: 'system_access:read:department',
    READ_OWN: 'system_access:read:own',
    UPDATE: 'system_access:update',
    APPROVE: 'system_access:approve',
    REJECT: 'system_access:reject',
    DELETE: 'system_access:delete',
    VIEW_HISTORY: 'system_access:history'
  },
  
  // User Management Permissions
  USERS: {
    CREATE: 'users:create',
    READ: 'users:read',
    READ_ALL: 'users:read:all',
    READ_DEPARTMENT: 'users:read:department',
    UPDATE: 'users:update',
    UPDATE_ALL: 'users:update:all',
    UPDATE_OWN: 'users:update:own',
    DELETE: 'users:delete',
    ASSIGN_ROLE: 'users:assign_role',
    DEACTIVATE: 'users:deactivate'
  },
  
  // Maintenance Permissions
  MAINTENANCE: {
    CREATE: 'maintenance:create',
    CREATE_OWN: 'maintenance:create:own',
    READ: 'maintenance:read',
    READ_ALL: 'maintenance:read:all',
    READ_DEPARTMENT: 'maintenance:read:department',
    READ_OWN: 'maintenance:read:own',
    UPDATE: 'maintenance:update',
    APPROVE: 'maintenance:approve',
    DELETE: 'maintenance:delete'
  },
  
  // Report Permissions
  REPORTS: {
    VIEW: 'reports:view',
    VIEW_ALL: 'reports:view:all',
    VIEW_DEPARTMENT: 'reports:view:department',
    VIEW_OWN: 'reports:view:own',
    EXPORT: 'reports:export'
  },
  
  // Settings Permissions
  SETTINGS: {
    VIEW: 'settings:view',
    UPDATE: 'settings:update',
    MANAGE_INTEGRATIONS: 'settings:integrations'
  },
  
  // Notification Permissions
  NOTIFICATIONS: {
    VIEW_OWN: 'notifications:view:own',
    VIEW_ALL: 'notifications:view:all',
    MARK_READ: 'notifications:mark_read'
  },
  
  // Category & Location Permissions
  CATEGORIES: {
    CREATE: 'categories:create',
    READ: 'categories:read',
    UPDATE: 'categories:update',
    DELETE: 'categories:delete'
  },
  
  LOCATIONS: {
    CREATE: 'locations:create',
    READ: 'locations:read',
    UPDATE: 'locations:update',
    DELETE: 'locations:delete'
  }
};

// ============================================
// ROLE CAPABILITIES
// ============================================

const ROLE_PERMISSIONS = {
  [ROLES.ADMIN]: [
    // Full asset management
    PERMISSIONS.ASSETS.CREATE,
    PERMISSIONS.ASSETS.READ,
    PERMISSIONS.ASSETS.READ_ALL,
    PERMISSIONS.ASSETS.UPDATE,
    PERMISSIONS.ASSETS.UPDATE_ALL,
    PERMISSIONS.ASSETS.DELETE,
    PERMISSIONS.ASSETS.DELETE_ALL,
    PERMISSIONS.ASSETS.IMPORT,
    PERMISSIONS.ASSETS.EXPORT,
    PERMISSIONS.ASSETS.BULK_OPERATIONS,
    
    // Full system access management
    PERMISSIONS.SYSTEM_ACCESS.CREATE,
    PERMISSIONS.SYSTEM_ACCESS.READ,
    PERMISSIONS.SYSTEM_ACCESS.READ_ALL,
    PERMISSIONS.SYSTEM_ACCESS.UPDATE,
    PERMISSIONS.SYSTEM_ACCESS.APPROVE,
    PERMISSIONS.SYSTEM_ACCESS.REJECT,
    PERMISSIONS.SYSTEM_ACCESS.DELETE,
    PERMISSIONS.SYSTEM_ACCESS.VIEW_HISTORY,
    
    // Full user management
    PERMISSIONS.USERS.CREATE,
    PERMISSIONS.USERS.READ,
    PERMISSIONS.USERS.READ_ALL,
    PERMISSIONS.USERS.UPDATE,
    PERMISSIONS.USERS.UPDATE_ALL,
    PERMISSIONS.USERS.DELETE,
    PERMISSIONS.USERS.ASSIGN_ROLE,
    PERMISSIONS.USERS.DEACTIVATE,
    
    // Full maintenance management
    PERMISSIONS.MAINTENANCE.CREATE,
    PERMISSIONS.MAINTENANCE.READ,
    PERMISSIONS.MAINTENANCE.READ_ALL,
    PERMISSIONS.MAINTENANCE.UPDATE,
    PERMISSIONS.MAINTENANCE.APPROVE,
    PERMISSIONS.MAINTENANCE.DELETE,
    
    // All reports
    PERMISSIONS.REPORTS.VIEW,
    PERMISSIONS.REPORTS.VIEW_ALL,
    PERMISSIONS.REPORTS.EXPORT,
    
    // System settings
    PERMISSIONS.SETTINGS.VIEW,
    PERMISSIONS.SETTINGS.UPDATE,
    PERMISSIONS.SETTINGS.MANAGE_INTEGRATIONS,
    
    // All notifications
    PERMISSIONS.NOTIFICATIONS.VIEW_OWN,
    PERMISSIONS.NOTIFICATIONS.VIEW_ALL,
    PERMISSIONS.NOTIFICATIONS.MARK_READ,
    
    // Category and location management
    PERMISSIONS.CATEGORIES.CREATE,
    PERMISSIONS.CATEGORIES.READ,
    PERMISSIONS.CATEGORIES.UPDATE,
    PERMISSIONS.CATEGORIES.DELETE,
    PERMISSIONS.LOCATIONS.CREATE,
    PERMISSIONS.LOCATIONS.READ,
    PERMISSIONS.LOCATIONS.UPDATE,
    PERMISSIONS.LOCATIONS.DELETE
  ],
  
  [ROLES.MANAGER]: [
    // Department asset viewing, request new
    PERMISSIONS.ASSETS.READ,
    PERMISSIONS.ASSETS.READ_DEPARTMENT,
    PERMISSIONS.ASSETS.EXPORT, // Export department assets
    
    // Create system access for team, view department requests
    PERMISSIONS.SYSTEM_ACCESS.CREATE,
    PERMISSIONS.SYSTEM_ACCESS.CREATE_TEAM,
    PERMISSIONS.SYSTEM_ACCESS.READ,
    PERMISSIONS.SYSTEM_ACCESS.READ_DEPARTMENT,
    PERMISSIONS.SYSTEM_ACCESS.VIEW_HISTORY,
    
    // View department users
    PERMISSIONS.USERS.READ,
    PERMISSIONS.USERS.READ_DEPARTMENT,
    PERMISSIONS.USERS.UPDATE_OWN,
    
    // Approve department maintenance
    PERMISSIONS.MAINTENANCE.CREATE,
    PERMISSIONS.MAINTENANCE.READ,
    PERMISSIONS.MAINTENANCE.READ_DEPARTMENT,
    PERMISSIONS.MAINTENANCE.APPROVE, // Can approve maintenance for department
    
    // Department reports
    PERMISSIONS.REPORTS.VIEW,
    PERMISSIONS.REPORTS.VIEW_DEPARTMENT,
    PERMISSIONS.REPORTS.EXPORT,
    
    // Own notifications
    PERMISSIONS.NOTIFICATIONS.VIEW_OWN,
    PERMISSIONS.NOTIFICATIONS.MARK_READ,
    
    // Read-only categories and locations
    PERMISSIONS.CATEGORIES.READ,
    PERMISSIONS.LOCATIONS.READ
  ],
  
  [ROLES.USER]: [
    // View only assigned assets
    PERMISSIONS.ASSETS.READ,
    PERMISSIONS.ASSETS.READ_OWN,
    
    // Submit own system access requests
    PERMISSIONS.SYSTEM_ACCESS.CREATE,
    PERMISSIONS.SYSTEM_ACCESS.CREATE_OWN,
    PERMISSIONS.SYSTEM_ACCESS.READ,
    PERMISSIONS.SYSTEM_ACCESS.READ_OWN,
    
    // Update own profile
    PERMISSIONS.USERS.READ,
    PERMISSIONS.USERS.UPDATE_OWN,
    
    // Submit and view own maintenance requests
    PERMISSIONS.MAINTENANCE.CREATE,
    PERMISSIONS.MAINTENANCE.CREATE_OWN,
    PERMISSIONS.MAINTENANCE.READ,
    PERMISSIONS.MAINTENANCE.READ_OWN,
    
    // View own summary reports
    PERMISSIONS.REPORTS.VIEW,
    PERMISSIONS.REPORTS.VIEW_OWN,
    
    // Own notifications
    PERMISSIONS.NOTIFICATIONS.VIEW_OWN,
    PERMISSIONS.NOTIFICATIONS.MARK_READ,
    
    // Read-only categories and locations
    PERMISSIONS.CATEGORIES.READ,
    PERMISSIONS.LOCATIONS.READ
  ]
};

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Check if a role has a specific permission
 * @param {string} role - The user role (admin, manager, user)
 * @param {string} permission - The permission to check
 * @returns {boolean}
 */
function hasPermission(role, permission) {
  if (!role || !permission) return false;
  const permissions = ROLE_PERMISSIONS[role] || [];
  return permissions.includes(permission);
}

/**
 * Check if a role has any of the specified permissions
 * @param {string} role - The user role
 * @param {string[]} permissions - Array of permissions to check
 * @returns {boolean}
 */
function hasAnyPermission(role, permissions) {
  if (!role || !permissions || permissions.length === 0) return false;
  return permissions.some(permission => hasPermission(role, permission));
}

/**
 * Check if a role has all of the specified permissions
 * @param {string} role - The user role
 * @param {string[]} permissions - Array of permissions to check
 * @returns {boolean}
 */
function hasAllPermissions(role, permissions) {
  if (!role || !permissions || permissions.length === 0) return false;
  return permissions.every(permission => hasPermission(role, permission));
}

/**
 * Get all permissions for a role
 * @param {string} role - The user role
 * @returns {string[]}
 */
function getRolePermissions(role) {
  return ROLE_PERMISSIONS[role] || [];
}

/**
 * Check if user can perform action based on role and resource ownership
 * @param {object} user - User object with role, id, department
 * @param {string} permission - The permission to check
 * @param {object} resource - The resource being accessed (optional)
 * @returns {boolean}
 */
function canPerformAction(user, permission, resource = null) {
  if (!user || !user.role) return false;
  
  // Check basic permission
  if (!hasPermission(user.role, permission)) return false;
  
  // Additional checks based on resource
  if (resource) {
    // Department-scoped permissions
    if (permission.includes(':department')) {
      if (user.role === ROLES.MANAGER) {
        return resource.department === user.department;
      }
    }
    
    // Own resource permissions
    if (permission.includes(':own')) {
      if (user.role === ROLES.USER) {
        return resource.user_id === user.id || 
               resource.assigned_to === user.id ||
               resource.requester_id === user.id;
      }
    }
  }
  
  return true;
}

// ============================================
// PAGE ACCESS CONTROL
// ============================================

const PAGE_ACCESS = {
  '/': [ROLES.ADMIN, ROLES.MANAGER, ROLES.USER], // Dashboard
  '/assets': [ROLES.ADMIN, ROLES.MANAGER, ROLES.USER],
  '/add-asset': [ROLES.ADMIN],
  '/asset-import': [ROLES.ADMIN],
  '/system-access': [ROLES.ADMIN, ROLES.MANAGER, ROLES.USER],
  '/users': [ROLES.ADMIN],
  '/reports': [ROLES.ADMIN, ROLES.MANAGER, ROLES.USER],
  '/settings': [ROLES.ADMIN],
  '/maintenance': [ROLES.ADMIN, ROLES.MANAGER, ROLES.USER],
  '/master-data': [ROLES.ADMIN],
  '/forms': [ROLES.ADMIN, ROLES.MANAGER],
  '/approvals': [ROLES.ADMIN, ROLES.MANAGER]
};

/**
 * Check if a role can access a specific page
 * @param {string} role - User role
 * @param {string} page - Page path
 * @returns {boolean}
 */
function canAccessPage(role, page) {
  const allowedRoles = PAGE_ACCESS[page];
  if (!allowedRoles) return true; // Allow access if not explicitly restricted
  return allowedRoles.includes(role);
}

// ============================================
// EXPORTS
// ============================================

module.exports = {
  ROLES,
  PERMISSIONS,
  ROLE_PERMISSIONS,
  PAGE_ACCESS,
  hasPermission,
  hasAnyPermission,
  hasAllPermissions,
  getRolePermissions,
  canPerformAction,
  canAccessPage
};
