# Übung (Java-Spur): Docker-Compose-Datei erstellen

**Dauer:** ca. 35 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr beschreibt die gesamte Bestell-Plattform (RabbitMQ, Order-Service, Notification-Service) in einer gemeinsamen `compose.yaml`.

## Voraussetzungen

- Dockerfiles aus Modul 7 in beiden Projekten vorhanden.
- Beide Projekte liegen in Unterordnern eines gemeinsamen Wurzelverzeichnisses (`order-service/`, `notification-service/`).

## Aufgaben

1. **Compose-Datei anlegen.** Erstellt `compose.yaml` im gemeinsamen Wurzelverzeichnis mit den drei Services aus der Theorie.

2. **Umgebungsvariablen ergänzen.** Prüft, dass `SPRING_RABBITMQ_HOST` bei beiden Java-Services auf `rabbitmq` (den Servicenamen) zeigt, nicht auf `localhost` oder `host.docker.internal`.

3. **Healthcheck für Order-Service ergänzen.** Fügt dem `order-service` einen Healthcheck über `/actuator/health` hinzu, analog zum RabbitMQ-Healthcheck aus der Theorie (Werkzeug: `curl` oder `wget` im Container - prüft in eurem Dockerfile, ob eines davon verfügbar ist, oder ergänzt es).

4. **Struktur begründen.** Erklärt in 2-3 Sätzen, warum `depends_on` mit `condition: service_healthy` hier wichtiger ist als ein einfaches `depends_on` ohne Bedingung.

## Checkpoint

`compose.yaml` enthält alle drei Services mit korrekten Umgebungsvariablen und mindestens zwei Healthchecks (RabbitMQ, Order-Service).

## Abschlusskriterium

Die Datei ist syntaktisch gültiges YAML und referenziert für Order-Service und Notification-Service jeweils `build: ./<verzeichnis>` statt eines vorgebauten Images.
