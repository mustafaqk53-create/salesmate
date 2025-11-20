# 🚀 Desktop Agent - Complete Customer Flow

## ✅ The Correct Flow (Step by Step)

### **Step 1: Customer Registration (Online)**
👤 **URL:** http://13.62.57.240:8080/agent-login

**Customer Actions:**
1. Opens the agent login page in browser
2. Clicks "Register" tab
3. Fills in:
   - **Phone Number:** e.g., `971507055253`
   - **Email:** e.g., `customer@email.com`
   - **Business Name:** e.g., `My Shop`
   - **Password:** e.g., `MyPassword123`
4. Clicks "Register"
5. **Tenant ID is generated** automatically (e.g., `TENANT-1732104567-abc123`)
6. Registration success message appears

**What Happens:**
- Tenant record created in database
- Password stored (for desktop agent AND dashboard login)
- Status: `registered`

---

### **Step 2: Download Desktop Agent**
📥 **Customer Downloads:**
- `sak-whatsapp-agent-windows.exe`
- `START-AGENT.bat`
- `README.txt`

**Customer Actions:**
1. Extract files to a folder (e.g., `C:\WhatsApp-Agent\`)
2. Double-click `START-AGENT.bat`

---

### **Step 3: Desktop Agent Login**
🔐 **Agent Opens Browser Automatically**

**Customer Actions:**
1. Agent detects no `.env` file
2. Browser opens to http://13.62.57.240:8080/agent-login
3. Customer enters **SAME credentials** used in Step 1:
   - **Phone:** `971507055253`
   - **Password:** `MyPassword123`
4. Clicks "Sign In"
5. Browser shows "✅ Login successful! Return to Desktop Agent"
6. Customer closes browser

**What Happens:**
- Credentials sent to localhost:3001/auth-callback
- Desktop agent saves tenant ID to `.env` file
- Agent initializes WhatsApp Web client

---

### **Step 4: QR Code Connection**
📱 **Agent Shows QR Code**

**Customer Actions:**
1. Opens WhatsApp on phone
2. Goes to **Settings → Linked Devices → Link a Device**
3. Scans QR code displayed in agent window
4. WhatsApp connects

**What Happens:**
- Agent registers with cloud server
- Database updated: `whatsapp_phone = 971507055253`, `status = connected`
- Agent starts listening for messages

---

### **Step 5: Dashboard Login (Online)**
💻 **URL:** http://13.62.57.240:8080/login.html

**Customer Actions:**
1. Opens dashboard login page
2. Enters **SAME credentials** used in Step 1:
   - **Phone:** `971507055253`
   - **Password:** `MyPassword123`
3. Clicks "Sign In"
4. Dashboard opens

**What Happens:**
- Dashboard verifies credentials from database
- Session created
- Customer can access all features

---

### **Step 6: Check Connection Status**
✅ **Dashboard Shows:**
- **Desktop Agent:** 🟢 Connected
- **WhatsApp Phone:** 971507055253
- **Status:** Online
- **Last Seen:** Just now

**Customer Can Now:**
- Send broadcast messages
- View analytics
- Manage products
- Chat with customers

---

## 🔑 Key Points

### **Same Credentials Everywhere**
| Where | Phone | Password |
|-------|-------|----------|
| Online Registration | ✅ | ✅ |
| Desktop Agent Login | ✅ | ✅ |
| Dashboard Login | ✅ | ✅ |

### **One Tenant ID**
- Generated during registration
- Stored in desktop agent's `.env` file
- Linked to WhatsApp number when connected

### **Connection Status**
- **Dashboard checks:** Desktop agent status from database
- **No Web QR:** Customer doesn't scan QR in dashboard
- **Desktop Agent only:** QR code shown in desktop application

---

## 📊 Technical Flow

```
1. Customer Registration
   ↓
   [Creates tenant in database with password]
   ↓
2. Downloads Desktop Agent
   ↓
3. Runs START-AGENT.bat
   ↓
   [Agent checks for .env file]
   ↓
4. No .env → Opens Browser → Login Page
   ↓
   [Customer enters phone + password]
   ↓
5. Login Success → Callback to localhost:3001
   ↓
   [Agent saves tenant ID to .env]
   ↓
6. Agent Initializes WhatsApp Client
   ↓
7. Shows QR Code in Agent Window
   ↓
8. Customer Scans QR with Phone
   ↓
   [WhatsApp Connected]
   ↓
9. Agent Registers with Cloud Server
   ↓
   [Database: status = 'connected', whatsapp_phone = '971...']
   ↓
10. Customer Opens Dashboard with Same Login
    ↓
    [Dashboard shows connection status from database]
    ↓
11. Customer Sends Messages via Dashboard
    ↓
    [Messages forwarded to desktop agent → WhatsApp]
```

---

## 🎯 What's Different from Before?

### ❌ Old Confusing Way:
- Two separate systems (web-based + desktop)
- Customer didn't know which to use
- QR code in dashboard AND desktop agent
- Inconsistent login methods

### ✅ New Clear Way:
- **One registration** → Works everywhere
- **Desktop agent** → Connects WhatsApp (QR code here)
- **Dashboard** → Manage messages (no QR code)
- **Same login** → Phone + Password everywhere

---

## 🔧 Required Database Columns

Make sure `tenants` table has:
```sql
- id (text, primary key)
- phone (text, unique)
- email (text)
- business_name (text)
- password (text) ← MUST EXIST
- whatsapp_phone (text) ← Updated by desktop agent
- status (text) ← 'registered' → 'connected'
- created_at (timestamp)
```

---

## 🆘 Troubleshooting

### "Invalid credentials" during desktop agent login
**Solution:** Make sure password column exists in database and contains the password customer set during registration

### "Connection status not showing in dashboard"
**Solution:** Desktop agent must successfully register with cloud server after QR scan

### "Desktop agent keeps asking to login"
**Solution:** Check that `.env` file was created in agent directory with valid tenant ID

---

## 📝 Summary

1. ✅ Customer registers ONCE with phone + password
2. ✅ Downloads desktop agent
3. ✅ Agent asks for login (same phone + password)
4. ✅ Agent shows QR code → Customer scans
5. ✅ Customer logs into dashboard (same phone + password)
6. ✅ Dashboard shows connection status from desktop agent
7. ✅ Customer sends messages via dashboard

**Simple. Clean. No confusion!** 🎉
