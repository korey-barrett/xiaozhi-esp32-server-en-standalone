This document is for developers. To deploy the Xiaozhi server, [click here to view the deployment tutorial](../../README.md#%E9%83%A8%E7%BD%B2%E6%96%87%E6%A1%A3)

To view the all-in-one digital human deployment, Kiosk full-screen startup, and system environment configuration, [click here to view the all-in-one deployment guide](../../docs/all-in-one-digital-human-setup.md)

To view wake word model download, runtime configuration, and detailed usage, [click here to view the wake word documentation](../../docs/digital-human-wakeword.md)

# Project Introduction

digital-human is an independent digital human test module that provides a local test page, front-end interaction resources, a wake word runtime, and an event bridge capability for integrating and debugging the entire digital human interaction pipeline.

# Quick Start

Install dependencies:

```bash
pip install -r wakeword_runtime/requirements.txt
```

Start the module:

```bash
python start.py
```

# Access Addresses

After starting, you can access:

- Page address: http://127.0.0.1:8006/index.html
- Event bridge address: ws://127.0.0.1:8006/wakeword-ws
- Health check: http://127.0.0.1:8006/health

# Directory Description

- `start.py`: module startup entry point
- `index.html`: digital human test page entry
- `wakeword_runtime`: local wake word runtime and configuration directory
- `js`, `css`: page front-end scripts and styles
- `images`, `resources`: page resource files

# Related Documentation

- All-in-one deployment guide: for x86 device full-machine deployment, Kiosk display, and auto-start on boot configuration
	[../../docs/all-in-one-digital-human-setup.md](../../docs/all-in-one-digital-human-setup.md)
- Wake word documentation: for wake word model download, runtime configuration, and local debugging
	[../../docs/digital-human-wakeword.md](../../docs/digital-human-wakeword.md)
