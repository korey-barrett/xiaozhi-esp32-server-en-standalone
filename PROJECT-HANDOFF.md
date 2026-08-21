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
- **Future feature:** **SSO login** via Google / Apple / Microsoft / GitHub accounts, with a **passcode requirement**.
  - ✅ **Implemented:** Google, Apple, Microsoft, GitHub (JustAuth 1.16.7) + passcode second factor. See section 10.
- **Future major change:** production localization into EN-UK, zh-CN, zh-TW, ja, ko, es, de, fr *(optional)* via i18n **without touching server code**.
- **Side project:** step-by-step third-party setup instructions (Gemini key, Tavily key, etc.).

---

## 5. HOW TO RUN / DEPLOY (reference)

> 📘 **Full install/deploy reference:** see `docs/INSTALLATION.md` for an audit of every method (Docker
> minimal/full, one-click script, source, local images, WSL2) plus new commands for SSO, headless device
> onboarding, and dependency install/update.

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
capture_serial.py   (headless-device onboarding helper — captures boot log / 6-digit setup code)
deploy-local.sh, deploy-local-now.sh, docker-compose.local.yml (in main/xiaozhi-server)
main/
  manager-api/     Java Spring Boot backend (admin console API)
  manager-web/     Vue.js admin console frontend
  manager-mobile/  uni-app mobile app
  xiaozhi-server/  Python core AI server (device-facing)
  digital-human/   browser digital-human test module
docs/              documentation (English) + FULL-ENGLISH-CONVERSION-CHECKLIST.md
docs/INSTALLATION.md   (audit of every install/deploy method + new commands: SSO, device onboarding, deps)
tools/             translation/caption tooling
```

---

## 9. Headless device onboarding (serial)

Devices without a screen (headless ESP32 boards) are onboarded over serial. The **MAC address** and the
**6-digit setup code** (needed to install the device in the admin console) are read from the serial port.

**Prerequisites:** `esptool` and `pyserial` installed (`pip install esptool pyserial`).

**Step 1 — Read the MAC address (also resets the board):**
```powershell
esptool --port COM<port> read_mac
```

**Step 2 — Capture the boot log to get the 6-digit setup code:**
```powershell
python capture_serial.py COM<port>
```
`capture_serial.py` (repo root) opens the port, captures ~15s of boot output at 115200 baud, and prints it.
The boot log contains the 6-digit setup code used to install the device in the admin console.

> 💡 The `read_mac` command resets the board via the RTS pin, so run it first, then immediately capture
> the serial output to catch the setup code printed during boot.

> 💡 **New vs. known device:** when you enter the setup code in the admin console, the same prompt checks
> whether the device is **new** or **already known** and acts accordingly. A brand-new device is registered;
> an already-added device (matching MAC) logs straight into the server — no duplicate is created.

> 🔒 **Security:** only the operator can add new devices (the 6-digit setup code is obtained over serial).
> Known devices auto-login on matching MAC, so no one can silently register a device on the server.

**Standing workflow:** when the user says something like "add new device on COM4" (any phrasing containing
`on COM<port>`), run Step 1 then Step 2 against that port and report the MAC + setup code.

**Standing doc convention:** `README.md` and `PROJECT-HANDOFF.md` are auto-updated to reflect every new
change/update without asking for approval.

---

## 10. SSO login (OAuth2/OIDC) with passcode

Users can log in to the admin console with a third-party account (**Google, Apple, Microsoft, GitHub**) plus a
**passcode** second factor.

### How it works
1. The login page shows SSO buttons for the enabled providers.
2. Clicking a provider redirects to its OAuth2 authorization page.
3. The provider redirects back to `/user/sso/callback`, which exchanges the code, stores a **pending SSO
   session** in Redis (10-min expiry), and redirects the browser to `/sso-callback?sso_state=...`.
4. The frontend prompts for the **passcode** and calls `POST /user/sso/verify`.
5. On a correct passcode, the backend links/creates the local user (table `sys_user_oauth`) and issues a
   normal session token.

### Configuration (`application.yml` → `xiaozhi.sso`)
- `enabled` — master switch.
- `passcode` — the required second factor.
- `frontend-redirect-url` — base URL the callback redirects back to (e.g. `http://192.168.0.195:8002`).
- `providers.<google|apple|microsoft|github>` — `client-id`, `client-secret`, `redirect-uri`. A provider is
  enabled only when its `client-id` is set. **Apple** additionally needs `team-id` and `key-id` (the private
  key goes in `client-secret`).

### Backend files
- `SsoController` (`/user/sso/providers`, `/render`, `/callback`, `/verify`)
- `SsoService` / `SsoServiceImpl` (JustAuth flow + passcode + user linking)
- `SsoProperties` (config), `SysUserOauthEntity`/`SysUserOauthDao` (identity link)
- Liquibase `202608241100.sql` creates `sys_user_oauth`.

### Frontend files
- `login.vue` (SSO buttons), `ssoCallback.vue` (passcode dialog), router `/sso-callback`, `user.js` API,
  i18n `sso.*` keys in all 6 languages.

### Security
- SSO alone is not enough — the **passcode** is always required to complete login.
- A brand-new SSO identity auto-creates a local user; the same provider identity always maps to the same
  local user (unique `(provider, provider_user_id)`).
