import { useEffect, useCallback, useRef, useState } from 'react';
import { RealtimeChannel } from '@supabase/supabase-js';
import { getSupabaseClient } from '@/utils/supabase';
import {
  subscribeToNotifications,
  subscribeToAccessRequests,
  subscribeToMyAccessRequests,
  subscribeToLicenseUpdates,
  subscribeToUserAccess,
  subscribeToPresence,
  unsubscribeChannel,
  RealtimeNotification,
  RealtimeAccessRequest
} from '@/utils/realtime';

const supabase = getSupabaseClient();

/**
 * Hook for real-time notifications
 */
export function useNotifications(
  userId: string | undefined,
  onNotification?: (notification: RealtimeNotification) => void
) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    if (!userId) return;

    // Subscribe to notifications
    channelRef.current = subscribeToNotifications(userId, (notification) => {
      console.log('📬 New notification:', notification);
      onNotification?.(notification);
    });

    // Cleanup on unmount
    return () => {
      if (channelRef.current) {
        unsubscribeChannel(channelRef.current);
      }
    };
  }, [userId, onNotification]);

  return {
    isConnected: channelRef.current?.state === 'joined',
    channel: channelRef.current
  };
}

/**
 * Hook for real-time access requests (for admins/managers)
 */
export function useAccessRequests(
  onNewRequest?: (request: RealtimeAccessRequest) => void,
  onRequestUpdate?: (request: RealtimeAccessRequest) => void,
  onRequestDelete?: (request: RealtimeAccessRequest) => void
) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    // Subscribe to access requests
    channelRef.current = subscribeToAccessRequests((request, eventType) => {
      console.log(`📝 Access request ${eventType}:`, request);
      
      switch (eventType) {
        case 'INSERT':
          onNewRequest?.(request);
          break;
        case 'UPDATE':
          onRequestUpdate?.(request);
          break;
        case 'DELETE':
          onRequestDelete?.(request);
          break;
      }
    });

    // Cleanup on unmount
    return () => {
      if (channelRef.current) {
        unsubscribeChannel(channelRef.current);
      }
    };
  }, [onNewRequest, onRequestUpdate, onRequestDelete]);

  return {
    isConnected: channelRef.current?.state === 'joined',
    channel: channelRef.current
  };
}

/**
 * Hook for user's own access requests
 */
export function useMyAccessRequests(
  userId: string | undefined,
  onMyRequest?: (request: RealtimeAccessRequest, eventType: 'INSERT' | 'UPDATE') => void
) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    if (!userId) return;

    // Subscribe to my access requests
    channelRef.current = subscribeToMyAccessRequests(userId, (request, eventType) => {
      console.log(`📋 My request ${eventType}:`, request);
      onMyRequest?.(request, eventType);
    });

    // Cleanup on unmount
    return () => {
      if (channelRef.current) {
        unsubscribeChannel(channelRef.current);
      }
    };
  }, [userId, onMyRequest]);

  return {
    isConnected: channelRef.current?.state === 'joined',
    channel: channelRef.current
  };
}

/**
 * Hook for license updates
 */
export function useLicenseUpdates(
  onLicenseUpdate?: (license: any, eventType: 'INSERT' | 'UPDATE') => void
) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    // Subscribe to license updates
    channelRef.current = subscribeToLicenseUpdates((license, eventType) => {
      console.log(`🔑 License ${eventType}:`, license);
      onLicenseUpdate?.(license, eventType);
    });

    // Cleanup on unmount
    return () => {
      if (channelRef.current) {
        unsubscribeChannel(channelRef.current);
      }
    };
  }, [onLicenseUpdate]);

  return {
    isConnected: channelRef.current?.state === 'joined',
    channel: channelRef.current
  };
}

/**
 * Hook for user access changes
 */
export function useUserAccess(
  userId: string | undefined,
  onAccessChange?: (access: any, eventType: 'INSERT' | 'UPDATE' | 'DELETE') => void
) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    if (!userId) return;

    // Subscribe to user access changes
    channelRef.current = subscribeToUserAccess(userId, (access, eventType) => {
      console.log(`🔐 Access ${eventType}:`, access);
      onAccessChange?.(access, eventType);
    });

    // Cleanup on unmount
    return () => {
      if (channelRef.current) {
        unsubscribeChannel(channelRef.current);
      }
    };
  }, [userId, onAccessChange]);

  return {
    isConnected: channelRef.current?.state === 'joined',
    channel: channelRef.current
  };
}

/**
 * Hook for presence (online users)
 */
export function usePresence(
  roomId: string | undefined,
  userId: string | undefined,
  userName: string | undefined,
  onPresenceChange?: (presences: any) => void
) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    if (!roomId || !userId || !userName) return;

    // Subscribe to presence
    channelRef.current = subscribeToPresence(roomId, userId, userName, (presences) => {
      console.log('👥 Presence update:', presences);
      onPresenceChange?.(presences);
    });

    // Cleanup on unmount
    return () => {
      if (channelRef.current) {
        unsubscribeChannel(channelRef.current);
      }
    };
  }, [roomId, userId, userName, onPresenceChange]);

  const updatePresence = useCallback(async (status: any) => {
    if (channelRef.current) {
      await channelRef.current.track(status);
    }
  }, []);

  return {
    isConnected: channelRef.current?.state === 'joined',
    channel: channelRef.current,
    updatePresence
  };
}

/**
 * Hook for general realtime connection status
 */
export function useRealtimeConnection() {
  const [isConnected, setIsConnected] = useState(false);
  const [connectionState, setConnectionState] = useState<string>('disconnected');

  useEffect(() => {
    // Monitor connection state
    const checkConnection = setInterval(() => {
      const channels = supabase.getChannels();
      const hasConnectedChannel = channels.some(ch => ch.state === 'joined');
      setIsConnected(hasConnectedChannel);
      setConnectionState(channels[0]?.state || 'disconnected');
    }, 1000);

    return () => clearInterval(checkConnection);
  }, []);

  return {
    isConnected,
    connectionState
  };
}

/**
 * Hook for toast notifications with realtime updates
 */
export function useRealtimeToast(userId: string | undefined) {
  const [toasts, setToasts] = useState<Array<{
    id: string;
    message: string;
    type: 'info' | 'success' | 'warning' | 'error';
  }>>([]);

  useNotifications(userId, (notification) => {
    // Add toast
    setToasts(prev => [...prev, {
      id: notification.id,
      message: notification.message,
      type: notification.type
    }]);

    // Auto-remove after 5 seconds
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== notification.id));
    }, 5000);
  });

  const removeToast = useCallback((id: string) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  }, []);

  return {
    toasts,
    removeToast
  };
}

/**
 * Hook for counting unread notifications with realtime updates
 */
export function useUnreadCount(userId: string | undefined) {
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    if (!userId) return;

    // Fetch initial count
    const fetchCount = async () => {
      const { data } = await supabase
        .from('notifications')
        .select('id', { count: 'exact', head: true })
        .eq('user_id', userId)
        .eq('read', false);
      
      setUnreadCount(data?.length || 0);
    };

    fetchCount();
  }, [userId]);

  // Update count on new notifications
  useNotifications(userId, (notification) => {
    if (!notification.read) {
      setUnreadCount(prev => prev + 1);
    }
  });

  const markAsRead = useCallback((notificationId: string) => {
    setUnreadCount(prev => Math.max(0, prev - 1));
  }, []);

  const markAllAsRead = useCallback(() => {
    setUnreadCount(0);
  }, []);

  return {
    unreadCount,
    markAsRead,
    markAllAsRead
  };
}

/**
 * Hook for pending requests count with realtime updates
 */
export function usePendingRequestsCount() {
  const [pendingCount, setPendingCount] = useState(0);

  useEffect(() => {
    // Fetch initial count
    const fetchCount = async () => {
      const { data } = await supabase
        .from('system_access_requests')
        .select('id', { count: 'exact', head: true })
        .eq('status', 'pending');
      
      setPendingCount(data?.length || 0);
    };

    fetchCount();
  }, []);

  // Update count on new/updated requests
  useAccessRequests(
    () => setPendingCount(prev => prev + 1), // New request
    (request) => {
      // Request updated
      if (request.status !== 'pending') {
        setPendingCount(prev => Math.max(0, prev - 1));
      }
    }
  );

  return pendingCount;
}

export default {
  useNotifications,
  useAccessRequests,
  useMyAccessRequests,
  useLicenseUpdates,
  useUserAccess,
  usePresence,
  useRealtimeConnection,
  useRealtimeToast,
  useUnreadCount,
  usePendingRequestsCount
};
