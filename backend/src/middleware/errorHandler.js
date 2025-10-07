const logger = require('../utils/logger');

const errorHandler = (error, req, res, next) => {
  logger.error('Error occurred:', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });

  // Default error response
  let statusCode = 500;
  let message = 'Internal server error';

  // Handle specific error types
  if (error.name === 'ValidationError') {
    statusCode = 400;
    message = 'Validation error';
  } else if (error.name === 'UnauthorizedError') {
    statusCode = 401;
    message = 'Unauthorized access';
  } else if (error.name === 'ForbiddenError') {
    statusCode = 403;
    message = 'Forbidden access';
  }

  // Don't leak error details in production
  if (process.env.NODE_ENV === 'production') {
    res.status(statusCode).json({
      error: message,
      timestamp: new Date().toISOString(),
      requestId: req.id || 'unknown'
    });
  } else {
    res.status(statusCode).json({
      error: message,
      details: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      requestId: req.id || 'unknown'
    });
  }
};

module.exports = errorHandler;