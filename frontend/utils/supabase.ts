import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface Asset {
  id: string;
  name: string;
  category: string;
  location: string;
  purchase_date: string;
  purchase_cost: number;
  current_value: number;
  condition: 'excellent' | 'good' | 'fair' | 'poor';
  assigned_to: string | null;
  maintenance_schedule: string | null;
  warranty_expiry: string | null;
  created_at: string;
  updated_at: string;
}

export interface MaintenanceRecord {
  id: string;
  asset_id: string;
  maintenance_type: string;
  scheduled_date: string;
  completed_date: string | null;
  cost: number;
  notes: string;
  status: 'scheduled' | 'in_progress' | 'completed' | 'cancelled';
  created_at: string;
  updated_at: string;
}

export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'manager' | 'user';
  department: string;
  created_at: string;
  updated_at: string;
}

// Asset API functions
export const getAssets = async () => {
  const { data, error } = await supabase
    .from('assets')
    .select('*')
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data;
};

export const getAssetById = async (id: string) => {
  const { data, error } = await supabase
    .from('assets')
    .select('*')
    .eq('id', id)
    .single();
  
  if (error) throw error;
  return data;
};

export const createAsset = async (asset: Omit<Asset, 'id' | 'created_at' | 'updated_at'>) => {
  const { data, error } = await supabase
    .from('assets')
    .insert([asset])
    .select()
    .single();
  
  if (error) throw error;
  return data;
};

export const updateAsset = async (id: string, updates: Partial<Asset>) => {
  const { data, error } = await supabase
    .from('assets')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw error;
  return data;
};

export const deleteAsset = async (id: string) => {
  const { error } = await supabase
    .from('assets')
    .delete()
    .eq('id', id);
  
  if (error) throw error;
};

// Maintenance API functions
export const getMaintenanceRecords = async (assetId?: string) => {
  let query = supabase
    .from('maintenance_records')
    .select('*, assets(name)');
  
  if (assetId) {
    query = query.eq('asset_id', assetId);
  }
  
  const { data, error } = await query.order('scheduled_date', { ascending: false });
  
  if (error) throw error;
  return data;
};

export const createMaintenanceRecord = async (record: Omit<MaintenanceRecord, 'id' | 'created_at' | 'updated_at'>) => {
  const { data, error } = await supabase
    .from('maintenance_records')
    .insert([record])
    .select()
    .single();
  
  if (error) throw error;
  return data;
};

export const updateMaintenanceRecord = async (id: string, updates: Partial<MaintenanceRecord>) => {
  const { data, error } = await supabase
    .from('maintenance_records')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw error;
  return data;
};