---
theme: default
---

# Lab 2 (Python-Spur): Gesamten Stack starten

## Lernziel

Nach diesem Lab startet ihr die komplette Bestell-Plattform (RabbitMQ, Order-Service, Notification-Service) mit einem einzigen Befehl.

## Leitfragen

1. Wie unterscheidet sich `docker compose up` von den einzelnen `docker run`-Befehlen aus Modul 7?
2. Wie liest man die Startreihenfolge und den Zustand aus der Compose-Ausgabe ab?

## Stack starten

```bash
docker compose up --build
```

`--build` erzwingt einen Neu-Build der Images, falls sich Dockerfiles oder Quellcode seit dem letzten Build geändert haben. Compose startet die Services in der durch `depends_on` vorgegebenen Reihenfolge und wartet bei `condition: service_healthy` auf einen bestandenen Healthcheck, bevor es abhängige Services startet.

## Zustand prüfen

```bash
docker compose ps
```

Zeigt für jeden Service Status (`running`) und Health-Zustand (`healthy`, `starting`, `unhealthy`).

## Im Hintergrund starten und Logs verfolgen

```bash
docker compose up -d --build
docker compose logs -f notification-service
```

## Checkpoint

Ihr könnt den gesamten Stack mit einem Befehl starten und den Health-Zustand aller Services über `docker compose ps` ablesen.
