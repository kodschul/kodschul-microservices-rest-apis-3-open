---
theme: default
---

# Lab 2 (Python-Spur): REST-Endpunkte implementieren

## Lernziel

Nach diesem Lab implementiert euer Order-Service alle fünf Operationen aus dem Vertrag (`order-api.yaml`) mit FastAPI.

## Leitfragen

1. Wie bildet FastAPI HTTP-Methoden und Pfade auf Python-Funktionen ab?
2. Wie beschreibt Pydantic Request- und Response-Modelle?
3. Wie hält man einen einfachen Zustand ohne echte Datenbank (für diesen Kurs bewusst in-memory)?

## Routen-Dekoratoren

```python
from fastapi import APIRouter

router = APIRouter(prefix="/orders")

@router.get("")
def list_orders(): ...

@router.get("/{order_id}")
def get_order(order_id: UUID): ...

@router.post("", status_code=201)
def create_order(request: NewOrderRequest): ...
```

- `@router.get(...)`, `@router.post(...)` usw. registrieren Pfad und Methode direkt am Funktions-Dekorator.
- Pfad-Parameter (`{order_id}`) werden über gleichnamige Funktionsparameter mit Typannotation gebunden; FastAPI validiert den Typ automatisch (z. B. `UUID`).
- `status_code=201` setzt den in Modul 2/Lab 1 festgelegten Erfolgsstatus für `POST` explizit (FastAPI verwendet sonst `200` als Standard).

## Pydantic-Modelle statt Klassen mit Gettern/Settern

```python
from pydantic import BaseModel, ConfigDict, Field
from pydantic.alias_generators import to_camel
from uuid import UUID
from datetime import datetime
from enum import Enum

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

Pydantic übernimmt automatisch Validierung (z. B. `quantity >= 1`) und JSON-Serialisierung/-Deserialisierung - ohne, dass ihr Getter/Setter oder manuelles Parsing schreiben müsst.

## camelCase vs. snake_case: der Vertrag entscheidet

Python-Konvention ist `snake_case` (`customer_name`), der gemeinsame Vertrag `output/project/contracts/order-api.yaml` schreibt aber `camelCase` (`customerName`) vor - denselben Vertrag, den auch die Java-Spur erfüllt. Ohne Zusatzkonfiguration würde die Python-API also ein anderes JSON-Wire-Format sprechen als vereinbart.

`model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)` löst das:

- `alias_generator=to_camel` erzeugt für jedes Feld automatisch einen `camelCase`-Alias (`customer_name` → `customerName`), der beim JSON-Ein- und -Ausgang verwendet wird.
- `populate_by_name=True` erlaubt zusätzlich, das Modell intern weiterhin über die `snake_case`-Attributnamen zu befüllen (z. B. `NewOrderRequest(customer_name=...)` in eigenem Python-Code), ohne dass ihr überall Aliase tippen müsst.

So bleibt der Python-Code intern idiomatisch (`snake_case`), während die Schnittstelle nach außen exakt dem vereinbarten `camelCase`-Vertrag folgt - Voraussetzung dafür, dass ein generierter Client (Modul 3) und die Java-Spur dieselbe Vertragserwartung erfüllen.

## Zustand ohne Datenbank

Wie in der Java-Spur genügt für diesen Kurs ein einfaches In-Memory-Dictionary. Das ist eine didaktische Vereinfachung; ein echtes System würde eine Datenbank verwenden (z. B. PostgreSQL mit SQLAlchemy).

```python
orders: dict[UUID, Order] = {}
```

## Checkpoint

Ihr könnt eine Ressource mit FastAPI über alle fünf HTTP-Methoden ansprechen und versteht, wie Pydantic-Modelle Validierung und Serialisierung übernehmen.
