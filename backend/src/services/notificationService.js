const { getGraphClient } = require('../config/azure');
const logger = require('../utils/logger');

const sendMaintenanceNotification = async (userEmail, maintenanceDetails) => {
  try {
    const graphClient = await getGraphClient();
    
    const message = {
      subject: `Maintenance Scheduled: ${maintenanceDetails.assetName}`,
      body: {
        contentType: 'HTML',
        content: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #2563eb;">Asset Maintenance Notification</h2>
            <p>Hello,</p>
            <p>A maintenance activity has been scheduled for an asset assigned to you:</p>
            
            <div style="background-color: #f3f4f6; padding: 20px; border-radius: 8px; margin: 20px 0;">
              <h3 style="margin-top: 0; color: #374151;">Maintenance Details</h3>
              <p><strong>Asset:</strong> ${maintenanceDetails.assetName}</p>
              <p><strong>Maintenance Type:</strong> ${maintenanceDetails.maintenanceType}</p>
              <p><strong>Scheduled Date:</strong> ${new Date(maintenanceDetails.scheduledDate).toLocaleDateString()}</p>
            </div>
            
            <p>Please ensure the asset is available for maintenance on the scheduled date.</p>
            <p>If you have any questions or need to reschedule, please contact the facilities team.</p>
            
            <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;">
            <p style="color: #6b7280; font-size: 14px;">
              This is an automated message from AssetFlow. Please do not reply to this email.
            </p>
          </div>
        `
      },
      toRecipients: [{
        emailAddress: {
          address: userEmail
        }
      }]
    };

    await graphClient.me.sendMail({ message });
    logger.info(`Maintenance notification sent to ${userEmail}`);
  } catch (error) {
    logger.error('Error sending maintenance notification:', error);
    throw error;
  }
};

const sendMaintenanceReminder = async (userEmail, maintenanceDetails) => {
  try {
    const graphClient = await getGraphClient();
    
    const message = {
      subject: `Maintenance Reminder: ${maintenanceDetails.assetName}`,
      body: {
        contentType: 'HTML',
        content: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #dc2626;">Maintenance Reminder</h2>
            <p>Hello,</p>
            <p>This is a reminder that maintenance is scheduled for tomorrow:</p>
            
            <div style="background-color: #fef2f2; border-left: 4px solid #dc2626; padding: 20px; margin: 20px 0;">
              <h3 style="margin-top: 0; color: #374151;">Maintenance Details</h3>
              <p><strong>Asset:</strong> ${maintenanceDetails.assetName}</p>
              <p><strong>Maintenance Type:</strong> ${maintenanceDetails.maintenanceType}</p>
              <p><strong>Scheduled Date:</strong> ${new Date(maintenanceDetails.scheduledDate).toLocaleDateString()}</p>
            </div>
            
            <p>Please ensure the asset is ready and available for maintenance.</p>
            
            <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;">
            <p style="color: #6b7280; font-size: 14px;">
              This is an automated reminder from AssetFlow. Please do not reply to this email.
            </p>
          </div>
        `
      },
      toRecipients: [{
        emailAddress: {
          address: userEmail
        }
      }]
    };

    await graphClient.me.sendMail({ message });
    logger.info(`Maintenance reminder sent to ${userEmail}`);
  } catch (error) {
    logger.error('Error sending maintenance reminder:', error);
    throw error;
  }
};

module.exports = {
  sendMaintenanceNotification,
  sendMaintenanceReminder
};