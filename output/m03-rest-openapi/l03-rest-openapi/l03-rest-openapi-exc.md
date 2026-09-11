# Übung M03: REST-Vertrag entwerfen und prüfen

## Szenario und Ziel

Die in M02 begründete Order-Grenze benötigt einen Vertrag, den Java-Implementierung und weitere Services unabhängig verwenden können.

**Gesamtdauer:** 255 Minuten über Tag 1 und Tag 2
**Zielartefakt:** REST-Entwurf, validierter OpenAPI-Vertrag, Generierungsbeobachtung sowie positive, Grenz- und Fehlerchecks am Java-Endpunkt

## Voraussetzungen

- abgeschlossene Context Map aus M02
- bereitgestellter Java-Starterstand und Testgerüst
- vorbereitete OpenAPI-Ausgangsdatei und Validator
- API-Client
- vorbereitete Generator-Konfiguration für die Demo

## Aufgabe 1: Ressourcen und Operationen modellieren

1. Leiten Sie aus der Order-Verantwortung die benötigten Ressourcen ab.
2. Ordnen Sie jeder fachlichen Absicht eine HTTP-Methode und URI zu.
3. Begründen Sie, welche denkbaren Operationen nicht zum aktuellen Vertrag gehören.

**Checkpoint:** Jede Operation besitzt Ressource, Methode, URI und fachliche Begründung.

## Aufgabe 2: Repräsentation und Formatgrenze festlegen

1. Entwerfen Sie Request- und Response-Felder für die Bestellerstellung.
2. Kennzeichnen Sie Pflichtfelder, Typen und fachliche Grenzen.
3. Vergleichen Sie die Konsequenzen einer JSON- und einer XML-Repräsentation.
4. Dokumentieren Sie die Formatentscheidung für den Basispfad.

**Checkpoint:** Das Datenmodell ist vollständig und die Formatgrenze ist begründet.

## Aufgabe 3: Erfolgs-, Grenz- und Fehlerfälle entwerfen

1. Beschreiben Sie mindestens einen Erfolgsfall, einen Eingabegrenzfall und einen abhängigen Fehlerfall.
2. Ordnen Sie jedem Fall einen HTTP-Status und ein Antwortschema zu.
3. Definieren Sie für Fehler einen stabilen maschinenlesbaren Code und eine verständliche Meldung.

**Checkpoint:** Ein Client kann die drei Fallklassen ohne Textanalyse unterscheiden.

## Aufgabe 4: OpenAPI-Vertrag ergänzen und validieren

1. Übertragen Sie Ressourcen, Operationen, Schemas und Responses in die Ausgangsdatei.
2. Verwenden Sie wiederverwendbare Komponenten für gemeinsam genutzte Modelle.
3. Validieren Sie den Vertrag mit dem bereitgestellten Werkzeug.
4. Korrigieren Sie alle gemeldeten Struktur- und Referenzfehler.

**Checkpoint:** Der Validator meldet keine Vertragsfehler und alle drei Fallklassen sind beschrieben.

## Aufgabe 5: Generierung beobachten und bewerten

1. Beobachten Sie die Generierung eines Clients oder Server-Stubs aus dem Vertrag.
2. Vergleichen Sie das Ergebnis mit der vorbereiteten Variante.
3. Notieren Sie zwei konkrete Vorteile und zwei Grenzen für das Projekt.
4. Identifizieren Sie Dateien, die nicht manuell gepflegt werden sollten.

**Checkpoint:** Der Nutzen ist von Fachlogik, Versionierung und Wartungsrisiko abgegrenzt.

## Aufgabe 6: Java-Erfolgsfall an den Vertrag binden

1. Implementieren Sie die Bestellerstellung an der bestehenden Controller-Grenze.
2. Geben Sie eine vertragstreue Erfolgsantwort zurück.
3. Ergänzen Sie einen automatisierten positiven Check für Status und Antwortfelder.
4. Führen Sie denselben Fall über die öffentliche HTTP-Grenze aus.

**Checkpoint:** Implementierung, Test und beobachtete HTTP-Antwort stimmen mit dem Vertrag überein.

## Aufgabe 7: Eingabegrenze prüfen

1. Wählen Sie einen Wert direkt außerhalb einer dokumentierten Eingabegrenze.
2. Ergänzen Sie einen automatisierten Check für Status und Fehlerstruktur.
3. Prüfen Sie, dass keine erfolgreiche Verarbeitung erfolgt.

**Checkpoint:** Der Grenzfall ist reproduzierbar und vertragstreu abgelehnt.

## Aufgabe 8: Abhängigen Fehlerfall prüfen

1. Stellen Sie die Nichtverfügbarkeit des abhängigen Service kontrolliert her.
2. Rufen Sie die Bestellerstellung erneut auf.
3. Prüfen Sie Status, Fehlercode und verständliche Meldung.
4. Stellen Sie den Ausgangszustand wieder her.

**Checkpoint:** Der Java-Service bildet den Downstream-Ausfall stabil auf seinen öffentlichen Vertrag ab.

## Abschlusskriterien

- [ ] Ressourcen, Methoden und Schemas sind fachlich begründet.
- [ ] JSON ist praktisch festgelegt und XML vergleichend abgegrenzt.
- [ ] Der OpenAPI-Vertrag ist syntaktisch gültig.
- [ ] Generierungsnutzen und -grenzen sind dokumentiert.
- [ ] Positiver, Grenz- und Fehlerfall sind automatisiert und über HTTP geprüft.

## Erweiterung

Ändern Sie eine Schemaeinschränkung kontrolliert. Ermitteln Sie, welche Vertrags-, Client-, Implementierungs- und Testartefakte gemeinsam aktualisiert werden müssen.

## Fallback

Falls Generator oder laufende Services nicht verfügbar sind, verwenden Sie die bereitgestellten Generatorausgaben und aufgezeichneten HTTP-Ergebnisse für Vergleich und Vertragsreview. Ohne eigenen Validator- und Laufzeitcheck bleiben die technischen Checkpoints offen.