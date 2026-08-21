# Firmware OTA Auto-Upgrade Configuration Guide for Single-Module Deployment

This tutorial will guide you on how to configure the firmware OTA auto-upgrade feature in a **single-module deployment** scenario, enabling automatic updates of device firmware.

If you are already using **full-module deployment**, please ignore this tutorial.

## Feature Introduction

In single-module deployment, xiaozhi-server has a built-in OTA firmware management feature that can automatically detect the device version and deliver the upgrade firmware. The system will automatically match and push the latest firmware version based on the device model and current version.

## Prerequisites

- You have successfully performed **single-module deployment** and are running xiaozhi-server
- The device can connect to the server normally

## Step 1: Prepare the firmware files

### 1. Create the firmware storage directory

The firmware files need to be placed in the `data/bin/` directory. If the directory does not exist, create it manually:

```bash
mkdir -p data/bin
```

### 2. Firmware file naming rules

The firmware files must follow the following naming format:

```
{DeviceModel}_{VersionNumber}.bin
```

**Naming rule description:**
- `DeviceModel`: The model name of the device, e.g., `lichuang-dev`, `bread-compact-wifi`, etc.
- `VersionNumber`: The firmware version number, must start with a digit, and supports digits, letters, dots, underscores, and hyphens, e.g., `1.6.6`, `2.0.0`, etc.
- The file extension must be `.bin`

**Naming examples:**
```
bread-compact-wifi_1.6.6.bin
lichuang-dev_2.0.0.bin
```

### 3. Place the firmware files

Copy the prepared firmware files (.bin files) to the `data/bin/` directory:

This is repeated three times because it's important: the bin file for upgrade is `xiaozhi.bin`, not the full firmware file `merged-binary.bin`!

This is repeated three times because it's important: the bin file for upgrade is `xiaozhi.bin`, not the full firmware file `merged-binary.bin`!

This is repeated three times because it's important: the bin file for upgrade is `xiaozhi.bin`, not the full firmware file `merged-binary.bin`!

```bash
cp xiaozhi.bin data/bin/DeviceModel_VersionNumber.bin
```

For example:
```bash
cp xiaozhi.bin data/bin/bread-compact-wifi_1.6.6.bin
```

## Step 2: Configure the public access address (only required for public deployment)

**Note: This step only applies to single-module public deployment scenarios.**

If your xiaozhi-server is publicly deployed (using a public IP or domain name), you **must** configure the `server.vision_explain` parameter, because the OTA firmware download address will use the domain and port from this configuration.

If you are deploying on a LAN, you can skip this step.

### Why configure this parameter?

In single-module deployment, when the system generates the firmware download address, it uses the domain and port from the `vision_explain` configuration as the base address. If it is not configured or is configured incorrectly, the device will not be able to access the firmware download address.

### Configuration method

Open the `data/.config.yaml` file, find the `server` configuration section, and set the `vision_explain` parameter:

```yaml
server:
  vision_explain: http://your-domain-or-IP:port/mcp/vision/explain
```

**Configuration examples:**

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
- If using Docker deployment, you cannot use a Docker-internal address (such as 127.0.0.1 or localhost)
- If you are using an nginx reverse proxy, fill in the external address and port number, not the port on which this project runs


## FAQ

### 1. The device does not receive firmware updates

**Possible causes and solutions:**

- Check whether the firmware file naming follows the rule: `{Model}_{VersionNumber}.bin`
- Check whether the firmware file is correctly placed in the `data/bin/` directory
- Check whether the device model matches the model in the firmware file name
- Check whether the firmware version number is higher than the device's current version
- Check the server logs to confirm whether the OTA request is being processed normally

### 2. The device reports the download address cannot be accessed

**Possible causes and solutions:**

- Check whether the domain or IP in the `server.vision_explain` configuration is correct
- Confirm the port number is configured correctly (default 8003)
- If it is public deployment, ensure the device can access the public address
- If it is Docker deployment, make sure you are not using an internal address (127.0.0.1)
- Check whether the firewall has opened the corresponding port
- If you are using an nginx reverse proxy, fill in the external address and port number, not the port on which this project runs

### 3. How to confirm the device's current version

Check the OTA request logs; the logs will show the version number reported by the device:

```
[ota_handler] - Device AA:BB:CC:DD:EE:FF firmware is up to date: 1.6.6
```

### 4. The firmware file does not take effect after being placed

The system has a 30-second cache time (default). You can:
- Wait 30 seconds before having the device initiate an OTA request
- Restart the xiaozhi-server service
- Adjust the `firmware_cache_ttl` configuration to a shorter time
