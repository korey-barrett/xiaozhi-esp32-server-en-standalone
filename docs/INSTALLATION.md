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
- **Image:** `xiaozhi-local:server_latest`
- **Ports:** `8000` (WebSocket), `8003` (HTTP / OTA / vision)
- **Needs:** `data/.config.yaml` and `models/SenseVoiceSmall/model.pt` (see docs/Deployment.md)

View logs:
```bash
docker logs -f xiaozhi-esp32-server
```

---

## Method 2 — Docker: Full module (server + console + DB + Redis)

Runs the complete stack: Python server, admin console (Vue + Java), MySQL, Redis, and the **MQTT gateway**
(which provides live device online status + theme-generator hardware autofill). Uses official/local images.

```bash
cd main/xiaozhi-server
docker compose -f docker-compose_all.yml up -d
```

- **Compose file:** `main/xiaozhi-server/docker-compose_all.yml`
- **Images:** `xiaozhi-local:server_latest`, `:web_latest`, and `:mqtt_gateway`
- **Ports:** `8000` (WebSocket), `8002` (Admin Console), `8003` (HTTP / vision), `1883` (MQTT), `8884`/udp
  (device discovery), `8007` (gateway manager API)
- **Services:** `xiaozhi-esp32-server`, `-web`, `-db` (MySQL), `-redis`, `-mqtt-gateway`
- **MQTT gateway env:** create `main/xiaozhi-server/mqtt-gateway.env` from `mqtt-gateway.env.example`
  (`PUBLIC_IP` = your LAN IP, `MQTT_SIGNATURE_KEY` = the same value you set in `server.mqtt_signature_key`).
  See [mqtt-gateway-integration.md](./mqtt-gateway-integration.md).

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
docker build -f Dockerfile-mqtt-gateway -t xiaozhi-local:mqtt_gateway .

# 2. Deploy (resets DB so Liquibase re-seeds English)
bash deploy-local-now.sh        # no sudo (docker runs as root)
# or: sudo bash deploy-local.sh # full build + deploy
```

- **Compose file:** `main/xiaozhi-server/docker-compose.local.yml` (uses `xiaozhi-local:*` images, absolute `/opt` paths)
- **Deploys to:** `/opt/xiaozhi-server`
- **After deploy:** re-register the admin account, then set `server.websocket` and `server.ota` in Parameter Management.
- **MQTT gateway:** create `main/xiaozhi-server/mqtt-gateway.env` (see `mqtt-gateway.env.example`) so the
  5th service comes up and the console shows live device status. Set `server.mqtt_gateway` /
  `server.mqtt_signature_key` / `server.udp_gateway` / `server.mqtt_manager_api` in Parameter Management to
  match it (see [mqtt-gateway-integration.md](./mqtt-gateway-integration.md)).

---

## Method 7 — WSL2 + Docker LAN access (mirrored mode)

The xiaozhi stack runs inside WSL2 native Docker with `networkingMode=mirrored`, so the VM shares the host's
LAN IP and published container ports are reachable on the host at `127.0.0.1:<port>`. They are **not**
reachable on the LAN IP by themselves — add portproxy rules bound to the **LAN IP → `127.0.0.1`** (from an
admin PowerShell) so other LAN devices can reach the stack:

```powershell
netsh interface portproxy add v4tov4 listenaddress=<LAN_IP> listenport=8000 connectaddress=127.0.0.1 connectport=8000
netsh interface portproxy add v4tov4 listenaddress=<LAN_IP> listenport=8002 connectaddress=127.0.0.1 connectport=8002
netsh interface portproxy add v4tov4 listenaddress=<LAN_IP> listenport=8003 connectaddress=127.0.0.1 connectport=8003
# MQTT gateway ports (device-facing, LAN)
netsh interface portproxy add v4tov4 listenaddress=<LAN_IP> listenport=1883 connectaddress=127.0.0.1 connectport=1883
netsh interface portproxy add v4tov4 listenaddress=<LAN_IP> listenport=8007 connectaddress=127.0.0.1 connectport=8007
netsh interface portproxy add v4tov4 listenaddress=<LAN_IP> listenport=8884 connectaddress=127.0.0.1 connectport=8884
```
The UDP rule for `8884` is best-effort — mirrored-mode publish usually already binds UDP onto the LAN IP.
Verify MQTT+UDP from an actual device (host self-tests can black-hole).

- WSL `.wslconfig`: `networkingMode=mirrored`, `memory=8GB`, `processors=8`, `swap=4GB`.
- **Do NOT bind to `0.0.0.0`** — it collides with Docker's mirrored publish (`address already in use`) and
  blocks the containers from starting. Bind to the LAN IP instead (verified 2026-09-14).
- Firewall rules `xiaozhi-8000/8002/8003` exist (leave them); add matching rules for `1883`, `8007`,
  `8884`/UDP if devices can't connect. `iphlpsvc` (IP Helper) must be **running** — it is what turns
  portproxy rules into real listeners.
- **On the host itself, use `http://localhost:8002`** — the LAN IP is not reachable from the host browser in
  mirrored mode (verified); it is only reachable from other LAN devices. Confirm LAN access from a phone /
  another PC / the ESP32.

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
| 1883 | MQTT broker (MQTT gateway, device-facing) |
| 8884 | UDP device discovery (MQTT gateway) |
| 8007 | Gateway manager API (device status / tools; consumed by Java manager-api) |
