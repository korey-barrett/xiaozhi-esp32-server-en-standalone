// Feature configuration utility
import Api from "@/apis/api";
import store from "@/store";

class FeatureManager {
    constructor() {
        this.defaultFeatures = {
            voiceprintRecognition: {
                name: 'feature.voiceprintRecognition.name',
                enabled: false,
                description: 'feature.voiceprintRecognition.description'
            },
            voiceClone: {
                name: 'feature.voiceClone.name',
                enabled: false,
                description: 'feature.voiceClone.description'
            },
            knowledgeBase: {
                name: 'feature.knowledgeBase.name',
                enabled: false,
                description: 'feature.knowledgeBase.description'
            },
            mcpAccessPoint: {
                name: 'feature.mcpAccessPoint.name',
                enabled: false,
                description: 'feature.mcpAccessPoint.description'
            },
            vad: {
                name: 'feature.vad.name',
                enabled: false,
                description: 'feature.vad.description'
            },
            asr: {
                name: 'feature.asr.name',
                enabled: false,
                description: 'feature.asr.description'
            },
            addressBook: {
                name: 'feature.addressBook.name',
                enabled: false,
                description: 'feature.addressBook.description'
            }
        };
        this.currentFeatures = { ...this.defaultFeatures }; // current in-memory configuration
        this.initialized = false;
        this.initPromise = null;
    }

    /**
     * Wait for initialization to complete
     */
    async waitForInitialization() {
        if (!this.initPromise) {
            this.initPromise = this.init();
        }
        await this.initPromise;
        return this.initialized;
    }

    /**
     * Initialize feature configuration
     */
    async init() {
        try {
            // Get configuration from the pub-config interface
            const config = await this.getConfigFromPubConfig();
            if (config) {
                this.currentFeatures = { ...config }; // save to memory
                this.initialized = true;
                return;
            }
        } catch (error) {
            console.warn('Failed to get configuration from the pub-config interface:', error);
        }

        // pub-config interface failed, use default configuration
        this.currentFeatures = { ...this.defaultFeatures }; // save default configuration to memory
        this.initialized = true;
    }

    /**
     * Update the config cache
     */
    updateConfigCache(config) {
        store.commit('setPubConfig', config);
        localStorage.setItem('pubConfig', JSON.stringify(config));
    }

    /**
     * Get configuration from the pub-config interface
     */
    async getConfigFromPubConfig() {
        return new Promise((resolve) => {
            // Directly call the pub-config interface to get configuration
            Api.user.getPubConfig((result) => {
                // Check the structure of the returned result
                if (result && result.status === 200) {
                    // Check whether there is a data field
                    if (result.data) {
                        const configCache = result.data.data || {};
                        // Check whether there is a code field; if so, judge by code
                        if (result.data.code !== undefined) {
                            if (result.data.code === 0 && result.data.data && result.data.data.systemWebMenu) {
                                try {
                                    let config;
                                    if (typeof result.data.data.systemWebMenu === 'string') {
                                        // If it is a string, JSON needs to be parsed
                                        config = JSON.parse(result.data.data.systemWebMenu);
                                    } else {
                                        // If it is already an object, use it directly
                                        config = result.data.data.systemWebMenu;
                                    }

                                    // Check whether the configuration contains a features object
                                    if (config && config.features) {
                                        // Ensure the knowledgeBase feature exists and is configured correctly
                                        if (!config.features.knowledgeBase) {
                                            console.warn('The configuration is missing the knowledgeBase feature, merging default configuration');
                                            config.features = { ...this.defaultFeatures, ...config.features };
                                        }
                                        resolve(config.features);
                                    } else {
                                        console.warn('The configuration is missing the features object, using default configuration');
                                        resolve(this.defaultFeatures);
                                    }
                                    configCache.systemWebMenu = config;
                                } catch (error) {
                                    console.warn('Failed to process the systemWebMenu configuration:', error);
                                    resolve(null);
                                }
                            } else {
                                console.warn('The interface returned a non-zero code or is missing required data, using default configuration');
                                resolve(null);
                            }
                        } else {
                            // If there is no code field, check systemWebMenu directly
                            if (result.data && result.data.systemWebMenu) {
                                try {
                                    let config;
                                    if (typeof result.data.systemWebMenu === 'string') {
                                        // If it is a string, JSON needs to be parsed
                                        config = JSON.parse(result.data.systemWebMenu);
                                    } else {
                                        // If it is already an object, use it directly
                                        config = result.data.systemWebMenu;
                                    }

                                    // Check whether the configuration contains a features object
                                    if (config && config.features) {
                                        // Ensure the knowledgeBase feature exists and is configured correctly
                                        if (!config.features.knowledgeBase) {
                                            console.warn('The configuration is missing the knowledgeBase feature, merging default configuration');
                                            config.features = { ...this.defaultFeatures, ...config.features };
                                        }
                                        resolve(config.features);
                                    } else {
                                        console.warn('The configuration is missing the features object, using default configuration');
                                        resolve(this.defaultFeatures);
                                    }
                                    configCache.systemWebMenu = config;
                                } catch (error) {
                                    console.warn('Failed to process the systemWebMenu configuration:', error);
                                    resolve(null);
                                }
                            } else {
                                console.warn('The interface returned without systemWebMenu data, using default configuration');
                                resolve(null);
                            }
                        }
                        this.updateConfigCache(configCache)
                    } else {
                        console.warn('The interface returned data missing the data field, using default configuration');
                        resolve(null);
                    }
                } else {
                    console.warn('pub-config interface call failed, using default configuration');
                    resolve(null);
                }
            });
        });
    }

    /**
     * Get the current configuration
     */
    getCurrentConfig() {
        // Return the current in-memory configuration
        return this.currentFeatures;
    }

    /**
     * Save configuration to the backend API
     */
    async saveConfig(config) {
        try {
            // Update the in-memory configuration
            this.currentFeatures = { ...config };

            // Save to the backend API asynchronously
            this.saveConfigToAPI(config).catch(error => {
                console.warn('Failed to save configuration to API:', error);
            }).finally(() => {
                this.init()
            });

            // Trigger a configuration change event
            window.dispatchEvent(new CustomEvent('featureConfigChanged', {
                detail: config
            }));
        } catch (error) {
            console.error('Failed to save feature configuration:', error);
        }
    }

    /**
     * Save configuration to the backend API
     */
    async saveConfigToAPI(config) {
        return new Promise((resolve) => {
            // Use the known ID (600) to update the parameter directly
            Api.admin.updateParam(
                {
                    id: 600,
                    paramCode: 'system-web.menu',
                    paramValue: JSON.stringify({
                        features: config,
                        groups: {
                            featureManagement: ["voiceprintRecognition", "voiceClone", "knowledgeBase", "mcpAccessPoint", "addressBook"],
                            voiceManagement: ["vad", "asr"]
                        }
                    }),
                    valueType: 'json',
                    remark: 'System feature menu configuration'
                },
                (updateResult) => {
                    if (updateResult.code === 0) {
                        resolve();
                    } else {
                        // If the update fails, the parameter may not exist or there may be another error; log it but do not prevent saving to localStorage
                        console.warn('Failed to update parameter:', updateResult.msg);
                        resolve(); // do not prevent saving to localStorage
                    }
                },
                (error) => {
                    console.warn('Failed to update parameter:', error);
                    resolve(); // do not prevent saving to localStorage
                }
            );
        });
    }



    /**
     * Get all feature configuration
     */
    getAllFeatures() {
        return this.getCurrentConfig();
    }

    /**
     * Get a simplified configuration object (for the home page component)
     */
    getConfig() {
        const features = this.getAllFeatures();
        return {
            voiceprintRecognition: features.voiceprintRecognition?.enabled || false,
            voiceClone: features.voiceClone?.enabled || false,
            knowledgeBase: features.knowledgeBase?.enabled || false,
            mcpAccessPoint: features.mcpAccessPoint?.enabled || false,
            vad: features.vad?.enabled || false,
            asr: features.asr?.enabled || false,
            addressBook: features.addressBook?.enabled || false
        };
    }

    /**
     * Get the status of the specified feature
     */
    getFeatureStatus(featureKey) {
        const features = this.getAllFeatures();
        return features[featureKey]?.enabled || false;
    }

    /**
     * Set feature status
     */
    setFeatureStatus(featureKey, enabled) {
        const features = this.getAllFeatures();
        if (features[featureKey]) {
            features[featureKey].enabled = enabled;
            this.saveConfig(features);
            return true;
        }
        return false;
    }

    /**
     * Enable a feature
     */
    enableFeature(featureKey) {
        return this.setFeatureStatus(featureKey, true);
    }

    /**
     * Disable a feature
     */
    disableFeature(featureKey) {
        return this.setFeatureStatus(featureKey, false);
    }

    /**
     * Toggle feature status
     */
    toggleFeature(featureKey) {
        const currentStatus = this.getFeatureStatus(featureKey);
        return this.setFeatureStatus(featureKey, !currentStatus);
    }

    /**
     * Reset all features to the default state
     */
    resetToDefault() {
        this.saveConfig(this.defaultFeatures);
    }

    /**
     * Batch update feature status
     */
    updateFeatures(featureUpdates) {
        const features = this.getAllFeatures();
        Object.keys(featureUpdates).forEach(featureKey => {
            if (features[featureKey]) {
                features[featureKey].enabled = featureUpdates[featureKey];
            } else if (this.defaultFeatures[featureKey]) {
                features[featureKey] = { ...this.defaultFeatures[featureKey] };
                features[featureKey].enabled = featureUpdates[featureKey];
            }
        });
        this.saveConfig(features);
    }

    /**
     * Get the list of enabled features
     */
    getEnabledFeatures() {
        const features = this.getAllFeatures();
        return Object.keys(features).filter(key => features[key].enabled);
    }

    /**
     * Check whether a feature is enabled
     */
    isFeatureEnabled(featureKey) {
        return this.getFeatureStatus(featureKey);
    }
}

// Create a singleton instance
const featureManager = new FeatureManager();

export default featureManager;