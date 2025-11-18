const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        error: 'No token provided',
        message: 'Please provide a valid authentication token'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix
    
    // TODO: Implement real JWT token validation
    // Validate the JWT token from Azure AD (Entra ID)
    // Verify signature, expiration, and claims
    // Extract user information from validated token
    
    // For now, reject all requests until proper auth is configured
    return res.status(401).json({ 
      error: 'Authentication not configured',
      message: 'Please configure Azure AD (Entra ID) authentication. See SETUP_CREDENTIALS.md for instructions.'
    });
    
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(500).json({ error: 'Authentication error' });
  }
};

module.exports = authMiddleware;