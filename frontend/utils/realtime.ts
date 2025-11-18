// Supabase Realtime Utilities
import { getSupabaseClient } from './supabase';
import { RealtimeChannel } from '@supabase/supabase-js';

const supabase = getSupabaseClient();

export interface RealtimeNotification {
  id: string;
  user_id: string;
  title: string;
  message: string;
  type: 'info' | 'warning' | 'error' | 'success';
  read: boolean;
  related_type: string | null;
  related_id: string | null;
  action_url: string | null;
  metadata: Record<string, any>;
  created_at: string;
}

export interface RealtimeAccessRequest {
  id: string;
  user_id: string;
  system_id: string;
  status: 'pending' | 'approved' | 'rejected';
  justification: string;
  created_at: string;
  updated_at: string;
}

/**
 * Subscribe to notifications for current user
 */
export function subscribeToNotifications(
  userId: string,
  onNotification: (notification: RealtimeNotification) => void
): RealtimeChannel {
  const channel = supabase
    .channel(`notifications:${userId}`)
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'notifications',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('New notification received:', payload);
        onNotification(payload.new as RealtimeNotification);
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'notifications',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('Notification updated:', payload);
        onNotification(payload.new as RealtimeNotification);
      }
    )
    .subscribe((status) => {
      console.log('Notification subscription status:', status);
    });

  return channel;
}

/**
 * Subscribe to access requests (for admins/managers)
 */
export function subscribeToAccessRequests(
  onRequest: (request: RealtimeAccessRequest, eventType: 'INSERT' | 'UPDATE' | 'DELETE') => void
): RealtimeChannel {
  const channel = supabase
    .channel('access_requests')
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'system_access_requests'
      },
      (payload) => {
        console.log('New access request:', payload);
        onRequest(payload.new as RealtimeAccessRequest, 'INSERT');
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'system_access_requests'
      },
      (payload) => {
        console.log('Access request updated:', payload);
        onRequest(payload.new as RealtimeAccessRequest, 'UPDATE');
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'DELETE',
        schema: 'public',
        table: 'system_access_requests'
      },
      (payload) => {
        console.log('Access request deleted:', payload);
        onRequest(payload.old as RealtimeAccessRequest, 'DELETE');
      }
    )
    .subscribe((status) => {
      console.log('Access request subscription status:', status);
    });

  return channel;
}

/**
 * Subscribe to user's own access requests
 */
export function subscribeToMyAccessRequests(
  userId: string,
  onRequest: (request: RealtimeAccessRequest, eventType: 'INSERT' | 'UPDATE') => void
): RealtimeChannel {
  const channel = supabase
    .channel(`my_access_requests:${userId}`)
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'system_access_requests',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('My new request:', payload);
        onRequest(payload.new as RealtimeAccessRequest, 'INSERT');
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'system_access_requests',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('My request updated:', payload);
        onRequest(payload.new as RealtimeAccessRequest, 'UPDATE');
      }
    )
    .subscribe((status) => {
      console.log('My access request subscription status:', status);
    });

  return channel;
}

/**
 * Subscribe to system license changes
 */
export function subscribeToLicenseUpdates(
  onLicenseUpdate: (license: any, eventType: 'INSERT' | 'UPDATE') => void
): RealtimeChannel {
  const channel = supabase
    .channel('system_licenses')
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'system_licenses'
      },
      (payload) => {
        console.log('New license:', payload);
        onLicenseUpdate(payload.new, 'INSERT');
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'system_licenses'
      },
      (payload) => {
        console.log('License updated:', payload);
        onLicenseUpdate(payload.new, 'UPDATE');
      }
    )
    .subscribe((status) => {
      console.log('License subscription status:', status);
    });

  return channel;
}

/**
 * Subscribe to user access changes (when access is granted/revoked)
 */
export function subscribeToUserAccess(
  userId: string,
  onAccessChange: (access: any, eventType: 'INSERT' | 'UPDATE' | 'DELETE') => void
): RealtimeChannel {
  const channel = supabase
    .channel(`user_access:${userId}`)
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'user_system_access',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('Access granted:', payload);
        onAccessChange(payload.new, 'INSERT');
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'user_system_access',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('Access updated:', payload);
        onAccessChange(payload.new, 'UPDATE');
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'DELETE',
        schema: 'public',
        table: 'user_system_access',
        filter: `user_id=eq.${userId}`
      },
      (payload) => {
        console.log('Access revoked:', payload);
        onAccessChange(payload.old, 'DELETE');
      }
    )
    .subscribe((status) => {
      console.log('User access subscription status:', status);
    });

  return channel;
}

/**
 * Subscribe to presence (online users)
 */
export function subscribeToPresence(
  roomId: string,
  userId: string,
  userName: string,
  onPresenceChange: (presences: any) => void
): RealtimeChannel {
  const channel = supabase
    .channel(`presence:${roomId}`, {
      config: {
        presence: {
          key: userId
        }
      }
    })
    .on('presence', { event: 'sync' }, () => {
      const state = channel.presenceState();
      console.log('Presence sync:', state);
      onPresenceChange(state);
    })
    .on('presence', { event: 'join' }, ({ key, newPresences }) => {
      console.log('User joined:', key, newPresences);
    })
    .on('presence', { event: 'leave' }, ({ key, leftPresences }) => {
      console.log('User left:', key, leftPresences);
    })
    .subscribe(async (status) => {
      if (status === 'SUBSCRIBED') {
        await channel.track({
          user_id: userId,
          user_name: userName,
          online_at: new Date().toISOString()
        });
      }
    });

  return channel;
}

/**
 * Broadcast message to channel (for real-time collaboration)
 */
export async function broadcastMessage(
  channel: RealtimeChannel,
  event: string,
  payload: any
): Promise<void> {
  await channel.send({
    type: 'broadcast',
    event,
    payload
  });
}

/**
 * Subscribe to broadcast messages
 */
export function subscribeToBroadcast(
  channelName: string,
  event: string,
  onMessage: (payload: any) => void
): RealtimeChannel {
  const channel = supabase
    .channel(channelName)
    .on('broadcast', { event }, ({ payload }) => {
      console.log('Broadcast message received:', payload);
      onMessage(payload);
    })
    .subscribe();

  return channel;
}

/**
 * Unsubscribe from channel
 */
export async function unsubscribeChannel(channel: RealtimeChannel): Promise<void> {
  await supabase.removeChannel(channel);
  console.log('Channel unsubscribed');
}

/**
 * Unsubscribe from all channels
 */
export async function unsubscribeAll(): Promise<void> {
  await supabase.removeAllChannels();
  console.log('All channels unsubscribed');
}

/**
 * Get channel status
 */
export function getChannelStatus(channel: RealtimeChannel): string {
  return channel.state;
}

/**
 * Custom hook for notifications (to be used with React)
 */
export const useRealtimeNotifications = (
  userId: string,
  onNotification: (notification: RealtimeNotification) => void
) => {
  let channel: RealtimeChannel | null = null;

  const subscribe = () => {
    channel = subscribeToNotifications(userId, onNotification);
    return channel;
  };

  const unsubscribe = async () => {
    if (channel) {
      await unsubscribeChannel(channel);
      channel = null;
    }
  };

  return { subscribe, unsubscribe };
};

/**
 * Custom hook for access requests
 */
export const useRealtimeAccessRequests = (
  onRequest: (request: RealtimeAccessRequest, eventType: 'INSERT' | 'UPDATE' | 'DELETE') => void
) => {
  let channel: RealtimeChannel | null = null;

  const subscribe = () => {
    channel = subscribeToAccessRequests(onRequest);
    return channel;
  };

  const unsubscribe = async () => {
    if (channel) {
      await unsubscribeChannel(channel);
      channel = null;
    }
  };

  return { subscribe, unsubscribe };
};

export default {
  subscribeToNotifications,
  subscribeToAccessRequests,
  subscribeToMyAccessRequests,
  subscribeToLicenseUpdates,
  subscribeToUserAccess,
  subscribeToPresence,
  broadcastMessage,
  subscribeToBroadcast,
  unsubscribeChannel,
  unsubscribeAll,
  getChannelStatus,
  useRealtimeNotifications,
  useRealtimeAccessRequests
};
