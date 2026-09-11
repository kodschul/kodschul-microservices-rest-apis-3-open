# Trainer-Checkliste

## Vor dem Kurs

- [ ] Java 21, Docker Compose v2 und Git auf dem Zielgerät prüfen.
- [ ] Starter und Referenz frisch bereitstellen; keine lokalen Lösungen im Starter belassen.
- [ ] Ports `8080`, `8000`, `5672` und `15672` prüfen.
- [ ] Paket- und Image-Zugriff testen oder benötigte Artefakte vorab laden.
- [ ] Referenz mit Start-, Smoke- und Stop-Skript vollständig ausführen.
- [ ] Prüfen, dass nach dem Stop keine Kurscontainer verbleiben.
- [ ] Native Tag-1-Alternative einmal ausführen.
- [ ] API-Client oder äquivalentes Werkzeug bereitstellen.
- [ ] Vorstellungsfolie und Zeitbox für bis zu zwölf Personen vorbereiten.
- [ ] Keine echten Kundendaten oder produktiven Zugangsdaten verwenden.

## Tag 1

- [ ] Einführung bis 09:30 abschließen und direkt ins Starterprojekt wechseln.
- [ ] Java-Build und ersten API-Aufruf bei allen Teilnehmenden prüfen.
- [ ] Erweiterungen nicht zur Voraussetzung für den Basispfad machen.
- [ ] Architekturentscheidungen an Qualitätszielen prüfen lassen.
- [ ] Vor dem Java-Python-Checkpoint den OpenAPI-Vertrag validieren.
- [ ] Tagesabschluss: erfolgreicher sprachübergreifender Aufruf ist sichtbar.

## Tag 2

- [ ] Fehler- und Vertragstest vor dem Messaging-Block abschließen.
- [ ] REST-/Messaging-Entscheidungen mit Kopplung und Konsistenz begründen lassen.
- [ ] RabbitMQ-Ereignis und Consumer-Ergebnis sichtbar machen.
- [ ] Docker-Tiefe auf Build, Konfiguration, Vernetzung, Status und Logs begrenzen.
- [ ] Compose-Landschaft zum Tagesende kontrolliert stoppen.

## Tag 3

- [ ] Gesamtlandschaft reproduzierbar neu starten.
- [ ] Vorbereiteten Fehler nur nach gesichertem Ausgangszustand aktivieren.
- [ ] Diagnose zuerst über Status und Logs führen, dann Änderungen zulassen.
- [ ] Resilienzmaßnahme gegen denselben Fehlerfall erneut testen.
- [ ] Produktionsreife-Review individuell abschließen lassen.
- [ ] Jede Person benennt einen konkreten nächsten Transferschritt.

## Fallbacks

| Problem | Erste Prüfung | Begrenzter Fallback |
| --- | --- | --- |
| Java baut nicht | JDK, Maven-Ausgabe, Netzwerk | vorgebautes Referenz-JAR für Analyse; Coding-Ziel später nachholen |
| Port belegt | Listener und `.env` prüfen | freie alternative Ports konfigurieren |
| FastAPI startet nicht | Python-Version und Abhängigkeiten | getestetes Container-Image verwenden |
| Docker Engine nicht erreichbar | Engine-Status und Kontext | nativer REST-Pfad nur für Tag 1 |
| RabbitMQ nicht gesund | Compose-Status und Broker-Logs | Ereignisvertrag und Publisher-Test analysieren; E2E bleibt offen |
| Teilnehmende sind schneller | Pflichtcheckpoint prüfen | klar markierte Erweiterung E05X oder zusätzlicher Fehlerfall |

Ein beobachteter Fallback ist kein bestandener individueller Ausführungscheckpoint. Fehlende Nachweise bleiben sichtbar.

## Abschlusskontrolle

- [ ] Pflichtcheckpoints sind pro Person dokumentiert.
- [ ] Starter, Lösungen und Trainerdateien bleiben getrennt.
- [ ] Offene technische Probleme und ausgelassene Übungen sind benannt.
- [ ] Keine Container, temporären Zugangsdaten oder personenbezogenen Daten bleiben zurück.
- [ ] Rückmeldungen für die nächste Materialrevision sind notiert.