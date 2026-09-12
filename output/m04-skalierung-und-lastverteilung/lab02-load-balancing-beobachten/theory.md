---
theme: default
---

# Lab 2: Load Balancing beobachten

## Lernziel

Nach diesem Lab habt ihr mehrere Instanzen eures Order-Service hinter einem einfachen Load Balancer beobachtet und wisst, welche Grenzen die aktuelle In-Memory-Speicherung dabei sichtbar macht.

## Leitfragen

1. Wie verteilt ein einfacher Load Balancer Anfragen auf mehrere Instanzen?
2. Was passiert mit dem Zustand, wenn zwei Instanzen unabhängige In-Memory-Speicher haben?

## Sandbox statt Produktionscode

Dieses Lab ist eine **Sandbox-Übung**: Ihr verändert nicht euer Kursprojekt dauerhaft, sondern startet zusätzliche, temporäre Instanzen zu Beobachtungszwecken. Kein Checkpoint aus diesem Lab wird in Modul 5/6 vorausgesetzt.

## Zwei Instanzen desselben Service starten

- **Java:** `mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082` in einem zweiten Terminal (die erste Instanz bleibt auf 8081 laufen).
- **Python:** `uvicorn app.main:app --port 8082` in einem zweiten Terminal (mit aktivierter virtueller Umgebung, die erste Instanz bleibt auf 8081 laufen).

## Ein einfacher Load Balancer mit nginx

`output/project/starter/nginx/loadbalancer.conf` verteilt Anfragen abwechselnd (round robin) auf Port 8081 und 8082:

```bash
docker run --rm -p 8080:8080 \
  -v "$PWD/output/project/starter/nginx/loadbalancer.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:1.27
```

`host.docker.internal` in der Konfiguration löst den Host-Rechner aus dem Container heraus auf (Docker Desktop). Unter nativem Docker Engine (z. B. Linux) ergänzt ihr `--add-host=host.docker.internal:host-gateway` am `docker run`-Befehl, oder ersetzt `host.docker.internal` durch die tatsächliche Host-IP.

## Checkpoint

Ihr könnt mehrfache Anfragen an `http://localhost:8080` senden und beobachten, dass sie abwechselnd von beiden Instanzen beantwortet werden.
