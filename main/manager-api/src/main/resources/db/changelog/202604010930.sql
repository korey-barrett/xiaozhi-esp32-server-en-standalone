-- Modify memory model names

UPDATE `ai_model_config` SET `model_name` = 'Local Short-term Memory (Summarizing)' WHERE `id` = 'Memory_mem_local_short';
UPDATE `ai_model_provider` SET `name` = 'Local Short-term Memory (Summarizing)' WHERE `id` = 'SYSTEM_Memory_mem_local_short';

UPDATE `ai_model_config` SET `model_name` = 'Report Chat History Only (No Memory Summary)' WHERE `id` = 'Memory_mem_report_only';
UPDATE `ai_model_provider` SET `name` = 'Report Chat History Only (No Memory Summary)' WHERE `id` = 'SYSTEM_Memory_mem_report_only';
