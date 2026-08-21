# get_news_from_newsnow Plugin News Source Configuration Guide

## Overview

The `get_news_from_newsnow` plugin now supports dynamically configuring news sources through the Web admin interface, without modifying code. Users can configure different news sources for each agent in the Console.

## Configuration Methods

### 1. Configure via the Web admin interface (Recommended)

1. Log in to the Console
2. Go to the "Role Configuration" page
3. Select the agent to configure
4. Click the "Edit Functions" button
5. In the parameter configuration area on the right, find the "newsnow news aggregation" plugin
6. In the "News Source Configuration" field, enter semicolon-separated Chinese names

### 2. Config file method

Configure in `config.yaml`:

```yaml
plugins:
  get_news_from_newsnow:
    url: "https://newsnow.busiyi.world/api/s?id="
    news_sources: "澎湃新闻;百度热搜;财联社;微博;抖音"
```

## News Source Configuration Format

News source configuration uses semicolon-separated Chinese names, in the format:

```
ChineseName1;ChineseName2;ChineseName3
```

### Configuration Example

```
澎湃新闻;百度热搜;财联社;微博;抖音;知乎;36氪
```

## Supported News Sources

The plugin supports the following Chinese news source names:

- 澎湃新闻
- 百度热搜
- 财联社
- 微博
- 抖音
- 知乎
- 36氪
- 华尔街见闻
- IT之家
- 今日头条
- 虎扑
- 哔哩哔哩
- 快手
- 雪球
- 格隆汇
- 法布财经
- 金十数据
- 牛客
- 少数派
- 稀土掘金
- 凤凰网
- 虫部落
- 联合早报
- 酷安
- 远景论坛
- 参考消息
- 卫星通讯社
- 百度贴吧
- 靠谱新闻
- And more...

## Default Configuration

If no news sources are configured, the plugin will use the following default configuration:

```
澎湃新闻;百度热搜;财联社
```

## Usage Instructions

1. **Configure news sources**: Set the Chinese names of the news sources in the Web interface or config file, separated by semicolons
2. **Invoke the plugin**: The user can say "broadcast news" or "get news"
3. **Specify a news source**: The user can say "broadcast Penpai News" or "get Baidu Hot Search"
4. **Get details**: The user can say "introduce this news in detail"

## How It Works

1. The plugin accepts a Chinese name as a parameter (e.g., "澎湃新闻")
2. Based on the configured news source list, it converts the Chinese name to the corresponding English ID (e.g., "thepaper")
3. It uses the English ID to call the API and fetch news data
4. It returns the news content to the user

## Notes

1. The configured Chinese name must exactly match the name defined in CHANNEL_MAP
2. After changing the configuration, restart the service or reload the configuration
3. If the configured news source is invalid, the plugin will automatically use the default news source
4. Separate multiple news sources with an English semicolon (;), not a Chinese semicolon (；)