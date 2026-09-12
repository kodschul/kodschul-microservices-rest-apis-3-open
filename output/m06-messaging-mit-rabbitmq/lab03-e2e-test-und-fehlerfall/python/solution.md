# Lösung (Python-Spur): End-to-End-Ereignisfluss testen und Fehlerfall betrachten

## Aufgabe 1: End-to-End-Bestätigung

Siehe Modul 6, Lab 2, Aufgabe 5. Erwartete Konsolenausgabe im Notification-Service:

```text
Benachrichtigung: Bestellung a3f1... für Mara Beispiel (2x Kaffeemaschine) ist eingegangen.
```

## Aufgabe 2: Verarbeitungslogik auslagern und testen

`app/consumer.py` (ergänzt):

```python
def build_notification_text(event: OrderCreatedEvent) -> str:
    return (
        f"Benachrichtigung: Bestellung {event.order.order_id} für "
        f"{event.order.customer_name} ({event.order.quantity}x {event.order.item_name}) "
        f"ist eingegangen."
    )


def on_message(channel, method, properties, body) -> None:
    event = OrderCreatedEvent.model_validate_json(body)
    print(build_notification_text(event))
    channel.basic_ack(delivery_tag=method.delivery_tag)
```

`tests/test_consumer.py`:

```python
from app.consumer import build_notification_text
from app.models import OrderCreatedEvent, OrderEventPayload


def test_build_notification_text_contains_order_details():
    event = OrderCreatedEvent(
        event_id="e1",
        occurred_at="2026-09-12T10:00:00Z",
        order=OrderEventPayload(
            order_id="a3f1...",
            customer_name="Mara Beispiel",
            item_name="Kaffeemaschine",
            quantity=2,
            status="NEW",
        ),
    )
    text = build_notification_text(event)
    assert "Mara Beispiel" in text
    assert "Kaffeemaschine" in text
```

## Aufgabe 3: Fehlerfall provozieren

```python
def on_message(channel, method, properties, body) -> None:
    event = OrderCreatedEvent.model_validate_json(body)
    if event.order.quantity > 1:
        raise ValueError("Testweise ausgelöster Verarbeitungsfehler")
    print(build_notification_text(event))
    channel.basic_ack(delivery_tag=method.delivery_tag)
```

Nach `POST /orders` mit `quantity: 2` zeigt die RabbitMQ-Management-UI (Queue `notification.order-created`) die Nachricht als "Unacked", da `basic_ack` nie erreicht wird - die Ausnahme unterbricht die Funktion vorher.

## Aufgabe 4: Zurücksetzen

Die testweise eingefügte `if`-Bedingung wird entfernt; der End-to-End-Fluss aus Aufgabe 1 funktioniert wieder wie zuvor.

## Erweiterung: Dead-Letter-Exchange (Skizze)

```python
channel.queue_declare(
    queue="notification.order-created",
    durable=True,
    arguments={
        "x-dead-letter-exchange": "order.events.dead-letter",
        "x-message-ttl": 30000,
    },
)
```

Nachrichten, die nach Ablauf der TTL nicht verarbeitet wurden, würden RabbitMQ automatisch an die angegebene Dead-Letter-Exchange weiterleiten - dort können sie manuell geprüft werden, statt die Hauptqueue dauerhaft zu blockieren. Eine vollständige Implementierung ist außerhalb des Kursumfangs.
