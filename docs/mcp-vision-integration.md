# Vision Model Usage Guide
This tutorial is divided into two parts:
- Part 1: Enable the vision model with single-module xiaozhi-server
- Part 2: How to enable the vision model in full-module mode

Before enabling the vision model, you need to prepare three things:
- You need a device with a camera that already implements camera calling in the xiaozhi repo. For example, the `LCKFB ESP32-S3 development board`
- Your device firmware version is upgraded to 1.6.6 or above
- You have already successfully run the basic conversation module

## Enabling the vision model with single-module xiaozhi-server

### Step 1: Confirm the network
The vision model starts port 8003 by default.

If you are running with Docker, confirm that your `docker-compose.yml` exposes port `8003`; if not, update to the latest `docker-compose.yml` file

If you are running from source, confirm that your firewall allows port `8003`

### Step 2: Choose your vision model
Open your `data/.config.yaml` file and set `selected_module.VLLM` to a vision model. Currently we support vision models with `openai`-type interfaces. `ChatGLMVLLM` is one of the models compatible with `openai`.

```
selected_module:
  VAD: ..
  ASR: ..
  LLM: ..
  VLLM: ChatGLMVLLM
  TTS: ..
  Memory: ..
  Intent: ..
```

Suppose we use `ChatGLMVLLM` as the vision model. First we need to log in to the [Zhipu AI](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) website and apply for an API key. If you have already applied for a key, you can reuse it.

Add this configuration to your config file; if the configuration already exists, just set your api_key.

```
VLLM:
  ChatGLMVLLM:
    api_key: your_api_key
```

### Step 3: Start the xiaozhi-server service
If you are running from source, start it with this command:
```
python app.py
```
If you are running with Docker, restart the container:
```
docker restart xiaozhi-esp32-server
```

After startup, logs similar to the following will be output.

```
2025-06-01 **** - OTA endpoint is       http://192.168.4.7:8003/xiaozhi/ota/
2025-06-01 **** - Vision analysis endpoint is  http://192.168.4.7:8003/mcp/vision/explain
2025-06-01 **** - Websocket address is   ws://192.168.4.7:8000/xiaozhi/v1/
2025-06-01 **** - =======The above addresses are websocket protocol addresses; do not visit them with a browser=======
2025-06-01 **** - To test websocket, start the digital-human module and open the browser for interactive testing
2025-06-01 **** - =============================================================
```

After startup, use a browser to open the `Vision analysis endpoint` connection shown in the log. See what it outputs? If you are on Linux and have no browser, you can run this command:
```
curl -i your-vision-analysis-endpoint
```

Normally it will display like this:
```
MCP Vision interface is running normally. The vision explanation endpoint address is: http://xxxx:8003/mcp/vision/explain
```

Please note: if you are deploying to the public network, or with Docker, you must change this configuration in your `data/.config.yaml`:
```
server:
  vision_explain: http://your-ip-or-domain:port/mcp/vision/explain
```

Why? Because the vision explanation endpoint needs to be delivered to the device. If your address is a LAN address or a Docker-internal address, the device cannot access it.

Suppose your public address is `111.111.111.111`; then `vision_explain` should be configured like this:

```
server:
  vision_explain: http://111.111.111.111:8003/mcp/vision/explain
```

If your MCP Vision endpoint runs normally, and you have also successfully opened the delivered `vision explanation endpoint address` in a browser, please continue to the next step

### Step 4: Enable device wake-up

Say to the device: "Please turn on the camera and tell me what you see"

Watch the xiaozhi-server log output to see if there are any errors.


## How to enable the vision model in full-module mode

### Step 1: Confirm the network
The vision model starts port 8003 by default.

If you are running with Docker, confirm that your `docker-compose_all.yml` maps port `8003`; if not, update to the latest `docker-compose_all.yml` file

If you are running from source, confirm that your firewall allows port `8003`

### Step 2: Confirm your config file

Open your `data/.config.yaml` file and confirm that its structure matches `data/config_from_api.yaml`. If it differs, or something is missing, add it.

### Step 3: Configure the vision model API key

We first need to log in to the [Zhipu AI](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) website and apply for an API key. If you have already applied for a key, you can reuse it.

Log in to the `Console`, click `Model Configuration` in the top menu, click `Vision LLM` in the left sidebar, find `VLLM_ChatGLMVLLM`, click the Edit button, enter your API key in the `API Key` field in the popup, and click Save.

After saving successfully, go to the agent you want to test, click `Configure Role`, and in the opened content check whether `Vision LLM (VLLM)` has the vision model you just selected. Click Save.

### Step 3: Start the xiaozhi-server module
If you are running from source, start it with this command:
```
python app.py
```
If you are running with Docker, restart the container:
```
docker restart xiaozhi-esp32-server
```

After startup, logs similar to the following will be output.

```
2025-06-01 **** - Vision analysis endpoint is  http://192.168.4.7:8003/mcp/vision/explain
2025-06-01 **** - Websocket address is   ws://192.168.4.7:8000/xiaozhi/v1/
2025-06-01 **** - =======The above addresses are websocket protocol addresses; do not visit them with a browser=======
2025-06-01 **** - To test websocket, start the digital-human module and open the browser for interactive testing
2025-06-01 **** - =============================================================
```

After startup, use a browser to open the `Vision analysis endpoint` connection shown in the log. See what it outputs? If you are on Linux and have no browser, you can run this command:
```
curl -i your-vision-analysis-endpoint
```

Normally it will display like this:
```
MCP Vision interface is running normally. The vision explanation endpoint address is: http://xxxx:8003/mcp/vision/explain
```

Please note: if you are deploying to the public network, or with Docker, you must change this configuration in your `data/.config.yaml`:
```
server:
  vision_explain: http://your-ip-or-domain:port/mcp/vision/explain
```

Why? Because the vision explanation endpoint needs to be delivered to the device. If your address is a LAN address or a Docker-internal address, the device cannot access it.

Suppose your public address is `111.111.111.111`; then `vision_explain` should be configured like this:

```
server:
  vision_explain: http://111.111.111.111:8003/mcp/vision/explain
```

If your MCP Vision endpoint runs normally, and you have also successfully opened the delivered `vision explanation endpoint address` in a browser, please continue to the next step

### Step 4: Enable device wake-up

Say to the device: "Please turn on the camera and tell me what you see"

Watch the xiaozhi-server log output to see if there are any errors.
