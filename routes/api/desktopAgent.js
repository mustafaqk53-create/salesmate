/**
 * Desktop Agent API Routes
 * Handles desktop agent registration and message processing
 */

const express = require('express');
const router = express.Router();
const { supabase } = require('../../services/config');

// Register desktop agent
router.post('/desktop-agent/register', async (req, res) => {
    try {
        const { tenantId, phoneNumber, agentVersion } = req.body;

        console.log(`[DESKTOP_AGENT] Registration request from tenant: ${tenantId}`);

        // Update tenant's desktop agent status
        const { data, error } = await supabase
            .from('tenants')
            .update({
                desktop_agent_connected: true,
                desktop_agent_phone: phoneNumber,
                desktop_agent_last_seen: new Date().toISOString(),
                updated_at: new Date().toISOString()
            })
            .eq('id', tenantId)
            .select()
            .single();

        if (error) {
            console.error('[DESKTOP_AGENT] Registration error:', error);
            return res.status(400).json({ 
                success: false, 
                error: error.message 
            });
        }

        console.log(`[DESKTOP_AGENT] ✅ Agent registered for tenant: ${tenantId}`);

        res.json({
            success: true,
            message: 'Desktop agent registered successfully',
            tenant: data
        });

    } catch (error) {
        console.error('[DESKTOP_AGENT] Registration error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

// Disconnect desktop agent
router.post('/desktop-agent/disconnect', async (req, res) => {
    try {
        const { tenantId } = req.body;

        console.log(`[DESKTOP_AGENT] Disconnect request from tenant: ${tenantId}`);

        // Update tenant's desktop agent status
        await supabase
            .from('tenants')
            .update({
                desktop_agent_connected: false,
                updated_at: new Date().toISOString()
            })
            .eq('id', tenantId);

        console.log(`[DESKTOP_AGENT] ✅ Agent disconnected for tenant: ${tenantId}`);

        res.json({
            success: true,
            message: 'Desktop agent disconnected'
        });

    } catch (error) {
        console.error('[DESKTOP_AGENT] Disconnect error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

// Get messages to process (pull from queue)
router.post('/desktop-agent/process-message', async (req, res) => {
    try {
        const { tenantId } = req.body;

        // Get pending messages from broadcast_recipients table
        const { data: messages, error } = await supabase
            .from('broadcast_recipients')
            .select('*')
            .eq('tenant_id', tenantId)
            .eq('status', 'pending')
            .order('created_at', { ascending: true })
            .limit(10);

        if (error) {
            console.error('[DESKTOP_AGENT] Error fetching messages:', error);
            return res.status(400).json({ 
                success: false, 
                error: error.message 
            });
        }

        res.json({
            success: true,
            messages: messages || []
        });

    } catch (error) {
        console.error('[DESKTOP_AGENT] Process message error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

// Mark message as sent
router.post('/desktop-agent/message-sent', async (req, res) => {
    try {
        const { messageId, tenantId } = req.body;

        // Update message status
        await supabase
            .from('broadcast_recipients')
            .update({
                status: 'sent',
                sent_at: new Date().toISOString()
            })
            .eq('id', messageId)
            .eq('tenant_id', tenantId);

        res.json({
            success: true,
            message: 'Message marked as sent'
        });

    } catch (error) {
        console.error('[DESKTOP_AGENT] Message sent error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

// Get tenant info (for agent validation)
router.post('/agent-get-tenant', async (req, res) => {
    try {
        const { tenantId } = req.body;

        const { data: tenant, error } = await supabase
            .from('tenants')
            .select('id, business_name, owner_whatsapp_number, plan')
            .eq('id', tenantId)
            .single();

        if (error || !tenant) {
            return res.status(404).json({ 
                success: false, 
                error: 'Tenant not found' 
            });
        }

        res.json({
            success: true,
            tenant
        });

    } catch (error) {
        console.error('[DESKTOP_AGENT] Get tenant error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

module.exports = router;
