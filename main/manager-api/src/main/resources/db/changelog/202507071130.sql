-- Add Alibaba Cloud streaming ASR provider
delete from `ai_model_provider` where id = 'SYSTEM_ASR_AliyunStreamASR';
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`) VALUES
('SYSTEM_ASR_AliyunStreamASR', 'ASR', 'aliyun_stream', 'Alibaba Cloud Speech Recognition (Streaming)', '[{"key":"appkey","label":"Application AppKey","type":"string"},{"key":"token","label":"Temporary Token","type":"string"},{"key":"access_key_id","label":"AccessKey ID","type":"string"},{"key":"access_key_secret","label":"AccessKey Secret","type":"string"},{"key":"host","label":"Service endpoint","type":"string"},{"key":"max_sentence_silence","label":"Sentence segmentation detection time","type":"number"},{"key":"output_dir","label":"Output directory","type":"string"}]', 6, 1, NOW(), 1, NOW());

-- Add Alibaba Cloud streaming ASR model configuration
delete from `ai_model_config` where id = 'ASR_AliyunStreamASR';
INSERT INTO `ai_model_config` VALUES ('ASR_AliyunStreamASR', 'ASR', 'AliyunStreamASR', 'Alibaba Cloud Speech Recognition (Streaming)', 0, 1, '{\"type\": \"aliyun_stream\", \"appkey\": \"\", \"token\": \"\", \"access_key_id\": \"\", \"access_key_secret\": \"\", \"host\": \"nls-gateway-cn-shanghai.aliyuncs.com\", \"max_sentence_silence\": 800, \"output_dir\": \"tmp/\"}', NULL, NULL, 8, NULL, NULL, NULL, NULL);

-- Update Alibaba Cloud streaming ASR configuration description
UPDATE `ai_model_config` SET 
`doc_link` = 'https://nls-portal.console.aliyun.com/',
`remark` = 'Alibaba Cloud streaming ASR configuration description:
1. The difference between Alibaba Cloud ASR and Alibaba Cloud (streaming) ASR is: Alibaba Cloud ASR recognizes a single utterance, while Alibaba Cloud (streaming) ASR performs real-time streaming recognition
2. Streaming ASR has lower latency and better real-time performance, making it suitable for voice interaction scenarios
3. You need to create an application in the Alibaba Cloud Intelligent Speech Interaction console and obtain authentication information
4. Supports real-time Mandarin speech recognition, punctuation prediction, and inverse text normalization
5. Requires a network connection; output files are saved to the tmp/ directory
Application steps:
1. Visit https://nls-portal.console.aliyun.com/ to enable the Intelligent Speech Interaction service
2. Visit https://nls-portal.console.aliyun.com/applist to create a project and obtain the appkey
3. Visit https://nls-portal.console.aliyun.com/overview to obtain a temporary token (or configure access_key_id and access_key_secret for automatic retrieval)
4. For dynamic token management, we recommend configuring access_key_id and access_key_secret
5. The max_sentence_silence parameter controls the sentence segmentation detection time (in milliseconds), default 800ms
For more parameter configuration, please refer to: https://help.aliyun.com/zh/isi/developer-reference/real-time-speech-recognition
' WHERE `id` = 'ASR_AliyunStreamASR';
