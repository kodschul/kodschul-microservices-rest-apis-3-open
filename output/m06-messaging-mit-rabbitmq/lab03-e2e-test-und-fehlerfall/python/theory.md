---
theme: default
---

# Lab 3 (Python-Spur): End-to-End-Ereignisfluss testen und Fehlerfall betrachten

## Lernziel

Nach diesem Lab habt ihr den Ereignisfluss Order → RabbitMQ → Notification nachweislich getestet und wisst, was bei einem Verarbeitungsfehler beim Konsumenten passiert.

## Leitfragen

1. Wie testet man Consumer-Logik automatisiert, ohne eine echte RabbitMQ-Instanz im Test zu benötigen?
2. Was passiert, wenn `on_message` eine Ausnahme wirft?

## Verarbeitungslogik isoliert testen

Statt eines vollständigen Broker-Tests testet ihr die Funktion, die die eigentliche Benachrichtigung erzeugt, getrennt von der RabbitMQ-Anbindung:

```python
def build_notification_text(event: OrderCreatedEvent) -> str:
    return (
        f"Benachrichtigung: Bestellung {event.order.order_id} für "
        f"{event.order.customer_name} ({event.order.quantity}x {event.order.item_name}) "
        f"ist eingegangen."
    )
```

```python
def test_build_notification_text_contains_order_details():
    event = OrderCreatedEvent(
        event_id="e1",
        occurred_at="2026-09-12T10:00:00Z",
        order=OrderEventPayload(
            order_id="a3f1...", customer_name="Mara Beispiel",
            item_name="Kaffeemaschine", quantity=2, status="NEW",
        ),
    )
    text = build_notification_text(event)
    assert "Mara Beispiel" in text
    assert "Kaffeemaschine" in text
```

## Fehlerfall: Ausnahme in `on_message`

Wirft `on_message` eine unbehandelte Ausnahme, bevor `channel.basic_ack(...)` aufgerufen wird, bestätigt der Consumer die Nachricht **nicht**. Je nach Konfiguration bleibt sie unbestätigt in der Warteschlange (sichtbar in der Management-UI als "Unacked") oder wird nach Verbindungsabbruch erneut zugestellt - ein dauerhafter Fehler kann so zu einer "poison message" führen, die wiederholt verarbeitet wird, ohne je erfolgreich zu sein.

## Ausblick: Retry-Strategie (Erweiterung)

Eine begrenzte Anzahl an Wiederholungsversuchen mit steigender Wartezeit lässt sich in `on_message` selbst zählen (z. B. über einen Nachrichten-Header) oder über eine **Dead-Letter-Exchange**-Konfiguration in RabbitMQ abbilden, die Nachrichten nach mehreren `nack`-Aufrufen automatisch umleitet.

## Checkpoint

Ihr könnt die Benachrichtigungslogik isoliert testen und erklären, was ohne `basic_ack` bei einem dauerhaften Verarbeitungsfehler passiert.
