# AssetFlow# AssetFlow

## Enterprise Asset & Access Management System## Enterprise Asset & Access Management System - Enterprise Asset Management Tool



> A comprehensive enterprise solution for managing IT assets, system access requests, and employee onboarding with Oracle Fusion ERP integration.A comprehensive enterprise asset management solution built with React/Next.js frontend, Node.js/Express backend, Supabase database, and integrated with Microsoft Azure AD (Entra ID) for authentication and email notifications.



**Built with:** Next.js · React · Node.js · Express · Supabase · PostgreSQL · Azure AD (Entra ID)## 🚀 Features



---### Core Asset Management

- **Asset Registration & Tracking**: Complete asset lifecycle management with detailed information including purchas## Authentication Flow

## 📱 Main Features1. User clicks "Sign in with Microsoft" → MSAL.js hand## Deployment



### 1️⃣ Dashboard### Frontend (Vercel)

Get a complete overview of your organization's assets and requests:1. Connect Gi## Contributing

1. Fork the repository

- 📊 **Total assets** in the system2. Create a feature branch (`git checkout -b feature/new-feature`)

- 🔄 **Active maintenance** tasks tracking3. Commit your changes (`git commit -m 'Add new feature'`)

- 👥 **Pending system access** requests4. Push to the branch (`git push origin feature/new-feature`)

- 📈 **Quick statistics** and real-time charts5. Open a Pull Request

- 🔔 **Recent notifications** and alerts

- 📉 Asset condition distribution---

- 💰 Financial overview (asset values)

## Documentation

---- **Main README**: Project overview and setup instructions (this file)

- **SYSTEM_ACCESS_IMPLEMENTATION.md**: Detailed documentation for System Access module

### 2️⃣ Assets Management- **database/schema.sql**: Complete database schema with RLS policies



**Navigate:** Click "Assets" in the sidebar---



#### 🔍 Browse & Search Assets## Support & Contact

- Browse through complete asset inventoryFor issues, questions, or contributions, please:

- Real-time search functionality- Open an issue on GitHub

- Advanced filtering options:- Submit a pull request

  - **Category**: IT Equipment, Furniture, Office Supplies, etc.- Contact the development team

  - **Location**: Office floor, room, building

  - **Condition**: Excellent, Good, Fair, Poor---

  - **Assignment Status**: Assigned, Available, In Maintenance

  - **Date Range**: Purchase date filtering## License



#### 🧾 Asset InformationMIT License © 2025

Each asset displays comprehensive details:

- 📝 **Name** and detailed description---

- 🏷️ **Category** and location

- 💰 **Purchase cost** and current value## Acknowledgments

- 📅 **Purchase date** and warranty info- Built with Next.js, Express, and Supabase

- 🎯 **Condition status** with visual indicators- Azure AD integration for enterprise authentication

- 👤 **Assigned user** information- Microsoft Graph API for email notifications

- 🔖 **Serial number** and asset tag- Tailwind CSS for modern UI design

- 📸 **Photos** and attachments (if available)

--- Vercel

#### ➕ Adding a New Asset (Admin/Manager Only)2. Configure environment variables in Vercel dashboard:

1. Click **"Add Asset"** button   - `NEXT_PUBLIC_MSAL_CLIENT_ID`

2. Fill in the asset form:   - `NEXT_PUBLIC_MSAL_TENANT_ID`

   - **Name**: What is it? (e.g., "MacBook Pro 16")   - `NEXT_PUBLIC_SUPABASE_URL`

   - **Category**: Select from dropdown   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

   - **Location**: Where is it located?   - `NEXT_PUBLIC_API_URL`

   - **Purchase Date**: When was it bought?3. Deploy Next.js application

   - **Purchase Cost**: Original price4. Custom domain configuration (optional)

   - **Current Value**: Current estimated worth

   - **Condition**: Rate its condition (Excellent/Good/Fair/Poor)### Backend (Vercel/PM2)

   - **Serial Number**: Unique identifier1. Deploy Express backend as Vercel Serverless Functions or use PM2

   - **Assigned To**: Select user (optional)2. Configure environment variables:

   - **Description**: Additional details and notes   - Supabase credentials

3. Click **"Save"**   - Azure AD credentials

4. Asset is now in the system! ✅   - Microsoft Graph API credentials

3. Set up logging and monitoring

#### ✏️ Editing an Asset4. Configure CORS for frontend domain

1. Find the asset in the list

2. Click the **Edit icon** (✏️)### Database (Supabase)

3. Update any information needed1. Create Supabase project

4. Click **"Save Changes"**2. Run schema.sql to create tables

5. Changes are logged in asset history3. Configure Row Level Security (RLS) policies

4. Set up real-time subscriptions (optional)

#### 👤 Assigning Assets to Employees5. Configure storage buckets for file uploads

1. Open the asset details page

2. Click **"Assign"** button---

3. Select the employee from dropdown

4. Click **"Confirm"**## Recent Updates

5. Employee receives automatic notification 📧

6. Assignment is tracked in asset history### October 2025 - System Access Management

- ✅ Added comprehensive System Access Management module

---- ✅ Integrated Forms and Approvals into System Access workflow

- ✅ Implemented Oracle Fusion ERP access tracking

### 3️⃣ System Access Management- ✅ Added IT asset handover management

- ✅ Created employee onboarding workflow

> **Complete employee onboarding solution with Oracle Fusion ERP and IT asset provisioning**- ✅ Streamlined sidebar navigation (removed separate Forms and Approvals)

- ✅ Added Time & Attendance integration support

#### 📝 How to Create a System Access Request- ✅ Implemented priority-based request management



**Navigate:** Click "System Access" in sidebar → Click **"New Access Request"**---gin

2. Entra ID validates credentials and returns ID & access tokens

##### 👤 Employee Details3. Token sent to backend → verified with MSAL Node

Fill in the new employee's information:4. Backend identifies user roles from AD groups

- **First Name**5. Role-based access applied throughout the app

- **Last Name**

- **Employee ID**---

- **Entra ID** (format: `f.lastname@1hospitality.ae`)

- **Department**## Key Features by Module

- **Department Head** name

- **Date of Joining**### 📦 Assets Module

- **Position/Title**- Create, read, update, delete assets

- Advanced search and filtering

##### 💻 System Access Required- Asset assignment to users

- Condition tracking and valuation

**Basic Access:**- Category and location management

- ☑️ **Network Login** (Windows/Entra ID)- Asset history and audit trail

- ☑️ **Email Account**

  - Generic email### 👥 System Access Module (NEW - October 2025)

  - Personal email- **Employee onboarding forms** with complete information capture

- **System access provisioning** (Network, Email, VPN)

**Oracle Fusion ERP Access:**- **Oracle Fusion ERP access management**:

  - HR Module: 7 access groups

📊 **IT Admin Access**  - Finance Module: AP, AR, Finance Manager, DM Finance

- IT Department full administrative access  - Department-specific access

- **IT asset handover tracking** (Laptop, Desktop, Mobile, Walkie Talkie, SIM Card)

👥 **HR Module** (6 groups):- **Request approval workflow** with priority levels

- Group 1: **DHR** (Department HR)- **Access audit trail** for compliance

- Group 2: **HR Manager**- **Time & Attendance** system integration

- Group 3: **Executive**- **Network and email provisioning** automation-ready

- Group 4: **Accommodation**

- Group 5: **Public Relations**### 🔧 Maintenance Module

- Group 6: **Hiring**- Schedule preventive maintenance

- **ESS User** (Employee Self-Service)- Track corrective maintenance

- Cost tracking and reporting

💰 **Finance Module** (4 groups):- Technician assignment

- **AP** (Accounts Payable)- Email reminders via Microsoft Graph API

- **AR** (Accounts Receivable)- Status tracking

- **Finance Manager**

- **DM Finance** (Department Manager Finance)### 👤 Users Module

- User management with Azure AD sync

🛒 **Procurement Module** (5 groups):- Role assignment (Admin, Manager, User)

- Group 3: **Buyer**- Department organization

- Group 4: **Coordinator**- Single Sign-On (SSO)

- Group 5: **Store**

- Group 6: **Receiver**### 📊 Reports Module

- Group 7: **Requestor**- Asset statistics and analytics

- Maintenance cost reports

⏰ **Timetec Time Attendance** (3 groups):- System access reports

- Group 1: **IT Admin**- Export capabilities

- Group 2: **HR Admin**- Visual dashboards

- Group 3: **Dept Coordinator**

---cost, current value, condition, and location

##### 🖥️ IT Assets Needed- **Advanced Search & Filtering**: Search assets by multiple criteria including category, location, condition, and assigned personnel

Select required hardware for the employee:- **Asset Assignment**: Assign assets to specific users and track ownership history

- ☑️ **Laptop** (specify model/specs if needed)- **Condition Monitoring**: Track asset condition with status indicators (excellent, good, fair, poor)

- ☑️ **Desktop** computer- **Asset Categories**: Organize assets by categories (IT Equipment, Office Furniture, Vehicles, etc.)

- ☑️ **Mobile** (with camera)

- ☑️ **Mobile** (non-camera)### System Access Management (NEW - October 2025)

- ☑️ **Walkie Talkie** (for operations staff)- **IT Onboarding & Offboarding**: Streamlined employee onboarding with comprehensive system access provisioning

- ☑️ **Duty SIM Card**- **Employee Information Management**: Track employee ID, name, department, department head, email, and joining date

- **Oracle Fusion ERP Access Management**: 

##### 🎯 Set Priority Level  - HR Module: 7 access groups (HR, Manager, Buyer, Coordinator, Store, Receiver, Requestor)

  - Finance Module: AP, AR, Finance Manager, DM Finance

- 🔴 **High**: Urgent, employee starting today  - Department-specific access control

- 🟡 **Medium**: Standard, 2–3 days turnaround- **Network & Email Access**: 

- 🟢 **Low**: Non-urgent, can wait  - Network login/Windows/VPN provisioning

  - Email accounts (generic, personal, Entra ID integration)

##### 📋 Additional Information  - Email format: f.name@hospital.ae

- Add any **notes** or **special requirements**- **Time & Attendance**: Integration-ready for biometric and attendance systems

- Specify software needs- **IT Asset Handover**: 

- Mention any exceptions or special access  - Laptop assignment and tracking

  - Desktop allocation

##### ✅ Submit  - Mobile device management (with/without camera)

Click **"Submit Request"** → IT department is notified automatically! 📧  - Walkie talkie assignment

  - Duty SIM card tracking

---  - IT Admin access provisioning

  - HR system access

#### 📂 Viewing & Managing Requests- **Access Request Workflow**:

  - Create, view, edit, and track access requests

**Tab Navigation:**  - Approval/rejection workflow with reason tracking

- **All Requests**: View everything  - Status tracking (Pending, In Progress, Approved, Rejected)

- **Pending**: ⏳ Awaiting IT approval  - Priority levels (Low, Medium, High)

- **In Progress**: 🔄 IT is actively working on it- **Unified Forms & Approvals**: All system access forms and approval workflows consolidated in one module

- **Approved**: ✅ Access granted and active- **Access Audit Trail**: Complete history of all access provisioning and modification activities

- **Rejected**: ❌ Denied with reason

### Maintenance Management

**Search & Filter:**- **Maintenance Scheduling**: Schedule preventive and corrective maintenance activities

- 🔍 **Search** by employee name, ID, or department- **Maintenance History**: Complete maintenance records with costs, technician details, and notes

- 📁 **Filter** by:- **Maintenance Reminders**: Automated email notifications for upcoming maintenance

  - Status (pending, approved, rejected)- **Status Tracking**: Track maintenance status (scheduled, in-progress, completed, cancelled)

  - Priority (high, medium, low)- **Cost Tracking**: Monitor maintenance costs and generate cost reports

  - Department

  - Date range### User Management & Authentication

  - Access type required- **Azure AD Integration**: Secure authentication using Microsoft Entra ID (Azure AD)

- **Role-Based Access Control**: Three-tier access control (Admin, Manager, User)

**Request Cards Display:**- **Single Sign-On (SSO)**: Seamless login experience with enterprise credentials

- Request number (e.g., SAR-2025-001)- **User Assignment**: Assign assets to specific users and track responsibility

- Employee name and department

- Priority indicator### Notifications & Communication

- Status badge- **Email Notifications**: Automated maintenance reminders via Microsoft Graph API

- Date submitted- **Real-time Alerts**: In-app notifications for important updates

- Quick action buttons- **Maintenance Reminders**: Proactive notifications for scheduled maintenance



---### Reporting & Analytics

- **Dashboard**: Overview of total assets, maintenance activities, and key metrics

#### 🔄 Request Status Flow- **Asset Statistics**: Visual charts showing asset distribution by category and condition

- **Maintenance Reports**: Track maintenance costs, schedules, and completion rates

```- **Export Capabilities**: Export data for external reporting and analysis

📝 Pending 

    ↓### Technical Features

⏳ In Progress (IT is working on it)- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile devices

    ↓- **Real-time Data**: Live updates using Supabase real-time subscriptions

✅ Approved (Access granted + assets delivered)- **File Attachments**: Upload and manage asset documentation and images

    OR- **Audit Trail**: Complete history of all asset and maintenance activities

❌ Rejected (With detailed reason)- **Data Security**: Enterprise-grade security with row-level security policies

```

## 🛠 Technology Stack

**Status Updates Include:**

- Who changed the status### Frontend

- When it was changed- **Framework**: Next.js 14 with React 18

- Comments or notes- **Styling**: Tailwind CSS for responsive design

- Full audit trail in history- **Authentication**: Azure MSAL (Microsoft Authentication Library)

- **State Management**: React Query for server state management

---- **UI Components**: Lucide React icons

- **Forms**: React Hook Form for form handling

#### 📊 Request Details View

### Backend

Click any request to see full details:- **Runtime**: Node.js with Express.js

- Complete employee information- **Database**: Supabase (PostgreSQL)

- All selected access types- **Authentication**: Azure AD integration with MSAL Node

- IT assets to be provided- **Email Service**: Microsoft Graph API

- Priority and current status- **Logging**: Winston for structured logging

- Assignment history- **Security**: Helmet, CORS, Rate limiting

- Comments and notes- **Validation**: Express Validator

- Status change history

- Approval/rejection reasons### Database

- **Primary Database**: Supabase (PostgreSQL)

**Available Actions (IT Admin):**- **Real-time Features**: Supabase real-time subscriptions

- ✏️ Edit request details- **Security**: Row Level Security (RLS)

- ✅ Approve request- **File Storage**: Supabase Storage for asset images and documents

- ❌ Reject with reason

- 💬 Add comments### DevOps & Deployment

- 📎 Attach documents- **Process Management**: PM2 for production deployment

- 🔄 Change status- **Environment Management**: Docker support

- 👤 Assign to IT staff member- **Monitoring**: Structured logging with Winston

- **Security**: Environment-based configuration

---	•	MSAL.js for frontend authentication

	•	MSAL Node for backend token validation

### 4️⃣ Maintenance Management	•	Role-based access using AD groups (Admin, Manager, User)



Track and manage all asset maintenance activities:4. Forms

	•	Dynamic forms for asset submission

- Schedule preventive maintenance	•	Field validation (required fields, serial number, purchase date)

- Log repair requests	•	Submission triggers approval workflow

- Track maintenance costs

- Service history for each asset5. Notifications

- Vendor management	•	Emails for pending approvals

- Maintenance notifications	•	Notifications to submitters after approval/rejection/changes

- Warranty tracking	•	Optional integration with Microsoft Teams for in-app notifications



---6. Audit Trail

	•	Logs all actions on assets: submission, updates, approvals, rejections

### 5️⃣ Reports & Analytics	•	Tracks who performed the action and when



Generate comprehensive reports:⸻



- Asset inventory reportsGetting Started

- Depreciation calculations

- Assignment historyPrerequisites

- Maintenance cost analysis	•	Node.js (v18+)

- System access audit reports	•	npm or yarn

- Department-wise asset distribution	•	Supabase account + project

- Financial summaries	•	Microsoft Entra ID tenant

- Custom report builder	•	Vercel account for deployment



---⸻



### 6️⃣ User ManagementProject Setup



Manage system users and permissions:1. Clone the repository



- Add/edit/deactivate usersgit clone https://github.com/yourusername/assetflow.git

- Role assignmentcd assetflow

- Department assignment

- Access control2. Install dependencies

- Activity logs

- User profile managementFrontend



---cd frontend

npm install

## 👥 User Roles & Permissions

Backend

### 🔹 Admin

**Full system access** — IT administrators and system managerscd ../backend

npm install

**Capabilities:**

- ✅ Create and manage all assets

- ✅ Approve/reject system access requests⸻

- ✅ Manage users and permissions

- ✅ View all reports and analytics3. Configure Environment Variables

- ✅ Configure system settings

- ✅ Access audit trailsBackend (.env)

- ✅ Manage categories and locations

- ✅ Full database accessPORT=5000

SUPABASE_URL=your_supabase_url

---SUPABASE_KEY=your_supabase_service_key



### 🔹 ManagerMSAL_CLIENT_ID=your_azure_client_id

**Department-level management** — Department heads and team leadsMSAL_TENANT_ID=your_azure_tenant_id

MSAL_CLIENT_SECRET=your_azure_client_secret

**Capabilities:**

- ✅ Create system access requests for their teamGRAPH_API_CLIENT_ID=your_graph_api_client_id

- ✅ View department assetsGRAPH_API_CLIENT_SECRET=your_graph_api_secret

- ✅ Request new assets for departmentGRAPH_API_TENANT_ID=your_azure_tenant_id

- ✅ Approve maintenance activitiesEMAIL_SENDER=your_email@domain.com

- ✅ View department reports

- ✅ Manage team member assignmentsFrontend (.env.local)

- ✅ Track department inventory

- 🚫 Cannot access other departments' data (unless granted)NEXT_PUBLIC_MSAL_CLIENT_ID=your_azure_client_id

NEXT_PUBLIC_MSAL_TENANT_ID=your_azure_tenant_id

---NEXT_PUBLIC_SUPABASE_URL=your_supabase_url

NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key

### 🔹 UserNEXT_PUBLIC_API_URL=https://your-backend.vercel.app

**Standard access** — All employees



**Capabilities:**⸻

- ✅ View assets assigned to them

- ✅ Submit system access requests (with manager approval)4. Running Locally

- ✅ Request maintenance for assigned assets

- ✅ View personal notificationsBackend

- ✅ Update profile information

- ✅ View own request historycd backend

- 🚫 Cannot view other users' assetsnpm run dev

- 🚫 Cannot approve requests

- 🚫 Cannot manage other usersFrontend



---cd frontend

npm run dev

## 🗂️ Excel Inventory Import

Your frontend will be available at http://localhost:3000, backend at http://localhost:5000.

**Location:** Root project folder contains Excel inventory file: `IT Hardware Inventory (3).xlsx`

⸻

### Import Features:

- Bulk import existing assets from ExcelProject Structure

- Automated data validation

- Duplicate detection/assetflow

- Category mapping├─ frontend/                 # React + Next.js frontend

- Location assignment│  ├─ components/            # Reusable UI components

- Asset tag generation│  │  ├─ Layout.tsx          # Main layout wrapper

│  │  └─ Sidebar.tsx         # Navigation sidebar

### Import Process:│  ├─ pages/                 # Next.js pages

1. Prepare Excel file with required columns│  │  ├─ index.tsx           # Dashboard

2. Run import script: `python import_excel_to_supabase.py`│  │  ├─ assets.tsx          # Asset management

3. Review import summary│  │  ├─ system-access.tsx   # System access management (NEW)

4. Verify data in system│  │  ├─ users.tsx           # User management

5. Resolve any conflicts│  │  ├─ reports.tsx         # Reports & analytics

│  │  ├─ settings.tsx        # Application settings

**Available Scripts:**│  │  └─ login.tsx           # Authentication page

- `import_excel_to_supabase.py` - Import to database│  ├─ context/               # Auth and state management

- `preview_excel.py` - Preview data before import│  │  └─ AuthContext.tsx     # Azure AD auth context

- `export_to_csv.py` - Export current inventory│  ├─ utils/                 # Utilities

│  │  └─ supabase.ts         # Supabase client

---│  └─ styles/                # Styling

│     └─ globals.css         # Global styles with Tailwind

## 🚀 Quick Start│

├─ backend/                  # Node.js + Express backend

### Prerequisites│  ├─ src/

- Node.js 18+ (20+ recommended)│  │  ├─ routes/             # API endpoints

- npm or yarn│  │  │  ├─ assets.js        # Asset routes

- Supabase account│  │  │  ├─ systemAccess.js  # System access routes (NEW)

- Azure AD tenant (for SSO)│  │  │  ├─ auth.js          # Authentication routes

- Git│  │  │  ├─ users.js         # User routes

│  │  │  ├─ maintenance.js   # Maintenance routes

### Installation│  │  │  └─ notifications.js # Notification routes

│  │  ├─ services/           # Business logic

1. **Clone the repository**│  │  │  └─ notificationService.js

```bash│  │  ├─ middleware/         # Express middleware

git clone https://github.com/jasimvk/assetflow.git│  │  │  ├─ auth.js          # MSAL token validation

cd assetflow│  │  │  └─ errorHandler.js  # Error handling

```│  │  ├─ config/             # Configuration

│  │  │  ├─ azure.js         # Azure AD config

2. **Install dependencies**│  │  │  └─ database.js      # Supabase config

│  │  ├─ utils/              # Utilities

Frontend:│  │  │  └─ logger.js        # Winston logger

```bash│  │  └─ server.js           # Express app

cd frontend│  ├─ logs/                  # Application logs

npm install│  ├─ ecosystem.config.js    # PM2 configuration

```│  └─ package.json

│

Backend:├─ database/

```bash│  └─ schema.sql             # Database schema

cd backend│

npm install├─ README.md                 # Project documentation

```├─ SYSTEM_ACCESS_IMPLEMENTATION.md  # System Access feature docs (NEW)

└─ package.json

3. **Setup Supabase Database**



Follow the complete guide in `DATABASE_SETUP.md`:⸻

- Create Supabase project

- Execute database schema (`database/supabase_setup.sql`)## Backend API Endpoints

- Configure RLS policies

- Create first admin user### Assets

| Endpoint | Method | Description |

4. **Configure Environment Variables**|----------|--------|-------------|

| /api/assets | GET | Fetch all assets with filtering |

Run the interactive setup:| /api/assets/:id | GET | Get single asset details |

```bash| /api/assets | POST | Create new asset |

./setup-supabase.sh| /api/assets/:id | PUT | Update asset details |

```| /api/assets/:id | DELETE | Delete/retire an asset |



Or manually create:### System Access (NEW)

| Endpoint | Method | Description |

**Frontend** - `frontend/.env.local`:|----------|--------|-------------|

```bash| /api/system-access | GET | Fetch all system access requests |

NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co| /api/system-access/:id | GET | Get single request details |

NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key| /api/system-access | POST | Create new access request |

NEXT_PUBLIC_AZURE_CLIENT_ID=your-azure-client-id| /api/system-access/:id | PUT | Update access request |

NEXT_PUBLIC_AZURE_TENANT_ID=your-azure-tenant-id| /api/system-access/:id | DELETE | Delete access request |

NEXT_PUBLIC_API_BASE_URL=http://localhost:3001| /api/system-access/:id/status | PATCH | Update request status |

```| /api/system-access/:id/approve | PATCH | Approve access request |

| /api/system-access/:id/reject | PATCH | Reject access request |

**Backend** - `backend/.env`:

```bash### Maintenance

NODE_ENV=development| Endpoint | Method | Description |

PORT=3001|----------|--------|-------------|

| /api/maintenance | GET | Fetch maintenance records |

SUPABASE_URL=https://your-project.supabase.co| /api/maintenance/:id | GET | Get maintenance details |

SUPABASE_SERVICE_ROLE_KEY=your-service-role-key| /api/maintenance | POST | Create maintenance record |

SUPABASE_ANON_KEY=your-anon-key| /api/maintenance/:id | PUT | Update maintenance record |



AZURE_CLIENT_ID=your-azure-client-id### Users & Authentication

AZURE_CLIENT_SECRET=your-azure-client-secret| Endpoint | Method | Description |

AZURE_TENANT_ID=your-azure-tenant-id|----------|--------|-------------|

| /api/users | GET | Fetch all users |

FRONTEND_URL=http://localhost:3000| /api/auth/login | POST | Azure AD authentication |

```| /api/auth/logout | POST | User logout |



5. **Test Database Connection**

⸻

Backend:

```bash## Navigation Structure

cd backend

node test-db.jsAssetFlow features a streamlined, role-based navigation:

```

### Main Navigation (Sidebar)

Frontend:1. **Dashboard** - Overview of assets, maintenance, and system access metrics

```bash2. **Assets** - Complete asset lifecycle management

cd frontend3. **System Access** - IT onboarding, access provisioning, forms, and approvals (NEW)

npm install dotenv  # first time only4. **Users** - User management and role assignment

node test-db.js5. **Reports** - Analytics and reporting tools

```6. **Settings** - Application configuration



6. **Start Development Servers**> **Note**: Forms and Approvals have been consolidated into the **System Access** module for better workflow management.



Terminal 1 - Backend:---

```bash

cd backend## System Access Workflow (NEW)

npm start

```### New Employee Onboarding Process:

1. **Request Creation**

Terminal 2 - Frontend:   - HR/Manager creates system access request

```bash   - Fills in employee details (name, ID, department, email, joining date)

cd frontend   - Selects required system access (network, email, Oracle Fusion)

npm run dev   - Specifies IT assets needed (laptop, mobile, etc.)

```

2. **IT Review**

7. **Access the Application**   - IT Admin reviews request

- Frontend: http://localhost:3000   - Verifies asset availability

- Backend API: http://localhost:3001   - Checks access requirements

- Login with Azure AD credentials

3. **Approval Process**

---   - IT Admin approves/rejects with comments

   - Priority assignment (High, Medium, Low)

## 🏗️ Technology Stack   - Status tracking (Pending → In Progress → Approved/Rejected)



### Frontend4. **Provisioning** (Upon Approval)

- **Framework**: Next.js 14 (React 18)   - Network login credentials created

- **Language**: TypeScript   - Email account provisioned (f.name@hospital.ae)

- **Styling**: Tailwind CSS   - Oracle Fusion ERP access granted:

- **UI Components**: Custom glassmorphism design     - HR Module groups (7 groups)

- **Icons**: Lucide React     - Finance Module groups (AP, AR, etc.)

- **State Management**: React Hooks, Context API     - Department-specific access

- **Forms**: React Hook Form   - IT assets assigned and tracked

- **Authentication**: @azure/msal-browser, @azure/msal-react   - Time & Attendance system setup

- **API Client**: Axios, @supabase/supabase-js   - ESS User access configured



### Backend5. **Notifications**

- **Runtime**: Node.js 18+   - Request creator notified of status updates

- **Framework**: Express.js   - IT Admin receives new request alerts

- **Language**: JavaScript (ES6+)   - Department head notified of approval

- **Database Client**: @supabase/supabase-js   - Complete audit trail maintained

- **Authentication**: @azure/msal-node

- **Email**: @microsoft/microsoft-graph-client---

- **Logging**: Winston

- **Security**: Helmet, CORS, express-rate-limit## Approval Workflow

- **File Upload**: Multer	1.	User submits asset form → Status: Pending Approval

- **Validation**: express-validator	2.	Backend identifies approvers based on asset type, cost, or department

	3.	Emails sent to approvers via Microsoft Graph API

### Database	4.	Approver submits decision → backend updates asset status

- **Platform**: Supabase (PostgreSQL)	5.	Submitter receives notification with the outcome

- **ORM**: Direct SQL with Supabase client	6.	Audit trail updated for all actions

- **Security**: Row Level Security (RLS)

- **Features**: ⸻

  - Auto-generated UUIDs

  - Triggers for audit logging## Supabase Database Tables

  - Views for reporting

  - Real-time subscriptions### Assets

  - Full-text search| Column | Type | Description |

|--------|------|-------------|

### DevOps & Tools| id | UUID | Primary Key |

- **Version Control**: Git, GitHub| name | VARCHAR(255) | Asset name |

- **Package Manager**: npm| category | VARCHAR(100) | Asset category |

- **Process Manager**: PM2 (backend)| serial_number | VARCHAR(100) | Unique serial number |

- **Import Tools**: Python 3 (pandas, openpyxl)| location | VARCHAR(255) | Physical location |

- **Testing**: Manual testing scripts| purchase_date | DATE | Date of purchase |

| purchase_cost | DECIMAL | Original cost |

---| current_value | DECIMAL | Current value |

| condition | ENUM | excellent, good, fair, poor |

## 📚 Documentation| assigned_to | UUID | Foreign key → Users.id |

| created_at | TIMESTAMP | Auto-generated |

| Document | Description || updated_at | TIMESTAMP | Auto-updated |

|----------|-------------|

| `README.md` | This file - Project overview and setup |### System Access Requests (NEW)

| `DATABASE_SETUP.md` | Complete Supabase setup guide || Column | Type | Description |

| `SUPABASE_TESTING_GUIDE.md` | Database connection testing ||--------|------|-------------|

| `CLIENT_README.md` | User guide (559 lines) || id | UUID | Primary Key |

| `QUICK_REFERENCE_CARD.md` | Printable quick reference || employee_id | VARCHAR(50) | Unique employee ID |

| `SYSTEM_ACCESS_IMPLEMENTATION.md` | Technical implementation details || first_name | VARCHAR(100) | Employee first name |

| `SYSTEM_ACCESS_MANAGEMENT.md` | System access feature guide || last_name | VARCHAR(100) | Employee last name |

| `QUICK_START_SYSTEM_ACCESS.md` | Quick start for system access || email | VARCHAR(255) | Employee email |

| `IMPLEMENTATION_CHECKLIST.md` | Feature checklist || department | VARCHAR(100) | Department name |

| `DOCUMENTATION_INDEX.md` | Complete documentation index || department_head | VARCHAR(255) | Department head name |

| date_of_joining | DATE | Joining date |

---| network_access | BOOLEAN | Network login access |

| email_access | JSONB | Email access details |

## 🗄️ Database Schema| oracle_fusion_access | JSONB | ERP access details |

| ess_user | BOOLEAN | ESS User access |

### Core Tables (12 total)| assigned_assets | JSONB | IT assets assigned |

| status | VARCHAR(50) | pending, approved, rejected, in_progress |

1. **users** - Employee accounts and authentication| priority | VARCHAR(20) | low, medium, high |

2. **categories** - Asset categories (8 pre-populated)| requested_by | UUID | Foreign key → Users.id |

3. **locations** - Office locations (5 pre-populated)| approved_by | UUID | Foreign key → Users.id |

4. **assets** - IT hardware inventory| approved_at | TIMESTAMP | Approval timestamp |

5. **maintenance_records** - Service and repair history| rejection_reason | TEXT | Reason for rejection |

6. **asset_history** - Asset assignment audit trail| notes | TEXT | Additional notes |

7. **asset_attachments** - Documents and images| created_at | TIMESTAMP | Auto-generated |

8. **maintenance_attachments** - Service receipts| updated_at | TIMESTAMP | Auto-updated |

9. **system_access_requests** - Employee onboarding requests

10. **system_access_history** - Request status changes### Maintenance Records

11. **system_access_assets** - Asset handover tracking| Column | Type | Description |

12. **notifications** - System alerts and messages|--------|------|-------------|

| id | UUID | Primary Key |

### Automatic Features| asset_id | UUID | Foreign key → Assets.id |

- ✅ UUID primary keys| maintenance_type | VARCHAR(100) | Type of maintenance |

- ✅ Auto-timestamps (created_at, updated_at)| scheduled_date | TIMESTAMP | Scheduled date |

- ✅ Request number generation (SAR-YYYY-NNN)| completed_date | TIMESTAMP | Completion date |

- ✅ Audit logging triggers| status | ENUM | scheduled, in_progress, completed, cancelled |

- ✅ 22 performance indexes| cost | DECIMAL | Maintenance cost |

- ✅ 3 reporting views| technician_name | VARCHAR(255) | Technician name |

- ✅ Row Level Security (RLS) policies| notes | TEXT | Additional notes |

| created_at | TIMESTAMP | Auto-generated |

---

### Users

## 🔒 Security Features| Column | Type | Description |

|--------|------|-------------|

- **Azure AD Integration**: Enterprise SSO with Entra ID| id | UUID | Primary Key |

- **Row Level Security**: Database-level access control| email | VARCHAR(255) | User email (unique) |

- **Role-Based Access**: Admin, Manager, User roles| name | VARCHAR(255) | Full name |

- **API Authentication**: JWT tokens| role | ENUM | admin, manager, user |

- **HTTPS Required**: Production enforces SSL| department | VARCHAR(100) | Department |

- **CORS Protection**: Whitelisted origins only| azure_user_id | VARCHAR(255) | Azure AD user ID |

- **Rate Limiting**: API request throttling| created_at | TIMESTAMP | Auto-generated |

- **Input Validation**: Server-side validation| updated_at | TIMESTAMP | Auto-updated |

- **SQL Injection Protection**: Parameterized queries

- **Audit Trails**: Complete activity logging

⸻

---

Authentication Flow

## 🚀 Deployment	1.	User clicks “Sign in with Microsoft” → MSAL.js handles login

	2.	Entra ID validates credentials and returns ID & access tokens

### Frontend (Vercel)	3.	Token sent to backend → verified with MSAL Node

1. Connect GitHub repository	4.	Backend identifies user roles from AD groups

2. Configure environment variables in Vercel dashboard	5.	Role-based access applied throughout the app

3. Deploy automatically on push to main

4. Custom domain setup (optional)⸻



### Backend (VPS/Cloud)Email Notifications via Microsoft Graph API

1. Set up Node.js server	•	Sends approval requests to approvers

2. Install PM2: `npm install -g pm2`	•	Submitters receive outcome notifications

3. Configure environment variables	•	Graph API integration ensures emails are sent via corporate accounts

4. Start with PM2: `pm2 start ecosystem.config.js`

5. Setup nginx reverse proxyExample workflow:

6. Enable SSL with Let's Encrypt

POST /assets/:id/approve

### Database (Supabase)Backend sends Graph API email to:

- Already cloud-hosted- Approver (on submission)

- Automatic backups- Submitter (after decision)

- Point-in-time recovery

- Global CDN

- Real-time subscriptions⸻



---Deployment

	•	Frontend: Vercel → connect GitHub repo, deploy Next.js app

## 📊 Recent Updates	•	Backend: Vercel Functions → host Express APIs

	•	Environment variables configured in Vercel dashboard

### November 2025 - Database Testing

- ✅ Created comprehensive test scripts⸻

- ✅ Frontend and backend connection tests

- ✅ Interactive Supabase setup scriptContributing

- ✅ Complete testing documentation	1.	Fork the repository

	2.	Create a feature branch (git checkout -b feature/xyz)

### October 2025 - System Access Management	3.	Commit changes (git commit -m "Add new feature")

- ✅ Full System Access Management module (1,145 lines)	4.	Push to branch (git push origin feature/xyz)

- ✅ Oracle Fusion ERP integration (27 access groups)	5.	Open a Pull Request

- ✅ IT asset handover workflow (6 asset types)

- ✅ Employee onboarding automation⸻

- ✅ Priority-based request system (High/Medium/Low)

- ✅ Status workflow (Pending → In Progress → Approved/Rejected)License

- ✅ Auto-generated request numbers (SAR-YYYY-001)

- ✅ Complete audit trail with history trackingMIT License © 2025 – Your Name

- ✅ Streamlined navigation (removed separate Forms/Approvals)

- ✅ 18 documentation files (150+ pages)⸻

- ✅ Build successful (0 errors)

I can also create a Copilot-ready folder structure with stub files, API routes, MSAL auth templates, and Graph API email functions, so you can literally start coding without writing boilerplate.

---

Do you want me to create that next?
## 🤝 Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Development Guidelines
- Follow existing code style
- Add comments for complex logic
- Update documentation
- Test thoroughly before PR
- Keep commits atomic and descriptive

---

## 📞 Support

For help and support:

- 📖 Check documentation files
- 🐛 Report bugs via GitHub Issues
- 💬 Contact IT department
- 📧 Email: support@1hospitality.ae

**Troubleshooting Resources:**
- `SUPABASE_TESTING_GUIDE.md` - Database connection issues
- `DATABASE_SETUP.md` - Setup problems
- `CLIENT_README.md` - User guide and FAQ

---

## 📄 License

MIT License © 2025 AssetFlow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.

---

## 🙏 Acknowledgments

- **Built with**: Next.js, Express, Supabase, PostgreSQL
- **Authentication**: Microsoft Azure AD (Entra ID)
- **UI Design**: Tailwind CSS with custom glassmorphism
- **Icons**: Lucide React
- **Notifications**: Microsoft Graph API
- **Community**: Open source contributors

---

## 📈 System Statistics

- **Total Code**: ~3,000+ lines
- **Documentation**: 150+ pages (18 files)
- **Database Tables**: 12 tables
- **Views**: 3 reporting views
- **Triggers**: 2 automatic triggers
- **RLS Policies**: 9 security policies
- **Features**: 6 major modules
- **User Roles**: 3 permission levels
- **Oracle Fusion Groups**: 27 access groups
- **IT Asset Types**: 6 categories

---

**Version**: 1.0  
**Last Updated**: November 15, 2025  
**Status**: ✅ Production Ready

---

Made with ❤️ for enterprise asset management
