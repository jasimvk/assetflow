#!/bin/bash

# AssetFlow Supabase Configuration Helper
# This script helps you set up your environment variables for Supabase

echo "🔧 AssetFlow Supabase Configuration Helper"
echo "=========================================="
echo ""

# Check if .env files exist
BACKEND_ENV="/Users/admin/Desktop/Personal/projects/assetflow/backend/.env"
FRONTEND_ENV="/Users/admin/Desktop/Personal/projects/assetflow/frontend/.env.local"

echo "📋 Steps to configure Supabase:"
echo ""
echo "1. Go to https://supabase.com and sign in"
echo "2. Open your project (or create a new one)"
echo "3. Go to Settings → API"
echo "4. Copy the following values:"
echo ""
echo "   - Project URL: https://xxxxx.supabase.co"
echo "   - anon public key: eyJhbGc..."
echo "   - service_role key: eyJhbGc... (KEEP SECRET!)"
echo ""
echo "=========================================="
echo ""

# Prompt for Supabase credentials
read -p "Enter your Supabase Project URL: " SUPABASE_URL
read -p "Enter your Supabase Anon Key: " ANON_KEY
read -p "Enter your Supabase Service Role Key: " SERVICE_KEY

echo ""
echo "📝 Configuring environment files..."
echo ""

# Configure Backend .env
cat > "$BACKEND_ENV" << EOF
NODE_ENV=development
PORT=3001

# Supabase Database Configuration
SUPABASE_URL=$SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_KEY
SUPABASE_ANON_KEY=$ANON_KEY

# Azure AD (configure later for SSO)
AZURE_CLIENT_ID=your-azure-client-id
AZURE_CLIENT_SECRET=your-azure-client-secret
AZURE_TENANT_ID=your-azure-tenant-id

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:3000

# Email Configuration (configure later)
SMTP_HOST=smtp.office365.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@company.com
SMTP_PASS=your-email-password
EOF

echo "✅ Backend .env configured"

# Configure Frontend .env.local
cat > "$FRONTEND_ENV" << EOF
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=$SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY

# Azure AD (configure later for SSO)
NEXT_PUBLIC_AZURE_CLIENT_ID=your-azure-client-id
NEXT_PUBLIC_AZURE_TENANT_ID=your-azure-tenant-id

# API Base URL
NEXT_PUBLIC_API_BASE_URL=http://localhost:3001
EOF

echo "✅ Frontend .env.local configured"
echo ""
echo "=========================================="
echo "✅ Configuration Complete!"
echo ""
echo "Next steps:"
echo "1. Run backend test: cd backend && node test-db.js"
echo "2. Run frontend test: cd frontend && node test-db.js"
echo ""
echo "⚠️  IMPORTANT: Make sure you've executed the database schema"
echo "   See DATABASE_SETUP.md Step 4"
echo ""
