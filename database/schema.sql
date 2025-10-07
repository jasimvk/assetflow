-- AssetFlow Database Schema
-- This SQL script creates the necessary tables for the AssetFlow application

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) CHECK (role IN ('admin', 'manager', 'user')) DEFAULT 'user',
    department VARCHAR(100),
    azure_user_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Categories table for asset categorization
CREATE TABLE IF NOT EXISTS categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Locations table
CREATE TABLE IF NOT EXISTS locations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    address TEXT,
    building VARCHAR(100),
    floor VARCHAR(50),
    room VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Assets table
CREATE TABLE IF NOT EXISTS assets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    serial_number VARCHAR(100) UNIQUE,
    model VARCHAR(100),
    manufacturer VARCHAR(100),
    purchase_date DATE NOT NULL,
    purchase_cost DECIMAL(12, 2) NOT NULL CHECK (purchase_cost >= 0),
    current_value DECIMAL(12, 2) NOT NULL CHECK (current_value >= 0),
    condition VARCHAR(20) CHECK (condition IN ('excellent', 'good', 'fair', 'poor')) DEFAULT 'good',
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    maintenance_schedule VARCHAR(50), -- e.g., 'monthly', 'quarterly', 'annually'
    warranty_expiry DATE,
    notes TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Maintenance records table
CREATE TABLE IF NOT EXISTS maintenance_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
    maintenance_type VARCHAR(100) NOT NULL,
    description TEXT,
    scheduled_date TIMESTAMP WITH TIME ZONE NOT NULL,
    completed_date TIMESTAMP WITH TIME ZONE,
    cost DECIMAL(10, 2) DEFAULT 0 CHECK (cost >= 0),
    technician_name VARCHAR(255),
    technician_contact VARCHAR(255),
    notes TEXT,
    status VARCHAR(20) CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')) DEFAULT 'scheduled',
    priority VARCHAR(20) CHECK (priority IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Asset history table for tracking changes
CREATE TABLE IF NOT EXISTS asset_history (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
    action VARCHAR(50) NOT NULL, -- 'created', 'updated', 'assigned', 'unassigned', 'maintenance'
    description TEXT,
    old_values JSONB,
    new_values JSONB,
    performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Asset attachments table
CREATE TABLE IF NOT EXISTS asset_attachments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    file_url VARCHAR(500) NOT NULL,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Maintenance attachments table
CREATE TABLE IF NOT EXISTS maintenance_attachments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    maintenance_record_id UUID NOT NULL REFERENCES maintenance_records(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    file_url VARCHAR(500) NOT NULL,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info', -- 'info', 'warning', 'error', 'success'
    related_asset_id UUID REFERENCES assets(id) ON DELETE SET NULL,
    related_maintenance_id UUID REFERENCES maintenance_records(id) ON DELETE SET NULL,
    read BOOLEAN DEFAULT FALSE,
    sent_via_email BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_assigned_to ON assets(assigned_to);
CREATE INDEX IF NOT EXISTS idx_assets_condition ON assets(condition);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_asset_id ON maintenance_records(asset_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_status ON maintenance_records(status);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_scheduled_date ON maintenance_records(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_asset_history_asset_id ON asset_history(asset_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_assets_updated_at BEFORE UPDATE ON assets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_maintenance_records_updated_at BEFORE UPDATE ON maintenance_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert default categories
INSERT INTO categories (name, description) VALUES
('IT Equipment', 'Computers, servers, networking equipment'),
('Office Furniture', 'Desks, chairs, cabinets, meeting room furniture'),
('Vehicles', 'Company cars, trucks, delivery vehicles'),
('Machinery', 'Manufacturing equipment, tools, heavy machinery'),
('HVAC', 'Heating, ventilation, and air conditioning systems'),
('Security', 'Cameras, access control systems, alarms'),
('Medical Equipment', 'Healthcare devices and instruments'),
('Laboratory Equipment', 'Scientific instruments and lab tools')
ON CONFLICT (name) DO NOTHING;

-- Insert default locations
INSERT INTO locations (name, address, building, floor) VALUES
('Headquarters', '123 Business Ave, Suite 100', 'Main Building', '1st Floor'),
('Warehouse', '456 Storage St', 'Warehouse A', 'Ground Floor'),
('Branch Office', '789 Commerce Blvd', 'Office Complex B', '3rd Floor')
ON CONFLICT (name) DO NOTHING;

-- Row Level Security (RLS) policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create policies (adjust based on your authentication setup)
-- These are basic policies - you should customize them based on your specific requirements

-- Users can read their own data and admins can read all
CREATE POLICY "Users can view own data" ON users FOR SELECT USING (auth.uid()::text = azure_user_id OR 
    EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role = 'admin'));

-- Assets policies
CREATE POLICY "Everyone can view assets" ON assets FOR SELECT USING (true);
CREATE POLICY "Managers and admins can modify assets" ON assets FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
);

-- Maintenance records policies
CREATE POLICY "Everyone can view maintenance records" ON maintenance_records FOR SELECT USING (true);
CREATE POLICY "Managers and admins can modify maintenance records" ON maintenance_records FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
);

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications FOR SELECT USING (
    user_id IN (SELECT id FROM users WHERE azure_user_id = auth.uid()::text)
);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (
    user_id IN (SELECT id FROM users WHERE azure_user_id = auth.uid()::text)
);