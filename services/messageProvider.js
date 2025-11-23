/**
 * MessageProvider - Abstraction layer for multiple WhatsApp providers
 * 
 * Supports:
 * - Desktop Agent (FREE - local WhatsApp Web)
 * - Waha Cloud (PREMIUM - 24/7 cloud)
 * - Maytapi (LEGACY - fallback for existing clients)
 * 
 * Cost savings: $450/month by switching from Maytapi to Desktop Agent/Waha
 */

const axios = require('axios');
const { supabase } = require('./config');

class MessageProvider {
    constructor(tenant) {
        this.tenant = tenant;
        this.provider = this.selectProvider();
    }

    /**
     * Determine which provider to use based on tenant configuration
     */
    selectProvider() {
        // Check tenant plan or specific provider setting
        if (this.tenant.whatsapp_provider) {
            return this.tenant.whatsapp_provider;
        }

        // Fallback to plan-based selection
        if (this.tenant.plan === 'basic') {
            return 'desktop-agent';
        } else if (this.tenant.plan === 'premium') {
            return 'waha';
        }

        // Default to Maytapi for backward compatibility
        return 'maytapi';
    }

    /**
     * Send a WhatsApp message via the selected provider
     */
    async sendMessage(phone, message, mediaUrl = null, options = {}) {
        console.log(`[MessageProvider] Sending via ${this.provider} to ${phone}`);

        try {
            switch (this.provider) {
                case 'desktop-agent':
                    return await this.sendViaDesktopAgent(phone, message, mediaUrl, options);
                case 'waha':
                    return await this.sendViaWaha(phone, message, mediaUrl, options);
                case 'maytapi':
                    return await this.sendViaMaytapi(phone, message, mediaUrl, options);
                default:
                    throw new Error(`Unknown provider: ${this.provider}`);
            }
        } catch (error) {
            console.error(`[MessageProvider] Error with ${this.provider}:`, error.message);
            
            // Fallback logic: try Maytapi if other providers fail
            if (this.provider !== 'maytapi' && process.env.MAYTAPI_API_KEY) {
                console.log('[MessageProvider] Falling back to Maytapi...');
                return await this.sendViaMaytapi(phone, message, mediaUrl, options);
            }
            
            throw error;
        }
    }

    /**
     * Desktop Agent: Queue message for local WhatsApp Web client
     * Cost: FREE ✅
     */
    async sendViaDesktopAgent(phone, message, mediaUrl, options) {
        console.log('[MessageProvider] Queueing for Desktop Agent...');

        // Ensure phone format
        const formattedPhone = phone.includes('@') ? phone : `${phone}@c.us`;

        // Insert into broadcast_recipients table for desktop agent to pick up
        const { data, error } = await supabase
            .from('broadcast_recipients')
            .insert({
                tenant_id: this.tenant.id,
                phone: formattedPhone,
                name: options.recipientName || null,
                message: message,
                media_url: mediaUrl,
                status: 'pending',
                delivery_method: 'desktop',
                created_at: new Date().toISOString()
            })
            .select()
            .single();

        if (error) {
            console.error('[MessageProvider] Desktop Agent queue error:', error);
            throw new Error(`Desktop Agent queue failed: ${error.message}`);
        }

        return {
            ok: true,
            provider: 'desktop-agent',
            messageId: data.id,
            status: 'queued',
            note: 'Message queued for Desktop Agent to send'
        };
    }

    /**
     * Waha Cloud: Send via Waha API (24/7 cloud WhatsApp)
     * Cost: ~$50/month 💰
     */
    async sendViaWaha(phone, message, mediaUrl, options) {
        const wahaUrl = process.env.WAHA_URL || 'http://localhost:3000';
        const wahaApiKey = process.env.WAHA_API_KEY;

        if (!wahaApiKey) {
            throw new Error('WAHA_API_KEY not configured');
        }

        if (!this.tenant.waha_session_name) {
            throw new Error('Waha session not configured for tenant');
        }

        console.log(`[MessageProvider] Sending via Waha session: ${this.tenant.waha_session_name}`);

        const formattedPhone = phone.includes('@') ? phone : `${phone}@c.us`;

        try {
            // Send text message
            const response = await axios.post(
                `${wahaUrl}/api/sendText`,
                {
                    session: this.tenant.waha_session_name,
                    chatId: formattedPhone,
                    text: message
                },
                {
                    headers: { 'X-Api-Key': wahaApiKey },
                    timeout: 10000
                }
            );

            // If media URL provided, send it separately
            if (mediaUrl) {
                await axios.post(
                    `${wahaUrl}/api/sendImage`,
                    {
                        session: this.tenant.waha_session_name,
                        chatId: formattedPhone,
                        file: { url: mediaUrl }
                    },
                    {
                        headers: { 'X-Api-Key': wahaApiKey },
                        timeout: 10000
                    }
                );
            }

            return {
                ok: true,
                provider: 'waha',
                messageId: response.data?.id || 'waha-' + Date.now(),
                status: 'sent',
                data: response.data
            };
        } catch (error) {
            console.error('[MessageProvider] Waha error:', error.response?.data || error.message);
            throw new Error(`Waha send failed: ${error.response?.data?.message || error.message}`);
        }
    }

    /**
     * Maytapi: Legacy provider (expensive, kept for backward compatibility)
     * Cost: $500/month 💸
     */
    async sendViaMaytapi(phone, message, mediaUrl, options) {
        const maytapiProductId = process.env.MAYTAPI_PRODUCT_ID;
        const maytapiPhoneId = process.env.MAYTAPI_PHONE_ID;
        const maytapiApiKey = process.env.MAYTAPI_API_KEY;

        if (!maytapiApiKey || !maytapiProductId || !maytapiPhoneId) {
            throw new Error('Maytapi credentials not configured');
        }

        console.log('[MessageProvider] Sending via Maytapi (legacy)...');

        const maytapiUrl = `https://api.maytapi.com/api/${maytapiProductId}/${maytapiPhoneId}/sendMessage`;

        try {
            const payload = {
                to_number: phone.replace('@c.us', ''),
                message: message,
                type: mediaUrl ? 'media' : 'text'
            };

            if (mediaUrl) {
                payload.media_url = mediaUrl;
            }

            const response = await axios.post(maytapiUrl, payload, {
                headers: {
                    'x-maytapi-key': maytapiApiKey,
                    'Content-Type': 'application/json'
                },
                timeout: 10000
            });

            return {
                ok: true,
                provider: 'maytapi',
                messageId: response.data?.data?.id || 'maytapi-' + Date.now(),
                status: 'sent',
                data: response.data
            };
        } catch (error) {
            console.error('[MessageProvider] Maytapi error:', error.response?.data || error.message);
            throw new Error(`Maytapi send failed: ${error.response?.data?.message || error.message}`);
        }
    }

    /**
     * Send broadcast to multiple recipients
     */
    async sendBroadcast(recipients, message, mediaUrl = null, options = {}) {
        const results = {
            total: recipients.length,
            sent: 0,
            failed: 0,
            errors: []
        };

        for (const recipient of recipients) {
            try {
                const phone = typeof recipient === 'string' ? recipient : recipient.phone;
                const name = typeof recipient === 'object' ? recipient.name : null;

                await this.sendMessage(phone, message, mediaUrl, { ...options, recipientName: name });
                results.sent++;

                // Rate limiting: wait between messages
                await new Promise(resolve => setTimeout(resolve, 2000));
            } catch (error) {
                results.failed++;
                results.errors.push({
                    recipient: typeof recipient === 'string' ? recipient : recipient.phone,
                    error: error.message
                });
            }
        }

        return results;
    }

    /**
     * Get provider status/health
     */
    async checkStatus() {
        switch (this.provider) {
            case 'desktop-agent':
                return await this.checkDesktopAgentStatus();
            case 'waha':
                return await this.checkWahaStatus();
            case 'maytapi':
                return await this.checkMaytapiStatus();
            default:
                return { ok: false, status: 'unknown', provider: this.provider };
        }
    }

    async checkDesktopAgentStatus() {
        try {
            const agentUrl = process.env.DESKTOP_AGENT_URL || 'http://localhost:3001';
            const response = await axios.get(`${agentUrl}/health`, { timeout: 5000 });
            return {
                ok: true,
                status: response.data.status || 'running',
                provider: 'desktop-agent',
                data: response.data
            };
        } catch (error) {
            return {
                ok: false,
                status: 'disconnected',
                provider: 'desktop-agent',
                error: error.message
            };
        }
    }

    async checkWahaStatus() {
        try {
            const wahaUrl = process.env.WAHA_URL || 'http://localhost:3000';
            const response = await axios.get(
                `${wahaUrl}/api/sessions/${this.tenant.waha_session_name}`,
                {
                    headers: { 'X-Api-Key': process.env.WAHA_API_KEY },
                    timeout: 5000
                }
            );
            return {
                ok: true,
                status: response.data.status || 'unknown',
                provider: 'waha',
                data: response.data
            };
        } catch (error) {
            return {
                ok: false,
                status: 'disconnected',
                provider: 'waha',
                error: error.message
            };
        }
    }

    async checkMaytapiStatus() {
        // Maytapi doesn't have a simple status endpoint
        return {
            ok: true,
            status: 'unknown',
            provider: 'maytapi',
            note: 'Maytapi status checking not implemented'
        };
    }
}

module.exports = MessageProvider;
