-- Add Xunfei streaming TTS provider
delete from `ai_model_provider` where id = 'SYSTEM_TTS_XunFeiStreamTTS';
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`) VALUES
('SYSTEM_TTS_XunFeiStreamTTS', 'TTS', 'xunfei_stream', 'Xunfei Streaming Speech Synthesis', '[{"key":"app_id","label":"APP_ID","type":"string"},{"key":"api_secret","label":"API_Secret","type":"string"},{"key":"api_key","label":"API Key","type":"string"},{"key":"output_dir","label":"Output Directory","type":"string"},{"key":"voice","label":"Voice","type":"string"},{"key":"format","label":"Audio Format","type":"string"},{"key":"sample_rate","label":"Sample Rate","type":"number"},{"key": "volume", "type": "number", "label": "Volume"},{"key": "speed", "type": "number", "label": "Speech Rate"},{"key": "pitch", "type": "number", "label": "Pitch"},{"key": "oral_level", "type": "number", "label": "Colloquial Level"},{"key": "spark_assist", "type": "number", "label": "Use Colloquial Mode"},{"key": "stop_split", "type": "number", "label": "Server-Side Sentence Splitting"},{"key": "remain", "type": "number", "label": "Keep Written Form"}]', 20, 1, NOW(), 1, NOW());

-- Add Xunfei streaming TTS model configuration
delete from `ai_model_config` where id = 'TTS_XunFeiStreamTTS';
INSERT INTO `ai_model_config` VALUES ('TTS_XunFeiStreamTTS', 'TTS', 'XunFeiStreamTTS', 'Xunfei Streaming Speech Synthesis', 0, 1, '{\"type\": \"xunfei_stream\", \"app_id\": \"\", \"api_secret\": \"\", \"api_key\": \"\", \"output_dir\": \"tmp/\", \"voice\": \"x5_lingxiaoxuan_flow\", \"format\": \"raw\", \"sample_rate\": 24000, \"volume\": 50, \"speed\": 50, \"pitch\": 50, \"oral_level\": \"mid\", \"spark_assist\": 1, \"stop_split\": 0, \"remain\": 0}', NULL, NULL, 23, NULL, NULL, NULL, NULL);

-- Update Xunfei streaming TTS configuration notes
UPDATE `ai_model_config` SET 
`doc_link` = 'https://console.xfyun.cn/app/myapp',
`remark` = 'Xunfei streaming TTS notes:
1. Log in to the Xunfei speech platform https://console.xfyun.cn/app/myapp to create the relevant application
2. Select the required service to obtain the API configuration https://console.xfyun.cn/services/uts
3. Purchase the relevant service for the application (APPID) you need, e.g. ultra-realistic synthesis https://console.xfyun.cn/services/uts
5. Supports real-time dual-stream communication with low latency
6. Supports colloquial settings and audio parameter tuning. Note: V5 voices do not support the related colloquial configuration
7. Supports real-time adjustment of volume, speech rate, pitch, and other parameters
' WHERE `id` = 'TTS_XunFeiStreamTTS';

-- Add Xunfei streaming TTS voices
delete from `ai_tts_voice` where tts_model_id = 'TTS_XunFeiStreamTTS';

-- Basic roles
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0001', 'TTS_XunFeiStreamTTS', 'Ling Xiaoxuan', 'x5_lingxiaoxuan_flow', 'Chinese', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0002', 'TTS_XunFeiStreamTTS', 'Ling Feiyi', 'x5_lingfeiyi_flow', 'Chinese', NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0003', 'TTS_XunFeiStreamTTS', 'Ling Xiaoyue', 'x5_lingxiaoyue_flow', 'Chinese', NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0004', 'TTS_XunFeiStreamTTS', 'Ling Yuzhao', 'x5_lingyuzhao_flow', 'Chinese', NULL, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0005', 'TTS_XunFeiStreamTTS', 'Ling Yuyan', 'x5_lingyuyan_flow', 'Chinese', NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL);

-- Add corresponding character voices
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0006', 'TTS_XunFeiStreamTTS', 'Ling Feizhe', 'x4_lingfeizhe_oral', 'Chinese', NULL, NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0007', 'TTS_XunFeiStreamTTS', 'Ling Xiaoli', 'x4_lingxiaoli_oral', 'Chinese', NULL, NULL, NULL, NULL, 7, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0008', 'TTS_XunFeiStreamTTS', 'Ling Xiaotang', 'x5_lingxiaotang_flow', 'Chinese', NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0009', 'TTS_XunFeiStreamTTS', 'Ling Xiaoqi', 'x4_lingxiaoqi_oral', 'Chinese', NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0010', 'TTS_XunFeiStreamTTS', 'Ling Youyou - Childhood Female Voice', 'x4_lingyouyou_oral', 'Chinese', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0011', 'TTS_XunFeiStreamTTS', 'Zi Jin', 'x4_zijin_oral', 'Tianjin Dialect', NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0012', 'TTS_XunFeiStreamTTS', 'Zi Yang', 'x4_ziyang_oral', 'Northeastern Dialect', NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0013', 'TTS_XunFeiStreamTTS', 'Grant', 'x5_EnUs_Grant_flow', 'English', NULL, NULL, NULL, NULL, 13, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_XunFeiStreamTTS_0014', 'TTS_XunFeiStreamTTS', 'Lila', 'x5_EnUs_Lila_flow', 'English', NULL, NULL, NULL, NULL, 14, NULL, NULL, NULL, NULL);
