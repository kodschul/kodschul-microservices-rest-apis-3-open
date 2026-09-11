# Übung M07: Testlücke schließen und Teilausfall kontrollieren

## Szenario und Ziel

Die Bestellplattform läuft als Compose-Landschaft. Vor einer Produktionsentscheidung soll nicht die größtmögliche Testmenge entstehen, sondern eine belegte Lücke geschlossen, der Cross-Service-Vertrag geprüft und ein vorbereiteter Teilausfall mit einer passenden Kontrolle begrenzt werden.

**Dauer Basispfad:** 110 Minuten, E10
**Zielartefakt:** ergänzter Test, Test- und Evidenzprotokoll sowie begründete Resilienzentscheidung

## Voraussetzungen und Starter

- abgeschlossener M06-Basispfad
- lauffähige Compose-Landschaft mit Java, Python und RabbitMQ
- vorhandene Java- und Python-Testgerüste
- veröffentlichter Notification-Vertrag und Laufzeitschema
- vorbereiteter Teilausfall des Notification Service
- Vorlage mit Risiko, Testebene, Beobachtung, Ursache, Kontrolle und Trade-off

## Aufgabe 1: Risiken den Testebenen zuordnen

1. Ordnen Sie mindestens vier Risiken den Ebenen Unit, Vertrag, Integration und End-to-End zu.
2. Prüfen Sie die vorhandenen Tests gegen positiven, Grenz- und Fehlerfall.
3. Wählen Sie genau eine relevante Lücke für den Basispfad.
4. Begründen Sie, warum die gewählte Ebene die engste verlässliche Prüfung ist.

**Checkpoint:** Die Testlücke ist als konkretes Risiko formuliert und einer geeigneten Testebene zugeordnet.

## Aufgabe 2: Gewählte Testlücke schließen

1. Ergänzen Sie einen fokussierten Test im vorhandenen Testgerüst.
2. Führen Sie zunächst nur den neuen Test aus.
3. Führen Sie danach die zugehörige Testsuite aus.
4. Notieren Sie Testname, beobachtetes Verhalten und Ergebnis im Protokoll.

**Checkpoint:** Der neue Test und seine Testsuite laufen reproduzierbar; die Lücke ist durch beobachtbares Verhalten geschlossen.

## Aufgabe 3: Cross-Service-Vertrag prüfen

1. Führen Sie den vorhandenen Vertragstest zwischen veröffentlichtem Vertrag und FastAPI-Laufzeitschema aus.
2. Ordnen Sie die geprüften Pfade, Methoden, Antworten und Schemaeinschränkungen zu.
3. Ergänzen Sie den positiven Java-Python-Durchstich als Integrationsnachweis.
4. Halten Sie fest, welches Risiko der Vertragstest erkennt und welches erst der Integrationsnachweis erkennt.

**Checkpoint:** Vertrag und laufende Servicegrenze sind getrennt geprüft; ihre unterschiedlichen Aussagen sind dokumentiert.

## Aufgabe 4: Vorbereiteten Teilausfall diagnostizieren

1. Aktivieren Sie nur den bereitgestellten Teilausfall des Notification Service.
2. Führen Sie positiven, Grenz- und Downstream-Fehlerfall aus.
3. Erfassen Sie Testergebnis, Service-Status und zeitlich passende Logs.
4. Trennen Sie Symptom, Evidenz und Ursache im Protokoll.

**Checkpoint:** Der Fehlerfall ist reproduziert; Status und Logs stützen dieselbe Ursache, während der Grenzfall weiterhin lokal verarbeitet wird.

## Aufgabe 5: Befund reproduzieren und Kontrolle auswählen

1. Stellen Sie nach der Pause den vorgesehenen Ausgangszustand wieder her.
2. Aktivieren Sie denselben Teilausfall erneut und bestätigen Sie den Befund.
3. Vergleichen Sie Timeout, begrenzte Wiederholung und Idempotenz für diesen Aufruf.
4. Wählen Sie eine Kontrolle, die ohne neue Pflichtinfrastruktur testbar ist.

**Checkpoint:** Die Diagnose ist nach der Pause reproduziert und die Kontrolle anhand von Seiteneffekt, Last und Wartezeit ausgewählt.

## Aufgabe 6: Kontrolle testen und Trade-off begründen

1. Wenden Sie die gewählte Kontrolle in der vorbereiteten Variante begrenzt an.
2. Wiederholen Sie positiven, Grenz- und Teilausfallfall.
3. Vergleichen Sie Verhalten und Evidenz vor und nach der Kontrolle.
4. Begründen Sie Nutzen, neue Gefahr und bewusste Restgrenze.

**Checkpoint:** Die Kontrolle begrenzt das beobachtete Verhalten, ohne den positiven oder den Grenzfall zu verschlechtern; der Trade-off ist belegt.

## Abschlusskriterien

- [ ] Eine risikobasierte Testlücke wurde geschlossen.
- [ ] Vertragstest und Cross-Service-Integration wurden getrennt nachgewiesen.
- [ ] Positiver, Grenz- und Teilausfallfall wurden ausgeführt.
- [ ] Der Fehler wurde vor und nach der Pause mit Test, Status und Logs reproduziert.
- [ ] Eine begrenzte Kontrolle wurde getestet und mit Restgrenze begründet.

## Erweiterung

Entwerfen Sie zusätzlich einen Duplikatfall und die dafür nötige Idempotenzregel. Die Erweiterung darf weder den M07-Basispfad verändern noch Voraussetzung für M08 werden.

## Fallback

Falls die Container-Runtime ausfällt, verwenden Sie die bereitgestellten Test-, Status- und Logauszüge für Risikoanalyse, Vertragsvergleich und Resilienzentscheidung. Ohne eigenen Testlauf, Fehlerinjektion und Wiederholung bleiben Ausführbarkeit und Reproduzierbarkeit offen.