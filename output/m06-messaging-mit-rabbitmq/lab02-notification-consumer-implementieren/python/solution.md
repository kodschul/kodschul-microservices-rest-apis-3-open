# Lösung (Python-Spur): Notification-Service als Consumer

## `app/models.py`

Identisch zur Lösung aus Modul 6, Lab 1 (Order-Service): `OrderEventPayload` und `OrderCreatedEvent` mit `alias_generator=to_camel`. Auch hier gilt: Die Struktur wird bewusst in beiden Codebasen dupliziert; `order-created-event.schema.json` bleibt die gemeinsame Quelle der Wahrheit.

## `app/consumer.py`

```python
import pika

from app.models import OrderCreatedEvent

EXCHANGE_NAME = "order.events"
QUEUE_NAME = "notification.order-created"
ROUTING_KEY = "order.created"


def on_message(channel, method, properties, body) -> None:
    event = OrderCreatedEvent.model_validate_json(body)
    print(
        f"Benachrichtigung: Bestellung {event.order.order_id} für "
        f"{event.order.customer_name} ({event.order.quantity}x {event.order.item_name}) "
        f"ist eingegangen."
    )
    channel.basic_ack(delivery_tag=method.delivery_tag)


def run_consumer() -> None:
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host="localhost",
            credentials=pika.PlainCredentials("kodschul", "kodschul"),
        )
    )
    channel = connection.channel()
    channel.exchange_declare(exchange=EXCHANGE_NAME, exchange_type="topic", durable=True)
    channel.queue_declare(queue=QUEUE_NAME, durable=True)
    channel.queue_bind(queue=QUEUE_NAME, exchange=EXCHANGE_NAME, routing_key=ROUTING_KEY)

    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(queue=QUEUE_NAME, on_message_callback=on_message)
    channel.start_consuming()
```

## `app/main.py` (erweitert)

```python
import threading
from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.consumer import run_consumer


@asynccontextmanager
async def lifespan(app: FastAPI):
    thread = threading.Thread(target=run_consumer, daemon=True)
    thread.start()
    yield


app = FastAPI(title="Notification Service", version="0.1.0", lifespan=lifespan)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "UP"}
```

## End-to-End-Test

1. Order-Service starten (Port 8081), Notification-Service starten (Port 8091), beide mit laufender RabbitMQ-Instanz.
2. `curl -X POST http://localhost:8081/orders -H "Content-Type: application/json" -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'`
3. In der Konsole des Notification-Service erscheint sinngemäß:

```text
Benachrichtigung: Bestellung a3f1... für Mara Beispiel (2x Kaffeemaschine) ist eingegangen.
```

## Hinweis zur Thread-Nutzung

`threading.Thread` mit `daemon=True` ist für dieses Kursbeispiel ausreichend. Für produktiven Einsatz mit hoher Last wäre ein dedizierter Worker-Prozess (statt eines Threads neben einem Webserver) die robustere Wahl.
