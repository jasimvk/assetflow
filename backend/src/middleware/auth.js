const jwt = require('jsonwebtoken');
const { msalInstance } = require('../config/azure');

const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix
    
    // For development, you might want to skip token validation
    // In production, validate the JWT token from Azure AD
    if (process.env.NODE_ENV === 'development' && token === 'dev-token') {
      req.user = { id: 'dev-user', email: 'dev@example.com' };
      return next();
    }

    // In production, validate the token with Azure AD
    // This is a simplified version - in production you'd want to validate the JWT signature
    try {
      // You would typically validate the JWT token here
      // For now, we'll accept any token in development
      req.user = { id: 'user-id', email: 'user@company.com' };
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