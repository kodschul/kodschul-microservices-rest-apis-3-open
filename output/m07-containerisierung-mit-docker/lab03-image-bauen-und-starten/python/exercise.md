# Übung (Python-Spur): Image bauen und einzeln starten

**Dauer:** ca. 25 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr baut die in Lab 2 erstellten Dockerfiles zu Images und startet sie einzeln, während RabbitMQ weiterhin auf dem Host läuft.

## Voraussetzungen

- Dockerfiles aus Lab 2 in beiden Projekten vorhanden.
- RabbitMQ läuft weiterhin über `output/project/starter/rabbitmq-compose.yml`.

## Aufgaben

1. **Host konfigurierbar machen.** Ersetzt den fest kodierten `host="localhost"` in `app/events.py` (Order-Service) und `app/consumer.py` (Notification-Service) durch `RABBITMQ_HOST = os.environ.get("RABBITMQ_HOST", "localhost")` (siehe Theorie) und verwendet die Variable in der jeweiligen `pika.ConnectionParameters(...)`.

2. **Images bauen.** Baut beide Images wie in der Theorie beschrieben. Notiert die Build-Dauer und die Image-Größe (`docker images | grep order-service`).

3. **Order-Service als Container starten.** Startet den Order-Service-Container mit `RABBITMQ_HOST=host.docker.internal` und prüft `curl http://localhost:8081/health`.

4. **Notification-Service als Container starten.** Wiederholt Aufgabe 3 sinngemäß für den Notification-Service (Port `8091`).

5. **End-to-End im Container bestätigen.** Legt über `POST /orders` (jetzt gegen den containerisierten Order-Service) eine Bestellung an und prüft, dass der containerisierte Notification-Service sie protokolliert.

## Checkpoint

Beide Container laufen, sind über ihre Health-Endpunkte erreichbar, und eine über den containerisierten Order-Service angelegte Bestellung erzeugt eine protokollierte Benachrichtigung im containerisierten Notification-Service.

## Abschlusskriterium

Der End-to-End-Fluss aus Aufgabe 5 funktioniert identisch zum nicht-containerisierten Test aus Modul 6.
