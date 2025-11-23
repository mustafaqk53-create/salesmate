# 🚀 Phase 2 Deployment Checklist

## ✅ Code Complete (Done)
- [x] MessageProvider class created (350 lines)
- [x] whatsappService.js updated (backward compatible)
- [x] broadcastService.js updated
- [x] followUpService.js updated
- [x] Migration scripts created
- [x] Tests passing
- [x] Code pushed to GitHub

## 🔧 Manual Steps Required

### Step 1: Run Database Migration (5 minutes)
**IMPORTANT: Do this before deploying to EC2**

1. Open Supabase Dashboard: https://supabase.com/dashboard
2. Navigate to: **SQL Editor**
3. Copy content from: `migrations/phase2_simple.sql`
4. Paste and click **RUN**
5. Verify output shows 3 columns added

**Expected output:**
```
✅ 3 columns added: plan, waha_session_name, waha_status
✅ SAK tenant updated to premium
✅ Indexes created
```

**Verify in Table Editor:**
- Check `tenants` table has new columns
- SAK tenant should have: `plan = 'premium'`, `whatsapp_provider = 'waha'`

---

### Step 2: Configure Environment (Optional)
**Only if using Waha for premium features**

Add to `.env` on EC2:
```bash
WAHA_API_URL=http://your-waha-server:3000
WAHA_SESSION_NAME=default
```

---

### Step 3: Deploy to EC2 (10 minutes)

**Option A: Using VS Code Task (Recommended)**
```bash
# In VS Code, run task: "Quick Deploy (no message)"
# This will deploy automatically
```

**Option B: Manual SSH Deploy**
```bash
# 1. SSH to EC2
ssh ec2-user@43.205.192.171

# 2. Navigate to app directory
cd /path/to/SAK-Whatsapp-AI-Hybrid

# 3. Pull latest code
git pull origin main

# 4. Install dependencies (if needed)
npm install

# 5. Restart application
pm2 restart all

# 6. Monitor logs
pm2 logs --lines 100
```

---

### Step 4: Verify Deployment (5 minutes)

**Check logs for MessageProvider:**
```bash
# On EC2 or local if testing
pm2 logs | grep MessageProvider

# Look for:
# ✅ [MessageProvider] Initialized for tenant: SAK
# ✅ [MessageProvider] Selected provider: waha
# ✅ [MessageProvider] Message sent successfully
```

**Test message sending:**
```bash
# Run test on EC2
cd /path/to/SAK-Whatsapp-AI-Hybrid
node tests/integration/test_message_provider.js
```

**Expected output:**
```
✅ Tenant loaded: SAK
   Plan: premium
   Provider: waha
✅ MessageProvider tests complete!
```

---

### Step 5: Monitor Cost Savings (Ongoing)

**Week 1:** Check Maytapi dashboard
- Message count should decrease 80-90%
- Cost should drop from $500 to ~$50

**Week 2:** Verify Desktop Agent
- Check `broadcast_recipients` table for queued messages
- Ensure Desktop Agent is processing queue

**Month 1:** Calculate actual savings
- Previous: $500/month
- New: $0-50/month
- Savings: $450-500/month 💰

---

## 🔍 Troubleshooting

### Issue: Migration fails in Supabase
**Solution:**
- Check if columns already exist (use Table Editor)
- Run only missing ALTER TABLE statements
- Contact support if permissions issue

### Issue: MessageProvider not selecting correct provider
**Debug:**
```bash
node -e "
const { supabase } = require('./services/config');
supabase.from('tenants').select('business_name, plan, whatsapp_provider')
  .then(d => console.table(d.data));
"
```
**Fix:** Ensure migration ran successfully, tenant has `plan` field set

### Issue: Waha not responding
**Debug:**
```bash
curl http://your-waha-server:3000/api/sessions
```
**Fix:** Ensure WAHA_API_URL is correct, Waha server is running

### Issue: Desktop Agent not processing queue
**Debug:**
```sql
SELECT COUNT(*) FROM broadcast_recipients WHERE status = 'queued';
```
**Fix:** Ensure Desktop Agent service is running and polling

---

## 📊 Success Metrics

**Phase 2 successful when:**
- ✅ Migration ran without errors
- ✅ Tests pass on EC2
- ✅ Messages route to correct provider
- ✅ Logs show provider selection
- ✅ Maytapi usage drops 80%+
- ✅ No production errors for 24 hours

---

## 🎯 Current Status

### Completed ✅
- Code development (100%)
- Local testing (100%)
- GitHub push (100%)
- Documentation (100%)

### Pending ⏳
- [ ] Run Supabase migration
- [ ] Deploy to EC2
- [ ] Production testing
- [ ] Cost monitoring

---

## 📝 Quick Commands

```bash
# Check tenant configuration
node run_phase2_migration.js

# Test MessageProvider
node tests/integration/test_message_provider.js

# Deploy to EC2 (manual)
git pull && pm2 restart all

# Monitor logs
pm2 logs --lines 100 | grep -i "provider\|error"

# Check queue status
node -e "const {supabase} = require('./services/config'); supabase.from('broadcast_recipients').select('status').then(d => console.log(d.data));"
```

---

## 🚨 Important Notes

1. **Run migration BEFORE deploying** - New code expects new columns
2. **Backward compatible** - Old code still works if migration not run
3. **Gradual rollout** - Can test with one tenant first
4. **Rollback plan** - Just revert git commit if issues
5. **Monitor closely** - First 24 hours after deployment

---

## 📞 Support

**If deployment issues:**
1. Check logs: `pm2 logs`
2. Verify migration: Run `run_phase2_migration.js`
3. Test locally: Run test files
4. Rollback: `git revert HEAD && pm2 restart all`

---

**Estimated Total Time:** 20-30 minutes  
**Risk Level:** Low (backward compatible) 🟢  
**Expected Savings:** $5,400/year 💰
