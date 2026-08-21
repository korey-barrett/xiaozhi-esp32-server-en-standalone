-- Fix duplicate provider_code for Doubao TTS Model 2.0, add ASR 2.0 support

-- ==================== Doubao TTS Model 2.0 ====================
-- Delete the TTS 2.0 provider (a separate provider is no longer needed)
delete from `ai_model_provider` where id = 'SYSTEM_TTS_HSDSTTS_V2';

-- ==================== Doubao Speech Recognition (Streaming) ====================
-- Fix the existing Doubao speech recognition (streaming) provider: remove the cluster field and add the resource_id field
UPDATE `ai_model_provider` SET `fields` = '[{"key":"appid","type":"string","label":"App ID"},{"key":"access_token","type":"string","label":"Access Token"},{"key":"boosting_table_name","type":"string","label":"Hot word file name"},{"key":"correct_table_name","type":"string","label":"Replacement word file name"},{"key":"output_dir","type":"string","label":"Output directory"},{"key":"end_window_size","type":"number","label":"Silence threshold (ms)"},{"key":"enable_multilingual","type":"boolean","label":"Enable multilingual recognition mode"},{"key":"language","type":"string","label":"Language code"},{"key":"resource_id","type":"string","label":"Resource ID"}]' WHERE `id` = 'SYSTEM_ASR_DoubaoStreamASR';

-- Fix the existing Doubao speech recognition (streaming) config: remove the cluster field and add the resource_id default value
UPDATE `ai_model_config` SET `config_json` = JSON_REMOVE(JSON_SET(`config_json`, '$.resource_id', 'volc.bigasr.sauc.duration'), '$.cluster') WHERE `id` = 'ASR_DoubaoStreamASR';

-- ==================== Doubao Speech Recognition Model 2.0 ====================

-- Insert Doubao speech recognition model 2.0 config
delete from `ai_model_config` where id = 'ASR_DoubaoStreamASRV2';
INSERT INTO `ai_model_config` VALUES ('ASR_DoubaoStreamASRV2', 'ASR', 'DoubaoStreamASRV2', 'Doubao Speech Recognition Model 2.0', 0, 1, '{
  "type": "doubao_stream",
  "appid": "",
  "access_token": "",
  "resource_id": "volc.seedasr.sauc.duration",
  "end_window_size": 200,
  "enable_multilingual": false,
  "language": "zh-CN",
  "output_dir": "tmp/"
}', NULL, NULL, 6, NULL, NULL, NULL, NULL);

-- Doubao speech recognition model 2.0 configuration documentation
UPDATE `ai_model_config` SET
`doc_link` = 'https://www.volcengine.com/docs/6561/109979',
`remark` = 'Doubao speech recognition model 2.0 configuration guide (based on Volcengine seed-asr):
1. Visit https://www.volcengine.com/ to register and activate a Volcengine account
2. Visit https://console.volcengine.com/speech/service/10038 to enable Doubao streaming speech recognition model 2.0
3. Obtain the appid and access_token at the bottom of the page
4. There are two resource IDs: hourly (volc.seedasr.sauc.duration) and concurrent (volc.seedasr.sauc.concurrent)
   - Hourly: fixed as: volc.seedasr.sauc.duration (Doubao speech recognition model 2.0)
   - Concurrent: fixed as: volc.seedasr.sauc.concurrent (Doubao speech recognition model 2.0)

Detailed parameter documentation: https://www.volcengine.com/docs/6561/109979

Notes:
- Doubao speech recognition model 2.0 uses the volc.seedasr.sauc.duration resource ID, different from Doubao speech recognition (streaming) (volc.bigasr.sauc.duration)
- Speech recognition model 2.0 is cheaper; it is recommended to use the concurrent resource ID in high-concurrency scenarios
' WHERE `id` = 'ASR_DoubaoStreamASRV2';
