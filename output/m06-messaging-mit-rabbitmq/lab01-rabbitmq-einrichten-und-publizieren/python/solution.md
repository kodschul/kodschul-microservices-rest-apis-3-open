# Lösung (Python-Spur): RabbitMQ einrichten und Ereignis publizieren

## `requirements.txt` (ergänzt)

```text
pika==1.3.2
```

## `app/models.py` (ergänzt)

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

## `app/events.py`

```python
from datetime import datetime, timezone
from uuid import uuid4

import pika

from app.models import Order, OrderCreatedEvent, OrderEventPayload

EXCHANGE_NAME = "order.events"
ROUTING_KEY = "order.created"


def publish_order_created(order: Order) -> None:
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host="localhost",
            credentials=pika.PlainCredentials("kodschul", "kodschul"),
        )
    )
    try:
        channel = connection.channel()
        channel.exchange_declare(exchange=EXCHANGE_NAME, exchange_type="topic", durable=True)

        event = OrderCreatedEvent(
            event_id=str(uuid4()),
            occurred_at=datetime.now(timezone.utc).isoformat(),
            order=OrderEventPayload(
                order_id=str(order.id),
                customer_name=order.customer_name,
                item_name=order.item_name,
                quantity=order.quantity,
                status=order.status.value,
            ),
        )

        channel.basic_publish(
            exchange=EXCHANGE_NAME,
            routing_key=ROUTING_KEY,
            body=event.model_dump_json(by_alias=True),
            properties=pika.BasicProperties(content_type="application/json"),
        )
    finally:
        connection.close()
```

## `app/routers/orders.py` (angepasster Ausschnitt)

```python
from app.events import publish_order_created

@router.post("", response_model=Order, status_code=201)
def create_order(request: NewOrderRequest) -> Order:
    order = Order(
        id=uuid4(),
        status=OrderStatus.NEW,
        created_at=datetime.now(timezone.utc),
        **request.model_dump(),
    )
    saved = save_order(order)
    publish_order_created(saved)
    return saved
```

## Manuelles Verifizieren

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'
```

In der Management-UI (`http://localhost:15672` → Exchanges → `order.events`) steigt die "Publish"-Rate sichtbar an.

## Hinweis zur Verbindungsstrategie

Diese Lösung öffnet und schließt für jede Bestellung eine neue Verbindung - einfach nachvollziehbar, aber für hohen Durchsatz nicht ideal. Eine wiederverwendete, langlebige Verbindung wäre eine sinnvolle Erweiterung außerhalb des Kursumfangs.
