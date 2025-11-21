-- Add is_active column to tenants table for easy client management
-- Run this in Supabase SQL Editor

-- Add column with default TRUE (all existing tenants stay active)
ALTER TABLE tenants 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

-- Add index for faster queries
CREATE INDEX IF NOT EXISTS idx_tenants_active 
ON tenants(is_active) 
WHERE is_active = TRUE;

-- Add comment
COMMENT ON COLUMN tenants.is_active IS 'Set to false to disable client access completely. Client cannot login or use any features when false.';

-- Example usage:

-- Disable a client (soft delete - can re-enable later)
-- UPDATE tenants SET is_active = false WHERE phone_number = '971507055253';

-- Re-enable a client
-- UPDATE tenants SET is_active = true WHERE phone_number = '971507055253';

-- List all inactive clients
-- SELECT phone_number, business_name, created_at 
-- FROM tenants 
-- WHERE is_active = false;
