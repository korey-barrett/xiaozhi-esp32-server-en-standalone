-- Add Alibaba Cloud streaming TTS provider
delete from `ai_model_provider` where id = 'SYSTEM_TTS_AliyunStreamTTS';
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`) VALUES
('SYSTEM_TTS_AliyunStreamTTS', 'TTS', 'aliyun_stream', 'Alibaba Cloud Speech Synthesis (Streaming)', '[{"key":"appkey","label":"Application AppKey","type":"string"},{"key":"token","label":"Temporary Token","type":"string"},{"key":"access_key_id","label":"AccessKey ID","type":"string"},{"key":"access_key_secret","label":"AccessKey Secret","type":"string"},{"key":"host","label":"Service endpoint","type":"string"},{"key":"voice","label":"Default voice","type":"string"},{"key":"format","label":"Audio format","type":"string"},{"key":"sample_rate","label":"Sample rate","type":"number"},{"key":"volume","label":"Volume","type":"number"},{"key":"speech_rate","label":"Speech rate","type":"number"},{"key":"pitch_rate","label":"Pitch","type":"number"},{"key":"output_dir","label":"Output directory","type":"string"}]', 15, 1, NOW(), 1, NOW());

-- Add Alibaba Cloud streaming TTS model configuration
delete from `ai_model_config` where id = 'TTS_AliyunStreamTTS';
INSERT INTO `ai_model_config` VALUES ('TTS_AliyunStreamTTS', 'TTS', 'AliyunStreamTTS', 'Alibaba Cloud Speech Synthesis (Streaming)', 0, 1, '{\"type\": \"aliyun_stream\", \"appkey\": \"\", \"token\": \"\", \"access_key_id\": \"\", \"access_key_secret\": \"\", \"host\": \"nls-gateway-cn-beijing.aliyuncs.com\", \"voice\": \"longxiaochun\", \"format\": \"pcm\", \"sample_rate\": 16000, \"volume\": 50, \"speech_rate\": 0, \"pitch_rate\": 0, \"output_dir\": \"tmp/\"}', NULL, NULL, 18, NULL, NULL, NULL, NULL);

-- Update Alibaba Cloud streaming TTS configuration description
UPDATE `ai_model_config` SET 
`doc_link` = 'https://nls-portal.console.aliyun.com/',
`remark` = 'Alibaba Cloud streaming TTS configuration description:
1. The difference between Alibaba Cloud TTS and Alibaba Cloud (streaming) TTS is: Alibaba Cloud TTS synthesizes a single utterance, while Alibaba Cloud (streaming) TTS performs real-time streaming synthesis
2. Streaming TTS has lower latency and better real-time performance, making it suitable for voice interaction scenarios
3. You need to create an application in the Alibaba Cloud Intelligent Speech Interaction console and obtain authentication information
4. Supports CosyVoice large-model voices with more natural quality
5. Supports real-time adjustment of volume, speech rate, pitch, and other parameters
Application steps:
1. Visit https://nls-portal.console.aliyun.com/ to enable the Intelligent Speech Interaction service
2. Visit https://nls-portal.console.aliyun.com/applist to create a project and obtain the appkey
3. Visit https://nls-portal.console.aliyun.com/overview to obtain a temporary token (or configure access_key_id and access_key_secret for automatic retrieval)
4. For dynamic token management, we recommend configuring access_key_id and access_key_secret
5. Servers in different regions such as Beijing and Shanghai can be selected to optimize latency
6. The voice parameter supports CosyVoice large-model voices, such as longxiaochun, longyueyue, etc.
For more parameter configuration, please refer to: https://help.aliyun.com/zh/isi/developer-reference/real-time-speech-synthesis
' WHERE `id` = 'TTS_AliyunStreamTTS';

-- Add Alibaba Cloud streaming TTS voices
delete from `ai_tts_voice` where tts_model_id = 'TTS_AliyunStreamTTS';
-- Gentle female voice series
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0001', 'TTS_AliyunStreamTTS', 'Long Xiaochun - Gentle Older Sister', 'longxiaochun', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0002', 'TTS_AliyunStreamTTS', 'Long Xiaoxia - Gentle Female Voice', 'longxiaoxia', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0003', 'TTS_AliyunStreamTTS', 'Long Mei - Gentle Female Voice', 'longmei', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0004', 'TTS_AliyunStreamTTS', 'Long Gui - Gentle Female Voice', 'longgui', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL);
-- Mature female voice series
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0005', 'TTS_AliyunStreamTTS', 'Long Yu - Mature Female Voice', 'longyu', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0006', 'TTS_AliyunStreamTTS', 'Long Jiao - Mature Female Voice', 'longjiao', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL);
-- Male voice series
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0007', 'TTS_AliyunStreamTTS', 'Long Chen - Dubbed Film Male Voice', 'longchen', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 7, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0008', 'TTS_AliyunStreamTTS', 'Long Xiu - Young Male Voice', 'longxiu', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0009', 'TTS_AliyunStreamTTS', 'Long Cheng - Sunny Male Voice', 'longcheng', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0010', 'TTS_AliyunStreamTTS', 'Long Zhe - Mature Male Voice', 'longzhe', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL);
-- Professional broadcast series
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0011', 'TTS_AliyunStreamTTS', 'Bella2.0 - News Female Voice', 'loongbella', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0012', 'TTS_AliyunStreamTTS', 'Stella2.0 - Confident Female Voice', 'loongstella', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0013', 'TTS_AliyunStreamTTS', 'Long Shu - News Male Voice', 'longshu', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0014', 'TTS_AliyunStreamTTS', 'Long Jing - Serious Female Voice', 'longjing', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 14, NULL, NULL, NULL, NULL);
-- Signature voice series
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0015', 'TTS_AliyunStreamTTS', 'Long Qi - Lively Child Voice', 'longqi', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0016', 'TTS_AliyunStreamTTS', 'Long Hua - Lively Child Voice', 'longhua', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 16, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0017', 'TTS_AliyunStreamTTS', 'Long Wu - Whimsical Male Voice', 'longwu', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 17, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0018', 'TTS_AliyunStreamTTS', 'Long Dachui - Humorous Male Voice', 'longdachui', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 18, NULL, NULL, NULL, NULL);
-- Cantonese voice series
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0019', 'TTS_AliyunStreamTTS', 'Long Jiayi - Cantonese Female Voice', 'longjiayi', 'Cantonese and mixed Cantonese-English', NULL, NULL, NULL, NULL, 19, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_AliyunStreamTTS_0020', 'TTS_AliyunStreamTTS', 'Long Tao - Cantonese Female Voice', 'longtao', 'Cantonese and mixed Cantonese-English', NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL, NULL);
