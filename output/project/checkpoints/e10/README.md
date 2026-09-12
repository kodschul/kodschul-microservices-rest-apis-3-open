# Checkpoint E10: Tests und Resilienz

Dieser Wiederaufnahmestand enthaelt den vollstaendigen Pflichtstand aus M01 bis M07. Er dient als stabiler Startpunkt vor M08 und nimmt keine Entscheidung einer einzelnen Aufgabe vorweg.

## Enthaltener Stand

- Java 21 und Spring Boot 4.1.1 fuer Bestellungen, Validierung und Versandereignisse
- FastAPI 0.141.1 fuer Benachrichtigungen und die Beobachtung konsumierter Ereignisse
- synchrone Java-Python-Kommunikation mit 500 ms Verbindungs- und 1 s Antwort-Timeout
- durable RabbitMQ-Queue `order.events` mit JSON-Ereignissen vom Typ `OrderDispatched`
- OpenAPI-Vertraege fuer Order und Notification
- automatisierte Unit-, API-, Vertrags- und Smoke-Tests

Im Basisstand ist keine absichtliche Stoerung aktiviert. Reversible Fehlerfaelle fuer E06 und E09 liegen unter [`../../variants`](../../variants/). Der Smoke-Test stoppt den Notification Service kontrolliert, prueft den begrenzten Fehlerpfad und startet ihn anschliessend wieder.

## Voraussetzungen

- Docker mit Compose-Unterstuetzung fuer den Gesamtfluss
- alternativ Java 21 und Maven 3.9.16 fuer Java-Tests
- alternativ Python 3.12 fuer Python-Tests

Die Skripte verwenden `.env.example` mit lokalen Beispielwerten. Fuer eine eigene Umgebung kann eine separate Umgebungsdatei mit abweichenden Werten verwendet werden.

## Tests ohne Container

Java im Verzeichnis `order-service`:

```powershell
mvn test
```

Python im Verzeichnis `notification-service`:

```powershell
python -m venv "$env:TEMP\e10-venv"
& "$env:TEMP\e10-venv\Scripts\python.exe" -m pip install -r requirements.txt
& "$env:TEMP\e10-venv\Scripts\python.exe" -m pytest
```

Die Python-Umgebung bleibt ausserhalb dieses Checkpoints. Unter POSIX-Systemen werden die entsprechenden Befehle mit einer temporaeren Umgebung und deren `bin/python` ausgefuehrt.

## Gesamtlandschaft starten und pruefen

PowerShell:

```powershell
./scripts/start.ps1
./scripts/smoke.ps1
./scripts/stop.ps1
```

POSIX-Shell:

```sh
./scripts/start.sh
./scripts/smoke.sh
./scripts/stop.sh
```

Der Smoke-Test erwartet folgende beobachtbare Ergebnisse:

| Fall | Ergebnis |
| --- | --- |
| Notification Health | `200` und Status `UP` |
| gueltige Bestellung | `201`, Status `created`, Benachrichtigung `accepted` |
| Menge `0` | `400` und Code `INVALID_ORDER` |
| Versand | `202`; das JSON-Ereignis erscheint unter `/events` |
| gestoppter Notification Service | `502` und Code `DOWNSTREAM_UNAVAILABLE` innerhalb der begrenzten Wartezeit |

## Ports

| Dienst | Port |
| --- | ---: |
| Order Service | 8080 |
| Notification Service | 8000 |
| RabbitMQ AMQP | 5672 |
| RabbitMQ Management | 15672 |

## Aufraeumen

`stop.ps1` oder `stop.sh` entfernt die Checkpoint-Container und verwaiste Compose-Ressourcen. Bei einem abgebrochenen Test sollte der Stop-Befehl erneut ausgefuehrt werden, bevor Ports oder Container anderweitig verwendet werden.

## Uebergang zu M08

E10 liefert getestetes Verhalten und reproduzierbare Fehler-Evidenz. M08 nutzt diesen Stand fuer Skalierungs-, Delivery- und Produktionsreife-Entscheidungen; diese Themen sind bewusst noch nicht in diesem Checkpoint umgesetzt.