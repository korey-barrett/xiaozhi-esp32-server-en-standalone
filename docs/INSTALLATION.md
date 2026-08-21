# Installation & Deployment Methods

This document audits every way to install/deploy this repo, with the exact commands for each. It is the
authoritative reference for the project instructions. Choose the method that fits your environment.

> **Repo:** `korey-barrett/xiaozhi-esp32-server-en-standalone` (English-first standalone fork)
> **Upstream:** `xinnan-tech/xiaozhi-esp32-server`

---

## Method 1 — Docker: Minimal (server only)

Runs only the Python AI server (no admin console, no DB). Uses the official image.

```bash
cd main/xiaozhi-server
docker compose up -d
```

- **Compose file:** `main/xiaozhi-server/docker-compose.yml`
- **Image:** `ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest`
- **Ports:** `8000` (WebSocket), `8003` (HTTP / OTA / vision)
- **Needs:** `data/.config.yaml` and `models/SenseVoiceSmall/model.pt` (see docs/Deployment.md)

View logs:
```bash
docker logs -f xiaozhi-esp32-server
```

---

## Method 2 — Docker: Full module (server + console + DB + Redis)

Runs the complete stack: Python server, admin console (Vue + Java), MySQL, and Redis. Uses official images.

```bash
cd main/xiaozhi-server
docker compose -f docker-compose_all.yml up -d
```

- **Compose file:** `main/xiaozhi-server/docker-compose_all.yml`
- **Images:** `ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest` and `:web_latest`
- **Ports:** `8000` (WebSocket), `8002` (Admin Console), `8003` (HTTP / vision)
- **Services:** `xiaozhi-esp32-server`, `-web`, `-db` (MySQL), `-redis`

View logs:
```bash
docker logs -f xiaozhi-esp32-server-web
```

---

## Method 3 — One-click install script (Debian/Ubuntu)

Automates Docker install, model download, config download, and full-stack deploy. Interactive (whiptail).

```bash
sudo bash docker-setup.sh
```

- **Script:** `docker-setup.sh` (repo root)
- **Target:** Debian/Ubuntu x86 only
- **Deploys to:** `/opt/xiaozhi-server`
- **Prompts:** Docker mirror selection, then `server.secret` sync after first admin registration

---

## Method 4 — Source code: Python server (conda)

Run the Python AI server directly from source.

```bash
# 1. Create the conda environment (Python 3.10)
conda remove -n xiaozhi-esp32-server --all -y
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server
conda install libopus ffmpeg -y

# 2. Install Python dependencies
cd main/xiaozhi-server
pip install -r requirements.txt

# 3. Run the server
python app.py
```

- **Dependencies:** `main/xiaozhi-server/requirements.txt`
- **Needs:** `data/.config.yaml` and `models/SenseVoiceSmall/model.pt`
- **Ports:** `8000` (WebSocket), `8003` (HTTP / OTA)

---

## Method 5 — Source code: Full module auto-update

Runs the full stack from source with automatic pull/build/restart scripts (see `docs/dev-ops-integration.md`).

```bash
# Web (port 8001/nginx)
./update_8001.sh
# Java backend (port 8002)
./update_8002.sh
# Python server (port 8000)
./update_8000.sh
```

Each script does `git pull`, rebuilds, kills the old process, and restarts. Requires a prior full source
deployment (JDK, Node, conda already set up).

---

## Method 6 — English-translated local images (this fork)

Build the English-translated stack as local Docker images and deploy them. This is the method used for this
fork's live deployment (WSL2 native Docker).

```bash
# 1. Build the local images (from the repo root)
docker build -f Dockerfile-web   -t xiaozhi-local:web_latest    .
docker build -f Dockerfile-server -t xiaozhi-local:server_latest .

# 2. Deploy (resets DB so Liquibase re-seeds English)
bash deploy-local-now.sh        # no sudo (docker runs as root)
# or: sudo bash deploy-local.sh # full build + deploy
```

- **Compose file:** `main/xiaozhi-server/docker-compose.local.yml` (uses `xiaozhi-local:*` images, absolute `/opt` paths)
- **Deploys to:** `/opt/xiaozhi-server`
- **After deploy:** re-register the admin account, then set `server.websocket` and `server.ota` in Parameter Management.

---

## Method 7 — WSL2 + Docker LAN access

The xiaozhi stack runs inside WSL2 native Docker. WSL2 NAT only exposes ports on `127.0.0.1`; add portproxy
rules (from an admin PowerShell) after each WSL reboot to reach it on the LAN IP.

```powershell
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8000 connectaddress=<WSL_IP> connectport=8000
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8002 connectaddress=<WSL_IP> connectport=8002
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8003 connectaddress=<WSL_IP> connectport=8003
```

- WSL `.wslconfig`: `networkingMode=NAT`, `memory=16GB`, `swap=8GB`
- Firewall rules `xiaozhi-8000/8002/8003` must exist.

---

## New: SSO login configuration

SSO (Google / Apple / Microsoft / GitHub) with a passcode second factor is configured in
`main/manager-api/src/main/resources/application.yml` under `xiaozhi.sso`:

```yaml
xiaozhi:
  sso:
    enabled: true
    passcode: "your-passcode"
    frontend-redirect-url: "http://192.168.0.195:8002"
    providers:
      google:
        client-id: "..."
        client-secret: "..."
        redirect-uri: "http://192.168.0.195:8002/xiaozhi/user/sso/callback?provider=google"
      apple:
        client-id: "..."        # services/bundle id
        client-secret: "..."    # .p8 private key
        redirect-uri: "..."
        team-id: "..."
        key-id: "..."
      microsoft:
        client-id: "..."
        client-secret: "..."
        redirect-uri: "..."
      github:
        client-id: "..."
        client-secret: "..."
        redirect-uri: "..."
```

A provider is enabled only when its `client-id` is set. After changing `application.yml`, rebuild the web
image (`docker build -f Dockerfile-web ...`) and redeploy. The `sys_user_oauth` table is created
automatically by Liquibase on startup.

---

## New: Headless device onboarding (serial)

Add a screen-less ESP32 device over serial. Requires `esptool` and `pyserial`.

```bash
# Step 1 — read the MAC address (also resets the board)
esptool --port COM<port> read_mac

# Step 2 — capture the boot log to get the 6-digit setup code
python capture_serial.py COM<port>
```

- `capture_serial.py` (repo root) captures ~15s of boot output at 115200 baud.
- The 6-digit setup code is used to install the device in the admin console.
- A brand-new device is registered; an already-known device (matching MAC) auto-logs-in.

---

## New: Dependency install / update

After pulling updated `package.json` / `pom.xml` files, reinstall dependencies:

```bash
# Java backend
cd main/manager-api
mvn compile

# Web console
cd main/manager-web
npm install
npm run build

# Mobile
cd main/manager-mobile
pnpm install
pnpm build:h5
```

---

## Port reference

| Port | Service |
|------|---------|
| 8000 | WebSocket (device-facing Python server) |
| 8002 | Admin Console (Vue + Java) |
| 8003 | HTTP / OTA / vision endpoint |
