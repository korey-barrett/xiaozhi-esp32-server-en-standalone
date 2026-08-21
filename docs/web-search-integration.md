# Web Search Plugin Usage Guide

## Feature Overview

The web search plugin `web_search` supports real-time web search during a conversation and returns results. The plugin supports two search providers: Metaso and Tavily; users can choose either one as needed.

## API Key Application Guide

We currently support `Metaso Search` and `Tavily Search`.
- Tavily Search: 1000 free requests per month.
- Metaso Search: has relatively high-quality domestic data sources.

## API Key Application Guide

### Method 1: Use Metaso Search

- Visit the [Metaso Search API](https://metaso.cn/search-api/api-keys), register and log in to your account
- On the API key management page, click "Create a New Key"
- Copy the generated API Key (prefixed with `mk-`); this is the key information needed for configuration

### Method 2: Use Tavily Search

- Visit the [Tavily Console](https://app.tavily.com/home), register and log in to your account
- Create an API Key in the console
- Copy the generated API Key (prefixed with `tvly-`); this is the key information needed for configuration

## Configuration

### Method 1. Use Console deployment (recommended)

- Log in to the Console
- Go to the "Configure Roles" page and select the agent to configure
- Click the "Edit Functions" button, and find the "Web Search" plugin in the parameter configuration area on the right
- Check "Web Search"
- Fill in the search provider (`metaso` or `tavily`) and paste the corresponding `API Key` into the configuration item
- Save the configuration, then save the agent configuration

### Method 2. Standalone xiaozhi-server deployment

Configure it in `data/.config.yaml`:

- Fill the search provider into `provider`; the available values are `metaso` or `tavily`
- Paste the API Key you obtained into `api_key`

```yaml
plugins:
  web_search:
    provider: "metaso"
    api_key: "your API Key"
```

To customize the number of returned results and the tool description, you can additionally configure `max_results` and `description`:

```yaml
plugins:
  web_search:
    provider: "metaso"
    description: "Web search tool. Use this tool when the user clearly needs to search the web for a question."
    max_results: 5
    api_key: "your API Key"
```

Also make sure `web_search` is enabled in the `functions` list:

```yaml
plugins:
  functions:
    - web_search
```

After configuration is complete, restart the service for the changes to take effect.
