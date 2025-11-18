# 📋 Pre-Deployment Checklist

Run through this checklist before deploying AssetFlow to production.

## ✅ Code Quality

- [x] All hardcoded data removed
- [x] Approval/rejection flow tested and working
- [x] Real-time notifications implemented
- [x] No console.log statements in production code
- [x] Error handling implemented
- [x] Loading states added to UI
- [ ] TypeScript errors resolved (run `npm run lint`)
- [ ] Tests passing (if tests exist)

## ✅ Database Setup

- [ ] Supabase project created
- [ ] Database schema deployed (`supabase_setup.sql`)
- [ ] System access schema deployed (`system_access_schema.sql`)
- [ ] Test users created (`test_users_fixed.sql`)
- [ ] Row Level Security (RLS) policies configured
- [ ] Realtime enabled for required tables:
  - [ ] `notifications`
  - [ ] `system_access_requests`
  - [ ] `assets`
- [ ] Database backups enabled

## ✅ Environment Variables

### Frontend
- [ ] `NEXT_PUBLIC_SUPABASE_URL` configured
- [ ] `NEXT_PUBLIC_SUPABASE_ANON_KEY` configured
- [ ] `NEXT_PUBLIC_API_URL` configured (after backend deployment)
- [ ] `NODE_ENV=production` set
- [ ] Azure AD variables (if using):
  - [ ] `NEXT_PUBLIC_AZURE_CLIENT_ID`
  - [ ] `NEXT_PUBLIC_AZURE_TENANT_ID`
  - [ ] `NEXT_PUBLIC_AZURE_REDIRECT_URI`

### Backend
- [ ] `SUPABASE_URL` configured
- [ ] `SUPABASE_SERVICE_ROLE_KEY` configured (⚠️ Keep secret!)
- [ ] `PORT` set (e.g., 3001)
- [ ] `NODE_ENV=production` set
- [ ] `CORS_ORIGIN` set to frontend URL
- [ ] `JWT_SECRET` generated and set
- [ ] Azure AD variables (if using):
  - [ ] `AZURE_CLIENT_ID`
  - [ ] `AZURE_CLIENT_SECRET`
  - [ ] `AZURE_TENANT_ID`

## ✅ Security

- [ ] Service role key NOT in frontend code
- [ ] API endpoints have authentication middleware
- [ ] CORS configured correctly
- [ ] Rate limiting enabled
- [ ] Input validation implemented
- [ ] SQL injection prevention (using parameterized queries)
- [ ] XSS prevention (React handles this mostly)
- [ ] HTTPS enabled (automatic with Vercel)
- [ ] Sensitive data encrypted
- [ ] No secrets in git repository

## ✅ Git Repository

- [x] All changes committed
- [x] Pushed to GitHub
- [ ] .env files in .gitignore (should be there already)
- [ ] README.md updated
- [ ] CHANGELOG.md updated (optional)
- [ ] Git tags for version (optional)

## ✅ Deployment Platform

### Vercel Account
- [ ] Vercel account created
- [ ] GitHub repository connected
- [ ] Team access configured (if needed)
- [ ] Payment method added (if using paid features)

### Project Configuration
- [ ] Project name set
- [ ] Framework preset: Next.js (frontend)
- [ ] Node.js version compatible (18+)
- [ ] Build settings configured
- [ ] Environment variables added
- [ ] Deployment domains configured

## ✅ Monitoring & Logging

- [ ] Error tracking setup (e.g., Sentry)
- [ ] Analytics setup (e.g., Vercel Analytics)
- [ ] Logging configured (Winston in backend)
- [ ] Performance monitoring enabled
- [ ] Uptime monitoring setup (e.g., UptimeRobot)

## ✅ Documentation

- [x] DEPLOYMENT_GUIDE.md created
- [x] Environment variable examples created
- [ ] API documentation (optional)
- [ ] User guide (optional)
- [ ] Team handover documentation
- [ ] Deployment runbook

## ✅ Testing

### Local Testing
- [ ] Frontend runs locally (`npm run dev`)
- [ ] Backend runs locally (`npm run dev`)
- [ ] Database connection works
- [ ] Authentication works
- [ ] All critical user flows tested:
  - [ ] User login
  - [ ] Asset viewing/creation
  - [ ] System access request submission
  - [ ] Approval/rejection flow
  - [ ] Notifications display
  - [ ] Real-time updates work

### Production Testing Plan
- [ ] Test plan documented
- [ ] Test users ready (admin, manager, user)
- [ ] Test data prepared
- [ ] Rollback plan ready

## ✅ Post-Deployment Tasks

- [ ] Verify deployment successful
- [ ] Test production URL
- [ ] Check logs for errors
- [ ] Test authentication
- [ ] Test critical user flows
- [ ] Monitor performance
- [ ] Update DNS (if using custom domain)
- [ ] Configure SSL certificate (if custom domain)
- [ ] Announce to team
- [ ] Update status page

## 🚨 Emergency Procedures

### If Deployment Fails
1. Check deployment logs in Vercel
2. Verify environment variables
3. Check database connection
4. Rollback to previous version if needed

### Rollback Steps
```bash
# Via Vercel Dashboard:
# 1. Go to Deployments
# 2. Find previous working deployment
# 3. Click "Promote to Production"

# Via CLI:
vercel rollback
```

## 📞 Support Contacts

- **Supabase Support**: https://supabase.com/support
- **Vercel Support**: https://vercel.com/support
- **GitHub Issues**: https://github.com/jasimvk/assetflow/issues

## 🎯 Deployment Order

**Recommended deployment sequence:**
1. ✅ Database setup (Supabase)
2. ✅ Backend deployment (get URL)
3. ✅ Frontend deployment (use backend URL)
4. ✅ Update frontend with backend URL
5. ✅ Update backend CORS with frontend URL
6. ✅ Test everything
7. ✅ Go live!

---

## 📝 Sign-off

Deployment completed by: _________________

Date: _________________

All checks passed: [ ] Yes [ ] No

Issues encountered: _________________

_________________

_________________

Post-deployment verification: [ ] Complete

Team notified: [ ] Yes [ ] No

---

**Ready to deploy?** Run:
```bash
./deploy.sh
```

Or follow the detailed guide in `DEPLOYMENT_GUIDE.md`
