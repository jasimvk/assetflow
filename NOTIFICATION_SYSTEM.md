# AssetFlow - Notification System Documentation

## 📋 Overview

The notification system in AssetFlow provides real-time alerts and updates to users about system access requests, asset assignments, maintenance schedules, and approvals.

---

## 🏗️ Architecture

### Components

1. **Database Storage** (Supabase)
   - Notifications table
   - Real-time subscriptions

2. **Backend API** (Express.js)
   - Notification routes
   - Notification service
   - Email integration (Microsoft Graph API)

3. **Frontend** (Next.js/React)
   - Notification bell icon
   - Notification dropdown
   - Toast notifications
   - Real-time updates

---

## 🗄️ Database Schema

### Notifications Table

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50) DEFAULT 'info', -- info, warning, error, success
  read BOOLEAN DEFAULT FALSE,
  related_type VARCHAR(50), -- 'access_request', 'asset', 'maintenance', 'approval'
  related_id UUID, -- ID of related entity
  action_url TEXT, -- Link to related page
  metadata JSONB, -- Additional data
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX idx_notifications_type ON notifications(type);
```

### Row Level Security (RLS)

```sql
-- Enable RLS
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users can only see their own notifications
CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

-- System can insert notifications
CREATE POLICY "System can insert notifications"
  ON notifications FOR INSERT
  WITH CHECK (true);
```

---

## 🔧 Backend Implementation

### 1. Notification Routes (`/backend/src/routes/notifications.js`)

#### **GET /api/notifications** - Get User Notifications
Fetches paginated notifications for the authenticated user.

**Query Parameters:**
- `page` (default: 1) - Page number
- `limit` (default: 10) - Items per page
- `unread_only` (boolean) - Filter unread only

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "title": "Access Request Approved",
      "message": "Your access to Microsoft 365 has been approved",
      "type": "success",
      "read": false,
      "related_type": "access_request",
      "related_id": "uuid",
      "action_url": "/system-access",
      "metadata": { "system_name": "Microsoft 365" },
      "created_at": "2025-11-18T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 25,
    "totalPages": 3
  }
}
```

---

#### **PUT /api/notifications/:id/read** - Mark as Read
Marks a single notification as read.

**Response:**
```json
{
  "id": "uuid",
  "read": true,
  "updated_at": "2025-11-18T10:35:00Z"
}
```

---

#### **PUT /api/notifications/mark-all-read** - Mark All as Read
Marks all unread notifications as read.

**Response:**
```json
{
  "message": "All notifications marked as read",
  "updated_count": 5
}
```

---

#### **GET /api/notifications/stats** - Get Statistics
Returns notification statistics for the user.

**Response:**
```json
{
  "total": 25,
  "unread": 5,
  "read": 20,
  "byType": {
    "info": 10,
    "warning": 3,
    "error": 2,
    "success": 10
  }
}
```

---

#### **POST /api/notifications** - Create Notification (Admin)
Creates a new notification (admin only).

**Request Body:**
```json
{
  "user_id": "uuid",
  "title": "New System Available",
  "message": "Microsoft Teams is now available for access requests",
  "type": "info",
  "related_type": "system",
  "related_id": "uuid",
  "action_url": "/system-access"
}
```

---

### 2. Notification Service (`/backend/src/services/notificationService.js`)

#### Email Notifications via Microsoft Graph API

**Configuration Required:**
```env
AZURE_CLIENT_ID=your_client_id
AZURE_TENANT_ID=your_tenant_id
AZURE_CLIENT_SECRET=your_client_secret
```

#### **sendMaintenanceNotification(userEmail, maintenanceDetails)**

Sends email notification for scheduled maintenance.

```javascript
const notificationService = require('./services/notificationService');

await notificationService.sendMaintenanceNotification(
  'user@example.com',
  {
    assetName: 'Dell Latitude 7420',
    maintenanceType: 'Hardware Upgrade',
    scheduledDate: '2025-11-20T10:00:00Z'
  }
);
```

**Email Template:**
- Subject: "Maintenance Scheduled: [Asset Name]"
- HTML formatted email with maintenance details
- Professional styling with company branding

---

#### **sendMaintenanceReminder(userEmail, maintenanceDetails)**

Sends reminder email 24 hours before maintenance.

```javascript
await notificationService.sendMaintenanceReminder(
  'user@example.com',
  {
    assetName: 'Dell Latitude 7420',
    maintenanceType: 'Hardware Upgrade',
    scheduledDate: '2025-11-20T10:00:00Z'
  }
);
```

---

### 3. Creating Notifications Programmatically

#### Helper Function (Create in `/backend/src/utils/notifications.js`):

```javascript
const supabase = require('../config/database');

/**
 * Create a notification for a user
 */
async function createNotification({
  userId,
  title,
  message,
  type = 'info',
  relatedType = null,
  relatedId = null,
  actionUrl = null,
  metadata = {}
}) {
  try {
    const { data, error } = await supabase
      .from('notifications')
      .insert([{
        user_id: userId,
        title,
        message,
        type,
        related_type: relatedType,
        related_id: relatedId,
        action_url: actionUrl,
        metadata,
        created_at: new Date().toISOString()
      }])
      .select()
      .single();

    if (error) throw error;
    return data;
  } catch (error) {
    console.error('Error creating notification:', error);
    throw error;
  }
}

/**
 * Notify user about access request status
 */
async function notifyAccessRequestStatus(request, status) {
  const titles = {
    approved: '✅ Access Request Approved',
    rejected: '❌ Access Request Rejected',
    pending: '⏳ Access Request Submitted'
  };

  const messages = {
    approved: `Your access to ${request.system_name} has been approved. You can now start using the system.`,
    rejected: `Your access request to ${request.system_name} has been rejected. ${request.rejection_reason || 'Please contact your manager for more details.'}`,
    pending: `Your access request to ${request.system_name} has been submitted and is pending approval.`
  };

  return createNotification({
    userId: request.user_id,
    title: titles[status],
    message: messages[status],
    type: status === 'approved' ? 'success' : status === 'rejected' ? 'error' : 'info',
    relatedType: 'access_request',
    relatedId: request.id,
    actionUrl: '/access-requests',
    metadata: {
      system_name: request.system_name,
      request_id: request.id
    }
  });
}

/**
 * Notify approver about new access request
 */
async function notifyApprover(request, approverId) {
  return createNotification({
    userId: approverId,
    title: '📝 New Access Request',
    message: `${request.user_name} has requested access to ${request.system_name}. Please review and approve.`,
    type: 'warning',
    relatedType: 'access_request',
    relatedId: request.id,
    actionUrl: `/access-requests/${request.id}`,
    metadata: {
      system_name: request.system_name,
      requester: request.user_name
    }
  });
}

/**
 * Notify user about asset assignment
 */
async function notifyAssetAssignment(assignment) {
  return createNotification({
    userId: assignment.user_id,
    title: '💻 New Asset Assigned',
    message: `${assignment.asset_name} has been assigned to you. Please acknowledge receipt.`,
    type: 'info',
    relatedType: 'asset',
    relatedId: assignment.asset_id,
    actionUrl: '/assets',
    metadata: {
      asset_name: assignment.asset_name,
      asset_tag: assignment.asset_tag
    }
  });
}

/**
 * Notify user about maintenance schedule
 */
async function notifyMaintenance(maintenance) {
  return createNotification({
    userId: maintenance.user_id,
    title: '🔧 Maintenance Scheduled',
    message: `Maintenance for ${maintenance.asset_name} is scheduled on ${new Date(maintenance.scheduled_date).toLocaleDateString()}.`,
    type: 'warning',
    relatedType: 'maintenance',
    relatedId: maintenance.id,
    actionUrl: '/maintenance',
    metadata: {
      asset_name: maintenance.asset_name,
      scheduled_date: maintenance.scheduled_date
    }
  });
}

/**
 * Notify about license expiration
 */
async function notifyLicenseExpiring(license, daysRemaining) {
  // Notify all admins
  const { data: admins } = await supabase
    .from('users')
    .select('id')
    .eq('role', 'admin');

  const notifications = admins.map(admin =>
    createNotification({
      userId: admin.id,
      title: '⚠️ License Expiring Soon',
      message: `${license.system_name} license expires in ${daysRemaining} days. Please renew to avoid service disruption.`,
      type: 'warning',
      relatedType: 'license',
      relatedId: license.id,
      actionUrl: '/system-access',
      metadata: {
        system_name: license.system_name,
        expiry_date: license.expiry_date,
        days_remaining: daysRemaining
      }
    })
  );

  return Promise.all(notifications);
}

module.exports = {
  createNotification,
  notifyAccessRequestStatus,
  notifyApprover,
  notifyAssetAssignment,
  notifyMaintenance,
  notifyLicenseExpiring
};
```

---

## 🎨 Frontend Implementation

### 1. Notification Bell Component

Create `/frontend/components/NotificationBell.tsx`:

```typescript
import { useState, useEffect } from 'react';
import { Bell } from 'lucide-react';
import { supabase } from '@/utils/supabase';

interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'info' | 'warning' | 'error' | 'success';
  read: boolean;
  action_url: string;
  created_at: string;
}

export default function NotificationBell() {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [showDropdown, setShowDropdown] = useState(false);

  useEffect(() => {
    fetchNotifications();
    subscribeToNotifications();
  }, []);

  const fetchNotifications = async () => {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(10);

    if (!error && data) {
      setNotifications(data);
      setUnreadCount(data.filter(n => !n.read).length);
    }
  };

  const subscribeToNotifications = () => {
    const channel = supabase
      .channel('notifications')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications'
        },
        (payload) => {
          setNotifications(prev => [payload.new as Notification, ...prev]);
          setUnreadCount(prev => prev + 1);
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  };

  const markAsRead = async (id: string) => {
    await fetch(`/api/notifications/${id}/read`, { method: 'PUT' });
    setNotifications(prev =>
      prev.map(n => n.id === id ? { ...n, read: true } : n)
    );
    setUnreadCount(prev => Math.max(0, prev - 1));
  };

  return (
    <div className="relative">
      <button
        onClick={() => setShowDropdown(!showDropdown)}
        className="relative p-2 hover:bg-gray-100 rounded-full"
      >
        <Bell className="w-6 h-6" />
        {unreadCount > 0 && (
          <span className="absolute top-0 right-0 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
            {unreadCount}
          </span>
        )}
      </button>

      {showDropdown && (
        <div className="absolute right-0 mt-2 w-96 bg-white rounded-lg shadow-lg z-50">
          <div className="p-4 border-b">
            <h3 className="font-semibold">Notifications</h3>
          </div>
          <div className="max-h-96 overflow-y-auto">
            {notifications.length === 0 ? (
              <div className="p-4 text-center text-gray-500">
                No notifications
              </div>
            ) : (
              notifications.map(notification => (
                <div
                  key={notification.id}
                  className={`p-4 border-b hover:bg-gray-50 cursor-pointer ${
                    !notification.read ? 'bg-blue-50' : ''
                  }`}
                  onClick={() => markAsRead(notification.id)}
                >
                  <h4 className="font-medium">{notification.title}</h4>
                  <p className="text-sm text-gray-600">{notification.message}</p>
                  <span className="text-xs text-gray-400">
                    {new Date(notification.created_at).toLocaleString()}
                  </span>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
```

---

### 2. Toast Notification Component

Create `/frontend/components/Toast.tsx`:

```typescript
import { useEffect } from 'react';
import { CheckCircle, XCircle, AlertCircle, Info, X } from 'lucide-react';

interface ToastProps {
  message: string;
  type: 'success' | 'error' | 'warning' | 'info';
  onClose: () => void;
  duration?: number;
}

export default function Toast({ message, type, onClose, duration = 5000 }: ToastProps) {
  useEffect(() => {
    const timer = setTimeout(onClose, duration);
    return () => clearTimeout(timer);
  }, [duration, onClose]);

  const icons = {
    success: <CheckCircle className="w-5 h-5 text-green-500" />,
    error: <XCircle className="w-5 h-5 text-red-500" />,
    warning: <AlertCircle className="w-5 h-5 text-yellow-500" />,
    info: <Info className="w-5 h-5 text-blue-500" />
  };

  const backgrounds = {
    success: 'bg-green-50 border-green-200',
    error: 'bg-red-50 border-red-200',
    warning: 'bg-yellow-50 border-yellow-200',
    info: 'bg-blue-50 border-blue-200'
  };

  return (
    <div className={`fixed top-4 right-4 max-w-md p-4 rounded-lg border ${backgrounds[type]} shadow-lg z-50 animate-slide-in`}>
      <div className="flex items-start gap-3">
        {icons[type]}
        <p className="flex-1 text-sm">{message}</p>
        <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
          <X className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
```

---

## 🔄 Real-time Notifications with Supabase

### Subscribe to Real-time Updates

```typescript
import { supabase } from '@/utils/supabase';

// Subscribe to new notifications
const channel = supabase
  .channel('notifications')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'notifications',
      filter: `user_id=eq.${userId}`
    },
    (payload) => {
      // Show toast notification
      showToast(payload.new.message, payload.new.type);
      
      // Update notification list
      updateNotificationList(payload.new);
      
      // Play sound (optional)
      playNotificationSound();
    }
  )
  .subscribe();

// Cleanup
return () => {
  supabase.removeChannel(channel);
};
```

---

## 📨 Notification Triggers

### 1. Access Request Workflow

```javascript
// When user submits access request
router.post('/access-requests', async (req, res) => {
  // Create access request
  const request = await createAccessRequest(req.body);
  
  // Notify user (confirmation)
  await notifyAccessRequestStatus(request, 'pending');
  
  // Notify approver
  await notifyApprover(request, request.approver_id);
  
  res.json(request);
});

// When approver approves/rejects
router.put('/access-requests/:id/approve', async (req, res) => {
  const request = await approveRequest(req.params.id);
  
  // Notify requester
  await notifyAccessRequestStatus(request, 'approved');
  
  res.json(request);
});
```

---

### 2. Asset Assignment

```javascript
// When asset is assigned
router.put('/assets/:id/assign', async (req, res) => {
  const assignment = await assignAsset(req.params.id, req.body.user_id);
  
  // Notify user
  await notifyAssetAssignment(assignment);
  
  // Send email (optional)
  await sendAssetAssignmentEmail(assignment);
  
  res.json(assignment);
});
```

---

### 3. Maintenance Schedule

```javascript
// When maintenance is scheduled
router.post('/maintenance', async (req, res) => {
  const maintenance = await scheduleMaintenance(req.body);
  
  // Notify asset owner
  await notifyMaintenance(maintenance);
  
  // Send email notification
  await sendMaintenanceNotification(maintenance.user_email, maintenance);
  
  // Schedule reminder (24 hours before)
  await scheduleMaintenanceReminder(maintenance);
  
  res.json(maintenance);
});
```

---

### 4. License Expiration Check (Cron Job)

```javascript
// Daily cron job to check license expiration
const cron = require('node-cron');

// Run daily at 9 AM
cron.schedule('0 9 * * *', async () => {
  const { data: licenses } = await supabase
    .from('system_licenses')
    .select('*')
    .gte('expiry_date', new Date().toISOString())
    .lte('expiry_date', new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString());

  for (const license of licenses) {
    const daysRemaining = Math.ceil(
      (new Date(license.expiry_date) - new Date()) / (1000 * 60 * 60 * 24)
    );
    
    if (daysRemaining <= 30) {
      await notifyLicenseExpiring(license, daysRemaining);
    }
  }
});
```

---

## 🎯 Notification Types

### Info (Blue)
- System updates
- New features
- General announcements
- Assignment confirmations

### Success (Green)
- Request approved
- Action completed
- Asset received
- License activated

### Warning (Yellow)
- Pending approvals
- License expiring soon
- Maintenance scheduled
- Action required

### Error (Red)
- Request rejected
- System error
- License expired
- Critical issue

---

## 📊 Usage Examples

### Example 1: Access Request Flow

```
User submits request
  ↓
✉️ Notification to User: "Request submitted"
  ↓
✉️ Notification to Manager: "New request pending"
  ↓
Manager approves
  ↓
✉️ Notification to User: "Request approved"
  ↓
🔔 Real-time toast: "You can now access the system"
```

### Example 2: Asset Assignment

```
Admin assigns asset
  ↓
✉️ Notification to User: "New asset assigned"
  ↓
📧 Email with asset details
  ↓
User acknowledges
  ↓
✉️ Notification to Admin: "Asset received"
```

---

## 🔔 Best Practices

### 1. Keep Messages Clear
✅ "Your access to Microsoft 365 has been approved"
❌ "Status update for request #12345"

### 2. Provide Context
✅ Include system name, asset details, dates
❌ Generic messages without details

### 3. Add Action Links
✅ Direct link to relevant page
❌ No way to navigate to details

### 4. Group Related Notifications
✅ "3 new access requests pending"
❌ 3 separate notifications

### 5. Set Appropriate Priority
✅ Critical: Errors, rejections
✅ Warning: Pending actions, expirations
✅ Info: Confirmations, updates

---

## 🧪 Testing Notifications

### Test Endpoint

```bash
# Send test notification
curl -X POST http://localhost:3001/api/notifications/test \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}'
```

### Manual Test

```javascript
// In browser console
const testNotification = {
  user_id: 'your-user-id',
  title: 'Test Notification',
  message: 'This is a test notification',
  type: 'info'
};

fetch('/api/notifications', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(testNotification)
});
```

---

## 📈 Monitoring

### Notification Metrics

- Total notifications sent
- Delivery rate
- Read rate
- Average time to read
- Notifications by type
- Peak notification times

### Database Queries

```sql
-- Unread notifications by user
SELECT user_id, COUNT(*) as unread_count
FROM notifications
WHERE read = FALSE
GROUP BY user_id;

-- Notifications in last 24 hours
SELECT COUNT(*) FROM notifications
WHERE created_at > NOW() - INTERVAL '24 hours';

-- Most common notification types
SELECT type, COUNT(*) as count
FROM notifications
GROUP BY type
ORDER BY count DESC;
```

---

## 🚀 Future Enhancements

- [ ] Push notifications (web push)
- [ ] SMS notifications for critical alerts
- [ ] Slack integration
- [ ] Microsoft Teams integration
- [ ] Notification preferences/settings
- [ ] Scheduled digest emails
- [ ] Notification templates
- [ ] A/B testing for notification content

---

**Document Version**: 1.0  
**Last Updated**: November 18, 2025  
**Author**: AssetFlow Development Team
