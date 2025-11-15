# AssetFlow
## Enterprise Asset & Access Management System - Enterprise Asset Management Tool

A comprehensive enterprise asset management solution built with React/Next.js frontend, Node.js/Express backend, Supabase database, and integrated with Microsoft Azure AD (Entra ID) for authentication and email notifications.

## 🚀 Features

### Core Asset Management
- **Asset Registration & Tracking**: Complete asset lifecycle management with detailed information including purchas## Authentication Flow
1. User clicks "Sign in with Microsoft" → MSAL.js hand## Deployment

### Frontend (Vercel)
1. Connect Gi## Contributing
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

---

## Documentation
- **Main README**: Project overview and setup instructions (this file)
- **SYSTEM_ACCESS_IMPLEMENTATION.md**: Detailed documentation for System Access module
- **database/schema.sql**: Complete database schema with RLS policies

---

## Support & Contact
For issues, questions, or contributions, please:
- Open an issue on GitHub
- Submit a pull request
- Contact the development team

---

## License

MIT License © 2025

---

## Acknowledgments
- Built with Next.js, Express, and Supabase
- Azure AD integration for enterprise authentication
- Microsoft Graph API for email notifications
- Tailwind CSS for modern UI design

--- Vercel
2. Configure environment variables in Vercel dashboard:
   - `NEXT_PUBLIC_MSAL_CLIENT_ID`
   - `NEXT_PUBLIC_MSAL_TENANT_ID`
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `NEXT_PUBLIC_API_URL`
3. Deploy Next.js application
4. Custom domain configuration (optional)

### Backend (Vercel/PM2)
1. Deploy Express backend as Vercel Serverless Functions or use PM2
2. Configure environment variables:
   - Supabase credentials
   - Azure AD credentials
   - Microsoft Graph API credentials
3. Set up logging and monitoring
4. Configure CORS for frontend domain

### Database (Supabase)
1. Create Supabase project
2. Run schema.sql to create tables
3. Configure Row Level Security (RLS) policies
4. Set up real-time subscriptions (optional)
5. Configure storage buckets for file uploads

---

## Recent Updates

### October 2025 - System Access Management
- ✅ Added comprehensive System Access Management module
- ✅ Integrated Forms and Approvals into System Access workflow
- ✅ Implemented Oracle Fusion ERP access tracking
- ✅ Added IT asset handover management
- ✅ Created employee onboarding workflow
- ✅ Streamlined sidebar navigation (removed separate Forms and Approvals)
- ✅ Added Time & Attendance integration support
- ✅ Implemented priority-based request management

---gin
2. Entra ID validates credentials and returns ID & access tokens
3. Token sent to backend → verified with MSAL Node
4. Backend identifies user roles from AD groups
5. Role-based access applied throughout the app

---

## Key Features by Module

### 📦 Assets Module
- Create, read, update, delete assets
- Advanced search and filtering
- Asset assignment to users
- Condition tracking and valuation
- Category and location management
- Asset history and audit trail

### 👥 System Access Module (NEW - October 2025)
- **Employee onboarding forms** with complete information capture
- **System access provisioning** (Network, Email, VPN)
- **Oracle Fusion ERP access management**:
  - HR Module: 7 access groups
  - Finance Module: AP, AR, Finance Manager, DM Finance
  - Department-specific access
- **IT asset handover tracking** (Laptop, Desktop, Mobile, Walkie Talkie, SIM Card)
- **Request approval workflow** with priority levels
- **Access audit trail** for compliance
- **Time & Attendance** system integration
- **Network and email provisioning** automation-ready

### 🔧 Maintenance Module
- Schedule preventive maintenance
- Track corrective maintenance
- Cost tracking and reporting
- Technician assignment
- Email reminders via Microsoft Graph API
- Status tracking

### 👤 Users Module
- User management with Azure AD sync
- Role assignment (Admin, Manager, User)
- Department organization
- Single Sign-On (SSO)

### 📊 Reports Module
- Asset statistics and analytics
- Maintenance cost reports
- System access reports
- Export capabilities
- Visual dashboards

---cost, current value, condition, and location
- **Advanced Search & Filtering**: Search assets by multiple criteria including category, location, condition, and assigned personnel
- **Asset Assignment**: Assign assets to specific users and track ownership history
- **Condition Monitoring**: Track asset condition with status indicators (excellent, good, fair, poor)
- **Asset Categories**: Organize assets by categories (IT Equipment, Office Furniture, Vehicles, etc.)

### System Access Management (NEW - October 2025)
- **IT Onboarding & Offboarding**: Streamlined employee onboarding with comprehensive system access provisioning
- **Employee Information Management**: Track employee ID, name, department, department head, email, and joining date
- **Oracle Fusion ERP Access Management**: 
  - HR Module: 7 access groups (HR, Manager, Buyer, Coordinator, Store, Receiver, Requestor)
  - Finance Module: AP, AR, Finance Manager, DM Finance
  - Department-specific access control
- **Network & Email Access**: 
  - Network login/Windows/VPN provisioning
  - Email accounts (generic, personal, Entra ID integration)
  - Email format: f.name@hospital.ae
- **Time & Attendance**: Integration-ready for biometric and attendance systems
- **IT Asset Handover**: 
  - Laptop assignment and tracking
  - Desktop allocation
  - Mobile device management (with/without camera)
  - Walkie talkie assignment
  - Duty SIM card tracking
  - IT Admin access provisioning
  - HR system access
- **Access Request Workflow**:
  - Create, view, edit, and track access requests
  - Approval/rejection workflow with reason tracking
  - Status tracking (Pending, In Progress, Approved, Rejected)
  - Priority levels (Low, Medium, High)
- **Unified Forms & Approvals**: All system access forms and approval workflows consolidated in one module
- **Access Audit Trail**: Complete history of all access provisioning and modification activities

### Maintenance Management
- **Maintenance Scheduling**: Schedule preventive and corrective maintenance activities
- **Maintenance History**: Complete maintenance records with costs, technician details, and notes
- **Maintenance Reminders**: Automated email notifications for upcoming maintenance
- **Status Tracking**: Track maintenance status (scheduled, in-progress, completed, cancelled)
- **Cost Tracking**: Monitor maintenance costs and generate cost reports

### User Management & Authentication
- **Azure AD Integration**: Secure authentication using Microsoft Entra ID (Azure AD)
- **Role-Based Access Control**: Three-tier access control (Admin, Manager, User)
- **Single Sign-On (SSO)**: Seamless login experience with enterprise credentials
- **User Assignment**: Assign assets to specific users and track responsibility

### Notifications & Communication
- **Email Notifications**: Automated maintenance reminders via Microsoft Graph API
- **Real-time Alerts**: In-app notifications for important updates
- **Maintenance Reminders**: Proactive notifications for scheduled maintenance

### Reporting & Analytics
- **Dashboard**: Overview of total assets, maintenance activities, and key metrics
- **Asset Statistics**: Visual charts showing asset distribution by category and condition
- **Maintenance Reports**: Track maintenance costs, schedules, and completion rates
- **Export Capabilities**: Export data for external reporting and analysis

### Technical Features
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile devices
- **Real-time Data**: Live updates using Supabase real-time subscriptions
- **File Attachments**: Upload and manage asset documentation and images
- **Audit Trail**: Complete history of all asset and maintenance activities
- **Data Security**: Enterprise-grade security with row-level security policies

## 🛠 Technology Stack

### Frontend
- **Framework**: Next.js 14 with React 18
- **Styling**: Tailwind CSS for responsive design
- **Authentication**: Azure MSAL (Microsoft Authentication Library)
- **State Management**: React Query for server state management
- **UI Components**: Lucide React icons
- **Forms**: React Hook Form for form handling

### Backend
- **Runtime**: Node.js with Express.js
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Azure AD integration with MSAL Node
- **Email Service**: Microsoft Graph API
- **Logging**: Winston for structured logging
- **Security**: Helmet, CORS, Rate limiting
- **Validation**: Express Validator

### Database
- **Primary Database**: Supabase (PostgreSQL)
- **Real-time Features**: Supabase real-time subscriptions
- **Security**: Row Level Security (RLS)
- **File Storage**: Supabase Storage for asset images and documents

### DevOps & Deployment
- **Process Management**: PM2 for production deployment
- **Environment Management**: Docker support
- **Monitoring**: Structured logging with Winston
- **Security**: Environment-based configuration
	•	MSAL.js for frontend authentication
	•	MSAL Node for backend token validation
	•	Role-based access using AD groups (Admin, Manager, User)

4. Forms
	•	Dynamic forms for asset submission
	•	Field validation (required fields, serial number, purchase date)
	•	Submission triggers approval workflow

5. Notifications
	•	Emails for pending approvals
	•	Notifications to submitters after approval/rejection/changes
	•	Optional integration with Microsoft Teams for in-app notifications

6. Audit Trail
	•	Logs all actions on assets: submission, updates, approvals, rejections
	•	Tracks who performed the action and when

⸻

Getting Started

Prerequisites
	•	Node.js (v18+)
	•	npm or yarn
	•	Supabase account + project
	•	Microsoft Entra ID tenant
	•	Vercel account for deployment

⸻

Project Setup

1. Clone the repository

git clone https://github.com/yourusername/assetflow.git
cd assetflow

2. Install dependencies

Frontend

cd frontend
npm install

Backend

cd ../backend
npm install


⸻

3. Configure Environment Variables

Backend (.env)

PORT=5000
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_service_key

MSAL_CLIENT_ID=your_azure_client_id
MSAL_TENANT_ID=your_azure_tenant_id
MSAL_CLIENT_SECRET=your_azure_client_secret

GRAPH_API_CLIENT_ID=your_graph_api_client_id
GRAPH_API_CLIENT_SECRET=your_graph_api_secret
GRAPH_API_TENANT_ID=your_azure_tenant_id
EMAIL_SENDER=your_email@domain.com

Frontend (.env.local)

NEXT_PUBLIC_MSAL_CLIENT_ID=your_azure_client_id
NEXT_PUBLIC_MSAL_TENANT_ID=your_azure_tenant_id
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
NEXT_PUBLIC_API_URL=https://your-backend.vercel.app


⸻

4. Running Locally

Backend

cd backend
npm run dev

Frontend

cd frontend
npm run dev

Your frontend will be available at http://localhost:3000, backend at http://localhost:5000.

⸻

Project Structure

/assetflow
├─ frontend/                 # React + Next.js frontend
│  ├─ components/            # Reusable UI components
│  │  ├─ Layout.tsx          # Main layout wrapper
│  │  └─ Sidebar.tsx         # Navigation sidebar
│  ├─ pages/                 # Next.js pages
│  │  ├─ index.tsx           # Dashboard
│  │  ├─ assets.tsx          # Asset management
│  │  ├─ system-access.tsx   # System access management (NEW)
│  │  ├─ users.tsx           # User management
│  │  ├─ reports.tsx         # Reports & analytics
│  │  ├─ settings.tsx        # Application settings
│  │  └─ login.tsx           # Authentication page
│  ├─ context/               # Auth and state management
│  │  └─ AuthContext.tsx     # Azure AD auth context
│  ├─ utils/                 # Utilities
│  │  └─ supabase.ts         # Supabase client
│  └─ styles/                # Styling
│     └─ globals.css         # Global styles with Tailwind
│
├─ backend/                  # Node.js + Express backend
│  ├─ src/
│  │  ├─ routes/             # API endpoints
│  │  │  ├─ assets.js        # Asset routes
│  │  │  ├─ systemAccess.js  # System access routes (NEW)
│  │  │  ├─ auth.js          # Authentication routes
│  │  │  ├─ users.js         # User routes
│  │  │  ├─ maintenance.js   # Maintenance routes
│  │  │  └─ notifications.js # Notification routes
│  │  ├─ services/           # Business logic
│  │  │  └─ notificationService.js
│  │  ├─ middleware/         # Express middleware
│  │  │  ├─ auth.js          # MSAL token validation
│  │  │  └─ errorHandler.js  # Error handling
│  │  ├─ config/             # Configuration
│  │  │  ├─ azure.js         # Azure AD config
│  │  │  └─ database.js      # Supabase config
│  │  ├─ utils/              # Utilities
│  │  │  └─ logger.js        # Winston logger
│  │  └─ server.js           # Express app
│  ├─ logs/                  # Application logs
│  ├─ ecosystem.config.js    # PM2 configuration
│  └─ package.json
│
├─ database/
│  └─ schema.sql             # Database schema
│
├─ README.md                 # Project documentation
├─ SYSTEM_ACCESS_IMPLEMENTATION.md  # System Access feature docs (NEW)
└─ package.json


⸻

## Backend API Endpoints

### Assets
| Endpoint | Method | Description |
|----------|--------|-------------|
| /api/assets | GET | Fetch all assets with filtering |
| /api/assets/:id | GET | Get single asset details |
| /api/assets | POST | Create new asset |
| /api/assets/:id | PUT | Update asset details |
| /api/assets/:id | DELETE | Delete/retire an asset |

### System Access (NEW)
| Endpoint | Method | Description |
|----------|--------|-------------|
| /api/system-access | GET | Fetch all system access requests |
| /api/system-access/:id | GET | Get single request details |
| /api/system-access | POST | Create new access request |
| /api/system-access/:id | PUT | Update access request |
| /api/system-access/:id | DELETE | Delete access request |
| /api/system-access/:id/status | PATCH | Update request status |
| /api/system-access/:id/approve | PATCH | Approve access request |
| /api/system-access/:id/reject | PATCH | Reject access request |

### Maintenance
| Endpoint | Method | Description |
|----------|--------|-------------|
| /api/maintenance | GET | Fetch maintenance records |
| /api/maintenance/:id | GET | Get maintenance details |
| /api/maintenance | POST | Create maintenance record |
| /api/maintenance/:id | PUT | Update maintenance record |

### Users & Authentication
| Endpoint | Method | Description |
|----------|--------|-------------|
| /api/users | GET | Fetch all users |
| /api/auth/login | POST | Azure AD authentication |
| /api/auth/logout | POST | User logout |


⸻

## Navigation Structure

AssetFlow features a streamlined, role-based navigation:

### Main Navigation (Sidebar)
1. **Dashboard** - Overview of assets, maintenance, and system access metrics
2. **Assets** - Complete asset lifecycle management
3. **System Access** - IT onboarding, access provisioning, forms, and approvals (NEW)
4. **Users** - User management and role assignment
5. **Reports** - Analytics and reporting tools
6. **Settings** - Application configuration

> **Note**: Forms and Approvals have been consolidated into the **System Access** module for better workflow management.

---

## System Access Workflow (NEW)

### New Employee Onboarding Process:
1. **Request Creation**
   - HR/Manager creates system access request
   - Fills in employee details (name, ID, department, email, joining date)
   - Selects required system access (network, email, Oracle Fusion)
   - Specifies IT assets needed (laptop, mobile, etc.)

2. **IT Review**
   - IT Admin reviews request
   - Verifies asset availability
   - Checks access requirements

3. **Approval Process**
   - IT Admin approves/rejects with comments
   - Priority assignment (High, Medium, Low)
   - Status tracking (Pending → In Progress → Approved/Rejected)

4. **Provisioning** (Upon Approval)
   - Network login credentials created
   - Email account provisioned (f.name@hospital.ae)
   - Oracle Fusion ERP access granted:
     - HR Module groups (7 groups)
     - Finance Module groups (AP, AR, etc.)
     - Department-specific access
   - IT assets assigned and tracked
   - Time & Attendance system setup
   - ESS User access configured

5. **Notifications**
   - Request creator notified of status updates
   - IT Admin receives new request alerts
   - Department head notified of approval
   - Complete audit trail maintained

---

## Approval Workflow
	1.	User submits asset form → Status: Pending Approval
	2.	Backend identifies approvers based on asset type, cost, or department
	3.	Emails sent to approvers via Microsoft Graph API
	4.	Approver submits decision → backend updates asset status
	5.	Submitter receives notification with the outcome
	6.	Audit trail updated for all actions

⸻

## Supabase Database Tables

### Assets
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| name | VARCHAR(255) | Asset name |
| category | VARCHAR(100) | Asset category |
| serial_number | VARCHAR(100) | Unique serial number |
| location | VARCHAR(255) | Physical location |
| purchase_date | DATE | Date of purchase |
| purchase_cost | DECIMAL | Original cost |
| current_value | DECIMAL | Current value |
| condition | ENUM | excellent, good, fair, poor |
| assigned_to | UUID | Foreign key → Users.id |
| created_at | TIMESTAMP | Auto-generated |
| updated_at | TIMESTAMP | Auto-updated |

### System Access Requests (NEW)
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| employee_id | VARCHAR(50) | Unique employee ID |
| first_name | VARCHAR(100) | Employee first name |
| last_name | VARCHAR(100) | Employee last name |
| email | VARCHAR(255) | Employee email |
| department | VARCHAR(100) | Department name |
| department_head | VARCHAR(255) | Department head name |
| date_of_joining | DATE | Joining date |
| network_access | BOOLEAN | Network login access |
| email_access | JSONB | Email access details |
| oracle_fusion_access | JSONB | ERP access details |
| ess_user | BOOLEAN | ESS User access |
| assigned_assets | JSONB | IT assets assigned |
| status | VARCHAR(50) | pending, approved, rejected, in_progress |
| priority | VARCHAR(20) | low, medium, high |
| requested_by | UUID | Foreign key → Users.id |
| approved_by | UUID | Foreign key → Users.id |
| approved_at | TIMESTAMP | Approval timestamp |
| rejection_reason | TEXT | Reason for rejection |
| notes | TEXT | Additional notes |
| created_at | TIMESTAMP | Auto-generated |
| updated_at | TIMESTAMP | Auto-updated |

### Maintenance Records
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| asset_id | UUID | Foreign key → Assets.id |
| maintenance_type | VARCHAR(100) | Type of maintenance |
| scheduled_date | TIMESTAMP | Scheduled date |
| completed_date | TIMESTAMP | Completion date |
| status | ENUM | scheduled, in_progress, completed, cancelled |
| cost | DECIMAL | Maintenance cost |
| technician_name | VARCHAR(255) | Technician name |
| notes | TEXT | Additional notes |
| created_at | TIMESTAMP | Auto-generated |

### Users
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| email | VARCHAR(255) | User email (unique) |
| name | VARCHAR(255) | Full name |
| role | ENUM | admin, manager, user |
| department | VARCHAR(100) | Department |
| azure_user_id | VARCHAR(255) | Azure AD user ID |
| created_at | TIMESTAMP | Auto-generated |
| updated_at | TIMESTAMP | Auto-updated |


⸻

Authentication Flow
	1.	User clicks “Sign in with Microsoft” → MSAL.js handles login
	2.	Entra ID validates credentials and returns ID & access tokens
	3.	Token sent to backend → verified with MSAL Node
	4.	Backend identifies user roles from AD groups
	5.	Role-based access applied throughout the app

⸻

Email Notifications via Microsoft Graph API
	•	Sends approval requests to approvers
	•	Submitters receive outcome notifications
	•	Graph API integration ensures emails are sent via corporate accounts

Example workflow:

POST /assets/:id/approve
Backend sends Graph API email to:
- Approver (on submission)
- Submitter (after decision)


⸻

Deployment
	•	Frontend: Vercel → connect GitHub repo, deploy Next.js app
	•	Backend: Vercel Functions → host Express APIs
	•	Environment variables configured in Vercel dashboard

⸻

Contributing
	1.	Fork the repository
	2.	Create a feature branch (git checkout -b feature/xyz)
	3.	Commit changes (git commit -m "Add new feature")
	4.	Push to branch (git push origin feature/xyz)
	5.	Open a Pull Request

⸻

License

MIT License © 2025 – Your Name

⸻

I can also create a Copilot-ready folder structure with stub files, API routes, MSAL auth templates, and Graph API email functions, so you can literally start coding without writing boilerplate.

Do you want me to create that next?