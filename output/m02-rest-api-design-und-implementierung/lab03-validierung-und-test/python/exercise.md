# Übung (Python-Spur): Validierung, Fehlerbehandlung und Integrationstest

**Dauer:** ca. 30 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr härtet den in Lab 2 gebauten Order-Service ab: vertragskonforme Fehlerantworten (`400` statt Frameworks Standard `422`) und ein automatisierter Test.

## Voraussetzungen

- Lauffähiger Order-Service aus Lab 2 (Python-Spur).
- `pytest` und `httpx` sind bereits Teil von `requirements.txt`; bei Bedarf erneut `pip install -r requirements.txt` ausführen.

## Aufgaben

1. **422-vs-400-Konflikt beheben.** Registriert in `app/main.py` einen Exception-Handler für `RequestValidationError`, der `400` statt des FastAPI-Standards `422` liefert (siehe Theorie).

2. **Eigene Exception für 404.** Erstellt `OrderNotFoundError` in `app/models.py` (oder einem neuen Modul `app/errors.py`) und werft sie in den Router-Funktionen `get_order_by_id`, `update_order`, `remove_order`, statt direkt `HTTPException(404, ...)` zu verwenden. Registriert dafür einen eigenen Exception-Handler.

3. **Integrationstest schreiben.** Erstellt `tests/test_orders.py` mit mindestens drei Testfällen unter Verwendung von `TestClient`:
   - `POST /orders` mit gültigen Daten liefert `201`,
   - `POST /orders` mit `quantity: 0` liefert `400`,
   - `GET /orders/{order_id}` mit einer zufälligen UUID liefert `404`.

## Checkpoint

Alle drei Testfälle aus Aufgabe 3 sind vorhanden und sollten nach eurer Einschätzung fehlerfrei durchlaufen (statische Prüfung durch den Trainer; die Ausführung kann optional ergänzt werden).

## Abschlusskriterium

- Ungültige Eingaben (`quantity <= 0`, leerer `customer_name`) führen zu `400`, nicht zum FastAPI-Standard `422`.
- Unbekannte IDs führen konsistent zu `404` mit einem JSON-Fehlerkörper.
- Der Testdatei liegen mindestens drei Testfälle mit den oben genannten Erwartungen bei.
