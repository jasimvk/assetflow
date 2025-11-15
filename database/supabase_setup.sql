-- ============================================================================
-- AssetFlow Complete Database Schema for Supabase
-- Version: 2.0.0
-- Date: November 15, 2025
-- Includes: Assets, Maintenance, System Access Management
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) CHECK (role IN ('admin', 'manager', 'user')) DEFAULT 'user',
    department VARCHAR(100),
    azure_user_id VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    job_title VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
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

-- ============================================================================
-- ASSET MANAGEMENT TABLES
-- ============================================================================

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
    maintenance_schedule VARCHAR(50),
    warranty_expiry DATE,
    notes TEXT,
    image_url VARCHAR(500),
    status VARCHAR(50) DEFAULT 'active', -- active, retired, maintenance, lost
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
    action VARCHAR(50) NOT NULL,
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

-- ============================================================================
-- SYSTEM ACCESS MANAGEMENT TABLES
-- ============================================================================

-- System Access Requests table
CREATE TABLE IF NOT EXISTS system_access_requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_number VARCHAR(50) UNIQUE NOT NULL,
    
    -- Employee Information
    employee_first_name VARCHAR(100) NOT NULL,
    employee_last_name VARCHAR(100) NOT NULL,
    employee_id VARCHAR(50) NOT NULL,
    entra_id VARCHAR(255) NOT NULL, -- f.lastname@1hospitality.ae
    department VARCHAR(100) NOT NULL,
    department_head VARCHAR(255) NOT NULL,
    date_of_joining DATE NOT NULL,
    
    -- Request Metadata
    priority VARCHAR(20) CHECK (priority IN ('high', 'medium', 'low')) DEFAULT 'medium',
    status VARCHAR(50) CHECK (status IN ('pending', 'in_progress', 'approved', 'rejected')) DEFAULT 'pending',
    
    -- Network & Email Access
    network_login BOOLEAN DEFAULT FALSE,
    email_generic BOOLEAN DEFAULT FALSE,
    email_personal BOOLEAN DEFAULT FALSE,
    
    -- Oracle Fusion ERP - IT Admin
    it_admin_access BOOLEAN DEFAULT FALSE,
    it_department BOOLEAN DEFAULT FALSE,
    
    -- Oracle Fusion ERP - HR Module
    hr_group_1_dhr BOOLEAN DEFAULT FALSE,
    hr_group_2_manager BOOLEAN DEFAULT FALSE,
    hr_group_3_executive BOOLEAN DEFAULT FALSE,
    hr_group_4_accommodation BOOLEAN DEFAULT FALSE,
    hr_group_5_pr BOOLEAN DEFAULT FALSE,
    hr_group_6_hiring BOOLEAN DEFAULT FALSE,
    ess_user BOOLEAN DEFAULT FALSE,
    
    -- Oracle Fusion ERP - Finance Module
    finance_ap BOOLEAN DEFAULT FALSE,
    finance_ar BOOLEAN DEFAULT FALSE,
    finance_manager BOOLEAN DEFAULT FALSE,
    finance_dm BOOLEAN DEFAULT FALSE,
    
    -- Oracle Fusion ERP - Procurement Module
    procurement_buyer BOOLEAN DEFAULT FALSE,
    procurement_coordinator BOOLEAN DEFAULT FALSE,
    procurement_store BOOLEAN DEFAULT FALSE,
    procurement_receiver BOOLEAN DEFAULT FALSE,
    procurement_requestor BOOLEAN DEFAULT FALSE,
    
    -- Timetec Time Attendance
    timetec_it_admin BOOLEAN DEFAULT FALSE,
    timetec_hr_admin BOOLEAN DEFAULT FALSE,
    timetec_dept_coordinator BOOLEAN DEFAULT FALSE,
    
    -- IT Assets
    laptop BOOLEAN DEFAULT FALSE,
    desktop BOOLEAN DEFAULT FALSE,
    mobile_camera BOOLEAN DEFAULT FALSE,
    mobile_non_camera BOOLEAN DEFAULT FALSE,
    walkie_talkie BOOLEAN DEFAULT FALSE,
    duty_sim BOOLEAN DEFAULT FALSE,
    
    -- Request Management
    notes TEXT,
    rejection_reason TEXT,
    requested_by UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_by UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_at TIMESTAMP WITH TIME ZONE,
    rejected_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Access History table
CREATE TABLE IF NOT EXISTS system_access_history (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    action VARCHAR(50) NOT NULL, -- 'created', 'updated', 'approved', 'rejected', 'provisioned'
    description TEXT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Access Assets Assignments table (linking requests to actual assets)
CREATE TABLE IF NOT EXISTS system_access_assets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    asset_id UUID REFERENCES assets(id) ON DELETE SET NULL,
    asset_type VARCHAR(50) NOT NULL, -- 'laptop', 'desktop', 'mobile', etc.
    serial_number VARCHAR(100),
    assigned_date TIMESTAMP WITH TIME ZONE,
    returned_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(50) DEFAULT 'pending', -- pending, assigned, returned
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- NOTIFICATIONS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info', -- 'info', 'warning', 'error', 'success'
    related_asset_id UUID REFERENCES assets(id) ON DELETE SET NULL,
    related_maintenance_id UUID REFERENCES maintenance_records(id) ON DELETE SET NULL,
    related_access_request_id UUID REFERENCES system_access_requests(id) ON DELETE SET NULL,
    read BOOLEAN DEFAULT FALSE,
    sent_via_email BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Asset indexes
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_location ON assets(location);
CREATE INDEX IF NOT EXISTS idx_assets_assigned_to ON assets(assigned_to);
CREATE INDEX IF NOT EXISTS idx_assets_condition ON assets(condition);
CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status);

-- Maintenance indexes
CREATE INDEX IF NOT EXISTS idx_maintenance_records_asset_id ON maintenance_records(asset_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_status ON maintenance_records(status);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_scheduled_date ON maintenance_records(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_maintenance_records_priority ON maintenance_records(priority);

-- Asset history indexes
CREATE INDEX IF NOT EXISTS idx_asset_history_asset_id ON asset_history(asset_id);
CREATE INDEX IF NOT EXISTS idx_asset_history_performed_at ON asset_history(performed_at);

-- System Access indexes
CREATE INDEX IF NOT EXISTS idx_system_access_requests_status ON system_access_requests(status);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_priority ON system_access_requests(priority);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_employee_id ON system_access_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_department ON system_access_requests(department);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_entra_id ON system_access_requests(entra_id);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_requested_by ON system_access_requests(requested_by);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_date_of_joining ON system_access_requests(date_of_joining);

-- System Access History indexes
CREATE INDEX IF NOT EXISTS idx_system_access_history_request_id ON system_access_history(request_id);
CREATE INDEX IF NOT EXISTS idx_system_access_history_performed_at ON system_access_history(performed_at);

-- System Access Assets indexes
CREATE INDEX IF NOT EXISTS idx_system_access_assets_request_id ON system_access_assets(request_id);
CREATE INDEX IF NOT EXISTS idx_system_access_assets_asset_id ON system_access_assets(asset_id);
CREATE INDEX IF NOT EXISTS idx_system_access_assets_status ON system_access_assets(status);

-- Notification indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);

-- User indexes
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_department ON users(department);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(active);

-- ============================================================================
-- FUNCTIONS AND TRIGGERS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Function to generate request number
CREATE OR REPLACE FUNCTION generate_request_number()
RETURNS TRIGGER AS $$
DECLARE
    year_part VARCHAR(4);
    count_part VARCHAR(3);
    next_number INTEGER;
BEGIN
    -- Get current year
    year_part := TO_CHAR(NOW(), 'YYYY');
    
    -- Get the count of requests this year
    SELECT COUNT(*) + 1 INTO next_number
    FROM system_access_requests
    WHERE request_number LIKE 'SAR-' || year_part || '-%';
    
    -- Generate the count part with leading zeros
    count_part := LPAD(next_number::TEXT, 3, '0');
    
    -- Set the request number
    NEW.request_number := 'SAR-' || year_part || '-' || count_part;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Function to create audit log for system access requests
CREATE OR REPLACE FUNCTION log_system_access_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO system_access_history (request_id, action, description, new_status, performed_by)
        VALUES (NEW.id, 'created', 'System access request created', NEW.status, NEW.requested_by);
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status <> NEW.status THEN
            INSERT INTO system_access_history (request_id, action, description, old_status, new_status, performed_by)
            VALUES (NEW.id, 'status_changed', 'Status changed from ' || OLD.status || ' to ' || NEW.status, OLD.status, NEW.status, NEW.approved_by);
        END IF;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Updated_at triggers
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assets_updated_at 
    BEFORE UPDATE ON assets 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_maintenance_records_updated_at 
    BEFORE UPDATE ON maintenance_records 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_system_access_requests_updated_at 
    BEFORE UPDATE ON system_access_requests 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Request number generation trigger
CREATE TRIGGER generate_request_number_trigger
    BEFORE INSERT ON system_access_requests
    FOR EACH ROW
    WHEN (NEW.request_number IS NULL)
    EXECUTE FUNCTION generate_request_number();

-- Audit log trigger
CREATE TRIGGER log_system_access_change_trigger
    AFTER INSERT OR UPDATE ON system_access_requests
    FOR EACH ROW
    EXECUTE FUNCTION log_system_access_change();

-- ============================================================================
-- DEFAULT DATA
-- ============================================================================

-- Insert default categories
INSERT INTO categories (name, description) VALUES
('IT Equipment', 'Computers, servers, networking equipment, laptops, desktops'),
('Office Furniture', 'Desks, chairs, cabinets, meeting room furniture'),
('Vehicles', 'Company cars, trucks, delivery vehicles'),
('Mobile Devices', 'Smartphones, tablets, walkie talkies'),
('Communication', 'Phones, SIM cards, communication devices'),
('Machinery', 'Manufacturing equipment, tools, heavy machinery'),
('HVAC', 'Heating, ventilation, and air conditioning systems'),
('Security', 'Cameras, access control systems, alarms')
ON CONFLICT (name) DO NOTHING;

-- Insert default locations
INSERT INTO locations (name, address, building, floor) VALUES
('Headquarters', 'Main Office Location', 'Main Building', '1st Floor'),
('IT Department', 'IT Office', 'Main Building', '2nd Floor'),
('HR Department', 'HR Office', 'Main Building', '3rd Floor'),
('Warehouse', 'Storage Facility', 'Warehouse A', 'Ground Floor'),
('Branch Office', 'Branch Location', 'Office Complex B', '1st Floor')
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_access_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view own data" ON users;
DROP POLICY IF EXISTS "Everyone can view assets" ON assets;
DROP POLICY IF EXISTS "Managers and admins can modify assets" ON assets;
DROP POLICY IF EXISTS "Everyone can view maintenance records" ON maintenance_records;
DROP POLICY IF EXISTS "Managers and admins can modify maintenance records" ON maintenance_records;
DROP POLICY IF EXISTS "Users can view own notifications" ON notifications;
DROP POLICY IF EXISTS "Users can update own notifications" ON notifications;

-- Users policies
CREATE POLICY "Users can view own data" ON users 
    FOR SELECT 
    USING (
        auth.uid()::text = azure_user_id OR 
        EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role = 'admin')
    );

CREATE POLICY "Admins can manage users" ON users 
    FOR ALL 
    USING (
        EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role = 'admin')
    );

-- Assets policies
CREATE POLICY "Everyone can view assets" ON assets 
    FOR SELECT 
    USING (true);

CREATE POLICY "Managers and admins can manage assets" ON assets 
    FOR ALL 
    USING (
        EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
    );

-- Maintenance records policies
CREATE POLICY "Everyone can view maintenance records" ON maintenance_records 
    FOR SELECT 
    USING (true);

CREATE POLICY "Managers and admins can manage maintenance" ON maintenance_records 
    FOR ALL 
    USING (
        EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
    );

-- System Access Request policies
CREATE POLICY "Everyone can view system access requests" ON system_access_requests 
    FOR SELECT 
    USING (true);

CREATE POLICY "Managers and admins can create requests" ON system_access_requests 
    FOR INSERT 
    WITH CHECK (
        EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
    );

CREATE POLICY "Admins can manage all requests" ON system_access_requests 
    FOR ALL 
    USING (
        EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role = 'admin')
    );

CREATE POLICY "Managers can update their department requests" ON system_access_requests 
    FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE azure_user_id = auth.uid()::text 
            AND role = 'manager' 
            AND department = system_access_requests.department
        )
    );

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications 
    FOR SELECT 
    USING (
        user_id IN (SELECT id FROM users WHERE azure_user_id = auth.uid()::text)
    );

CREATE POLICY "Users can update own notifications" ON notifications 
    FOR UPDATE 
    USING (
        user_id IN (SELECT id FROM users WHERE azure_user_id = auth.uid()::text)
    );

CREATE POLICY "System can create notifications" ON notifications 
    FOR INSERT 
    WITH CHECK (true);

-- ============================================================================
-- VIEWS FOR REPORTING
-- ============================================================================

-- View: System Access Requests with User Details
CREATE OR REPLACE VIEW vw_system_access_requests_detailed AS
SELECT 
    sar.*,
    u_req.name AS requested_by_name,
    u_req.email AS requested_by_email,
    u_app.name AS approved_by_name,
    u_app.email AS approved_by_email,
    (
        SELECT COUNT(*) FROM system_access_assets 
        WHERE request_id = sar.id AND status = 'assigned'
    ) AS assets_assigned_count,
    (
        SELECT COUNT(*) FROM system_access_history 
        WHERE request_id = sar.id
    ) AS history_count
FROM system_access_requests sar
LEFT JOIN users u_req ON sar.requested_by = u_req.id
LEFT JOIN users u_app ON sar.approved_by = u_app.id;

-- View: Assets with Assignment Details
CREATE OR REPLACE VIEW vw_assets_with_users AS
SELECT 
    a.*,
    u.name AS assigned_to_name,
    u.email AS assigned_to_email,
    u.department AS assigned_to_department,
    (
        SELECT COUNT(*) FROM maintenance_records 
        WHERE asset_id = a.id AND status IN ('scheduled', 'in_progress')
    ) AS active_maintenance_count
FROM assets a
LEFT JOIN users u ON a.assigned_to = u.id;

-- View: Dashboard Statistics
CREATE OR REPLACE VIEW vw_dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM assets WHERE status = 'active') AS total_active_assets,
    (SELECT COUNT(*) FROM assets WHERE assigned_to IS NOT NULL) AS assigned_assets,
    (SELECT COUNT(*) FROM maintenance_records WHERE status IN ('scheduled', 'in_progress')) AS active_maintenance,
    (SELECT COUNT(*) FROM system_access_requests WHERE status = 'pending') AS pending_access_requests,
    (SELECT COUNT(*) FROM system_access_requests WHERE status = 'in_progress') AS in_progress_access_requests,
    (SELECT COUNT(*) FROM system_access_requests WHERE date_of_joining >= CURRENT_DATE - INTERVAL '30 days') AS recent_onboarding;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '============================================================================';
    RAISE NOTICE 'AssetFlow Database Schema Setup Complete!';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE 'Tables Created:';
    RAISE NOTICE '  ✓ users';
    RAISE NOTICE '  ✓ categories';
    RAISE NOTICE '  ✓ locations';
    RAISE NOTICE '  ✓ assets';
    RAISE NOTICE '  ✓ maintenance_records';
    RAISE NOTICE '  ✓ asset_history';
    RAISE NOTICE '  ✓ asset_attachments';
    RAISE NOTICE '  ✓ maintenance_attachments';
    RAISE NOTICE '  ✓ system_access_requests';
    RAISE NOTICE '  ✓ system_access_history';
    RAISE NOTICE '  ✓ system_access_assets';
    RAISE NOTICE '  ✓ notifications';
    RAISE NOTICE '';
    RAISE NOTICE 'Features Enabled:';
    RAISE NOTICE '  ✓ UUID generation';
    RAISE NOTICE '  ✓ Automatic timestamps (updated_at)';
    RAISE NOTICE '  ✓ Request number generation (SAR-YYYY-NNN)';
    RAISE NOTICE '  ✓ Audit logging for access requests';
    RAISE NOTICE '  ✓ Row Level Security (RLS)';
    RAISE NOTICE '  ✓ Performance indexes';
    RAISE NOTICE '  ✓ Reporting views';
    RAISE NOTICE '';
    RAISE NOTICE 'Next Steps:';
    RAISE NOTICE '  1. Configure your Supabase project URL and keys';
    RAISE NOTICE '  2. Update your .env files with Supabase credentials';
    RAISE NOTICE '  3. Test the connection from your application';
    RAISE NOTICE '  4. Create your first admin user';
    RAISE NOTICE '============================================================================';
END $$;
