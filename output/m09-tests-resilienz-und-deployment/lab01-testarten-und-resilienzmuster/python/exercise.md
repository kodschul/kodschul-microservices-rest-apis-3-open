# Übung (Python-Spur): Testarten zuordnen und Resilienzmuster implementieren

**Dauer:** ca. 45 Minuten (Baseline) + optional 15 Minuten Erweiterung "weiteres Muster" · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr ordnet vorhandene Tests des Kurses nach Testart ein und macht die Ereignisveröffentlichung widerstandsfähiger gegen kurzzeitige RabbitMQ-Ausfälle.

## Voraussetzungen

- Order-Service mit `publish_order_created` aus Modul 6/7.

## Baseline-Aufgaben

1. **Testarten zuordnen.** Ordnet vier konkrete Tests/Prüfungen aus dem bisherigen Kurs (`test_orders.py`, der Abgleich generierter OpenAPI-Spezifikation gegen den Vertrag, der Checkpoint-Nachweis aus Modul 8, ein denkbarer Test der Benachrichtigungstext-Erzeugung) den vier Testarten aus der Theorie zu.

2. **Abhängigkeit ergänzen.** Fügt `tenacity==9.0.0` zu `requirements.txt` hinzu und installiert sie.

3. **Retry implementieren.** Versieht `publish_order_created` mit `@retry` gemäß Theorie (max. 3 Versuche, exponentielles Backoff).

4. **Verhalten beobachten.** Stoppt RabbitMQ kurzzeitig (`docker compose stop rabbitmq` bzw. `docker stop <container>`), legt eine Bestellung an und beobachtet in den Logs des Order-Service die Wiederholungsversuche. Startet RabbitMQ danach wieder und prüft, dass eine neue Bestellung wieder normal funktioniert.

## Erweiterung (optional, nicht Teil der Pflichtzeit)

Ergänzt zusätzlich ein **Timeout-Muster**: Setzt `blocked_connection_timeout` und `socket_timeout` in `pika.ConnectionParameters(...)`, damit ein nicht erreichbarer Broker nicht unbegrenzt lange blockiert.

## Checkpoint

Bei kurzzeitig gestopptem RabbitMQ zeigen die Order-Service-Logs mehrere Wiederholungsversuche mit steigender Wartezeit, bevor die Operation endgültig fehlschlägt oder (bei rechtzeitigem Neustart von RabbitMQ) doch noch erfolgreich ist.

## Abschlusskriterium

Die vier Tests/Prüfungen aus Aufgabe 1 sind korrekt zugeordnet; das Retry-Verhalten aus Aufgabe 4 ist nachvollziehbar dokumentiert.
