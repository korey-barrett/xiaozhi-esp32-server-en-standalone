"""
Cache strategy and data structure definitions
"""

import time
from enum import Enum
from typing import Any, Optional
from dataclasses import dataclass


class CacheStrategy(Enum):
    """Cache strategy enum"""

    TTL = "ttl"  # Time-based expiry
    LRU = "lru"  # Least recently used
    FIXED_SIZE = "fixed_size"  # Fixed size
    TTL_LRU = "ttl_lru"  # TTL + LRU mixed strategy


@dataclass
class CacheEntry:
    """Cache entry data structure"""

    value: Any
    timestamp: float
    ttl: Optional[float] = None  # Time to live (seconds)
    access_count: int = 0
    last_access: float = None

    def __post_init__(self):
        if self.last_access is None:
            self.last_access = self.timestamp

    def is_expired(self) -> bool:
        """Check whether it is expired"""
        if self.ttl is None:
            return False
        return time.time() - self.timestamp > self.ttl

    def touch(self):
        """Update the access time and count"""
        self.last_access = time.time()
        self.access_count += 1
