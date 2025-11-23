-- Phase 2: Add WhatsApp provider fields to tenants table
-- Run this in Supabase SQL Editor

-- Add columns for multi-provider support
ALTER TABLE tenants 
ADD COLUMN IF NOT EXISTS whatsapp_provider VARCHAR(20) DEFAULT 'maytapi',
ADD COLUMN IF NOT EXISTS plan VARCHAR(20) DEFAULT 'basic',
ADD COLUMN IF NOT EXISTS waha_session_name VARCHAR(100),
ADD COLUMN IF NOT EXISTS waha_status VARCHAR(50) DEFAULT 'disconnected';

-- Update existing tenants to use appropriate provider
-- Set SAK tenant to premium plan
UPDATE tenants 
SET plan = 'premium', 
    whatsapp_provider = 'waha'
WHERE id = 'c93fbde0-7d5d-473c-ab2b-5f677c9a495c';

-- Add index for faster provider lookups
CREATE INDEX IF NOT EXISTS idx_tenants_provider ON tenants(whatsapp_provider);
CREATE INDEX IF NOT EXISTS idx_tenants_plan ON tenants(plan);

-- Display current configuration
SELECT 
    id,
    business_name,
    whatsapp_provider,
    plan,
    waha_status
FROM tenants;
