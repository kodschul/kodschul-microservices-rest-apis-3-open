# Übung M06: Compose-Landschaft betreiben und diagnostizieren

## Szenario und Ziel

Die Bestellplattform besteht aus Java, Python und RabbitMQ. Die vorhandenen Dockerfiles und die Compose-Datei sollen eine reproduzierbare Umgebung ergeben; anschließend wird ein vorbereiteter Konfigurations- oder Verbindungsfehler systematisch behoben.

**Dauer Basispfad:** 105 Minuten, E08 60 Minuten und E09 45 Minuten
**Zielartefakt:** laufende Compose-Landschaft, Diagnoseprotokoll, korrigierte Konfiguration und sauberer Abschluss

## Voraussetzungen und Starter

- abgeschlossene M05-Referenzlösung
- funktionsfähige lokale Container-Runtime mit Compose
- vorhandene Java- und Python-Dockerfiles
- vorbereitete Compose-Datei für Java, Python und RabbitMQ
- vorbereitete fehlerhafte Compose-Variante
- freie Kursports und konfigurierte lokale Werte

## Aufgabe 1: Dockerfiles prüfen und Images bauen

1. Ordnen Sie in beiden Dockerfiles Build-, Laufzeit-, Port- und Health-Schritte zu.
2. Prüfen Sie, welche Tests oder Abhängigkeitsinstallationen beim Build ausgeführt werden.
3. Bauen Sie beide Anwendungs-Images über den vorgesehenen Compose-Weg.
4. Dokumentieren Sie Erfolg oder die erste konkrete Build-Ursache.

**Checkpoint:** Beide Images sind gebaut; Image und laufender Container werden korrekt unterschieden.

## Aufgabe 2: Compose-Konfiguration erklären

1. Rendern und prüfen Sie die effektive Compose-Konfiguration.
2. Markieren Sie veröffentlichte Ports, interne Container-Ports und Service-Namen.
3. Ordnen Sie Umgebungsvariablen, Healthchecks und Abhängigkeiten den drei Services zu.
4. Erklären Sie, warum interne Aufrufe nicht über den Hostnamen des Entwicklungsrechners laufen.

**Checkpoint:** Netzwerkpfade und Konfigurationsquellen sind für Java, Python und RabbitMQ nachvollziehbar.

## Aufgabe 3: Gesamtlandschaft starten und prüfen

1. Starten Sie die Landschaft mit Build und Bereitschaftsprüfung.
2. Prüfen Sie Zustand, Health und Ports aller Services.
3. Führen Sie den vorgesehenen API-Smoke-Test aus.
4. Belegen Sie positiven Pfad, ungültige Eingabe und konsumiertes Ereignis.

**Checkpoint:** Java, Python und RabbitMQ sind gesund; der Ende-zu-Ende-Pfad ist beobachtbar.

## Aufgabe 4: Vorbereiteten Fehler eingrenzen

1. Aktivieren Sie genau eine bereitgestellte Fehlerart aus Port, Konfiguration oder Service-Name.
2. Prüfen Sie zuerst die effektive Konfiguration und danach den Service-Status.
3. Lesen Sie die Logs des auffälligen und des unmittelbar abhängigen Service.
4. Halten Sie Symptom, Evidenz und vermutete Ursache getrennt fest.

**Checkpoint:** Die Ursache ist durch Konfiguration, Status oder Logs belegt und nicht nur vermutet.

## Aufgabe 5: Ursache korrigieren und validieren

1. Ändern Sie nur die belegte Fehlerursache.
2. Starten Sie die betroffenen Services mit der korrigierten Konfiguration neu.
3. Wiederholen Sie Status-, Health- und API-Prüfung.
4. Ergänzen Sie das Diagnoseprotokoll um Korrektur und Nachweis.

**Checkpoint:** Die korrigierte Landschaft erfüllt denselben Checkpoint wie vor der Störung.

## Aufgabe 6: Umgebung kontrolliert bereinigen

1. Sichern Sie nur das Diagnoseprotokoll und keine lokalen Konfigurationswerte.
2. Beenden und entfernen Sie die Compose-Landschaft einschließlich verwaister Kurscontainer.
3. Prüfen Sie, dass keine Kursservices mehr laufen.
4. Halten Sie die bewusste Themengrenze des Moduls fest.

**Checkpoint:** Die Kurslandschaft ist entfernt; Registry, Volumes, Kubernetes und Monitoring-Stack wurden nicht eingeführt.

## Abschlusskriterien

- [ ] Java- und Python-Images wurden aus den vorhandenen Dockerfiles gebaut.
- [ ] Java, Python und RabbitMQ liefen gesund in Compose.
- [ ] Positiver, Grenz- und Ereignispfad wurden geprüft.
- [ ] Eine vorbereitete Störung wurde mit Evidenz diagnostiziert und korrigiert.
- [ ] Die Umgebung wurde ohne veröffentlichte lokale Werte bereinigt.

## Erweiterung

Vergleichen Sie die Diagnosewirkung eines Portfehlers mit der eines falschen Service-Namens. Ändern Sie immer nur eine Ursache und ergänzen Sie das Protokoll. Die Erweiterung ist keine Voraussetzung für M07.

## Fallback

Falls keine Container-Runtime verfügbar ist, prüfen Sie bereitgestellte Compose-Konfiguration, Status- und Logauszüge und erstellen Sie das Diagnoseprotokoll. Ohne eigenen Build, Start, Smoke-Test und Cleanup bleibt der Reproduzierbarkeitscheckpoint offen.