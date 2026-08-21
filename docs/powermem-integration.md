# PowerMem Memory Component Integration Guide

## Introduction

[PowerMem](https://www.powermem.ai/) is an Agent memory component open-sourced by OceanBase. It performs memory summarization and intelligent retrieval through a local LLM, providing efficient memory management for AI agents.

Cost notes: PowerMem itself is open-source and free. The actual cost depends on the LLM and database you choose:
- Using SQLite + a free LLM (such as Zhipu glm-4-flash) = **completely free**
- Using a cloud LLM or cloud database = charged according to the corresponding service

> 💡 **Best Performance Tip**: PowerMem achieves maximum performance when used with OceanBase. SQLite is only recommended when resources are insufficient.

- **GitHub**: https://github.com/oceanbase/powermem
- **Official Website**: https://www.powermem.ai/
- **Usage Examples**: https://github.com/oceanbase/powermem/tree/main/examples

## Features

- **Local Summarization**: performs memory summarization and extraction locally via LLM
- **User Profile**: automatically extracts user information (name, occupation, interests, etc.) through `UserMemory` and continuously updates the user profile
- **Intelligent Forgetting**: based on the Ebbinghaus forgetting curve, automatically "forgets" outdated noise information
- **Multiple Storage Backends**: supports OceanBase (recommended, best performance), SeekDB (recommended, all-in-one AI application storage), PostgreSQL, SQLite (lightweight alternative)
- **Multiple LLM Support**: Qwen, Zhipu (glm-4-flash is free), OpenAI, etc.
- **Intelligent Retrieval**: semantic retrieval based on vector search
- **Private Deployment**: fully supports local private deployment
- **Asynchronous Operations**: efficient asynchronous memory management

## Installation

PowerMem is already added to the project dependencies. If you need to install it manually:

```bash
pip install powermem
```

## Configuration

### Basic Configuration

Configure PowerMem in `config.yaml`:

```yaml
selected_module:
  Memory: powermem

Memory:
  powermem:
    type: powermem
    # Whether to enable the user profile feature
    # User profile supports: oceanbase, seekdb, sqlite (powermem 0.3.0+)
    enable_user_profile: true
    
    # ========== LLM Configuration ==========
    llm:
      provider: openai  # Options: qwen, openai, zhipu, etc.
      config:
        api_key: your LLM API key
        model: qwen-plus
        # openai_base_url: https://api.openai.com/v1  # Optional, custom service URL
    
    # ========== Embedding Configuration ==========
    embedder:
      provider: openai  # Options: qwen, openai, etc.
      config:
        api_key: your embedding model API key
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
        # embedding_dims: 1024  # Vector dimensions, configure only when not 1536
    
    # ========== Database Configuration ==========
    vector_store:
      provider: sqlite  # Options: oceanbase(recommended), seekdb(recommended), postgres, sqlite(lightweight)
      config: {}  # SQLite requires no additional configuration
```

### Configuration Parameter Details

#### LLM Configuration

| Parameter | Description | Allowed Values |
|------|------|--------|
| `llm.provider` | LLM provider | `qwen`, `openai`, `zhipu`, etc. |
| `llm.config.api_key` | API key | - |
| `llm.config.model` | Model name | Depends on the provider |
| `llm.config.openai_base_url` | Custom service URL (optional) | - |

#### Embedding Configuration

| Parameter | Description | Allowed Values |
|------|------|--------|
| `embedder.provider` | Embedding model provider | `qwen`, `openai`, etc. |
| `embedder.config.api_key` | API key | - |
| `embedder.config.model` | Model name | Depends on the provider |
| `embedder.config.openai_base_url` | Custom service URL (optional) | - |

#### Database Configuration

| Parameter | Description | Allowed Values |
|------|------|--------|
| `vector_store.provider` | Storage backend type | `oceanbase`(recommended), `seekdb`(recommended), `postgres`, `sqlite`(lightweight) |
| `vector_store.config` | Database connection configuration | Depends on the provider |

### Memory Modes

PowerMem supports two memory modes:

| Mode | Configuration | Function | Storage Requirement |
|------|------|------|----------|
| **Normal Memory** | `enable_user_profile: false` | Conversation memory storage and retrieval | Supports all databases |
| **User Profile** | `enable_user_profile: true` | Memory + automatic user profile extraction | oceanbase, seekdb, sqlite |

> 📌 **Version Note**: In PowerMem 0.3.0+, the user profile feature supports three storage backends: OceanBase, SeekDB, and SQLite.

### Using Qwen (Recommended)

1. Visit [Alibaba Cloud Bailian Platform](https://bailian.console.aliyun.com/) to register an account
2. Obtain an API key on the [API Key Management](https://bailian.console.aliyun.com/?apiKey=1#/api-key) page
3. Configure as follows:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: qwen
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: qwen-plus
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
    vector_store:
      provider: sqlite
      config: {}
```

### Using the Free Zhipu LLM (Completely Free Option)

Zhipu provides a free glm-4-flash model. Combined with SQLite, this enables completely free usage:

1. Visit [Zhipu AI Open Platform](https://bigmodel.cn/) to register an account
2. Obtain an API key on the [API Keys](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) page
3. Configure as follows:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: openai  # Use OpenAI-compatible mode
      config:
        api_key: xxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxx
        model: glm-4-flash
        openai_base_url: https://open.bigmodel.cn/api/paas/v4/
    embedder:
      provider: openai
      config:
        api_key: xxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxx
        model: embedding-3
        openai_base_url: https://open.bigmodel.cn/api/paas/v4/
    vector_store:
      provider: sqlite
      config: {}
```

### Using OpenAI

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: gpt-4o-mini
        openai_base_url: https://api.openai.com/v1
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-3-small
        openai_base_url: https://api.openai.com/v1
    vector_store:
      provider: sqlite
      config: {}
```

### Using OceanBase (Best Performance Option)

OceanBase is PowerMem's best partner and unlocks maximum performance:

1. Deploy an OceanBase database (supports open-source local deployment or cloud services)
   - Open-source deployment: https://github.com/oceanbase/oceanbase
   - Cloud service: https://www.oceanbase.com/
2. Configure as follows:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: qwen
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: qwen-plus
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
    vector_store:
      provider: oceanbase
      config:
        host: 127.0.0.1
        port: 2881
        user: root@test
        password: your_password
        db_name: powermem
        collection_name: memories  # Default value
        embedding_model_dims: 1536  # Embedding vector dimensions, required parameter
```

## Device Memory Isolation

PowerMem automatically uses the device ID (`device_id`) as the `user_id` for memory isolation. This means:

- Each device has its own independent memory space
- Memory between different devices is completely isolated
- Multiple conversations on the same device can share memory context

## User Profile (UserMemory)

PowerMem provides the `UserMemory` class, which automatically extracts user profile information from conversations.

> 📌 **Version Note**: In PowerMem 0.3.0+, the user profile feature supports three storage backends: OceanBase, SeekDB, and SQLite.

### Enabling User Profile

Set `enable_user_profile: true` in the configuration to enable it:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true  # Enable user profile
    llm:
      provider: qwen
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: qwen-plus
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
    vector_store:
      provider: sqlite  # User profile supports: oceanbase, seekdb, sqlite
      config: {}
```

### User Profile Capabilities

| Capability | Description |
|------|------|
| **Information Extraction** | automatically extracts name, age, occupation, interests, etc. from conversations |
| **Continuous Updates** | continuously refines the user profile as conversations progress |
| **Profile Retrieval** | combines the user profile with memory search to improve retrieval relevance |
| **Intelligent Forgetting** | based on the Ebbinghaus forgetting curve, fades outdated information |

### How It Works

Once the user profile is enabled, xiaozhi automatically returns the following when querying memory:
1. **User Profile**: basic user information, interests, hobbies, etc.
2. **Related Memories**: historical memories related to the current conversation

> ✅ **Version Note**: In PowerMem 0.3.0+, the user profile feature supports three storage backends: OceanBase, SeekDB, and SQLite.

## Comparison with Other Memory Components

| Feature | PowerMem | mem0ai | mem_local_short |
|------|----------|--------|-----------------|
| Working method | Local summarization | Cloud API | Local summarization |
| Storage location | Local/cloud DB | Cloud | Local YAML |
| Cost | Depends on LLM and DB | 1000 times/month free | Completely free |
| Intelligent retrieval | ✅ Vector search | ✅ Vector search | ❌ Full return |
| User profile | ✅ UserMemory | ❌ | ❌ |
| Intelligent forgetting | ✅ Forgetting curve | ❌ | ❌ |
| Private deployment | ✅ Supported | ❌ Cloud only | ✅ Supported |
| Database support | OceanBase(recommended)/SeekDB/PostgreSQL/SQLite | - | YAML file |

## FAQ

### 1. API Key Error

If you encounter an `API key is required` error, check:
- Whether `llm_api_key` and `embedding_api_key` are filled in correctly
- Whether the API key is valid

### 2. Model Does Not Exist

If you encounter a model-does-not-exist error, confirm:
- Whether the `llm_model` and `embedding_model` names are correct
- Whether the corresponding model service is activated

### 3. Connection Timeout

If you encounter a connection timeout, you can try:
- Checking the network connection
- If you use a proxy, configure `llm_base_url` and `embedding_base_url`

## Testing and Verification

You can test whether PowerMem works correctly in a virtual environment:

```bash
# Activate the virtual environment
source .venv/bin/activate

# Test the PowerMem import
python -c "from powermem import AsyncMemory; print('PowerMem imported successfully')"

# Test the UserMemory import (user profile feature)
python -c "from powermem import UserMemory; print('UserMemory imported successfully')"
```

## More Resources

- [PowerMem Official Documentation](https://www.powermem.ai/)
- [PowerMem GitHub Repository](https://github.com/oceanbase/powermem)
- [PowerMem Usage Examples](https://github.com/oceanbase/powermem/tree/main/examples)
- [OceanBase Official Website](https://www.oceanbase.com/)
- [OceanBase GitHub](https://github.com/oceanbase/oceanbase)
- [SeekDB GitHub](https://github.com/oceanbase/seekdb) (AI-native search database)
- [Alibaba Cloud Bailian Platform](https://bailian.console.aliyun.com/)

