# Project Handoff — xiaozhi-esp32-server-en (English Translation & Maintenance)

> **Purpose of this file:** This is a complete handoff/context document so a fresh chat session can
> pick up this project without needing the prior conversation history. Import this file into a new
> session and follow the current objective.

---

## 1. What this project is

An **English-language translation and maintenance fork** of the open-source project
[`xiaozhi-esp32-server`](https://github.com/xinnan-tech/xiaozhi-esp32-server) (by xinnan-tech, MIT licensed).

The original Chinese source code, documentation, and user-facing strings have been translated to English
while preserving functionality. The final goal: the **entire repo will be fully English**, then versioned in
**the same 6 languages as the official version** (English, Simplified Chinese, Traditional Chinese, German,
Vietnamese, Portuguese-Brazil).

**Published repo:** https://github.com/korey-barrett/xiaozhi-esp32-server-en (public, maintained by
Korey Paul Barrett / GitHub: `korey-barrett`).

**Original repo (upstream):** https://github.com/xinnan-tech/xiaozhi-esp32-server

---

## 2. Local environment / repo location

- **Working directory:** `D:\DEV\Projects\xiaozhi-server\xiaozhi-server`
- **Git branch:** `main`, in sync with `origin` = `https://github.com/korey-barrett/xiaozhi-esp32-server-en.git`
- **Git identity:** `Korey Paul Barrett <184138352+korey-barrett@users.noreply.github.com>`
  (uses GitHub **noreply** email — required by GitHub's email-privacy protection; do NOT use the private gmail)

### Toolchain installed (portable, no-admin — lives in `C:\Users\korey\devtools\`)
| Tool | Path | Notes |
|------|------|-------|
| JDK 21 (Temurin) | `C:\Users\korey\devtools\jdk-21.0.12+8` | project requires Java 21 |
| Maven 3.9.11 | `C:\Users\korey\devtools\apache-maven-3.9.11` | |
| pnpm 11.22.0 | global | manager-mobile uses pnpm (`only-allow pnpm`) |
| gh CLI 2.97.0 | `C:\Users\korey\devtools\bin\gh.exe` | authenticated as `korey-barrett` |

`JAVA_HOME` and `PATH` include the JDK/Maven/gh dirs (set at user level). In a fresh shell you may need:
```powershell
$env:JAVA_HOME="C:\Users\korey\devtools\jdk-21.0.12+8"
$env:PATH="C:\Users\korey\devtools\jdk-21.0.12+8\bin;C:\Users\korey\devtools\apache-maven-3.9.11\bin;C:\Users\korey\devtools\bin;$env:PATH"
```

### Build verification status (all PASS)
- Java backend `main/manager-api`: `mvn compile` → SUCCESS (451 classes). `mvn test` → 121/126 pass;
  5 errors are MySQL connection failures (need a running DB, not translation issues).
- Vue frontend `main/manager-web`: `npm install && npm run build` → SUCCESS
- uni-app mobile `main/manager-mobile`: `pnpm install && pnpm build:h5` → SUCCESS
- Python `main/xiaozhi-server` + `main/digital-human`: 183 `.py` files compile OK
- JS: 49 files pass `node --check`

---

## 3. Translation status (COMPLETE across all areas)

All Chinese has been translated to English, with only **documented functional exceptions** preserved.

| Area | Status |
|------|--------|
| manager-api (Java backend) | ✅ All English (entities/DTOs/VOs, controllers, services, config, SQL seeds, tests, i18n bundles) |
| xiaozhi-server (Python) | ✅ All English (providers, core, plugins, config.yaml, etc.) |
| manager-web (Vue) | ✅ All English (components, views, apis, i18n dictionaries, public HTML) |
| manager-mobile (uni-app) | ✅ All English (pages, i18n, legal docs, env, config) |
| docs/ | ✅ All English |
| root/misc | ✅ READMEs, .github, Dockerfiles, shell scripts, env files |
| digital-human | ✅ All English (code, model display names, READMEs) |

### Documented functional exceptions — kept in Chinese (DO NOT translate)
These are matched against **actual spoken Chinese** by the ESP32, or are functional data. Translating breaks functionality:
- **Wake words** — `你好小智;你好小志;小爱同学;...` (sys_params `wakeup_words`)
- **Exit commands** — `退出;关闭` (sys_params `exit_commands`)
- **News-source names** — `澎湃新闻;百度热搜;财联社;...` (news plugin)
- **Default city** — `广州` (weather plugin)
- **Pinyin TTS pronunciation dict** — `处理/(chu3)(li3)` etc.
- **CJK name-validation regex** — `[一-龥]` in AddressBookDialog.vue
- **`YOUR_` sentinel placeholders** with trailing Chinese descriptions (e.g. `YOUR_LLM API密钥`) — the `YOUR_` prefix is the functional "not configured" marker; code checks `"YOUR_" in value`

Full list is in `docs/TRANSLATION-GLOSSARY.md` (the durable translation glossary + progress tracker).

---

## 4. Repo structure (top-level)

```
Dockerfile-server, Dockerfile-server-base, Dockerfile-web  (Docker builds)
README.md          (has English-fork intro section)
LICENSE            (MIT: original xinnan-tech + Copyright (c) 2026 Korey Paul Barrett)
NOTICE             (credits original project + this fork)
SECURITY.md        (added on GitHub)
PROJECT-HANDOFF.md (this file — import into a fresh chat session)
deploy-local.sh, deploy-local-now.sh   (helpers to build + deploy the English stack; WSL)
capture_serial.py   (headless-device onboarding helper — captures boot log / 6-digit setup code)
main/
  manager-api/     Java Spring Boot backend (admin console API)
  manager-web/     Vue.js admin console frontend
  manager-mobile/  uni-app mobile app
  xiaozhi-server/  Python core AI server (device-facing)
    docker-compose.local.yml   (local-images deployment, absolute /opt paths)
  digital-human/   browser digital-human test module
docs/              documentation (English) + TRANSLATION-GLOSSARY.md
```

---

## 5. HOW TO RUN LOCALLY (reference)

### Full module (Docker) — recommended (official images)
```bash
cd main/xiaozhi-server
docker-compose -f docker-compose_all.yml up -d
```
- Console: `http://<LAN-IP>:8002` (portproxy needed if inside WSL2; see note below)
- OTA: `http://<LAN-IP>:8002/xiaozhi/ota/`

### English-translated deployment (local images) — see section 6
```bash
cd /mnt/d/DEV/Projects/xiaozhi-server/xiaozhi-server
docker build -f Dockerfile-web -t xiaozhi-local:web_latest .
docker build -f Dockerfile-server -t xiaozhi-local:server_latest .
bash deploy-local-now.sh   # reset DB + deploy docker-compose.local.yml (xiaozhi-local images)
```

### WSL2 + Docker LAN access (NAT + portproxy)
The xiaozhi server runs inside WSL2 Docker. WSL2 only exposes ports on `127.0.0.1`. To reach it on the
LAN IP, run after each WSL reboot (from an admin PowerShell):
```powershell
# (The old setup-wsl-nat-portproxy.ps1 was removed from the repo.)
# Manual: get WSL IP, then:
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8000 connectaddress=<WSL_IP> connectport=8000
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8002 connectaddress=<WSL_IP> connectport=8002
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8003 connectaddress=<WSL_IP> connectport=8003
# plus firewall rules (already added): xiaozhi-8000/8002/8003
```
- WSL `.wslconfig`: `networkingMode=NAT`, `memory=16GB`, `swap=8GB`
- Console config: `server.websocket` = `ws://192.168.0.195:8000/xiaozhi/v1/`, `server.ota` =
  `http://192.168.0.195:8002/xiaozhi/ota/` — set in the 智控台 console "Parameter Management".

---

## 6. DEPLOYMENT — ENGLISH-TRANSLATED STACK (in progress)

> Status as of last session: the **English-translated Docker stack is DEPLOYED and running** on the
> WSL2 Docker engine. All containers are up. See "CURRENT WORK / PENDING" below for what's unfinished.

### Key discovery: the server runs in WSL2-native Docker, NOT Docker Desktop
- The xiaozhi stack runs in **WSL2's native Docker engine** (`/opt/xiaozhi-server/docker-compose_all.yml`),
  NOT Docker Desktop. The `ghcr.nju.edu.cn/xinnan-tech/*` images were the official (Chinese) upstream.
- To deploy the English code, I build **local images** (`xiaozhi-local:server_latest` / `web_latest`)
  from the translated repo and run them from `/opt/xiaozhi-server`.
- MySQL data lives at `/opt/xiaozhi-server/mysql/data` (bind mount). Resetting it re-seeds English.
- Docker now runs without sudo (`korey` added to the docker group).

### How to redeploy (the "lighter" approach — reuse official server-base)
```bash
# From WSL:
cd /mnt/d/DEV/Projects/xiaozhi-server/xiaozhi-server
docker build -f Dockerfile-web   -t xiaozhi-local:web_latest    .   # Vue+Java (takes ~10min first time, cached after)
docker build -f Dockerfile-server -t xiaozhi-local:server_latest .   # fast (reuses official server-base)
bash deploy-local-now.sh   # backs up DB, resets mysql data, deploys via docker-compose.local.yml
```
- `docker-compose.local.yml` uses `xiaozhi-local:*` images with ABSOLUTE `/opt/xiaozhi-server` paths.
- `deploy-local-now.sh` runs the whole reset+deploy without sudo (docker containers do the /opt writes).

### Issues found & fixed during deployment (IMPORTANT — record of what was done)
1. **`start.sh`/`nginx.conf` CRLF line endings** broke `exec /start.sh` in the web container — converted to LF.
2. **`ai_tts_voice.name`** column was `VARCHAR(20)`; English voice names are longer. Widened to `VARCHAR(100)`
   in `202503141346.sql`. (Also had to shorten a few voice names in `202504151206.sql`, `202504221135.sql`.)
3. **`ai_model_provider.name`** (was VARCHAR(50)) and **`ai_model_config.model_name`** (was VARCHAR(50))
   widened to `VARCHAR(100)` — English names like "Alibaba Bailian Paraformer Real-time Speech Recognition" exceed 50.
4. **My own `202608061500.sql`** remark for wakeup_words was over `VARCHAR(200)` sys_params.remark — shortened.
5. **server.secret mismatch** after DB reset — the manager-api generates a new secret; the Python server's
   `/opt/xiaozhi-server/data/.config.yaml` `manager-api.secret` must be updated to match. (Current secret in DB
   was `21f15953-4a19-44f0-9997-c08b86d05cd5`.)

### ✅ COMPLETED (as of the session that fixed the SSRF OTA whitelist)
- **SSRF OTA whitelist FIXED and DEPLOYED.** `SysParamsController.java` had a Copilot-Autofix security
  patch (`c336c473`) that only allowed `https://ota.example.com/ota/`, rejecting `http://192.168.0.195:8002/xiaozhi/ota/`
  (misleadingly reported as "OTA address must end in /ota/"). Added `isTrustedOtaHost()` allowing private/LAN
  (RFC1918) hosts in addition to the trust list. Rebuilt `xiaozhi-local:web_latest` (image `49f83568b734`) and
  **recreated the web container** — it now runs the fixed image. Verified `http://192.168.0.195:8002/xiaozhi/ota/`
  is reachable **from inside the container** and returns a body containing "OTA", so the OTA GET validation passes.
  → The user can now SAVE `server.ota` = `http://192.168.0.195:8002/xiaozhi/ota/` in Parameter Management.
- **Commit + push DONE** (commit `118e3ff8`, pushed to `origin/main`). Working tree clean & in sync.
- **Admin account**: logs show an active session (user id `2090723320123240450`), so an account is already registered.
- **`server.websocket`** = `ws://192.168.0.195:8000/xiaozhi/v1/` was already accepted (prior session).
- Deployment helper files (`deploy-local.sh`, `deploy-local-now.sh`, `docker-compose.local.yml`) are now committed;
  `fix_secret.sh` + `get_secret.sql` (machine-specific, contain a hardcoded secret) are **gitignored**.

### ⚠️ REMAINING (user action / verification)
- Save `server.ota` = `http://192.168.0.195:8002/xiaozhi/ota/` in Parameter Management (should now succeed).
- Confirm the admin account is usable / re-register if needed.

---

## 7. CURRENT OBJECTIVE (last in-progress task — the Parameter Management parse is DONE)

### Task: Parse "Parameter Management" (under the "More" menu) in manager-web for Chinese text — DONE
The page UI is fully English. The only Chinese is the **`param_value` data** for `wakeup_words` and
`exit_commands` (spoken-Chinese, critical, kept). I added an English translation note in their `remark`
(via changelog `202608061500.sql`) and logged them for future removal in `docs/TRANSLATION-GLOSSARY.md`.
This is COMPLETE. The remaining work is now the DEPLOYMENT/PENDING items in section 6.

---

## 8. Known constraints / notes

- **GitHub email privacy:** commits must use `<userid>+korey-barrett@users.noreply.github.com`, not the
  private gmail, or GitHub rejects the push (GH007).
- **5 Java test errors** are MySQL-connection failures (integration tests need a running DB); not translation issues.
- **The generator assets** (`manager-web/public/generator/static/...`) are packaged build artifacts of the
  external `xiaozhi-assets-generator` project — do NOT hand-edit minified bundles.
- **Live2D model files** (`digital-human/resources/*`) are model data — `Name` display fields translated, `Id` values preserved.
- **`YOUR_` sentinel:** config placeholder values start with `YOUR_` and the code detects "not configured"
  via `"YOUR_" in value` — keep that marker consistent across config + code.

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
