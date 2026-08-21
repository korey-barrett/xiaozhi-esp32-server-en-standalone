# Weather Plugin Usage Guide

## Overview

The weather plugin `get_weather` is one of the core features of the Xiaozhi ESP32 voice assistant. It supports querying weather information for locations across the country via voice. The plugin is built on the QWeather API and provides real-time weather and 7-day weather forecast functionality.

## API Key Application Guide

### 1. Register a QWeather account

1. Visit the [QWeather Console](https://console.qweather.com/)
2. Register an account and complete email verification
3. Log in to the console

### 2. Create an application to obtain an API Key

1. After entering the console, click ["Project Management"](https://console.qweather.com/project?lang=zh) on the right → "Create Project"
2. Fill in the project information:
   - **Project Name**: e.g. "Xiaozhi Voice Assistant"
3. Click Save
4. After the project is created, click "Create Credential" within the project
5. Fill in the credential information:
    - **Credential Name**: e.g. "Xiaozhi Voice Assistant"
    - **Authentication Method**: select "API Key"
6. Click Save
7. Copy the `API Key` from the credential; this is the first key configuration item

### 3. Obtain the API Host

1. In the console, click ["Settings"](https://console.qweather.com/setting?lang=zh) → "API Host"
2. Check the dedicated `API Host` address assigned to you; this is the second key configuration item

The steps above yield two important configuration items: `API Key` and `API Host`.

## Configuration (choose one)

### Method 1. If you deployed with the Console (recommended)

1. Log in to the Console
2. Go to the "Role Configuration" page
3. Select the agent to configure
4. Click the "Edit Functions" button
5. Find the "Weather Query" plugin in the parameter configuration area on the right
6. Check "Weather Query"
7. Paste the first key configuration you copied, `API Key`, into `Weather Plugin API Key`
8. Paste the second key configuration you copied, `API Host`, into `Developer API Host`
9. Save the configuration, then save the agent configuration

### Method 2. If you are deploying the standalone xiaozhi-server module

Configure it in `data/.config.yaml`:

1. Paste the first key configuration you copied, `API Key`, into `api_key`
2. Paste the second key configuration you copied, `API Host`, into `api_host`
3. Fill in your city in `default_location`, e.g. `广州`

```yaml
plugins:
  get_weather:
    api_key: "your QWeather API key"
    api_host: "your QWeather API host address"
    default_location: "your default query city"
```

