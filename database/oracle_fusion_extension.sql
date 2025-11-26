-- Oracle Fusion ERP Access Details Extension
-- Add this after the system_access_v2.sql to extend for Oracle Fusion specific modules

-- Oracle Fusion ERP Module Access (Detailed)
CREATE TABLE IF NOT EXISTS oracle_fusion_access (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- IT Admin
    it_admin_access BOOLEAN DEFAULT FALSE,
    it_department BOOLEAN DEFAULT FALSE,
    
    -- HR Module Groups
    hr_group_1_dhr BOOLEAN DEFAULT FALSE,
    hr_group_2_hr_manager BOOLEAN DEFAULT FALSE,
    hr_group_3_executive BOOLEAN DEFAULT FALSE,
    hr_group_4_accommodation BOOLEAN DEFAULT FALSE,
    hr_group_5_public_relations BOOLEAN DEFAULT FALSE,
    hr_group_6_hiring BOOLEAN DEFAULT FALSE,
    hr_ess_user BOOLEAN DEFAULT FALSE, -- Employee Self-Service
    
    -- Finance Module
    finance_ap BOOLEAN DEFAULT FALSE, -- Accounts Payable
    finance_ar BOOLEAN DEFAULT FALSE, -- Accounts Receivable
    finance_manager BOOLEAN DEFAULT FALSE,
    finance_dm_finance BOOLEAN DEFAULT FALSE,
    
    -- Procurement Module
    procurement_group_3_buyer BOOLEAN DEFAULT FALSE,
    procurement_group_4_coordinator BOOLEAN DEFAULT FALSE,
    procurement_group_5_store BOOLEAN DEFAULT FALSE,
    procurement_group_6_receiver BOOLEAN DEFAULT FALSE,
    procurement_group_7_requestor BOOLEAN DEFAULT FALSE,
    
    -- Metadata
    provisioned_at TIMESTAMP WITH TIME ZONE,
    provisioned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Timetec Time Attendance Access
CREATE TABLE IF NOT EXISTS timetec_access (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- Access Groups
    group_1_it_admin BOOLEAN DEFAULT FALSE,
    group_2_hr_admin BOOLEAN DEFAULT FALSE,
    group_3_dept_coordinator BOOLEAN DEFAULT FALSE,
    
    -- Biometric enrollment
    biometric_enrolled BOOLEAN DEFAULT FALSE,
    enrolled_at TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    provisioned_at TIMESTAMP WITH TIME ZONE,
    provisioned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Network & Email Access
CREATE TABLE IF NOT EXISTS network_email_access (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- Network Login
    network_login BOOLEAN DEFAULT FALSE, -- Windows/Entra ID
    
    -- Email
    email_generic BOOLEAN DEFAULT FALSE,
    email_personal BOOLEAN DEFAULT FALSE,
    email_address VARCHAR(255),
    
    -- Metadata
    provisioned_at TIMESTAMP WITH TIME ZONE,
    provisioned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_oracle_fusion_access_request_id ON oracle_fusion_access(access_request_id);
CREATE INDEX IF NOT EXISTS idx_timetec_access_request_id ON timetec_access(access_request_id);
CREATE INDEX IF NOT EXISTS idx_network_email_access_request_id ON network_email_access(access_request_id);

-- RLS Policies
ALTER TABLE oracle_fusion_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE timetec_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE network_email_access ENABLE ROW LEVEL SECURITY;

-- Oracle Fusion policies
CREATE POLICY "Users can view own oracle access" ON oracle_fusion_access
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests
            WHERE system_access_requests.id = oracle_fusion_access.access_request_id
            AND (system_access_requests.requested_by = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin'))
        )
    );

CREATE POLICY "System can create oracle access" ON oracle_fusion_access
    FOR INSERT WITH CHECK (true);

-- Timetec policies
CREATE POLICY "Users can view own timetec access" ON timetec_access
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests
            WHERE system_access_requests.id = timetec_access.access_request_id
            AND (system_access_requests.requested_by = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin'))
        )
    );

CREATE POLICY "System can create timetec access" ON timetec_access
    FOR INSERT WITH CHECK (true);

-- Network/Email policies
CREATE POLICY "Users can view own network access" ON network_email_access
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests
            WHERE system_access_requests.id = network_email_access.access_request_id
            AND (system_access_requests.requested_by = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin'))
        )
    );

CREATE POLICY "System can create network access" ON network_email_access
    FOR INSERT WITH CHECK (true);
