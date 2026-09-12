# Übung: Servicegrenzen für die Bestell-Plattform entwerfen

**Dauer:** ca. 45 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja (Architekturentscheidung, Grundlage für Modul 2)

## Szenario

Ihr entwerft die Servicegrenzen der Bestell-Plattform, bevor in Lab 3 der Startercode aufgesetzt wird. Das Ergebnis ist die verbindliche Grundlage für die REST-API in Modul 2.

## Voraussetzungen

- `theory.md` gelesen.
- Ergebnis aus Lab 1 (Empfehlung Microservices für die Bestell-Plattform).

## Aufgaben

1. **Komponenten zeichnen.** Skizziert (als Mermaid-Diagramm, ASCII-Skizze oder Tabelle) die vier Schichten des Order-Service aus der Theorie und tragt für jede Schicht mindestens ein konkretes Element ein (z. B. "API-Schicht: `OrderController`").

2. **Servicegrenzen begründen.** Erstellt eine Tabelle mit den Spalten `Service`, `Fachliche Verantwortung`, `Eigene Daten? (ja/nein)`, `Änderungsgrund`. Füllt sie für Order, Inventory und Notification aus eigenen Worten aus (nicht nur aus der Theorie abschreiben - nutzt ein zusätzliches konkretes Beispiel je Service).

3. **Schnittstellen benennen.** Legt fest, worüber Order und Inventory kommunizieren (synchron per REST oder asynchron?) und worüber Order und Notification kommunizieren. Begründet die Wahl in je einem Satz. (Die endgültige technische Umsetzung entsteht erst in Modul 4/5 - hier geht es um die bewusste Entscheidung.)

4. **Anti-Pattern erkennen.** Nennt ein Beispiel, wie eine schlechte Servicegrenze für die Bestell-Plattform aussehen könnte (z. B. ein Zuschnitt nach Technologie statt nach Fachlichkeit), und erklärt in 1-2 Sätzen, warum das problematisch wäre.

## Checkpoint

Ihr habt ein Architekturdiagramm oder eine gleichwertige Skizze sowie eine ausgefüllte Servicegrenzen-Tabelle mit begründeten Kommunikationsentscheidungen vorliegen.

## Abschlusskriterium

- Diagramm/Skizze zeigt alle vier Schichten mit mindestens einem konkreten Element je Schicht.
- Tabelle enthält alle drei Services mit eigener Begründung (nicht wortgleich aus der Theorie kopiert).
- Kommunikationsart (synchron/asynchron) ist für beide Beziehungen benannt und begründet.
