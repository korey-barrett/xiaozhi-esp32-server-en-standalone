# MCP Endpoint Usage Guide

Using the mcp calculator feature open-sourced by Xia Ge as an example, this tutorial introduces how to connect your own custom mcp service to your own endpoint.

The prerequisite for this tutorial is that your `xiaozhi-server` has already enabled the MCP endpoint feature. If you haven't enabled it yet, you can enable it first according to [this tutorial](./mcp-endpoint-enable.md).

# How to add a simple mcp feature, such as a calculator feature, to an Agent

### If you are doing a full-module deployment
If you are doing a full-module deployment, you can enter the Console, go to Agent Management, click `Configure Role`, and to the right of `Intent Recognition` there is an `Edit Features` button.

Click this button. In the popup page, at the bottom, there will be `MCP Endpoint`; normally it will show the `MCP Endpoint Address` of this Agent. Next, let's extend a calculator feature based on MCP technology for this Agent.

This `MCP Endpoint Address` is very important; you will use it later.

### If you are doing a single-module deployment
If you are doing a single-module deployment and you have already configured the MCP endpoint address in the configuration file, then normally when the single-module deployment starts, it will output logs like the following.
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

As above, the `ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc` in the `MCP endpoint is` output is your `MCP Endpoint Address`.

This `MCP Endpoint Address` is very important; you will use it later.

## Step 1: Download the Xia Ge MCP calculator project code

Open the [calculator project](https://github.com/78/mcp-calculator) written by Xia Ge in your browser.

Once opened, find a green button on the page labeled `Code`, click it, and then you will see a `Download ZIP` button.

Click it to download the source code archive of this project. After it downloads to your computer, extract it; its name may be `mcp-calculatorr-main`.
You need to rename it to `mcp-calculator`. Next, use the command line to enter the project directory and install dependencies.


```bash
# Enter the project directory
cd mcp-calculator

conda remove -n mcp-calculator --all -y
conda create -n mcp-calculator python=3.10 -y
conda activate mcp-calculator

pip install -r requirements.txt
```

## Step 2: Start

Before starting, first copy the MCP endpoint address from the Agent in your Console.

For example, my Agent's mcp address is
```
ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
```

Start entering commands

```bash
export MCP_ENDPOINT=ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
```

After entering it, start the program

```bash
python mcp_pipe.py calculator.py
```

### If you are deploying on the Console
If you are deploying on the Console, after starting, go back into the Console and click to refresh the MCP connection status, and you will see the list of extended features.

### If you are doing a single-module deployment
If you are doing a single-module deployment, when the device connects, it will output logs like the following, which means success

```
250705 -INFO-Initializing MCP endpoint: wss://2662r3426b.vicp.fun/mcp_e 
250705 -INFO-Sending MCP endpoint initialization message
250705 -INFO-MCP endpoint connected successfully
250705 -INFO-MCP endpoint initialized successfully
250705 -INFO-Unified tool handler initialization complete
250705 -INFO-MCP endpoint server info: name=Calculator, version=1.9.4
250705 -INFO-Number of tools supported by the MCP endpoint: 1
250705 -INFO-All MCP endpoint tools fetched, client ready
250705 -INFO-Tool cache refreshed
250705 -INFO-Currently supported function list: [ 'get_time', 'get_lunar', 'play_music', 'get_weather', 'handle_exit_intent', 'calculator']
```
If it contains `'calculator'`, it means the device can call the calculator tool based on intent recognition.