 # Supabase Realtime Implementation Guide

## 📋 Overview

This guide covers the complete implementation of Supabase Realtime for real-time notifications, live updates, presence tracking, and collaborative features in AssetFlow.

---

## 🏗️ Architecture

### Components

1. **Realtime Utilities** (`/frontend/utils/realtime.ts`)
   - Core realtime subscription functions
   - Channel management
   - Event handlers

2. **React Hooks** (`/frontend/hooks/useRealtime.ts`)
   - Custom hooks for React components
   - State management
   - Automatic cleanup

3. **Database Triggers** (Supabase)
   - Postgres changes tracking
   - Real-time event streaming

---

## 🔧 Implementation Files

### 1. Realtime Utilities (`/frontend/utils/realtime.ts`)

#### Core Functions:

##### **subscribeToNotifications(userId, onNotification)**
Subscribe to notifications for a specific user.

```typescript
import { subscribeToNotifications } from '@/utils/realtime';

const channel = subscribeToNotifications(userId, (notification) => {
  console.log('New notification:', notification);
  // Show toast, update UI, play sound, etc.
});

// Cleanup
unsubscribeChannel(channel);
```

**Use Cases:**
- Real-time notification bell updates
- Toast notifications
- Sound alerts
- Badge count updates

---

##### **subscribeToAccessRequests(onRequest)**
Subscribe to all access request changes (admin/manager view).

```typescript
import { subscribeToAccessRequests } from '@/utils/realtime';

const channel = subscribeToAccessRequests((request, eventType) => {
  switch (eventType) {
    case 'INSERT':
      console.log('New request:', request);
      // Refresh pending requests list
      break;
    case 'UPDATE':
      console.log('Request updated:', request);
      // Update specific request in UI
      break;
    case 'DELETE':
      console.log('Request deleted:', request);
      // Remove from list
      break;
  }
});
```

**Use Cases:**
- Admin dashboard live updates
- Pending requests count
- Request status changes
- Auto-refresh lists

---

##### **subscribeToMyAccessRequests(userId, onRequest)**
Subscribe to current user's access requests only.

```typescript
import { subscribeToMyAccessRequests } from '@/utils/realtime';

const channel = subscribeToMyAccessRequests(userId, (request, eventType) => {
  if (eventType === 'UPDATE' && request.status === 'approved') {
    showToast('Your request has been approved!', 'success');
  }
});
```

**Use Cases:**
- User's request status updates
- Approval notifications
- Rejection notifications
- Request history updates

---

##### **subscribeToLicenseUpdates(onLicenseUpdate)**
Subscribe to system license changes.

```typescript
import { subscribeToLicenseUpdates } from '@/utils/realtime';

const channel = subscribeToLicenseUpdates((license, eventType) => {
  if (eventType === 'UPDATE' && license.available_licenses < 5) {
    showAlert('Low license count!', 'warning');
  }
});
```

**Use Cases:**
- License availability monitoring
- Expiration alerts
- Capacity planning
- Auto-refresh system list

---

##### **subscribeToUserAccess(userId, onAccessChange)**
Subscribe to user's system access changes (grants/revokes).

```typescript
import { subscribeToUserAccess } from '@/utils/realtime';

const channel = subscribeToUserAccess(userId, (access, eventType) => {
  if (eventType === 'INSERT') {
    showToast(`Access granted to ${access.system_name}!`, 'success');
    refreshMyAccessList();
  }
});
```

**Use Cases:**
- Access granted notifications
- Access revoked alerts
- System access list updates
- Permission changes

---

##### **subscribeToPresence(roomId, userId, userName, onPresenceChange)**
Track online users in a room (for collaboration features).

```typescript
import { subscribeToPresence } from '@/utils/realtime';

const channel = subscribeToPresence(
  'admin-room',
  userId,
  userName,
  (presences) => {
    const onlineUsers = Object.values(presences).flat();
    console.log('Online users:', onlineUsers.length);
  }
);
```

**Use Cases:**
- Show who's online
- Collaborative editing
- Live chat
- Activity indicators

---

### 2. React Hooks (`/frontend/hooks/useRealtime.ts`)

#### Custom Hooks for Components:

##### **useNotifications(userId, onNotification)**
React hook for notifications with automatic cleanup.

```typescript
import { useNotifications } from '@/hooks/useRealtime';

function NotificationBell() {
  const [notifications, setNotifications] = useState([]);
  
  useNotifications(userId, (notification) => {
    setNotifications(prev => [notification, ...prev]);
  });

  return <BellIcon count={notifications.length} />;
}
```

---

##### **useAccessRequests(onNew, onUpdate, onDelete)**
React hook for access requests with separate handlers.

```typescript
import { useAccessRequests } from '@/hooks/useRealtime';

function AdminDashboard() {
  const [requests, setRequests] = useState([]);
  
  useAccessRequests(
    (newRequest) => setRequests(prev => [newRequest, ...prev]),
    (updated) => setRequests(prev => prev.map(r => r.id === updated.id ? updated : r)),
    (deleted) => setRequests(prev => prev.filter(r => r.id !== deleted.id))
  );

  return <RequestsList requests={requests} />;
}
```

---

##### **useMyAccessRequests(userId, onRequest)**
React hook for user's own requests.

```typescript
import { useMyAccessRequests } from '@/hooks/useRealtime';

function MyRequests() {
  const [myRequests, setMyRequests] = useState([]);
  
  useMyAccessRequests(userId, (request, eventType) => {
    if (eventType === 'UPDATE') {
      // Update specific request
      setMyRequests(prev => prev.map(r => r.id === request.id ? request : r));
    }
  });

  return <MyRequestsList requests={myRequests} />;
}
```

---

##### **useRealtimeToast(userId)**
React hook that automatically shows toast notifications.

```typescript
import { useRealtimeToast } from '@/hooks/useRealtime';

function App() {
  const { toasts, removeToast } = useRealtimeToast(userId);

  return (
    <>
      {toasts.map(toast => (
        <Toast
          key={toast.id}
          message={toast.message}
          type={toast.type}
          onClose={() => removeToast(toast.id)}
        />
      ))}
    </>
  );
}
```

---

##### **useUnreadCount(userId)**
React hook for unread notification count with live updates.

```typescript
import { useUnreadCount } from '@/hooks/useRealtime';

function NotificationBell() {
  const { unreadCount, markAsRead, markAllAsRead } = useUnreadCount(userId);

  return (
    <div>
      <BellIcon />
      {unreadCount > 0 && <Badge>{unreadCount}</Badge>}
    </div>
  );
}
```

---

##### **usePendingRequestsCount()**
React hook for pending requests count with live updates.

```typescript
import { usePendingRequestsCount } from '@/hooks/useRealtime';

function AdminSidebar() {
  const pendingCount = usePendingRequestsCount();

  return (
    <MenuItem>
      Access Requests
      {pendingCount > 0 && <Badge>{pendingCount}</Badge>}
    </MenuItem>
  );
}
```

---

## 📊 Database Configuration

### Enable Realtime on Tables

```sql
-- Enable realtime for notifications table
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- Enable realtime for access requests
ALTER PUBLICATION supabase_realtime ADD TABLE system_access_requests;

-- Enable realtime for user access
ALTER PUBLICATION supabase_realtime ADD TABLE user_system_access;

-- Enable realtime for licenses
ALTER PUBLICATION supabase_realtime ADD TABLE system_licenses;
```

### Row Level Security (RLS)

Ensure RLS policies allow realtime subscriptions:

```sql
-- Users can only receive notifications meant for them
CREATE POLICY "Users receive own notifications realtime"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

-- Admins/Managers can see all access requests
CREATE POLICY "Admins see all access requests realtime"
  ON system_access_requests FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role IN ('admin', 'manager')
    )
  );

-- Users see their own access requests
CREATE POLICY "Users see own access requests realtime"
  ON system_access_requests FOR SELECT
  USING (auth.uid() = user_id);
```

---

## 🎯 Implementation Examples

### Example 1: Real-time Notification Bell

```typescript
import { useState, useEffect } from 'react';
import { Bell } from 'lucide-react';
import { useNotifications, useUnreadCount } from '@/hooks/useRealtime';

export default function NotificationBell({ userId }: { userId: string }) {
  const [notifications, setNotifications] = useState([]);
  const [showDropdown, setShowDropdown] = useState(false);
  const { unreadCount, markAsRead, markAllAsRead } = useUnreadCount(userId);

  // Subscribe to real-time notifications
  useNotifications(userId, (notification) => {
    // Add to list
    setNotifications(prev => [notification, ...prev]);
    
    // Show toast
    if (notification.type === 'success') {
      playSuccessSound();
    }
  });

  const handleNotificationClick = async (notification) => {
    // Mark as read
    await markAsRead(notification.id);
    
    // Navigate to related page
    if (notification.action_url) {
      router.push(notification.action_url);
    }
  };

  return (
    <div className="relative">
      <button onClick={() => setShowDropdown(!showDropdown)}>
        <Bell className="w-6 h-6" />
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
            {unreadCount}
          </span>
        )}
      </button>

      {showDropdown && (
        <div className="absolute right-0 mt-2 w-96 bg-white rounded-lg shadow-lg">
          <div className="p-4 border-b flex justify-between">
            <h3 className="font-semibold">Notifications</h3>
            {unreadCount > 0 && (
              <button onClick={markAllAsRead} className="text-sm text-blue-600">
                Mark all read
              </button>
            )}
          </div>
          <div className="max-h-96 overflow-y-auto">
            {notifications.map(notification => (
              <div
                key={notification.id}
                className={`p-4 border-b hover:bg-gray-50 cursor-pointer ${
                  !notification.read ? 'bg-blue-50' : ''
                }`}
                onClick={() => handleNotificationClick(notification)}
              >
                <h4 className="font-medium">{notification.title}</h4>
                <p className="text-sm text-gray-600">{notification.message}</p>
                <span className="text-xs text-gray-400">
                  {new Date(notification.created_at).toLocaleString()}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
```

---

### Example 2: Admin Dashboard with Live Updates

```typescript
import { useState, useEffect } from 'react';
import { useAccessRequests, usePendingRequestsCount } from '@/hooks/useRealtime';

export default function AdminDashboard() {
  const [requests, setRequests] = useState([]);
  const pendingCount = usePendingRequestsCount();

  // Load initial data
  useEffect(() => {
    fetchRequests();
  }, []);

  // Subscribe to real-time updates
  useAccessRequests(
    // On new request
    (newRequest) => {
      setRequests(prev => [newRequest, ...prev]);
      showToast('New access request received', 'info');
      playNotificationSound();
    },
    // On update
    (updatedRequest) => {
      setRequests(prev => prev.map(r => 
        r.id === updatedRequest.id ? updatedRequest : r
      ));
    },
    // On delete
    (deletedRequest) => {
      setRequests(prev => prev.filter(r => r.id !== deletedRequest.id));
    }
  );

  return (
    <div>
      <h1>Access Requests Dashboard</h1>
      <div className="stats">
        <div className="stat-card">
          <h3>Pending Requests</h3>
          <p className="text-3xl font-bold">{pendingCount}</p>
        </div>
      </div>

      <div className="requests-list">
        {requests.map(request => (
          <RequestCard key={request.id} request={request} />
        ))}
      </div>
    </div>
  );
}
```

---

### Example 3: User Request Status Page

```typescript
import { useState, useEffect } from 'react';
import { useMyAccessRequests } from '@/hooks/useRealtime';

export default function MyRequests({ userId }: { userId: string }) {
  const [myRequests, setMyRequests] = useState([]);

  // Load initial data
  useEffect(() => {
    fetchMyRequests();
  }, []);

  // Subscribe to my request updates
  useMyAccessRequests(userId, (request, eventType) => {
    if (eventType === 'UPDATE') {
      // Update the specific request
      setMyRequests(prev => prev.map(r => 
        r.id === request.id ? request : r
      ));

      // Show notification based on status
      if (request.status === 'approved') {
        showToast(`Your request to ${request.system_name} has been approved!`, 'success');
      } else if (request.status === 'rejected') {
        showToast(`Your request to ${request.system_name} was rejected`, 'error');
      }
    }
  });

  return (
    <div>
      <h1>My Access Requests</h1>
      <div className="requests-grid">
        {myRequests.map(request => (
          <RequestCard
            key={request.id}
            request={request}
            isLiveUpdate={true}
          />
        ))}
      </div>
    </div>
  );
}
```

---

### Example 4: Online Users Presence

```typescript
import { useState } from 'react';
import { usePresence } from '@/hooks/useRealtime';

export default function OnlineUsers({ roomId, userId, userName }) {
  const [onlineUsers, setOnlineUsers] = useState([]);

  usePresence(roomId, userId, userName, (presences) => {
    const users = Object.values(presences).flat();
    setOnlineUsers(users);
  });

  return (
    <div className="online-users">
      <h3>Online Now ({onlineUsers.length})</h3>
      <div className="user-list">
        {onlineUsers.map(user => (
          <div key={user.user_id} className="user-item">
            <div className="avatar">{user.user_name[0]}</div>
            <span>{user.user_name}</span>
            <span className="online-indicator"></span>
          </div>
        ))}
      </div>
    </div>
  );
}
```

---

## 🎨 UI Components with Realtime

### Toast Notification Component

```typescript
import { useRealtimeToast } from '@/hooks/useRealtime';
import { CheckCircle, XCircle, AlertCircle, Info } from 'lucide-react';

export default function ToastContainer({ userId }: { userId: string }) {
  const { toasts, removeToast } = useRealtimeToast(userId);

  const icons = {
    success: <CheckCircle className="text-green-500" />,
    error: <XCircle className="text-red-500" />,
    warning: <AlertCircle className="text-yellow-500" />,
    info: <Info className="text-blue-500" />
  };

  return (
    <div className="fixed top-4 right-4 z-50 space-y-2">
      {toasts.map(toast => (
        <div
          key={toast.id}
          className="bg-white rounded-lg shadow-lg p-4 flex items-center gap-3 animate-slide-in"
        >
          {icons[toast.type]}
          <p className="flex-1">{toast.message}</p>
          <button onClick={() => removeToast(toast.id)}>×</button>
        </div>
      ))}
    </div>
  );
}
```

---

## 🔔 Connection Status Indicator

```typescript
import { useRealtimeConnection } from '@/hooks/useRealtime';

export default function ConnectionStatus() {
  const { isConnected, connectionState } = useRealtimeConnection();

  return (
    <div className="flex items-center gap-2">
      <div className={`w-2 h-2 rounded-full ${
        isConnected ? 'bg-green-500' : 'bg-red-500'
      }`} />
      <span className="text-sm text-gray-600">
        {isConnected ? 'Connected' : 'Disconnected'}
      </span>
    </div>
  );
}
```

---

## 🧪 Testing Realtime

### Test Notification

```typescript
// In browser console or test file
import { getSupabaseClient } from '@/utils/supabase';

const supabase = getSupabaseClient();

// Insert test notification
await supabase.from('notifications').insert({
  user_id: 'your-user-id',
  title: 'Test Notification',
  message: 'This is a test realtime notification',
  type: 'info'
});

// Should appear instantly in UI!
```

### Test Access Request Update

```typescript
// Update request status
await supabase
  .from('system_access_requests')
  .update({ status: 'approved' })
  .eq('id', 'request-id');

// User should receive instant notification!
```

---

## 📈 Performance Optimization

### Best Practices:

1. **Limit Active Subscriptions**
   ```typescript
   // Only subscribe to what you need
   useEffect(() => {
     if (isAdminPage) {
       // Subscribe to all requests
     } else {
       // Subscribe only to my requests
     }
   }, [isAdminPage]);
   ```

2. **Cleanup Subscriptions**
   ```typescript
   useEffect(() => {
     const channel = subscribeToNotifications(userId, callback);
     
     return () => {
       unsubscribeChannel(channel); // Always cleanup!
     };
   }, [userId]);
   ```

3. **Debounce UI Updates**
   ```typescript
   const debouncedUpdate = useMemo(
     () => debounce((data) => setData(data), 300),
     []
   );

   useNotifications(userId, (notification) => {
     debouncedUpdate(notification);
   });
   ```

4. **Use Filters Wisely**
   ```sql
   -- Filter at database level, not in JavaScript
   filter: `user_id=eq.${userId}`  -- Good
   
   -- vs
   .filter(n => n.user_id === userId)  -- Bad (wastes bandwidth)
   ```

---

## 🚀 Advanced Features

### Broadcast Messages

```typescript
import { broadcastMessage } from '@/utils/realtime';

// Broadcast to all connected clients
await broadcastMessage(channel, 'user-typing', {
  userId,
  userName,
  timestamp: new Date()
});
```

### Presence Tracking

```typescript
const { updatePresence } = usePresence(roomId, userId, userName);

// Update user status
await updatePresence({
  status: 'busy',
  current_page: '/system-access'
});
```

---

## 🎯 Use Cases Summary

| Feature | Hook | Use Case |
|---------|------|----------|
| Notifications | `useNotifications` | Bell icon, toasts |
| Unread Count | `useUnreadCount` | Badge counter |
| Access Requests | `useAccessRequests` | Admin dashboard |
| My Requests | `useMyAccessRequests` | User's requests |
| Pending Count | `usePendingRequestsCount` | Sidebar badge |
| License Updates | `useLicenseUpdates` | System availability |
| User Access | `useUserAccess` | Access granted alerts |
| Presence | `usePresence` | Online users |
| Toasts | `useRealtimeToast` | Auto-toasts |

---

## 📞 Troubleshooting

### Connection Issues

```typescript
// Check if realtime is enabled
const { isConnected } = useRealtimeConnection();
console.log('Realtime connected:', isConnected);

// Check channel state
console.log('Channel state:', channel.state);
// Should be: 'joined'
```

### Not Receiving Updates

1. Check RLS policies
2. Verify realtime is enabled on table
3. Check filter syntax
4. Verify user authentication

### Multiple Updates

```typescript
// Use key in useEffect to prevent duplicate subscriptions
useEffect(() => {
  const channel = subscribe();
  return () => unsubscribe(channel);
}, [userId]); // Only recreate when userId changes
```

---

## 📚 References

- [Supabase Realtime Docs](https://supabase.com/docs/guides/realtime)
- [Realtime Broadcast](https://supabase.com/docs/guides/realtime/broadcast)
- [Realtime Presence](https://supabase.com/docs/guides/realtime/presence)
- [Postgres Changes](https://supabase.com/docs/guides/realtime/postgres-changes)

---

**Document Version**: 1.0  
**Last Updated**: November 18, 2025  
**Status**: ✅ Implemented
