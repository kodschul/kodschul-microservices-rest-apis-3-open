# Übung: Trade-offs von Event-Driven Architecture gegenüber REST bewerten

**Dauer:** ca. 30 Minuten · **Typ:** Discussion · **Verändert die Projektbasis:** Nein

## Szenario

Ihr bewertet für die Bestell-Plattform, wo Ereigniskommunikation sinnvoll ist und wo REST vorzuziehen bleibt.

## Aufgaben

1. **Drei Interaktionen bewerten.** Entscheidet für jede der folgenden Interaktionen, ob REST oder Ereigniskommunikation besser passt, und begründet:
   - Ein Kunde möchte sofort wissen, ob seine Bestellung angenommen wurde.
   - Drei unabhängige Systeme (Benachrichtigung, Statistik, Lager) sollen von jeder neuen Bestellung erfahren.
   - Ein Support-Mitarbeiter sucht gezielt nach einer einzelnen Bestellung anhand ihrer ID.

2. **Kompromiss benennen.** Wählt eine der drei Interaktionen aus Aufgabe 1 und benennt einen konkreten Kompromiss (Kosten, Risiko), den eure Wahl bewusst in Kauf nimmt.

3. **Grenzfall diskutieren.** Was würde sich ändern, wenn plötzlich zehn statt drei Systeme über neue Bestellungen informiert werden müssten? Begründet, welcher Ansatz (REST oder Ereigniskommunikation) davon eher profitiert.

## Checkpoint

Alle drei Interaktionen sind bewertet, ein Kompromiss ist benannt, der Grenzfall ist diskutiert.

## Abschlusskriterium

Die Antwort zu Aufgabe 3 begründet die Skalierbarkeit der Ereigniskommunikation mit mehreren Konsumenten ohne Zusatzaufwand für den Sender.
