---
theme: default
---

# Lab 1 (Python-Spur): OpenAPI-Spezifikation erzeugen

## Lernziel

Nach diesem Lab kennt ihr die automatisch von FastAPI erzeugte OpenAPI-Spezifikation eures Order-Service und könnt sie gezielt verfeinern und mit dem Vertrag aus Modul 2 abgleichen.

## Leitfragen

1. Woher kommt die OpenAPI-Spezifikation, die FastAPI bereitstellt, ohne dass ihr sie schreibt?
2. Wie verbessert man automatisch generierte, aber wenig aussagekräftige Beschreibungen?

## FastAPI erzeugt OpenAPI automatisch

Anders als bei Java/Spring (wo eine zusätzliche Bibliothek wie springdoc nötig ist) generiert FastAPI die OpenAPI-Spezifikation **immer automatisch** aus euren Pfad-Operationen, Typannotationen und Pydantic-Modellen - ohne Zusatzabhängigkeit. Abrufbar unter:

```text
http://localhost:8081/openapi.json
```

## Spezifikation verfeinern

Ohne Zusatzangaben liefert FastAPI nur technisch korrekte, aber wenig aussagekräftige Beschreibungen. Mit Parametern am Routen-Dekorator und `Field(..., description=...)` lässt sich das verbessern:

```python
@router.post(
    "",
    response_model=Order,
    status_code=201,
    summary="Neue Bestellung anlegen",
    description="Legt eine Bestellung mit Status NEW an und liefert sie inklusive generierter ID zurück.",
)
def create_order(request: NewOrderRequest) -> Order:
    ...
```

## Vertrag vs. generierte Spezifikation

Der in Modul 2 handgeschriebene Vertrag (`order-api.yaml`) und die jetzt generierte Spezifikation sollten dieselben Pfade, Methoden und - mit der in Lab 3 aus Modul 2 ergänzten Fehlerbehandlung - auch dieselben Statuscodes beschreiben. FastAPI listet standardmäßig nur den `response_model`-Erfolgsfall und den automatischen `422`-Validierungsfehler; benutzerdefinierte Fehlerantworten (wie euer `400`- und `404`-Handler) müsst ihr über `responses={...}` explizit dokumentieren, sonst fehlen sie in der Spezifikation, obwohl der Code sie korrekt liefert.

## Checkpoint

Ihr könnt die generierte OpenAPI-Spezifikation abrufen, eine Operation verfeinern und wisst, warum benutzerdefinierte Fehlerantworten explizit dokumentiert werden müssen.
