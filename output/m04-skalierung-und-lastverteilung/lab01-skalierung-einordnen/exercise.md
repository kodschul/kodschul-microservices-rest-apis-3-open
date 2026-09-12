# Übung: Skalierung von Lastszenarien einordnen

**Dauer:** ca. 20 Minuten · **Typ:** Short Exercise · **Verändert die Projektbasis:** Nein

## Szenario

Ihr bewertet vier Lastszenarien der Bestell-Plattform und leitet daraus jeweils eine Skalierungsempfehlung ab.

## Aufgaben

1. **Vier Szenarien einordnen.** Ordnet jedem Szenario "horizontal", "vertikal" oder "Cloud-Autoscaling" zu und begründet in 1-2 Sätzen:
   - **Szenario A:** Der Order-Service bekommt an einem Aktionstag zehnmal so viele Anfragen wie sonst, an den übrigen Tagen normale Last.
   - **Szenario B:** Ein einzelner Analyse-Batch-Job läuft einmal täglich und braucht kurzzeitig viel Rechenleistung, aber nur ein einziger Prozess führt ihn aus.
   - **Szenario C:** Die Notification-Service-Last ist über das Jahr konstant und gut vorhersagbar.
   - **Szenario D:** Ein Praktikant vermutet, dass "mehr RAM" das Problem einer langsamen Datenbankabfrage lösen wird.

2. **Voraussetzung prüfen.** Erklärt, warum horizontale Skalierung des aktuellen Order-Service (Stand Modul 2) ohne Anpassung problematisch wäre.

3. **Cloud vs. feste Kapazität.** Nennt ein Kriterium, das für Cloud-Autoscaling spricht, und eines, das für feste Kapazität spricht.

## Checkpoint

Alle vier Szenarien sind eingeordnet und begründet; die In-Memory-Einschränkung aus Aufgabe 2 ist klar benannt.

## Abschlusskriterium

Jede Einordnung nennt mindestens ein Kriterium aus der Theorie (nicht nur eine Vermutung).
