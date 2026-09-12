# Übung (Java-Spur): REST-Endpunkte implementieren

**Dauer:** ca. 45 Minuten (Baseline) + optional 15 Minuten Erweiterung · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr implementiert die fünf Operationen aus `output/project/contracts/order-api.yaml` in eurem Order-Service (Java-Spur).

## Voraussetzungen

- Lauffähiges Starterprojekt aus Modul 1, Lab 3.
- `output/project/contracts/order-api.yaml` gelesen.

## Baseline-Aufgaben

1. **Domänenmodell anlegen.** Erstellt eine Klasse `Order` (Felder: `id`, `customerName`, `itemName`, `quantity`, `status`, `createdAt`) und eine Klasse `NewOrderRequest` (Felder: `customerName`, `itemName`, `quantity`) im Package `com.kodschul.orderservice`.

2. **Speicher anlegen.** Erstellt eine Klasse `OrderRepository` mit einer thread-sicheren In-Memory-Map und Methoden `save`, `findAll`, `findById`, `deleteById`.

3. **Controller implementieren.** Erstellt `OrderController` mit den fünf Endpunkten aus dem Vertrag:
   - `GET /orders` - alle Bestellungen,
   - `GET /orders/{id}` - eine Bestellung (bei unbekannter ID: `404`, siehe Hinweis unten),
   - `POST /orders` - neue Bestellung, Status wird serverseitig auf `NEW` gesetzt, `createdAt` auf den aktuellen Zeitpunkt,
   - `PUT /orders/{id}` - aktualisiert `customerName`, `itemName`, `quantity` einer bestehenden Bestellung,
   - `DELETE /orders/{id}` - entfernt eine Bestellung.

   *Hinweis:* Eine saubere `404`-Behandlung mit einer eigenen Exception-Klasse ist Teil von Lab 3. Gebt für diese Baseline-Aufgabe zunächst `ResponseEntity.notFound().build()` zurück, wenn eine ID nicht existiert.

4. **Manuell testen.** Startet den Service und prüft mit `curl` mindestens: Bestellung anlegen, Liste abrufen, einzelne Bestellung abrufen, aktualisieren, löschen.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Ergänzt einen zusätzlichen Endpunkt `GET /orders?status=NEW`, der nur Bestellungen mit passendem Status liefert (Query-Parameter mit `@RequestParam(required = false)`).

## Checkpoint

Alle fünf Endpunkte sind über `curl` erfolgreich getestet; die Statuscodes entsprechen der Tabelle aus Lab 1.

## Abschlusskriterium

- `POST /orders` liefert `201` mit vollständigem Order-Objekt inklusive generierter `id`.
- `GET /orders/{id}` liefert für eine existierende ID `200`, für eine zufällige UUID `404`.
- `PUT` und `DELETE` verhalten sich gemäß Vertrag.
