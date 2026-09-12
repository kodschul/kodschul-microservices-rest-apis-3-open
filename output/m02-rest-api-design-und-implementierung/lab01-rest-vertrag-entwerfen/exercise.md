# Übung: REST-Vertrag für die Order-Ressource entwerfen

**Dauer:** ca. 45 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja (Vertragsdatei `contracts/order-api.yaml`)

## Szenario

Bevor ihr in Lab 2 Code schreibt, legt ihr den REST-Vertrag für die Order-Ressource als OpenAPI-3.0-Dokument fest. Dieser Vertrag gilt für beide Sprachspuren gleichermaßen.

## Voraussetzungen

- `theory.md` gelesen.
- Servicegrenzen aus Modul 1, Lab 2 (Order-Verantwortung).
- Ein Texteditor; OpenAPI-Kenntnisse werden nicht vorausgesetzt, ihr orientiert euch am Beispiel unten.

## Datenmodell

Nutzt folgendes Order-Schema als Ausgangspunkt:

| Feld | Typ | Pflicht bei Anlage? | Vom Server gesetzt? |
| --- | --- | --- | --- |
| `id` | string (UUID) | nein | ja |
| `customerName` | string | ja | nein |
| `itemName` | string | ja | nein |
| `quantity` | integer, >= 1 | ja | nein |
| `status` | enum: `NEW`, `CONFIRMED`, `CANCELLED` | nein | ja (Startwert `NEW`) |
| `createdAt` | string (date-time) | nein | ja |

## Aufgaben

1. **Pfade und Methoden festlegen.** Legt fest, welche Pfade und HTTP-Methoden `/orders` unterstützt: Liste abrufen, einzelne Bestellung abrufen, anlegen, aktualisieren, löschen. Nutzt die Tabelle aus der Theorie.

2. **Statuscodes je Operation zuordnen.** Ordnet jeder Operation aus Aufgabe 1 den Erfolgsstatuscode sowie mindestens einen Fehlerstatuscode zu (z. B. `404` bei unbekannter ID).

3. **OpenAPI-Dokument schreiben.** Schreibt ein vollständiges OpenAPI-3.0-YAML-Dokument (`info`, `paths`, `components.schemas.Order`) auf Basis der Aufgaben 1 und 2. Legt die Datei unter `output/project/contracts/order-api.yaml` ab.

4. **Grenzfall entscheiden.** Was passiert, wenn `POST /orders` mit `quantity: 0` aufgerufen wird? Legt den erwarteten Statuscode fest und ergänzt ihn im Dokument (`400`-Antwort für den Anlage-Endpunkt).

## Checkpoint

Eine gültige OpenAPI-3.0-Datei liegt unter `output/project/contracts/order-api.yaml`, enthält alle fünf Operationen mit Erfolgs- und mindestens einem Fehlerstatuscode sowie das vollständige `Order`-Schema.

## Abschlusskriterium

- Die Datei ist syntaktisch gültiges YAML.
- Alle fünf Operationen aus Aufgabe 1 sind als `paths`-Einträge vorhanden.
- `quantity` ist als Ganzzahl mit Minimum 1 modelliert.
- `status` ist als Enum mit den drei genannten Werten modelliert.
