# Lösung (Python-Spur): Validierung, Fehlerbehandlung und Integrationstest

## `app/errors.py`

```python
from uuid import UUID


class OrderNotFoundError(Exception):
    def __init__(self, order_id: UUID):
        self.order_id = order_id
```

## `app/main.py` (erweitert)

```python
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from app.errors import OrderNotFoundError
from app.routers.orders import router as orders_router

app = FastAPI(title="Order Service", version="0.1.0")
app.include_router(orders_router)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    return JSONResponse(status_code=400, content={"error": "Validation failed"})


@app.exception_handler(OrderNotFoundError)
async def order_not_found_handler(request: Request, exc: OrderNotFoundError) -> JSONResponse:
    return JSONResponse(status_code=404, content={"error": f"Order not found: {exc.order_id}"})


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "UP"}
```

## `app/routers/orders.py` (angepasste Ausschnitte)

```python
from app.errors import OrderNotFoundError

@router.get("/{order_id}", response_model=Order)
def get_order_by_id(order_id: UUID) -> Order:
    order = get_order(order_id)
    if order is None:
        raise OrderNotFoundError(order_id)
    return order


@router.put("/{order_id}", response_model=Order)
def update_order(order_id: UUID, request: NewOrderRequest) -> Order:
    existing = get_order(order_id)
    if existing is None:
        raise OrderNotFoundError(order_id)
    updated = existing.model_copy(update=request.model_dump())
    return save_order(updated)


@router.delete("/{order_id}", status_code=204)
def remove_order(order_id: UUID) -> None:
    if get_order(order_id) is None:
        raise OrderNotFoundError(order_id)
    delete_order(order_id)
```

*Hinweis:* Der `HTTPException`-Import und die bisherigen `raise HTTPException(status_code=404, ...)`-Zeilen aus Lab 2 werden vollständig durch `OrderNotFoundError` ersetzt.

## `tests/test_orders.py`

```python
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_create_order_with_valid_data_returns_201():
    response = client.post(
        "/orders",
        json={"customerName": "Mara Beispiel", "itemName": "Kaffeemaschine", "quantity": 2},
    )
    assert response.status_code == 201
    body = response.json()
    assert body["status"] == "NEW"
    assert body["id"]


def test_create_order_with_invalid_quantity_returns_400():
    response = client.post(
        "/orders",
        json={"customerName": "Mara Beispiel", "itemName": "Kaffeemaschine", "quantity": 0},
    )
    assert response.status_code == 400


def test_get_order_with_unknown_id_returns_404():
    response = client.get("/orders/00000000-0000-0000-0000-000000000000")
    assert response.status_code == 404
```
