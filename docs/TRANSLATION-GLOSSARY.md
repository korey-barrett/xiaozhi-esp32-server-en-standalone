# xiaozhi-esp32-server — English Translation Glossary & Progress

Purpose: produce an English-language, buildable version of this repo for GitHub.
This file tracks consistent translations for functional/domain terms and per-area
progress, so work can resume cleanly across multiple sessions.

## Glossary (functional / domain terms — must map consistently everywhere)

| Chinese | English | Notes / where used |
|---------|---------|--------------------|
| 智控台 | Console (Admin Console / Control Panel) | The management UI (manager-web / port 8002) |
| 智能体 | Agent | AI agent managed in console |
| 音色 | Timbre / Voice | Voice-clone & TTS terms |
| 声音克隆 | Voice Clone | |
| 普通话 | Mandarin | language code value |
| 粤语 | Cantonese | language code value |
| 英语 | English | language code value |
| 日语 | Japanese | language code value |
| 韩语 | Korean | language code value |
| 意图识别 | Intent Recognition | |
| 参数管理 | Parameter Management | console page |
| 固件 / OTA | Firmware / OTA | |
| 设备 | Device | |
| 角色 | Role | permissions |
| 用户 | User | |
| 模型 | Model | LLM/ASR/TTS model |
| 供应器 | Provider | model provider |
| 知识库 | Knowledge Base | RAG |
| 插件 | Plugin | |
| 训练成功/失败/中/待训练 | Training Succeeded / Failed / In Progress / Pending | trainStatus |
| 训练错误原因 | Training Error Reason | |
| 模型配置 | Model Configuration | |
| 语音克隆管理 | Voice Clone Management | |
| 分页查询 | Paginated Query / Paged Query | |
| 批量删除 | Batch Delete | |
| 新增 / 修改 / 删除 | Add / Edit / Delete | CRUD |
| 默认 | Default | |
| 启用 / 关闭 | Enable / Disable | |

## Progress log

### manager-api (Java backend) — COMPLETE (session 1)
- [x] Phase 0: entity / dto / vo (100 files) — all English
- [x] Phase 1: controller (24 files) — all English
- [x] Phase 2: service / service impl (78 files) — all English
- [x] Phase 3: config / security / common / utils / dao / enums / rag / tasks (113 files) — all English
- [x] Phase 4: SQL seed/changelog (103 files) — English except 4 documented functional-exception files; master yaml comments translated
- [x] Phase 5: tests (20) + resources (mapper xml, app yml, logback) + lua getKeyOrCreate.lua — all English
- [x] Placeholder sentinel 你/你的 -> YOUR_ updated in lockstep (Java + Python + config.yaml + config_from_api.yaml)
- [ ] PENDING: mvn compile verification (no JDK/Maven in this env) — run before publishing

### manager-web (Vue frontend)
- [ ] Not started (i18n zh_CN.js/zh_TW.js are largest ~9.2k chars each; en.js already exists)

### xiaozhi-server (Python) — COMPLETE (session 2)
- [x] core/providers (ASR/LLM/TTS/Memory/intent/tools/vad/vllm) — 83 files
- [x] core/utils, core/handle, core/api, core/connection/http_server/websocket_server/auth — all English
- [x] plugins_func, performance_tester — all English
- [x] config files: config.yaml (1172 lines), config_from_api.yaml, agent-base-prompt.txt, docker-compose(.all).yml, mcp_server_settings.json, requirements.txt — all English
- [x] Placeholder sentinel 你/你的 -> YOUR_ done earlier
- [x] Verified: 170 .py files compile; config.yaml valid YAML (33 top-level keys)
- [x] Functional exceptions documented: wake words, exit commands, news sources, device rooms, default city, reference_text, minimax pinyin dict, YOUR_ placeholders with trailing Chinese

### manager-mobile — COMPLETE (session 2) except legal docs
- [x] 86 src files (pages/api/utils/store/hooks/http/layouts/router) — all English
- [x] i18n zh_CN.ts / zh_TW.ts — translated to English (matching en.ts, 554 keys)
- [x] config: manifest.config.ts, package.json, pages.config.ts, vite.config.ts, uno.config.ts, scripts, src/manifest.json, src/pages.json, READMEs — all English
- [x] Chinese image filenames renamed to English (generate-appid.png, local-run.png, re-identify-project.png, packaging-step1/2.png) and README refs updated
- [x] Mobile error-code checks updated: `请求错误[10067]` -> `Request error[10067]` (matches new backend/alova format)
- [ ] PENDING: legal docs user-agreement-zh.vue / privacy-policy-zh.vue (agent processing)

### docs/ — COMPLETE (session 2), functional exceptions remain
- [x] 42 .md docs translated to English (Deployment, Deployment_all, all integration guides, readme/*)
- [x] Markdown anchors updated to English (e.g. #model-files, #configure-the-project-files)
- [x] Image alt texts, badge labels, blogger names translated
- [x] Placeholder values in docs normalized to YOUR_ (你的... -> YOUR_...)
- [x] Functional exceptions documented & kept: news source names (澎湃新闻 etc.) in newsnow_plugin_config.md, HA device-list example (公司,玩具灯,...) in homeassistant-integration.md, fish-speech reference_text wake-word sample, paddlespeech Chinese TTS sample commands, default city 广州
- [x] TRANSLATION-GLOSSARY.md itself intentionally bilingual (tracks progress)

## Functional placeholder (你 / 你的) — SENTINEL handling
The Chinese char `你` / `你的` is used across config.yaml, config_from_api.yaml, Java (RAGFlowAdapter.java),
and Python (manage_api_client.py, util.py, http_server.py, app.py) as a **sentinel** meaning
"this value is not yet configured" (code checks `"你" in value` / `contains("你")`).
Decision: replace all placeholder values with English `YOUR_...` markers (e.g. `YOUR_API_KEY`, `YOUR_IP_OR_DOMAIN`)
and update every code check from `"你"` / `"你的"` to `"YOUR_"`. This must be done in lockstep across
config.yaml, config_from_api.yaml, and the Java + Python files listed above, or config detection will break.
The wake-word strings (你好小智, 嘿你好呀, etc.) are user-facing and translated as normal strings.

## Intentional exceptions — functional voice/data values kept in Chinese
The following values are matched against ACTUAL SPOKEN CHINESE by the ESP32 voice model,
or are pinyin/news-source data used at runtime. Translating them would break functionality,
so they are intentionally retained in Chinese in the English repo:
- `sys_params` `wakeup_words` (你好小智;你好小志;小爱同学;...) — device wake words
- `sys_params` `exit_commands` (退出;关闭) — spoken exit commands
- `ai_model_config` TTS pronunciation dict `"tone": ["处理/(chu3)(li3)", ...]` — pinyin TTS data
- `202505142037.sql` `replace(system_prompt, '我是', '你是')` — historical migration on Chinese prompt text
- Python `minimax_httpstream.py` `default_pronunciation_dict` tone entries — pinyin TTS data
- Python `plugin_executor.py` `news_sources = "澎湃新闻;百度热搜;财联社"` — real Chinese news-outlet names queried by the news plugin (functionally passed to news APIs)
- Python `get_news_from_newsnow.py` — the Chinese news-source name -> slug map (知乎->zhihu, 澎湃新闻->thepaper, etc.) and DEFAULT_NEWS_SOURCES / default source param. These Chinese names are the user-facing source selectors that map to real Chinese news APIs; must stay consistent with config.yaml news_sources and plugin_executor.py.
- Python `get_weather.py` `default_location = "广州"` and config.yaml `default_location: "广州"` — default city name passed to the (Chinese) weather API; kept consistent.
- manager-web `AddressBookDialog.vue` name-validation regex `/^[一-龥a-zA-Z0-9\s-_]+$/` — `一-龥` is a functional CJK Unicode character range used to allow Chinese characters in names; kept as-is.
- digital-human functional values kept in Chinese (matched against spoken Chinese / device commands): `index.html` wake-word placeholder text, `js/config/manager.js` DEFAULT_WAKE_WORDS, `js/core/network/websocket.js` wake-word text and `includes('绑定')` bind-check, `wakeword_runtime/config/config_loader.py` wake-word list.
Files affected: 202504112058.sql, 202506080955.sql, 202505142037.sql, 202509051745.sql, minimax_httpstream.py, plugin_executor.py, get_news_from_newsnow.py, get_weather.py, config.yaml, manager-web/src/components/AddressBookDialog.vue, main/digital-human/*
These are seed/migration/data that ship and are used at runtime; the repo's display strings/comments are English.
The agent template display name 小智 was transliterated to "Xiaozhi" (safe, display-only).

## PENDING FUTURE REMOVAL — sys_params rows shown in Parameter Management (manager-web "More" menu)
These two `sys_params` rows are the ONLY Chinese remaining in the Parameter Management page. Their
`param_value` is matched against ACTUAL SPOKEN CHINESE by the device, so it is retained in Chinese
(functional). Their `remark` has been updated with an English translation in a new changelog
(`202608061500.sql`). They are logged here for eventual removal once a full-English strategy is decided
(e.g. firmware/device supports English wake words, or the device-side model changes).
- `wakeup_words` — param_value = `你好小智;你好小志;小爱同学;你好小鑫;你好小新;小美同学;小龙小龙;喵喵同学;小滨小滨;小冰小冰` (+ `;嘿你好呀`). English: "Hello Xiaozhi / Hey hello / Xiao Ai Tong Xue / Hello Xiaoxin / Xiao Mei Tong Xue / Xiao Long Xiao Long / Miao Miao Tong Xue / Xiao Bin Xiao Bin / Xiao Bing Xiao Bing / Hey hello"
- `exit_commands` — param_value = `退出;关闭`. English: "Exit" (退出), "Close" (关闭)
Files affected: 202504112058.sql (insert), 202506080955.sql (update), 202608061500.sql (remark translation note)

### digital-human + root/misc — COMPLETE (session 2)
- [x] digital-human code files (js/css/html/py): live2d.js comments, all module code translated
- [x] digital-human README.md, Live2D model ReadMe.txt files translated
- [x] Live2D model resource display names (cdi3.json/physics3.json `Name` fields) translated to English; `Id` values preserved
- [x] Root README.md, main/README.md (+ TOC anchors), .github templates/workflows translated
- [x] manager-api/pom.xml + README.md, manager-web babel.config.js/README.md/vue.config.js/public offline.html/privacy-policy.html/user-agreement.html/generator README.md — all translated

## Build artifacts NOT edited (minified / third-party bundles)
- `manager-web/public/generator/assets/*.js` (e.g. index-Guo1hQ-y.js) — minified build bundle of the external xiaozhi-assets-generator project
- `manager-web/public/generator/static/charsets/*.txt` — functional character-set data files
- `digital-human/resources/*/runtime/*.cdi3.json` & `*.physics3.json` — Live2D model data (Name fields translated, but are model assets)
These are packaged/compiled outputs; do not hand-edit minified bundles.

## Rules
- Do NOT translate: package names, class names, method names, identifiers, enum constants, URLs, DB column names, config keys (e.g. `server.websocket`, `server.ota`).
- Translate: comments, docstrings, Javadoc, log messages, error/user-facing strings, @Schema/@Operation/@DisplayName descriptions.
- Functional data values (language codes, trainStatus labels, param remarks): translate but keep consistent via the glossary AND verify all reference sites are updated together so behavior is unchanged.
- Keep code buildable: after each phase, run the relevant build (e.g. `mvn compile` / `mvn -q compile`) to confirm no breakage.
