# Security Overview (Mixboard)

This document provides a practical security overview for SAK WhatsApp AI Sales Assistant.

## 1) Security Goals
- Protect tenant data from cross-tenant access.
- Protect customer identifiers and conversation content.
- Secure API communications between Desktop Agent and cloud server.
- Limit sensitive credential exposure.

## 2) Tenant Isolation
- Business data is logically scoped by tenant identifier.
- Tenant-scoped storage separates products, customers, orders, and knowledge sources.

## 3) Authentication & Secrets Management
- Secrets (API keys, database credentials, AI provider keys) are expected to be configured via environment variables.
- Desktop Agent-to-server communication uses a shared secret/API key (deployment-specific).

## 4) Transport Security
- Recommended: HTTPS for all cloud endpoints.
- Desktop Agent communicates with the cloud server via HTTP/HTTPS as configured.

## 5) Minimization (Hybrid Mode)
- WhatsApp Web session/authentication persists locally on the business machine in Desktop Agent mode.
- The cloud server does not need to store WhatsApp Web session secrets for the hybrid approach.

## 6) Logging & Monitoring
- Server logs are used for debugging and operational monitoring.
- Logging should avoid storing plaintext secrets.

## 7) Data Storage Security (Deployment-Dependent)
- Database access is restricted to the server via configured credentials.
- Cloud storage access is restricted by configured service credentials.

## 8) Operational Recommendations
For production deployments:
- Use HTTPS and rotate API keys periodically.
- Apply least-privilege access for database and storage credentials.
- Restrict admin endpoints to authorized users.
- Maintain regular backups for operational data (orders, products).

## 9) Disclosure & Contact
- Security contact email: __________________________
- Vulnerability reporting process: __________________________
