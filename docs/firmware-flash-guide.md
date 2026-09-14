# Flashing xiaozhi-esp32 Firmware for a Board from the Console Dictionary

> This guide is **fork-specific**: it goes from a board **name in the Console's board dictionary**
> to a flashing that board's firmware, with the firmware's OTA address pointed at **your** locally
> running `xiaozhi-esp32-server` instead of the cloud (`https://api.tenclass.net/xiaozhi/ota/`).

## 1. The firmware is a separate project

This repo is the **server + admin console**. The ESP32 firmware is built from the upstream firmware
project:

```
https://github.com/78/xiaozhi-esp32
```

Clone and build it on any machine with the ESP-IDF toolchain — you do **not** build the firmware
from this repo. The server just needs to be running so the board has somewhere to connect afterwards.

## 2. Pick your board from the dictionary

The Console's board dictionary (System → Dictionary → `FIRMWARE_TYPE`, ~185 entries) is **not an
arbitrary list**: it is synced verbatim from the firmware project's `main/boards/**/config.json`
build names (`db/changelog/202609141500.sql`). Every entry is the exact string a device built for
that board reports as `board.type` / `board.name` — so the dictionary name is the identity your
server will use to recognize and update the board.

To find your board in the firmware source, search by the dictionary entry:

```bash
cd xiaozhi-esp32
grep -rl "<dictionary-entry>" main/boards/
# example: grep -rl "quandong-s3-dev" main/boards/
```

That finds the board directory (flat `main/boards/<board>/` or grouped
`main/boards/<manufacturer>/<board>/`). Its `config.json` tells you what you need:

```json
{
    "type": "quandong-s3-dev",          // board family / compatibility identity
    "target": "esp32s3",                // chip you must set-target
    "builds": [
        { "name": "quandong-s3-dev", "sdkconfig_append": [] }
    ]
}
```

Notes:

- The dictionary holds **build variants**, not just families. e.g. `bread-compact-wifi`,
  `bread-compact-wifi-128x64`, `bread-compact-wifi-lcd`, `bread-compact-esp32` are separate
  entries — pick the one matching your exact hardware + display.
- Names are lowercase `[a-z0-9.-]` with dashes only — no underscores in reported names
  (underscores only exist in the menuconfig symbol, e.g. `BOARD_TYPE_QUANDONG_S3_DEV`).
- `target` is the chip: `esp32`, `esp32s3`, `esp32c3`, `esp32c6`, `esp32p4`, … It must match your
  physical chip for the build to work.

## 3. Decide which OTA endpoint your board will use

Your standalone stack runs **two** OTA endpoints side by side, and **both** speak the device OTA
protocol (they return `server_time`, `firmware`, `websocket` **or** `mqtt`, plus an `activation`
code for new devices). Which one you point the firmware at depends on how you want to *manage*
firmware and server config — not on one being "more correct".

| Endpoint | Served by | How server config is read | How firmware is managed |
|---|---|---|---|
| `http://<LAN-IP>:8002/xiaozhi/ota/` | Web container (Java console) | Console → Parameter Management (`server.websocket`, `server.mqtt_gateway`, `server.mqtt_signature_key`, `server.ota`) | Console **Firmware** page — uploaded files are stored in the database; download link built from `server.ota` |
| `http://<LAN-IP>:8003/xiaozhi/ota/` | Python server (`core/http_server.py`) | `data/.config.yaml` (`server.websocket`, `server.mqtt_gateway`, `server.mqtt_signature_key`) | `.bin` files named `{model}_{version}.bin` staged in `data/bin/` (see [ota-upgrade-guide.md](./ota-upgrade-guide.md)) |

For the live full-module stack in this deployment, **`:8002` is the standard/console-managed
endpoint** (the address printed in `README.md` and used by the full-module section of
`docs/firmware-build.md`). If you would rather push firmware by dropping files into the server
container, use **`:8003`**. Either way, the device receives your WebSocket or MQTT gateway config,
so it connects exactly like any other board on your stack.

## 4. Point the firmware's OTA address at your server

The firmware's hardcoded OTA/cloud address lives in **`main/Kconfig.projbuild`**:

Before:
```
config OTA_URL
    string "Default OTA URL"
    default "https://api.tenclass.net/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```

Change the `default` to your chosen endpoint. For this live LAN deployment, either:

```
    default "http://192.168.0.195:8002/xiaozhi/ota/"    # console-managed (DB)
```
or
```
    default "http://192.168.0.195:8003/xiaozhi/ota/"    # file-driven (data/bin)
```

That single change is what turns the board into a **self-hosted** device instead of one phoning home
to `api.tenclass.net` / the `xiaozhi.me` cloud flow.

## 5. Build the firmware

Requires the ESP-IDF toolchain ([official Windows setup](https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/get-started/windows-setup.html)):

```bash
cd xiaozhi-esp32
idf.py set-target esp32s3        # from the board's config.json "target"
idf.py menuconfig                # Xiaozhi Assistant → Target Board → pick your board
idf.py build
```

WiFi credentials / wake word / language are user build options set in menuconfig (or provisioned
later once the device connects to the server).

## 6. Flash the new board

With the board USB-connected (ESP-IDF env active):

```bash
idf.py flash monitor
```

Browser alternative (no build environment needed): `cd scripts && python release.py` produces a
flashable `build/merged-binary.bin` that you can load with
[ESP Launchpad](https://espressif.github.io/esp-launchpad/).

## 7. First boot

1. The board boots and **POSTs** to your `OTA_URL`
   (`http://192.168.0.195:8002/xiaozhi/ota/` or `:8003`) reporting its **MAC** (`device-id` =
   the MAC address), `board.type`/`board.name` (your dictionary entry), and firmware version.
2. Your server replies with the transport config — with the MQTT gateway enabled it is the `mqtt`
   block: broker `192.168.0.195:1883`, client id `GID_<board>@@@<mac>@@@<mac>`, a signed password —
   and the board shows **online** in the Console.
3. A **brand-new** board also receives an **activation code**; install it in the Console like any
   new device (the 6-digit setup-code onboarding). Known boards log straight in.
4. Say the wake word — the board starts talking through your stack.

## 8. Push firmware updates over the air (auto-OTA)

The server only delivers a firmware file when the reported **version is newer** than the board's
current one, the model matches exactly, and the file is staged:

- **Console-managed (`:8002`):** upload the firmware via the Console's Firmware page (stored in
  the DB; download link derived from `server.ota`).
- **File-driven (`:8003`):** copy the **OTA upgrade image**, which in an `idf.py build` is
  **`build/xiaozhi.bin`** — **not** `merged-binary.bin` — into the server container's `data/bin/`
  named `{dictionary-entry}_{version}.bin`:
  ```
  data/bin/quandong-s3-dev_1.6.6.bin
  ```
  The download URL comes from `server.vision_explain` (already `http://192.168.0.195:8003/...`)
  rewritten to `/xiaozhi/ota/download/{file}` (`core/api/ota_handler.py`). There is a 30-second
  model cache after you drop files in.

## 9. Verification

- `curl http://<LAN-IP>:8003/xiaozhi/ota/` → "OTA interface is running normally, the websocket
  address sent to devices is: ws://192.168.0.195:8000/xiaozhi/v1/"
- `docker logs xiaozhi-esp32-server` shows the board's OTA request line with its reported model and
  version.
- Console → Device Management shows the new board **online** (green) — confirming the MQTT
  gateway bridge, not just the raw websocket.
- Board answers the wake word through your server.
