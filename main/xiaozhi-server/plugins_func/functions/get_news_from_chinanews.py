import random
import httpx
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
from config.logger import setup_logging
from plugins_func.register import register_function, ToolType, ActionResponse, Action
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler


TAG = __name__
logger = setup_logging()

GET_NEWS_FROM_CHINANEWS_FUNCTION_DESC = {
    "type": "function",
    "function": {
        "name": "get_news_from_chinanews",
        "description": (
            "Call when the user asks to view or listen to the news (e.g. 'give me the news' 'what's the news today'). "
            "The user can specify a news category, such as society news, technology news, international news, etc. "
            "If none is specified, society news is reported by default."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "category": {
                    "type": "string",
                    "description": "News category, e.g. society, technology, international. Optional; if not provided, the default category is used",
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


async def fetch_news_from_rss(rss_url):
    """Fetch the list of news items from an RSS source"""
    try:
        async with httpx.AsyncClient(timeout=httpx.Timeout(5.0, connect=3.0)) as client:
            response = await client.get(rss_url)

        # Parse XML
        root = ET.fromstring(response.content)

        # Find all item elements (news entries)
        news_items = []
        for item in root.findall(".//item"):
            title = (
                item.find("title").text if item.find("title") is not None else "No title"
            )
            link = item.find("link").text if item.find("link") is not None else "#"
            description = (
                item.find("description").text
                if item.find("description") is not None
                else "No description"
            )
            pubDate = (
                item.find("pubDate").text
                if item.find("pubDate") is not None
                else "Unknown time"
            )

            news_items.append(
                {
                    "title": title,
                    "link": link,
                    "description": description,
                    "pubDate": pubDate,
                }
            )

        return news_items
    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch RSS news: {e}")
        return []


async def fetch_news_detail(url):
    """Fetch the news detail page content and summarize it"""
    try:
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            response = await client.get(url)

        soup = BeautifulSoup(response.content, "html.parser")

        # Try to extract the body content (the selectors here may need adjusting according to the actual website structure)
        content_div = soup.select_one(
            ".content_desc, .content, article, .article-content"
        )
        if content_div:
            paragraphs = content_div.find_all("p")
            content = "\n".join(
                [p.get_text().strip() for p in paragraphs if p.get_text().strip()]
            )
            return content
        else:
            # If a specific content area cannot be found, try to fetch all paragraphs
            paragraphs = soup.find_all("p")
            content = "\n".join(
                [p.get_text().strip() for p in paragraphs if p.get_text().strip()]
            )
            return content[:2000]  # Limit length
    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch news details: {e}")
        return "Unable to fetch detailed content"


def map_category(category_text):
    """Map the user-provided category to a category key in the configuration file"""
    if not category_text:
        return None

    # Category mapping dictionary; currently supports society, international and finance news. See the configuration file for more types
    category_map = {
        # Society news
        "society": "society_rss_url",
        "society news": "society_rss_url",
        # International news
        "international": "world_rss_url",
        "international news": "world_rss_url",
        # Finance news
        "finance": "finance_rss_url",
        "finance news": "finance_rss_url",
        "financial": "finance_rss_url",
        "economy": "finance_rss_url",
    }

    # Convert to lowercase and strip whitespace
    normalized_category = category_text.lower().strip()

    # Return the mapping result, or the original input if there is no match
    return category_map.get(normalized_category, category_text)


@register_function(
    "get_news_from_chinanews",
    GET_NEWS_FROM_CHINANEWS_FUNCTION_DESC,
    ToolType.SYSTEM_CTL,
)
async def get_news_from_chinanews(
    conn: "ConnectionHandler",
    category: str = None,
    detail: bool = False,
    lang: str = "en_US",
):
    """Fetch the news, pick one at random to report, or fetch the details of the last news item"""
    try:
        # If detail is True, fetch the details of the last news item
        if detail:
            if (
                not hasattr(conn, "last_news_link")
                or not conn.last_news_link
                or "link" not in conn.last_news_link
            ):
                return ActionResponse(
                    Action.REQLLM,
                    "Sorry, I couldn't find the news you recently queried. Please fetch a news item first.",
                    None,
                )

            link = conn.last_news_link.get("link")
            title = conn.last_news_link.get("title", "Unknown title")

            if link == "#":
                return ActionResponse(
                    Action.REQLLM, "Sorry, this news item has no available link to fetch its details.", None
                )

            logger.bind(tag=TAG).debug(f"Fetching news details: {title}, URL={link}")

            # Fetch news details
            detail_content = await fetch_news_detail(link)

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
                f"Details: {detail_content}\n\n"
                f"(Please summarize the news content above, extract key information, and report it to the user in a natural, fluent way, "
                f"without mentioning that it is a summary, as if telling a complete news story)"
            )

            return ActionResponse(Action.REQLLM, detail_report, None)

        # Otherwise, fetch the news list and pick one at random
        # Get the RSS URL from the configuration
        rss_config = conn.config.get("plugins", {}).get("get_news_from_chinanews", {})
        default_rss_url = rss_config.get(
            "default_rss_url", "http://feeds.bbci.co.uk/news/rss.xml"
        )

        # Map the user-provided category to a category key in the configuration
        mapped_category = map_category(category)

        # If a category is provided, try to get the corresponding URL from the configuration
        rss_url = default_rss_url
        if mapped_category and mapped_category in rss_config:
            rss_url = rss_config[mapped_category]

        logger.bind(tag=TAG).info(
            f"Fetching news: original category={category}, mapped category={mapped_category}, URL={rss_url}"
        )

        # Fetch the news list
        news_items = await fetch_news_from_rss(rss_url)

        if not news_items:
            return ActionResponse(
                Action.REQLLM, "Sorry, I couldn't retrieve the news. Please try again later.", None
            )

        # Pick a news item at random
        selected_news = random.choice(news_items)

        # Save the current news link to the connection object so the details can be queried later
        if not hasattr(conn, "last_news_link"):
            conn.last_news_link = {}
        conn.last_news_link = {
            "link": selected_news.get("link", "#"),
            "title": selected_news.get("title", "Unknown title"),
        }

        # Build the news report
        news_report = (
            f"Using the data below, respond to the user's news query in {lang}:\n\n"
            f"News title: {selected_news['title']}\n"
            f"Published: {selected_news['pubDate']}\n"
            f"News content: {selected_news['description']}\n"
            f"(Please report this news item to the user in a natural, fluent way, summarizing the content as appropriate. "
            f"Just read the news directly, no extra content is needed. "
            f"If the user asks for more details, tell them they can say 'tell me more about this news' to get more content)"
        )

        return ActionResponse(Action.REQLLM, news_report, None)

    except Exception as e:
        logger.bind(tag=TAG).error(f"Error fetching news: {e}")
        return ActionResponse(
            Action.REQLLM, "Sorry, an error occurred while fetching the news. Please try again later.", None
        )
