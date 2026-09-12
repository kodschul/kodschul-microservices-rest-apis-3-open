# Best Practices

Diese Praktiken werden im Kurs tatsächlich verwendet und verbinden Architektur, API-Design, Messaging, Container und Betrieb über alle neun Module.

## Servicegrenzen vor Code entwerfen

- Eine Servicegrenze braucht einen fachlichen Grund (Verantwortung, Datenhoheit), nicht nur eine technische Trennung.
- Order-, Inventory- und Notification-Verantwortung werden bewusst getrennt benannt, bevor der erste Endpunkt entsteht (Modul 1).
- Eine Grenze, die nicht begründet werden kann, ist ein Kandidat für einen gemeinsamen Service statt für eine künstliche Aufteilung.

## Contract-first statt Code-first entwickeln

- Der REST-Vertrag (`order-api.yaml`) und der Ereignisvertrag (`order-created-event.schema.json`, `messaging-contract.md`) entstehen vor der Implementierung (Module 2, 5).
- Beide Sprachspuren implementieren denselben Vertrag unabhängig voneinander - Abweichungen fallen beim Vertragsabgleich auf, nicht erst beim gemeinsamen Testen.
- Ein Vertrag, der beiden Spuren vorliegt, verhindert, dass sich REST- und Messaging-Feldnamen unbemerkt auseinanderentwickeln.

## Feldnamen sprachübergreifend konsistent halten

- Alle JSON-Payloads (REST und Messaging) verwenden konsequent `camelCase`, unabhängig von der internen Attributbenennung jeder Sprache.
- Python-Modelle nutzen `alias_generator=to_camel` und `populate_by_name=True`, damit interner `snake_case`-Code und externes `camelCase`-JSON keinen Widerspruch erzeugen.
- Diese Konsistenz wird am Vertrag geprüft (Modul 2, 3), nicht erst beim Testen der Integration.

## Kleine, in sich vollständige Ereignisse veröffentlichen

- Das Bestellereignis trägt bereits alle Daten, die der Notification-Service braucht (Event-Carried State Transfer, Modul 5) - keine Rückfrage an den Order-Service nötig.
- Nur Felder aufnehmen, die ein Konsument tatsächlich benötigt; interne Implementierungsdetails bleiben außerhalb des Ereignisses.
- Ein eigenes Schema pro Ereignistyp (statt eines generischen "Alles-Ereignisses") hält Verträge klein und nachvollziehbar.

## Wiederholungen begrenzen und mit Backoff versehen

- Jeder Retry hat eine feste Obergrenze (`maxAttempts`/`stop_after_attempt`) statt endloser Wiederholung (Modul 9).
- Exponentielles Backoff verhindert, dass wiederholte Versuche ein bereits gestörtes System zusätzlich belasten.
- Retry passt zu vorübergehenden Fehlern (z. B. kurzer Verbindungsabbruch), nicht zu dauerhaften (z. B. falsche Zugangsdaten) - diese Grenze wird im Kurs bewusst benannt.

## Health-Signale und Startreihenfolge explizit machen

- Jeder Service exponiert einen Health-Endpunkt (`/health` bzw. `/actuator/health`), der unabhängig von fachlicher Logik prüfbar ist (Modul 1, 6).
- Docker-Compose-Healthchecks und `depends_on: condition: service_healthy` sorgen dafür, dass abhängige Services erst starten, wenn RabbitMQ tatsächlich bereit ist, nicht nur, wenn der Container existiert (Modul 8).

## Container schlank, reproduzierbar und nicht-privilegiert bauen

- Multi-Stage-Builds trennen Build- und Laufzeitumgebung (Java, Modul 7); Python nutzt ein schlankes, fest gepinntes Basis-Image statt `latest`.
- Abhängigkeiten werden vor dem restlichen Code kopiert und installiert, damit Docker-Layer-Caching greift.
- Container laufen mit einem eigens angelegten, nicht-privilegierten Nutzer statt als `root`.

## Innerhalb eines Compose-Netzwerks über Servicenamen kommunizieren

- Sobald mehrere Services gemeinsam über Docker Compose laufen, ersetzt der Servicename (`rabbitmq`, `order-service`) den bis dahin genutzten `host.docker.internal` (Modul 8).
- `host.docker.internal` bleibt nur relevant, solange Container einzeln gestartet werden und einen auf dem Host laufenden Dienst erreichen müssen (Module 3, 4, 7) - inklusive des Hinweises, dass native Docker-Engine-Umgebungen (z. B. Linux) zusätzlich `--add-host=host.docker.internal:host-gateway` benötigen.

## Neue Abhängigkeiten immer in der Abhängigkeitsdatei deklarieren

- Neue Bibliotheken (`pika`, `tenacity`, `spring-retry`, `pytest`/`httpx`) werden über `requirements.txt` bzw. `pom.xml` eingeführt, nie nur ad-hoc installiert (Module 2, 6, 9).
- Das hält die Umgebung für andere Teilnehmende und für den Trainer reproduzierbar.

## Sandbox-Übungen von der Projektbasis trennen

- Übungen, die nur zu Beobachtungszwecken dienen (z. B. eine zweite Service-Instanz hinter einem temporären Load Balancer, Modul 4), sind ausdrücklich als reversibel gekennzeichnet.
- Teilnehmende wissen dadurch klar, wann eine Änderung dauerhaft im eigenen Projekt bleibt und wann nicht.

## Fehlerfälle gezielt provozieren, beobachten und zurücksetzen

- Resilienz wird nicht nur behauptet, sondern durch bewusst injizierte Fehler sichtbar gemacht (z. B. RabbitMQ kurzzeitig stoppen, Modul 6/9) und danach explizit wieder zurückgesetzt.
- Automatisierte Fehlerinjektionstests (Mocking von `RabbitTemplate`/`pika.BlockingConnection`) prüfen dasselbe Verhalten reproduzierbar, ohne echte Infrastruktur zu stören (Modul 9).

## Baseline vor Erweiterung abschließen

- Jede Übung trennt eine für alle verpflichtende Baseline von optionalen Erweiterungen (z. B. Modul 2, 6, 9).
- Eine Erweiterung ist nie Voraussetzung für nachfolgende Pflichtinhalte - das erlaubt heterogenen Gruppen ein gemeinsames Tempo ohne Blockaden.

## Monitoring früh mitdenken, nicht nachträglich anhängen

- Bereits im letzten Modul wird ein Monitoring-/Logging-Konzept entlang vier fester Aspekte skizziert: Health-Signale, fachliche Metriken, Fehler-Sichtbarkeit, Log-Korrelation (Modul 9).
- Eine Korrelations-ID (hier die Bestell-ID) durch die Logs mehrerer Services zu verfolgen, ist die einfachste Form von Tracing ohne zusätzliche Infrastruktur.
