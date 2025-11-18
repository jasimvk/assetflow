# 🚀 AssetFlow Deployment Guide

## ✅ Completed Steps

1. **Git Commit & Push** - All changes pushed to GitHub
   - Approval/rejection flow fixes
   - Hardcoded data removal
   - Supabase Realtime implementation
   - Test users SQL script

## 📋 Next Steps for Deployment

### 1️⃣ Deploy to Vercel (Frontend)

**Option A: Via Vercel Dashboard (Recommended)**
1. Go to [vercel.com](https://vercel.com)
2. Click "Add New Project"
3. Import from GitHub: `jasimvk/assetflow`
4. Configure project:
   - **Framework Preset**: Next.js
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`
   - **Install Command**: `npm install`

5. Add Environment Variables:
   ```
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   NEXT_PUBLIC_API_URL=your_backend_url (will set after backend deployment)
   NODE_ENV=production
   ```

6. Click "Deploy"

**Option B: Via Vercel CLI**
```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy from project root
vercel

# Follow prompts:
# - Link to existing project or create new
# - Set root directory: frontend
# - Override settings: No (use vercel.json)

# Add environment variables
vercel env add NEXT_PUBLIC_SUPABASE_URL production
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production
vercel env add NEXT_PUBLIC_API_URL production

# Deploy to production
vercel --prod
```

---

### 2️⃣ Deploy Backend API

**Option A: Deploy to Vercel (Recommended for Node.js)**
1. Create `vercel.json` in backend folder:
   ```json
   {
     "version": 2,
     "builds": [
       {
         "src": "src/server.js",
         "use": "@vercel/node"
       }
     ],
     "routes": [
       {
         "src": "/(.*)",
         "dest": "src/server.js"
       }
     ],
     "env": {
       "NODE_ENV": "production"
     }
   }
   ```

2. Deploy via Vercel CLI:
   ```bash
   cd backend
   vercel
   
   # Add environment variables
   vercel env add SUPABASE_URL production
   vercel env add SUPABASE_SERVICE_ROLE_KEY production
   vercel env add PORT production (set to 3001)
   
   # Deploy to production
   vercel --prod
   ```

**Option B: Deploy to Railway**
1. Go to [railway.app](https://railway.app)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose `jasimvk/assetflow`
5. Configure:
   - **Root Directory**: `backend`
   - **Start Command**: `npm start`
6. Add environment variables:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
   PORT=3001
   NODE_ENV=production
   ```
7. Deploy

**Option C: Deploy to Render**
1. Go to [render.com](https://render.com)
2. New Web Service
3. Connect GitHub: `jasimvk/assetflow`
4. Configure:
   - **Name**: assetflow-backend
   - **Root Directory**: `backend`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
5. Add environment variables (same as above)
6. Deploy

---

### 3️⃣ Configure Supabase

1. **Go to Supabase Dashboard**: [supabase.com/dashboard](https://supabase.com/dashboard)

2. **Get Your Credentials**:
   - Project URL: `Settings` → `API` → `Project URL`
   - Anon Key: `Settings` → `API` → `anon public`
   - Service Role Key: `Settings` → `API` → `service_role` (⚠️ Keep secret!)

3. **Run Database Migrations**:
   - Go to `SQL Editor` in Supabase
   - Execute these files in order:
     ```sql
     -- 1. Run main schema (if not already done)
     database/supabase_setup.sql
     
     -- 2. Run system access schema
     database/system_access_schema.sql
     
     -- 3. Create test users
     database/test_users_fixed.sql
     ```

4. **Enable Realtime** (if not already enabled):
   - Go to `Database` → `Replication`
   - Enable replication for these tables:
     - ✅ `notifications`
     - ✅ `system_access_requests`
     - ✅ `assets`

5. **Configure Authentication**:
   - Go to `Authentication` → `Providers`
   - Enable Email (for testing)
   - Configure Azure AD (when ready):
     - Go to `Authentication` → `Providers` → `Azure`
     - Add your Azure AD credentials

---

### 4️⃣ Update Frontend Environment Variables

After deploying backend, update frontend environment:

```bash
# Update NEXT_PUBLIC_API_URL with your backend URL
vercel env add NEXT_PUBLIC_API_URL production

# Enter your deployed backend URL, e.g.:
# https://assetflow-backend.vercel.app
# or
# https://assetflow-backend.up.railway.app
```

Redeploy frontend:
```bash
vercel --prod
```

---

### 5️⃣ Verify Deployment

**Test Checklist**:
- [ ] Frontend loads successfully
- [ ] Backend API responds (check /health endpoint)
- [ ] Database connection works
- [ ] User authentication works (test users)
- [ ] Approval/rejection flow works
- [ ] Notifications appear in real-time
- [ ] Assets page loads data
- [ ] System access requests display correctly

**Quick Tests**:
1. **Health Check**:
   ```bash
   curl https://your-backend-url.vercel.app/health
   ```

2. **Test Login**:
   - Use test user: `admin@assetflow.com`
   - Should load dashboard

3. **Test Approval Flow**:
   - Login as user: `developer1@assetflow.com`
   - Submit a system access request
   - Login as admin: `admin@assetflow.com`
   - Approve or reject the request
   - Verify notification appears

4. **Test Real-time**:
   - Open app in 2 browser windows
   - Create/update data in one window
   - Should update in other window automatically

---

## 🔧 Environment Variables Summary

### Frontend (.env.production)
```bash
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
NEXT_PUBLIC_API_URL=https://your-backend-url.vercel.app
NODE_ENV=production
```

### Backend (.env.production)
```bash
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
PORT=3001
NODE_ENV=production
CORS_ORIGIN=https://your-frontend-url.vercel.app
```

---

## 📊 Deployment Platforms Comparison

| Platform | Best For | Pricing | Pros | Cons |
|----------|----------|---------|------|------|
| **Vercel** | Next.js Frontend | Free tier available | Zero config, fast CDN, great DX | Serverless functions have cold starts |
| **Railway** | Node.js Backend | $5/month | Always-on, no cold starts | Paid only |
| **Render** | Full-stack apps | Free tier available | Free tier, persistent storage | Slower than Railway |
| **Fly.io** | Global deployment | Free tier available | Multi-region, Docker support | Steeper learning curve |

---

## 🎯 Recommended Setup

**For Production**:
- **Frontend**: Vercel (optimized for Next.js)
- **Backend**: Railway (persistent, no cold starts)
- **Database**: Supabase (already configured)

**For Testing/Staging**:
- **Frontend**: Vercel (free tier)
- **Backend**: Render (free tier)
- **Database**: Supabase (same database, use separate schema)

---

## 🆘 Troubleshooting

### Issue: "API connection failed"
**Solution**: 
1. Check NEXT_PUBLIC_API_URL is set correctly
2. Verify backend is deployed and running
3. Check CORS settings in backend allow frontend domain

### Issue: "Database connection error"
**Solution**:
1. Verify Supabase credentials are correct
2. Check if Supabase project is active
3. Run database migrations if not done

### Issue: "Authentication not working"
**Solution**:
1. Mock auth is removed - need to implement Azure AD
2. Or use Supabase Auth for testing
3. Check auth middleware configuration

### Issue: "Real-time not working"
**Solution**:
1. Enable replication in Supabase for required tables
2. Check Supabase anon key has correct permissions
3. Verify WebSocket connection in browser dev tools

---

## 📚 Additional Resources

- **Vercel Docs**: https://vercel.com/docs
- **Railway Docs**: https://docs.railway.app
- **Supabase Docs**: https://supabase.com/docs
- **Next.js Deployment**: https://nextjs.org/docs/deployment

---

## ✅ Post-Deployment Checklist

After successful deployment:
- [ ] Add custom domain (optional)
- [ ] Set up monitoring (Vercel Analytics, Railway Metrics)
- [ ] Configure error tracking (Sentry)
- [ ] Set up CI/CD pipelines
- [ ] Enable HTTPS (auto with Vercel/Railway)
- [ ] Configure rate limiting
- [ ] Set up backup strategy
- [ ] Document deployment process for team
- [ ] Implement Azure AD authentication
- [ ] Add production environment variables
- [ ] Test all critical user flows
- [ ] Monitor logs for errors

---

## 🎉 You're Ready to Deploy!

Your AssetFlow application is now prepared for deployment with:
- ✅ Clean codebase (no hardcoded data)
- ✅ Fixed approval/rejection flow
- ✅ Real-time notifications
- ✅ Test users ready
- ✅ Documentation complete

**Start with Step 1** (Deploy Frontend to Vercel) and work your way through! 🚀
