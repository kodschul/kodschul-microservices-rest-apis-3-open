# Trainer-Glossar

Dieses Glossar ergänzt das öffentliche Glossar um typische Rückfragen, Fehlvorstellungen und Moderationshinweise.

| Begriff | Präzise Einordnung | Typische Fehlvorstellung | Trainerhinweis |
| --- | --- | --- | --- |
| API Contract | gemeinsam überprüfbare Schnittstellenerwartung | Die OpenAPI-Datei garantiert korrektes Laufzeitverhalten. | Vertrag und Implementierung mit positiven und negativen Tests vergleichen. |
| Context Map | Beziehung zwischen fachlichen Kontexten | Jedes technische Modul braucht einen eigenen Service. | Verantwortung und Datenhoheit vor Prozessgrenzen diskutieren. |
| Event | Aussage über ein eingetretenes fachliches Ereignis | Ein Event ist ein versteckter synchroner Befehl. | Vergangenheitsform und unabhängige Consumer betonen. |
| Healthcheck | automatisierbares Zustandssignal | HTTP 200 bedeutet automatisch vollständige Betriebsbereitschaft. | Liveness und Readiness anhand von Abhängigkeiten unterscheiden. |
| Idempotenz | stabile Wirkung bei wiederholter Verarbeitung | RabbitMQ verhindert grundsätzlich Duplikate. | Wiederzustellung demonstrieren und fachlichen Schlüssel diskutieren. |
| Microservice | eigenständig änder- und betreibbare fachliche Einheit | Kleine Codebasis bedeutet Microservice. | Betriebs- und Teamgrenze in die Bewertung aufnehmen. |
| OpenAPI | maschinenlesbare HTTP-Schnittstellenbeschreibung | Generierter Client beseitigt Versionsprobleme. | Generierung als mechanische Hilfe mit eigenem Lifecycle einordnen. |
| RabbitMQ | Message Broker | Der Broker löst Konsistenz automatisch. | Zustellung, Verarbeitung und fachliche Konsistenz getrennt betrachten. |
| REST | ressourcenorientierter Architekturstil über HTTP | Jede JSON-API ist automatisch RESTful. | Ressourcen, Methoden, Statuscodes und Zustandslosigkeit prüfen. |
| Retry | begrenzte Wiederholung | Mehr Wiederholungen erhöhen immer die Zuverlässigkeit. | Lastverstärkung und nicht-idempotente Wirkung sichtbar machen. |
| Service Boundary | Grenze von Verantwortung und Datenhoheit | Tabellen oder technische Schichten definieren Services. | Änderungsgründe und fachliche Fähigkeiten als Kriterien verwenden. |
| Timeout | explizite Obergrenze für Warten | Standardwerte des Frameworks sind immer passend. | Timeout aus Nutzererwartung und Fehlerbudget ableiten lassen. |
| Vertical Slice | kleinster Ende-zu-Ende-Pfad | Erst alle Schichten fertigstellen, dann integrieren. | Frühe Integration als Risikonachweis hervorheben. |

## Diagnosefragen

- Welches Verhalten wurde tatsächlich beobachtet?
- An welcher Servicegrenze tritt die Abweichung auf?
- Welche Hypothese erklärt Status, Logs und Testresultat gemeinsam?
- Welcher kleinste Test kann diese Hypothese widerlegen?
- Wurde nach der Änderung derselbe Fall erneut ausgeführt?

## Abgrenzungen

- Kubernetes ist kein Kursbestandteil.
- Ein vollständiger Monitoring-Stack wird nicht aufgebaut.
- CI/CD wird als Delivery-Entscheidung behandelt, nicht als Pipeline-Lab.
- XML wird vergleichend eingeordnet; JSON bleibt Implementierungsformat.
- Python-Programmierung ist Erweiterung, die Python-Integration ist Basispfad.