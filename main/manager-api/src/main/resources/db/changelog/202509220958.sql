delete from `ai_model_config` where id = 'LLM_XunfeiSparkLLM';
INSERT INTO `ai_model_config` VALUES ('LLM_XunfeiSparkLLM', 'LLM', 'Xunfei Spark Cognitive Large Model', 'Xunfei Spark Cognitive Large Model', 0, 1, '{"type": "openai", "model_name": "generalv3.5", "base_url": "https://spark-api-open.xf-yun.com/v1", "api_password": "YOUR_API_PASSWORD", "temperature": 0.5, "max_tokens": 2048, "top_p": 1.0, "frequency_penalty": 0.0}', 'https://www.xfyun.cn/doc/spark/HTTP%E8%B0%83%E7%94%A8%E6%96%87%E6%A1%A3.html', 'Xunfei Spark cognitive large model, supports multi-turn dialogue, text generation and more', 14, NULL, NULL, NULL, NULL);

-- Update Xunfei Spark cognitive large model configuration documentation
UPDATE `ai_model_config` SET
`doc_link` = 'https://www.xfyun.cn/doc/spark/HTTP%E8%B0%83%E7%94%A8%E6%96%87%E6%A1%A3.html',
`remark` = 'Xunfei Spark cognitive large model configuration notes:
1. Log in to the Xunfei open platform https://www.xfyun.cn/. Each model corresponds to its own api_password; when changing models, check the api_password of the corresponding model
2. Create a Spark cognitive large model application to obtain the API Password
3. Parameter notes:
   - api_password: API Password, obtained after creating an application on the Xunfei open platform
   - model_name: Model name, supports generalv3.5, generalv3 and other versions
   - base_url: API address, defaults to https://spark-api-open.xf-yun.com/v1
   - temperature: Temperature parameter, controls generation randomness, range 0-1, default 0.5
   - max_tokens: Maximum number of output tokens, default 2048
   - top_p: Core sampling parameter, controls vocabulary diversity, default 1.0
   - frequency_penalty: Frequency penalty, reduces repeated content, default 0.0
4. Each model corresponds to its own api_password; when changing models, check the api_password of the corresponding model.
' WHERE `id` = 'LLM_XunfeiSparkLLM';