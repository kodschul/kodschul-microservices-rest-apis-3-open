# Übung (Java-Spur): RabbitMQ einrichten und Ereignis publizieren

**Dauer:** ca. 60 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr richtet RabbitMQ lokal ein und erweitert den Order-Service so, dass er bei jeder neuen Bestellung ein Ereignis gemäß `output/project/contracts/messaging-contract.md` publiziert.

## Voraussetzungen

- Order-Service aus Modul 2/3 (Java-Spur).
- Docker lokal verfügbar.
- `output/project/contracts/order-created-event.schema.json` und `messaging-contract.md` gelesen.

## Aufgaben

1. **RabbitMQ starten.** Startet RabbitMQ mit `output/project/starter/rabbitmq-compose.yml` und öffnet die Management-UI.

2. **Abhängigkeit und Konfiguration ergänzen.** Fügt `spring-boot-starter-amqp` zu `pom.xml` hinzu und ergänzt `application.yml` um `spring.rabbitmq.host: localhost`, `port: 5672`, `username: kodschul`, `password: kodschul`.

3. **Exchange und Message-Konverter deklarieren.** Erstellt `RabbitMQConfig` mit dem `order.events`-Topic-Exchange und einem `Jackson2JsonMessageConverter`-Bean (siehe Theorie).

4. **Ereignis-Klassen anlegen.** Erstellt `OrderCreatedEvent` und `OrderEventPayload` gemäß `order-created-event.schema.json` (Felder `eventId`, `eventType`, `occurredAt`, `order` mit `orderId`, `customerName`, `itemName`, `quantity`, `status`).

5. **Publisher implementieren und verdrahten.** Erstellt `OrderEventPublisher` (siehe Theorie) und ruft ihn in `OrderController.createOrder` nach dem Speichern der Bestellung auf.

6. **Manuell verifizieren.** Legt über `POST /orders` eine Bestellung an und prüft in der RabbitMQ-Management-UI unter "Exchanges" → `order.events` → "Publish message rate", dass eine Nachricht veröffentlicht wurde.

## Checkpoint

Nach einem `POST /orders`-Aufruf zeigt die RabbitMQ-Management-UI eine veröffentlichte Nachricht auf dem Exchange `order.events` mit Routing Key `order.created`.

## Abschlusskriterium

Das veröffentlichte Ereignis entspricht `order-created-event.schema.json` (alle Pflichtfelder vorhanden, `camelCase`-Feldnamen).
