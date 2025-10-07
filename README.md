# AssetFlow - Enterprise Asset Management Tool 

A comprehensive enterprise asset management solution built with React/Next.js frontend, Node.js/Express backend, Supabase database, and integrated with Microsoft Azure AD (Entra ID) for authentication and email notifications.

## 🚀 Features

### Core Asset Management
- **Asset Registration & Tracking**: Complete asset lifecycle management with detailed information including purchase date, cost, current value, condition, and location
- **Advanced Search & Filtering**: Search assets by multiple criteria including category, location, condition, and assigned personnel
- **Asset Assignment**: Assign assets to specific users and track ownership history
- **Condition Monitoring**: Track asset condition with status indicators (excellent, good, fair, poor)
- **Asset Categories**: Organize assets by categories (IT Equipment, Office Furniture, Vehicles, etc.)

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
│  ├─ components/            # Reusable UI components (Forms, Dashboards)
│  ├─ pages/                 # Next.js pages (Assets, Approvals, Login)
│  ├─ context/               # Auth and state management
│  ├─ utils/                 # MSAL authentication, API helpers
│  └─ styles/                # Tailwind customizations
│
├─ backend/                  # Node.js + Express backend
│  ├─ controllers/           # API logic (assets, approvals)
│  ├─ models/                # Supabase table models
│  ├─ routes/                # Express API endpoints
│  ├─ services/              # Email, approval workflow, Graph API integration
│  └─ utils/                 # MSAL token validation, helper functions
│
├─ README.md                 # Project documentation
└─ package.json


⸻

Backend API Endpoints

Endpoint	Method	Description
/api/assets	GET	Fetch all assets (role-based)
/api/assets	POST	Submit a new asset request
/api/assets/:id	PUT	Update asset details
/api/assets/:id	DELETE	Retire an asset
/api/assets/:id/approve	POST	Approve/Reject asset
/api/approvals	GET	Fetch pending approvals for the logged-in user


⸻

Approval Workflow
	1.	User submits asset form → Status: Pending Approval
	2.	Backend identifies approvers based on asset type, cost, or department
	3.	Emails sent to approvers via Microsoft Graph API
	4.	Approver submits decision → backend updates asset status
	5.	Submitter receives notification with the outcome
	6.	Audit trail updated for all actions

⸻

Supabase Database Tables (Simplified)

Assets

Column	Type	Notes
id	UUID	Primary Key
name	String	Asset name
type	String	Category
serial_number	String	Optional
value	Number	Cost/value of asset
status	Enum	Pending, Approved, Rejected, Retired
created_by	String	AD user ID
assigned_to	String	AD user ID (optional)
created_at	Timestamp	Auto-generated

AssetApprovals

Column	Type	Notes
id	UUID	Primary Key
asset_id	UUID	Foreign key → Assets.id
approver_id	String	AD user ID
status	Enum	Pending, Approved, Rejected
comments	Text	Optional
created_at	Timestamp	Auto-generated


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