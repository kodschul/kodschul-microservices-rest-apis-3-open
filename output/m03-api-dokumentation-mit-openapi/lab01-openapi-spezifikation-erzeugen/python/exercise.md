# Übung (Python-Spur): OpenAPI-Spezifikation erzeugen

**Dauer:** ca. 15 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr prüft die automatisch von FastAPI erzeugte OpenAPI-Spezifikation eures Order-Service, verfeinert eine Operation und gleicht sie mit dem Vertrag aus Modul 2 ab.

## Voraussetzungen

- Order-Service aus Modul 2 (inkl. Validierung und Fehlerbehandlung).

## Aufgaben

1. **Spezifikation abrufen.** Ruft `http://localhost:8081/openapi.json` auf und prüft, ob alle fünf Order-Operationen enthalten sind.

2. **Eine Operation verfeinern.** Ergänzt bei `create_order` die Parameter `summary` und `description` am `@router.post(...)`-Dekorator und prüft, ob sich die generierte Spezifikation entsprechend ändert.

3. **Fehlerantworten dokumentieren.** Ergänzt bei `get_order_by_id` den Parameter `responses={404: {"description": "Order not found"}}` am Dekorator, damit der `404`-Fall auch in der Spezifikation sichtbar wird.

4. **Abgleich mit dem Vertrag.** Vergleicht die generierte Spezifikation stichprobenartig mit `output/project/contracts/order-api.yaml`: Stimmen Statuscodes und **Feldnamen** (z. B. `customerName` statt `customer_name`) für `POST /orders` überein? Notiert eine Abweichung, falls vorhanden, oder bestätigt, dass keine besteht.

## Checkpoint

`http://localhost:8081/openapi.json` liefert eine JSON-Antwort mit allen fünf Order-Operationen; mindestens eine Operation hat eine ergänzte Beschreibung, und der `404`-Fall ist bei `GET /orders/{order_id}` dokumentiert.

## Abschlusskriterium

Die generierte Spezifikation wurde mit dem ursprünglichen Vertrag abgeglichen, und das Ergebnis (übereinstimmend oder mit benannter Abweichung) ist notiert.
