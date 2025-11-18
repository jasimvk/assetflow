/**
 * Frontend RBAC Utilities
 * React hooks and utilities for role-based access control
 */

import { useAuth } from '../context/AuthContext';
import { useRouter } from 'next/router';
import { useEffect, ReactNode } from 'react';

// Import shared role constants
const {
  ROLES,
  PERMISSIONS,
  hasPermission,
  hasAnyPermission,
  hasAllPermissions,
  canAccessPage
} = require('../../shared/roles');

interface RoleInfo {
  role: string | null;
  department: string | null;
  user: any;
  isAdmin: boolean;
  isManager: boolean;
  isUser: boolean;
  hasPermission: (permission: string) => boolean;
  hasAnyPermission: (permissions: string[]) => boolean;
  hasAllPermissions: (permissions: string[]) => boolean;
  canAccessPage: (page: string) => boolean;
}

interface DataFilters {
  department?: string;
  user_id?: string;
  assigned_to?: string;
}

/**
 * Hook to get current user's role information
 * @returns {RoleInfo} Role information and helper functions
 * 
 * @example
 * const { role, isAdmin, isManager, isUser, hasPermission } = useRole();
 * if (isAdmin) { // Show admin UI }
 */
export function useRole(): RoleInfo {
  const { user } = useAuth();

  const role = (user as any)?.role || null;
  const department = (user as any)?.department || null;

  return {
    role,
    department,
    user,
    isAdmin: role === ROLES.ADMIN,
    isManager: role === ROLES.MANAGER,
    isUser: role === ROLES.USER,
    hasPermission: (permission: string) => hasPermission(role, permission),
    hasAnyPermission: (permissions: string[]) => hasAnyPermission(role, permissions),
    hasAllPermissions: (permissions: string[]) => hasAllPermissions(role, permissions),
    canAccessPage: (page: string) => canAccessPage(role, page)
  };
}

/**
 * Hook to protect routes based on role
 * Redirects to home if user doesn't have access
 * @param {string|string[]} allowedRoles - Role(s) allowed to access the page
 * 
 * @example
 * // In admin-only page
 * useRoleProtection(ROLES.ADMIN);
 * 
 * // In page accessible by multiple roles
 * useRoleProtection([ROLES.ADMIN, ROLES.MANAGER]);
 */
export function useRoleProtection(allowedRoles) {
  const { user, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && user) {
      const roles = Array.isArray(allowedRoles) ? allowedRoles : [allowedRoles];
      
      if (!roles.includes(user.role)) {
        console.warn(`Access denied: User role '${user.role}' not in allowed roles:`, roles);
        router.replace('/');
      }
    }
  }, [user, loading, allowedRoles, router]);
}

/**
 * Hook to get filtered data scope based on user role
 * @returns {DataFilters} Filters to apply to API calls
 * 
 * @example
 * const filters = useDataScope();
 * const assets = await assetsAPI.getAll(filters);
 */
export function useDataScope(): DataFilters {
  const { user } = useAuth();

  if (!user || !(user as any).role) {
    return {};
  }

  const filters: DataFilters = {};
  const userRole = (user as any).role;
  const userDept = (user as any).department;

  switch (userRole) {
    case ROLES.ADMIN:
      // No filters - admin sees everything
      break;

    case ROLES.MANAGER:
      // Filter by department
      if (userDept) {
        filters.department = userDept;
      }
      break;

    case ROLES.USER:
      // Filter to only user's own resources
      filters.user_id = user.id;
      filters.assigned_to = user.id;
      break;

    default:
      break;
  }

  return filters;
}

/**
 * Component to conditionally render based on permissions
 * @param {object} props - Component props
 * @param {string|string[]} props.permission - Required permission(s)
 * @param {string|string[]} props.role - Required role(s)
 * @param {React.ReactNode} props.children - Content to render if authorized
 * @param {React.ReactNode} props.fallback - Content to render if not authorized
 * 
 * @example
 * <RoleGuard permission={PERMISSIONS.ASSETS.CREATE}>
 *   <button>Create Asset</button>
 * </RoleGuard>
 * 
 * <RoleGuard role={ROLES.ADMIN} fallback={<p>Admin only</p>}>
 *   <AdminPanel />
 * </RoleGuard>
 */
interface RoleGuardProps {
  permission?: string | string[];
  role?: string | string[];
  children: ReactNode;
  fallback?: ReactNode;
}

export function RoleGuard({ permission, role, children, fallback = null }: RoleGuardProps) {
  const { role: userRole, hasPermission: checkPermission } = useRole();

  let isAuthorized = true;

  // Check role if specified
  if (role) {
    const roles = Array.isArray(role) ? role : [role];
    isAuthorized = roles.includes(userRole || '');
  }

  // Check permission if specified
  if (isAuthorized && permission) {
    const permissions = Array.isArray(permission) ? permission : [permission];
    isAuthorized = permissions.some(p => checkPermission(p));
  }

  return isAuthorized ? (<>{children}</>) : (<>{fallback}</>);
}

/**
 * Higher-order component to protect page components
 * @param {React.Component} Component - Page component to protect
 * @param {string|string[]} allowedRoles - Roles allowed to access
 * @returns {React.Component} Protected component
 * 
 * @example
 * const AdminUsersPage = withRoleProtection(UsersPage, ROLES.ADMIN);
 * export default AdminUsersPage;
 */
export function withRoleProtection(Component: any, allowedRoles: string | string[]) {
  return function ProtectedComponent(props: any) {
    useRoleProtection(allowedRoles);
    return (<Component {...props} />);
  };
}

/**
 * Utility to check if user owns a resource
 * @param {object} user - Current user object
 * @param {object} resource - Resource to check ownership
 * @returns {boolean}
 * 
 * @example
 * const canEdit = ownsResource(user, asset);
 */
export function ownsResource(user, resource) {
  if (!user || !resource) return false;

  return (
    resource.user_id === user.id ||
    resource.assigned_to === user.id ||
    resource.requester_id === user.id ||
    resource.created_by === user.id
  );
}

/**
 * Utility to check if resource is in user's department
 * @param {object} user - Current user object
 * @param {object} resource - Resource to check
 * @returns {boolean}
 */
export function inUserDepartment(user, resource) {
  if (!user || !resource) return false;
  return resource.department === user.department;
}

/**
 * Utility to get user-friendly role name
 * @param {string} role - Role constant
 * @returns {string} Display name
 */
export function getRoleDisplayName(role) {
  const roleNames = {
    [ROLES.ADMIN]: 'Administrator',
    [ROLES.MANAGER]: 'Manager',
    [ROLES.USER]: 'User'
  };
  return roleNames[role] || 'Unknown';
}

/**
 * Utility to get role badge color
 * @param {string} role - Role constant
 * @returns {string} Tailwind color classes
 */
export function getRoleBadgeColor(role) {
  const colors = {
    [ROLES.ADMIN]: 'bg-purple-100 text-purple-700 border-purple-200',
    [ROLES.MANAGER]: 'bg-blue-100 text-blue-700 border-blue-200',
    [ROLES.USER]: 'bg-gray-100 text-gray-700 border-gray-200'
  };
  return colors[role] || 'bg-gray-100 text-gray-700 border-gray-200';
}

// Re-export constants for convenience
export { ROLES, PERMISSIONS };
