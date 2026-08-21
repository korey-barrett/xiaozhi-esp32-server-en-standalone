-- Update HuoshanDoubleStreamTTS provider config: add option to enable connection reuse
UPDATE `ai_model_provider`
SET fields = '[{"key": "ws_url", "type": "string", "label": "WebSocket Address"}, {"key": "appid", "type": "string", "label": "Application ID"}, {"key": "access_token", "type": "string", "label": "Access Token"}, {"key": "resource_id", "type": "string", "label": "Resource ID"}, {"key": "speaker", "type": "string", "label": "Default Timbre"}, {"key": "enable_ws_reuse", "type": "boolean", "label": "Enable connection reuse", "default": true}, {"key": "speech_rate", "type": "number", "label": "Speech Rate (-50~100)"}, {"key": "loudness_rate", "type": "number", "label": "Volume (-50~100)"}, {"key": "pitch", "type": "number", "label": "Pitch (-12~12)"}]'
WHERE id = 'SYSTEM_TTS_HSDSTTS';

UPDATE `ai_model_config` SET 
`doc_link` = 'https://console.volcengine.com/speech/service/10007',
`remark` = 'Volcano Engine TTS service configuration notes:
1. Visit https://www.volcengine.com/ to register and activate a Volcano Engine account
2. Visit https://console.volcengine.com/speech/service/10007 to enable the TTS model and purchase a timbre
3. Obtain appid and access_token at the bottom of the page
5. The resource ID is fixed as: volc.service_type.10029 (TTS and audio mixing)
6. Connection reuse: enable WebSocket connection reuse, default true to reduce connection overhead (note: when reuse is enabled, idle connections consume concurrency while the device is in the listening state)
7. Speech rate: -50~100, optional; default 0, range -50~100
8. Volume: -50~100, optional; default 0, range -50~100
9. Pitch: -12~12, optional; default 0, range -12~12
10. Fill them into the config file' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS';