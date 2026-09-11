# FAQ

## Muss ich bereits Microservices entwickelt haben?

Nein. Der Kurs beginnt mit einem vorbereiteten, laufenden Java-Service. Programmiergrundlagen und erste Erfahrung mit APIs werden vorausgesetzt; Microservice-Frameworks, RabbitMQ und Container-Orchestrierung werden nicht vorausgesetzt.

## Muss ich Python programmieren können?

Nein. Der Notification Service ist vorbereitet und wird über seinen OpenAPI-Vertrag integriert. Eigene Python-Änderungen sind eine optionale Erweiterung.

## Warum beginnt der Kurs mit Code?

Architekturentscheidungen werden an beobachtbarem Verhalten und realer Kopplung getroffen. Der laufende Service liefert dafür früher belastbare Evidenz als eine rein abstrakte Diskussion.

## Sind Microservices besser als ein Monolith?

Nicht grundsätzlich. Microservices können unabhängige Änderung und Skalierung erleichtern, erhöhen aber Netzwerk-, Betriebs- und Abstimmungskosten. Die passende Form hängt von Qualitätszielen und Kontext ab.

## Was bedeutet eine gute Servicegrenze?

Sie bündelt eine klare fachliche Verantwortung und Datenhoheit. Änderungen innerhalb der Grenze sollen möglichst wenige andere Services zwingen, sich gleichzeitig zu ändern.

## Warum wird OpenAPI verwendet?

OpenAPI macht Requests, Responses, Pflichtfelder und Fehler maschinenlesbar. Damit können Menschen und Werkzeuge prüfen, ob Anbieter und Verbraucher dieselbe Schnittstelle erwarten.

## Wird ein Client vollständig generiert?

Die Generierung wird demonstriert und mit einer vorbereiteten Variante verglichen. Generierter Code spart mechanische Arbeit, benötigt aber weiterhin fachliche Prüfung, Versionierung und Tests.

## Warum verwendet der Kurs JSON statt XML?

JSON ist das primäre Datenformat des Referenzprojekts und wird von Spring Boot und FastAPI direkt unterstützt. XML wird vergleichend eingeordnet, aber nicht als zweiter Implementierungspfad aufgebaut.

## Wann sollte REST verwendet werden?

REST passt zu Interaktionen, bei denen der Aufrufer eine unmittelbare Antwort benötigt und die zeitliche Kopplung akzeptabel ist.

## Wann ist Messaging sinnvoll?

Messaging passt, wenn Verarbeitung zeitlich entkoppelt werden darf, mehrere Verbraucher reagieren können oder ein kurzzeitig nicht erreichbarer Empfänger den Sender nicht blockieren soll.

## Garantiert RabbitMQ genau eine Verarbeitung?

Nein. Je nach Bestätigung und Fehlerverhalten kann eine Nachricht erneut zugestellt werden. Consumer müssen relevante Operationen deshalb idempotent gestalten oder Duplikate erkennen.

## Warum braucht der Kurs Docker Compose?

Compose beschreibt Java, Python und RabbitMQ als gemeinsam startbare Landschaft. Dadurch sind Netzwerke, Ports und Konfiguration reproduzierbar, ohne eine vollständige Orchestrierungsplattform einzuführen.

## Wird Kubernetes behandelt?

Nein. Kubernetes liegt außerhalb des praktischen Kursumfangs. Skalierung und Deployment werden soweit behandelt, wie es für die Bewertung der Referenzlösung erforderlich ist.

## Welche Ports müssen frei sein?

Standardmäßig werden `8080` für Java, `8000` für FastAPI, `5672` für AMQP und `15672` für die RabbitMQ-Verwaltung verwendet. Die Werte können über eine lokale `.env`-Datei angepasst werden.

## Was prüft ein Healthcheck?

Ein Healthcheck liefert einen automatisierbaren Zustand für Start und Diagnose. Er sollte klar unterscheiden, ob der Prozess läuft und ob notwendige Abhängigkeiten betriebsbereit sind.

## Warum reichen Unit Tests nicht aus?

Unit Tests prüfen isolierte Logik schnell. Sie erkennen jedoch keine falschen URLs, abweichenden JSON-Felder, Broker-Konfigurationen oder Probleme im vollständigen Servicefluss.

## Was ist ein Contract Test?

Ein Contract Test prüft relevante Eigenschaften der vereinbarten Schnittstelle. Im Kurs wird damit verhindert, dass OpenAPI-Dokument und laufende API unbemerkt auseinanderlaufen.

## Wie wird ein Downstream-Ausfall behandelt?

Der Order Service übersetzt den nicht erreichbaren Notification Service in eine definierte Fehlerantwort. Später werden Timeout und begrenzte Wiederholung anhand des konkreten Risikos bewertet.

## Warum sind Retries riskant?

Wiederholungen erhöhen Last und können nicht-idempotente Operationen doppelt ausführen. Sie benötigen Grenzen, Backoff und eine klare Entscheidung, welche Fehler überhaupt vorübergehend sind.

## Was bedeutet Produktionsreife im Kurs?

Produktionsreife ist ein begründetes Review, kein einzelner Schalter. Architektur, Tests, Betrieb, Security, Beobachtbarkeit, Skalierung, Delivery und Verantwortlichkeiten werden gemeinsam bewertet.

## Werden Cloud-Dienste benötigt?

Nein. Der Pflichtpfad läuft lokal. Cloud-Skalierung und Deployment-Optionen werden als Transfer- und Entscheidungsfragen eingeordnet.

## Was ist der gemeinsame Mindeststand?

Der Basispfad umfasst den laufenden Java-Service, einen validierten Vertrag, Java-Python-Kommunikation, einen RabbitMQ-Ereignisfluss, die Compose-Landschaft sowie einen dokumentierten Test- und Produktionsreifebefund.

## Was mache ich, wenn mein Setup ausfällt?

Zuerst werden Ports, Containerstatus, Logs und Konfiguration geprüft. Für den Tag-1-REST-Pfad existiert ein nativer Windows-Fallback; die Container- und Messaging-Ziele benötigen weiterhin eine funktionierende Docker-Umgebung.