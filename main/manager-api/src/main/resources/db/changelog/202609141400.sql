-- Repair dangling LLM references in the system Memory / Intent providers.
--
-- Background: `Memory_mem_local_short.config_json.llm` pointed at 'LLM_ChatGLMLLM'
-- (a provider absent from this fork's catalog) and `Intent_intent_llm.config_json.llm`
-- pointed at 'GeminiLLM' (catalog id is 'LLM_GeminiLLM'). Both made the console's
-- POST /config/agent-models throw
--   Cannot invoke "ModelConfigEntity.getId()" because "memLocalShortLLM" is null,
-- returning HTTP 500 for every device. The Python server then received no TTS/LLM/
-- Memory/Intent sections, selected_module lacked "TTS", and TTS init failed with
-- KeyError('TTS') -> device showed "listening" but produced no reply.
--
-- This runs as a NEW changeset (earlier changelogs are left unchanged so their
-- Liquibase checksums stay valid). Idempotent: sets the same final values the
-- running DB was patched to on 2026-09-14.
UPDATE `ai_model_config`
SET `config_json` = '{"llm": "LLM_OllamaLLM", "type": "mem_local_short"}'
WHERE `id` = 'Memory_mem_local_short';

UPDATE `ai_model_config`
SET `config_json` = '{"llm": "LLM_GeminiLLM", "type": "intent_llm"}'
WHERE `id` = 'Intent_intent_llm';
