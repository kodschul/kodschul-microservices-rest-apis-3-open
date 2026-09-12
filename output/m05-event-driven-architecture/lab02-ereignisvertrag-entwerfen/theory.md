---
theme: default
---

# Lab 2: Ereignisvertrag entwerfen

## Lernziel

Nach diesem Lab habt ihr einen vertraglich festgelegten Aufbau für das Bestellereignis, den beide Sprachspuren in Modul 6 gleichermaßen implementieren.

## Leitfragen

1. Welche Informationen muss ein Ereignis mindestens tragen?
2. Wie werden Exchange, Routing Key und Queue in RabbitMQ benannt, damit sie eindeutig und nachvollziehbar sind?

## Aufbau eines Ereignisses

Ein Ereignis besteht typischerweise aus einem technischen Umschlag (Envelope) und den fachlichen Nutzdaten (Payload):

```json
{
  "eventId": "c9f1...",
  "eventType": "order.created",
  "occurredAt": "2026-09-12T10:15:00Z",
  "order": {
    "orderId": "a3f1...",
    "customerName": "Mara Beispiel",
    "itemName": "Kaffeemaschine",
    "quantity": 2,
    "status": "NEW"
  }
}
```

- `eventId`, `eventType`, `occurredAt` bilden den Umschlag - unabhängig von der fachlichen Nutzlast wiederverwendbar für künftige Ereignistypen.
- `order` trägt die fachlichen Daten nach dem Muster "Event-Carried State Transfer" aus Lab 1.
- Feldnamen sind konsequent `camelCase`, genau wie der REST-Vertrag aus Modul 2 - damit bleibt die Namenskonvention über REST und Messaging hinweg identisch.

## RabbitMQ-Benennungskonvention

| Element | Wert in diesem Kurs | Begründung |
| --- | --- | --- |
| Exchange | `order.events` (Typ: `topic`) | Ein Exchange pro fachlichem Ereignisstrom, erweiterbar um weitere Ereignistypen. |
| Routing Key | `order.created` | Beschreibt Ereignistyp; Topic-Exchanges erlauben späteres Filtern nach Mustern wie `order.*`. |
| Queue (Notification-Service) | `notification.order-created` | Name beginnt mit dem konsumierenden Service, endet mit dem Ereignis - eindeutig auch bei mehreren Queues. |

## Checkpoint

Ihr könnt ein Ereignis-Schema mit Umschlag und Nutzdaten entwerfen und eine nachvollziehbare Exchange-/Routing-Key-/Queue-Benennung festlegen.
