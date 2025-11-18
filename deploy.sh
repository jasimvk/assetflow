#!/bin/bash

# AssetFlow Deployment Script
# This script helps deploy AssetFlow to Vercel

set -e  # Exit on error

echo "🚀 AssetFlow Deployment Script"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI not found!${NC}"
    echo "Install it with: npm i -g vercel"
    exit 1
fi

echo -e "${GREEN}✅ Vercel CLI found${NC}"
echo ""

# Function to deploy frontend
deploy_frontend() {
    echo -e "${BLUE}📦 Deploying Frontend...${NC}"
    cd frontend
    
    echo "Setting environment variables..."
    echo -e "${YELLOW}Please enter your Supabase URL:${NC}"
    read -r SUPABASE_URL
    echo -e "${YELLOW}Please enter your Supabase Anon Key:${NC}"
    read -r SUPABASE_ANON_KEY
    
    vercel env add NEXT_PUBLIC_SUPABASE_URL production <<< "$SUPABASE_URL" || true
    vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production <<< "$SUPABASE_ANON_KEY" || true
    
    echo "Deploying to Vercel..."
    vercel --prod
    
    cd ..
    echo -e "${GREEN}✅ Frontend deployed!${NC}"
    echo ""
}

# Function to deploy backend
deploy_backend() {
    echo -e "${BLUE}📦 Deploying Backend...${NC}"
    cd backend
    
    echo "Setting environment variables..."
    echo -e "${YELLOW}Please enter your Supabase URL:${NC}"
    read -r SUPABASE_URL
    echo -e "${YELLOW}Please enter your Supabase Service Role Key:${NC}"
    read -rs SUPABASE_SERVICE_KEY  # -s hides input
    echo ""
    
    vercel env add SUPABASE_URL production <<< "$SUPABASE_URL" || true
    vercel env add SUPABASE_SERVICE_ROLE_KEY production <<< "$SUPABASE_SERVICE_KEY" || true
    vercel env add PORT production <<< "3001" || true
    vercel env add NODE_ENV production <<< "production" || true
    
    echo "Deploying to Vercel..."
    vercel --prod
    
    cd ..
    echo -e "${GREEN}✅ Backend deployed!${NC}"
    echo ""
}

# Main menu
echo "What would you like to deploy?"
echo "1) Frontend only"
echo "2) Backend only"
echo "3) Both (Frontend + Backend)"
echo "4) Exit"
echo ""
read -rp "Enter your choice (1-4): " choice

case $choice in
    1)
        deploy_frontend
        ;;
    2)
        deploy_backend
        ;;
    3)
        deploy_backend
        echo -e "${YELLOW}⏳ Waiting 10 seconds for backend to initialize...${NC}"
        sleep 10
        deploy_frontend
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting...${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Update frontend NEXT_PUBLIC_API_URL with your backend URL"
echo "2. Update backend CORS_ORIGIN with your frontend URL"
echo "3. Run database migrations in Supabase SQL Editor"
echo "4. Test your deployment"
echo ""
echo "See DEPLOYMENT_GUIDE.md for detailed instructions."
