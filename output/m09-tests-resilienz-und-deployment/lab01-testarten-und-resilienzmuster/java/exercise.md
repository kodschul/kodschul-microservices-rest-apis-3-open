# Übung (Java-Spur): Testarten zuordnen und Resilienzmuster implementieren

**Dauer:** ca. 45 Minuten (Baseline) + optional 15 Minuten Erweiterung "weiteres Muster" · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr ordnet vorhandene Tests des Kurses nach Testart ein und macht den Ereignis-Publisher widerstandsfähiger gegen kurzzeitige RabbitMQ-Ausfälle.

## Voraussetzungen

- Order-Service mit `OrderEventPublisher` aus Modul 6/7.

## Baseline-Aufgaben

1. **Testarten zuordnen.** Ordnet vier konkrete Tests/Prüfungen aus dem bisherigen Kurs (`OrderControllerTest`, der Abgleich generierter OpenAPI-Spezifikation gegen den Vertrag, der Checkpoint-Nachweis aus Modul 8, ein denkbarer Test der Benachrichtigungstext-Erzeugung) den vier Testarten aus der Theorie zu.

2. **Abhängigkeit ergänzen.** Fügt `spring-retry` und `spring-boot-starter-aop` zu `pom.xml` hinzu und aktiviert Retry mit `@EnableRetry` auf der Hauptanwendungsklasse.

3. **Retry implementieren.** Versieht `publishOrderCreated` mit `@Retryable` gemäß Theorie (max. 3 Versuche, Backoff 500 ms mit Faktor 2).

4. **Verhalten beobachten.** Stoppt RabbitMQ kurzzeitig (`docker compose stop rabbitmq` bzw. `docker stop <container>`), legt eine Bestellung an und beobachtet in den Logs des Order-Service die Wiederholungsversuche. Startet RabbitMQ danach wieder und prüft, dass eine neue Bestellung wieder normal funktioniert.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Ergänzt zusätzlich ein **Timeout-Muster**: Konfiguriert einen expliziten Verbindungs-Timeout für `ConnectionFactory`, damit ein nicht erreichbarer Broker nicht unbegrenzt lange blockiert.

## Checkpoint

Bei kurzzeitig gestopptem RabbitMQ zeigen die Order-Service-Logs mehrere Wiederholungsversuche mit steigender Wartezeit, bevor die Operation endgültig fehlschlägt oder (bei rechtzeitigem Neustart von RabbitMQ) doch noch erfolgreich ist.

## Abschlusskriterium

Die vier Tests/Prüfungen aus Aufgabe 1 sind korrekt zugeordnet; das Retry-Verhalten aus Aufgabe 4 ist in den Logs nachvollziehbar dokumentiert.
