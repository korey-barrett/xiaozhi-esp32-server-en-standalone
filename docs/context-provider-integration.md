# Context Source Usage Tutorial

## Overview

A `context source` adds a [data source] to the context of Xiaozhi's system prompt.

At the moment Xiaozhi wakes up, the `context source` fetches data from external systems and dynamically injects it into the large model's system prompt.
This lets Xiaozhi perceive the state of something in the world at the moment of waking.

It is fundamentally different from MCP and memory: `context source` forces Xiaozhi to perceive world data; `memory (Mem)` tells it what was discussed earlier; `MCP (function call)` is used when a specific capability/knowledge needs to be invoked.

With this feature, at the very instant Xiaozhi wakes up, it can "sense":
- Human health sensor status (body temperature, blood pressure, blood oxygen status, etc.)
- Real-time data from business systems (server load, to-do data, stock information, etc.)
- Any text information retrievable via an HTTP API

**Note**: This feature simply helps Xiaozhi perceive the state of things at the moment of waking. If you want Xiaozhi to obtain the state of things in real time after waking, it is recommended to combine this feature with MCP tool calls.

## How It Works

1. **Configure sources**: The user configures one or more HTTP API addresses.
2. **Trigger the request**: When the system builds the prompt, if it finds the `{{ dynamic_context }}` placeholder in the template, it requests all configured APIs.
3. **Automatic injection**: The system automatically formats the API-returned data as a Markdown list and replaces the `{{ dynamic_context }}` placeholder.

## API Specification

For Xiaozhi to correctly parse the data, your API needs to meet the following specification:

- **Request method**: `GET`
- **Request header**: The system automatically adds the `device-id` field to the Request Header.
- **Response format**: Must return JSON format and include the `code` and `data` fields.

### Response Examples

**Case 1: Returning key-value pairs**
```json
{
  "code": 0,
  "msg": "success",
  "data": {
    "Living room temperature": "26℃",
    "Living room humidity": "45%",
    "Front door status": "Closed"
  }
}
```
*Injection effect:*
```markdown
<context>
- **Living room temperature:** 26℃
- **Living room humidity:** 45%
- **Front door status:** Closed
</context>
```

**Case 2: Returning a list**
```json
{
  "code": 0,
  "data": [
    "You have 10 pending tasks",
    "The car is currently traveling at 100 km/h"
  ]
}
```
*Injection effect:*
```markdown
<context>
- You have 10 pending tasks
- The car is currently traveling at 100 km/h
</context>
```

## Configuration Guide

### Method 1: Configure in the Console (full-module deployment)

1. Log in to the Console and go to the **Role Configuration** page.
2. Find the **Context Source** configuration item (click the "Edit Source" button).
3. Click **Add** and enter your API address.
4. If the API requires authentication, you can add `Authorization` or other headers in the **Request Headers** section.
5. Save the configuration.

### Method 2: Configure via the configuration file (single-module deployment)

Edit the `xiaozhi-server/data/.config.yaml` file and add the `context_providers` configuration section:

```yaml
# Context source configuration
context_providers:
  - url: "http://api.example.com/data"
    headers:
      Authorization: "Bearer your-token"
  - url: "http://another-api.com/data"
```

## Enabling the Feature

By default, the `{{ dynamic_context }}` placeholder is already preset in the system's prompt template file (`data/.agent-base-prompt.txt`), so you do not need to add it manually.

**Example:**

```markdown
<context>
[Important! The following information is provided in real time. Use it directly without calling a tool to look it up:]
- **Device ID:** {{device_id}}
- **Current time:** {{current_time}}
...
{{ dynamic_context }}
</context>
```

**Note**: If you do not need this feature, you can choose **not to configure any context source**, or you can **remove** the `{{ dynamic_context }}` placeholder from the prompt template file.

## Appendix: Mock Test Server Example

For your convenience in testing and development, we provide a simple Python Mock Server script. You can run this script to simulate the API endpoints locally.

**mock_api_server.py**

```python
import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs

# Set the port number
PORT = 8081

class MockRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Parse the path and query parameters
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        query = parse_qs(parsed_path.query)

        response_data = {}
        status_code = 200

        print(f"Request received: {path}, params: {query}")

        # Case 1: Simulate health data (returns a Dict)
        # Path parameter style: /health
        # device_id is taken from the Header
        if path == "/health":
            device_id = self.headers.get("device-id", "unknown_device")
            print(f"device_id: {device_id}")
            response_data = {
                "code": 0,
                "msg": "success",
                "data": {
                    "Test device ID": device_id,
                    "Heart rate": "80 bpm",
                    "Blood pressure": "120/80 mmHg",
                    "Status": "Good"
                }
            }

        # Case 2: Simulate a news list (returns a List)
        # No parameters: /news/list
        elif path == "/news/list":
            response_data = {
                "code": 0,
                "msg": "success",
                "data": [
                    "Headlines: Python 3.14 released",
                    "Tech news: AI assistants are changing lives",
                    "Local news: heavy rain tomorrow, remember to bring an umbrella"
                ]
            }

        # Case 3: Simulate a weather briefing (returns a String)
        # No parameters: /weather/simple
        elif path == "/weather/simple":
            response_data = {
                "code": 0,
                "msg": "success",
                "data": "Sunny turning cloudy today, 20-25 degrees, good air quality, suitable for going out."
            }

        # Case 4: Simulate device details (Query parameter style)
        # Parameter style: /device/info
        # device_id is taken from the Header
        elif path == "/device/info":
            device_id = self.headers.get("device-id", "unknown_device")
            response_data = {
                "code": 0,
                "msg": "success",
                "data": {
                    "Query method": "Header parameter",
                    "Device ID": device_id,
                    "Battery": "85%",
                    "Firmware": "v2.0.1"
                }
            }
        
        # Case 5: 404 Not Found
        else:
            status_code = 404
            response_data = {"error": "Endpoint not found"}

        # Send the response
        self.send_response(status_code)
        self.send_header('Content-type', 'application/json; charset=utf-8')
        self.end_headers()
        self.wfile.write(json.dumps(response_data, ensure_ascii=False).encode('utf-8'))

# Start the service
# Allow address reuse to avoid errors on quick restarts
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("", PORT), MockRequestHandler) as httpd:
    print(f"==================================================")
    print(f"Mock API Server started: http://localhost:{PORT}")
    print(f"Available endpoints:")
    print(f"1. [dict] http://localhost:{PORT}/health")
    print(f"2. [list] http://localhost:{PORT}/news/list")
    print(f"3. [text] http://localhost:{PORT}/weather/simple")
    print(f"4. [params] http://localhost:{PORT}/device/info")
    print(f"==================================================")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped")
```
