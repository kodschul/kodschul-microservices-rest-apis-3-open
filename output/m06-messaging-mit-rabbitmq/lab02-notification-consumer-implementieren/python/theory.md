---
theme: default
---

# Lab 2 (Python-Spur): Notification-Service als Consumer

## Lernziel

Nach diesem Lab konsumiert euer Notification-Service `order.created`-Ereignisse aus RabbitMQ und protokolliert eine Benachrichtigung.

## Leitfragen

1. Wie bindet man eine Queue an einen bestehenden Exchange mit `pika`?
2. Wie lässt sich ein blockierender Consumer neben einer FastAPI-Anwendung betreiben?

## Queue und Binding deklarieren

```python
channel.exchange_declare(exchange="order.events", exchange_type="topic", durable=True)
channel.queue_declare(queue="notification.order-created", durable=True)
channel.queue_bind(
    queue="notification.order-created",
    exchange="order.events",
    routing_key="order.created",
)
```

Auch hier gilt: Der Notification-Service deklariert Exchange **und** Queue erneut (idempotent), damit beide Services unabhängig von der Startreihenfolge funktionieren.

## Ein blockierender Consumer neben FastAPI

`pika.BlockingConnection` blockiert den aufrufenden Thread dauerhaft in `start_consuming()`. Damit die FastAPI-Anwendung (Health-Endpunkt) parallel weiterläuft, startet ihr den Consumer in einem **eigenen Thread**, der beim Anwendungsstart (`lifespan`) gestartet wird:

```python
import threading

def start_consumer_in_background() -> None:
    thread = threading.Thread(target=run_consumer, daemon=True)
    thread.start()
```

`daemon=True` sorgt dafür, dass der Thread beim Beenden der Anwendung nicht das Herunterfahren blockiert.

## Nachrichten verarbeiten

```python
def on_message(channel, method, properties, body):
    event = OrderCreatedEvent.model_validate_json(body)
    print(f"Benachrichtigung: Bestellung {event.order.order_id} für "
          f"{event.order.customer_name} ({event.order.quantity}x {event.order.item_name}) "
          f"ist eingegangen.")
    channel.basic_ack(delivery_tag=method.delivery_tag)
```

`basic_ack` bestätigt RabbitMQ explizit, dass die Nachricht verarbeitet wurde - ohne Bestätigung würde RabbitMQ sie erneut zustellen (siehe `messaging-contract.md`, "mindestens einmal"-Zustellung).

## Checkpoint

Ihr könnt eine Queue an einen bestehenden Exchange binden und eingehende Ereignisse in einem Hintergrund-Thread verarbeiten.
