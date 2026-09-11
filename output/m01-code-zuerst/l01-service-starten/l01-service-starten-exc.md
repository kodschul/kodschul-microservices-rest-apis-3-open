# Übung M01: Service starten und verändern

## Szenario und Ziel

Das Team übernimmt einen vorbereiteten Order Service. Bevor Architektur oder Integration verändert werden, muss der aktuelle Stand reproduzierbar laufen.

**Dauer:** 60 Minuten  
**Zielartefakt:** laufender Service, dokumentierter API-Aufruf, grüner Test und gesicherte Änderung

## Voraussetzungen

- bereitgestelltes Starterprojekt
- Java 21 oder kompatible freigegebene Laufzeit
- Maven 3.9.x oder Docker Compose v2
- API-Client oder `curl`
- freie Ports `8080` und `8000`

## Aufgabe 1: Projekt orientieren

1. Lokalisieren Sie Build-Datei, Anwendungseinstieg, Controller, Fachlogik und Tests.
2. Notieren Sie für jede Stelle ihre Aufgabe in einem Satz.
3. Markieren Sie die Methode, die eine Bestellung aktuell verarbeitet.

**Checkpoint:** Der Weg vom HTTP-Request bis zur Fachlogik ist nachvollziehbar.

## Aufgabe 2: Build und Tests ausführen

1. Bauen Sie den Java-Service mit dem vorgesehenen Build-Werkzeug.
2. Führen Sie die vorhandenen Tests aus.
3. Halten Sie Anzahl und Status der Tests fest.
4. Trennen Sie Warnungen von Fehlern.

**Checkpoint:** Der Build endet erfolgreich oder ein konkreter reproduzierbarer Blocker ist dokumentiert.

## Aufgabe 3: Service starten und API beobachten

1. Starten Sie den Order Service.
2. Prüfen Sie den Health-Endpunkt.
3. Senden Sie eine syntaktisch gültige Bestellung an `POST /api/orders`.
4. Dokumentieren Sie Statuscode und Antwortkörper.

**Checkpoint:** Health und aktuelles Bestellverhalten sind mit Request und Response belegt.

## Aufgabe 4: Kleine Verhaltensänderung absichern

1. Aktivieren oder ergänzen Sie einen Test für eine erfolgreiche Bestellerstellung.
2. Implementieren Sie nur das für diesen Test erforderliche Verhalten.
3. Verwenden Sie eine eindeutige Bestell-ID und den Status `created`.
4. Führen Sie den Test und anschließend den API-Aufruf erneut aus.

**Checkpoint:** Der Test ist grün und die API liefert das erwartete neue Verhalten.

## Aufgabe 5: Ergebnis sichern

1. Prüfen Sie die geänderten Dateien.
2. Notieren Sie Build-Befehl, Testresultat und beobachteten Statuscode.
3. Sichern Sie den Stand in einem lokalen Commit, sofern Git im Kurssetup vorgesehen ist.

## Abschlusskriterien

- [ ] Service ist erreichbar.
- [ ] Build und Test sind reproduzierbar.
- [ ] Die kleine Änderung ist durch einen Test abgesichert.
- [ ] Ausgangs- und Endverhalten sind dokumentiert.

## Erweiterung

Ergänzen Sie einen Test für eine ungültige Menge, ohne den Fehlervertrag späterer Module vorwegzunehmen.

## Fallback

Falls Maven lokal nicht verfügbar ist, verwenden Sie den vorbereiteten Container-Build. Ein nur beobachteter Lauf ersetzt den eigenen Build-Checkpoint nicht; dokumentieren Sie diesen Fall als offen.