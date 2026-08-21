-- Add Xunfei streaming speech recognition service configuration
delete from `ai_model_provider` where id = 'SYSTEM_ASR_XunfeiStream';
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`) VALUES
('SYSTEM_ASR_XunfeiStream', 'ASR', 'xunfei_stream', 'Xunfei Streaming Speech Recognition', '[{"key":"app_id","label":"Application ID","type":"string"},{"key":"api_key","label":"API_KEY","type":"password"},{"key":"api_secret","label":"API_SECRET","type":"password"},{"key":"domain","label":"Recognition Domain","type":"string"},{"key":"language","label":"Recognition Language","type":"string"},{"key":"accent","label":"Dialect","type":"string"},{"key":"dwa","label":"Dynamic Correction","type":"string"},{"key":"output_dir","label":"Output Directory","type":"string"}]', 18, 1, NOW(), 1, NOW());

delete from `ai_model_config` where id = 'ASR_XunfeiStream';
INSERT INTO `ai_model_config` VALUES ('ASR_XunfeiStream', 'ASR', 'Xunfei Streaming Speech Recognition', 'Xunfei Streaming Speech Recognition Service', 0, 1, '{"type": "xunfei_stream", "app_id": "", "api_key": "", "api_secret": "", "domain": "slm", "language": "zh_cn", "accent": "mandarin", "dwa": "wpgs", "output_dir": "tmp/"}', 'https://www.xfyun.cn/doc/spark/spark_zh_iat.html', 'Supports real-time streaming speech recognition for Mandarin Chinese and a variety of dialects', 21, NULL, NULL, NULL, NULL);

-- Update Xunfei streaming speech recognition model configuration documentation
UPDATE `ai_model_config` SET
`doc_link` = 'https://www.xfyun.cn/doc/spark/spark_zh_iat.html',
`remark` = 'Xunfei streaming speech recognition configuration notes:
1. Log in to the Xunfei open platform https://www.xfyun.cn/
2. Create a speech recognition application to obtain the APPID, APISecret, and APIKey
3. Parameter notes:
   - app_id: Application ID, obtained after creating an application on the Xunfei open platform
   - api_key: API key, used for interface authentication
   - api_secret: API key, used to generate the signature
   - domain: Recognition domain, defaults to slm (intelligent speech transcription)
   - language: Recognition language, defaults to zh_cn (Chinese)
   - accent: Dialect type, defaults to mandarin (Mandarin), supports cantonese (Cantonese) and others
   - dwa: Dynamic correction, defaults to wpgs (enables dynamic correction)
   - output_dir: Audio file output directory, defaults to tmp/
4. Supports real-time streaming recognition, suitable for real-time voice interaction scenarios
5. Supports recognition of multiple dialects and languages
' WHERE `id` = 'ASR_XunfeiStream';