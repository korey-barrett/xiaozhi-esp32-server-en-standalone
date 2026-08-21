-- Add a small model ID field to the agent table
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_agent' AND COLUMN_NAME = 'slm_model_id');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE `ai_agent` ADD COLUMN `slm_model_id` VARCHAR(255) NULL COMMENT ''Small Model ID'' AFTER `llm_model_id`', 'SELECT ''Column slm_model_id already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Create the chat title table
DROP TABLE IF EXISTS `ai_agent_chat_title`;
CREATE TABLE `ai_agent_chat_title` (
    `id` VARCHAR(32) NOT NULL COMMENT 'Primary Key ID',
    `session_id` VARCHAR(255) NOT NULL COMMENT 'Session ID',
    `title` VARCHAR(255) DEFAULT NULL COMMENT 'Chat Title',
    `created_at` DATETIME DEFAULT NULL COMMENT 'Created At',
    `updated_at` DATETIME DEFAULT NULL COMMENT 'Updated At',
    PRIMARY KEY (`id`),
    KEY `idx_session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Agent Chat Title Table';
