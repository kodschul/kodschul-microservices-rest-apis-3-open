# Übung (Python-Spur): Fehlerinjektionstest und Monitoring-Konzept

**Dauer:** ca. 40 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr sichert das Retry-Verhalten aus Lab 1 automatisiert ab und skizziert ein Monitoring-/Logging-Konzept für die gesamte Plattform.

## Voraussetzungen

- Retry-Muster aus Lab 1.
- `pytest` ist bereits Teil von `requirements.txt` (Modul 2).

## Aufgaben

1. **Fehlerinjektionstest schreiben.** Erstellt `tests/test_events.py` mit dem Testfall aus der Theorie. Prüft zusätzlich einen zweiten Fall: Wirft `pika.BlockingConnection` **keine** Exception, wird die Verbindung genau einmal aufgebaut.

2. **Test mit dem Code abgleichen.** Vergleicht euren Test gedanklich mit dem Retry-Code aus Lab 1: Stimmen `stop_after_attempt(...)` im Code und die erwartete Aufrufanzahl im Test überein?

3. **Monitoring-Konzept skizzieren.** Erstellt `output/project/monitoring-logging-concept.md` mit den vier Aspekten aus der Theorie, bezogen konkret auf Order-Service, Notification-Service und RabbitMQ.

4. **Korrelations-ID vorschlagen.** Schlagt vor, wie eine Bestell-ID als Korrelations-ID durch Logs beider Services sichtbar gemacht werden könnte (Codeänderung ist nicht nötig, ein konkreter Vorschlag reicht).

## Checkpoint

`tests/test_events.py` enthält zwei Testfälle (Fehler- und Erfolgsfall); `monitoring-logging-concept.md` deckt alle vier Aspekte für beide Services ab.

## Abschlusskriterium

Die Anzahl der erwarteten Verbindungsversuche im Test entspricht exakt der `stop_after_attempt(...)`-Konfiguration aus Lab 1.
