# Übung (Java-Spur): Client-Stub generieren

**Dauer:** ca. 15 Minuten (Baseline) + optionale Erweiterung "Dokumentation gemeinsam reviewen" · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr generiert einen TypeScript-Client aus der laufenden Spezifikation eures Order-Service.

## Voraussetzungen

- Order-Service mit springdoc aus Lab 1 läuft auf Port 8081.
- Docker Desktop bzw. eine Container-Runtime ist verfügbar (siehe Preflight-Hinweise des Trainers).

## Baseline-Aufgaben

1. **Client generieren.** Führt den Docker-Befehl aus der Theorie aus und prüft, dass im Ordner `generated-client` Code erzeugt wurde.

2. **Generierten Code inspizieren.** Öffnet eine der generierten API-Klassen (z. B. `OrdersApi`) und identifiziert die Methode, die `POST /orders` entspricht. Vergleicht ihre Parameter mit `NewOrderRequest` aus Modul 2.

3. **Lücke erkennen.** Prüft, ob die generierte Client-Methode für `createOrder` eine Beschreibung/JSDoc-Kommentar enthält. Falls nicht: Erklärt, welche Ergänzung in Lab 1 (`@Operation`) das beheben würde.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Reviewt zu zweit die generierte Dokumentation (`generated-client`-Ordner oder die Swagger-UI-Beschreibungstexte) und haltet fest, welche zwei Operationen noch von zusätzlichen `@Operation`- oder `@ApiResponse`-Angaben profitieren würden.

## Checkpoint

Ein `generated-client`-Ordner mit TypeScript-Code existiert, und ihr habt mindestens eine generierte Methode einem Endpunkt aus eurem Order-Service zugeordnet.

## Abschlusskriterium

Ihr könnt erklären, welche Zeile der OpenAPI-Spezifikation zu welcher generierten Client-Methode geführt hat, und mindestens eine Verbesserungsmöglichkeit für die Spezifikation benennen.
