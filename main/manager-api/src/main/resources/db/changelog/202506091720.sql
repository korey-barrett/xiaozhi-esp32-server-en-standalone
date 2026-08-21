ALTER TABLE `ai_tts_voice`
ADD COLUMN `reference_audio` VARCHAR(500) DEFAULT NULL COMMENT 'reference audio path' AFTER `remark`,
ADD COLUMN `reference_text` VARCHAR(500) DEFAULT NULL COMMENT 'reference text' AFTER `reference_audio`;
