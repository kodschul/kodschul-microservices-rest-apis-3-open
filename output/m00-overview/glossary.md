# Glossar

Alphabetisches Nachschlagewerk für Begriffe der Bestell-Plattform (Order- und Notification-Service) über alle neun Module.

| Begriff / Abkürzung | Bereich | Verwendet für | Primäre Rolle | Vorkommen |
| --- | --- | --- | --- | --- |
| 422-vs-400-Konflikt | REST/Validierung | FastAPI liefert bei Validierungsfehlern standardmäßig `422`, der Vertrag verlangt `400` - erfordert einen eigenen Exception-Handler | Python-Spur | M2 |
| Agile Softwareentwicklung | Vorgehen | kurze Zyklen mit nutzbaren Zwischenergebnissen, wie die modulare Kursstruktur selbst | alle | M9 |
| AMQP (Advanced Message Queuing Protocol) | Messaging | Übertragungsprotokoll, das RabbitMQ implementiert | alle | M5, M6 |
| At-least-once-Zustellung | Messaging | RabbitMQ-Standardverhalten; Nachrichten können doppelt zugestellt werden | alle | M6, M9 |
| Autoscaling (Cloud-Autoscaling) | Skalierung | automatisches Hinzufügen/Entfernen von Instanzen nach Lastmetriken | Architekt:in | M4 |
| Backoff (Exponential Backoff) | Resilienz | wachsende Wartezeit zwischen Wiederholungsversuchen | alle | M9 |
| Baseline / Erweiterung | Didaktik | Pflichtaufgabe vs. optionale Vertiefung für schnellere Teilnehmende | alle | alle Module |
| Bestell-Plattform | Referenzszenario | Order-, Inventory- und Notification-Funktionalität des durchgängigen Kursprojekts | alle | alle Module |
| Blue-Green Deployment | Deployment | zwei parallele Umgebungen, schlagartige Umschaltung, schneller Rollback | Architekt:in | M9 |
| camelCase-Alias | Datenformat | `alias_generator=to_camel`/`populate_by_name=True` in Pydantic für vertragskonformes JSON bei intern `snake_case` gehaltenen Python-Attributen | Python-Spur | M2, M5, M6, M9 |
| Canary Deployment | Deployment | neue Version erhält zunächst nur einen kleinen Traffic-Anteil | Architekt:in | M9 |
| Checkpoint (`CHECKPOINT.md`) | Betrieb | dokumentierter, reproduzierbarer Nachweis (Status, Erreichbarkeit, funktionaler Nachweis) | alle | M8 |
| CI/CD (Continuous Integration/Continuous Deployment) | DevOps | automatisiertes Bauen, Testen und Ausliefern von Änderungen | alle | M9 |
| Consumer | Messaging | Komponente, die Nachrichten aus einer Queue entgegennimmt und verarbeitet | alle | M6 |
| Contract-first | API-Design | der REST-Vertrag entsteht vor der Implementierung und ist für beide Spuren identisch verbindlich | alle | M2 |
| Contract-Test | Test | prüft, ob eine Implementierung einem vereinbarten Vertrag entspricht | alle | M9 |
| Dead-Letter-Exchange/-Queue | Messaging | Ziel für Nachrichten, die nach mehreren Fehlversuchen nicht regulär verarbeitet wurden | alle | M6 |
| DevOps | Vorgehen | enge Verzahnung von Entwicklung und Betrieb, sichtbar an der Verantwortung für Code (M1-M6) und Betrieb (M7-M9) | alle | M9 |
| Docker Compose | Betrieb | Beschreibung und gemeinsamer Start mehrerer Container-Services über eine Datei | alle | M8 |
| Dockerfile | Betrieb | reproduzierbare Bauanleitung für ein Container-Image | alle | M7 |
| `.dockerignore` | Betrieb | schließt unnötige Dateien vom Docker-Build-Kontext aus | alle | M7 |
| Dual-Track | Kursformat | Java/Spring Boot und Python/FastAPI als vollständig parallele, gleichwertige Spuren | alle | Kursweit |
| Envelope (Ereignis-Umschlag) | Messaging | technischer Rahmen eines Ereignisses (`eventId`, `eventType`, `occurredAt`), unabhängig von der fachlichen Nutzlast | alle | M5 |
| Event-Carried State Transfer | EDA | Ereignis trägt bereits alle vom Konsumenten benötigten Daten | alle | M5 |
| Event-Driven Architecture (EDA) | Architektur | Architekturstil, in dem Ereignisse Interaktionen zwischen Services auslösen | Architekt:in | M5 |
| Event Notification | EDA | schlankes Ereignis, das nur "etwas ist passiert" mitteilt | Architekt:in | M5 |
| Exchange (Topic Exchange) | Messaging | RabbitMQ-Komponente, die Nachrichten nach Routing Key an Queues verteilt | alle | M5, M6 |
| FastAPI | Python-Framework | Web-Framework der Python-Spur; erzeugt OpenAPI automatisch aus Typannotationen | Python-Spur | M1-M9 |
| Health-Endpunkt / Healthcheck | Betrieb | technischer Nachweis, dass ein Service oder Container betriebsbereit ist | alle | M1, M6, M8 |
| Horizontale Skalierung | Skalierung | zusätzliche, gleichwertige Instanzen eines Services hinter einem Load Balancer | Architekt:in | M4 |
| HTTP-Statuscode | REST | standardisierte Aussage über das Ergebnis eines HTTP-Aufrufs (z. B. 201, 400, 404) | alle | M2, M3 |
| Idempotenz | Resilienz | Eigenschaft, bei wiederholter Verarbeitung keine zusätzliche fachliche Wirkung zu erzeugen | alle | M6, M9 |
| In-Memory-Speicher | Datenhaltung | prozesslokale, bewusst einfache Speicherung ohne Datenbank; Ursache sichtbarer Grenzen bei Skalierung und Neustart | alle | M2, M4, M8 |
| JSON Schema | Vertrag | maschinenlesbare Beschreibung eines Ereignis- oder Datenformats | alle | M5 |
| Korrelations-ID | Betrieb | gemeinsame Kennung (z. B. Bestell-ID), mit der sich ein Vorgang über mehrere Services hinweg in Logs verfolgen lässt | alle | M9 |
| Load Balancer / Load Balancing | Skalierung | verteilt Anfragen auf mehrere Service-Instanzen | Architekt:in | M4 |
| Messaging-Vertrag (`messaging-contract.md`) | Vertrag | legt Exchange, Routing Key, Queue und Zustellgarantie sprachneutral verbindlich fest | alle | M5, M6 |
| Monitoring-/Logging-Konzept | Betrieb | Skizze zu Health-Signalen, fachlichen Metriken, Fehler-Sichtbarkeit und Log-Korrelation | alle | M9 |
| Multi-Stage-Build | Betrieb | trennt Build-Umgebung von schlanker Laufzeitumgebung im selben Dockerfile | Java-Spur | M7 |
| Notification-Service | Architektur | zweiter implementierter Service; konsumiert Bestellereignisse und protokolliert Benachrichtigungen | alle | M1, M6-M9 |
| OpenAPI / Swagger | API-Dokumentation | maschinenlesbare Spezifikation einer REST-API und ihre interaktive Oberfläche (Swagger UI) | alle | M3 |
| Order-Service | Architektur | vollständig implementierter Kern-Service der Bestell-Plattform | alle | M1-M9 |
| Publish/Subscribe | EDA | ein Sender veröffentlicht Ereignisse, beliebig viele Empfänger abonnieren sie | Architekt:in | M5 |
| Queue | Messaging | geordneter Puffer für zuzustellende Nachrichten, hier `notification.order-created` | alle | M5, M6 |
| RabbitMQ | Messaging | Message Broker, der Order- und Notification-Service asynchron verbindet | alle | M5, M6, M8, M9 |
| Retry-Muster | Resilienz | automatische Wiederholung einer fehlgeschlagenen Operation bei vorübergehenden Fehlern | alle | M9 |
| Rolling Deployment | Deployment | Instanzen werden nach und nach durch eine neue Version ersetzt | Architekt:in | M9 |
| Routing Key | Messaging | Zeichenkette (`order.created`), nach der ein Topic-Exchange Nachrichten weiterleitet | alle | M5, M6 |
| Servicegrenze | Architektur | Abgrenzung von Verantwortung und Datenhoheit zwischen Services | alle | M1 |
| Servicename (statt `host.docker.internal`) | Betrieb | Hostname, über den sich Services innerhalb eines Compose-Netzwerks gegenseitig erreichen | alle | M8 |
| Spring Boot | Java-Framework | Web-Framework der Java-Spur; nutzt springdoc-openapi zur Dokumentationserzeugung | Java-Spur | M1-M9 |
| Swagger UI / `/docs` / `/redoc` | API-Dokumentation | interaktive bzw. rein lesende Oberfläche zur API-Erkundung | alle | M3 |
| Testarten (Unit/Integration/Contract/End-to-End) | Test | vier im Kurs unterschiedene Prüfebenen, vom isolierten Funktionstest bis zum Gesamtablauf | alle | M9 |
| Timeout-Muster | Resilienz | expliziter Verbindungs-/Wartezeit-Grenzwert, damit ein nicht erreichbarer Dienst nicht unbegrenzt blockiert | alle | M9 |
| Vertikale Skalierung | Skalierung | mehr Rechenressourcen für eine bestehende Instanz | Architekt:in | M4 |

## Schreibweisen

- Produktnamen werden als **Spring Boot**, **FastAPI**, **RabbitMQ** und **Docker Compose** geschrieben.
- Alle REST- und Ereignis-Payloads verwenden im JSON konsequent `camelCase` (z. B. `customerName`, `itemName`).
- Der Order-Service läuft standardmäßig auf Port `8081`, der Notification-Service auf Port `8091`, RabbitMQ auf `5672`/`15672`.
- Das fachliche Ereignis heißt `order.created`, transportiert im Exchange `order.events`.
