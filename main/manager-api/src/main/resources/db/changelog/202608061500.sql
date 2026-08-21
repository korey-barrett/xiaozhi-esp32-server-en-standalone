-- English translation notes for sys_params rows whose param_value intentionally
-- retains Chinese. These values are matched against ACTUAL SPOKEN CHINESE by the
-- ESP32 device (wake words and exit commands), so they are kept in Chinese for
-- functionality. This changeSet documents their English meaning in the remark
-- column and flags them for eventual review.
-- See docs/TRANSLATION-GLOSSARY.md -> "Pending future removal" for the tracker.

-- wakeup_words: Chinese wake words the device listens for (critical, retained in Chinese).
-- English: "Hello Xiaozhi", "Hey hello", "Xiao Ai Tong Xue", "Hello Xiaoxin",
--          "Hello Xiaoxin", "Xiao Mei Tong Xue", "Xiao Long Xiao Long",
--          "Miao Miao Tong Xue", "Xiao Bin Xiao Bin", "Xiao Bing Xiao Bing", "Hey hello"
update `sys_params`
set remark = 'Chinese wake words (retained in Chinese for device wake-up). English: Hello Xiaozhi / Hey hello / Xiao Ai Tong Xue / Xiao Mei Tong Xue / Xiao Long / Miao Miao / Xiao Bin / Xiao Bing'
where param_code = 'wakeup_words';

-- exit_commands: Chinese exit commands the device recognizes.
-- English: "Exit" (退出), "Close/Shut down" (关闭)
update `sys_params`
set remark = 'Chinese exit commands (retained in Chinese for device exit). English: Exit, Close'
where param_code = 'exit_commands';
