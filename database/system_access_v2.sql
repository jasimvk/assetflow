-- System Access Management V2 Schema (Clean Installation)
-- Drop existing objects first to ensure clean installation

-- Drop tables (CASCADE will automatically drop policies and constraints)
DROP TABLE IF EXISTS access_request_history CASCADE;
DROP TABLE IF EXISTS access_request_approvals CASCADE;
DROP TABLE IF EXISTS it_asset_handover CASCADE;
DROP TABLE IF EXISTS system_access_details CASCADE;
DROP TABLE IF EXISTS system_access_requests CASCADE;


-- Main system access requests table
CREATE TABLE system_access_requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    request_number VARCHAR(50) UNIQUE NOT NULL,
    
    -- Employee Information
    employee_first_name VARCHAR(100) NOT NULL,
    employee_last_name VARCHAR(100) NOT NULL,
    employee_id VARCHAR(50) NOT NULL,
    entra_id VARCHAR(255), -- Format: f.lastname@1hospitality.ae
    department VARCHAR(100) NOT NULL,
    department_head VARCHAR(255), -- Department Head name
    email VARCHAR(255) NOT NULL,
    date_of_joining DATE,
    
    -- Request Details
    request_type VARCHAR(50) CHECK (request_type IN ('software', 'hardware', 'both')) DEFAULT 'software',
    justification TEXT,
    urgency VARCHAR(20) CHECK (urgency IN ('low', 'normal', 'high', 'urgent')) DEFAULT 'normal',
    priority VARCHAR(20) CHECK (priority IN ('low', 'medium', 'high')) DEFAULT 'medium', -- Visual priority
    required_by_date DATE,
    notes TEXT, -- Special requirements
    
    -- Status and Workflow
    status VARCHAR(50) CHECK (status IN ('pending', 'under_review', 'approved', 'rejected', 'in_progress', 'completed', 'cancelled')) DEFAULT 'pending',
    
    -- Approval Workflow
    requested_by UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_by UUID REFERENCES users(id) ON DELETE SET NULL,
    rejected_by UUID REFERENCES users(id) ON DELETE SET NULL,
    approval_date TIMESTAMP WITH TIME ZONE,
    rejection_date TIMESTAMP WITH TIME ZONE,
    rejection_reason TEXT,
    
    -- Processing
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL, -- IT staff assigned
    completed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    completed_at TIMESTAMP WITH TIME ZONE,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Software/System Access Details
CREATE TABLE system_access_details (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- System Information
    system_id UUID REFERENCES systems(id) ON DELETE SET NULL,
    system_name VARCHAR(100) NOT NULL, -- Fallback if not in systems table
    access_level VARCHAR(50) CHECK (access_level IN ('Read', 'Write', 'Admin', 'Custom')) DEFAULT 'Read',
    access_type VARCHAR(100), -- e.g., 'Generic Email', 'AP', 'AR', etc.
    
    -- Credentials (if applicable)
    username VARCHAR(255),
    email_address VARCHAR(255),
    group_assignments TEXT[], -- Array of group assignments
    
    -- Status
    status VARCHAR(50) CHECK (status IN ('pending', 'provisioned', 'failed')) DEFAULT 'pending',
    provisioned_at TIMESTAMP WITH TIME ZONE,
    provisioned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Notes
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- IT Asset Handover (Hardware Requests)
CREATE TABLE it_asset_handover (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- Asset Information
    asset_id UUID REFERENCES assets(id) ON DELETE SET NULL,
    asset_type VARCHAR(50) NOT NULL, -- 'laptop', 'desktop', 'monitor', 'phone', etc.
    asset_details TEXT,
    serial_number VARCHAR(100),
    
    -- Handover Details
    handover_date TIMESTAMP WITH TIME ZONE,
    handed_over_by UUID REFERENCES users(id) ON DELETE SET NULL,
    received_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Condition & Accessories
    condition VARCHAR(20) CHECK (condition IN ('new', 'good', 'fair', 'refurbished')),
    accessories TEXT, -- charger, bag, mouse, etc.
    
    -- Status
    status VARCHAR(50) CHECK (status IN ('pending', 'handed_over', 'returned')) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Approval Workflow Table (for multi-level approvals if needed)
CREATE TABLE access_request_approvals (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- Approver Details
    approver_id UUID REFERENCES users(id) ON DELETE SET NULL,
    approver_role VARCHAR(50), -- 'manager', 'it_admin', 'department_head'
    approval_level INTEGER DEFAULT 1, -- For multi-level approval
    
    -- Decision
    decision VARCHAR(20) CHECK (decision IN ('pending', 'approved', 'rejected')) DEFAULT 'pending',
    decision_date TIMESTAMP WITH TIME ZONE,
    comments TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Access Request History/Audit Log
CREATE TABLE access_request_history (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    access_request_id UUID NOT NULL REFERENCES system_access_requests(id) ON DELETE CASCADE,
    
    -- Action Details
    action VARCHAR(100) NOT NULL, -- 'created', 'approved', 'rejected', 'assigned', 'completed', etc.
    description TEXT,
    
    -- Status Changes
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    
    -- Actor
    performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Metadata
    metadata JSONB -- For storing additional context
);

-- Create indexes for performance
CREATE INDEX idx_system_access_requests_status ON system_access_requests(status);
CREATE INDEX idx_system_access_requests_employee_id ON system_access_requests(employee_id);
CREATE INDEX idx_system_access_requests_requested_by ON system_access_requests(requested_by);
CREATE INDEX idx_system_access_requests_assigned_to ON system_access_requests(assigned_to);
CREATE INDEX idx_system_access_requests_created_at ON system_access_requests(created_at);

CREATE INDEX idx_system_access_details_request_id ON system_access_details(access_request_id);
CREATE INDEX idx_system_access_details_system_id ON system_access_details(system_id);

CREATE INDEX idx_it_asset_handover_request_id ON it_asset_handover(access_request_id);
CREATE INDEX idx_it_asset_handover_asset_id ON it_asset_handover(asset_id);

CREATE INDEX idx_access_request_approvals_request_id ON access_request_approvals(access_request_id);
CREATE INDEX idx_access_request_approvals_approver_id ON access_request_approvals(approver_id);

CREATE INDEX idx_access_request_history_request_id ON access_request_history(access_request_id);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_system_access_requests_updated_at
    BEFORE UPDATE ON system_access_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (User-Friendly)
ALTER TABLE system_access_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_access_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE it_asset_handover ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_request_approvals ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_request_history ENABLE ROW LEVEL SECURITY;

-- Policies for system_access_requests
CREATE POLICY "Users can view own requests" ON system_access_requests
    FOR SELECT USING (
        requested_by = auth.uid()::uuid OR
        auth.jwt() ->> 'role' IN ('admin', 'it_admin', 'manager')
    );

CREATE POLICY "Users can create requests" ON system_access_requests
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins can update requests" ON system_access_requests
    FOR UPDATE USING (
        auth.jwt() ->> 'role' IN ('admin', 'it_admin')
    );

-- Policies for system_access_details
CREATE POLICY "Users can view own details" ON system_access_details
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests sar
            WHERE sar.id = system_access_details.access_request_id
            AND (sar.requested_by = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin', 'manager'))
        )
    );

CREATE POLICY "System can create details" ON system_access_details
    FOR INSERT WITH CHECK (true);

-- Policies for it_asset_handover
CREATE POLICY "Users can view own handovers" ON it_asset_handover
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests sar
            WHERE sar.id = it_asset_handover.access_request_id
            AND (sar.requested_by = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin'))
        )
    );

CREATE POLICY "IT can manage handovers" ON it_asset_handover
    FOR ALL USING (
        auth.jwt() ->> 'role' IN ('admin', 'it_admin')
    );

-- Policies for approvals
CREATE POLICY "Users can view approvals for their requests" ON access_request_approvals
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests sar
            WHERE sar.id = access_request_approvals.access_request_id
            AND (sar.requested_by = auth.uid()::uuid OR access_request_approvals.approver_id = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin'))
        )
    );

CREATE POLICY "Approvers can create approvals" ON access_request_approvals
    FOR INSERT WITH CHECK (
        auth.jwt() ->> 'role' IN ('admin', 'manager', 'it_admin')
    );

CREATE POLICY "Approvers can update their approvals" ON access_request_approvals
    FOR UPDATE USING (
        approver_id = auth.uid()::uuid OR auth.jwt() ->> 'role' = 'admin'
    );

-- Policies for history
CREATE POLICY "Users can view history of own requests" ON access_request_history
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM system_access_requests sar
            WHERE sar.id = access_request_history.access_request_id
            AND (sar.requested_by = auth.uid()::uuid OR auth.jwt() ->> 'role' IN ('admin', 'it_admin'))
        )
    );

CREATE POLICY "System can create history" ON access_request_history
    FOR INSERT WITH CHECK (true);
