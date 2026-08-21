#!/usr/bin/env python3
"""Capture serial boot output from an ESP32 (e.g. the 6-digit setup code).

Usage:
    python capture_serial.py COM4 [duration_seconds] [baud]

Defaults: duration = 15s, baud = 115200.
Run `esptool --port COM<port> read_mac` first to reset the board, then this
script captures the boot log that follows.
"""
import sys
import time
import serial

# Write raw UTF-8 bytes to stdout so non-ASCII boot-log characters don't crash
# on Windows consoles (cp1252). Falls back to text write if buffer is absent.
def write_out(data: bytes) -> None:
    try:
        sys.stdout.buffer.write(data)
        sys.stdout.buffer.flush()
    except (AttributeError, BrokenPipeError):
        sys.stdout.write(data.decode("utf-8", errors="replace"))
        sys.stdout.flush()

port = sys.argv[1] if len(sys.argv) > 1 else "COM4"
duration = float(sys.argv[2]) if len(sys.argv) > 2 else 15.0
baud = int(sys.argv[3]) if len(sys.argv) > 3 else 115200

print(f"Opening {port} @ {baud} baud, capturing {duration}s of boot output...")
ser = serial.Serial(port, baud, timeout=0.2)
start = time.time()
try:
    while time.time() - start < duration:
        data = ser.read(4096)
        if data:
            write_out(data)
finally:
    ser.close()
print("\n--- capture complete ---")
