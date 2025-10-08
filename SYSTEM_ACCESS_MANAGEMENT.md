# System Access Management - Feature Documentation

## Overview
The System Access Management feature streamlines IT onboarding and system access provisioning for new employees. This comprehensive solution handles everything from employee information collection to system access provisioning and IT asset handover.

## Key Features

### 1. **Employee Onboarding Form**
Capture essential employee information:
- First Name & Last Name
- Employee ID
- Department & Department Head
- Email Address
- Date of Joining

### 2. **System Access Provisioning**

#### Network Access
- Login/Windows/Open access
- Username provisioning

#### Email Access
- Generic Email
- General Email
- Email address creation or Enter ID & Name

#### Oracle Fusion ERP Access
Complete module-wise access management:

**HR Module:**
- Group 1 - DHR
- Group 2 - Vary
- Group 3 - Executive
- Group 4 - Hana Deletion
- Group 5 - PR
- Group 6 - HRM
- ESS User

**Finance Module:**
- AP (Accounts Payable)
- AR (Accounts Receivable)
- Finance Manager
- DIN Finance

**Department Access:**
- Group 1 - Head PCU
- Group 2 - Manager
- Group 3 - Buyer
- Group 4 - Coordinator
- Store
- Receiver
- Request User

### 3. **Time & Attendance System**
- IT Admin Access
- HR Access
- Biometric enrollment
- Card issuance tracking

### 4. **IT Assets Handover**
Track handover of essential IT equipment:
- Laptop
- Desktop
- Mobile
- Non-Camera Mobile
- Walkie Talkie
- Duty SIM Card

## Database Schema

### Main Tables

#### `system_access_requests`
Core table for tracking access requests with employee details and status.

#### `system_access_details`
Stores individual system access requirements (Network, Email, etc.)

#### `oracle_fusion_access`
Dedicated table for Oracle Fusion ERP access permissions across HR, Finance, and Department modules.

#### `it_asset_handover`
Tracks IT assets assigned during onboarding with handover details.

#### `time_attendance_access`
Manages Time & Attendance system access and enrollment status.

#### `access_request_history`
Audit log for all changes and actions on access requests.

## User Interface

### Dashboard View
- Quick stats showing pending access requests
- Recent system access requests widget
- Status indicators (Pending, In Progress, Completed)

### System Access Page
Features:
- Create new access request with comprehensive form
- View all requests with filtering and search
- Status tracking for each request
- System and asset count badges
- Quick actions menu

### Request Status Flow
1. **Pending** - New request awaiting processing
2. **In Progress** - IT team actively provisioning access
3. **Completed** - All systems provisioned and assets handed over
4. **Cancelled** - Request cancelled

## API Endpoints

### System Access Routes (`/api/system-access`)

```
GET    /                          - List all access requests
GET    /:id                       - Get detailed request info
POST   /                          - Create new access request
PATCH  /:id/status               - Update request status
PATCH  /:id/system-access/:sysId - Update system access status
PATCH  /:id/assets/:assetId      - Update asset handover status
GET    /:id/history              - Get request audit history
```

## Implementation Steps

### 1. Database Setup
Run the system access schema:
```bash
psql -U your_user -d your_database -f database/system_access_schema.sql
```

### 2. Backend Integration
The system access routes are already integrated in `server.js`:
```javascript
app.use('/api/system-access', authMiddleware, systemAccessRoutes);
```

### 3. Frontend Access
Navigate to `/system-access` to access the System Access Management page.

## Workflow Example

### New Employee Onboarding Process:

1. **HR/Manager creates access request**
   - Fill in employee details
   - Select required systems (Network, Email, Oracle Fusion, etc.)
   - Select required IT assets (Laptop, Mobile, etc.)
   - Submit request

2. **IT Admin receives notification**
   - Review request details
   - Update status to "In Progress"

3. **IT Team provisions access**
   - Create network login
   - Set up email account
   - Configure Oracle Fusion access with appropriate groups
   - Provision Time & Attendance access

4. **Asset Handover**
   - Assign physical assets (laptop, mobile, etc.)
   - Record serial numbers and condition
   - Mark assets as handed over

5. **Completion**
   - All systems and assets marked as provisioned
   - Request status updated to "Completed"
   - Employee notified

## Benefits

1. **Centralized Management**: Single interface for all onboarding activities
2. **Compliance**: Complete audit trail of all access provisioning
3. **Efficiency**: Streamlined process reduces onboarding time
4. **Visibility**: Real-time status tracking for all stakeholders
5. **Asset Tracking**: Integrated IT asset management
6. **Accountability**: Clear ownership and timeline tracking

## Security Considerations

- Role-based access control (Admin, Manager, User)
- Audit logging for all changes
- Row-level security policies
- Request history for compliance

## Future Enhancements

- Email notifications for request status changes
- Automated provisioning integration with Active Directory
- Mobile app for asset handover with photo capture
- Analytics dashboard for onboarding metrics
- Integration with HRMS systems
- Offboarding workflow (reverse process)

## Support

For questions or issues with System Access Management:
1. Check the audit history for troubleshooting
2. Review system logs in `/backend/logs/`
3. Contact IT Admin team

---

**Last Updated**: October 8, 2025
**Version**: 1.0.0
