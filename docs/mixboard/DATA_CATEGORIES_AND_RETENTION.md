# Data Categories & Retention (Mixboard)

This document summarizes the categories of data processed by SAK WhatsApp AI Sales Assistant and typical retention behavior.

## 1) Data Categories Processed
### A. Tenant/Account Data (Business Admin)
- Business name and configuration
- Login/account identifiers (e.g., email/credentials depending on enabled auth)
- Subscription tier/status metadata (if enabled)

### B. Customer Identifiers
- Customer phone number / WhatsApp chat identifier
- Optional customer name (if available from WhatsApp profile or provided by the operator)

### C. Conversation Content
- Customer message text
- Bot replies
- Message metadata (timestamps, message ids)

### D. Commerce/Operations Data
- Product catalog items (names, codes, pricing, packaging details)
- Cart contents and cart history
- Orders, order items, totals
- Shipping/address information (only if provided by the customer/operator)
- Tax identifiers (e.g., GST preference and GST number, only if provided)

### E. Campaign/Follow-up Data
- Follow-up tasks/reminders (status, timestamps)
- Broadcast campaigns: target phone numbers, message templates, sending status, delivery logs (as configured)

### F. Knowledge Sources (Optional)
- Uploaded documents (business-provided)
- Website crawl text chunks and embeddings (business-provided website content)

### G. Technical/Telemetry Data
- Server logs (request logs, error logs)
- Provider delivery logs (which channel was used)

## 2) How Data Is Used
- Provide the core service (respond to WhatsApp messages and manage sales flows).
- Maintain operational continuity (conversation memory, customer profile consistency).
- Enable business workflows (orders, follow-ups, broadcasts).
- Improve relevance and accuracy (semantic retrieval from catalog/website/docs).
- Debug and reliability monitoring (logs).

## 3) Retention (Typical Defaults)
Because deployments can vary by customer/tenant, retention may be configured by the operator.

Typical retention behavior:
- Tenant operational data (customers, orders, products) is retained while the tenant account remains active to provide continuity.
- Conversation history is retained to support context and auditing.
- Broadcast/follow-up records are retained for operational tracking.
- Technical logs may be retained for a limited period for troubleshooting.

## 4) Deletion & Export
- Tenant administrators may delete records depending on the dashboard/admin tools enabled in the deployment.
- If required, data exports can be performed at the database level (deployment/operator controlled).

## 5) Third-Party Processing
When enabled:
- OpenAI processes prompts and context to generate replies and embeddings.
- Supabase/Postgres stores tenant data and vectors.
- Cloud storage may store documents/assets.

## 6) Reviewer Notes
- In hybrid mode, WhatsApp Web authentication/session data stays on the business machine (Desktop Agent). The cloud server typically receives message text + metadata required to generate replies and store operational records.

## 7) Fill-In Fields
- Data retention policy URL (if published): __________________________
- Support contact for data requests: __________________________
- Deletion request process: __________________________
