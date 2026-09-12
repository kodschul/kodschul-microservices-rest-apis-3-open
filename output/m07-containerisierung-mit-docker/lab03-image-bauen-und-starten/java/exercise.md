# Übung (Java-Spur): Image bauen und einzeln starten

**Dauer:** ca. 25 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr baut die in Lab 2 erstellten Dockerfiles zu Images und startet sie einzeln, während RabbitMQ weiterhin auf dem Host läuft.

## Voraussetzungen

- Dockerfiles aus Lab 2 in beiden Projekten vorhanden.
- RabbitMQ läuft weiterhin über `output/project/starter/rabbitmq-compose.yml`.

## Aufgaben

1. **Images bauen.** Baut beide Images wie in der Theorie beschrieben. Notiert die Build-Dauer und die Image-Größe (`docker images | grep order-service`).

2. **Order-Service als Container starten.** Startet den Order-Service-Container mit den Umgebungsvariablen aus der Theorie und prüft `curl http://localhost:8081/actuator/health`.

3. **Notification-Service als Container starten.** Wiederholt Aufgabe 2 sinngemäß für den Notification-Service (Port `8091`, `SPRING_RABBITMQ_HOST=host.docker.internal`).

4. **End-to-End im Container bestätigen.** Legt über `POST /orders` (jetzt gegen den containerisierten Order-Service) eine Bestellung an und prüft, dass der containerisierte Notification-Service sie protokolliert.

## Checkpoint

Beide Container laufen, sind über ihre Health-Endpunkte erreichbar, und eine über den containerisierten Order-Service angelegte Bestellung erzeugt eine protokollierte Benachrichtigung im containerisierten Notification-Service.

## Abschlusskriterium

Der End-to-End-Fluss aus Aufgabe 4 funktioniert identisch zum nicht-containerisierten Test aus Modul 6.
