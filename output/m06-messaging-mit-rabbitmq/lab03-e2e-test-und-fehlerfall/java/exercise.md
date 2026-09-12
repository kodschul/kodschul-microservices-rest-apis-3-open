# Übung (Java-Spur): End-to-End-Ereignisfluss testen und Fehlerfall betrachten

**Dauer:** ca. 30 Minuten (Baseline) + optional 15 Minuten Erweiterung "Retry-Strategie" · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr sichert den Ereignisfluss mit einem automatisierten Test ab und untersucht, was bei einem Verarbeitungsfehler im Notification-Service passiert.

## Voraussetzungen

- Order-Service (Lab 1) und Notification-Service (Lab 2) lauffähig.

## Baseline-Aufgaben

1. **End-to-End manuell bestätigen.** Führt den End-to-End-Test aus Lab 2 (Aufgabe 5) erneut aus und haltet Bestell-ID und protokollierten Text fest.

2. **Consumer-Logik testen.** Schreibt `OrderCreatedListenerTest` mit dem Testfall aus der Theorie (konstruiertes Ereignis, `assertDoesNotThrow`).

3. **Fehlerfall provozieren.** Ändert `handleOrderCreated` testweise so, dass sie bei `quantity > 1` eine `RuntimeException` wirft. Legt über den Order-Service eine Bestellung mit `quantity: 2` an und beobachtet in der RabbitMQ-Management-UI (Queue `notification.order-created`), dass die Nachricht wiederholt zugestellt wird (steigender "Redelivered"-Zähler bzw. wachsende Warteschlangenlänge).

4. **Fehlerfall zurücksetzen.** Entfernt die testweise eingefügte Exception wieder und bestätigt, dass der End-to-End-Fluss wieder fehlerfrei funktioniert.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Konfiguriert eine begrenzte Retry-Strategie (z. B. maximal 3 Versuche) über `RetryTemplate` am `SimpleRabbitListenerContainerFactory` und beobachtet, dass RabbitMQ nach Erschöpfen der Versuche keine weitere Zustellung mehr versucht.

## Checkpoint

Der Test aus Aufgabe 2 läuft ohne Exception; das Fehlerverhalten aus Aufgabe 3 ist beobachtet und dokumentiert.

## Abschlusskriterium

Die Dokumentation aus Aufgabe 3 benennt explizit die wiederholte Zustellung als Folge der fehlenden Bestätigung (`ack`).
