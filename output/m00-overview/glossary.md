# Glossar

Die Begriffe beziehen sich auf die Bestell- und Lieferplattform aus der Kursübersicht.

| Begriff | Bereich | Bedeutung im Kurs | Vorkommen |
| --- | --- | --- | --- |
| AMQP (Advanced Message Queuing Protocol) | Messaging | Protokoll für den Nachrichtenaustausch mit RabbitMQ | M05 |
| API (Application Programming Interface) | Schnittstelle | definierter Zugang zu Funktionen und Daten eines Services | M01–M04 |
| API Contract | Schnittstelle | überprüfbare Vereinbarung über Requests, Responses und Fehler | M03–M04 |
| Backoff | Resilienz | zunehmende Wartezeit zwischen begrenzten Wiederholungen | M07 |
| Boundary Case | Test | gültiger oder ungültiger Fall an einer festgelegten Grenze | M03, M07 |
| Consumer | Messaging | Komponente, die Nachrichten aus einer Queue verarbeitet | M05 |
| Container | Betrieb | isolierter Prozess aus einem reproduzierbaren Image | M06 |
| Context Map | Architektur | Darstellung fachlicher Bereiche und ihrer Beziehungen | M02 |
| Contract Test | Test | Prüfung, ob Implementierung und vereinbarte Schnittstelle zusammenpassen | M03, M07 |
| Docker Compose | Betrieb | Beschreibung und gemeinsamer Betrieb mehrerer Container-Services | M06 |
| Dockerfile | Betrieb | reproduzierbare Anleitung zum Bau eines Container-Images | M06 |
| Downstream Service | Integration | Service, den ein anderer Service aufruft | M04, M07 |
| Event | Messaging | fachliche Mitteilung über etwas bereits Geschehenes | M05 |
| Event-Driven Architecture | Architektur | Architektur, in der Ereignisse Interaktionen auslösen | M05 |
| FastAPI | Python | Framework des vorbereiteten Notification Service | M04 |
| Healthcheck | Betrieb | technische Prüfung, ob ein Service erreichbar oder betriebsbereit ist | M06–M07 |
| HTTP Statuscode | REST | standardisierte Aussage über das Ergebnis eines HTTP-Aufrufs | M01, M03 |
| Idempotenz | Resilienz | Eigenschaft, bei wiederholter Verarbeitung keine zusätzliche Wirkung zu erzeugen | M07 |
| Image | Betrieb | unveränderliche Vorlage für einen Container | M06 |
| Integration Test | Test | Prüfung des Zusammenspiels mehrerer Komponenten | M04, M07 |
| JSON (JavaScript Object Notation) | Datenformat | primäres Austauschformat der Kurs-APIs und Events | M03–M05 |
| Load Balancing | Skalierung | Verteilung von Anfragen auf mehrere Instanzen | M08 |
| Microservice | Architektur | eigenständig betreibbare Einheit mit klarer fachlicher Verantwortung | M02 |
| Monolith | Architektur | gemeinsam entwickelte und betriebene Anwendungseinheit | M02 |
| OpenAPI | Schnittstelle | maschinenlesbare Beschreibung einer HTTP API | M03–M04 |
| Producer | Messaging | Komponente, die Nachrichten veröffentlicht | M05 |
| Queue | Messaging | geordneter Puffer für zu verarbeitende Nachrichten | M05 |
| RabbitMQ | Messaging | Message Broker für den Ereignisfluss im Referenzprojekt | M05–M06 |
| REST (Representational State Transfer) | Schnittstelle | Architekturstil für ressourcenorientierte HTTP-Schnittstellen | M03 |
| Retry | Resilienz | kontrollierte Wiederholung einer fehlgeschlagenen Operation | M07 |
| Service Boundary | Architektur | Grenze von Verantwortung, Datenhoheit und Änderungsbedarf | M02 |
| Spring Boot | Java | Framework des Order Service | M01–M07 |
| Timeout | Resilienz | maximale Wartezeit auf eine Operation oder Antwort | M07 |
| Unit Test | Test | schnelle Prüfung einer kleinen Codeeinheit in Isolation | M01, M07 |
| Vertical Slice | Integration | kleinster durchgängiger Pfad durch beteiligte Komponenten | M04 |
| Vertikale Skalierung | Skalierung | mehr Ressourcen für eine bestehende Instanz | M08 |
| Horizontale Skalierung | Skalierung | zusätzliche Instanzen derselben Anwendung | M08 |

## Schreibweisen

- Produktnamen werden als **Spring Boot**, **FastAPI**, **RabbitMQ** und **Docker Compose** geschrieben.
- API-Payloads und Events verwenden im Kurs JSON.
- Der fachliche Ereignisname lautet `OrderDispatched`.
- Der Java-Service heißt **Order Service**, der Python-Service **Notification Service**.