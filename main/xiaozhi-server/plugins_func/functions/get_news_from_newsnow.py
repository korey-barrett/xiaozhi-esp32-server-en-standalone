import random
import httpx
from io import BytesIO
from markitdown import MarkItDown, StreamInfo
from config.logger import setup_logging
from plugins_func.register import register_function, ToolType, ActionResponse, Action
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler


TAG = __name__
logger = setup_logging()

CHANNEL_MAP = {
    # International/English channels only (Chinese channels removed; the newsnow
    # plugin is disabled by default and its aggregator host is a Chinese service).
    "V2EX": "v2ex-share",
    "MKTNews": "mktnews-flash",
    "Solidot": "solidot",
    "Hacker News": "hackernews",
    "Product Hunt": "producthunt",
    "Github": "github-trending-today",
}

# Default news source string, used when none is specified in the configuration
# (English-language channels; the aggregator host newsnow.busiyi.world is Chinese — see checklist note)
DEFAULT_NEWS_SOURCES = "Hacker News;Product Hunt;Github"

def _get_newsnow_config(conn):
    # Get from the connection configuration
    plugins = conn.config.get("plugins", {})
    newsnow = plugins.get("get_news_from_newsnow", {})
    sources = newsnow.get("news_sources", "")
    if isinstance(sources, str) and sources.strip():
        return sources

    return ""

def get_news_sources_from_config(conn):
    """Get the news source string from the configuration"""
    try:
        result = _get_newsnow_config(conn)
        if result:
            logger.bind(tag=TAG).debug(f"Using the configured news source: {result}")
            return result

        logger.bind(tag=TAG).debug("No news source configuration found, using the default configuration")
        return DEFAULT_NEWS_SOURCES

    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to get the news source configuration: {e}; using the default configuration")
        return DEFAULT_NEWS_SOURCES


# Get the available news source names from the default configuration (retrieved dynamically at runtime by get_news_sources_from_config)
example_sources_str = DEFAULT_NEWS_SOURCES.replace(";","、")

GET_NEWS_FROM_NEWSNOW_FUNCTION_DESC = {
    "type": "function",
    "function": {
        "name": "get_news_from_newsnow",
        "description": "Call when the user asks to view or listen to the news (e.g. 'give me the news' 'what's the news today').",
        "parameters": {
            "type": "object",
            "properties": {
                "source": {
                    "type": "string",
                    "description": f"The English name of the news source, e.g. {example_sources_str}, etc. Optional; if not provided, the default news source is used",
                },
                "detail": {
                    "type": "boolean",
                    "description": "Whether to fetch the detailed content; defaults to false. If true, fetch the details of the last news item",
                },
                "lang": {
                    "type": "string",
                    "description": "The language code used by the user, e.g. en_US/zh_CN; defaults to en_US",
                },
            },
            "required": ["lang"],
        },
    },
}


async def fetch_news_from_api(conn: "ConnectionHandler", source="thepaper"):
    """Fetch the news list from the API"""
    try:
        api_url = f"https://newsnow.busiyi.world/api/s?id={source}"

        news_config = conn.config.get("plugins", {}).get("get_news_from_newsnow", {})
        if news_config.get("url"):
            api_url = news_config["url"] + source

        headers = {"User-Agent": "Mozilla/5.0"}
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            response = await client.get(api_url, headers=headers)

        data = response.json()

        if "items" in data:
            return data["items"]
        else:
            logger.bind(tag=TAG).error(f"News API response format error: {data}")
            return []

    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch news from the API: {e}")
        return []


async def fetch_news_detail(url):
    """Fetch the news detail page content and clean the HTML with MarkItDown"""
    try:
        headers = {"User-Agent": "Mozilla/5.0"}
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            response = await client.get(url, headers=headers)

        # Use MarkItDown to clean the HTML content
        md = MarkItDown(enable_plugins=False)
        result = md.convert_stream(
            BytesIO(response.content),
            stream_info=StreamInfo(
                mimetype="text/html",
                extension=".html",
                charset=response.encoding or "utf-8",
            ),
        )

        # Get the cleaned text content
        clean_text = result.text_content

        # If the cleaned content is empty, return a notice
        if not clean_text or len(clean_text.strip()) == 0:
            logger.bind(tag=TAG).warning(f"Cleaned news content is empty: {url}")
            return "Unable to parse the news details; the website structure may be unusual or the content may be restricted."

        return clean_text
    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch news details: {e}")
        return "Unable to fetch detailed content"


@register_function(
    "get_news_from_newsnow",
    GET_NEWS_FROM_NEWSNOW_FUNCTION_DESC,
    ToolType.SYSTEM_CTL,
)
async def get_news_from_newsnow(
    conn: "ConnectionHandler",
    source: str = "Hacker News",
    detail: bool = False,
    lang: str = "en_US",
):
    """Fetch the news, pick one at random to report, or fetch the details of the last news item"""
    try:
        # Get the currently configured news source
        news_sources = get_news_sources_from_config(conn)

        # If detail is True, fetch the details of the last news item
        detail = str(detail).lower() == "true"
        if detail:
            if (
                not hasattr(conn, "last_newsnow_link")
                or not conn.last_newsnow_link
                or "url" not in conn.last_newsnow_link
            ):
                return ActionResponse(
                    Action.REQLLM,
                    "Sorry, I couldn't find the news you recently queried. Please fetch a news item first.",
                    None,
                )

            url = conn.last_newsnow_link.get("url")
            title = conn.last_newsnow_link.get("title", "Unknown title")
            source_id = conn.last_newsnow_link.get("source_id", "thepaper")
            source_name = CHANNEL_MAP.get(source_id, "Unknown source")

            if not url or url == "#":
                return ActionResponse(
                    Action.REQLLM, "Sorry, this news item has no available link to fetch its details.", None
                )

            logger.bind(tag=TAG).debug(
                f"Fetching news details: {title}, source: {source_name}, URL={url}"
            )

            # Fetch news details
            detail_content = await fetch_news_detail(url)

            if not detail_content or detail_content == "Unable to fetch detailed content":
                return ActionResponse(
                    Action.REQLLM,
                    f"Sorry, I couldn't fetch the details of \"{title}\"; the link may have expired or the website structure may have changed.",
                    None,
                )

            # Build the detail report
            detail_report = (
                f"Using the data below, respond to the user's news detail query in {lang}:\n\n"
                f"News title: {title}\n"
                # f"News source: {source_name}\n"
                f"Details: {detail_content}\n\n"
                f"(Please summarize the news content above, extract key information, and report it to the user in a natural, fluent way, "
                f"without mentioning that it is a summary, as if telling a complete news story)"
            )

            return ActionResponse(Action.REQLLM, detail_report, None)

        # Otherwise, fetch the news list and pick one at random
        # Convert the Chinese name to an English ID
        english_source_id = None

        # Check whether the input Chinese name is among the configured news sources
        news_sources_list = [
            name.strip() for name in news_sources.split(";") if name.strip()
        ]
        if source in news_sources_list:
            # If the input Chinese name is among the configured news sources, look up the corresponding English ID in CHANNEL_MAP
            english_source_id = CHANNEL_MAP.get(source)

        # If no matching English ID is found, use the default source
        if not english_source_id:
            logger.bind(tag=TAG).warning(f"Invalid news source: {source}; using the default source Hacker News")
            english_source_id = "hackernews"
            source = "Hacker News"

        logger.bind(tag=TAG).info(f"Fetching news: source={source}({english_source_id})")

        # Fetch the news list
        news_items = await fetch_news_from_api(conn, english_source_id)

        if not news_items:
            return ActionResponse(
                Action.REQLLM,
                f"Sorry, I couldn't retrieve news from {source}. Please try again later or try another news source.",
                None,
            )

        # Pick a news item at random
        selected_news = random.choice(news_items)

        # Save the current news link to the connection object so the details can be queried later
        if not hasattr(conn, "last_newsnow_link"):
            conn.last_newsnow_link = {}
        conn.last_newsnow_link = {
            "url": selected_news.get("url", "#"),
            "title": selected_news.get("title", "Unknown title"),
            "source_id": english_source_id,
        }

        # Build the news report
        news_report = (
            f"Using the data below, respond to the user's news query in {lang}:\n\n"
            f"News title: {selected_news['title']}\n"
            # f"News source: {source}\n"
            f"(Please report this news headline to the user in a natural, fluent way, "
            f"and tell them they can request the detailed content, which will then be fetched.)"
        )

        return ActionResponse(Action.REQLLM, news_report, None)

    except Exception as e:
        logger.bind(tag=TAG).error(f"Error fetching news: {e}")
        return ActionResponse(
            Action.REQLLM, "Sorry, an error occurred while fetching the news. Please try again later.", None
        )
