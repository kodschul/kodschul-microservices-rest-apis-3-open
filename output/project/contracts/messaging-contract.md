# Messaging-Vertrag: Bestellereignisse

Gilt sprachneutral für die Java- und die Python-Spur (analog zu `order-api.yaml` für REST).

## RabbitMQ-Konvention

| Element | Wert | Typ/Hinweis |
| --- | --- | --- |
| Exchange | `order.events` | Typ `topic` |
| Routing Key | `order.created` | ein Routing Key je Ereignistyp |
| Queue (Notification-Service) | `notification.order-created` | an `order.events` mit Routing Key `order.created` gebunden |

## Nachrichtenformat

- Content-Type: `application/json`
- Payload-Schema: [`order-created-event.schema.json`](./order-created-event.schema.json)
- Feldnamen konsequent `camelCase`, identisch zur Namenskonvention aus `order-api.yaml`.

## Zustellgarantie (Planungsannahme für diesen Kurs)

RabbitMQ liefert Nachrichten standardmäßig **mindestens einmal** (at-least-once) aus. Konsumenten müssen daher mit doppelt zugestellten Nachrichten umgehen können (siehe Modul 6, Fehlerfallbetrachtung). Exactly-once-Zustellung ist außerhalb des Kursumfangs.
