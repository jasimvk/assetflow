// Mock authentication middleware for testing RBAC
// This is for development/testing only
// In production, replace with proper Azure AD authentication

const mockAuthMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        error: 'No token provided',
        message: 'Please provide a valid authentication token'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix
    
    // Mock token parsing for testing
    // In production, validate JWT from Azure AD
    // For testing, token format: "email:role:department:userId"
    // Example: "admin@assetflow.com:admin:IT:user-id-123"
    
    try {
      const [email, role, department, userId] = token.split(':');
      
      if (!email || !role || !department || !userId) {
        return res.status(401).json({ 
          error: 'Invalid token format',
          message: 'Token must be in format: email:role:department:userId'
        });
      }
      
      // Attach user to request
      req.user = {
        id: userId,
        email: email,
        role: role,
        department: department
      };
      
      next();
    } catch (parseError) {
      return res.status(401).json({ 
        error: 'Invalid token',
        message: 'Could not parse authentication token'
      });
    }
    
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(500).json({ error: 'Authentication error' });
  }
};

module.exports = mockAuthMiddleware;

/*
 * TESTING INSTRUCTIONS:
 * 
 * Use these tokens for testing with curl or Postman:
 * 
 * Admin token:
 * Bearer admin@assetflow.com:admin:IT:user-admin-001
 * 
 * Manager token:
 * Bearer it.manager@assetflow.com:manager:IT:user-mgr-001
 * 
 * User token:
 * Bearer developer1@assetflow.com:user:IT:user-dev-001
 * 
 * Example curl:
 * curl -H "Authorization: Bearer admin@assetflow.com:admin:IT:user-admin-001" \
 *   http://localhost:3001/api/assets
 * 
 * IMPORTANT: Replace this with real Azure AD validation in production!
 */
