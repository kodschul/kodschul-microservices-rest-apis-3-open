# Übung (Python-Spur): RabbitMQ einrichten und Ereignis publizieren

**Dauer:** ca. 60 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr richtet RabbitMQ lokal ein und erweitert den Order-Service so, dass er bei jeder neuen Bestellung ein Ereignis gemäß `output/project/contracts/messaging-contract.md` publiziert.

## Voraussetzungen

- Order-Service aus Modul 2/3 (Python-Spur).
- Docker lokal verfügbar.
- `output/project/contracts/order-created-event.schema.json` und `messaging-contract.md` gelesen.

## Aufgaben

1. **RabbitMQ starten.** Startet RabbitMQ mit `output/project/starter/rabbitmq-compose.yml` und öffnet die Management-UI.

2. **Abhängigkeit ergänzen.** Fügt `pika==1.3.2` zu `requirements.txt` hinzu und installiert sie.

3. **Ereignis-Modelle anlegen.** Erstellt in `app/models.py` `OrderEventPayload` und `OrderCreatedEvent` mit `camelCase`-Alias-Konfiguration gemäß `order-created-event.schema.json` (siehe Theorie).

4. **Publisher-Modul erstellen.** Erstellt `app/events.py` mit einer Funktion `publish_order_created(order: Order) -> None`, die eine Verbindung öffnet, den Exchange `order.events` deklariert und das Ereignis mit Routing Key `order.created` veröffentlicht.

5. **Publisher verdrahten.** Ruft `publish_order_created(...)` in `create_order` (`app/routers/orders.py`) nach dem Speichern der Bestellung auf.

6. **Manuell verifizieren.** Legt über `POST /orders` eine Bestellung an und prüft in der RabbitMQ-Management-UI unter "Exchanges" → `order.events`, dass eine Nachricht veröffentlicht wurde.

## Checkpoint

Nach einem `POST /orders`-Aufruf zeigt die RabbitMQ-Management-UI eine veröffentlichte Nachricht auf dem Exchange `order.events` mit Routing Key `order.created`.

## Abschlusskriterium

Das veröffentlichte Ereignis entspricht `order-created-event.schema.json` (alle Pflichtfelder vorhanden, `camelCase`-Feldnamen im JSON).
