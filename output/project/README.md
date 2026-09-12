# Kursprojekt: Bestell- und Lieferplattform

Dieses Verzeichnis enthält das technische Arbeitsprojekt für die Übungen. Der Java-basierte Order Service bildet den Hauptpfad. Ein vorbereiteter Notification Service mit FastAPI und RabbitMQ ergänzen ihn schrittweise um synchrone und asynchrone Kommunikation.

## Projektfortschritt

Die Arbeitsstände bauen in dieser Reihenfolge aufeinander auf:

1. `starter`: Ausgangspunkt für den Kurs und für E01
2. `e01`: geprüfter Stand nach dem ersten Build, API-Aufruf, Test und einer kleinen Änderung
3. `e04`: geprüfter Stand mit dem in E03 entworfenen Vertrag und den zugehörigen Java-Endpunkten
4. `e10`: Ausgangspunkt für Tests, Fehlerdiagnose und Resilienzarbeit

Die Checkpoint-Stände sind Start- und Wiederherstellungspunkte. Sie ermöglichen den Einstieg in einen späteren Abschnitt oder die Fortsetzung nach einem lokalen Problem. Fachliche Begründungen bleiben in den Begleitdokumenten der jeweiligen Lektion.

## Asset Map nach Uebung

| Uebung | Start- oder Checkpoint-Stand | Vertrag | Arbeitsvorlage | Variante |
| --- | --- | --- | --- | --- |
| E01 | [`starter`](starter/), [`checkpoints/e01`](checkpoints/e01/) | - | [`templates/e01-change-log.md`](templates/e01-change-log.md) | - |
| E02 | [`checkpoints/e01`](checkpoints/e01/) | - | [`templates/e02-context-map.md`](templates/e02-context-map.md) | - |
| E03 | [`checkpoints/e01`](checkpoints/e01/) | [`contracts/order-api.yaml`](contracts/order-api.yaml), [`contracts/notification-api.json`](contracts/notification-api.json) | [`templates/e03-rest-design.md`](templates/e03-rest-design.md) | - |
| E04 | [`checkpoints/e04`](checkpoints/e04/) | [`contracts/order-api.yaml`](contracts/order-api.yaml) | - | - |
| E05 | [`checkpoints/e04`](checkpoints/e04/) | [`contracts/notification-api.json`](contracts/notification-api.json) | [`templates/e05-integration-evidence.md`](templates/e05-integration-evidence.md) | - |
| E06 | [`checkpoints/e10`](checkpoints/e10/) | - | [`templates/e06-messaging-evidence.md`](templates/e06-messaging-evidence.md) | [`variants/e06-consumer-failure`](variants/e06-consumer-failure/) |
| E07 | [`checkpoints/e10`](checkpoints/e10/) | - | [`templates/e07-communication-decision.md`](templates/e07-communication-decision.md) | - |
| E08 | [`checkpoints/e10`](checkpoints/e10/) | - | - | - |
| E09 | [`checkpoints/e10`](checkpoints/e10/) | - | [`templates/e09-diagnosis-log.md`](templates/e09-diagnosis-log.md) | [`variants/e09-broken-service-name`](variants/e09-broken-service-name/) |
| E10 | [`checkpoints/e10`](checkpoints/e10/) | [`contracts/order-api.yaml`](contracts/order-api.yaml), [`contracts/notification-api.json`](contracts/notification-api.json) | [`templates/e10-test-resilience-evidence.md`](templates/e10-test-resilience-evidence.md) | - |
| E11 | [`checkpoints/e10`](checkpoints/e10/) | - | [`templates/e11-production-readiness-plan.md`](templates/e11-production-readiness-plan.md) | - |

## Voraussetzungen und Versionen

| Komponente | Kursversion oder Anforderung |
| --- | --- |
| Betriebssystem | Windows 11 |
| Java Development Kit | Java 21 LTS |
| Spring Boot | 4.1.1 |
| Maven | 3.9.16 |
| Python | 3.12.14 |
| FastAPI | 0.141.1 |
| Uvicorn | 0.52.4 |
| Pika | 1.4.4 |
| RabbitMQ | 4.3.5-management |
| Docker Compose | Compose v2; geprüft mit 5.1.0 |
| Weitere Werkzeuge | Git, Browser und ein API-Client |

Für den ersten Java-Python-Durchstich ist RabbitMQ noch nicht erforderlich. Für die späteren Messaging- und Compose-Übungen muss die lokale Container-Laufzeit verfügbar sein.

## Lokale Ports

| Port | Dienst |
| ---: | --- |
| `8080` | Order Service |
| `8000` | Notification Service |
| `5672` | RabbitMQ AMQP |
| `15672` | RabbitMQ Management-Oberfläche |

Die Ports müssen lokal frei und erreichbar sein. Beende bereits laufende Anwendungen auf diesen Ports, bevor du einen Projektstand startest.

## Mit Checkpoints arbeiten

Arbeite normalerweise im aktuellen Übungsstand weiter. Wenn ein Stand nicht mehr zuverlässig ausführbar ist:

1. Sichere eigene Notizen und noch benötigte Änderungen außerhalb des betroffenen Arbeitsverzeichnisses.
2. Öffne den zuletzt abgeschlossenen Checkpoint oder den für die nächste Übung genannten Startstand.
3. Führe die Prüfungen aus, die in der README dieses Checkpoints beschrieben sind.
4. Übertrage nur eigene, bereits verstandene Änderungen und prüfe nach jedem Schritt erneut.

Ein Checkpoint bestätigt einen definierten Zwischenstand und nimmt die Entscheidungen der folgenden Übungen nicht vorweg.

## Lokale Übungsdaten

Verwende ausschließlich die mitgelieferten anonymisierten Beispieldaten oder selbst erstellte fiktive Werte. Nutze keine Kunden-, Personen-, Unternehmens- oder Produktionsdaten. Das Projekt benötigt keine Cloud-Dienste und legt im vorgesehenen Ablauf keine persistenten Container-Volumes an.

## Befehle

Die passenden Build-, Start-, Test-, Prüf- und Stoppbefehle stehen in der README des jeweiligen Start- oder Checkpoint-Stands. Verwende dort nur die Befehle für den aktuellen Abschnitt, damit Voraussetzungen und erwartbarer Umfang zusammenpassen.