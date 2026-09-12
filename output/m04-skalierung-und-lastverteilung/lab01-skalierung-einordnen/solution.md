# Lösung: Skalierung von Lastszenarien einordnen

## Aufgabe 1: Szenarien einordnen

| Szenario | Empfehlung | Begründung |
| --- | --- | --- |
| A: zehnfache Last an Aktionstagen | **Horizontal (idealerweise Cloud-Autoscaling)** | Schwankende, vorhersehbare Spitzen; zusätzliche Instanzen bei Bedarf sind kosteneffizienter als dauerhaft überdimensionierte Hardware. |
| B: einzelner Batch-Job, kurzzeitig rechenintensiv | **Vertikal** | Ein einzelner Prozess kann von mehr CPU/RAM profitieren; horizontale Skalierung hilft nicht, wenn nur eine Instanz die Arbeit ausführt. |
| C: konstante, vorhersagbare Last | **Feste Kapazität (vertikal oder eine feste Anzahl horizontaler Instanzen)** | Ohne Schwankung bringt Autoscaling wenig zusätzlichen Nutzen, aber zusätzliche Komplexität. |
| D: "mehr RAM" gegen langsame Datenbankabfrage | **Keine Skalierungsmaßnahme, sondern Ursachenanalyse** | Eine langsame Abfrage ist meist ein Indexierungs- oder Query-Problem; mehr RAM behebt die Ursache nicht zuverlässig. |

## Aufgabe 2: Voraussetzung für horizontale Skalierung

Der Order-Service speichert Bestellungen aktuell in einer prozesslokalen In-Memory-Map (Modul 2). Zwei horizontal skalierte Instanzen hätten **jeweils ihre eigene, unabhängige Kopie** der Daten - eine Bestellung, die bei Instanz 1 angelegt wurde, wäre bei Instanz 2 unsichtbar. Horizontale Skalierung setzt voraus, dass der Service entweder zustandslos ist oder seinen Zustand in einem gemeinsam genutzten, externen Speicher (z. B. einer Datenbank) hält.

## Aufgabe 3: Cloud vs. feste Kapazität

- **Für Cloud-Autoscaling spricht:** stark schwankende, schwer vorhersagbare Last (Szenario A) - man zahlt nur für tatsächlich benötigte Kapazität.
- **Für feste Kapazität spricht:** gleichmäßige, gut vorhersagbare Last (Szenario C) - Autoscaling-Infrastruktur (Metriken, Schwellenwerte, Testen der Skalierungsregeln) erzeugt Betriebsaufwand, der sich ohne Schwankung kaum auszahlt.
