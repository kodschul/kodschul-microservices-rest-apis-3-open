# Übung M04: FastAPI aus Java integrieren

## Szenario und Ziel

Der Order Service soll nach einer Bestellerstellung den vorbereiteten Notification Service aufrufen. Beide Services bleiben unabhängig implementiert und teilen nur ihren HTTP-Vertrag.

**Dauer Basispfad:** 45 Minuten, davon 25 Minuten an Tag 1 und 20 Minuten an Tag 2
**Zielartefakt:** funktionierende Java-Python-Interaktion mit dokumentiertem Erfolgs- und Downstream-Fehlerfall

## Voraussetzungen

- abgeschlossener M03-Vertrag und funktionsfähiger Java-Erfolgsendpunkt
- vorbereiteter FastAPI-Service
- Java-Clientgerüst oder markierte Adapterstelle
- API-Client und freie Kursports
- keine Python-Vorkenntnisse für den Basispfad

## Aufgabe 1: FastAPI-Vertrag beobachten

1. Starten Sie den vorbereiteten Notification Service mit dem vorgesehenen Kursweg.
2. Prüfen Sie seinen Health-Endpunkt.
3. Vergleichen Sie die veröffentlichte Operation mit dem Vertrag aus M03.
4. Halten Sie erforderliche Request- und Response-Felder fest.

**Checkpoint:** Bereitschaft, Operation und Feldabbildung sind dokumentiert.

## Aufgabe 2: Java-Adapter ergänzen

1. Ergänzen Sie einen Java-Client an der vorbereiteten Adapterstelle.
2. Beziehen Sie die Basisadresse aus der Laufzeitkonfiguration.
3. Bilden Sie Java-Felder explizit auf die veröffentlichten JSON-Felder ab.
4. Geben Sie nur das für die Order-Fachlogik benötigte Ergebnis zurück.

**Checkpoint:** Netzwerk- und JSON-Details bleiben außerhalb der Order-Fachlogik.

## Aufgabe 3: Erfolgsaufruf verbinden

1. Rufen Sie den Adapter nach erfolgreicher Bestellerstellung auf.
2. Übernehmen Sie das Downstream-Ergebnis in die Order-Antwort.
3. Ergänzen Sie einen automatisierten Check mit kontrolliertem Clientverhalten.

**Checkpoint:** Die Java-Anwendungslogik liefert Bestellung und Benachrichtigungsergebnis gemeinsam zurück.

## Aufgabe 4: Ende-zu-Ende-Erfolg prüfen

1. Starten Sie beide Services.
2. Senden Sie eine gültige Bestellung an den Java-Endpunkt.
3. Prüfen Sie Status und alle vertraglich relevanten Antwortfelder.
4. Sichern Sie die beobachtete Request-Response-Beziehung.

**Checkpoint:** Der Aufruf durchläuft Java und Python und endet mit einer vertragstreuen Java-Antwort.

## Aufgabe 5: Downstream-Ausfall abbilden

1. Übersetzen Sie Transportfehler des Java-Clients in eine anwendungsbezogene Ausnahme.
2. Bilden Sie diese Ausnahme zentral auf die öffentliche Fehlerstruktur ab.
3. Stellen Sie die Nichtverfügbarkeit des Notification Service kontrolliert her.
4. Wiederholen Sie den Order-Aufruf und dokumentieren Sie das Ergebnis.

**Checkpoint:** Die öffentliche Antwort bleibt stabil und enthält keine internen Fehlerdetails.

## Aufgabe 6: Wiederherstellung prüfen

1. Starten Sie den Notification Service erneut.
2. Wiederholen Sie den Erfolgsaufruf ohne Codeänderung am Order Service.
3. Vergleichen Sie Erfolg, Ausfall und Wiederherstellung.
4. Notieren Sie die verbleibende zeitliche Kopplung.

**Checkpoint:** Konfiguration und Adapter funktionieren nach Wiederherstellung unverändert.

## Abschlusskriterien

- [ ] FastAPI wurde ohne Python-Änderung als vorbereiteter Service genutzt.
- [ ] Java bildet Request und Response explizit auf den Vertrag ab.
- [ ] Der Ende-zu-Ende-Erfolgsfall ist reproduzierbar.
- [ ] Downstream-Ausfall und Wiederherstellung sind dokumentiert.
- [ ] Interne Transportfehler gelangen nicht in die öffentliche API.

## Erweiterung

**E05X, optional, bis zu 30 Minuten:** Verändern Sie ein Verhalten des FastAPI-Service innerhalb eines bewusst aktualisierten Vertrags. Passen Sie Vertrag und betroffene Tests gemeinsam an und validieren Sie erneut. Die Erweiterung darf den Pflichtstand nicht blockieren.

## Fallback

Falls keine lokale Python-Laufzeit verfügbar ist, verwenden Sie den vorbereiteten Service als Container. Falls auch dieser nicht gestartet werden kann, analysieren Sie bereitgestellte Antworten und Logs; ohne eigenen Ende-zu-Ende-Aufruf bleibt der Integrationscheckpoint offen.