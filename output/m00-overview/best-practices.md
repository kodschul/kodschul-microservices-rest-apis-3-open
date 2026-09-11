# Best Practices

Diese Leitlinien verbinden Architektur, API-Design, Integration, Tests und Betrieb über alle Kurstage.

## Mit dem Problem beginnen

- Eine Servicegrenze braucht einen fachlichen oder betrieblichen Grund.
- Ein zusätzlicher Prozess, Container oder Broker ist kein Nutzen an sich.
- Qualitätsziele wie unabhängige Änderung, Verfügbarkeit oder Skalierung machen Trade-offs prüfbar.
- Ein gut strukturierter Monolith bleibt eine gültige Option.

## Verantwortung und Datenhoheit klären

- Jeder Service besitzt eine klar benannte Verantwortung.
- Daten werden nicht ohne definierte Schnittstelle zwischen Services geteilt.
- Gemeinsame Datenbanken erzeugen versteckte Laufzeit- und Änderungsabhängigkeiten.
- Eine Context Map macht Beziehungen und Abhängigkeiten sichtbar.

## HTTP-Semantik konsistent einsetzen

- Ressourcen werden als fachliche Substantive modelliert.
- HTTP-Methoden beschreiben die beabsichtigte Operation.
- Statuscodes unterscheiden Erfolg, ungültige Eingabe und Downstream-Ausfall.
- Fehlerantworten enthalten einen stabilen maschinenlesbaren Code und eine verständliche Nachricht.
- Grenzfälle werden vor der Implementierung benannt.

## OpenAPI als Vertrag behandeln

- Der Vertrag beschreibt erfolgreiche und fehlerhafte Antworten.
- Pflichtfelder, Grenzen und erlaubte Werte sind explizit.
- Änderungen am Vertrag werden gemeinsam mit Implementierung und Tests geprüft.
- Generierter Code reduziert Tipparbeit, ersetzt aber keine fachliche Prüfung.
- Verbraucher und Anbieter benötigen eine abgestimmte Versionsstrategie.

## Sprachgrenzen über Datenverträge überbrücken

- Java und Python koppeln sich über öffentliche Schemas statt über implementierungsspezifische Klassen.
- Feldnamen und Datentypen werden auf der Leitung geprüft.
- Serialisierte Nachrichten werden von der empfangenden Technologie tatsächlich gelesen.
- Framework-spezifische Details bleiben hinter der Servicegrenze.

## REST und Messaging bewusst auswählen

REST passt, wenn eine unmittelbare Antwort fachlich erforderlich ist. Messaging passt, wenn zeitliche Entkopplung und unabhängige Verarbeitung wichtiger sind.

Prüfkriterien:

- Muss der Aufrufer sofort wissen, ob die Operation erfolgreich war?
- Darf der Empfänger vorübergehend nicht erreichbar sein?
- Wie wird Konsistenz sichtbar gemacht?
- Wer besitzt Fehlerbehandlung und Wiederholung?
- Wie werden Duplikate behandelt?

## Wiederholungen begrenzen

- Jeder Retry benötigt eine maximale Anzahl oder Gesamtdauer.
- Backoff reduziert zusätzliche Last während einer Störung.
- Nicht jede Operation darf wiederholt werden.
- Idempotenz verhindert doppelte fachliche Wirkung.
- Dauerhafte Fehler werden sichtbar gemacht, nicht endlos verdeckt.

## Tests nach Risiko wählen

| Risiko | Geeigneter früher Nachweis |
| --- | --- |
| fehlerhafte Fachlogik | Unit Test |
| abweichendes API-Schema | Contract Test |
| falsche Service-Konfiguration | Integration Test |
| defekter Gesamtfluss | End-to-End-Smoke-Test |
| problematisches Ausfallverhalten | gezielter Fehler- und Resilienztest |

Eine große Zahl schneller Unit Tests ersetzt keinen kleinen, gezielten Test über eine echte Servicegrenze.

## Container reproduzierbar halten

- Base Images und Bibliotheken verwenden konkrete Versionen.
- Konfiguration wird über Umgebungsvariablen eingebracht.
- Sensible Konfigurationswerte gehören nicht in Images oder öffentliche Dateien.
- Healthchecks prüfen die für den Betrieb relevante Erreichbarkeit.
- Service-Namen dienen innerhalb von Compose als Netzwerkadressen.
- Start und Stopp sind skriptbar und hinterlassen keine unnötigen Ressourcen.

## Diagnose mit Evidenz führen

- Zuerst Status und betroffene Grenze bestimmen.
- Danach relevante Logs und Konfiguration prüfen.
- Eine Hypothese mit einem kleinen Test falsifizieren.
- Erst dann Konfiguration oder Code ändern.
- Nach der Korrektur denselben Fehlerfall erneut ausführen.

## Produktionsreife als Entscheidung behandeln

Eine lokal laufende Lösung ist noch nicht produktionsreif. Zu prüfen sind mindestens:

- Verantwortlichkeiten und Bereitschaftsdienst,
- Security und geschützte Konfigurationsverwaltung,
- Metriken, Logs, Traces und Alarmierung,
- Backup-, Recovery- und Rollback-Verfahren,
- Kapazitäts- und Skalierungsannahmen,
- Deployment- und Freigabeprozess,
- Kosten und organisatorische Komplexität.

## Kurs-Checkliste

- [ ] Jede Servicegrenze besitzt eine Begründung.
- [ ] Erfolg, Grenze und Fehler sind im Vertrag sichtbar.
- [ ] Java und Python tauschen vertragstreue Daten aus.
- [ ] Die Kommunikationsform passt zur fachlichen Erwartung.
- [ ] Tests adressieren konkrete Risiken.
- [ ] Die Landschaft lässt sich reproduzierbar starten und stoppen.
- [ ] Ein verteilter Fehler ist anhand von Evidenz diagnostiziert.
- [ ] Nächste Produktionsschritte sind priorisiert und begründet.