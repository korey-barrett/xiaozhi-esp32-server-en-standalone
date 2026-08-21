-- Modify the chat content field type
ALTER TABLE ai_agent_chat_history MODIFY COLUMN content TEXT COMMENT 'Chat Content';
