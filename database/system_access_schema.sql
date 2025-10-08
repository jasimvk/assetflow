-- System Access Management Schema Extension
-- For IT Onboarding and System Access Provisioning

-- System Access Requests table
CREATE TABLE IF NOT EXISTS system_access_requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_number VARCHAR(50) UNIQUE NOT NULL,
    employee_first_name VARCHAR(100) NOT NULL,
    employee_last_name VARCHAR(100) NOT NULL,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    department VARCHAR(100) NOT NULL,
    department_head VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    date_of_joining DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')) DEFAULT 'pending',
    requested_by UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_by UUID REFERENCES users(id) ON DELETE SET NULL,
    completed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- System Access Details (for various systems like Oracle Fusion, Network, Email, etc.)
CREATE TABLE IF NOT EXISTS system_access_details (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    system_name VARCHAR(100) NOT NULL, -- e.g., 'Network', 'Email', 'Oracle Fusion ERP'
    access_type VARCHAR(100), -- e.g., 'Login/Windows/Open', 'Generic Email', 'AP', 'AR', etc.
    username VARCHAR(255),
    email_address VARCHAR(255),
    group_assignments TEXT[], -- Array of group assignments
    status VARCHAR(50) CHECK (status IN ('pending', 'provisioned', 'failed')) DEFAULT 'pending',
    provisioned_at TIMESTAMP WITH TIME ZONE,
    provisioned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Oracle Fusion ERP specific access tracking
CREATE TABLE IF NOT EXISTS oracle_fusion_access (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    -- HR Module
    hr_group_1_dhr BOOLEAN DEFAULT FALSE,
    hr_group_2_vary BOOLEAN DEFAULT FALSE,
    hr_group_3_executive BOOLEAN DEFAULT FALSE,
    hr_group_4_hana_deletion BOOLEAN DEFAULT FALSE,
    hr_group_5_pr BOOLEAN DEFAULT FALSE,
    hr_group_6_hrm BOOLEAN DEFAULT FALSE,
    hr_ess_user BOOLEAN DEFAULT FALSE,
    -- Finance Module
    finance_ap BOOLEAN DEFAULT FALSE,
    finance_ar BOOLEAN DEFAULT FALSE,
    finance_manager BOOLEAN DEFAULT FALSE,
    finance_din_finance BOOLEAN DEFAULT FALSE,
    -- Department Specific
    dept_group_1_head_pcu BOOLEAN DEFAULT FALSE,
    dept_group_2_manager BOOLEAN DEFAULT FALSE,
    dept_group_3_buyer BOOLEAN DEFAULT FALSE,
    dept_group_4_coordinator BOOLEAN DEFAULT FALSE,
    dept_store BOOLEAN DEFAULT FALSE,
    dept_receiver BOOLEAN DEFAULT FALSE,
    dept_request_user BOOLEAN DEFAULT FALSE,
    status VARCHAR(50) DEFAULT 'pending',
    provisioned_at TIMESTAMP WITH TIME ZONE,
    provisioned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- IT Assets Handover tracking
CREATE TABLE IF NOT EXISTS it_asset_handover (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    asset_id UUID REFERENCES assets(id) ON DELETE SET NULL,
    asset_type VARCHAR(50) NOT NULL, -- 'laptop', 'desktop', 'mobile', 'non_camera_mobile', 'walkie_talkie', 'duty_sim_card'
    asset_details TEXT,
    serial_number VARCHAR(100),
    handover_date TIMESTAMP WITH TIME ZONE,
    handed_over_by UUID REFERENCES users(id) ON DELETE SET NULL,
    received_by UUID REFERENCES users(id) ON DELETE SET NULL,
    condition VARCHAR(20) CHECK (condition IN ('new', 'good', 'fair', 'refurbished')),
    accessories TEXT, -- charger, bag, mouse, etc.
    status VARCHAR(50) CHECK (status IN ('pending', 'handed_over', 'returned')) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Time & Attendance system access
CREATE TABLE IF NOT EXISTS time_attendance_access (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    it_admin_access BOOLEAN DEFAULT FALSE,
    hr_access BOOLEAN DEFAULT FALSE,
    biometric_enrolled BOOLEAN DEFAULT FALSE,
    card_issued BOOLEAN DEFAULT FALSE,
    card_number VARCHAR(50),
    enrolled_at TIMESTAMP WITH TIME ZONE,
    enrolled_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Access Request History/Audit log
CREATE TABLE IF NOT EXISTS access_request_history (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_system_access_requests_status ON system_access_requests(status);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_employee_id ON system_access_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_system_access_requests_date_of_joining ON system_access_requests(date_of_joining);
CREATE INDEX IF NOT EXISTS idx_system_access_details_request_id ON system_access_details(access_request_id);
CREATE INDEX IF NOT EXISTS idx_oracle_fusion_access_request_id ON oracle_fusion_access(access_request_id);
CREATE INDEX IF NOT EXISTS idx_it_asset_handover_request_id ON it_asset_handover(access_request_id);
CREATE INDEX IF NOT EXISTS idx_it_asset_handover_asset_id ON it_asset_handover(asset_id);

-- Create trigger for updated_at
CREATE TRIGGER update_system_access_requests_updated_at 
    BEFORE UPDATE ON system_access_requests 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security
ALTER TABLE system_access_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_access_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE oracle_fusion_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE it_asset_handover ENABLE ROW LEVEL SECURITY;

-- Policies for system access requests
CREATE POLICY "Everyone can view access requests" ON system_access_requests FOR SELECT USING (true);
CREATE POLICY "Managers and admins can create access requests" ON system_access_requests FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
);
CREATE POLICY "Managers and admins can modify access requests" ON system_access_requests FOR UPDATE USING (
    EXISTS (SELECT 1 FROM users WHERE azure_user_id = auth.uid()::text AND role IN ('admin', 'manager'))
);
