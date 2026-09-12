# Übung (Java-Spur): Validierung, Fehlerbehandlung und Integrationstest

**Dauer:** ca. 30 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr härtet den in Lab 2 gebauten Order-Service ab: serverseitige Validierung, konsistente Fehlerantworten und ein automatisierter Test.

## Voraussetzungen

- Lauffähiger Order-Service aus Lab 2 (Java-Spur).

## Aufgaben

1. **Validierung ergänzen.** Fügt `@NotBlank` zu `customerName` und `itemName` sowie `@Min(1)` zu `quantity` in `NewOrderRequest` hinzu. Markiert den Parameter in `createOrder` und `updateOrder` mit `@Valid`.

2. **Eigene Exception für 404.** Erstellt `OrderNotFoundException extends RuntimeException` und werft sie in `getOrder`, `updateOrder` und `deleteOrder`, statt direkt `ResponseEntity.notFound()` zurückzugeben.

3. **Zentrale Fehlerbehandlung.** Erstellt `ApiExceptionHandler` mit `@RestControllerAdvice` und behandelt `OrderNotFoundException` (→ 404) sowie `MethodArgumentNotValidException` (→ 400) wie in der Theorie gezeigt.

4. **Integrationstest schreiben.** Erstellt `OrderControllerTest` mit mindestens drei Testfällen:
   - `POST /orders` mit gültigen Daten liefert `201`,
   - `POST /orders` mit `quantity: 0` liefert `400`,
   - `GET /orders/{id}` mit einer zufälligen UUID liefert `404`.

## Checkpoint

Alle drei Testfälle aus Aufgabe 4 sind vorhanden und sollten nach eurer Einschätzung fehlerfrei durchlaufen (statische Prüfung durch den Trainer; die Ausführung kann optional ergänzt werden).

## Abschlusskriterium

- Ungültige Eingaben (`quantity <= 0`, leerer `customerName`) führen zu `400` statt zu einer unbehandelten Exception oder `500`.
- Unbekannte IDs führen konsistent zu `404` mit einem JSON-Fehlerkörper.
- Der Testklasse liegen mindestens drei Testfälle mit den oben genannten Erwartungen bei.
