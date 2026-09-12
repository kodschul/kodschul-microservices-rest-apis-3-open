# Trainer-Glossar

Stand: vollständiger Kurs (M1-M9). Wird bei inhaltlichen Änderungen ergänzt.

| Begriff | Bedeutung im Kurs | Modul |
| --- | --- | --- |
| Bestell-Plattform | Referenzszenario des Kurses: Order-, Inventory- und Notification-Verantwortung | M1 |
| Order-Service | Vollständig implementierter Service; Inventory bleibt konzipiert, aber nicht implementiert | M1 |
| Dual-Track | Jedes implementierungsnahe Lab existiert vollständig als Java- und als Python-Variante; Teilnehmende wählen einmal zu Kursbeginn | M1 |
| Contract-first | Der REST-Vertrag (`order-api.yaml`) entsteht vor dem Code und ist für beide Spuren identisch verbindlich | M2 |
| In-Memory-Speicher | Bewusste didaktische Vereinfachung statt echter Datenbank; Ursache für sichtbare Inkonsistenzen bei Skalierung (M4) und Neustart (M8) | M2 |
| 422-vs-400-Konflikt (Python) | FastAPI liefert bei Validierungsfehlern standardmäßig `422`; der Vertrag verlangt `400` - erfordert einen eigenen Exception-Handler | M2 |
| camelCase-Alias (Python) | `alias_generator=to_camel` + `populate_by_name=True` sorgt dafür, dass Python-Modelle intern `snake_case`, im JSON aber `camelCase` verwenden - Voraussetzung für Vertragskonformität mit Java | M2, M6 |
| springdoc-openapi (Java) | Bibliothek, die aus Spring-MVC-Code automatisch eine OpenAPI-Spezifikation erzeugt | M3 |
| Automatische OpenAPI-Generierung (Python) | FastAPI erzeugt die Spezifikation ohne Zusatzabhängigkeit aus Typannotationen und Pydantic-Modellen | M3 |
| Swagger UI / `/docs` / `/redoc` | Interaktive (Swagger UI, `/docs`) bzw. rein lesende (`/redoc`) Oberflächen zur API-Erkundung | M3 |
| Load Balancer (nginx-Sandbox) | Temporäre Übung, verändert nicht die Projektbasis; zeigt die Grenzen der In-Memory-Speicherung bei horizontaler Skalierung | M4 |
| Event-Carried State Transfer | EDA-Muster, bei dem das Ereignis bereits alle benötigten Daten trägt; Grundlage des Bestellereignisses | M5 |
| Messaging-Vertrag (`messaging-contract.md`) | Legt Exchange (`order.events`), Routing Key (`order.created`) und Queue (`notification.order-created`) verbindlich fest | M5, M6 |
| Notification-Service | Zweiter implementierter Service; konsumiert Bestellereignisse über RabbitMQ, keine eigene REST-API für Teilnehmende | M6 |
| At-least-once-Zustellung | RabbitMQ-Standardverhalten; Konsumenten müssen mit doppelt zugestellten Nachrichten umgehen können | M6, M9 |
| Multi-Stage-Build (Java) | Trennt Build-Stage (Maven/JDK) von Laufzeit-Stage (schlankes JRE-Image) | M7 |
| `host.docker.internal` | Löst den Host-Rechner aus einem Container heraus auf; unter nativem Docker Engine (z. B. Linux) zusätzlich `--add-host=host.docker.internal:host-gateway` nötig | M3, M4, M7 |
| Servicename statt `host.docker.internal` | Innerhalb eines Compose-Netzwerks erreichen sich Services über ihren Servicenamen, nicht über den Host | M8 |
| Retry mit Exponential Backoff | Wiederholt eine fehlgeschlagene Operation mit wachsender Wartezeit; passt zu vorübergehenden, nicht zu dauerhaften Fehlern | M9 |
| Blue-Green Deployment | Empfohlene Deployment-Strategie für die Bestell-Plattform im Kurs-Referenzszenario | M9 |

## Schwierige Teilnehmerfragen (gesamter Kurs)

**"Warum bauen wir nicht auch Inventory und Notification in Modul 1?"**
Antwort: Der Kurs fokussiert bewusst auf einen vollständig durchimplementierten Service (Order), um Tiefe statt Breite zu erreichen. Inventory bleibt konzeptionell, Notification kommt in Modul 6 hinzu.

**"Warum eine In-Memory-Speicherung statt einer echten Datenbank?"**
Antwort: Datenbankanbindung ist explizit kein Lernziel dieses Kurses; sie würde Zeit von den REST-, Messaging- und Container-Themen abziehen. In einem Produktivsystem wäre eine Datenbank Pflicht.

**"Muss ich beide Sprachspuren durcharbeiten?"**
Antwort: Nein. Jede/r Teilnehmende wählt zu Kursbeginn eine Spur und bleibt darin; die andere Spur dient nur als Referenz, falls jemand später vergleichen möchte.

**"Warum bauen wir keine echte Datenbank oder Kubernetes-Deployment?"**
Antwort: Beides ist bewusst außerhalb des Kursumfangs (siehe `01-concept.md`, Risks and Fallbacks); der Kurs fokussiert auf REST, Messaging und Containerisierung in der verfügbaren Zeit. Modul 9 behandelt produktive Deployment-Strategien konzeptionell, nicht praktisch.

**"Sind `kodschul`/`kodschul` echte Zugangsdaten, die ich absichern muss?"**
Antwort: Nein. Das ist ein kursweiter, einprägsamer Platzhalter für die lokale, nicht im Internet erreichbare RabbitMQ-Instanz. Er ist bewusst kein individuell erzeugtes Geheimnis. Weist Teilnehmende darauf hin, dass ein produktives Setup immer eigene, individuell erzeugte Zugangsdaten braucht - dieser Platzhalter dient nur der Kurs-Reproduzierbarkeit.

**"Warum wird das Bestellereignis in beiden Spuren separat implementiert, obwohl es derselbe Vertrag ist?"**
Antwort: Jede Spur hat eine eigene, unabhängige Codebasis (kein gemeinsam genutztes Sprachmodul). Der Vertrag (`order-created-event.schema.json`, `messaging-contract.md`) ist die gemeinsame Quelle der Wahrheit, die beide Implementierungen synchron hält.

## Versionssensible Fakten (Stand Erstellung, vor Kursbeginn erneut prüfen)

- Spring Boot `3.3.4`, springdoc-openapi `2.6.0`, spring-retry (aktuelle Version zur Erstellungszeit) - vor Kursbeginn auf aktuelle Patch-Version prüfen.
- FastAPI `0.115.0`, Pydantic `2.9.2`, `pika` `1.3.2`, `tenacity` `9.0.0` - vor Kursbeginn auf aktuelle Patch-Version prüfen.
- RabbitMQ `3.13` (Management-Image) - vor Kursbeginn auf aktuelle Patch-Version prüfen.

## Bewertungs- und Adaptionshinweise je Lab (aus öffentlichen Lösungen entfernt, siehe `04-content-review.md` B-01)

| Lab | Hinweis für den Trainer |
| --- | --- |
| M1-L1 | Bei Aufgabe 1+2 gibt es keine einzige "richtige" Formulierung; entscheidend ist ein Bezug zu mindestens einem Kriterium aus der Theorie-Tabelle, nicht nur eine Meinung. |
| M1-L2 | Bei Aufgabe 3 auf eine **fachliche** Begründung achten (nicht "REST ist einfacher"). Alternative Antworten (z. B. Order↔Inventory asynchron mit Kompensationslogik) sind zulässig, wenn schlüssig begründet. |
| M1-L3 (Java) | Fokus liegt auf Startsequenz/Fehlermeldungen, nicht auf Zusatzcode. Übersprungene Fehlerfälle sollten nachgeholt werden, da sie in M7-M9 als Lesekompetenz wiederkehren. |
| M1-L3 (Python) | Fokus liegt auf Server-vs-Framework-Verständnis und Dekoratoren. Teilnehmende ohne Python-Erfahrung profitieren von einer kurzen Live-Demo vor dem eigenständigen Start. |
| M2-L1 | Abweichende, aber akzeptable Verträge sind ok (z. B. zusätzlicher `PATCH`-Endpunkt oder `POST /orders/{id}/cancel` statt `DELETE`) - wichtig ist nur ein gemeinsamer Vertrag für beide Spuren. |
| M2-L2 (Java/Python) | In-Memory-Speicherung ist bewusst simpel, kein Vorgriff auf Persistenz. Vollständige 404-Fehlerbehandlung folgt bewusst erst in Lab 3. |
| M2-L3 (Java) | Statische Prüfung, keine Testausführung vorgesehen. Häufiger Stolperstein: `@Valid` vergessen, oder `javax.validation` statt `jakarta.validation`. |
| M2-L3 (Python) | Statische Prüfung, keine Testausführung vorgesehen. Der 422-vs-400-Konflikt ist bewusst eingebaut; Teilnehmende, die ihn übersehen, bemerken ihn an einem fehlschlagenden Testfall. |
| M3-L1 (Java/Python) | Lernwert liegt darin, zu erleben, dass generierte Dokumentation nicht automatisch vollständig ist - Fehlerfälle müssen aktiv annotiert werden. |
| M3-L2 (Java) | Übung bewusst ohne neuen Code; Lernwert liegt im Verständnis von Swagger UI gegenüber automatisierten Tests. |
| M3-L2 (Python) | Wie Java, zusätzlich `/redoc`-Vergleich. Zeigt `/docs` weiterhin `422` statt `400`, deutet das auf eine unvollständige Lab-3-Lösung aus Modul 2 hin. |
| M3-L3 (Java/Python) | Bei Docker-Ausfall bei einzelnen Teilnehmenden: generierten Client vorab bereitstellen und Übung auf die Code-Inspektion (Aufgaben 2-3) beschränken (siehe `trainer-checklist.md`). |
| M4-L2 | Sandbox-Lab, verändert die Projektbasis nicht. Häufiger Stolperstein: Teilnehmende vergessen, die zweite Instanz wirklich auf einem anderen Port zu starten. |
| M6-L1/L2 (Java/Python) | Beide Services deklarieren Exchange/Queue erneut (idempotent) - das ist beabsichtigt, kein Fehler. |
| M6-L3 (Java/Python) | Der Fehlerfall-Testfall ist absichtlich provoziert und muss nach Aufgabe 4 zurückgesetzt werden; unbedingt prüfen, dass Teilnehmende dies nicht vergessen. |
| M7-L1 (Java/Python) | Diagnose-Lab ohne Code-Änderung; Fokus liegt auf dem Erkennen der vier Problemklassen, nicht auf einer perfekten Formulierung. |
| M9-L1/L2 (Java/Python) | Retry-Parameter in Theorie/Übung (`maxAttempts`/`stop_after_attempt`) und im Fehlerinjektionstest müssen exakt übereinstimmen - bei Abweichungen zuerst hier nachsehen. |
| M9-L3 (Java/Python) | Capstone bündelt bewusst mehrere Lernfragen (Deployment-Strategie, DevOps, Demonstration) in einem Lab - das ist eine akzeptierte Designentscheidung (siehe `03-feedback.md`, Iteration 2, MJ-01). |
