# Quick Start Guide - System Access Management

## Overview
The System Access Management module streamlines employee onboarding, system provisioning, and IT asset handover.

## Accessing the Module
Navigate to: **System Access** from the sidebar menu (orange icon with UserPlus)

## Main Features

### 1️⃣ Create New Access Request
Click the **"New Access Request"** button to create a request for a new employee.

#### Employee Information
- **First Name**: Employee's first name
- **Last Name**: Employee's last name
- **Employee ID**: Unique identifier
- **Email**: Format: f.name@hospital.ae
- **Department**: Select from dropdown
- **Department Head**: Name of the department head
- **Date of Joining**: Employee's start date

#### System Access
- ☑️ **Network Access**: Login/Windows/VPN access
- ☑️ **Email Access**:
  - Generic email
  - Personal email
  - Entra ID integration
- ☑️ **Oracle Fusion ERP**:
  - **HR Module**: 7 groups (HR, Manager, Buyer, Coordinator, Store, Receiver, Requestor)
  - **Finance Module**: AP, AR, Finance Manager, DM Finance
- ☑️ **ESS User**: Employee Self-Service access
- ☑️ **Time & Attendance**: Biometric enrollment

#### IT Assets
Select which assets to assign:
- 💻 Laptop
- 🖥️ Desktop
- 📱 Mobile (with camera)
- 📱 Mobile (non-camera)
- 📻 Walkie Talkie
- 📞 Duty SIM Card
- 🔐 IT Admin Access
- 👔 HR Access

### 2️⃣ View Requests
Use the tabs to filter requests:
- **All Requests**: View all access requests
- **Pending**: Awaiting approval
- **Approved**: Approved requests
- **Rejected**: Rejected requests

### 3️⃣ Search & Filter
- 🔍 **Search**: By employee name, ID, or department
- 📁 **Filter**: By status, priority, or department

### 4️⃣ Manage Requests

#### View Details
Click the eye icon (👁️) to view full request details.

#### Approve/Reject
- Click **Approve** to grant access
- Click **Reject** and provide a reason

#### Edit Request
Click the edit icon (✏️) to modify pending requests.

#### Export
Click **Export** to download request data.

## Request Status Flow

```
Pending → In Progress → Approved
                     ↘ Rejected
```

## Priority Levels
- 🔴 **High**: Urgent access needed (new joiners starting today)
- 🟡 **Medium**: Standard processing (within 2-3 days)
- 🟢 **Low**: Non-urgent requests

## Best Practices

### For HR/Managers
1. Submit access requests **at least 3 days** before joining date
2. Verify employee details before submission
3. Select only required system access to maintain security
4. Include department head name for approval chain
5. Set appropriate priority level

### For IT Admins
1. Review requests daily
2. Verify asset availability before approval
3. Provide clear rejection reasons
4. Update status to "In Progress" when provisioning
5. Complete asset assignment before final approval
6. Document any special configurations in notes

### For Security
- Follow principle of least privilege
- Audit access logs regularly
- Review and revoke unnecessary permissions
- Maintain documentation of all access grants

## Common Workflows

### New Employee Onboarding
1. HR creates access request 3 days before joining
2. IT Admin reviews and approves
3. IT provisions:
   - Network login credentials
   - Email account (f.name@hospital.ae)
   - Oracle Fusion access
   - Assigns laptop/desktop
4. Employee receives credentials on Day 1
5. Time & Attendance enrollment completed

### Employee Transfer
1. Create new access request with updated department
2. Specify changed access requirements
3. IT Admin removes old department access
4. IT Admin grants new department access
5. Asset reassignment (if needed)

### Employee Exit
1. Create exit checklist (future feature)
2. Revoke all system access
3. Collect IT assets
4. Archive access records
5. Generate exit report

## Notifications
- 📧 **Email**: Sent for new requests, approvals, rejections
- 🔔 **In-app**: Real-time notifications for status changes
- 📊 **Reports**: Daily/weekly access reports

## Troubleshooting

### Request Not Appearing
- Check active tab (Pending vs All)
- Verify search filters are not active
- Refresh the page

### Cannot Approve Request
- Verify you have Admin/Manager role
- Check if request is still in "Pending" status
- Ensure asset availability

### Email Format Error
- Use format: firstname.lastname@hospital.ae
- Only lowercase letters
- No special characters except period

## Security Notes
- All actions are logged with timestamp and user
- Requests cannot be deleted, only rejected
- Asset assignments are tracked in Asset module
- Access grants require approval workflow
- Audit trail maintained for compliance

## Integration Status
- ✅ Asset Management System
- ✅ User Authentication (Azure AD)
- ✅ Email Notifications
- ⏳ Oracle Fusion ERP API (Ready)
- ⏳ Active Directory Automation (Ready)
- ⏳ Time & Attendance System (Ready)

## Keyboard Shortcuts
- `Ctrl/Cmd + N`: New Request
- `Ctrl/Cmd + F`: Focus Search
- `Escape`: Close Modal
- `Tab`: Navigate Form Fields

## Mobile Access
The System Access module is fully responsive and works on:
- 📱 Mobile phones
- 📱 Tablets
- 💻 Desktops
- 🖥️ Large displays

## Need Help?
- Check the main README.md for setup instructions
- Review SYSTEM_ACCESS_IMPLEMENTATION.md for technical details
- Contact IT Admin team for access issues
- Open GitHub issue for bugs or feature requests

---

**Last Updated**: October 8, 2025
**Version**: 1.0.0
