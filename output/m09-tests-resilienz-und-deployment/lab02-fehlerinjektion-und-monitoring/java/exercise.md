# Übung (Java-Spur): Fehlerinjektionstest und Monitoring-Konzept

**Dauer:** ca. 40 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr sichert das Retry-Verhalten aus Lab 1 automatisiert ab und skizziert ein Monitoring-/Logging-Konzept für die gesamte Plattform.

## Voraussetzungen

- Retry-Muster aus Lab 1.
- `mockito-core` ist über `spring-boot-starter-test` bereits verfügbar.

## Aufgaben

1. **Fehlerinjektionstest schreiben.** Erstellt `OrderEventPublisherTest` mit dem Testfall aus der Theorie. Prüft zusätzlich einen zweiten Fall: Wirft `RabbitTemplate` **keine** Exception, wird `convertAndSend` genau einmal aufgerufen.

2. **Test ausführen (statisch prüfen).** Vergleicht euren Test gedanklich mit dem Retry-Code aus Lab 1: Stimmen `maxAttempts` im Code und `times(...)` im Test überein?

3. **Monitoring-Konzept skizzieren.** Erstellt `output/project/monitoring-logging-concept.md` mit den vier Aspekten aus der Theorie, bezogen konkret auf Order-Service, Notification-Service und RabbitMQ.

4. **Korrelations-ID vorschlagen.** Schlagt vor, wie eine Bestell-ID als Korrelations-ID durch Logs beider Services sichtbar gemacht werden könnte (Codeänderung ist nicht nötig, ein konkreter Vorschlag reicht).

## Checkpoint

`OrderEventPublisherTest` enthält zwei Testfälle (Fehler- und Erfolgsfall); `monitoring-logging-concept.md` deckt alle vier Aspekte für beide Services ab.

## Abschlusskriterium

Die Anzahl der erwarteten Aufrufe im Test entspricht exakt der `maxAttempts`-Konfiguration aus Lab 1.
