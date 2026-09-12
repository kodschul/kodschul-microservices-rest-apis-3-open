# Übung (Python-Spur): End-to-End-Ereignisfluss testen und Fehlerfall betrachten

**Dauer:** ca. 30 Minuten (Baseline) + optional 15 Minuten Erweiterung "Retry-Strategie" · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr sichert den Ereignisfluss mit einem automatisierten Test ab und untersucht, was bei einem Verarbeitungsfehler im Notification-Service passiert.

## Voraussetzungen

- Order-Service (Lab 1) und Notification-Service (Lab 2) lauffähig.

## Baseline-Aufgaben

1. **End-to-End manuell bestätigen.** Führt den End-to-End-Test aus Lab 2 (Aufgabe 5) erneut aus und haltet Bestell-ID und protokollierten Text fest.

2. **Verarbeitungslogik auslagern und testen.** Extrahiert aus `on_message` eine Funktion `build_notification_text(event: OrderCreatedEvent) -> str` und schreibt dafür einen Test in `tests/test_consumer.py` (siehe Theorie).

3. **Fehlerfall provozieren.** Ändert `on_message` testweise so, dass sie bei `event.order.quantity > 1` eine `ValueError` wirft, **bevor** `channel.basic_ack(...)` aufgerufen wird. Legt über den Order-Service eine Bestellung mit `quantity: 2` an und beobachtet in der RabbitMQ-Management-UI (Queue `notification.order-created`), dass die Nachricht als "Unacked" bzw. erneut zugestellt angezeigt wird.

4. **Fehlerfall zurücksetzen.** Entfernt die testweise eingefügte Ausnahme wieder und bestätigt, dass der End-to-End-Fluss wieder fehlerfrei funktioniert.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Skizziert (als Kommentar oder kurzes Codebeispiel, keine vollständige Implementierung nötig), wie eine Dead-Letter-Exchange-Konfiguration in RabbitMQ nach einer begrenzten Anzahl an `nack`-Aufrufen die Nachricht automatisch umleiten würde.

## Checkpoint

Der Test aus Aufgabe 2 läuft ohne Ausnahme; das Fehlerverhalten aus Aufgabe 3 ist beobachtet und dokumentiert.

## Abschlusskriterium

Die Dokumentation aus Aufgabe 3 benennt explizit die fehlende Bestätigung (`basic_ack`) als Ursache für die erneute Zustellung bzw. den "Unacked"-Status.
