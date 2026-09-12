---
theme: default
---

# Lab 1 (Python-Spur): RabbitMQ einrichten und Ereignis publizieren

## Lernziel

Nach diesem Lab publiziert euer Order-Service bei jeder neuen Bestellung ein `order.created`-Ereignis gemäß `output/project/contracts/messaging-contract.md` an RabbitMQ.

## Leitfragen

1. Wie verbindet sich Python mit RabbitMQ?
2. Wie wird ein Exchange deklariert und eine Nachricht darauf veröffentlicht?

## RabbitMQ lokal starten

```bash
docker compose -f output/project/starter/rabbitmq-compose.yml up -d
```

Management-UI: `http://localhost:15672` (Login `kodschul`/`kodschul`).

## `pika`: Verbindung und Exchange

```python
import pika

connection = pika.BlockingConnection(
    pika.ConnectionParameters(
        host="localhost",
        credentials=pika.PlainCredentials("kodschul", "kodschul"),
    )
)
channel = connection.channel()
channel.exchange_declare(exchange="order.events", exchange_type="topic", durable=True)
```

`exchange_declare` ist **idempotent**: Wird der Exchange bereits mit denselben Eigenschaften erzeugt, passiert nichts Schädliches, wenn er schon existiert.

## Ereignis-Modell mit `camelCase`-Alias

Wie in Modul 2 (siehe `NewOrderRequest`/`Order`) verwendet ihr `alias_generator=to_camel`, damit das veröffentlichte JSON exakt dem Schema `order-created-event.schema.json` entspricht:

```python
from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel

class OrderEventPayload(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    order_id: str
    customer_name: str
    item_name: str
    quantity: int
    status: str

class OrderCreatedEvent(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    event_id: str
    event_type: str = "order.created"
    occurred_at: str
    order: OrderEventPayload
```

## Ereignis publizieren

```python
channel.basic_publish(
    exchange="order.events",
    routing_key="order.created",
    body=event.model_dump_json(by_alias=True),
    properties=pika.BasicProperties(content_type="application/json"),
)
```

`model_dump_json(by_alias=True)` erzeugt das JSON mit den `camelCase`-Aliasen statt der internen `snake_case`-Attributnamen.

## Checkpoint

Ihr könnt RabbitMQ lokal starten, einen Exchange deklarieren und ein Ereignis publizieren, das in der Management-UI unter "Exchanges" sichtbar wird.
