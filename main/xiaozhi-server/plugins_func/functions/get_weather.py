import httpx
from config.logger import setup_logging
from plugins_func.register import register_function, ToolType, ActionResponse, Action
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler

TAG = __name__
logger = setup_logging()

# Open-Meteo API endpoints (free, no API key, non-Chinese service)
GEOCODE_URL = "https://geocoding-api.open-meteo.com/v1/search"
FORECAST_URL = "https://api.open-meteo.com/v1/forecast"

GET_WEATHER_FUNCTION_DESC = {
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": (
            "Get the weather for a location; the user should provide a place, "
            "e.g. if the user says 'weather in London', the parameter is: London. "
            "If no location is provided, the configured default city is used. "
            "Important: the local 7-day weather forecast is already provided in the "
            "context; do NOT call this tool unless the user specifies another city."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "Location name, e.g. London. Optional; if not provided, omit it",
                },
                "lang": {
                    "type": "string",
                    "description": "Language code used by the user, e.g. en_US/zh_CN; defaults to en_US",
                },
            },
            "required": ["lang"],
        },
    },
}

# WMO weather interpretation codes -> English description
WMO = {
    0: "Clear sky",
    1: "Mainly clear",
    2: "Partly cloudy",
    3: "Overcast",
    45: "Fog",
    48: "Depositing rime fog",
    51: "Light drizzle",
    53: "Drizzle",
    55: "Dense drizzle",
    56: "Light freezing drizzle",
    57: "Dense freezing drizzle",
    61: "Slight rain",
    63: "Moderate rain",
    65: "Heavy rain",
    66: "Light freezing rain",
    67: "Heavy freezing rain",
    71: "Slight snow fall",
    73: "Moderate snow fall",
    75: "Heavy snow fall",
    77: "Snow grains",
    80: "Slight rain showers",
    81: "Moderate rain showers",
    82: "Violent rain showers",
    85: "Slight snow showers",
    86: "Heavy snow showers",
    95: "Thunderstorm",
    96: "Thunderstorm with slight hail",
    99: "Thunderstorm with heavy hail",
}


def _wmo_desc(code):
    return WMO.get(code, "Unknown")


async def geocode(location):
    """Resolve a place name to lat/lon via Open-Meteo geocoding (free, no key)."""
    params = {"name": location, "count": 1, "language": "en", "format": "json"}
    async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
        response = await client.get(GEOCODE_URL, params=params)
    data = response.json()
    results = data.get("results") or []
    if results:
        r = results[0]
        return {
            "name": r.get("name"),
            "country": r.get("country"),
            "admin1": r.get("admin1"),
            "latitude": r.get("latitude"),
            "longitude": r.get("longitude"),
        }
    return None


async def fetch_forecast(lat, lon):
    params = {
        "latitude": lat,
        "longitude": lon,
        "current": "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m",
        "daily": "weather_code,temperature_2m_max,temperature_2m_min",
        "timezone": "auto",
        "forecast_days": 7,
    }
    async with httpx.AsyncClient(timeout=httpx.Timeout(15.0, connect=3.0)) as client:
        response = await client.get(FORECAST_URL, params=params)
    return response.json() if response.status_code == 200 else None


def build_report(geo, data):
    city = geo.get("name", "Unknown")
    if geo.get("admin1"):
        city = f"{city}, {geo['admin1']}"

    lines = [f"The location you queried is: {city}\n"]

    current = data.get("current") or {}
    if current:
        temp = current.get("temperature_2m")
        feel = current.get("apparent_temperature")
        hum = current.get("relative_humidity_2m")
        wind = current.get("wind_speed_10m")
        desc = _wmo(current.get("weather_code"))
        lines.append(
            f"Current weather: {desc}, temperature {temp}°C "
            f"(feels like {feel}°C), humidity {hum}%, wind {wind} km/h"
        )

    daily = data.get("daily") or {}
    dates = daily.get("time") or []
    codes = daily.get("weather_code") or []
    highs = daily.get("temperature_2m_max") or []
    lows = daily.get("temperature_2m_min") or []
    if dates:
        lines.append("\n7-day forecast:")
        for i, d in enumerate(dates):
            w = _wmo(codes[i]) if i < len(codes) else "Unknown"
            hi = highs[i] if i < len(highs) else "?"
            lo = lows[i] if i < len(lows) else "?"
            lines.append(f"{d}: {w}, temperature {lo}~{hi}°C")

    lines.append("\n(If you need the specific weather for a certain day, please tell me the date)")
    return "\n".join(lines)


@register_function("get_weather", GET_WEATHER_FUNCTION_DESC, ToolType.SYSTEM_CTL)
async def get_weather(conn: "ConnectionHandler", location: str = None, lang: str = "en_US"):
    from core.utils.cache.manager import cache_manager, CacheType

    weather_config = conn.config.get("plugins", {}).get("get_weather", {})
    default_location = weather_config.get("default_location", "")

    if not location:
        location = default_location

    if not location:
        return ActionResponse(
            Action.REQLLM,
            "Please tell me which city's weather you would like to know.",
            None,
        )

    weather_cache_key = f"full_weather_{location}_{lang}"
    cached_weather_report = cache_manager.get(CacheType.WEATHER, weather_cache_key)
    if cached_weather_report:
        return ActionResponse(Action.REQLLM, cached_weather_report, None)

    geo = await geocode(location)
    if not geo:
        return ActionResponse(
            Action.REQLLM,
            f"No matching city found: {location}. Please confirm the location is correct",
            None,
        )

    weather = await fetch_forecast(geo["latitude"], geo["longitude"])
    if not weather:
        return ActionResponse(Action.REQLLM, None, "Request failed")

    weather_report = build_report(geo, weather)

    cache_manager.set(CacheType.WEATHER, weather_cache_key, weather_report)

    return ActionResponse(Action.REQLLM, weather_report, None)
