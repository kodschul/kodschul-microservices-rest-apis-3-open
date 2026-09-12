---
theme: default
---

# Lab 3 (Python-Spur): Validierung, Fehlerbehandlung und Integrationstest

## Lernziel

Nach diesem Lab validiert euer Order-Service Eingaben serverseitig, liefert konsistente Fehlerantworten gemäß Vertrag und ist durch einen automatisierten Integrationstest abgesichert.

## Leitfragen

1. Was validiert Pydantic bereits automatisch, und was fehlt noch?
2. Warum antwortet FastAPI bei Validierungsfehlern standardmäßig mit `422`, obwohl der Vertrag `400` vorsieht - und wie geht ihr damit um?
3. Wie testet man einen FastAPI-Endpunkt automatisiert, ohne den Server manuell zu starten?

## Was Pydantic bereits validiert

Die `Field`-Constraints aus Lab 2 (`min_length=1`, `ge=1`) werden von Pydantic bereits automatisch geprüft. Ein Verstoß löst intern eine `RequestValidationError` aus.

## Der 422-vs-400-Konflikt

FastAPI antwortet bei einer `RequestValidationError` **standardmäßig mit `422 Unprocessable Entity`**, nicht mit `400 Bad Request`. Das ist eine bewusste Design-Entscheidung des Frameworks (semantisch: "syntaktisch korrekt, aber inhaltlich ungültig"), weicht aber vom in Lab 1 vereinbarten Vertrag ab, der `400` vorsieht.

**Konsequenz für Contract-first:** Ein Vertrag legt das Soll fest; die Implementierung muss ihn aktiv einhalten, auch gegen Framework-Standardwerte. Dazu registriert ihr einen eigenen Exception-Handler:

```python
from fastapi import Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(status_code=400, content={"error": "Validation failed"})
```

## Eigene Exception für 404

```python
class OrderNotFoundError(Exception):
    def __init__(self, order_id):
        self.order_id = order_id

@app.exception_handler(OrderNotFoundError)
async def order_not_found_handler(request: Request, exc: OrderNotFoundError):
    return JSONResponse(status_code=404, content={"error": f"Order not found: {exc.order_id}"})
```

Ein eigener Exception-Typ trennt fachliche Fehler (Order nicht gefunden) von technischen Validierungsfehlern und macht die Fehlerbehandlung an einer Stelle wartbar.

## Integrationstests mit `TestClient`

FastAPI basiert auf Starlette, das einen `TestClient` auf Basis von `httpx` bereitstellt. Er simuliert HTTP-Anfragen ohne echten Netzwerk-Port.

```python
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_order_returns_201():
    response = client.post("/orders", json={...})
    assert response.status_code == 201
```

## Checkpoint

Ihr könnt erklären, warum FastAPI-Validierungsfehler standardmäßig `422` statt `400` liefern, einen eigenen Exception-Handler registrieren und einen Endpunkt mit `TestClient` automatisiert testen.
