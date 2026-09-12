# Lösung (Python-Spur): Docker-Compose-Datei erstellen

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
      RABBITMQ_HOST: rabbitmq
    depends_on:
      rabbitmq:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8081/health')"]
      interval: 10s
      timeout: 5s
      retries: 5

  notification-service:
    build: ./notification-service
    ports:
      - "8091:8091"
    environment:
      RABBITMQ_HOST: rabbitmq
    depends_on:
      rabbitmq:
        condition: service_healthy
```

## Aufgabe 4: Begründung

Ohne `condition: service_healthy` startet Compose die abhängigen Services, sobald der RabbitMQ-**Container** existiert - nicht erst, wenn RabbitMQ tatsächlich Verbindungen annehmen kann. RabbitMQ braucht nach dem Containerstart einige Sekunden, bis es bereit ist; ohne die Bedingung würden Order-Service und Notification-Service beim ersten Verbindungsversuch scheitern, statt automatisch zu warten.
