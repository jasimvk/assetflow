import { getSupabaseClient } from './supabase';

const supabase = getSupabaseClient();

// Error handler
const handleError = (error: any) => {
  console.error('API Error:', error);
  throw error;
};

// Assets API
export const assetsAPI = {
  getAll: async (filters?: { category?: string; location?: string; condition?: string }) => {
    try {
      console.log('Fetching assets from Supabase...');
      let query = supabase.from('assets').select(`
        *,
        department:department_id (
          id,
          name,
          description
        )
      `);
      
      if (filters?.category) query = query.eq('category', filters.category);
      if (filters?.location) query = query.eq('location', filters.location);
      if (filters?.condition) query = query.eq('condition', filters.condition);
      
      const { data, error } = await query;
      
      if (error) {
        console.error('Supabase error:', error);
        throw error;
      }
      
      console.log('Assets fetched successfully:', data?.length || 0, 'records');
      return data || [];
    } catch (error) {
      console.error('Error in getAll:', error);
      handleError(error);
      return [];
    }
  },

  getById: async (id: string) => {
    try {
      const { data, error } = await supabase
        .from('assets')
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  create: async (asset: any) => {
    try {
      const { data, error } = await supabase
        .from('assets')
        .insert([asset])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  update: async (id: string, asset: any) => {
    try {
      const { data, error } = await supabase
        .from('assets')
        .update(asset)
        .eq('id', id)
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  delete: async (id: string) => {
    try {
      const { error } = await supabase
        .from('assets')
        .delete()
        .eq('id', id);
      
      if (error) throw error;
      return true;
    } catch (error) {
      handleError(error);
      return false;
    }
  },

  assign: async (assetId: string, userId: string) => {
    try {
      const { data, error } = await supabase
        .from('assets')
        .update({ assigned_to: userId })
        .eq('id', assetId)
        .select()
        .single();
      
      if (error) throw error;
      
      // Log to asset history
      await supabase.from('asset_history').insert([{
        asset_id: assetId,
        action: 'assigned',
        changed_by: userId,
        details: `Asset assigned to user ${userId}`
      }]);
      
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// System Access API
export const systemAccessAPI = {
  getAll: async (filters?: { status?: string; priority?: string; department?: string }) => {
    try {
      let query = supabase
        .from('system_access_requests')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (filters?.status) query = query.eq('status', filters.status);
      if (filters?.priority) query = query.eq('priority', filters.priority);
      if (filters?.department) query = query.eq('department', filters.department);
      
      const { data, error } = await query;
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  getById: async (id: string) => {
    try {
      const { data, error } = await supabase
        .from('system_access_requests')
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  create: async (request: any) => {
    try {
      const { data, error } = await supabase
        .from('system_access_requests')
        .insert([request])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  updateStatus: async (id: string, status: string, comments?: string) => {
    try {
      const { data, error } = await supabase
        .from('system_access_requests')
        .update({ 
          status,
          ...(status === 'approved' && { approved_at: new Date().toISOString() }),
          ...(status === 'rejected' && { 
            rejected_at: new Date().toISOString(),
            rejection_reason: comments || 'No reason provided'
          }),
          updated_at: new Date().toISOString()
        })
        .eq('id', id)
        .select()
        .single();
      
      if (error) throw error;
      
      // Log status change to history
      await supabase.from('system_access_history').insert([{
        request_id: id,
        field_changed: 'status',
        old_value: '', // Would need to fetch old value
        new_value: status,
        comments: status === 'rejected' ? (comments || 'No reason provided') : comments
      }]);
      
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  getHistory: async (requestId: string) => {
    try {
      const { data, error } = await supabase
        .from('system_access_history')
        .select('*')
        .eq('request_id', requestId)
        .order('changed_at', { ascending: false });
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  }
};

// Maintenance API
export const maintenanceAPI = {
  getAll: async (filters?: { status?: string; asset_id?: string }) => {
    try {
      let query = supabase
        .from('maintenance_records')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (filters?.status) query = query.eq('status', filters.status);
      if (filters?.asset_id) query = query.eq('asset_id', filters.asset_id);
      
      const { data, error } = await query;
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  getById: async (id: string) => {
    try {
      const { data, error } = await supabase
        .from('maintenance_records')
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  create: async (record: any) => {
    try {
      const { data, error } = await supabase
        .from('maintenance_records')
        .insert([record])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  update: async (id: string, record: any) => {
    try {
      const { data, error } = await supabase
        .from('maintenance_records')
        .update(record)
        .eq('id', id)
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// Users API
export const usersAPI = {
  getAll: async (filters?: { role?: string; department?: string }) => {
    try {
      let query = supabase
        .from('users')
        .select('*')
        .order('full_name', { ascending: true });
      
      if (filters?.role) query = query.eq('role', filters.role);
      if (filters?.department) query = query.eq('department', filters.department);
      
      const { data, error } = await query;
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  getById: async (id: string) => {
    try {
      const { data, error} = await supabase
        .from('users')
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  create: async (user: any) => {
    try {
      const { data, error } = await supabase
        .from('users')
        .insert([user])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  },

  update: async (id: string, user: any) => {
    try {
      const { data, error } = await supabase
        .from('users')
        .update(user)
        .eq('id', id)
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// Categories API
export const categoriesAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  }
};

// Dashboard Stats API
export const dashboardAPI = {
  getStats: async () => {
    try {
      const { data, error } = await supabase
        .from('vw_dashboard_stats')
        .select('*')
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// Notifications API
export const notificationsAPI = {
  getAll: async (userId: string) => {
    try {
      const { data, error } = await supabase
        .from('notifications')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', { ascending: false });
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  markAsRead: async (id: string) => {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('id', id);
      
      if (error) throw error;
      return true;
    } catch (error) {
      handleError(error);
      return false;
    }
  }
};

// Departments API
export const departmentsAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('departments')
        .select('*')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  getById: async (id: string) => {
    try {
      const { data, error } = await supabase
        .from('departments')
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// ============================================
// MASTER DATA API
// ============================================

// Locations API
export const locationsAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('locations')
        .select('id, name')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string) => {
    try {
      const { data, error } = await supabase
        .from('locations')
        .insert([{ name }])
        .select('id, name')
        .single();
      
      if (error) {
        console.error('Error creating location:', error);
        throw error;
      }
      return data;
    } catch (error) {
      handleError(error);
      throw error; // Re-throw so the component knows it failed
    }
  }
};

// Manufacturers API
export const manufacturersAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('manufacturers')
        .select('id, name')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string) => {
    try {
      const { data, error } = await supabase
        .from('manufacturers')
        .insert([{ name }])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// Models API
export const modelsAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('models')
        .select('id, name, manufacturer_id')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string, manufacturerId?: string) => {
    try {
      const { data, error } = await supabase
        .from('models')
        .insert([{ name, manufacturer_id: manufacturerId }])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// OS Versions API
export const osVersionsAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('os_versions')
        .select('id, name')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string) => {
    try {
      const { data, error } = await supabase
        .from('os_versions')
        .insert([{ name }])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// CPU Types API
export const cpuTypesAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('cpu_types')
        .select('id, name')
        .order('name', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string) => {
    try {
      const { data, error } = await supabase
        .from('cpu_types')
        .insert([{ name }])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// RAM Sizes API
export const ramSizesAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('ram_sizes')
        .select('id, name, sort_order')
        .order('sort_order', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string) => {
    try {
      const { data, error } = await supabase
        .from('ram_sizes')
        .insert([{ name }])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// Storage Sizes API
export const storageSizesAPI = {
  getAll: async () => {
    try {
      const { data, error } = await supabase
        .from('storage_sizes')
        .select('id, name, sort_order')
        .order('sort_order', { ascending: true });
      
      if (error) throw error;
      return data || [];
    } catch (error) {
      handleError(error);
      return [];
    }
  },

  create: async (name: string) => {
    try {
      const { data, error } = await supabase
        .from('storage_sizes')
        .insert([{ name }])
        .select()
        .single();
      
      if (error) throw error;
      return data;
    } catch (error) {
      handleError(error);
      return null;
    }
  }
};

// Asset Code Generator API
export const assetCodeAPI = {
  generate: async (category: string): Promise<string> => {
    const categoryPrefixes: Record<string, string> = {
      'Desktop': 'DSK',
      'Laptop': 'LPT',
      'Server': 'SRV',
      'Monitor': 'MON',
      'Printer': 'PRT',
      'Switch': 'SWT',
      'Storage': 'STR',
      'Mobile Phone': 'MOB',
      'Walkie Talkie': 'WLK',
      'Tablet': 'TBL',
      'IT Peripherals': 'PER',
      'Other': 'OTH'
    };

    const prefix = categoryPrefixes[category] || 'AST';
    const year = new Date().getFullYear().toString().slice(-2);

    try {
      // Get the latest asset code for this category/prefix
      const { data: latestAssets, error } = await supabase
        .from('assets')
        .select('asset_code')
        .like('asset_code', `${prefix}-${year}-%`)
        .order('asset_code', { ascending: false })
        .limit(1);

      if (error) throw error;

      let nextNumber = 1;
      if (latestAssets && latestAssets.length > 0 && latestAssets[0].asset_code) {
        const lastCode = latestAssets[0].asset_code;
        const parts = lastCode.split('-');
        if (parts.length >= 3) {
          const lastNumber = parseInt(parts[2]) || 0;
          nextNumber = lastNumber + 1;
        }
      }

      return `${prefix}-${year}-${String(nextNumber).padStart(4, '0')}`;
    } catch (error) {
      console.error('Error generating asset code:', error);
      // Return a fallback code if query fails
      return `${prefix}-${year}-${String(Math.floor(Math.random() * 9999)).padStart(4, '0')}`;
    }
  }
};

// Combined Master Data API (for form initialization)
export const masterDataAPI = {
  getAll: async () => {
    try {
      const [
        locations,
        manufacturers,
        models,
        osVersions,
        cpuTypes,
        ramSizes,
        storageSizes,
        departments
      ] = await Promise.all([
        locationsAPI.getAll(),
        manufacturersAPI.getAll(),
        modelsAPI.getAll(),
        osVersionsAPI.getAll(),
        cpuTypesAPI.getAll(),
        ramSizesAPI.getAll(),
        storageSizesAPI.getAll(),
        departmentsAPI.getAll()
      ]);

      return {
        locations,
        manufacturers,
        models,
        osVersions,
        cpuTypes,
        ramSizes,
        storageSizes,
        departments
      };
    } catch (error) {
      handleError(error);
      return {
        locations: [],
        manufacturers: [],
        models: [],
        osVersions: [],
        cpuTypes: [],
        ramSizes: [],
        storageSizes: [],
        departments: []
      };
    }
  }
};
