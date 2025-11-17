// Vercel serverless function handler
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const assetRoutes = require('../src/routes/assets');
const maintenanceRoutes = require('../src/routes/maintenance');
const userRoutes = require('../src/routes/users');
const notificationRoutes = require('../src/routes/notifications');
const authRoutes = require('../src/routes/auth');
const systemAccessRoutes = require('../src/routes/system-access');
const authMiddleware = require('../src/middleware/auth');
const errorHandler = require('../src/middleware/errorHandler');

const app = express();

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  credentials: true
}));

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: 'serverless'
  });
});

// API routes
app.use('/api/auth', authRoutes);
app.use('/api/assets', authMiddleware, assetRoutes);
app.use('/api/maintenance', authMiddleware, maintenanceRoutes);
app.use('/api/users', authMiddleware, userRoutes);
app.use('/api/notifications', authMiddleware, notificationRoutes);
app.use('/api/system-access', authMiddleware, systemAccessRoutes);

// Error handling middleware
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Export for Vercel
module.exports = app;
