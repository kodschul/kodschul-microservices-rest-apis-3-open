# Übung M08: Produktionsreife bewerten und nächste Schritte priorisieren

## Szenario und Ziel

Die Bestellplattform erfüllt die Kurscheckpoints, ist damit aber noch nicht automatisch produktionsreif. Eine lokale Skalierungsbeobachtung und ein individuelles Review sollen die wichtigsten technischen und organisatorischen Lücken in einen umsetzbaren Plan überführen.

**Dauer Basispfad:** 95 Minuten, D02 20 Minuten und E11 75 Minuten
**Zielartefakt:** Skalierungsbeobachtung, ausgefülltes Produktionsreife-Review und priorisierter Verbesserungsplan mit Transferschritt

## Voraussetzungen und Starter

- abgeschlossener M07-Basispfad
- lauffähige Compose-Landschaft
- alle eigenen Pflichtcheckpoints aus M01 bis M07
- Review-Raster für Architektur, Verträge, Tests, Betrieb, Beobachtbarkeit, Deployment, Delivery und Ownership
- Vorlage für Risiko, Evidenz, Maßnahme, Priorität, Abhängigkeit, Rolle und Nachweis

## Aufgabe 1: Horizontale und vertikale Skalierung abgrenzen

1. Beschreiben Sie für den Notification Service je eine horizontale und vertikale Veränderung.
2. Ordnen Sie Kapazität, Ausfallverteilung, Kosten und technische Grenzen zu.
3. Beobachten Sie den vorbereiteten Versuch einer zusätzlichen lokalen Instanz.
4. Halten Sie fest, was die Beobachtung belegt und was ohne Load Balancer und Lastmessung offen bleibt.

**Checkpoint:** Beide Skalierungsrichtungen sind korrekt unterschieden; die lokale Beobachtung wird nicht als Produktionsnachweis überinterpretiert.

## Aufgabe 2: Architektur und Verträge bewerten

1. Prüfen Sie Servicegrenzen, Verantwortung und Datenhoheit der Bestellplattform.
2. Bewerten Sie REST-, OpenAPI- und Messaging-Entscheidungen anhand ihrer bisherigen Evidenz.
3. Benennen Sie das wichtigste verbleibende Architektur- oder Vertragsrisiko.
4. Formulieren Sie einen überprüfbaren nächsten Nachweis.

**Checkpoint:** Architektur und Schnittstellen besitzen eine belegte Stärke, ein priorisierbares Risiko und einen konkreten Nachweis.

## Aufgabe 3: Tests, Resilienz und Betrieb bewerten

1. Ordnen Sie die vorhandenen Unit-, Vertrags-, Integrations- und End-to-End-Tests den wichtigsten Risiken zu.
2. Prüfen Sie Teilausfall, Timeout-Entscheidung, Health-Status und Cleanup.
3. Bewerten Sie Start, Diagnose, Wiederherstellung und Rückfallfähigkeit.
4. Priorisieren Sie die größte verbleibende Betriebs- oder Resilienzlücke.

**Checkpoint:** Test- und Betriebsrisiko sind anhand vorhandener oder fehlender Evidenz bewertet.

## Aufgabe 4: Logging und Monitoring-Konzept skizzieren

1. Definieren Sie zwei beobachtbare Serviceziele für den Bestellfluss.
2. Ordnen Sie geeignete Logs, Metriken oder Traces als Signale zu.
3. Benennen Sie Schwelle, Reaktion und verantwortliche Rolle.
4. Begrenzen Sie das Ergebnis auf ein Konzept ohne Monitoring-Stack.

**Checkpoint:** Zwei Serviceziele besitzen messbare Signale und eine Reaktion, ohne neue Plattformimplementierung.

## Aufgabe 5: Deployment, Delivery und Ownership planen

1. Vergleichen Sie Rolling, Blue/Green und Canary für eine nächste Änderung.
2. Wählen Sie eine Strategie anhand von Rückrollbarkeit, Ressourcen und Kompatibilität.
3. Skizzieren Sie erforderliche CI/CD-Gates und DevOps-Handoffs, ohne eine Pipeline zu bauen.
4. Ordnen Sie jeder Übergabe eine verantwortliche Rolle und einen Nachweis zu.

**Checkpoint:** Deployment-Entscheidung, Delivery-Gates und Teamverantwortung bilden einen konsistenten Ablauf.

## Aufgabe 6: Verbesserungsplan und Transfer abschließen

1. Sammeln Sie die Risiken aus allen Review-Dimensionen.
2. Priorisieren Sie drei Maßnahmen nach Auswirkung, Wahrscheinlichkeit, Evidenz und Abhängigkeit.
3. Formulieren Sie pro Maßnahme Rolle, Abschlussnachweis und bewusste Grenze.
4. Legen Sie einen konkreten ersten Transferschritt für Ihr Arbeitsumfeld fest.

**Checkpoint:** Drei begründete Maßnahmen sind geordnet; der erste Transfer besitzt Termin, Rolle und beobachtbaren Nachweis.

## Abschlusskriterien

- [ ] Horizontale und vertikale Skalierung wurden korrekt abgegrenzt.
- [ ] Alle acht Review-Dimensionen wurden individuell bewertet.
- [ ] Risiken beruhen auf vorhandener oder sichtbar fehlender Evidenz.
- [ ] Drei Maßnahmen wurden priorisiert und Rollen zugeordnet.
- [ ] Ein konkreter Transferschritt mit Nachweis wurde festgelegt.

## Erweiterung

Übertragen Sie das Review auf einen eigenen anonymisierten Service. Vergleichen Sie nur die drei höchsten Risiken mit der Kursplattform. Die Erweiterung verändert den Pflichtplan nicht.

## Fallback

Falls keine zusätzliche lokale Instanz beobachtet werden kann, verwenden Sie den bereitgestellten Compose-Status und die dokumentierte Portkollision. Das Review und der Verbesserungsplan bleiben ausführbar; nur die eigene Skalierungsbeobachtung bleibt offen.