-- Remove non-streaming MiniMax TTS config, keep the streaming version

-- Delete the old non-streaming MiniMax TTS model config
DELETE FROM `ai_model_config` WHERE `id` = 'TTS_MinimaxTTS';

-- Delete the old non-streaming MiniMax TTS provider config  
DELETE FROM `ai_model_provider` WHERE `id` = 'SYSTEM_TTS_minimax';

-- Delete the old non-streaming MiniMax TTS voice config
DELETE FROM `ai_tts_voice` WHERE `tts_model_id` = 'TTS_MinimaxTTS';
