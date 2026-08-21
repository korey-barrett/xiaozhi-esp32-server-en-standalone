# MCP Endpoint Deployment and Usage Guide

This tutorial contains 3 parts
- 1. How to deploy the MCP endpoint service
- 2. How to configure the MCP endpoint in full-module deployment
- 3. How to configure the MCP endpoint in single-module deployment

# 1. How to deploy the MCP endpoint service

## Step 1: Download the MCP endpoint project source code

Open the [MCP endpoint project address](https://github.com/xinnan-tech/mcp-endpoint-server) in your browser.

Once opened, find a green button on the page labeled `Code`, click it, and then you will see a `Download ZIP` button.

Click it to download the source code archive of this project. After it downloads to your computer, extract it; its name may be `mcp-endpoint-server-main`.
You need to rename it to `mcp-endpoint-server`.

## Step 2: Start the program
This project is a very simple project; running it with docker is recommended. However, if you don't want to use docker, you can refer to [this page](https://github.com/xinnan-tech/mcp-endpoint-server/blob/main/README_dev.md) to run it from source. The following is the docker method

```
# Enter the project source code root directory
cd mcp-endpoint-server

# Clear the cache
docker compose -f docker-compose.yml down
docker stop mcp-endpoint-server
docker rm mcp-endpoint-server
docker rmi ghcr.nju.edu.cn/xinnan-tech/mcp-endpoint-server:latest

# Start the docker container
docker compose -f docker-compose.yml up -d
# View the logs
docker logs -f mcp-endpoint-server
```

At this point, the log will output something like the following
```
250705 INFO-=====The following addresses are the Console/single-module MCP endpoint addresses====
250705 INFO-Console MCP parameter config: http://172.22.0.2:8004/mcp_endpoint/health?key=abc
250705 INFO-Single-module deployment MCP endpoint: ws://172.22.0.2:8004/mcp_endpoint/mcp/?token=def
250705 INFO-=====Choose the one that matches your deployment; do not leak it to anyone======
```

Please copy out the two interface addresses:

Because you are deploying with docker, you must NOT use the addresses above directly!

Because you are deploying with docker, you must NOT use the addresses above directly!

Because you are deploying with docker, you must NOT use the addresses above directly!

First copy the addresses out and put them in a draft. You need to know your computer's LAN IP. For example, my computer's LAN IP is `192.168.1.25`, then
my original interface addresses
```
Console MCP parameter config: http://172.22.0.2:8004/mcp_endpoint/health?key=abc
Single-module deployment MCP endpoint: ws://172.22.0.2:8004/mcp_endpoint/mcp/?token=def
```
should be changed to
```
Console MCP parameter config: http://192.168.1.25:8004/mcp_endpoint/health?key=abc
Single-module deployment MCP endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=def
```

After making the changes, please use your browser to access the `Console MCP parameter config` directly. When the browser shows something like the following code, it means success.
```
{"result":{"status":"success","connections":{"tool_connections":0,"robot_connections":0,"total_connections":0}},"error":null,"id":null,"jsonrpc":"2.0"}
```

Please keep the two `interface addresses` above; you will need them in the next step.

# 2. How to configure the MCP endpoint in full-module deployment
First, you need to enable the MCP endpoint feature. In the Console, click `Parameter Dictionary` at the top, and in the dropdown menu click the `System Function Configuration` page. On the page, check `MCP Endpoint`, then click `Save Configuration`. On the `Role Configuration` page, click the `Edit Features` button, and you will see the `mcp endpoint` feature.

If you are doing a full-module deployment, log in to the Console with an administrator account, click `Parameter Dictionary` at the top, and select the `Parameter Management` feature.

Then search for the parameter `server.mcp_endpoint`; at this point its value should be `null`.
Click the edit button, paste the `Console MCP parameter config` obtained in the previous step into `Parameter Value`. Then save.

If it saves successfully, everything went well and you can go to the Agent to see the effect. If it doesn't save successfully, it means the Console cannot access the MCP endpoint, most likely due to a network firewall, or you did not fill in the correct LAN IP.

# 3. How to configure the MCP endpoint in single-module deployment

If you are doing a single-module deployment, find your configuration file `data/.config.yaml`.
Search for `mcp_endpoint` in the configuration file. If you can't find it, add the `mcp_endpoint` configuration. For example, this is what I did
```
server:
  websocket: ws://YOUR_IP_OR_DOMAIN:PORT/xiaozhi/v1/
  http_port: 8002
log:
  log_level: INFO

# There may be more configuration here..

mcp_endpoint: YOUR_ENDPOINT_WEBSOCKET_ADDRESS
```
At this point, paste the `Single-module deployment MCP endpoint` obtained from `How to deploy the MCP endpoint service` into `mcp_endpoint`. Something like this

```
server:
  websocket: ws://YOUR_IP_OR_DOMAIN:PORT/xiaozhi/v1/
  http_port: 8002
log:
  log_level: INFO

# There may be more configuration here

mcp_endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=def
```

After configuring, starting the single module will output logs like the following.
```
250705[__main__]-INFO-Initializing component: vad success SileroVAD
250705[__main__]-INFO-Initializing component: asr success FunASRServer
250705[__main__]-INFO-OTA interface is    http://192.168.1.25:8002/xiaozhi/ota/
250705[__main__]-INFO-Vision analysis interface is    http://192.168.1.25:8002/mcp/vision/explain
250705[__main__]-INFO-MCP endpoint is     ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
250705[__main__]-INFO-Websocket address is    ws://192.168.1.25:8000/xiaozhi/v1/
250705[__main__]-INFO-=======the above addresses are websocket protocol addresses, do not access them with a browser=======
250705[__main__]-INFO-To test websocket, please start the digital-human module and open the browser interaction test
250705[__main__]-INFO-=============================================================
```

As above, if you can output something similar with the `ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc` in `MCP endpoint is`, it means the configuration succeeded.

