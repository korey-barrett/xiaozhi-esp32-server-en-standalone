-- Add server.ota to configure the OTA address

delete from `sys_params` where id = 100;
delete from `sys_params` where id = 101;

delete from `sys_params` where id = 106;
INSERT INTO `sys_params` (id, param_code, param_value, value_type, param_type, remark) VALUES (106, 'server.websocket', 'null', 'string', 1, 'WebSocket address, separate multiple with ;');

delete from `sys_params` where id = 107;
INSERT INTO `sys_params` (id, param_code, param_value, value_type, param_type, remark) VALUES (107, 'server.ota', 'null', 'string', 1, 'OTA address');


-- Add firmware info table
CREATE TABLE IF NOT EXISTS `ai_ota` (
  `id` varchar(32) NOT NULL COMMENT 'ID',
  `firmware_name` varchar(100) DEFAULT NULL COMMENT 'Firmware Name',
  `type` varchar(50) DEFAULT NULL COMMENT 'Firmware Type',
  `version` varchar(50) DEFAULT NULL COMMENT 'Version',
  `size` bigint DEFAULT NULL COMMENT 'File Size (Bytes)',
  `remark` varchar(500) DEFAULT NULL COMMENT 'Remark/Description',
  `firmware_path` varchar(255) DEFAULT NULL COMMENT 'Firmware Path',
  `sort` int unsigned DEFAULT '0' COMMENT 'Sort Order',
  `updater` bigint DEFAULT NULL COMMENT 'Updater',
  `update_date` datetime DEFAULT NULL COMMENT 'Update Time',
  `creator` bigint DEFAULT NULL COMMENT 'Creator',
  `create_date` datetime DEFAULT NULL COMMENT 'Create Time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Firmware Info Table';

update ai_device set auto_update = 1;
