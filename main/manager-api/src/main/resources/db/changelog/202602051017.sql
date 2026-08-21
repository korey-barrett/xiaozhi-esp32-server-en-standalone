-- Add powermem memory model provider
INSERT INTO `ai_model_provider` (`id`, `model_type`, `provider_code`, `name`, `fields`, `sort`, `creator`, `create_date`, `updater`, `update_date`)
VALUES ('SYSTEM_Memory_powermem', 'Memory', 'powermem', 'PowerMem Memory', '[
  {"key":"enable_user_profile","label":"Enable User Profile","type":"boolean"},
  {"key":"llm_provider","label":"LLM Provider","type":"string"},
  {"key":"llm_api_key","label":"LLM API Key","type":"string"},
  {"key":"llm_model","label":"LLM Model","type":"string"},
  {"key":"openai_base_url","label":"OpenAI Base URL","type":"string"},
  {"key":"embedding_provider","label":"Embedding Provider","type":"string"},
  {"key":"embedding_api_key","label":"Embedding API Key","type":"string"},
  {"key":"embedding_model","label":"Embedding Model","type":"string"},
  {"key":"embedding_openai_base_url","label":"Embedding OpenAI Base URL","type":"string"},
  {"key":"embedding_dims","label":"Embedding Dimensions","type":"integer"},
  {"key":"vector_store","label":"Vector Store Configuration (JSON)","type":"dict"}
]', 4, 1, NOW(), 1, NOW());

-- Add PowerMem memory model configuration
INSERT INTO `ai_model_config` VALUES (
  'Memory_powermem',
  'Memory',
  'powermem',
  'PowerMem Memory',
  0,
  1,
  '{\"type\": \"powermem\", \"enable_user_profile\": true, \"llm_provider\": \"openai\", \"llm_api_key\": \"YOUR_LLM_API_KEY\", \"llm_model\": \"qwen-plus\", \"openai_base_url\": \"\", \"embedding_provider\": \"openai\", \"embedding_api_key\": \"YOUR_EMBEDDING_API_KEY\", \"embedding_model\": \"text-embedding-v4\", \"embedding_openai_base_url\": \"https://api.openai.com/v1\", \"embedding_dims\": \"\", \"vector_store\": {\"provider\": \"sqlite\", \"config\": {}}}',
  NULL,
  NULL,
  4,
  NULL,
  NULL,
  NULL,
  NULL
);


-- PowerMem memory configuration notes
UPDATE `ai_model_config` SET
`doc_link` = 'https://github.com/oceanbase/powermem',
`remark` = 'PowerMem is the agent memory component open-sourced by OceanBase, which summarizes memories via a local LLM
GitHub: https://github.com/oceanbase/powermem
Website: https://www.powermem.ai/
Usage examples: https://github.com/oceanbase/powermem/tree/main/examples

[Cost Notes]
PowerMem itself is free; the actual cost depends on the chosen LLM and database:
- Using sqlite + a free LLM (e.g. glm-4-flash) = completely free
- Using a cloud LLM or cloud database = billed according to the corresponding service

[enable_user_profile] User profile feature
- false: use normal memory mode (AsyncMemory)
- true: use user profile mode (UserMemory), which automatically extracts user information
- User profile feature supports: oceanbase, seekdb, sqlite (powermem 0.3.0+)

[llm] LLM configuration - used for memory summarization and user profile extraction
  provider: LLM provider, valid values:
    - qwen: Qwen (Tongyi Qianwen) (https://bailian.console.aliyun.com/?apiKey=1#/api-key)
    - openai: OpenAI-compatible interface
    - zhipu: Zhipu AI (https://bigmodel.cn/usercenter/proj-mgmt/apikeys) - recommended to use the free glm-4-flash
  config: LLM configuration parameters
    - api_key: API key (required)
    - model: model name, e.g. qwen-plus, glm-4-flash, etc.
    - openai_base_url: custom service URL (optional), e.g. https://api.openai.com/v1
  Examples:
    {"provider": "zhipu", "config": {"api_key": "your_key", "model": "glm-4-flash"}}
    {"provider": "qwen", "config": {"api_key": "your_key", "model": "qwen-plus"}}

[embedder] Embedding configuration - used to vectorize memory content
  provider: embedding model provider, valid values:
    - qwen: Qwen (Tongyi Qianwen)
    - openai: OpenAI-compatible interface
  config: Embedding configuration parameters
    - api_key: API key (required)
    - model: model name, e.g. text-embedding-v4, text-embedding-3-small, etc.
    - openai_base_url: custom service URL (optional)
    - embedding_dims: vector dimensions (optional), must be configured when not 1536
  Example:
    {"provider": "openai", "config": {"api_key": "your_key", "model": "text-embedding-v4", "openai_base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1"}}

[vector_store] Database storage configuration - used to store vectorized memories
  provider: database type, valid values:
    - sqlite: lightweight local database (recommended for getting started, no extra configuration needed)
    - oceanbase: OceanBase database (recommended for production, best performance)
    - seekdb: SeekDB (recommended, all-in-one AI application storage)
    - postgres: PostgreSQL database

  SQLite configuration (no extra configuration needed):
    {"provider": "sqlite", "config": {}}

  OceanBase configuration example:
    {"provider": "oceanbase", "config": {
      "host": "127.0.0.1",
      "port": 2881,
      "user": "root@test",
      "password": "your_password",
      "db_name": "powermem",
      "collection_name": "memories",
      "embedding_model_dims": 1024
    }}
  Notes:
    - collection_name: default table name; if a dimension error occurs, delete this table or change its name
    - embedding_model_dims: embedding vector dimensions, must match the model dimensions of the embedder
      e.g. Zhipu: embedding-2 has 1024 dimensions, embedding-3 has 2048 dimensions

[Recommended configuration combinations]
1. Completely free plan:
   - LLM: zhipu + glm-4-flash (free)
   - Embedder: Qwen text-embedding-v4
   - Database: sqlite

2. Production plan:
   - LLM: qwen-plus or other commercial models
   - Embedder: text-embedding-v4
   - Database: oceanbase or seekdb
'
WHERE `id` = 'Memory_powermem';
