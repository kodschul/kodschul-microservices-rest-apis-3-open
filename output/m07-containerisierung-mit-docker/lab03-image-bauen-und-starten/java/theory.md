---
theme: default
---

# Lab 3 (Java-Spur): Image bauen und einzeln starten

## Lernziel

Nach diesem Lab habt ihr Order-Service und Notification-Service als Docker-Images gebaut und einzeln lauffähig gestartet.

## Leitfragen

1. Wie baut man ein Image aus einem Dockerfile?
2. Wie verbindet sich ein Container mit einer auf dem Host laufenden RabbitMQ-Instanz?

## Image bauen

```bash
docker build -t order-service:0.1.0 ./order-service
docker build -t notification-service:0.1.0 ./notification-service
```

## Container einzeln starten

```bash
docker run --rm -p 8081:8081 \
  --add-host=host.docker.internal:host-gateway \
  -e SPRING_RABBITMQ_HOST=host.docker.internal \
  order-service:0.1.0
```

`--add-host=host.docker.internal:host-gateway` ist unter Docker Desktop nicht zwingend nötig, schadet aber nicht und macht den Befehl auch unter nativem Docker Engine (z. B. Linux) funktionsfähig (vgl. Modul 3, Lab 3).

## Checkpoint

Ihr könnt beide Images bauen und Order-Service sowie Notification-Service jeweils als eigenständigen Container starten, der sich erfolgreich mit der auf dem Host laufenden RabbitMQ-Instanz verbindet.
