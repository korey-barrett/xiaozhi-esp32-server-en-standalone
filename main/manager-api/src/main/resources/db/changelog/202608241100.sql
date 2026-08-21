-- SSO (OAuth2/OIDC) identity link table.
-- Maps an external provider identity (provider + provider_user_id) to a local sys_user.
CREATE TABLE IF NOT EXISTS `sys_user_oauth` (
    `id`               BIGINT       NOT NULL COMMENT 'Primary key',
    `user_id`          BIGINT       NOT NULL COMMENT 'Local system user id',
    `provider`         VARCHAR(32)  NOT NULL COMMENT 'Provider name: google, apple, microsoft, github',
    `provider_user_id` VARCHAR(255) NOT NULL COMMENT 'Provider unique user id (subject / uuid)',
    `creator`          BIGINT       DEFAULT NULL COMMENT 'Creator',
    `create_date`      DATETIME     DEFAULT NULL COMMENT 'Creation time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_sys_user_oauth_provider_user` (`provider`, `provider_user_id`),
    KEY `idx_sys_user_oauth_user_id` (`user_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'SSO identity link';
