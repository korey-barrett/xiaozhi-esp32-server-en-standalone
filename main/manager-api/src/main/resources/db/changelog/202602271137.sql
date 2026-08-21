-- Update the Tencent TTS provider config to add speed, volume, and format parameters
UPDATE `ai_model_provider`
SET fields = '[{"key":"appid","label":"Application ID","type":"string"},{"key":"secret_id","label":"Secret ID","type":"string"},{"key":"secret_key","label":"Secret Key","type":"string"},{"key":"format","label":"Audio Format","type":"string"},{"key":"speed","label":"Speed","type":"number"},{"key":"volume","label":"Volume","type":"number"},{"key":"output_dir","label":"Output Directory","type":"string"},{"key":"voice","label":"Voice ID","type":"string"},{"key":"region","label":"Region","type":"string"}]'
WHERE id = 'SYSTEM_TTS_TencentTTS';

-- Update the Tencent TTS model config to add speed and volume parameters, and supplement parameter notes
UPDATE `ai_model_config` SET 
    `config_json` = JSON_SET(`config_json`, '$.speed', 0, '$.volume', 0),
    `remark` = 'Tencent TTS configuration notes:
1. You need to enable the Intelligent Speech Interaction service on the Tencent Cloud platform
2. Multiple voices are supported; the current config uses 101001
3. A network connection is required
4. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://console.cloud.tencent.com/cam/capi to obtain the key
2. Visit https://console.cloud.tencent.com/tts/resourcebundle to claim free resources
3. Create a new application
4. Obtain appid, secret_id, and secret_key
5. Fill them into the configuration file
Audio parameters:
- format: audio format, supports pcm, wav, mp3
- speed: speech rate, range -2~6, default 0
- volume: volume, range -10~10, default 0'
WHERE `id` = 'TTS_TencentTTS';

-- Update the CozeCnTTS provider config to add speed and loudness_rate parameters
UPDATE `ai_model_provider`
SET fields = '[{"key":"voice","label":"Voice","type":"string"},{"key":"access_token","label":"Access Token","type":"string"},{"key":"speed","label":"Speed","type":"number"},{"key":"loudness_rate","label":"Volume Gain","type":"number"},{"key":"output_dir","label":"Output Directory","type":"string"},{"key":"response_format","label":"Response Format","type":"string"}]'
WHERE id = 'SYSTEM_TTS_cozecn';

-- Update the CozeCnTTS model config to add speed and loudness_rate parameters, and supplement parameter notes
UPDATE `ai_model_config` SET 
    `config_json` = JSON_SET(`config_json`, '$.speed', 1, '$.loudness_rate', 0),
    `remark` = 'Coze Chinese speech synthesis configuration notes:
1. Visit https://www.coze.cn/ to register and log in
2. Create an application and obtain the access_token
3. Choose an appropriate voice ID
Audio parameters:
- response_format: audio format, supports pcm, wav, mp3
- speed: speech rate, range 0.5~2, default 1
- loudness_rate: volume gain, range -50~100, default 0'
WHERE `id` = 'TTS_CozeCnTTS';
