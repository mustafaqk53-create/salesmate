# Architecture & Data Flow (Mixboard)

This document describes the system architecture, message flow, and data flows for SAK WhatsApp AI Sales Assistant.

## 1) System Components
### A. Web Dashboard (Browser)
- Static frontend served by the backend server.
- Used by business operators to manage products, orders, customers, broadcasts, follow-ups, and knowledge sources.

### B. Cloud Server (Node.js + Express)
- Hosts REST APIs and serves dashboard pages.
- Implements business logic, tenant isolation, AI orchestration, and integrations.
- Runs scheduled jobs (e.g., follow-ups, broadcast queue processing).

### C. Database (Supabase / Postgres)
- Stores tenant configuration and tenant-isolated operational data.
- Supports vector search for semantic retrieval (embeddings) when enabled.

### D. AI Provider (OpenAI)
- Chat completion for response generation.
- Embeddings for semantic retrieval.

### E. Optional Storage (Google Cloud Storage)
- Stores assets/documents/media when configured.

### F. WhatsApp Connectivity
The system supports a hybrid approach:
- Desktop Agent mode (WhatsApp Web on the business PC), and/or
- Provider/webhook mode (depending on deployment).

## 2) Hybrid Mode: Message Flow (End-to-End)
### Inbound
1. Customer sends a WhatsApp message to the business number.
2. Desktop Agent (running on the business PC) receives the message via WhatsApp Web session.
3. Desktop Agent sends an HTTPS/HTTP request to the cloud server containing:
   - Tenant identifier
   - Sender phone/chat id
   - Message text and metadata (timestamps/message ids)
4. Cloud server processes the message:
   - Resolves tenant
   - Ensures customer profile exists
   - Loads conversation context
   - Classifies intent
   - Applies deterministic business rules (cart/order/state machine)
   - Calls AI provider as needed for response generation
5. Cloud server returns a text reply.
6. Desktop Agent sends the reply back to the customer through WhatsApp Web.

### Outbound
Outbound messages (e.g., broadcasts/follow-ups) are created in the cloud server and sent using:
- Preferred channel: WhatsApp Web / Desktop Agent (when connected)
- Fallback: other configured provider channel (when applicable)

## 3) Provider/Webhook Mode: Message Flow (Optional)
1. External WhatsApp provider posts messages to the cloud server webhook.
2. Cloud server runs the same core message handling pipeline (tenant resolution, customer profile, AI/business rules).
3. Cloud server uses the configured provider API to send replies.

## 4) Data Flow Overview
### A. Data in Transit
Typical payloads transmitted between components:
- Customer message text + basic metadata (sender id, timestamps)
- Tenant id and routing context
- AI requests to OpenAI (prompt + selected context)
- AI responses back to the server

### B. Data at Rest
Typical data stored per tenant:
- Tenant configuration
- Products/catalog and pricing
- Customers and conversation history
- Carts, orders, and order items
- Follow-ups and campaign/broadcast metadata
- Knowledge sources (documents and/or website crawl results)

## 5) Key Design Principles
- Tenant isolation: tenant id scopes catalog, customers, orders, and knowledge.
- Reliability: deterministic state machine for checkout steps, with AI used for language understanding and response naturalness.
- Hybrid stability: WhatsApp Web session stays local in Desktop Agent mode.

## 6) Operational Controls
- Admin/operator dashboard provides visibility and management tools.
- Scheduled jobs handle follow-ups and broadcast queues.

## 7) Diagram (Text)
Customer → WhatsApp → (Desktop Agent on Business PC) → Cloud Server (AI + Business Logic) → Database/AI Provider → reply → Desktop Agent → WhatsApp → Customer

## 8) Environment-Specific Notes (Fill In)
- Cloud hosting provider: __________________________
- Primary region: __________________________
- Support contact: __________________________
