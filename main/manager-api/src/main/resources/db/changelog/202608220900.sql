-- English / local model defaults (remove Zhipu/ChatGLM as the default provider)
-- Applies to any existing database: flips the default LLM/VLLM to Google Gemini
-- (free tier, non-Chinese), makes the default TTS voice English, and repoints
-- agent defaults away from the Chinese Zhipu service. Idempotent.

-- 1. LLM default -> Google Gemini (free tier)
UPDATE `ai_model_config` SET `is_default` = 0 WHERE `id` IN ('LLM_ChatGLMLLM', 'LLM_OllamaLLM');
UPDATE `ai_model_config` SET `is_default` = 1, `is_enabled` = 1 WHERE `id` = 'LLM_GeminiLLM';

-- 2. Intent LLM helper no longer points at Zhipu
UPDATE `ai_model_config` SET `config_json` = '{\"type\": \"intent_llm\", \"llm\": \"GeminiLLM\"}' WHERE `id` = 'Intent_intent_llm';

-- 3. TTS default voice -> English (Edge TTS is a Microsoft, non-Chinese service)
UPDATE `ai_model_config`
SET `config_json` = '{\"type\": \"edge\", \"voice\": \"en-US-AriaNeural\", \"output_dir\": \"tmp/\"}'
WHERE `id` = 'TTS_EdgeTTS';

-- 4. VLLM default -> Google Gemini vision (add config if missing)
INSERT INTO `ai_model_config` (`id`, `model_type`, `model_code`, `name`, `is_default`, `is_enabled`, `config_json`, `sort`)
SELECT 'VLLM_GeminiVLM', 'VLLM', 'GeminiVLM', 'Google Gemini Vision', 1, 1,
       '{\"type\": \"openai\", \"model_name\": \"gemini-2.0-flash\", \"base_url\": \"https://generativelanguage.googleapis.com/v1beta/openai/\", \"api_key\": \"YOUR_API_KEY\"}',
       3
WHERE NOT EXISTS (SELECT 1 FROM `ai_model_config` WHERE `id` = 'VLLM_GeminiVLM');
UPDATE `ai_model_config` SET `is_default` = 0, `is_enabled` = 1 WHERE `id` IN ('VLLM_ChatGLMVLLM', 'VLLM_OllamaVLM');
UPDATE `ai_model_config` SET `is_default` = 1, `is_enabled` = 1 WHERE `id` = 'VLLM_GeminiVLM';

-- 5. Default vision model for existing agents / templates and new rows
UPDATE `ai_agent` SET `vllm_model_id` = 'VLLM_GeminiVLM' WHERE `vllm_model_id` IN ('VLLM_ChatGLMVLLM', 'VLLM_OllamaVLM');
UPDATE `ai_agent_template` SET `vllm_model_id` = 'VLLM_GeminiVLM' WHERE `vllm_model_id` IN ('VLLM_ChatGLMVLLM', 'VLLM_OllamaVLM');
ALTER TABLE `ai_agent` ALTER COLUMN `vllm_model_id` SET DEFAULT 'VLLM_GeminiVLM';
ALTER TABLE `ai_agent_template` ALTER COLUMN `vllm_model_id` SET DEFAULT 'VLLM_GeminiVLM';
