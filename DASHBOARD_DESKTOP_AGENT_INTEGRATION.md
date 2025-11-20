# Dashboard + Desktop Agent Integration Guide

## 🎉 WHAT'S NEW

Your **existing dashboard** now automatically uses the **Desktop Agent** (FREE WhatsApp) instead of Maytapi (PAID API)!

### ✅ All Your Dashboard Features Still Work:
- 📸 **Image Upload** - Upload photos from camera/gallery
- 📊 **Excel/CSV Upload** - Import contacts from Google, iPhone, anywhere
- 📋 **Copy & Paste** - Paste phone numbers from WhatsApp, Messages, etc.
- 📅 **Schedule Messages** - Send now or schedule for later
- ⚙️ **Batch Controls** - Set delays, batch sizes, rate limiting
- 📝 **Message Templates** - Save and load templates
- 🎯 **Personalization** - Use {name}, {phone}, {business} variables
- 👥 **Contact Groups** - Save and reuse recipient lists

---

## 🚀 HOW IT WORKS

### Automatic Smart Routing:

**Priority 1:** Desktop Agent (Your PC) = **FREE!** ✅
- Checks `http://localhost:3001` 
- If agent running → All broadcasts FREE!

**Priority 2:** Cloud WhatsApp Web = **FREE!** ✅
- If desktop agent offline, checks cloud WhatsApp
- Still free, just server-based

**Priority 3:** Maytapi API = **PAID** 💰
- Only if both free options offline
- Automatic fallback, no config needed

---

## 📱 USING THE DASHBOARD

### Step 1: Start Desktop Agent
```powershell
# Navigate to download folder
cd C:\path\to\public\download

# Run the agent
.\START-AGENT.bat
```

### Step 2: Open Dashboard
- Go to `http://13.62.57.240:8080/dashboard.html`
- Login with your credentials

### Step 3: Check Broadcast Tab
- Click **Broadcast** in sidebar
- Look at the status banner at top:

**🟢 Green Banner = FREE MODE**
```
Desktop Agent Online (FREE!)
Using your local WhatsApp Web connection
$0.00 per message!
```

**🟠 Orange Banner = PAID MODE**
```
No Free WhatsApp Connection
Desktop Agent: Offline ❌
Using Maytapi API
```

### Step 4: Send Broadcasts (Same as Before!)
1. **Choose Recipients:**
   - Paste numbers
   - Upload Excel/CSV
   - Select saved groups

2. **Compose Message:**
   - Write your message
   - Upload image (optional)
   - Use personalization: `Hi {name}!`

3. **Configure Settings:**
   - Batch size: 10 messages/batch
   - Message delay: 500ms between messages
   - Batch delay: 2000ms between batches

4. **Send or Schedule:**
   - Send now: Immediate delivery
   - Schedule: Pick date/time

5. **Click "Send Broadcast"**
   - System automatically routes to FREE method if available
   - Falls back to PAID if needed
   - Shows progress and results

---

## 🔧 BACKEND CHANGES

### New Files:
- `services/desktopAgentBridge.js` - Routes broadcasts to desktop agent
- Enhanced `desktop-agent/index.js` - Handles image broadcasts, batch processing

### Modified Files:
- `routes/api/broadcast.js` - Priority routing (Desktop → Cloud → Maytapi)
- `public/dashboard.html` - Status indicator showing connection method

### API Flow:
```
Dashboard
   ↓
POST /api/broadcast/send
   ↓
Check desktop agent (localhost:3001/health)
   ↓
If ONLINE → POST localhost:3001/broadcast (FREE!)
   ↓
If OFFLINE → Check cloud WhatsApp
   ↓
If OFFLINE → Use Maytapi (PAID)
```

---

## 📊 COST COMPARISON

### Before (Maytapi Only):
- Cost per message: ~$0.02
- 1000 messages: $20
- 10,000 messages: $200

### After (Desktop Agent):
- Cost per message: **$0.00** ✅
- 1000 messages: **FREE**
- 10,000 messages: **FREE**
- Unlimited messages: **FREE**

---

## 🎯 FEATURES SUPPORTED

### Desktop Agent Broadcast Endpoint:
```javascript
POST http://localhost:3001/broadcast

{
  "phoneNumbers": ["971501234567", "971509876543"],
  "message": "Hi {name}! Special offer...",
  "messageType": "text" | "image",
  "imageBase64": "data:image/jpeg;base64,...",
  "batchSize": 10,
  "messageDelay": 500,
  "batchDelay": 2000
}

Response:
{
  "ok": true,
  "totalSent": 2,
  "totalFailed": 0,
  "results": [
    {"phone": "971501234567", "status": "sent", "timestamp": "..."},
    {"phone": "971509876543", "status": "sent", "timestamp": "..."}
  ],
  "summary": {
    "total": 2,
    "sent": 2,
    "failed": 0,
    "successRate": "100.00%"
  }
}
```

### Supported Message Types:
- ✅ Plain text
- ✅ Image + caption
- ✅ Personalization variables
- ✅ Batch processing
- ✅ Rate limiting
- ✅ Error handling per contact

---

## 🚨 TROUBLESHOOTING

### Issue: Orange banner shows "Desktop Agent: Offline"

**Solution:**
1. Make sure agent is running:
   ```powershell
   cd public\download
   .\START-AGENT.bat
   ```

2. Check agent health:
   ```powershell
   Invoke-RestMethod -Uri "http://localhost:3001/health"
   ```

3. Verify WhatsApp connected:
   - Look for "WhatsApp Web connected successfully!" in agent terminal
   - Check QR code scanned

### Issue: Broadcasts still using Maytapi

**Reasons:**
- Desktop agent not running
- WhatsApp not connected in agent
- Network issues blocking localhost:3001

**Solution:**
- Restart desktop agent
- Re-scan QR code
- Check Windows Firewall (allow port 3001)

### Issue: Image broadcasts not working

**Solution:**
- Make sure `messageType: "image"` is set
- Image must be base64 encoded
- Format: `data:image/jpeg;base64,...`
- Desktop agent supports: JPEG, PNG, GIF

---

## 💡 PRO TIPS

### 1. Keep Desktop Agent Running
- Minimize the terminal window (don't close!)
- Agent reconnects automatically if WhatsApp disconnects
- Check status banner before large broadcasts

### 2. Optimize Batch Settings
- Small batches (5-10) = more reliable
- Longer delays (1000-2000ms) = avoid spam detection
- For 1000+ contacts: batch=10, messageDelay=1000, batchDelay=5000

### 3. Test Before Large Broadcasts
- Send to 2-3 numbers first
- Verify messages delivered
- Check formatting and images
- Then send to full list

### 4. Monitor Agent Terminal
- Watch for "✅ Sent" messages
- Check for errors
- See batch progress in real-time

### 5. Fallback Strategy
- If urgent and agent offline: Let it use Maytapi (costs money)
- If not urgent: Start agent first, then broadcast (FREE)

---

## 📈 USAGE STATISTICS

The dashboard shows:
- **Total sent today**: Real-time counter
- **Success rate**: Percentage delivered
- **Method used**: Desktop Agent vs Maytapi
- **Recent broadcasts**: History with details

---

## 🔐 SECURITY

### Desktop Agent:
- Runs locally on your PC
- No data sent to cloud (except AI processing)
- WhatsApp session encrypted
- Port 3001 only accessible from localhost

### Dashboard Integration:
- Checks localhost:3001 from browser
- Falls back to cloud if unavailable
- HTTPS support (optional)
- Tenant isolation maintained

---

## 📞 SUPPORT

### If broadcasts fail:
1. Check desktop agent running
2. Check WhatsApp connected
3. Verify phone numbers format (clean digits)
4. Check batch settings (not too aggressive)
5. Review agent terminal for errors

### If you see errors:
- "WhatsApp not connected" → Scan QR code
- "Phone number invalid" → Use clean format: 971501234567
- "Rate limit exceeded" → Increase delays
- "Connection refused" → Start desktop agent

---

## ✅ SUCCESS CHECKLIST

Before sending broadcasts:
- [ ] Desktop agent running (START-AGENT.bat)
- [ ] WhatsApp connected (green status)
- [ ] Dashboard shows "Desktop Agent Online"
- [ ] Test message sent successfully
- [ ] Phone numbers cleaned (no +, spaces, etc.)
- [ ] Batch settings configured
- [ ] Message preview looks good

---

## 🎊 CONCLUSION

You now have a **HYBRID system**:
- **Dashboard** = Full-featured UI with all controls
- **Desktop Agent** = FREE WhatsApp connection
- **Maytapi** = Automatic paid fallback

**No changes to your workflow!** Just start the agent and save money! 💰✅

---

**Built:** November 20, 2025
**Status:** Production Ready ✅
**Cost Savings:** Up to 100% on broadcasts! 🎉
