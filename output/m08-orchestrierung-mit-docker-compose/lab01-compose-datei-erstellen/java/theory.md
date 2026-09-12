---
theme: default
---

# Lab 1 (Java-Spur): Docker-Compose-Datei erstellen

## Lernziel

Nach diesem Lab könnt ihr Order-Service, Notification-Service und RabbitMQ mit einer einzigen Docker-Compose-Datei gemeinsam beschreiben.

## Leitfragen

1. Wie ersetzt Docker Compose die manuellen `docker run`-Befehle aus Modul 7?
2. Wie kommunizieren Services in einem Compose-Netzwerk miteinander?

## Vom manuellen Start zu Compose

In Modul 7 habt ihr jeden Container einzeln mit `docker run` gestartet und `host.docker.internal` genutzt, um RabbitMQ auf dem Host zu erreichen. Mit Docker Compose laufen **alle Services im selben, von Compose verwalteten Netzwerk** - sie erreichen sich gegenseitig über ihren **Servicenamen** als Hostnamen, ganz ohne `host.docker.internal`.

## Grundgerüst einer Compose-Datei

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

- `build: ./order-service` baut das Image aus dem Dockerfile aus Modul 7, statt ein vorgebautes Image zu referenzieren.
- `SPRING_RABBITMQ_HOST: rabbitmq` nutzt den **Servicenamen** `rabbitmq` als Hostnamen - Compose löst ihn intern auf.
- `depends_on` mit `condition: service_healthy` sorgt dafür, dass die Services erst starten, wenn RabbitMQ den Healthcheck besteht.

## Checkpoint

Ihr könnt eine Compose-Datei mit mehreren Services schreiben, die per Servicename statt `host.docker.internal` miteinander kommunizieren.
