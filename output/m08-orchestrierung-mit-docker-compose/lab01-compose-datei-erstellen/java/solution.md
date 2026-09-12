# Lösung (Java-Spur): Docker-Compose-Datei erstellen

## `compose.yaml`

```yaml
services:
  rabbitmq:
    image: rabbitmq:3.13-management
    ports:
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: kodschul
      RABBITMQ_DEFAULT_PASS: kodschul
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "-q", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  order-service:
    build: ./order-service
    ports:
      - "8081:8081"
    environment:
      SPRING_RABBITMQ_HOST: rabbitmq
    depends_on:
      rabbitmq:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:8081/actuator/health"]
      interval: 10s
      timeout: 5s
      retries: 5

  notification-service:
    build: ./notification-service
    ports:
      - "8091:8091"
    environment:
      SPRING_RABBITMQ_HOST: rabbitmq
    depends_on:
      rabbitmq:
        condition: service_healthy
```

*Hinweis:* `eclipse-temurin:17-jre-alpine` enthält `wget` standardmäßig; falls euer Basis-Image das nicht tut, `curl` oder `wget` im Dockerfile nachinstallieren oder auf `wget` verzichten und stattdessen einen Healthcheck auf Basis eines eigenen kleinen Skripts verwenden.

## Aufgabe 4: Begründung

Ohne `condition: service_healthy` startet Compose die abhängigen Services, sobald der RabbitMQ-**Container** existiert - nicht erst, wenn RabbitMQ tatsächlich Verbindungen annehmen kann. RabbitMQ braucht nach dem Containerstart einige Sekunden, bis es bereit ist; ohne die Bedingung würden Order-Service und Notification-Service in dieser Zeit vergeblich versuchen, sich zu verbinden, und könnten je nach Implementierung dauerhaft fehlschlagen statt automatisch erneut zu versuchen.
