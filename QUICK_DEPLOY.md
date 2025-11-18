# 🚀 Quick Deployment Guide

Get AssetFlow deployed in under 10 minutes!

## Prerequisites
- [x] Supabase account (https://supabase.com)
- [ ] Vercel account (https://vercel.com)
- [ ] Git repository pushed to GitHub ✅

---

## 🎯 Three Simple Steps

### Step 1: Setup Database (5 minutes)

1. **Create Supabase Project**
   - Go to https://supabase.com/dashboard
   - Click "New Project"
   - Name: `assetflow`
   - Choose region closest to your users
   - Wait for setup to complete

2. **Run SQL Scripts**
   - Go to SQL Editor in Supabase
   - Copy & paste these files in order:
     1. `database/supabase_setup.sql` → Execute
     2. `database/system_access_schema.sql` → Execute  
     3. `database/test_users_fixed.sql` → Execute

3. **Enable Realtime**
   - Go to Database → Replication
   - Enable for: `notifications`, `system_access_requests`, `assets`

4. **Copy Credentials**
   - Settings → API
   - Copy: `Project URL` and `anon public` key

---

### Step 2: Deploy Backend (2 minutes)

**Option A: Vercel CLI (Fastest)**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy backend
cd backend
vercel

# Add environment variables when prompted
# SUPABASE_URL=<your_url>
# SUPABASE_SERVICE_ROLE_KEY=<your_service_key>

# Deploy to production
vercel --prod
```

**Option B: Vercel Dashboard**
1. Go to https://vercel.com/new
2. Import from GitHub: `jasimvk/assetflow`
3. Root Directory: `backend`
4. Add environment variables (see `.env.production.example`)
5. Deploy

**Copy your backend URL**: `https://assetflow-backend-xxxxx.vercel.app`

---

### Step 3: Deploy Frontend (2 minutes)

**Option A: Vercel CLI**
```bash
# Deploy frontend
cd frontend
vercel

# Add environment variables when prompted
# NEXT_PUBLIC_SUPABASE_URL=<your_supabase_url>
# NEXT_PUBLIC_SUPABASE_ANON_KEY=<your_anon_key>
# NEXT_PUBLIC_API_URL=<your_backend_url>

# Deploy to production
vercel --prod
```

**Option B: Vercel Dashboard**
1. New Project → Import `jasimvk/assetflow`
2. Root Directory: `frontend`
3. Add environment variables:
   ```
   NEXT_PUBLIC_SUPABASE_URL=<your_supabase_url>
   NEXT_PUBLIC_SUPABASE_ANON_KEY=<your_anon_key>
   NEXT_PUBLIC_API_URL=<your_backend_url>
   ```
4. Deploy

**Copy your frontend URL**: `https://assetflow-xxxxx.vercel.app`

---

## ✅ Verify Deployment

1. **Open your frontend URL**
2. **Test login** with: `admin@assetflow.com`
3. **Create a system access request**
4. **Approve/reject it** 
5. **Check notifications** appear

---

## 🎉 That's It!

Your AssetFlow is now live at: `https://assetflow-xxxxx.vercel.app`

### What's Working:
- ✅ User authentication (test users)
- ✅ Asset management
- ✅ System access requests
- ✅ Approval/rejection workflow
- ✅ Real-time notifications
- ✅ Dashboard and reports

---

## 🔧 Optional: Update CORS

For better security, update backend CORS:

```bash
# In Vercel dashboard → Backend project → Settings → Environment Variables
# Add/Update:
CORS_ORIGIN=https://assetflow-xxxxx.vercel.app  # Your frontend URL
```

Then redeploy backend:
```bash
cd backend
vercel --prod
```

---

## 📚 Need More Details?

See full documentation:
- **Detailed Guide**: `DEPLOYMENT_GUIDE.md`
- **Checklist**: `PRE_DEPLOYMENT_CHECKLIST.md`
- **Environment Setup**: `.env.production.example` files

---

## 🆘 Troubleshooting

**Issue**: "API connection failed"
→ Check `NEXT_PUBLIC_API_URL` matches your backend URL

**Issue**: "Database connection error"  
→ Verify Supabase credentials are correct

**Issue**: "Authentication not working"
→ Test users created? Run `test_users_fixed.sql`

**Issue**: "Real-time not working"
→ Enable replication in Supabase Database → Replication

---

## 🎯 Automated Deployment

Use the deployment script:

```bash
./deploy.sh
```

Choose option 3 for full deployment!

---

## 📞 Support

- **Issues**: https://github.com/jasimvk/assetflow/issues
- **Vercel Support**: https://vercel.com/support
- **Supabase Support**: https://supabase.com/support

---

**Happy Deploying! 🚀**
