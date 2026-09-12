# Übung: Monolith vs. Microservices einordnen

**Dauer:** ca. 30 Minuten · **Typ:** Short Exercise · **Verändert die Projektbasis:** Nein

## Szenario

Die Kodschul-Bestell-Plattform (Order, Inventory, Notification) existiert aktuell nur als Idee auf dem Papier. Bevor ihr mit der Implementierung beginnt, bewertet ihr drei fiktive Systeme und leitet daraus eine Empfehlung für die Bestell-Plattform ab.

## Voraussetzungen

- Ihr habt `theory.md` gelesen.
- Keine weiteren Vorbereitungen nötig.

## Aufgaben

1. **Drei Systeme einordnen.** Bewertet für jedes der folgenden Systeme, ob ein Monolith oder Microservices sinnvoller sind. Nutzt die Kriterientabelle aus der Theorie und begründet jede Entscheidung in 1-2 Sätzen.
   - **System A:** Interne Werkzeug-App für 4 Personen, die einmal im Quartal Reports erzeugt. Ein Entwicklerteam, keine Skalierungsanforderung.
   - **System B:** Ein Online-Shop mit stark schwankendem Traffic im Checkout-Bereich (Weihnachtsgeschäft), aber gleichbleibend niedriger Last im Backoffice-Bereich. Drei Teams arbeiten parallel an Checkout, Backoffice und Reporting.
   - **System C:** Eine Studierenden-Verwaltungssoftware einer kleinen Hochschule, ein Team, überschaubare Nutzerzahl, seltene Änderungen.

2. **Bestell-Plattform einordnen.** Wendet dieselben Kriterien auf die geplante Kodschul-Bestell-Plattform an (Order, Inventory, Notification; siehe `system/context` und Kursüberblick). Haltet eure Einschätzung in 3-5 Sätzen fest und benennt mindestens zwei konkrete Kriterien, die eure Entscheidung tragen.

3. **Grenzfall diskutieren.** Nennt eine Eigenschaft, die sich bei System B ändern müsste, damit ein Monolith dort doch die bessere Wahl wäre.

## Checkpoint

Ihr habt für alle drei Systeme sowie die Bestell-Plattform eine begründete Tabellen- oder Stichpunkt-Einordnung vorliegen (Monolith oder Microservices, mindestens ein Kriterium als Begründung je System).

## Abschlusskriterium

- Alle vier Einordnungen (A, B, C, Bestell-Plattform) sind vorhanden und begründet.
- Die Begründung bezieht sich auf mindestens ein Kriterium aus der Theorie-Tabelle, nicht nur auf ein Bauchgefühl.
