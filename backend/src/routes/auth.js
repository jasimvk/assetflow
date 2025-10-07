const express = require('express');
const router = express.Router();

// Login endpoint for development
router.post('/login', async (req, res) => {
  try {
    // In development mode, return a mock token
    if (process.env.NODE_ENV === 'development') {
      const mockUser = {
        id: 'dev-user-123',
        email: 'dev@example.com',
        name: 'Development User',
        role: 'admin'
      };

      res.json({
        success: true,
        user: mockUser,
        token: 'dev-token-123',
        message: 'Development login successful'
      });
    } else {
      // In production, this would handle Azure AD authentication
      res.status(501).json({ 
        error: 'Production authentication not yet implemented',
        message: 'Please configure Azure AD authentication for production use'
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
});

// Logout endpoint
router.post('/logout', async (req, res) => {
  try {
    // In a real implementation, you would invalidate the token
    res.json({
      success: true,
      message: 'Logout successful'
    });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ error: 'Logout failed' });
  }
});

// Get current user endpoint
router.get('/me', async (req, res) => {
  try {
    // For development, return mock user data
    if (process.env.NODE_ENV === 'development') {
      const mockUser = {
        id: 'dev-user-123',
        email: 'dev@example.com',
        name: 'Development User',
        role: 'admin',
        department: 'IT'
      };

      res.json({
        success: true,
        user: mockUser
      });
    } else {
      // In production, this would validate the token and return user data
      res.status(401).json({ error: 'Authentication required' });
    }
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ error: 'Failed to get user data' });
  }
});

// Verify token endpoint
router.post('/verify', async (req, res) => {
  try {
    const { token } = req.body;

    if (process.env.NODE_ENV === 'development' && token === 'dev-token-123') {
      res.json({
        valid: true,
        user: {
          id: 'dev-user-123',
          email: 'dev@example.com',
          name: 'Development User',
          role: 'admin'
        }
      });
    } else {
      res.json({ valid: false });
    }
  } catch (error) {
    console.error('Token verification error:', error);
    res.status(500).json({ error: 'Token verification failed' });
  }
});

module.exports = router;