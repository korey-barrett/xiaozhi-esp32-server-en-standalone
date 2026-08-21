-- Standardize the language type data of ai_tts_voice
UPDATE ai_tts_voice
SET languages = CASE
    WHEN languages IN ('Chinese', 'Mandarin','Northeastern Dialect','Tianjin Dialect','Chinese-Beijing Accent','Chinese-Qingdao Accent','Chinese-Henan Accent','Chinese-Guangxi Accent','Liaoning','Shaanxi','Chinese-Sichuan Accent','Chinese-Taiwan Accent','Chinese-Changsha Accent') THEN 'Mandarin'
    WHEN languages IN ('Chinese and Chinese-English Mixed', 'Chinese, English', 'Chinese, American English','Chinese-Beijing Accent, English','Chinese (Northeast) and Chinese-English Mixed') THEN 'Mandarin, English'
    WHEN languages IN ('British English', 'British English', 'American English', 'Australian English', 'English') THEN 'English'
    WHEN languages = 'Japanese' THEN 'Japanese'
    WHEN languages = 'Japanese, Spanish' THEN 'Japanese, Spanish'
    WHEN languages = 'Korean' THEN 'Korean'
    WHEN languages IN ('Cantonese', 'Chinese-Guangdong Accent') THEN 'Cantonese'
    WHEN languages = 'Chinese (Cantonese) and Chinese-English Mixed' THEN 'Cantonese, English'
    WHEN languages = 'Cantonese and Cantonese-English Mixed' THEN 'Cantonese, English'
    ELSE languages
END;

-- Add voice language, volume, rate, and pitch fields to the ai_agent table
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent' AND COLUMN_NAME = 'tts_language');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent` ADD COLUMN `tts_language` VARCHAR(50) NULL COMMENT ''Voice Language'' AFTER `tts_voice_id`', 'SELECT ''Column tts_language already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent' AND COLUMN_NAME = 'tts_volume');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent` ADD COLUMN `tts_volume` INT NULL COMMENT ''TTS Volume'' AFTER `tts_language`', 'SELECT ''Column tts_volume already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent' AND COLUMN_NAME = 'tts_rate');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent` ADD COLUMN `tts_rate` INT NULL COMMENT ''TTS Rate'' AFTER `tts_volume`', 'SELECT ''Column tts_rate already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent' AND COLUMN_NAME = 'tts_pitch');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent` ADD COLUMN `tts_pitch` INT NULL COMMENT ''TTS Pitch'' AFTER `tts_rate`', 'SELECT ''Column tts_pitch already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add voice language, volume, rate, and pitch fields to the ai_agent_template table
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent_template' AND COLUMN_NAME = 'tts_language');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent_template` ADD COLUMN `tts_language` VARCHAR(50) NULL COMMENT ''Voice Language'' AFTER `tts_voice_id`', 'SELECT ''Column tts_language already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent_template' AND COLUMN_NAME = 'tts_volume');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent_template` ADD COLUMN `tts_volume` INT NULL COMMENT ''TTS Volume'' AFTER `tts_language`', 'SELECT ''Column tts_volume already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent_template' AND COLUMN_NAME = 'tts_rate');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent_template` ADD COLUMN `tts_rate` INT NULL COMMENT ''TTS Rate'' AFTER `tts_volume`', 'SELECT ''Column tts_rate already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent_template' AND COLUMN_NAME = 'tts_pitch');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent_template` ADD COLUMN `tts_pitch` INT NULL COMMENT ''TTS Pitch'' AFTER `tts_rate`', 'SELECT ''Column tts_pitch already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;