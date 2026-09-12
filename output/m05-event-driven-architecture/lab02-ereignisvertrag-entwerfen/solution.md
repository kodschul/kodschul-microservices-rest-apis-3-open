# Lösung: Ereignisvertrag für ein Bestellereignis entwerfen

## Aufgabe 1: Envelope

`eventId` (eindeutige Kennung des Ereignisses, unabhängig vom fachlichen Inhalt, u. a. nützlich für Deduplizierung), `eventType` (identifiziert die Bedeutung, erlaubt spätere weitere Ereignistypen), `occurredAt` (Zeitpunkt des Auftretens, unabhängig davon, wann eine Nachricht tatsächlich verarbeitet wird) - alle drei sind für jeden künftigen Ereignistyp gültig, nicht nur für Bestellungen.

## Aufgabe 2: Payload

Für den Notification-Service werden benötigt: `orderId` (Referenz), `customerName` (für die Anrede), `itemName` und `quantity` (Inhalt der Benachrichtigung), `status` (Bestätigungstext). Felder wie interne Zeitstempel der Order-Datenbank sind bewusst **nicht** Teil des Ereignisses, da der Notification-Service sie nicht braucht (Prinzip: nur transportieren, was der Konsument tatsächlich benötigt).

## Aufgabe 3+4: Vertragsdateien

Die vollständige Lösung liegt unter [`output/project/contracts/order-created-event.schema.json`](../../../project/contracts/order-created-event.schema.json) und [`output/project/contracts/messaging-contract.md`](../../../project/contracts/messaging-contract.md).

Wichtige Designentscheidungen:

- `eventType` ist als `const: "order.created"` modelliert, nicht als freies Enum - jede Schemadatei beschreibt genau einen Ereignistyp; weitere Ereignisse (z. B. `order.cancelled`) bekämen ein eigenes Schema.
- Die Queue heißt nach Konsument und Ereignis (`notification.order-created`), nicht nach dem Erzeuger - das bleibt auch dann eindeutig, wenn später weitere Konsumenten hinzukommen.
