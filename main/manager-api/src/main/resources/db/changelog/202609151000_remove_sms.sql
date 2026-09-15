-- Remove Aliyun SMS + mobile-phone registration from the build (not required)
-- Idempotent: no-ops on fresh installs where the seed inserts were skipped, and cleans existing DBs.
DELETE FROM sys_params WHERE id IN (111, 112, 610, 611, 612, 613);
DELETE FROM sys_dict_data WHERE dict_type_id = 102;
DELETE FROM sys_dict_type WHERE id = 102;
