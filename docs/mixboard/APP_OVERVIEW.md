# SAK WhatsApp AI Sales Assistant (Hybrid) — App Overview (Mixboard)

## Product Summary
SAK WhatsApp AI Sales Assistant is a multi-tenant WhatsApp-first sales automation platform that helps businesses convert WhatsApp conversations into structured sales outcomes.

It combines:
- A WhatsApp AI assistant that can answer product questions, guide customers through ordering, and respond quickly 24/7.
- A web dashboard for business operators to manage products, customers, orders, broadcasts, follow-ups, documents, and analytics.
- A hybrid deployment option that runs the WhatsApp Web connection locally (Desktop Agent) while keeping AI, database, and business logic in the cloud.

## Primary Use Cases
- Respond to customer questions on WhatsApp (product details, pricing, availability, policies).
- Convert chat messages into cart actions and structured orders.
- Collect required checkout details (e.g., GST preference/number, shipping/address information).
- Manage customers and conversations from a unified dashboard.
- Run outbound campaigns (“broadcasts”) and manage follow-ups.
- Improve answer quality by grounding replies in the tenant’s catalog and optional website/document knowledge.

## Target Users
- Businesses that sell via WhatsApp (retail, wholesale, distribution, B2B, D2C).
- Sales and support teams that need fast responses, consistent quoting, and a repeatable order-taking workflow.

## Core Features (High-Level)
### 1) AI Assistant
- Intent-aware replies and guided flows.
- Catalog-aware responses using product data and semantic retrieval (embeddings).
- Conversation context/memory for multi-turn sales.

### 2) Cart + Orders
- Cart building via natural language.
- Checkout flow with structured state transitions.
- Order creation with line items and totals.

### 3) Customer Profiles
- Persistent customer profiles per tenant.
- Stores operational info such as GST preference and addresses when provided.

### 4) Dashboard
- Conversations, orders, customers, products.
- Follow-ups and reminders.
- Broadcast campaigns.
- Website indexing and document knowledge management (optional modules).
- WhatsApp Web connection status/controls (where enabled).

### 5) Multi-Tenant SaaS
- Tenant registration and tenant-isolated data.
- Subscription tier concept and usage tracking (where configured).

## Deployment Modes
### Hybrid Mode (Recommended)
- Desktop Agent (business PC) handles WhatsApp Web session.
- Cloud Server handles AI processing, storage, business logic, and dashboard.

This improves stability and reduces cloud resource cost because heavy browser automation runs locally.

### Provider/Webhook Mode (Optional)
- WhatsApp messages can also arrive via webhook from an external provider integration (depending on configuration).

## Third-Party Services (Typical)
- OpenAI: AI responses and embeddings (configurable model selection).
- Supabase/Postgres: tenant data storage and vector search.
- Google Cloud Storage (optional): assets/documents/media storage.

## Notes for Reviewers
- The app is designed to keep tenant data isolated.
- In hybrid mode, the WhatsApp authentication session remains on the business’s machine; only message payloads required for AI/business logic are sent to the cloud.

## Company/Contact (Fill In)
- Publisher/Company name: __________________________
- Support email: __________________________
- Website: __________________________
- Jurisdiction: __________________________
