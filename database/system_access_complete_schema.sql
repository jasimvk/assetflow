-- ============================================
-- SYSTEM ACCESS MANAGEMENT SCHEMA
-- Complete schema for managing software systems, licenses, and user access
-- ============================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS access_request_approvals CASCADE;
DROP TABLE IF EXISTS access_requests CASCADE;
DROP TABLE IF EXISTS user_access CASCADE;
DROP TABLE IF EXISTS system_licenses CASCADE;
DROP TABLE IF EXISTS systems CASCADE;

-- ============================================
-- 1. SYSTEMS TABLE
-- Stores information about software systems/applications
-- ============================================
CREATE TABLE systems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    category VARCHAR(100), -- e.g., 'ERP', 'CRM', 'Email', 'Development', 'Design'
    vendor VARCHAR(255),
    version VARCHAR(100),
    license_type VARCHAR(100), -- e.g., 'Per User', 'Per Device', 'Site License', 'Subscription'
    total_licenses INTEGER DEFAULT 0,
    available_licenses INTEGER DEFAULT 0,
    cost_per_license DECIMAL(10, 2),
    renewal_date DATE,
    contract_end_date DATE,
    system_url VARCHAR(500),
    support_contact VARCHAR(255),
    support_email VARCHAR(255),
    documentation_url VARCHAR(500),
    status VARCHAR(50) DEFAULT 'active', -- 'active', 'inactive', 'deprecated'
    requires_approval BOOLEAN DEFAULT true,
    auto_approve BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

-- Index for faster queries
CREATE INDEX idx_systems_status ON systems(status);
CREATE INDEX idx_systems_category ON systems(category);
CREATE INDEX idx_systems_name ON systems(name);

-- ============================================
-- 2. SYSTEM_LICENSES TABLE
-- Tracks individual license keys/assignments
-- ============================================
CREATE TABLE system_licenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    system_id UUID NOT NULL REFERENCES systems(id) ON DELETE CASCADE,
    license_key VARCHAR(500),
    license_type VARCHAR(100), -- 'User', 'Device', 'Floating'
    purchase_date DATE,
    activation_date DATE,
    expiry_date DATE,
    cost DECIMAL(10, 2),
    vendor_order_number VARCHAR(255),
    status VARCHAR(50) DEFAULT 'available', -- 'available', 'assigned', 'expired', 'suspended'
    max_users INTEGER DEFAULT 1,
    current_users INTEGER DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster queries
CREATE INDEX idx_licenses_system ON system_licenses(system_id);
CREATE INDEX idx_licenses_status ON system_licenses(status);

-- ============================================
-- 3. USER_ACCESS TABLE
-- Tracks which users have access to which systems
-- ============================================
CREATE TABLE user_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    system_id UUID NOT NULL REFERENCES systems(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    license_id UUID REFERENCES system_licenses(id) ON DELETE SET NULL,
    access_level VARCHAR(100), -- 'Read', 'Write', 'Admin', 'Full Access'
    username VARCHAR(255), -- Username in the system
    email VARCHAR(255),
    assigned_date DATE DEFAULT CURRENT_DATE,
    expiry_date DATE,
    status VARCHAR(50) DEFAULT 'active', -- 'active', 'suspended', 'revoked', 'expired'
    last_access_date TIMESTAMP,
    access_count INTEGER DEFAULT 0,
    assigned_by UUID REFERENCES auth.users(id),
    revoked_by UUID REFERENCES auth.users(id),
    revoked_date TIMESTAMP,
    revocation_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(system_id, user_id)
);

-- Index for faster queries
CREATE INDEX idx_user_access_system ON user_access(system_id);
CREATE INDEX idx_user_access_user ON user_access(user_id);
CREATE INDEX idx_user_access_status ON user_access(status);

-- ============================================
-- 4. ACCESS_REQUESTS TABLE
-- Manages access requests and approval workflow
-- ============================================
CREATE TABLE access_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    system_id UUID NOT NULL REFERENCES systems(id) ON DELETE CASCADE,
    requester_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    requester_name VARCHAR(255),
    requester_email VARCHAR(255),
    requester_department VARCHAR(255),
    request_type VARCHAR(50), -- 'new_access', 'access_extension', 'access_upgrade', 'access_revoke'
    access_level VARCHAR(100),
    justification TEXT NOT NULL,
    urgency VARCHAR(50) DEFAULT 'normal', -- 'low', 'normal', 'high', 'urgent'
    required_by_date DATE,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'cancelled'
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_date TIMESTAMP,
    reviewed_by UUID REFERENCES auth.users(id),
    reviewer_name VARCHAR(255),
    reviewer_comments TEXT,
    approved_date TIMESTAMP,
    rejected_date TIMESTAMP,
    rejection_reason TEXT,
    fulfilled_date TIMESTAMP,
    fulfilled_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster queries
CREATE INDEX idx_access_requests_status ON access_requests(status);
CREATE INDEX idx_access_requests_requester ON access_requests(requester_id);
CREATE INDEX idx_access_requests_system ON access_requests(system_id);

-- ============================================
-- 5. ACCESS_REQUEST_APPROVALS TABLE
-- Tracks multi-level approval workflow
-- ============================================
CREATE TABLE access_request_approvals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL REFERENCES access_requests(id) ON DELETE CASCADE,
    approver_id UUID NOT NULL REFERENCES auth.users(id),
    approver_name VARCHAR(255),
    approver_role VARCHAR(100), -- 'manager', 'it_admin', 'security_officer'
    approval_level INTEGER DEFAULT 1,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    decision_date TIMESTAMP,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster queries
CREATE INDEX idx_approvals_request ON access_request_approvals(request_id);
CREATE INDEX idx_approvals_approver ON access_request_approvals(approver_id);
CREATE INDEX idx_approvals_status ON access_request_approvals(status);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update available licenses when assigning access
CREATE OR REPLACE FUNCTION update_available_licenses()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.status = 'active' THEN
        -- Decrease available licenses
        UPDATE systems 
        SET available_licenses = available_licenses - 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.system_id AND available_licenses > 0;
        
        -- Update license current users if license_id is provided
        IF NEW.license_id IS NOT NULL THEN
            UPDATE system_licenses
            SET current_users = current_users + 1,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = NEW.license_id;
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status = 'active' AND NEW.status IN ('suspended', 'revoked', 'expired') THEN
            -- Increase available licenses
            UPDATE systems 
            SET available_licenses = available_licenses + 1,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = NEW.system_id;
            
            -- Update license current users
            IF NEW.license_id IS NOT NULL THEN
                UPDATE system_licenses
                SET current_users = current_users - 1,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = NEW.license_id;
            END IF;
        ELSIF OLD.status IN ('suspended', 'revoked', 'expired') AND NEW.status = 'active' THEN
            -- Decrease available licenses
            UPDATE systems 
            SET available_licenses = available_licenses - 1,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = NEW.system_id AND available_licenses > 0;
            
            -- Update license current users
            IF NEW.license_id IS NOT NULL THEN
                UPDATE system_licenses
                SET current_users = current_users + 1,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = NEW.license_id;
            END IF;
        END IF;
    ELSIF TG_OP = 'DELETE' AND OLD.status = 'active' THEN
        -- Increase available licenses
        UPDATE systems 
        SET available_licenses = available_licenses + 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = OLD.system_id;
        
        -- Update license current users
        IF OLD.license_id IS NOT NULL THEN
            UPDATE system_licenses
            SET current_users = current_users - 1,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = OLD.license_id;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Trigger for user_access
CREATE TRIGGER trg_update_licenses
AFTER INSERT OR UPDATE OR DELETE ON user_access
FOR EACH ROW
EXECUTE FUNCTION update_available_licenses();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER trg_systems_updated_at
BEFORE UPDATE ON systems
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_system_licenses_updated_at
BEFORE UPDATE ON system_licenses
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_user_access_updated_at
BEFORE UPDATE ON user_access
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_access_requests_updated_at
BEFORE UPDATE ON access_requests
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE systems ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_licenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_request_approvals ENABLE ROW LEVEL SECURITY;

-- Systems: Everyone can read, admins can modify
CREATE POLICY systems_select_policy ON systems
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY systems_insert_policy ON systems
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY systems_update_policy ON systems
    FOR UPDATE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY systems_delete_policy ON systems
    FOR DELETE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin');

-- System Licenses: Admins can view/modify
CREATE POLICY licenses_select_policy ON system_licenses
    FOR SELECT
    TO authenticated
    USING (auth.jwt() ->> 'role' IN ('admin', 'it_staff'));

CREATE POLICY licenses_insert_policy ON system_licenses
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY licenses_update_policy ON system_licenses
    FOR UPDATE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY licenses_delete_policy ON system_licenses
    FOR DELETE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin');

-- User Access: Users can see their own, admins see all
CREATE POLICY user_access_select_policy ON user_access
    FOR SELECT
    TO authenticated
    USING (
        user_id = auth.uid() OR 
        auth.jwt() ->> 'role' IN ('admin', 'it_staff', 'manager')
    );

CREATE POLICY user_access_insert_policy ON user_access
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.jwt() ->> 'role' IN ('admin', 'it_staff'));

CREATE POLICY user_access_update_policy ON user_access
    FOR UPDATE
    TO authenticated
    USING (auth.jwt() ->> 'role' IN ('admin', 'it_staff'));

CREATE POLICY user_access_delete_policy ON user_access
    FOR DELETE
    TO authenticated
    USING (auth.jwt() ->> 'role' IN ('admin', 'it_staff'));

-- Access Requests: Users can see their own, approvers see pending
CREATE POLICY access_requests_select_policy ON access_requests
    FOR SELECT
    TO authenticated
    USING (
        requester_id = auth.uid() OR 
        auth.jwt() ->> 'role' IN ('admin', 'manager', 'it_staff')
    );

CREATE POLICY access_requests_insert_policy ON access_requests
    FOR INSERT
    TO authenticated
    WITH CHECK (requester_id = auth.uid());

CREATE POLICY access_requests_update_policy ON access_requests
    FOR UPDATE
    TO authenticated
    USING (
        requester_id = auth.uid() OR 
        auth.jwt() ->> 'role' IN ('admin', 'manager', 'it_staff')
    );

-- Access Request Approvals: Approvers can view/modify their approvals
CREATE POLICY approvals_select_policy ON access_request_approvals
    FOR SELECT
    TO authenticated
    USING (
        approver_id = auth.uid() OR 
        auth.jwt() ->> 'role' IN ('admin', 'manager')
    );

CREATE POLICY approvals_insert_policy ON access_request_approvals
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.jwt() ->> 'role' IN ('admin', 'manager', 'it_staff'));

CREATE POLICY approvals_update_policy ON access_request_approvals
    FOR UPDATE
    TO authenticated
    USING (
        approver_id = auth.uid() OR 
        auth.jwt() ->> 'role' = 'admin'
    );

-- ============================================
-- SAMPLE DATA FOR TESTING
-- ============================================

-- Insert sample systems
INSERT INTO systems (name, description, category, vendor, license_type, total_licenses, available_licenses, cost_per_license, status, requires_approval) VALUES
('Microsoft 365', 'Office productivity suite including Word, Excel, PowerPoint, Teams', 'Productivity', 'Microsoft', 'Per User', 100, 100, 12.50, 'active', false),
('Salesforce CRM', 'Customer relationship management platform', 'CRM', 'Salesforce', 'Per User', 50, 50, 150.00, 'active', true),
('Adobe Creative Cloud', 'Design and creative software suite', 'Design', 'Adobe', 'Per User', 20, 20, 54.99, 'active', true),
('GitHub Enterprise', 'Code hosting and collaboration platform', 'Development', 'GitHub', 'Per User', 75, 75, 21.00, 'active', false),
('Jira Software', 'Project management and issue tracking', 'Project Management', 'Atlassian', 'Per User', 100, 100, 7.00, 'active', false),
('Slack Business', 'Team communication and collaboration', 'Communication', 'Slack', 'Per User', 150, 150, 8.00, 'active', false),
('Zoom Business', 'Video conferencing platform', 'Communication', 'Zoom', 'Site License', 1, 1, 1999.00, 'active', false),
('QuickBooks Enterprise', 'Accounting and financial management', 'Finance', 'Intuit', 'Site License', 1, 1, 1850.00, 'active', true),
('AutoCAD', 'Computer-aided design software', 'Design', 'Autodesk', 'Per User', 10, 10, 220.00, 'active', true),
('Tableau', 'Business intelligence and analytics', 'Analytics', 'Tableau', 'Per User', 25, 25, 70.00, 'active', true);

-- ============================================
-- USEFUL VIEWS
-- ============================================

-- View for system access overview
CREATE OR REPLACE VIEW v_system_access_overview AS
SELECT 
    s.id AS system_id,
    s.name AS system_name,
    s.category,
    s.total_licenses,
    s.available_licenses,
    s.total_licenses - s.available_licenses AS used_licenses,
    ROUND((s.total_licenses - s.available_licenses)::NUMERIC / NULLIF(s.total_licenses, 0) * 100, 2) AS usage_percentage,
    COUNT(ua.id) AS active_users,
    s.renewal_date,
    s.status
FROM systems s
LEFT JOIN user_access ua ON s.id = ua.system_id AND ua.status = 'active'
GROUP BY s.id, s.name, s.category, s.total_licenses, s.available_licenses, s.renewal_date, s.status;

-- View for pending access requests
CREATE OR REPLACE VIEW v_pending_requests AS
SELECT 
    ar.id,
    ar.system_id,
    s.name AS system_name,
    ar.requester_id,
    ar.requester_name,
    ar.requester_department,
    ar.request_type,
    ar.access_level,
    ar.justification,
    ar.urgency,
    ar.submitted_date,
    ar.required_by_date,
    ar.status
FROM access_requests ar
JOIN systems s ON ar.system_id = s.id
WHERE ar.status = 'pending'
ORDER BY 
    CASE ar.urgency
        WHEN 'urgent' THEN 1
        WHEN 'high' THEN 2
        WHEN 'normal' THEN 3
        WHEN 'low' THEN 4
    END,
    ar.submitted_date ASC;

-- View for user access summary
CREATE OR REPLACE VIEW v_user_access_summary AS
SELECT 
    ua.user_id,
    COUNT(ua.id) AS total_systems,
    COUNT(CASE WHEN ua.status = 'active' THEN 1 END) AS active_access,
    COUNT(CASE WHEN ua.status = 'suspended' THEN 1 END) AS suspended_access,
    COUNT(CASE WHEN ua.expiry_date < CURRENT_DATE THEN 1 END) AS expired_access,
    SUM(s.cost_per_license) AS total_license_cost
FROM user_access ua
JOIN systems s ON ua.system_id = s.id
GROUP BY ua.user_id;

-- View for license expiry alerts
CREATE OR REPLACE VIEW v_license_expiry_alerts AS
SELECT 
    s.id AS system_id,
    s.name AS system_name,
    s.vendor,
    s.renewal_date,
    s.contract_end_date,
    CASE 
        WHEN s.renewal_date <= CURRENT_DATE + INTERVAL '30 days' THEN 'critical'
        WHEN s.renewal_date <= CURRENT_DATE + INTERVAL '60 days' THEN 'warning'
        ELSE 'normal'
    END AS alert_level,
    s.renewal_date - CURRENT_DATE AS days_until_renewal,
    s.total_licenses * s.cost_per_license AS renewal_cost
FROM systems s
WHERE s.renewal_date IS NOT NULL 
    AND s.renewal_date >= CURRENT_DATE
    AND s.status = 'active'
ORDER BY s.renewal_date ASC;

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON TABLE systems IS 'Stores software systems/applications available in the organization';
COMMENT ON TABLE system_licenses IS 'Tracks individual license keys and assignments';
COMMENT ON TABLE user_access IS 'Manages user access to systems';
COMMENT ON TABLE access_requests IS 'Handles system access request workflow';
COMMENT ON TABLE access_request_approvals IS 'Multi-level approval tracking for access requests';

-- ============================================
-- COMPLETE!
-- ============================================

-- Verify tables created
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) AS column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    AND table_name IN ('systems', 'system_licenses', 'user_access', 'access_requests', 'access_request_approvals')
ORDER BY table_name;
