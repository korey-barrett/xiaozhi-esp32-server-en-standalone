-- Add Index-TTS-vLLM streaming TTS provider
delete from `ai_model_provider` where id = 'SYSTEM_TTS_IndexStreamTTS';
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`) VALUES
('SYSTEM_TTS_IndexStreamTTS', 'TTS', 'index_stream', 'Index-TTS-vLLM Streaming TTS', '[{"key":"api_url","label":"API Service URL","type":"string"},{"key":"voice","label":"Default Voice","type":"string"},{"key":"audio_format","label":"Audio Format","type":"string"},{"key":"output_dir","label":"Output Directory","type":"string"}]', 16, 1, NOW(), 1, NOW());

-- Add Index-TTS-vLLM streaming TTS model config
delete from `ai_model_config` where id = 'TTS_IndexStreamTTS';
INSERT INTO `ai_model_config` VALUES ('TTS_IndexStreamTTS', 'TTS', 'IndexStreamTTS', 'Index-TTS-vLLM Streaming TTS', 0, 1, '{\"type\": \"index_stream\", \"api_url\": \"http://127.0.0.1:11996/tts\", \"voice\": \"jay_klee\", \"audio_format\": \"pcm\", \"output_dir\": \"tmp/\"}', NULL, NULL, 19, NULL, NULL, NULL, NULL);

-- Update Index-TTS-vLLM streaming TTS config description
UPDATE `ai_model_config` SET 
`doc_link` = 'https://github.com/Ksuriuri/index-tts-vllm',
`remark` = 'Index-TTS-vLLM Streaming TTS Configuration Guide:
1. Index-TTS-vLLM is a vLLM inference service based on the Index-TTS project, providing streaming speech synthesis
2. Supports multiple voices with natural quality, suitable for various voice interaction scenarios
3. Requires deploying the Index-TTS-vLLM service first, then configuring the API URL
4. Supports real-time streaming synthesis with low latency
5. Supports custom voices; you can register new voices under the project''s assets folder
Deployment Steps:
1. Clone the project: git clone https://github.com/Ksuriuri/index-tts-vllm.git
2. Install dependencies: pip install -r requirements.txt
3. Start the service: python app.py
4. The service runs on http://127.0.0.1:11996 by default
5. For other voices, register them under the project''s assets folder
6. Supports multiple audio formats: pcm, wav, mp3, etc.
For more configuration options, see: https://github.com/Ksuriuri/index-tts-vllm/blob/master/README.md
' WHERE `id` = 'TTS_IndexStreamTTS';

-- Add Index-TTS-vLLM streaming TTS voices
delete from `ai_tts_voice` where tts_model_id = 'TTS_IndexStreamTTS';
-- Default voice
INSERT INTO `ai_tts_voice` VALUES ('TTS_IndexStreamTTS_0001', 'TTS_IndexStreamTTS', 'Jay Klee', 'jay_klee', 'Chinese and mixed Chinese-English', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL);
