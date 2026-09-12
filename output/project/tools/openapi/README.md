# OpenAPI-Werkzeuge

Dieses Verzeichnis nimmt die im Kurs verwendete Konfiguration für OpenAPI-Validierung und -Generierung auf. Die Übungen arbeiten vom Vertrag aus: Zuerst wird die Beschreibung geprüft, danach werden Auswirkungen auf Implementierung oder Client-Artefakte beobachtet.

## Validierungsziel

Die Validierung soll mindestens feststellen, ob:

- das Dokument syntaktisch lesbar ist,
- die OpenAPI-Struktur gültig ist,
- lokale Referenzen auflösbar sind,
- Operationen, Anfragen, Antworten und Schemas vollständig genug für den jeweiligen Checkpoint sind.

Platzhalter für die Kurskonfiguration:

- Validator-Konfiguration:
- Eingabevertrag:
- Ausgabe oder Prüfbericht:

## Generierungsziel

Die Generierung dient dazu, den Zusammenhang zwischen Vertrag und erzeugten Client- oder Server-Artefakten zu untersuchen. Generierte Dateien ersetzen weder fachliche Entscheidungen noch Implementierungs- und Vertragstests.

Platzhalter für die Kurskonfiguration:

- Generierungsrichtung:
- Eingabevertrag:
- Zielverzeichnis:
- Zusätzliche Optionen:

## Ausführung

Die konkrete Validator- und Generatorausführung muss die bereitgestellte Kursumgebung verwenden. Befehle und Konfiguration werden mit dem zugehörigen Checkpoint bereitgestellt. Verwende keine abweichende lokale Werkzeugversion, da sich Regeln und generierte Artefakte zwischen Versionen unterscheiden können.

Für Validator und Generator ist in diesem Projektkern keine Versionsnummer angegeben. Eine konkrete Version darf erst aus der bereitgestellten Kursumgebung übernommen werden.