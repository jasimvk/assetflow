const authMiddleware = async (req, res, next) => {
  try {
    // For development mode, bypass authentication
    if (process.env.NODE_ENV === 'development') {
      req.user = { 
        id: 'dev-user-123', 
        email: 'dev@example.com', 
        role: 'admin',
        name: 'Development User'
      };
      return next();
    }

    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix
    
    // In production, validate the JWT token from Azure AD
    // This is a simplified version - in production you'd want to validate the JWT signature
    try {
      // You would typically validate the JWT token here with Azure AD
      // For now, we'll accept any token and create a mock user
      req.user = { 
        id: 'user-id-456', 
        email: 'user@company.com',
        role: 'manager',
        name: 'Production User'
      };
      next();
    } catch (tokenError) {
      return res.status(401).json({ error: 'Invalid token' });
    }
    
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(500).json({ error: 'Authentication error' });
  }
};

module.exports = authMiddleware;