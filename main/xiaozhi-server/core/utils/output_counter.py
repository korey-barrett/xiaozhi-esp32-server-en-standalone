import datetime
from typing import Dict, Tuple

# Global dictionary storing the daily output character count for each device
_device_daily_output: Dict[Tuple[str, datetime.date], int] = {}
# Records the date of the last check
_last_check_date: datetime.date = None


def reset_device_output():
    """
    Reset the daily output character count for all devices
    Call this function at 00:00 every day
    """
    _device_daily_output.clear()


def get_device_output(device_id: str) -> int:
    """
    Get the device's output character count for the current day
    """
    current_date = datetime.datetime.now().date()
    return _device_daily_output.get((device_id, current_date), 0)


def add_device_output(device_id: str, char_count: int):
    """
    Increase the device's output character count
    """
    current_date = datetime.datetime.now().date()
    global _last_check_date

    # If this is the first call or the date has changed, clear the counter
    if _last_check_date is None or _last_check_date != current_date:
        _device_daily_output.clear()
        _last_check_date = current_date

    current_count = _device_daily_output.get((device_id, current_date), 0)
    _device_daily_output[(device_id, current_date)] = current_count + char_count


def check_device_output_limit(device_id: str, max_output_size: int) -> bool:
    """
    Check whether the device has exceeded the output limit
    :return: True if the limit is exceeded, False if it is not
    """
    if not device_id:
        return False
    current_output = get_device_output(device_id)
    return current_output >= max_output_size
