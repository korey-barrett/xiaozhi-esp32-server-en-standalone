-- Add English wake/exit values and the 'willow' custom wake word.
-- This runs as a NEW changeset (the earlier 202504112058.sql is left unchanged to
-- keep its Liquibase checksum valid). Idempotent — sets the exact final values.
UPDATE `sys_params`
SET `param_value` = '你好小智;你好小志;小爱同学;你好小鑫;你好小新;小美同学;小龙小龙;喵喵同学;小滨小滨;小冰小冰;hey xiaozhi;hello xiaozhi;hi xiaozhi;willow;Willow'
WHERE `param_code` = 'wakeup_words';

UPDATE `sys_params`
SET `param_value` = '退出;关闭;exit;goodbye;bye'
WHERE `param_code` = 'exit_commands';
