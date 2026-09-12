# Übung (Python-Spur): REST-Endpunkte implementieren

**Dauer:** ca. 45 Minuten (Baseline) + optional 15 Minuten Erweiterung · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr implementiert die fünf Operationen aus `output/project/contracts/order-api.yaml` in eurem Order-Service (Python-Spur).

## Voraussetzungen

- Lauffähiges Starterprojekt aus Modul 1, Lab 3.
- `output/project/contracts/order-api.yaml` gelesen.

## Baseline-Aufgaben

1. **Modelle anlegen.** Erstellt in `app/models.py` ein Enum `OrderStatus`, ein Modell `NewOrderRequest` (Felder: `customer_name`, `item_name`, `quantity`) und ein Modell `Order`, das `NewOrderRequest` um `id`, `status`, `created_at` erweitert. Konfiguriert beide Modelle mit einem `camelCase`-Alias-Generator (siehe Theorie), damit das JSON-Wire-Format exakt dem gemeinsamen Vertrag `order-api.yaml` entspricht (`customerName` statt `customer_name` usw.).

2. **Speicher anlegen.** Erstellt in `app/repository.py` ein einfaches In-Memory-Dictionary sowie Funktionen `save_order`, `list_orders`, `get_order`, `delete_order`.

3. **Router implementieren.** Erstellt in `app/routers/orders.py` einen `APIRouter` mit den fünf Endpunkten aus dem Vertrag:
   - `GET /orders` - alle Bestellungen,
   - `GET /orders/{order_id}` - eine Bestellung (bei unbekannter ID: `404`, siehe Hinweis unten),
   - `POST /orders` - neue Bestellung, Status wird serverseitig auf `NEW` gesetzt, `created_at` auf den aktuellen Zeitpunkt,
   - `PUT /orders/{order_id}` - aktualisiert `customer_name`, `item_name`, `quantity` einer bestehenden Bestellung,
   - `DELETE /orders/{order_id}` - entfernt eine Bestellung.

   *Hinweis:* Eine saubere `404`-Behandlung mit `HTTPException` ist Teil von Lab 3. Gebt für diese Baseline-Aufgabe zunächst eine einfache `HTTPException(status_code=404)` zurück, wenn eine ID nicht existiert.

4. **Router registrieren und testen.** Bindet den Router in `app/main.py` per `app.include_router(...)` ein, startet den Service und prüft mit `curl` mindestens: Bestellung anlegen, Liste abrufen, einzelne Bestellung abrufen, aktualisieren, löschen.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Ergänzt einen optionalen Query-Parameter `status` bei `GET /orders`, der nur Bestellungen mit passendem Status liefert.

## Checkpoint

Alle fünf Endpunkte sind über `curl` erfolgreich getestet; die Statuscodes entsprechen der Tabelle aus Lab 1.

## Abschlusskriterium

- `POST /orders` liefert `201` mit vollständigem Order-Objekt inklusive generierter `id`.
- `GET /orders/{order_id}` liefert für eine existierende ID `200`, für eine zufällige UUID `404`.
- `PUT` und `DELETE` verhalten sich gemäß Vertrag.
