# Übung M05: REST oder Ereignis entscheiden und beobachten

## Szenario und Ziel

Die Bestellplattform verwendet bereits einen synchronen Java-Python-Aufruf. Nun werden konkrete Interaktionen anhand fachlicher Kriterien eingeordnet und der Versand als Ereignisfluss über RabbitMQ ausgeführt.

**Dauer Basispfad:** 120 Minuten, E07 45 Minuten und E06 75 Minuten
**Zielartefakt:** REST-/Messaging-Entscheidungsübersicht, ausführbarer Ereignisfluss und dokumentierter Redelivery-Befund

## Voraussetzungen und Starter

- abgeschlossener Java-Python-Checkpoint aus M04
- vorbereiteter RabbitMQ-Broker
- Publisher-, Queue- und Consumer-Gerüst
- Entscheidungsvorlage mit Kriterienfeldern
- API-Client und vorgesehene lokale Kursumgebung
- konfigurierte lokale Zugriffswerte, ohne sie in Artefakte zu übernehmen

## Aufgabe 1: Direkte Antwortbedarfe klassifizieren

1. Wählen Sie mindestens drei Interaktionen der Bestellplattform aus.
2. Prüfen Sie für jede Interaktion, ob der auslösende Ablauf sofort eine fachliche Antwort benötigt.
3. Dokumentieren Sie die Folgen einer nicht erreichbaren Gegenstelle.

**Checkpoint:** Die Übersicht trennt unmittelbare Antwortbedarfe von späteren Reaktionen.

## Aufgabe 2: Messaging-Alternativen bewerten

1. Bewerten Sie für dieselben Interaktionen zeitliche Kopplung und zulässige Konsistenzverzögerung.
2. Ordnen Sie jeder Interaktion REST oder Messaging zu.
3. Begründen Sie jede Wahl mit mindestens einem Kopplungs- und einem Konsistenzkriterium.

**Checkpoint:** Jede Zuordnung nennt Nutzen, Fehlergrenze und einen akzeptierten Nachteil.

## Aufgabe 3: Bestellereignis veröffentlichen

1. Prüfen Sie das vorbereitete Ereignisschema und die Publisher-Stelle.
2. Ergänzen Sie die Veröffentlichung des Versandereignisses an die vorgesehene Queue.
3. Lösen Sie den Versand für eine zuvor angelegte Bestellung aus.
4. Beobachten Sie die Annahme des Versandbefehls und die Broker-Aktivität getrennt.

**Checkpoint:** Ein Versandbefehl führt zu einer veröffentlichten Nachricht, ohne die Consumer-Verarbeitung vorzutäuschen.

## Aufgabe 4: Ereignis konsumieren

1. Prüfen Sie Queue-Bindung, Consumer und Bestätigungszeitpunkt.
2. Starten Sie die vorbereiteten Komponenten.
3. Warten Sie begrenzt auf das Verarbeitungsergebnis derselben Bestellung.
4. Vergleichen Sie Ereignistyp und Bestellbezug mit der veröffentlichten Nachricht.

**Checkpoint:** Das konsumierte Ereignis ist anhand seines Bestellbezugs beobachtbar.

## Aufgabe 5: Positiven und verzögerten Pfad vergleichen

1. Dokumentieren Sie die Reihenfolge von HTTP-Annahme, Veröffentlichung und Verarbeitung.
2. Unterbrechen Sie den Consumer kontrolliert und veröffentlichen Sie ein weiteres Ereignis.
3. Stellen Sie den Consumer wieder her und beobachten Sie die spätere Verarbeitung.

**Checkpoint:** Die Dokumentation zeigt die zeitliche Entkopplung und das Fenster verzögerter Konsistenz.

## Aufgabe 6: Verarbeitungsfehler und Redelivery analysieren

1. Aktivieren Sie den vorbereiteten Verarbeitungsfehler.
2. Beobachten Sie Consumer-Meldung, Bestätigung und Queue-Zustand.
3. Beheben Sie die vorbereitete Störung und verfolgen Sie die erneute Zustellung.
4. Prüfen Sie das fachliche Endergebnis auf mögliche Duplikate.

**Checkpoint:** Fehler, ausbleibende Bestätigung, Redelivery und Endzustand sind in ihrer Reihenfolge dokumentiert.

## Aufgabe 7: Trade-off-Entscheidung abschließen

1. Aktualisieren Sie die Entscheidungsübersicht mit den Beobachtungen aus dem Ereignisfluss.
2. Halten Sie für mindestens eine REST- und eine Messaging-Wahl den akzeptierten Nachteil fest.
3. Kennzeichnen Sie offene betriebliche Kontrollen für verzögerte oder doppelte Verarbeitung.

**Checkpoint:** Die Entscheidung ist fachlich begründet und behauptet keine kopplungs- oder fehlerfreie Kommunikation.

## Abschlusskriterien

- [ ] E07 ist als Kriterien- und Trade-off-Übersicht abgeschlossen.
- [ ] Das Versandereignis wird veröffentlicht und konsumiert.
- [ ] Das Ergebnis ist derselben Bestellung zugeordnet.
- [ ] Verzögerung, Fehler und Redelivery sind nachvollziehbar dokumentiert.
- [ ] Zugangswerte wurden nicht in öffentliche Artefakte übernommen.

## Erweiterung

Bewerten Sie eine weitere Interaktion, bei der beide Kommunikationsformen vertretbar sind. Dokumentieren Sie, welches Qualitätsziel die Entscheidung kippen würde. Die Erweiterung ist keine Voraussetzung für M06.

## Fallback

Falls RabbitMQ lokal nicht ausführbar ist, analysieren Sie bereitgestellte Publisher-, Queue-, Consumer- und Fehlerbeobachtungen und vervollständigen Sie die Entscheidungsübersicht. Ohne eigene Veröffentlichung, Verarbeitung und Redelivery bleibt der technische Messaging-Checkpoint offen.