# Übung: Skalierungsentscheidung dokumentieren

**Dauer:** ca. 30 Minuten · **Typ:** Discussion · **Verändert die Projektbasis:** Nein

## Szenario

Ihr erstellt ein kurzes Entscheidungsdokument, wie Order-Service und Notification-Service (ab Modul 6) skaliert werden sollen.

## Voraussetzungen

- Ergebnisse aus Lab 1 und Lab 2 dieses Moduls.

## Aufgaben

1. **Lastmuster einschätzen.** Beschreibt in je 1-2 Sätzen das erwartete Lastmuster für Order-Service (synchrone Kundenanfragen) und Notification-Service (asynchrone Ereignisverarbeitung).

2. **Option wählen.** Wählt für jeden der beiden Services eine Option aus der Theorie-Tabelle (oder eine eigene, begründete Alternative) und begründet die Wahl anhand des Lastmusters aus Aufgabe 1.

3. **Risiken benennen.** Nennt für jede gewählte Option mindestens ein Risiko oder einen Kompromiss (z. B. Kaltstartzeit bei Serverless, Kosten bei dauerhaft reservierter Kapazität).

4. **Dokument zusammenfassen.** Fasst Aufgabe 1-3 in einem kurzen Dokument (Tabelle oder Fließtext, ca. 10-15 Sätze) zusammen.

## Checkpoint

Ein Entscheidungsdokument mit Lastmuster, gewählter Option und mindestens einem Risiko je Service liegt vor.

## Abschlusskriterium

Beide Services (Order, Notification) sind mit je einer begründeten Skalierungsoption und einem benannten Risiko dokumentiert.
