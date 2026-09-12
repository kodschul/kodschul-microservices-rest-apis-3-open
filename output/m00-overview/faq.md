# FAQ

## Muss ich sowohl Java als auch Python können?

Nein. Ihr wählt zu Kursbeginn eine Spur (Java/Spring Boot oder Python/FastAPI) und bleibt für alle drei Tage darin. Die andere Spur dient nur als Referenz, falls ihr später vergleichen möchtet.

## Wie wähle ich meine Spur?

Nach eurer praktischen Vorerfahrung: Wählt die Sprache, in der ihr bereits produktiv gearbeitet habt. Tiefe Erfahrung in beiden Sprachen wird nicht vorausgesetzt, mindestens eine praktische Vorerfahrung schon.

## Was passiert, wenn (fast) alle dieselbe Spur wählen?

Das ist ausdrücklich vorgesehen und funktioniert: Konzept und Ablauf sind so geplant, dass der Kurs auch mit nur einer aktiv genutzten Spur vollständig trägt.

## Warum verwenden wir eine In-Memory-Speicherung statt einer echten Datenbank?

Datenbankanbindung ist bewusst kein Lernziel dieses Kurses; sie würde Zeit von REST-, Messaging- und Container-Themen abziehen. Die daraus entstehenden Grenzen (z. B. bei mehreren Instanzen oder nach einem Neustart) werden in Modul 4 und 8 gezielt sichtbar gemacht, nicht verschwiegen.

## Warum verwenden wir `camelCase` im JSON, obwohl Python-Code `snake_case` nutzt?

Der REST- und Ereignisvertrag ist sprachneutral und schreibt `camelCase` vor, damit Java und Python identische Nachrichten austauschen. Python hält seine internen Attributnamen `snake_case` (Konvention der Sprache) und übersetzt beim Serialisieren automatisch über eine Alias-Konfiguration.

## Warum sind manche Labs sprachneutral und andere in `java/`/`python/` aufgeteilt?

Labs zu Architektur-, Skalierungs- und Event-Driven-Konzepten sind unabhängig von der Implementierungssprache und deshalb sprachneutral. Sobald ein Lab tatsächlichen Code enthält, liegt es einmal je Spur vor - nutzt dabei nur den Unterordner eurer gewählten Spur.

## Muss ich die Erweiterungsaufgaben lösen?

Nein. Erweiterungen sind optional und richten sich an schnellere oder erfahrenere Teilnehmende. Sie sind nie Voraussetzung für die nächste Pflichtaufgabe.

## Was mache ich, wenn Docker bei mir nicht funktioniert?

Meldet euch frühzeitig beim Trainer. Für kritische Schritte (z. B. Client-Generierung, RabbitMQ-Fallback) stehen vorbereitete Alternativen wie fertige Artefakte oder Aufzeichnungen bereit.

## Was mache ich, wenn RabbitMQ nicht startet?

Prüft zunächst, ob der Compose-Befehl aus `output/project/starter/rabbitmq-compose.yml` fehlerfrei durchläuft und Port `5672`/`15672` frei sind. Gelingt das nicht, greift der vorbereitete Fallback (getestetes Compose-Stack, alternative Nachweise) des Trainers.

## Sind `kodschul`/`kodschul` echte Zugangsdaten, um die ich mich kümmern muss?

Nein. Das ist ein kursweiter Platzhalter für die lokale, nicht im Internet erreichbare RabbitMQ-Instanz - kein individuell erzeugtes Geheimnis. In einem produktiven Setup würdet ihr immer eigene, individuell erzeugte Zugangsdaten verwenden.

## Warum bauen wir Inventory nicht auch vollständig?

Der Kurs fokussiert bewusst auf zwei vollständig durchimplementierte Services (Order, Notification), um Tiefe statt Breite zu erreichen. Inventory bleibt als Servicegrenze konzeptionell Teil des Szenarios (Modul 1), wird aber nicht implementiert.

## Was ist der Unterschied zwischen Unit-, Integrations-, Contract- und End-to-End-Test in diesem Kurs?

Ein Unit-Test prüft eine einzelne Funktion isoliert (z. B. Benachrichtigungstext-Erzeugung). Ein Integrationstest prüft das Zusammenspiel innerhalb eines Services (z. B. `OrderControllerTest`/`test_orders.py`). Ein Contract-Test gleicht die generierte OpenAPI-Spezifikation gegen den Vertrag ab. Ein End-to-End-Test prüft den gesamten Ablauf über mehrere Services (der manuelle Checkpoint-Nachweis in Modul 8).

## Was passiert mit meinen Bestellungen nach einem Neustart des Docker-Compose-Stacks?

Sie sind weg. Die In-Memory-Speicherung ist an den Lebenszyklus des jeweiligen Container-Prozesses gebunden; ein Neustart erzeugt einen komplett neuen, leeren Speicher. Das ist eine bewusste, im Kurs benannte Einschränkung, keine Fehlfunktion.

## Warum wird Cloud-Deployment nur besprochen und nicht praktisch umgesetzt?

Cloud-Deployment mit echten Ressourcen erfordert Zugangsdaten, Kosten und Freigaben, die außerhalb des Kursrahmens liegen. Modul 9 behandelt Deployment-Strategien (Rolling, Blue-Green, Canary) und Cloud-Skalierungsoptionen konzeptionell und begründet, praktisch bleibt alles lokal in Docker Compose.

## Welche Deployment-Strategie setzen wir im Kurs tatsächlich um?

Für die lokale Docker-Compose-Umgebung reicht ein einfaches Rolling-Vorgehen. Die Wahl einer produktiven Strategie (z. B. Blue-Green für die Bestell-Plattform) ist Teil der Abschlussaufgabe in Modul 9 und wird dort begründet, nicht praktisch mit echter Infrastruktur ausgeführt.

## Wird meine Lösung benotet?

Nein, es gibt keine Bewertung im Sinne einer Note. Jede Übung hat ein Abschlusskriterium, an dem ihr selbst überprüfen könnt, ob euer Ergebnis vollständig ist; der Trainer unterstützt bei Rückfragen.

## Muss ich am Ende alle sechs Lernziele im Capstone nachweisen?

Ja, das ist das Abschlusskriterium von Modul 9, Lab 3: Das Abschlussdokument (`capstone-summary.md`) ordnet allen sechs Lernzielen aus dem Kurskonzept einen konkreten Bezug zum eigenen Projektstand zu.

## Kann ich nach dem Kurs mit meinem Projektstand weiterarbeiten?

Ja. Alle Artefakte (Code, Verträge, Compose-Datei, Checkpoint-Protokolle) liegen lokal bei euch vor und sind nicht an die Kursumgebung gebunden.

## Brauche ich eine bestimmte IDE?

Nein, eine feste IDE ist nicht vorgeschrieben. Für die Java-Spur ist z. B. IntelliJ IDEA verbreitet, für die Python-Spur z. B. VS Code - beide sind Empfehlungen, keine Voraussetzung.

## Wird Kubernetes im Kurs behandelt?

Nein. Der Kurs orchestriert lokal mit Docker Compose. Kubernetes wird in Modul 4 nur als eine mögliche Cloud-Skalierungsoption genannt, nicht praktisch eingesetzt.

## Warum dupliziert der Kurs die Ereignis-Klassen zwischen Order- und Notification-Service, statt sie einmal gemeinsam zu nutzen?

Beide Services sind bewusst unabhängige Codebasen ohne gemeinsam genutztes Sprachmodul (Dual-Track-Prinzip). Die geteilte Schemadatei (`order-created-event.schema.json`) ist die gemeinsame Quelle der Wahrheit, an der beide Implementierungen synchron gehalten werden - der Preis dafür ist eine bewusst in Kauf genommene Duplizierung der Modellklassen.
