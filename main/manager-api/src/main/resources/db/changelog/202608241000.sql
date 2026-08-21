-- Swap news defaults to English sources (BBC RSS) and English newsnow sources
-- Removes the default Chinese news feeds (Chinanews) and Chinese news-source list.
-- Idempotent.

-- 1. sys_params defaults -> BBC English feeds
UPDATE `sys_params`
SET `param_value` = 'http://feeds.bbci.co.uk/news/rss.xml'
WHERE `param_code` = 'plugins.get_news.default_rss_url';

UPDATE `sys_params`
SET `param_value` = '{"society":"http://feeds.bbci.co.uk/news/rss.xml","world":"http://feeds.bbci.co.uk/news/world/rss.xml","finance":"http://feeds.bbci.co.uk/news/business/rss.xml"}'
WHERE `param_code` = 'plugins.get_news.category_urls';

-- 2. get_news_from_chinanews plugin defaults -> BBC English feeds
UPDATE `ai_model_provider`
SET `fields` = JSON_ARRAY(
    JSON_OBJECT('key', 'default_rss_url', 'type', 'string', 'label', 'Default RSS Source', 'default', 'http://feeds.bbci.co.uk/news/rss.xml'),
    JSON_OBJECT('key', 'society_rss_url', 'type', 'string', 'label', 'Society News RSS Address', 'default', 'http://feeds.bbci.co.uk/news/rss.xml'),
    JSON_OBJECT('key', 'world_rss_url', 'type', 'string', 'label', 'World News RSS Address', 'default', 'http://feeds.bbci.co.uk/news/world/rss.xml'),
    JSON_OBJECT('key', 'finance_rss_url', 'type', 'string', 'label', 'Finance News RSS Address', 'default', 'http://feeds.bbci.co.uk/news/business/rss.xml')
)
WHERE `provider_code` = 'get_news_from_chinanews' AND `model_type` = 'Plugin';

-- 3. get_news_from_newsnow plugin: English default sources
-- NOTE: the aggregator host newsnow.busiyi.world is still a Chinese service; the
-- default source list is English. Full removal is a separate follow-up.
UPDATE `ai_model_provider`
SET `fields` = JSON_ARRAY(
    JSON_OBJECT('key', 'url', 'type', 'string', 'label', 'Endpoint URL', 'default', 'https://newsnow.busiyi.world/api/s?id='),
    JSON_OBJECT('key', 'news_sources', 'type', 'string', 'label', 'News source configuration', 'default', 'Hacker News;Product Hunt;Github')
)
WHERE `provider_code` = 'get_news_from_newsnow' AND `model_type` = 'Plugin';
