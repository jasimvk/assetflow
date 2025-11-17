# AssetFlow Vercel Deployment Guide

## Prerequisites
- Vercel account (sign up at https://vercel.com)
- Vercel CLI installed (already done ✓)
- Supabase project URL and anon key

## Step 1: Deploy Backend API

### 1.1 Navigate to backend folder:
```bash
cd /Users/admin/Desktop/Personal/projects/assetflow/backend
```

### 1.2 Login to Vercel (if not already logged in):
```bash
vercel login
```
Visit https://vercel.com/device and enter the code shown.

### 1.3 Deploy backend:
```bash
vercel --prod
```

When prompted:
- **Set up and deploy**: Yes
- **Which scope**: Select your account
- **Link to existing project**: No
- **Project name**: `assetflow-backend` (or your choice)
- **Directory**: `./` (current directory)
- **Override settings**: No

### 1.4 Add environment variables in Vercel Dashboard:
Go to: https://vercel.com/[your-username]/assetflow-backend/settings/environment-variables

Add these variables:
```
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
FRONTEND_URL=https://assetflow-frontend.vercel.app (update after frontend deploy)
NODE_ENV=production
```

### 1.5 Save the backend URL:
After deployment, note the URL (e.g., `https://assetflow-backend.vercel.app`)

---

## Step 2: Deploy Frontend

### 2.1 Navigate to frontend folder:
```bash
cd /Users/admin/Desktop/Personal/projects/assetflow/frontend
```

### 2.2 Deploy frontend:
```bash
vercel --prod
```

When prompted:
- **Set up and deploy**: Yes
- **Which scope**: Select your account
- **Link to existing project**: No
- **Project name**: `assetflow-frontend` (or your choice)
- **Directory**: `./` (current directory)
- **Override settings**: No

### 2.3 Add environment variables in Vercel Dashboard:
Go to: https://vercel.com/[your-username]/assetflow-frontend/settings/environment-variables

Add these variables:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
NEXT_PUBLIC_API_URL=https://assetflow-backend.vercel.app
NODE_ENV=production
```

### 2.4 Redeploy after adding env vars:
```bash
vercel --prod
```

---

## Step 3: Update Backend FRONTEND_URL

### 3.1 Go to backend environment variables:
https://vercel.com/[your-username]/assetflow-backend/settings/environment-variables

### 3.2 Update FRONTEND_URL:
```
FRONTEND_URL=https://assetflow-frontend.vercel.app
```
(Use the actual URL from Step 2)

### 3.3 Redeploy backend:
```bash
cd /Users/admin/Desktop/Personal/projects/assetflow/backend
vercel --prod
```

---

## Step 4: Test Your Deployment

### 4.1 Open your frontend URL:
```
https://assetflow-frontend.vercel.app
```

### 4.2 Test these features:
- ✅ Login/authentication
- ✅ Navigate to Assets page
- ✅ Click on table rows
- ✅ Filter assets by category
- ✅ Test Master Data and Import Assets

### 4.3 Check API health:
```
https://assetflow-backend.vercel.app/api/health
```
Should return: `{"status":"OK","timestamp":"...","environment":"serverless"}`

---

## Step 5: Import Production Data

### 5.1 Open Supabase Dashboard:
Go to your Supabase project → SQL Editor

### 5.2 Run import scripts in order:
1. `import_assets_desktops_retired.sql` (13 desktops)
2. `import_assets_laptops_additional.sql` (7 laptops)
3. `import_assets_walkie_talkies.sql` (16 walkie talkies)

### 5.3 Verify data:
```sql
SELECT 
  category,
  status,
  COUNT(*) as count
FROM assets
GROUP BY category, status
ORDER BY category, status;
```

---

## Quick Commands Reference

### Deploy both projects:
```bash
# Backend
cd /Users/admin/Desktop/Personal/projects/assetflow/backend
vercel --prod

# Frontend
cd /Users/admin/Desktop/Personal/projects/assetflow/frontend
vercel --prod
```

### View deployment logs:
```bash
vercel logs [deployment-url]
```

### List all deployments:
```bash
vercel list
```

### Remove a deployment:
```bash
vercel remove [deployment-name]
```

---

## Environment Variables Summary

### Backend (.env):
```env
SUPABASE_URL=https://[project].supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
FRONTEND_URL=https://assetflow-frontend.vercel.app
NODE_ENV=production
```

### Frontend (.env.local):
```env
NEXT_PUBLIC_SUPABASE_URL=https://[project].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...
NEXT_PUBLIC_API_URL=https://assetflow-backend.vercel.app
NODE_ENV=production
```

---

## Troubleshooting

### Issue: "The specified token is not valid"
**Solution**: Run `vercel login` again

### Issue: "Environment variables not found"
**Solution**: 
1. Add variables in Vercel Dashboard
2. Redeploy with `vercel --prod`

### Issue: Backend API routes returning 404
**Solution**: 
1. Check backend URL is correct in frontend env vars
2. Verify API routes start with `/api/`
3. Check backend deployment logs: `vercel logs [backend-url]`

### Issue: CORS errors
**Solution**:
1. Update `FRONTEND_URL` in backend env vars
2. Redeploy backend

### Issue: Database connection errors
**Solution**:
1. Verify Supabase URL and keys in env vars
2. Check Supabase project is active
3. Verify RLS policies allow access

---

## Custom Domain (Optional)

### Add custom domain:
1. Go to Project Settings → Domains
2. Add your domain (e.g., assetflow.yourdomain.com)
3. Update DNS records as instructed
4. Update environment variables with new domain

---

## Monitoring

### View analytics:
- Frontend: https://vercel.com/[username]/assetflow-frontend/analytics
- Backend: https://vercel.com/[username]/assetflow-backend/analytics

### View logs:
```bash
vercel logs assetflow-frontend --follow
vercel logs assetflow-backend --follow
```

---

## Success Checklist

- [ ] Backend deployed successfully
- [ ] Backend environment variables configured
- [ ] Frontend deployed successfully
- [ ] Frontend environment variables configured
- [ ] Both projects can communicate
- [ ] Health check endpoint working
- [ ] Login/authentication working
- [ ] Assets page loading with data
- [ ] Clickable rows functioning
- [ ] Production SQL scripts imported
- [ ] All features tested

---

## Support

If you encounter issues:
1. Check Vercel deployment logs
2. Check browser console for errors
3. Verify all environment variables are set
4. Test API health endpoint
5. Check Supabase connection

**Your apps will be live at:**
- Frontend: `https://assetflow-frontend.vercel.app`
- Backend: `https://assetflow-backend.vercel.app`

🎉 Happy deploying!
