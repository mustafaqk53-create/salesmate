/**
 * Desktop Agent Bridge Service
 * 
 * This service routes broadcast requests from the dashboard to the local desktop agent
 * instead of using Maytapi (paid service).
 * 
 * Flow: Dashboard → Cloud Server → Desktop Agent → WhatsApp Web (FREE!)
 */

const axios = require('axios');
const { supabase } = require('./config');

/**
 * Send broadcast via desktop agent (local WhatsApp Web)
 * 
 * @param {string} tenantId - Tenant ID
 * @param {Object} broadcastData - Broadcast configuration from dashboard
 * @returns {Promise<Object>} - Result from desktop agent
 */
async function sendViaDesktopAgent(tenantId, broadcastData) {
    try {
        // Get tenant's desktop agent connection info
        const { data: tenant, error: tenantError } = await supabase
            .from('tenants')
            .select('owner_whatsapp_number, business_name, desktop_agent_url')
            .eq('id', tenantId)
            .single();

        if (tenantError || !tenant) {
            throw new Error('Tenant not found');
        }

        // Use desktop_agent_url if set, otherwise use default localhost
        const desktopAgentUrl = tenant.desktop_agent_url || 'http://localhost:3001';

        console.log(`[DESKTOP_AGENT_BRIDGE] Routing broadcast to: ${desktopAgentUrl}`);
        console.log(`[DESKTOP_AGENT_BRIDGE] Recipients: ${broadcastData.recipients.length}`);
        console.log(`[DESKTOP_AGENT_BRIDGE] Message type: ${broadcastData.messageType}`);

        // Prepare request for desktop agent
        const agentRequest = {
            phoneNumbers: broadcastData.recipients,
            message: broadcastData.message,
            messageType: broadcastData.messageType || 'text',
            imageBase64: broadcastData.imageBase64,
            batchSize: broadcastData.batchSize || 10,
            messageDelay: broadcastData.messageDelay || 500,
            batchDelay: broadcastData.batchDelay || 2000
        };

        // Send to desktop agent
        const response = await axios.post(`${desktopAgentUrl}/broadcast`, agentRequest, {
            timeout: 300000, // 5 minutes timeout (broadcasts can take time)
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (response.data.ok) {
            console.log(`[DESKTOP_AGENT_BRIDGE] ✅ Success: ${response.data.totalSent} sent, ${response.data.totalFailed} failed`);
            return {
                success: true,
                totalSent: response.data.totalSent,
                totalFailed: response.data.totalFailed,
                results: response.data.results,
                summary: response.data.summary,
                method: 'desktop_agent'
            };
        } else {
            throw new Error(response.data.error || 'Desktop agent returned error');
        }

    } catch (error) {
        console.error('[DESKTOP_AGENT_BRIDGE] ❌ Error:', error.message);
        
        // If desktop agent is not reachable, return error with helpful message
        if (error.code === 'ECONNREFUSED' || error.code === 'ETIMEDOUT') {
            return {
                success: false,
                error: 'Desktop agent not running. Please start the agent on your PC.',
                hint: 'Run START-AGENT.bat on your computer',
                method: 'desktop_agent_failed'
            };
        }
        
        return {
            success: false,
            error: error.message,
            method: 'desktop_agent_failed'
        };
    }
}

/**
 * Check if desktop agent is online
 * 
 * @param {string} tenantId - Tenant ID
 * @returns {Promise<boolean>} - True if agent is running
 */
async function isDesktopAgentOnline(tenantId) {
    try {
        const { data: tenant } = await supabase
            .from('tenants')
            .select('desktop_agent_url')
            .eq('id', tenantId)
            .single();

        if (!tenant) return false;

        const desktopAgentUrl = tenant.desktop_agent_url || 'http://localhost:3001';
        
        const response = await axios.get(`${desktopAgentUrl}/health`, {
            timeout: 3000
        });

        return response.data && response.data.status === 'running';

    } catch (error) {
        return false;
    }
}

module.exports = {
    sendViaDesktopAgent,
    isDesktopAgentOnline
};
