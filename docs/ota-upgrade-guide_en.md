# Firmware OTA Auto-Upgrade Configuration Guide for Single-Module Deployment

This tutorial will guide you through configuring the firmware OTA auto-upgrade feature in a **single-module deployment** scenario, enabling automatic updates of the device firmware.

If you are already using **full-module deployment**, ignore this tutorial.

## Feature Description

In single-module deployment, xiaozhi-server has a built-in OTA firmware management feature that can automatically detect the device version and push the upgrade firmware. The system automatically matches and pushes the latest firmware version based on the device model and current version.

## Prerequisites

- You have successfully performed a **single-module deployment** and are running xiaozhi-server
- The device can connect to the server normally

## Step 1: Prepare the Firmware File

### 1. Create the Firmware Storage Directory

The firmware file needs to be placed in the `data/bin/` directory. If the directory does not exist, create it manually:

```bash
mkdir -p data/bin
```

### 2. Firmware File Naming Rules

The firmware file must follow the following naming format:

```
{device-model}_{version-number}.bin
```

**Naming rule explanation:**
- `device-model`: the device model name, for example `lichuang-dev`, `bread-compact-wifi`, etc.
- `version-number`: the firmware version number, which must start with a digit and supports digits, letters, dots, underscores, and hyphens, for example `1.6.6`, `2.0.0`, etc.
- The file extension must be `.bin`

**Naming examples:**
```
bread-compact-wifi_1.6.6.bin
lichuang-dev_2.0.0.bin
```

### 3. Place the Firmware File

Copy the prepared firmware file (the .bin file) to the `data/bin/` directory:

Important — repeated three times: the upgrade bin file is `xiaozhi.bin`, NOT the full firmware file `merged-binary.bin`!

Important — repeated three times: the upgrade bin file is `xiaozhi.bin`, NOT the full firmware file `merged-binary.bin`!

Important — repeated three times: the upgrade bin file is `xiaozhi.bin`, NOT the full firmware file `merged-binary.bin`!

```bash
cp xiaozhi.bin data/bin/device-model_version-number.bin
```

For example:
```bash
cp xiaozhi.bin data/bin/bread-compact-wifi_1.6.6.bin
```

## Step 2: Configure the Public Access Address (only needed for public deployments)

**Note: this step only applies to the single-module public deployment scenario.**

If your xiaozhi-server is deployed publicly (using a public IP or domain name), you **must** configure the `server.vision_explain` parameter, because the OTA firmware download address will use the domain and port configured there.

If you are doing a LAN deployment, you can skip this step.

### Why configure this parameter?

In single-module deployment, when the system generates the firmware download address, it uses the domain and port configured in `vision_explain` as the base address. If it is not configured or is misconfigured, the device will not be able to access the firmware download address.

### How to configure it

Open the `data/.config.yaml` file, find the `server` section, and set the `vision_explain` parameter:

```yaml
server:
  vision_explain: http://your-domain-or-ip:port/mcp/vision/explain
```

**Configuration example:**

LAN deployment (default):
```yaml
server:
  vision_explain: http://192.168.1.100:8003/mcp/vision/explain
```

Public domain deployment:
```yaml
server:
  vision_explain: http://yourdomain.com:8003/mcp/vision/explain
```

### Notes

- The domain or IP must be an address the device can access
- If using Docker deployment, do not use a Docker internal address (such as 127.0.0.1 or localhost)
- If you use an nginx reverse proxy, fill in the external address and port, not the port on which this project runs

## Frequently Asked Questions

### 1. The device does not receive firmware updates

**Possible causes and solutions:**

- Check whether the firmware file name follows the rule: `{model}_{version}.bin`
- Check whether the firmware file is correctly placed in the `data/bin/` directory
- Check whether the device model matches the model in the firmware file name
- Check whether the firmware version number is higher than the device's current version
- View the server logs to confirm whether OTA requests are handled normally

### 2. The device reports that the download address is inaccessible

**Possible causes and solutions:**

- Check whether the domain or IP configured in `server.vision_explain` is correct
- Confirm the port number is configured correctly (default 8003)
- If it is a public deployment, make sure the device can access that public address
- If it is a Docker deployment, make sure you are not using an internal address (127.0.0.1)
- Check whether the firewall has opened the corresponding port
- If you use an nginx reverse proxy, fill in the external address and port, not the port on which this project runs

### 3. How do I confirm the device's current version

View the OTA request log; the log shows the version number reported by the device:

```
[ota_handler] - Device AA:BB:CC:DD:EE:FF firmware is up to date: 1.6.6
```

### 4. The firmware file has no effect after being placed

The system has a 30-second cache time (default). You can:
- Wait 30 seconds and then let the device make an OTA request
- Restart the xiaozhi-server service
- Adjust the `firmware_cache_ttl` configuration to a shorter time
