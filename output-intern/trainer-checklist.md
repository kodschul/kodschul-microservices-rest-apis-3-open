# Trainer-Checkliste

Stand: vollständiger Kurs (M1-M9).

## Vor Kursbeginn (einmalig, alle Tage betreffend)

- [ ] Preflight-Check je Teilnehmendem: Docker-Funktionsfähigkeit, freie lokale Ports (8081, 8091, 5672, 15672), Zugriff auf Maven Central und PyPI.
- [ ] Java-/Python-Erfahrungsniveau je Teilnehmendem ist laut Trainerentscheidung bewusst nicht separat erhoben worden (siehe `03-feedback.md`, Iteration 3) - bei Bedarf informell zu Kursbeginn abfragen, um die Trackwahl zu erleichtern.
- [ ] Videokonferenz-Tool und Screen-Sharing-Setup festgelegt.
- [ ] Alle vier Starterprojekte (`order-service`, `notification-service`, je Java und Python) lokal getestet (Start, Health-Check).
- [ ] `output/project/contracts/order-api.yaml`, `order-created-event.schema.json` und `messaging-contract.md` auf Konsistenz geprüft (gleiche Feldnamen, `camelCase`).

## Tag 1 - Setup und Fallbacks

- [ ] JDK 17 und Maven 3.9+ (Java-Spur) bzw. Python 3.11+ (Python-Spur) auf Trainer-Referenzmaschine verifiziert.
- [ ] Docker-Image für `openapitools/openapi-generator-cli` vorab gezogen (`docker pull openapitools/openapi-generator-cli`), um Wartezeiten in M3-L3 zu vermeiden.
- [ ] Fallback für M3-L3 vorbereitet: fertig generierter `generated-client`-Ordner als Download, falls Docker bei einzelnen Teilnehmenden nicht funktioniert.
- [ ] Bei Teilnehmenden mit nativem Docker Engine (z. B. Linux statt Docker Desktop): Hinweis geben, dass der `docker run`-Befehl in M3-L3 um `--add-host=host.docker.internal:host-gateway` ergänzt werden muss (bereits in `theory.md`/`solution.md` beider Spuren dokumentiert).
- [ ] Swagger UI (Java: `/swagger-ui.html`, Python: `/docs`) auf Referenzmaschine geöffnet und Screenshot als Backup erstellt (M3-L2-Fallback).

## Zeitpuffer und Kürzungsoptionen Tag 1

Bei Zeitdruck zuerst kürzen (siehe `02-plan.md`, Timing Validation):

1. M2-L2-Erweiterung "weitere Ressourcen" (optional, entfällt zuerst),
2. M3-L3-Erweiterung "Dokumentation gemeinsam reviewen" (optional, entfällt als zweites),
3. M3-L1/L2/L3 sind bereits knapp bemessen (15 Min); nicht weiter kürzen, stattdessen bei Bedarf den Rückblick zu Beginn von Tag 2 verkürzen.

## Übergänge und Tagesabschluss

- Tagesabschluss Tag 1, 16:15-16:30: Ergebnis sichern lassen (Order-Service läuft, REST-API dokumentiert), offene Fragen sammeln, Ausblick auf Skalierung/Messaging (Tag 2) geben.
- Tagesabschluss Tag 2, 16:15-16:30: Ergebnis sichern lassen (asynchrone Kommunikation funktioniert), offene Fragen sammeln, Ausblick auf Container/Compose (Tag 3) geben.
- Kursabschluss Tag 3, 16:10-16:30: Capstone-Ergebnisse würdigen, offene Fragen sammeln, Feedback einholen, Verabschiedung.

## Tag 2 - Setup und Fallbacks

- [ ] `output/project/starter/rabbitmq-compose.yml` vorab getestet; RabbitMQ-Image (`rabbitmq:3.13-management`) vorab gezogen.
- [ ] Beide Notification-Service-Starter (`output/project/starter/java/notification-service/`, `.../python/notification-service/`) lokal getestet.
- [ ] Fallback für M4-L2 (Load Balancing): nginx-Image (`nginx:1.27`) vorab gezogen.
- [ ] Hinweis für Teilnehmende mit nativem Docker Engine (M4-L2, nginx-Container erreicht Host über `host.docker.internal`): ggf. `--add-host` ergänzen.
- [ ] Fallback für M6, falls RabbitMQ bei einzelnen Teilnehmenden nicht erreichbar ist: Management-UI-Screenshot einer funktionierenden Instanz als Ersatznachweis vorbereiten.

## Zeitpuffer und Kürzungsoptionen Tag 2

1. M6-L3-Erweiterung "Retry-Strategie"/Dead-Letter-Skizze (optional, entfällt zuerst).
2. M4 (Skalierung) ist rein konzeptionell/Sandbox - bei Zeitdruck lässt sich M4-L2 auf eine reine Beobachtung ohne eigenes Provozieren des Zustandsproblems (Aufgabe 4) kürzen.

## Tag 3 - Setup und Fallbacks

- [ ] Docker-Basis-Images vorab gezogen: `maven:3.9-eclipse-temurin-17`, `eclipse-temurin:17-jre-alpine`, `python:3.11-slim`, um Wartezeiten in M7 zu vermeiden.
- [ ] Fallback für M7/M8 bei Build-Problemen: vorgebaute Images oder ein vollständig funktionierendes `compose.yaml` als Referenz bereithalten.
- [ ] `output/project/monitoring-logging-concept.md` und `output/project/capstone-summary.md` sind Teilnehmerartefakte (Vorlagen in den jeweiligen `solution.md`-Dateien von M9-L2/L3) - keine vorgefertigte Version an Teilnehmende ausgeben.

## Zeitpuffer und Kürzungsoptionen Tag 3

1. M9-L1-Erweiterung "weiteres Resilienzmuster" (optional, entfällt zuerst).
2. M7-L1/L2 sind knapp bemessen (15/35 Min je Spur für zwei Dockerfiles) - bei Zeitdruck das Notification-Service-Dockerfile (Aufgabe 2) als Hausaufgabe nach hinten verschieben, da das Muster identisch zum Order-Service ist.

## Statische Prüfung vor Auslieferung (gesamter Kurs)

- [ ] Alle 27 Labs (M1-L1 bis M9-L3) enthalten `theory.md`, `exercise.md`, `solution.md` (sprachneutrale Labs direkt im Lab-Ordner, implementierungsnahe Labs je `java/`- und `python/`-Unterordner).
- [ ] Aufgaben und Lösungen in jedem Lab sind nummerngleich (Parität geprüft).
- [ ] Code in Lösungen wurde statisch auf plausible Syntax, Imports und API-Nutzung geprüft; keine Ausführung vorgenommen.
- [ ] Keine internen Informationen, Zugangsdaten oder Trainerhinweise in `output/`-Dateien.
- [ ] Feldnamen sind über REST-Vertrag, Ereignisvertrag und beide Sprachspuren hinweg konsistent `camelCase` (siehe `04-content-review.md`, M-01).

## `m00-overview` (erzeugt)

- [x] Kurzer Hinweis zur Ordnerkonvention der Sprachspuren aufgenommen: sprachneutrale Labs liegen direkt im Lab-Ordner, implementierungsnahe Labs in `java/`- und `python/`-Unterordnern (siehe `04-content-review.md`, O-01, sowie `output/m00-overview/overview.md`, Abschnitt "Zwei Sprachspuren, ein Szenario").
- [x] Gesamtagenda M1-M9 mit Tagesmeilensteinen aus `02-plan.md` übernommen (`output/m00-overview/overview.md`).
- [x] Verweis auf `output/project/capstone-summary.md` als Abschlussartefakt ergänzt (`output/m00-overview/overview.md`, Tag-3-Abschnitt).
- [ ] Verweis auf `output/project/capstone-summary.md` als Abschlussartefakt ergänzen.
