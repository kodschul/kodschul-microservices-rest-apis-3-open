# Übung (Java-Spur): Notification-Service als Consumer

**Dauer:** ca. 45 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr richtet euren Notification-Service so ein, dass er `order.created`-Ereignisse konsumiert und eine Benachrichtigung protokolliert.

## Voraussetzungen

- Startercode `output/project/starter/java/notification-service/` kopiert und lauffähig (siehe Modul 1, Lab 3 als Vorbild für Setup).
- Order-Service aus Lab 1 publiziert bereits Ereignisse.
- Beide Services verbinden sich mit derselben RabbitMQ-Instanz (`output/project/starter/rabbitmq-compose.yml`).

## Aufgaben

1. **Startercode einrichten.** Kopiert `output/project/starter/java/notification-service/` in euer Arbeitsverzeichnis, prüft Health-Endpunkt (`http://localhost:8091/actuator/health`).

2. **Ereignis-Klassen anlegen.** Erstellt `OrderEventPayload` und `OrderCreatedEvent` identisch zu Lab 1 (Order-Service) - beide Services teilen dasselbe Vertragsformat, auch wenn es sich um zwei getrennte Codebasen handelt.

3. **Queue und Binding deklarieren.** Erstellt `RabbitMQConfig` mit Queue, Exchange, Binding und JSON-Konverter (siehe Theorie).

4. **Consumer implementieren.** Erstellt `OrderCreatedListener` mit `@RabbitListener` (siehe Theorie).

5. **End-to-End testen.** Startet Order-Service und Notification-Service gleichzeitig, legt über `POST /orders` eine Bestellung an und prüft in der Konsolenausgabe des Notification-Service, dass die Benachrichtigung protokolliert wurde.

## Checkpoint

Nach einem `POST /orders`-Aufruf erscheint innerhalb weniger Sekunden eine Log-Zeile im Notification-Service mit Bestell-ID, Kundenname, Menge und Artikel.

## Abschlusskriterium

Der Consumer verarbeitet das Ereignis ohne Exception; die protokollierten Werte entsprechen exakt der zuvor angelegten Bestellung.
