# Project Handoff — xiaozhi-esp32-server-en-standalone (English-first standalone fork)

> **Purpose:** Import this file into a fresh chat session to pick up this project without the prior
> conversation history. Follow the current objective / remaining steps below.

---

## 1. What this project is

An **English-first, standalone fork** of the open-source project
[`xiaozhi-esp32-server`](https://github.com/xinnan-tech/xiaozhi-esp32-server) (by xinnan-tech, MIT licensed).

- The original Chinese source, docs, and UI strings are translated to English.
- **EN-US is the canonical language** (code/naming convention). EN-UK is a display variant only.
- **No data is sent to Chinese services by default** — provider defaults are non-Chinese/local.
- The repo is a **standalone** repository (NOT a fork, no upstream link), so upstream can never overwrite it.

**Published repo:** https://github.com/korey-barrett/xiaozhi-esp32-server-en-standalone (public, standalone)
**Original upstream:** https://github.com/xinnan-tech/xiaozhi-esp32-server

---

## 2. Local environment / repo location

- **Working directory (new clone):** `D:\DEV\Projects\xiaozhi-server-en-standalone\xiaozhi-esp32-server-en-standalone`
  (cloned via GitHub Desktop; `origin` = the standalone repo, at commit `936d0ac`).
- **Old working directory (previous repo, still on disk):** `D:\DEV\Projects\xiaozhi-server\xiaozhi-server`
  — the old fork was **deleted from GitHub**; its full history is preserved locally on the `history-backup` branch there.
- **Git identity:** `Korey Paul Barrett <184138352+korey-barrett@users.noreply.github.com>` (GitHub noreply email — required).

### Toolchain (portable, no-admin — in `C:\Users\korey\devtools\`)
| Tool | Path |
|------|------|
| JDK 21 (Temurin) | `C:\Users\korey\devtools\jdk-21.0.12+8` |
| Maven 3.9.11 | `C:\Users\korey\devtools\apache-maven-3.9.11` |
| pnpm 11.22.0 | global |
| gh CLI 2.97.0 | `C:\Users\korey\devtools\bin\gh.exe` (auth as `korey-barrett`) |
| Ollama | Windows host (`http://192.168.0.198:11434`), model `qwen2.5vl:7b` pulled |

---

## 3. Current state (all work done)

### English-first / no-Chinese-egress (DONE)
- **Console + mobile + Python server + config + docs + `/generator`** are all English-default.
- **Provider defaults (non-Chinese):** LLM/VLLM → **Google Gemini** (free tier), ASR → **FunASR** (local),
  VAD → **Silero** (local), TTS → **Edge TTS** (English voice), Memory → **nomem**, Weather → **Open-Meteo**,
  Web search → **Tavily** (US), News → **BBC RSS** (newsnow plugin disabled).
- **Removed Chinese egress:** pconline IP geolocation (no client-IP egress), QWeather key, Metaso search default,
  Chinanews/NewsNow defaults, Aliyun SMS (optional/off).
- **`/generator`** (device-config tool) rebuilt from `xiaozhi-assets-generator` source with **English default locale**.
- **Remaining Chinese in source:** only functional spoken wake/exit words (`你好小智…`, `退出`, `关闭`).

### Repo / versioning (DONE)
- Standalone repo created, old fork deleted, history squashed to a single commit by Korey.
- Dependabot disabled (`.github/dependabot.yml` removed).
- `LICENSE`/`NOTICE` credit the original `xinnan-tech` project (MIT) + `Copyright (c) 2026 Korey Paul Barrett`.

### Deployment (DONE — fresh deploy)
- Runs in **WSL2 native Docker** (NOT Docker Desktop). Stack: `xiaozhi-esp32-server`, `-web`, `-db`, `-redis`.
- **Fresh deploy done:** DB reset + re-seeded with English defaults; `server.secret` synced; all containers healthy.
- Console: `http://192.168.0.195:8002` (HTTP 200). Server websocket: `ws://172.18.0.4:8000/xiaozhi/v1/` (internal).

---

## 4. ⚠️ REMAINING / NEXT STEPS (do these first in the new session)

### Manual console setup (user action — fresh DB needs these)
1. **Register the super-admin account** (first registration = admin).
2. **Parameter Management** (More → Params Management):
   - `server.websocket` = `ws://192.168.0.195:8000/xiaozhi/v1/`
   - `server.ota` = `http://192.168.0.195:8002/xiaozhi/ota/`
3. **Model Configuration** (Models): add **Gemini API key** for LLM and VLLM (defaults are Gemini; ASR=FunASR local, TTS=Edge English — no keys).
4. **Provider Management**: set Web Search to **Tavily** + add **Tavily API key** (if web search is wanted).
5. **Weather**: Open-Meteo — no key needed.

### Roadmap (documented in `docs/FULL-ENGLISH-CONVERSION-CHECKLIST.md` §8)
- **Future feature:** automatic en-UK → en-US correction (e.g. `Colour → Color`) with a user popup.
- **Future major change:** production localization into EN-UK, zh-CN, zh-TW, ja, ko, es, de, fr *(optional)* via i18n **without touching server code**.
- **Side project:** step-by-step third-party setup instructions (Gemini key, Tavily key, etc.).

---

## 5. HOW TO RUN / DEPLOY (reference)

### Fresh deploy (WSL)
```bash
cd /mnt/d/DEV/Projects/xiaozhi-server-en-standalone/xiaozhi-esp32-server-en-standalone
docker build -f Dockerfile-web   -t xiaozhi-local:web_latest    .
docker build -f Dockerfile-server -t xiaozhi-local:server_latest .
bash deploy-local-now.sh   # backs up DB, resets mysql, deploys via docker-compose.local.yml
```
- `docker-compose.local.yml` uses `xiaozhi-local:*` images with absolute `/opt/xiaozhi-server` paths.
- After a fresh DB reset, **sync `server.secret`**: get the new value from the DB
  (`SELECT param_value FROM sys_params WHERE param_code='server.secret';`) and update
  `/opt/xiaozhi-server/data/.config.yaml` → `manager-api.secret` (write via a docker container, since `/opt` is root-owned), then restart the server container.

### WSL2 + Docker LAN access
- WSL2 NAT exposes ports on `127.0.0.1`; portproxy forwards `0.0.0.0:8000/8002/8003` → WSL IP (`172.17.76.77`).
- Firewall rules `xiaozhi-8000/8002/8003` exist. Re-check the portproxy after any WSL reboot (WSL IP can change).

---

## 6. Key technical notes / constraints

- **GitHub email privacy:** commits must use `<userid>+korey-barrett@users.noreply.github.com`, not a private gmail.
- **`ai_model_config` column is `model_name`** (not `name`) — a migration bug was fixed for this (`202608220900.sql`).
- **`YOUR_` sentinel:** config placeholders start with `YOUR_`; code detects "not configured" via `"YOUR_" in value` — keep that prefix.
- **Retained functional Chinese:** wake words / exit commands (spoken), news/weather functional data.
- **Generator bundle** (`manager-web/public/generator/`) is a build of the external `xiaozhi-assets-generator`; source lives in `%TEMP%\xiaozhi-assets-generator\web` if a rebuild is needed.
- **5 Java test errors** are MySQL-connection failures (need a running DB), not translation issues.

---

## 7. Tooling added (in `tools/`)
- `translate_screenshots.py` — batch OCR+translate of Chinese screenshots via Ollama (`--markdown`, `--json`, `--report`).
- `generate_doc_captions.py` — build English alt-text/captions for docs images.
- `apply_doc_alttext.py` — apply English alt-texts into docs in place (idempotent).
- `run_translate_in_wsl.sh` — WSL wrapper for the above.

---

## 8. Repo structure (top-level)
```
Dockerfile-web, Dockerfile-server, Dockerfile-server-base
README.md, LICENSE, NOTICE, PROJECT-HANDOFF.md (this file)
deploy-local.sh, deploy-local-now.sh, docker-compose.local.yml (in main/xiaozhi-server)
main/
  manager-api/     Java Spring Boot backend (admin console API)
  manager-web/     Vue.js admin console frontend
  manager-mobile/  uni-app mobile app
  xiaozhi-server/  Python core AI server (device-facing)
  digital-human/   browser digital-human test module
docs/              documentation (English) + FULL-ENGLISH-CONVERSION-CHECKLIST.md
tools/             translation/caption tooling
```
