# Übung (Java-Spur): OpenAPI-Spezifikation erzeugen

**Dauer:** ca. 15 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr lasst euren Order-Service seine eigene OpenAPI-Spezifikation erzeugen und vergleicht sie mit dem Vertrag aus Modul 2.

## Voraussetzungen

- Order-Service aus Modul 2 (inkl. Validierung und Fehlerbehandlung).

## Aufgaben

1. **Abhängigkeit ergänzen.** Fügt `springdoc-openapi-starter-webmvc-ui` (Version `2.6.0`) zu `pom.xml` hinzu und startet den Service neu.

2. **Spezifikation abrufen.** Ruft `http://localhost:8081/v3/api-docs` auf und prüft, ob alle fünf Order-Operationen enthalten sind.

3. **Eine Operation verfeinern.** Ergänzt bei `createOrder` eine `@Operation`-Annotation mit `summary` und `description` und prüft, ob sich die generierte Spezifikation entsprechend ändert.

4. **Abgleich mit dem Vertrag.** Vergleicht die generierte Spezifikation stichprobenartig mit `output/project/contracts/order-api.yaml`: Stimmen Statuscodes für `POST /orders` überein? Notiert eine Abweichung, falls vorhanden (z. B. fehlende `400`-Antwortbeschreibung), oder bestätigt, dass keine besteht.

## Checkpoint

`http://localhost:8081/v3/api-docs` liefert eine JSON-Antwort mit allen fünf Order-Operationen; mindestens eine Operation hat eine per `@Operation` ergänzte Beschreibung.

## Abschlusskriterium

Die generierte Spezifikation wurde mit dem ursprünglichen Vertrag abgeglichen, und das Ergebnis (übereinstimmend oder mit benannter Abweichung) ist notiert.
