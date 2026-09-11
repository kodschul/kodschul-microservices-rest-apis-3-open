import json
import logging
import os
from threading import Event, Thread
import time

import pika

from app.store import EventStore


LOGGER = logging.getLogger(__name__)


class RabbitConsumer:
    def __init__(self, event_store: EventStore) -> None:
        self._event_store = event_store
        self._stop = Event()
        self._thread: Thread | None = None

    def start(self) -> None:
        self._thread = Thread(target=self._consume, name="order-event-consumer", daemon=True)
        self._thread.start()

    def stop(self) -> None:
        self._stop.set()
        if self._thread is not None:
            self._thread.join(timeout=2)

    def _consume(self) -> None:
        parameters = pika.ConnectionParameters(
            host=os.getenv("RABBITMQ_HOST", "localhost"),
            port=int(os.getenv("RABBITMQ_PORT", "5672")),
            credentials=pika.PlainCredentials(
                os.getenv("RABBITMQ_USER", "course"),
                os.getenv("RABBITMQ_PASSWORD", "course"),
            ),
            connection_attempts=3,
            retry_delay=2,
        )

        while not self._stop.is_set():
            try:
                connection = pika.BlockingConnection(parameters)
                channel = connection.channel()
                channel.queue_declare(queue="order.events", durable=True)
                for method, _, body in channel.consume("order.events", inactivity_timeout=1):
                    if self._stop.is_set():
                        break
                    if method is None:
                        continue
                    event = json.loads(body)
                    self._event_store.add(event)
                    channel.basic_ack(method.delivery_tag)
                channel.cancel()
                connection.close()
            except (pika.exceptions.AMQPError, OSError, json.JSONDecodeError) as error:
                LOGGER.warning("RabbitMQ consumer unavailable: %s", error)
                self._stop.wait(2)