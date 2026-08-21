-- Add chat history config fields
ALTER TABLE `ai_agent` 
ADD COLUMN `chat_history_conf` tinyint NOT NULL DEFAULT 0 COMMENT 'Chat history config (0 not recorded, 1 text only, 2 text and voice)' AFTER `system_prompt`;

ALTER TABLE `ai_agent_template` 
ADD COLUMN `chat_history_conf` tinyint NOT NULL DEFAULT 0 COMMENT 'Chat history config (0 not recorded, 1 text only, 2 text and voice)' AFTER `system_prompt`;