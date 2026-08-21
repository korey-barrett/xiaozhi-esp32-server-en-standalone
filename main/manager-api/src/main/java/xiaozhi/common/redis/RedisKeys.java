package xiaozhi.common.redis;

/**
 * Redis Key constants class
 * Copyright (c) renren.io All rights reserved.
 * Website: https://www.renren.io
 */
public class RedisKeys {
    /**
     * System parameter key
     */
    public static String getSysParamsKey() {
        return "sys:params";
    }

    /**
     * Captcha key
     */
    public static String getCaptchaKey(String uuid) {
        return "sys:captcha:" + uuid;
    }

    /**
     * Unregistered device captcha key
     */
    public static String getDeviceCaptchaKey(String captcha) {
        return "sys:device:captcha:" + captcha;
    }

    /**
     * User ID key
     */
    public static String getUserIdKey(Long userid) {
        return "sys:username:id:" + userid;
    }

    /**
     * Model name key
     */
    public static String getModelNameById(String id) {
        return "model:name:" + id;
    }

    /**
     * Model configuration key
     */
    public static String getModelConfigById(String id) {
        return "model:data:" + id;
    }

    /**
     * Timbre name cache key
     */
    public static String getTimbreNameById(String id) {
        return "timbre:name:" + id;
    }

    /**
     * Agent device count cache key
     */
    public static String getAgentDeviceCountById(String id) {
        return "agent:device:count:" + id;
    }

    /**
     * Agent last connection time cache key
     */
    public static String getAgentDeviceLastConnectedAtById(String id) {
        return "agent:device:lastConnected:" + id;
    }

    /**
     * System configuration cache key
     */
    public static String getServerConfigKey() {
        return "server:config";
    }

    /**
     * Timbre details cache key
     */
    public static String getTimbreDetailsKey(String id) {
        return "timbre:details:" + id;
    }

    /**
     * Version number key
     */
    public static String getVersionKey() {
        return "sys:version";
    }

    /**
     * OTA firmware ID key
     */
    public static String getOtaIdKey(String uuid) {
        return "ota:id:" + uuid;
    }

    /**
     * OTA firmware download count key
     */
    public static String getOtaDownloadCountKey(String uuid) {
        return "ota:download:count:" + uuid;
    }

    /**
     * Dictionary data cache key
     */
    public static String getDictDataByTypeKey(String dictType) {
        return "sys:dict:data:" + dictType;
    }

    /**
     * Agent audio ID cache key
     */
    public static String getAgentAudioIdKey(String uuid) {
        return "agent:audio:id:" + uuid;
    }

    /**
     * SMS verification code cache key
     */
    public static String getSMSValidateCodeKey(String phone) {
        return "sms:Validate:Code:" + phone;
    }

    /**
     * SMS verification code last send time cache key
     */
    public static String getSMSLastSendTimeKey(String phone) {
        return "sms:Validate:Code:" + phone + ":last_send_time";
    }

    /**
     * SMS verification code daily send count cache key
     */
    public static String getSMSTodayCountKey(String phone) {
        return "sms:Validate:Code:" + phone + ":today_count";
    }

    /**
     * Chat history UUID mapping key
     */
    public static String getChatHistoryKey(String uuid) {
        return "agent:chat:history:" + uuid;
    }

    /**
     * Voice clone audio ID cache key
     */
    public static String getVoiceCloneAudioIdKey(String uuid) {
        return "voiceClone:audio:id:" + uuid;
    }

    /**
     * Knowledge base cache key
     */
    public static String getKnowledgeBaseCacheKey(String datasetId) {
        return "knowledge:base:" + datasetId;
    }

    /**
     * Temporary registered device marker key
     */
    public static String getTmpRegisterMacKey(String deviceId) {
        return "tmp_register_mac:" + deviceId;
    }

    /**
     * OTA bound device
     */
    public static String getOtaActivationCode(String activationCode) {
        return "ota:activation:code:" + activationCode;
    }

    /**
     * OTA device MAC related information
     */
    public static String getOtaDeviceActivationInfo(String deviceId) {
        return "ota:activation:data:" + deviceId;
    }

    /**
     * OTA upload count
     */
    public static String getOtaUploadCountKey(Long username) {
        return "ota:upload:count:" + username;
    }

    /**
     * Device address book cache key
     */
    public static String getAddressBookKey() {
        return "device:address_book:all";
    }

}
