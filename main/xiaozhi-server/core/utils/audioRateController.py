import time
import asyncio
from collections import deque
from config.logger import setup_logging

TAG = __name__
logger = setup_logging()


class AudioRateController:
    """
    Audio rate controller - precisely controls audio sending by 60ms frame duration
    Resolves the cumulative time drift problem under high concurrency
    """

    def __init__(self, frame_duration=60):
        """
        Args:
            frame_duration: Single audio frame duration (milliseconds), default 60ms
        """
        self.frame_duration = frame_duration
        self.queue = deque()
        self.play_position = 0  # Virtual playback position (milliseconds)
        self.start_timestamp = None  # Start timestamp (read-only, not modified)
        self.pending_send_task = None
        self.logger = logger
        self.queue_empty_event = asyncio.Event()  # Queue empty event
        self.queue_empty_event.set()  # Initial empty state
        self.queue_has_data_event = asyncio.Event()  # Queue has data event
        self._last_queue_empty_time = 0  # Time of last queue empty (seconds)

    def reset(self):
        """Reset the controller state"""
        if self.pending_send_task and not self.pending_send_task.done():
            self.pending_send_task.cancel()
            # After cancel, the task is cleaned up on the next event loop iteration; no need to block waiting

        self.queue.clear()
        self.play_position = 0
        self.start_timestamp = None  # Set by the first audio packet
        self._last_queue_empty_time = 0  # Reset time
        # Related event handling
        self.queue_empty_event.set()
        self.queue_has_data_event.clear()

    def add_audio(self, opus_packet):
        """Add an audio packet to the queue"""
        # If the queue was previously empty, adjust the timestamp to keep playback time continuous
        # This way, audio added while waiting for a tool call will not play early
        # If the interval is very short (<1 frame), it is normal streaming and no reset is needed
        if len(self.queue) == 0 and self.play_position > 0:
            elapsed_since_empty = (time.monotonic() - self._last_queue_empty_time) * 1000
            # Only treat as a real "pause/resume" if the interval exceeds one frame duration
            if elapsed_since_empty >= self.frame_duration:
                self.start_timestamp = time.monotonic() - (self.play_position / 1000)
                self.logger.bind(tag=TAG).debug(
                    f"Queue resumed from empty, resetting timestamp, current playback position: {self.play_position}ms, interval: {elapsed_since_empty:.0f}ms"
                )

        self.queue.append(("audio", opus_packet))
        # Related event handling
        self.queue_empty_event.clear()
        self.queue_has_data_event.set()

    def add_message(self, message_callback):
        """
        Add a message to the queue (sent immediately, does not consume playback time)

        Args:
            message_callback: Message send callback function async def()
        """
        if len(self.queue) == 0 and self.play_position > 0:
            elapsed_since_empty = (time.monotonic() - self._last_queue_empty_time) * 1000
            if elapsed_since_empty >= self.frame_duration:
                self.start_timestamp = time.monotonic() - (self.play_position / 1000)
                self.logger.bind(tag=TAG).debug(
                    f"Queue resumed from empty, resetting timestamp, current playback position: {self.play_position}ms, interval: {elapsed_since_empty:.0f}ms"
                )

        self.queue.append(("message", message_callback))
        # Related event handling
        self.queue_empty_event.clear()
        self.queue_has_data_event.set()

    def _get_elapsed_ms(self):
        """Get the elapsed time (milliseconds)"""
        if self.start_timestamp is None:
            return 0
        return (time.monotonic() - self.start_timestamp) * 1000

    async def check_queue(self, send_audio_callback):
        """
        Check the queue and send audio/messages on time

        Args:
            send_audio_callback: Audio send callback function async def(opus_packet)
        """
        while self.queue:
            item = self.queue[0]
            item_type = item[0]

            if item_type == "message":
                # Message type: send immediately, does not consume playback time
                _, message_callback = item
                self.queue.popleft()
                try:
                    await message_callback()
                except Exception as e:
                    self.logger.bind(tag=TAG).error(f"Failed to send message: {e}")
                    raise

            elif item_type == "audio":
                if self.start_timestamp is None:
                    self.start_timestamp = time.monotonic()

                _, opus_packet = item

                # Loop and wait until the time arrives
                while True:
                    # Calculate the time difference
                    elapsed_ms = self._get_elapsed_ms()
                    output_ms = self.play_position

                    if elapsed_ms < output_ms:
                        # Not yet time to send, calculate the wait duration
                        wait_ms = output_ms - elapsed_ms

                        # Wait then re-check (allows interruption)
                        try:
                            await asyncio.sleep(wait_ms / 1000)
                        except asyncio.CancelledError:
                            self.logger.bind(tag=TAG).debug("Audio send task was cancelled")
                            raise
                        # After waiting, re-check the time (loop back to while True)
                    else:
                        # Time has arrived, break out of the wait loop
                        break

                # Time has arrived, remove from the queue and send
                self.queue.popleft()
                self.play_position += self.frame_duration
                try:
                    await send_audio_callback(opus_packet)
                except Exception as e:
                    self.logger.bind(tag=TAG).error(f"Failed to send audio: {e}")
                    raise

        # Clear events after the queue is processed
        self.queue_empty_event.set()
        self.queue_has_data_event.clear()
        self._last_queue_empty_time = time.monotonic()  # Record the queue empty time

    def start_sending(self, send_audio_callback):
        """
        Start the asynchronous send task

        Args:
            send_audio_callback: Audio send callback function

        Returns:
            asyncio.Task: The send task
        """

        async def _send_loop():
            try:
                while True:
                    # Wait for the queue data event; avoid polling which consumes CPU
                    await self.queue_has_data_event.wait()

                    await self.check_queue(send_audio_callback)
            except asyncio.CancelledError:
                self.logger.bind(tag=TAG).debug("Audio send loop has stopped")
            except Exception as e:
                self.logger.bind(tag=TAG).error(f"Audio send loop exception: {e}")

        self.pending_send_task = asyncio.create_task(_send_loop())
        return self.pending_send_task

    def stop_sending(self):
        """Stop the send task"""
        if self.pending_send_task and not self.pending_send_task.done():
            self.pending_send_task.cancel()
            self.logger.bind(tag=TAG).debug("Audio send task cancelled")
