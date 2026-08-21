-- liquibase formatted sql

-- changeset xiaozhi:202512041515
CREATE TABLE ai_agent_context_provider (
    id VARCHAR(32) NOT NULL COMMENT 'Primary key',
    agent_id VARCHAR(32) NOT NULL COMMENT 'Agent ID',
    context_providers JSON COMMENT 'Context source configuration',
    creator BIGINT COMMENT 'Creator',
    created_at DATETIME COMMENT 'Created time',
    updater BIGINT COMMENT 'Updater',
    updated_at DATETIME COMMENT 'Updated time',
    PRIMARY KEY (id),
    INDEX idx_agent_id (agent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Agent context source configuration table';
