# Übung: Ereignisvertrag für ein Bestellereignis entwerfen

**Dauer:** ca. 30 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja (Vertragsdatei)

## Szenario

Ihr legt den verbindlichen Aufbau des Bestellereignisses fest, das der Order-Service in Modul 6 publiziert und der Notification-Service konsumiert.

## Voraussetzungen

- `theory.md` gelesen.
- REST-Vertrag aus Modul 2 (`output/project/contracts/order-api.yaml`) als Referenz für Feldnamen.

## Aufgaben

1. **Envelope festlegen.** Bestätigt oder passt die drei Umschlag-Felder (`eventId`, `eventType`, `occurredAt`) an und begründet kurz, warum sie unabhängig von der fachlichen Nutzlast sind.

2. **Payload festlegen.** Legt fest, welche Felder das `order`-Objekt enthält. Orientiert euch am `Order`-Schema aus Modul 2, aber wählt bewusst nur die Felder, die der Notification-Service tatsächlich braucht.

3. **JSON Schema schreiben.** Schreibt ein JSON Schema für das Gesamtereignis und legt es unter `output/project/contracts/order-created-event.schema.json` ab.

4. **Messaging-Konvention dokumentieren.** Haltet Exchange-Name, Typ, Routing Key und Queue-Name in `output/project/contracts/messaging-contract.md` fest (Tabelle wie in der Theorie).

## Checkpoint

`order-created-event.schema.json` und `messaging-contract.md` liegen unter `output/project/contracts/` und sind in sich konsistent (Feldnamen im Schema entsprechen den in der Konvention benutzten Begriffen).

## Abschlusskriterium

- Das Schema ist syntaktisch gültiges JSON Schema (Draft 2020-12 oder kompatibel).
- Alle Feldnamen sind `camelCase`.
- Die Messaging-Konvention benennt Exchange, Routing Key und Queue eindeutig.
