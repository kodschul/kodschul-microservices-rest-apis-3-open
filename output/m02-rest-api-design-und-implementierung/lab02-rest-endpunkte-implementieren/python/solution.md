# Lösung (Python-Spur): REST-Endpunkte implementieren

## `app/models.py`

```python
from datetime import datetime
from enum import Enum
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field
from pydantic.alias_generators import to_camel


class OrderStatus(str, Enum):
    NEW = "NEW"
    CONFIRMED = "CONFIRMED"
    CANCELLED = "CANCELLED"


class NewOrderRequest(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    customer_name: str = Field(min_length=1)
    item_name: str = Field(min_length=1)
    quantity: int = Field(ge=1)


class Order(NewOrderRequest):
    id: UUID
    status: OrderStatus
    created_at: datetime
```

## `app/repository.py`

```python
from uuid import UUID

from app.models import Order

_orders: dict[UUID, Order] = {}


def save_order(order: Order) -> Order:
    _orders[order.id] = order
    return order


def list_orders() -> list[Order]:
    return list(_orders.values())


def get_order(order_id: UUID) -> Order | None:
    return _orders.get(order_id)


def delete_order(order_id: UUID) -> None:
    _orders.pop(order_id, None)
```

## `app/routers/orders.py`

```python
from datetime import datetime, timezone
from uuid import UUID, uuid4

from fastapi import APIRouter, HTTPException

from app.models import NewOrderRequest, Order, OrderStatus
from app.repository import delete_order, get_order, list_orders, save_order

router = APIRouter(prefix="/orders", tags=["orders"])


@router.get("", response_model=list[Order])
def get_orders() -> list[Order]:
    return list_orders()


@router.get("/{order_id}", response_model=Order)
def get_order_by_id(order_id: UUID) -> Order:
    order = get_order(order_id)
    if order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return order


@router.post("", response_model=Order, status_code=201)
def create_order(request: NewOrderRequest) -> Order:
    order = Order(
        id=uuid4(),
        status=OrderStatus.NEW,
        created_at=datetime.now(timezone.utc),
        **request.model_dump(),
    )
    return save_order(order)


@router.put("/{order_id}", response_model=Order)
def update_order(order_id: UUID, request: NewOrderRequest) -> Order:
    existing = get_order(order_id)
    if existing is None:
        raise HTTPException(status_code=404, detail="Order not found")
    updated = existing.model_copy(update=request.model_dump())
    return save_order(updated)


@router.delete("/{order_id}", status_code=204)
def remove_order(order_id: UUID) -> None:
    if get_order(order_id) is None:
        raise HTTPException(status_code=404, detail="Order not found")
    delete_order(order_id)
```

## `app/main.py` (erweitert)

```python
from fastapi import FastAPI

from app.routers.orders import router as orders_router

app = FastAPI(title="Order Service", version="0.1.0")
app.include_router(orders_router)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "UP"}
```

## Manuelles Testen

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'
# -> 201, liefert u. a. die generierte "id" (Antwortfelder ebenfalls camelCase)

curl http://localhost:8081/orders
curl http://localhost:8081/orders/<id-aus-der-antwort>

curl -X PUT http://localhost:8081/orders/<id> \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":3}'

curl -X DELETE http://localhost:8081/orders/<id> -i
# -> 204, kein Body

curl http://localhost:8081/orders/00000000-0000-0000-0000-000000000000 -i
# -> 404
```

## Erweiterung: Filter nach Status

```python
from typing import Optional

@router.get("", response_model=list[Order])
def get_orders(status: Optional[OrderStatus] = None) -> list[Order]:
    orders = list_orders()
    if status is None:
        return orders
    return [o for o in orders if o.status == status]
```
