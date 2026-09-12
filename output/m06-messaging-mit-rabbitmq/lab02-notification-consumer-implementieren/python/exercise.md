# Übung (Python-Spur): Notification-Service als Consumer

**Dauer:** ca. 45 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr richtet euren Notification-Service so ein, dass er `order.created`-Ereignisse konsumiert und eine Benachrichtigung protokolliert.

## Voraussetzungen

- Startercode `output/project/starter/python/notification-service/` kopiert und lauffähig.
- Order-Service aus Lab 1 publiziert bereits Ereignisse.
- Beide Services verbinden sich mit derselben RabbitMQ-Instanz.

## Aufgaben

1. **Startercode einrichten.** Kopiert `output/project/starter/python/notification-service/` in euer Arbeitsverzeichnis, richtet eine virtuelle Umgebung ein, prüft `GET /health`.

2. **Ereignis-Modelle anlegen.** Erstellt `app/models.py` mit `OrderEventPayload` und `OrderCreatedEvent`, identisch zu Lab 1 (Order-Service).

3. **Consumer-Modul erstellen.** Erstellt `app/consumer.py` mit einer Funktion `run_consumer()`, die Exchange und Queue deklariert, bindet und über `on_message` eingehende Nachrichten protokolliert (siehe Theorie).

4. **Consumer im Hintergrund starten.** Startet `run_consumer()` in einem eigenen Thread beim Anwendungsstart (`app/main.py`, FastAPI-`lifespan`-Hook oder Startup-Event).

5. **End-to-End testen.** Startet Order-Service und Notification-Service gleichzeitig, legt über `POST /orders` eine Bestellung an und prüft in der Konsolenausgabe des Notification-Service, dass die Benachrichtigung protokolliert wurde.

## Checkpoint

Nach einem `POST /orders`-Aufruf erscheint innerhalb weniger Sekunden eine Konsolenausgabe im Notification-Service mit Bestell-ID, Kundenname, Menge und Artikel.

## Abschlusskriterium

Der Consumer verarbeitet das Ereignis ohne Ausnahme, bestätigt es mit `basic_ack`, und die protokollierten Werte entsprechen exakt der zuvor angelegten Bestellung.
