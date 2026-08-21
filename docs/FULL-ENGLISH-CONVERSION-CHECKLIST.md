# Full-English Conversion Checklist

> **Goal:** Convert this fork to **English-only usage** — no Chinese UI, no Chinese
> wake/exit data, and **no data sent to Chinese apps or sites**. For every configurable
> option, provide both a **free** and a **paid** choice, each offering **cloud** and
> **local** (self-hosted) options, defaulting to free/local where possible.
>
> This is a **living document**. Sections marked *(audit)* are filled from a code audit
> of the current repo; re-run the audit whenever upstream changes.

---

## 1. Guiding principles

- **English-only UI:** every label, message, and menu is English; the only retained Chinese
  is *functional spoken data* (wake words / exit commands matched against the user's voice).
- **No Chinese data egress:** replace every provider whose API/endpoint is a Chinese company
  (Alibaba, Tencent, Volcengine/Doubao, SiliconFlow, MiniMax, iFlytek, Baidu, Moonshot/Kimi,
  Zhipu, Qwen, DeepSeek, etc.) with a global/English or local option.
- **Free + paid, cloud + local:** for each capability, list at least one free and one paid
  option, each of which may be cloud or local.
- **Default to free + local** where the hardware allows, to keep new users' setup simple and
  privacy-friendly.

---

## 2. Page & menu conversion checklist *(audit complete)*

> Result: the admin console and mobile app are **already fully English in source** (all UI text via i18n).
> Only non-UI Chinese remains: a validation regex, test/comments, SVG metadata. The prebuilt generator
> bundle has been rebuilt with an English default locale.
> See §2.4 for retained functional Chinese.

### 2.1 Admin console — top-level menus (from `HeaderBar.vue` + `en.js`)
| Menu | Pages (routes) | Notes |
|---|---|---|
| **Agents** | `home.vue`, `roleConfig.vue`, `DeviceManagement.vue` | includes Voice Print sub-flow |
| **Voice Clone** | `VoiceCloneManagement.vue` (+ Voice Resource for super-admin) | |
| **Models** | `ModelConfig.vue` | super-admin; 8 tabs: VAD/ASR/LLM/VLLM/Intent/TTS/Memory/RAG |
| **Knowledge** | `KnowledgeBaseManagement.vue`, `KnowledgeBaseItem.vue` | feature-gated |
| **Address Book** | `AddressBookManagement.vue` | feature-gated |
| **More** ▾ (super-admin) | Params · Users · OTA · Dict · Provider · Default Role Templates · Replacement Words · Server · System Feature | |
| Right side | Language selector · Change Password · Logout | |

### 2.2 Admin console — pages
| Page (view file) | Menu | What it configures | Conversion action |
|---|---|---|---|
| `home.vue` | Agents | agent dashboard | ✅ English |
| `roleConfig.vue` | Agents | per-agent role/model/persona config | ✅ English |
| `DeviceManagement.vue` | Agents | agents/devices | ✅ English |
| `VoicePrint.vue` | Agents | voiceprint samples | ✅ English |
| `TemplateQuickConfig.vue` | — | quick multi-module wizard | ✅ English |
| `VoiceCloneManagement.vue` | Voice Clone | voice clones | ✅ English |
| `VoiceResourceManagement.vue` | Voice Clone | voice resource activation | ✅ English |
| `ModelConfig.vue` | Models | provider/model registry (8 tabs) | ✅ English; defaults → §6 |
| `KnowledgeBase*.vue` | Knowledge | RAG docs | ✅ English |
| `AddressBookManagement.vue` | Address Book | contacts | regex fix (§2.4) |
| `ParamsManagement.vue` | More | sys_params | English values; keep wake/exit |
| `UserManagement.vue` / `DictManagement.vue` / `OtaManagement.vue` / `ProviderManagement.vue` / `AgentTemplateManagement.vue` / `ServerSideManager.vue` / `FeatureManagement.vue` / `ReplacementWordManagement.vue` | More | misc | ✅ English |
| `login/register/retrievePassword.vue` | Auth | sign in / up / reset | ✅ English |

### 2.3 Mobile app (manager-mobile)
Tabs: **Home**, **Network** (`device-config`), **System**. Pages under `src/pages/`: index, login, register, forgot-password, legal (privacy/user-agreement, en+zh variants both English), device list, device-config (wifi), agent (list/edit/provider/speedPitch/tools + AgentSnapshotPanel), chat-history, settings, voiceprint. **All visible UI is English.**

### 2.4 Remaining Chinese to clean (non-UI) — from audit
| Location | Chinese | Type | Action |
|---|---|---|---|
| `manager-web/src/components/AddressBookDialog.vue` L67 | `/^[一-龥a-zA-Z0-9\s-_]+$/` | contact-name validation regex allows CJK | remove CJK class from regex if you want to forbid Chinese names |
| `manager-web/src/apis/.../agentSnapshotApi.test.mjs` L24,38 | `// 删除智能体配置快照` etc. | test-fixture comments | translate comments |
| `manager-web/public/generator/…` | was zh-CN-default bundle; **rebuilt from xiaozhi-assets-generator source with `en` default** | device-config generator SPA | ✅ **done** (commit `bce5e5a8`) |
| `manager-mobile/src/static/logo.svg` | `data-name="图层 2"` | SVG layer metadata | rename layers |
| `manager-mobile/eslint.config.mjs` | Chinese comments | config comments | translate comments |

### 2.5 Retained Chinese (functional, do NOT translate)
| Location | Value | Why retained |
|---|---|---|
| `sys_params` `wakeup_words` | 你好小智; … | matched to spoken Chinese for wake-up |
| `sys_params` `exit_commands` | 退出; 关闭 | matched to spoken Chinese for exit |
| news sources / default city | 澎湃新闻 … / Guangzhou | functional data (replace in §5) |

---

## 3. Data-flow audit — external services contacted *(audit complete)*

Every configurable service and the external endpoint it contacts. Marked `[CH]` = Chinese company/service to replace.

### 3.1 Chinese services to remove or replace
| Service | Purpose / model type | Endpoint(s) | Config location | Replace with |
|---|---|---|---|---|
| Alibaba Cloud / Qwen (`[CH]`) | LLM, ASR (Paraformer), TTS (CosyVoice), VLLM | `dashscope.aliyuncs.com`, `nls-gateway*.aliyuncs.com` | `ai_model_config` seeds | Ollama / OpenAI / Whisper |
| Alibaba SMS (`[CH]`) | SMS verification (optional login) | `dysmsapi.aliyuncs.com` | `sys_params aliyun.sms.*` | none / Twilio / GSM / email |
| Volcengine / Doubao (`[CH]`) | LLM, ASR, TTS (`seed-tts-2.0`) | `ark.cn-beijing.volces.com`, `openspeech.bytedance.com` | provider config | OpenAI / Edge TTS |
| Zhipu / GLM (`[CH]`) | LLM, VLLM | `open.bigmodel.cn` | provider config | Ollama / OpenAI |
| DeepSeek (`[CH]`) | LLM | `api.deepseek.com` | provider config | OpenAI / Ollama |
| SiliconFlow (`[CH]`) | TTS (CosyVoice) | `api.siliconflow.cn` | provider config | Edge TTS / Piper |
| MiniMax (`[CH]`) | TTS + voice clone | `api.minimaxi.com`, `cdn.hailuoai.video` | provider config | ElevenLabs / Coqui XTTS |
| Tencent Cloud (`[CH]`) | ASR, TTS | `asr.tencentcloudapi.com`, `tts.tencentcloudapi.com` | provider config | Whisper / Edge TTS |
| iFlytek / Xunfei (`[CH]`) | ASR, LLM | `iat.cn-huabei-1.xf-yun.com`, `spark-api-open.xf-yun.com` | provider config | Whisper / OpenAI |
| Baidu (`[CH]`) | ASR | Baidu aip (dev_pid=1537) | provider config | Whisper / faster-whisper |
| Coze / CozeCN (`[CH]`) | TTS, LLM | `api.coze.cn` | provider config | OpenAI / Ollama |
| QWeather (`[CH]`) | weather plugin | `mj7p3y7naa.re.qweatherapi.com` (embedded key) | `sys_params` weather | Open-Meteo / OpenWeatherMap |
| Chinanews (`[CH]`) | news RSS (default) | `www.chinanews.com.cn/rss` | `sys_params` / plugin | English RSS / GNews |
| NewsNow (`[CH]`) | news aggregator | `newsnow.busiyi.world` | plugin | English RSS |
| Metaso (`[CH]`) | web search (default) | `metaso.cn/api/v1/search` | plugin | **Tavily** / Brave / SearXNG |
| pconline (`[CH]`) | IP→city geolocation on every connect | `whois.pconline.com.cn` | core | local GeoIP (e.g. ipinfo free / MaxMind) |
| Linker/302AI/Gizwits (`[CH]`) | Doubao TTS proxies | `tts.linkerai.cn`, `api.302ai.cn`, `gizwitsapi.com` | provider config | Edge TTS / Piper |

### 3.2 Non-Chinese / local providers already available
- **Cloud/global:** OpenAI (LLM/TTS/ASR), Google Gemini, Dify, Groq, Mem0AI, **Microsoft Edge TTS**, Tavily (web search), Home Assistant (local smart-home).
- **Local-only:** Silero VAD, FunASR, Sherpa, Vosk, Ollama, Xinference, LM Studio, GPT-SoVITS, FishSpeech, PaddleSpeech, custom TTS, local memory (`mem_local`, `nomem`).

> **Note:** every Chinese service above has at least one English/local replacement already present in
> the provider registry (§4). Removing Chinese defaults is mostly a **seed/default change**, not new code.

---

## 4. Provider replacement matrix

For each capability, recommended English/global + local options. **Free/paid × cloud/local.**

### 4.1 LLM (large language model)
| | Cloud | Local (self-hosted) |
|---|---|---|
| **Free** | Google Gemini free tier; Mistral free; Groq free tier; OpenRouter free models | **Ollama** (Llama 3, Mistral, Gemma); llama.cpp; vLLM |
| **Paid** | OpenAI GPT-4o; Anthropic Claude; Google Gemini; Mistral | Same local engines (no per-token cost) |

### 4.2 Speech recognition (ASR)
| | Cloud | Local |
|---|---|---|
| **Free** | Google Speech free tier; (open) | **Whisper / faster-whisper / whisper.cpp**; Vosk |
| **Paid** | OpenAI Whisper API; Deepgram; AssemblyAI; Azure | — |

### 4.3 Text-to-speech (TTS)
| | Cloud | Local |
|---|---|---|
| **Free** | Microsoft **Edge TTS**; Google TTS free tier | **Piper**; Coqui TTS |
| **Paid** | OpenAI TTS; ElevenLabs; Azure; Google | — |

### 4.4 Voice activity detection (VAD)
| | Cloud | Local |
|---|---|---|
| **Free** | — | **Silero VAD**; WebRTC VAD (default local) |
| **Paid** | Azure/Deepgram VAD | — |

### 4.5 Vision / visual LLM (VLLM)
| | Cloud | Local |
|---|---|---|
| **Free** | Google Gemini free tier | **Ollama** (Qwen2.5-VL, LLaVA, Gemma 3) |
| **Paid** | OpenAI GPT-4o; Anthropic; Google | — |

### 4.6 Memory / embeddings
| | Cloud | Local |
|---|---|---|
| **Free** | — | **Ollama nomic-embed**; sentence-transformers; Qdrant/Chroma/Milvus |
| **Paid** | OpenAI/Cohere embeddings | — |

### 4.7 Voice cloning
| | Cloud | Local |
|---|---|---|
| **Free** | — | **Coqui XTTS**; OpenVoice (open source) |
| **Paid** | ElevenLabs; PlayHT | — |

### 4.8 Weather & news (optional plugins)
| | Cloud | Local |
|---|---|---|
| Weather free | **Open-Meteo** (open, free); OpenWeatherMap free tier | — |
| News free | **RSS / GNews** (English sources) | — |

### 4.9 SMS (optional phone login)
SMS is optional (see `ali-sms-integration.md`). Default = username/password. If needed:
| | Cloud | Local |
|---|---|---|
| Free | Twilio trial credit | GSM/4G modem + SIM; or email-based codes |
| Paid | Twilio / MessageBird / Vonage | — |

### 4.10 MQTT
| | Cloud | Local |
|---|---|---|
| Free | (any public broker) | **Mosquitto** (self-hosted) |
| Paid | HiveMQ Cloud etc. | — |

---

## 5. Default Chinese data to replace

| Item | Current (Chinese) | Replace with | Cloud | Local |
|---|---|---|---|---|
| News sources | 澎湃新闻, 百度热搜, 财联社… | English RSS (BBC, Reuters, RSSHub) | GNews/NewsAPI | local RSS reader |
| Weather default city | 广州 | configurable, user-set | Open-Meteo | — |
| Wake words | 你好小智… | (retain; add English wake word if desired) | — | local Wakenet |
| SMS | Alibaba Cloud | optional / none | Twilio | GSM modem / email |

---

## 6. Recommended target stack (all-English; default = free cloud, local optional)

> **Default providers** (set in the seed/migration): **LLM → Google Gemini** (free tier),
> **VLLM/Vision → Google Gemini**, **ASR → local FunASR**, **TTS → Edge TTS (English voice)**,
> **VAD → Silero**, **Memory → nomem**. All non-Chinese.

| Capability | Recommended default | Free? | Local? |
|---|---|---|---|
| LLM | **Google Gemini (free tier)** | ✅ | optional via Ollama |
| Vision (VLLM) | **Google Gemini (free tier)** | ✅ | optional via Ollama |
| ASR | **FunASR / faster-whisper** (local) | ✅ | ✅ |
| TTS | **Edge TTS (English)** | ✅ | cloud/local |
| VAD | **Silero** (local) | ✅ | ✅ |
| Memory | none / local (`nomem`) | ✅ | ✅ |
| Voice clone | Coqui XTTS (local) | ✅ | ✅ |
| Weather | **Open-Meteo** | ✅ | ✅ |
| SMS | none (username/password login) | ✅ | ✅ |
| MQTT | Mosquitto (local) | ✅ | ✅ |

> **Third-party setup instructions:** step-by-step guides for obtaining each required
> third-party key (e.g. creating a **Google Gemini free-tier API key**, plus the free/paid
> cloud and local options above) will be added as a **separate side project** that documents
> third-party requirements. Until then, the console/model pages and this checklist are the
> reference for the required fields.

---

## 7. Implementation phases
1. **UI/English pass** — complete any remaining Chinese UI text (page audit §2).
2. **Provider plumbing** — ensure every provider type supports the free/local options above;
   add any missing provider implementations (e.g. non-Aliyun SMS, English news/weather).
3. **Default flip** — change seed defaults from Chinese providers to the English/local defaults.
4. **Data-egress removal** — remove/disable remaining Chinese endpoints; document any optional ones.
5. **Validation** — run the app fully offline with only local providers; verify no Chinese egress.

---
*(Audit sections §2 and §3 completed from a code audit of the repo.)*

---

## 8. Language conventions & future roadmap

### 8.1 Canonical language — **EN-US**
- **EN-US** is the project's **canonical/default language** and the naming convention used in the actual
  code, identifiers, and defaults (e.g. `color`, `center` — not UK `colour`, `centre`).
- This is **by design**. A remark appears to users that **EN-US is the default language** of the project.
- **EN-UK** is a *display* variant only — it is **not** used as the code/naming convention.

### 8.2 Future feature — automatic en-UK → en-US correction (not yet implemented)
Planned UX feature: when a user enters a UK spelling variant (e.g. `Colour`), the **server app
automatically adjusts it to `Color`** and shows a **text popup** to the user explaining that the change
occurred and **why** (because EN-US is the project's canonical language). This is a **future feature**,
not present in the current build.

### 8.3 Future major change — production multilingual localisation (does NOT touch server code)
At production stage, the project will be **localized for display** into:
- English (UK), Simplified Chinese (`zh-CN`), Traditional Chinese (`zh-TW`),
- Japanese, Korean, Spanish, German, French *(optional)*.

This is delivered purely through the **i18n/dictionary layer** and **will not modify the underlying server
code**, so nothing breaks. **This is a major change scheduled for a future version.**
