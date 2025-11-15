# AssetFlow - User Guide

**Enterprise Asset & Access Management System**

Version 1.0 | October 2025

---

## 🎯 What is AssetFlow?

AssetFlow is your organization's comprehensive solution for managing:
- 📦 **Physical Assets** (laptops, desktops, furniture, equipment)
- 👥 **System Access** (new employee onboarding, IT provisioning)
- 🔧 **Maintenance** (scheduling, tracking, cost management)
- 📊 **Reporting** (analytics, insights, compliance)

---

## 🚀 Getting Started

### Accessing AssetFlow

1. **Open your web browser** (Chrome, Safari, Edge, or Firefox)
2. **Navigate to**: [Your AssetFlow URL]
3. **Click "Sign In with Microsoft"**
4. **Use your company email** and password (Azure AD credentials)
5. You're in! 🎉

### First Login

When you log in for the first time:
- ✅ Your account is automatically created
- ✅ Your role is assigned based on your department
- ✅ You'll see the Dashboard with an overview of the system

---

## 👥 User Roles

### 🔹 Admin
**Full system access** - IT administrators and system managers
- Create and manage all assets
- Approve/reject system access requests
- Manage users and permissions
- View all reports and analytics
- Configure system settings

### 🔹 Manager
**Department-level management** - Department heads and team leads
- Create system access requests for their team
- View department assets
- Request new assets
- Approve maintenance activities
- View department reports

### 🔹 User
**Standard access** - All employees
- View assets assigned to them
- Submit system access requests
- Request maintenance
- View personal notifications
- Update profile information

---

## 📱 Main Features

### 1️⃣ Dashboard

**Your home page** - Get a quick overview of everything

**What you'll see:**
- 📊 Total assets in the system
- 🔄 Active maintenance tasks
- 👥 Pending system access requests
- 📈 Quick statistics and charts
- 🔔 Recent notifications

**How to use it:**
- Click on any metric card to see details
- Check notifications regularly for updates
- Use the quick action buttons to navigate

---

### 2️⃣ Assets Management

**Track and manage all physical assets**

#### Viewing Assets
1. Click **"Assets"** in the sidebar
2. Browse through the asset list
3. Use search to find specific items
4. Filter by:
   - Category (IT Equipment, Furniture, etc.)
   - Location (Office floor, room)
   - Condition (Excellent, Good, Fair, Poor)
   - Assignment status

#### Asset Information
Each asset shows:
- 📝 Name and description
- 🏷️ Category and location
- 💰 Purchase cost and current value
- 📅 Purchase date
- 🎯 Condition status
- 👤 Who it's assigned to
- 📸 Photos (if available)

#### Adding a New Asset (Admin/Manager)
1. Click **"Add Asset"** button
2. Fill in the form:
   - **Name**: What is it? (e.g., "MacBook Pro 16")
   - **Category**: Select from dropdown
   - **Location**: Where is it located?
   - **Purchase Date**: When was it bought?
   - **Purchase Cost**: Original price
   - **Current Value**: Current worth
   - **Condition**: Rate its condition
   - **Serial Number**: Unique identifier
   - **Assigned To**: Select user (optional)
   - **Description**: Additional details
3. Click **"Save"**
4. Asset is now in the system! ✅

#### Editing an Asset
1. Find the asset in the list
2. Click the **Edit** icon (✏️)
3. Update the information
4. Click **"Save Changes"**

#### Assigning Assets
1. Open the asset details
2. Click **"Assign"**
3. Select the employee from dropdown
4. Click **"Confirm"**
5. Employee will be notified 📧

---

### 3️⃣ System Access Management

**Handle employee onboarding and IT provisioning**

This is where HR and IT manage new employee access to systems and equipment.

#### Creating a System Access Request

**When to use:**
- New employee joining
- Employee changing departments
- Additional system access needed

**How to create:**
1. Click **"System Access"** in sidebar
2. Click **"New Access Request"** button
3. Fill in the employee information:

   **👤 Employee Details:**
   - First Name
   - Last Name
   - Employee ID
   - Email (format: firstname.lastname@hospital.ae)
   - Department
   - Department Head name
   - Date of Joining

   **💻 System Access Required:**
   - ☑️ Network Login (Windows/VPN)
   - ☑️ Email Account
     - Generic email
     - Personal email  
     - Entra ID
   - ☑️ Oracle Fusion ERP Access
     - **HR Module**: 
       - Group 1: HR
       - Group 2: Manager
       - Group 3: Buyer
       - Group 4: Coordinator
       - Group 5: Store
       - Group 6: Receiver
       - Group 7: Requestor
     - **Finance Module**:
       - AP (Accounts Payable)
       - AR (Accounts Receivable)
       - Finance Manager
       - DM Finance
   - ☑️ ESS User (Employee Self-Service)
   - ☑️ Time & Attendance

   **🖥️ IT Assets Needed:**
   - ☑️ Laptop
   - ☑️ Desktop
   - ☑️ Mobile (with camera)
   - ☑️ Mobile (non-camera)
   - ☑️ Walkie Talkie
   - ☑️ Duty SIM Card
   - ☑️ IT Admin Access
   - ☑️ HR Access

4. Set **Priority**:
   - 🔴 High (urgent, starting today)
   - 🟡 Medium (standard, 2-3 days)
   - 🟢 Low (non-urgent)

5. Add any **notes** or special requirements

6. Click **"Submit Request"**

7. IT will be notified automatically! 📧

#### Viewing Requests

**Use the tabs to filter:**
- **All Requests**: See everything
- **Pending**: Awaiting IT approval
- **Approved**: Access granted
- **Rejected**: Denied with reason

**Search & Filter:**
- 🔍 Search by employee name, ID, or department
- 📁 Filter by status, priority, department

#### Request Status Flow

```
📝 Pending
    ↓
⏳ In Progress (IT is working on it)
    ↓
✅ Approved (Access granted)
    OR
❌ Rejected (With reason why)
```

#### What Happens After Approval?

When IT approves your request:
1. ✅ Network login credentials are created
2. ✅ Email account is set up (firstname.lastname@hospital.ae)
3. ✅ Oracle Fusion access is granted
4. ✅ IT assets are assigned
5. ✅ Employee receives all login details
6. ✅ You get a notification confirming everything is ready

---

 

### 4 Users Management

**View and manage user accounts** (Admin only)

#### What You Can Do:
- View all users in the organization
- See user roles and departments
- Assign roles (Admin, Manager, User)
- Update user information
- Deactivate accounts

#### User Information:
- Full name
- Email address
- Department
- Role
- Last login date
- Assets assigned to them

---

### 6️⃣ Reports & Analytics

**Get insights and export data**

#### Available Reports:
- 📊 **Asset Statistics**
  - Total assets by category
  - Assets by location
  - Condition breakdown
  - Value distribution

- 🔧 **Maintenance Reports**
  - Scheduled vs completed
  - Maintenance costs
  - Technician performance
  - Overdue maintenance

- 👥 **System Access Reports**
  - Onboarding metrics
  - Average approval time
  - Access by department
  - Asset handover tracking

- 💰 **Financial Reports**
  - Asset valuations
  - Depreciation tracking
  - Maintenance costs
  - Budget utilization

#### Exporting Data:
1. Navigate to the report you want
2. Click **"Export"** button
3. Choose format (CSV, Excel, PDF)
4. File downloads to your computer

---

## 🔔 Notifications

### Types of Notifications:

**🟢 Success**
- Asset created successfully
- Request approved
- Maintenance completed

**🟡 Warning**
- Upcoming maintenance
- Asset condition declining
- Approval pending

**🔴 Urgent**
- Asset requires immediate attention
- Maintenance overdue
- Critical system updates

### Managing Notifications:
- Click the bell icon (🔔) in the top right
- See all recent notifications
- Click to mark as read
- Click notification to view details

---

## 💡 Tips & Best Practices

### For Everyone:
✅ **Check Dashboard daily** for updates and alerts
✅ **Keep asset information updated** - report changes immediately
✅ **Respond to notifications promptly** - especially approval requests
✅ **Use search** to find things quickly instead of scrolling
✅ **Report issues early** - don't wait until equipment fails

### For HR & Managers:
✅ **Submit access requests 3 days before** employee joining date
✅ **Double-check employee details** before submitting
✅ **Select only necessary access** - follow principle of least privilege
✅ **Update department head information** regularly
✅ **Set appropriate priority levels** - don't mark everything as urgent

### For IT Admins:
✅ **Review pending requests daily**
✅ **Provide clear rejection reasons** to help requesters
✅ **Update request status** (Pending → In Progress → Approved)
✅ **Complete asset assignments** before marking approved
✅ **Document special configurations** in notes field
✅ **Run regular reports** for compliance and auditing

---

## 📱 Mobile Access

AssetFlow works perfectly on your mobile device!

**Access from:**
- 📱 iPhone/iPad (Safari)
- 📱 Android phones/tablets (Chrome)
- 💻 Tablets (any browser)

**Mobile Features:**
- View all assets on the go
- Create system access requests
- Approve/reject requests
- Receive push notifications
- Scan asset QR codes (future feature)

---

## 🔐 Security & Privacy

### Your Data is Safe:
- 🔒 **Enterprise-grade security** with Microsoft Azure
- 🔒 **Role-based access** - you only see what you need
- 🔒 **Encrypted connections** (HTTPS)
- 🔒 **Audit trails** - all actions are logged
- 🔒 **Regular backups** - data is never lost

### Password & Login:
- Use your **Microsoft account** - same as your work email
- **Never share** your login credentials
- Enable **two-factor authentication** for extra security
- **Log out** when using shared computers

---

## ❓ Frequently Asked Questions (FAQ)

### General Questions

**Q: How do I log in?**
A: Click "Sign In with Microsoft" and use your work email and password.

**Q: I forgot my password. What do I do?**
A: Use Microsoft's password reset - this is your work account password, not AssetFlow-specific.

**Q: Can I access AssetFlow from home?**
A: Yes! Access from anywhere with internet. Your work credentials are required.

**Q: Does AssetFlow work on mobile?**
A: Yes! It's fully responsive and works on all devices.

### Assets

**Q: How do I find an asset?**
A: Use the search bar or filters on the Assets page.

**Q: Can I add photos to assets?**
A: Yes (Admin/Manager only). Click Edit → Upload Image.

**Q: What if an asset breaks?**
A: Request maintenance immediately through the asset's page.

**Q: Who can create new assets?**
A: Admins and Managers only. Users can view and request.

### System Access

**Q: How long does IT take to approve access requests?**
A: Usually 2-3 business days. Mark as High priority if urgent.

**Q: Can I request access for someone else?**
A: Yes, Managers can request access for their team members.

**Q: What if my request is rejected?**
A: Check the rejection reason. You can create a new request addressing the issues.

**Q: Can I edit a request after submitting?**
A: Yes, but only if it's still "Pending". Contact IT if already in progress.

**Q: What's the email format?**
A: firstname.lastname@hospital.ae (all lowercase, no special characters except period)

### Maintenance

**Q: How do I report a broken asset?**
A: Go to the asset → Request Maintenance → Describe the issue.

**Q: Who handles maintenance requests?**
A: IT department for tech equipment, Facilities for furniture/building items.

**Q: Can I see maintenance history?**
A: Yes, view the asset details to see all past maintenance.

### Permissions

**Q: Why can't I create assets?**
A: This requires Manager or Admin role. Contact your supervisor.

**Q: How do I get elevated permissions?**
A: Request role change through your department head or IT admin.

**Q: Can I see other departments' assets?**
A: Admins see everything. Managers see their department. Users see assigned assets.

---

## 🆘 Need Help?

### Getting Support

**1. Check this guide first** - Most questions are answered here

**2. Contact IT Support:**
   - 📧 Email: itsupport@hospital.ae
   - 📞 Phone: [IT Helpdesk Number]
   - 💬 Teams: IT Support Channel

**3. For urgent issues:**
   - System down or not accessible
   - Security concerns
   - Data loss
   - Critical asset failures

**4. For general questions:**
   - How to use a feature
   - Best practices
   - Training requests
   - Feature suggestions

### When Contacting Support:

Please provide:
- Your name and employee ID
- What you were trying to do
- What happened (error message, unexpected behavior)
- Screenshots (if applicable)
- Your role (Admin, Manager, User)

---

 

## 📋 Quick Reference

### Common Actions

| What You Want to Do | How to Do It |
|---------------------|--------------|
| View all assets | Sidebar → Assets |
| Search for an asset | Assets page → Search bar |
| Create access request | System Access → New Request |
| Approve a request | System Access → Pending → Approve |
| Request maintenance | Asset details → Request Maintenance |
| View notifications | Click bell icon (🔔) |
| Export data | Reports → Export button |
| Update your profile | Settings → Profile |
| Log out | Click profile → Log out |

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl/Cmd + N` | New Request |
| `Ctrl/Cmd + F` | Focus Search |
| `Ctrl/Cmd + S` | Save Form |
| `Escape` | Close Modal |
| `Tab` | Navigate Fields |

---

 

## ✅ Checklist for New Users

**Your first week with AssetFlow:**

- [ ] Log in successfully with Microsoft account
- [ ] Explore the Dashboard
- [ ] Find your assigned assets
- [ ] Update your profile information
- [ ] Test the search function
- [ ] Create a test access request (if you're a manager)
- [ ] Check notifications
- [ ] Explore reports
 

**Congratulations! You're now an AssetFlow pro! 🎉**

---

**AssetFlow** - Making asset and access management simple and efficient.

*Last Updated: October 8, 2025*
*Version: 1.0.0*

---

© 2025 Jasim. All rights reserved.
