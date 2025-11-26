const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const assetRoutes = require('./routes/assets');
const maintenanceRoutes = require('./routes/maintenance');
const userRoutes = require('./routes/users');
const notificationRoutes = require('./routes/notifications');
const authRoutes = require('./routes/auth');
const systemAccessRoutes = require('./routes/system-access');
const mockAuth = require('./middleware/mockAuth');
const errorHandler = require('./middleware/errorHandler');
const logger = require('./utils/logger');

const app = express();
const PORT = process.env.PORT || 3001;

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.'
});
app.use(limiter);

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Logging middleware
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path} - ${req.ip}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0'
  });
});

// API routes
app.use('/api/auth', authRoutes); // Auth routes don't need auth middleware
app.use('/api/assets', mockAuth, assetRoutes);
app.use('/api/maintenance', mockAuth, maintenanceRoutes);
app.use('/api/users', mockAuth, userRoutes);
app.use('/api/notifications', mockAuth, notificationRoutes);
app.use('/api/system-access', mockAuth, systemAccessRoutes);

// Error handling middleware
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, () => {
  logger.info(`AssetFlow API server running on port ${PORT}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
});