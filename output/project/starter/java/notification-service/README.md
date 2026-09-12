# Notification-Service (Java-Spur) - Starterprojekt

Minimales Spring-Boot-3-Projekt mit `spring-boot-starter-amqp`. Enthält nur die Projektstruktur und Actuator-Healthcheck; der RabbitMQ-Consumer wird in Modul 6 ergänzt.

## Voraussetzungen

- JDK 17, Maven 3.9+
- Laufende RabbitMQ-Instanz (`output/project/starter/rabbitmq-compose.yml`)

## Starten

```bash
mvn spring-boot:run
```

Health-Check:

```bash
curl http://localhost:8091/actuator/health
```
