# Übung: Synchrone/asynchrone Interaktionen unterscheiden

**Dauer:** ca. 30 Minuten · **Typ:** Short Exercise · **Verändert die Projektbasis:** Nein

## Szenario

Ihr analysiert fünf Interaktionen der Bestell-Plattform und ordnet sie ein.

## Aufgaben

1. **Fünf Interaktionen einordnen.** Ordnet jeder Interaktion "synchron" oder "asynchron" zu und begründet in 1 Satz:
   - Ein Kunde ruft `GET /orders/{id}` auf, um den Status seiner Bestellung zu sehen.
   - Der Order-Service informiert den Notification-Service, dass eine neue Bestellung angelegt wurde.
   - Ein Frontend prüft per `POST /orders` synchron, ob eine Bestellung erfolgreich angelegt wurde.
   - Der Notification-Service verschickt (fiktiv) eine E-Mail, nachdem er ein Ereignis empfangen hat.
   - Ein Monitoring-System fragt periodisch `GET /actuator/health` bzw. `GET /health` ab.

2. **Muster zuordnen.** Ordnet der Order→Notification-Interaktion aus Aufgabe 1 eines der drei EDA-Grundmuster aus der Theorie zu und begründet, warum es passt.

3. **Kopplung bewerten.** Erklärt in 2-3 Sätzen, warum asynchrone Ereigniskommunikation die zeitliche Kopplung zwischen Order- und Notification-Service reduziert, verglichen mit einem direkten synchronen Aufruf.

## Checkpoint

Alle fünf Interaktionen sind eingeordnet, ein EDA-Muster ist begründet zugeordnet.

## Abschlusskriterium

Die Begründung in Aufgabe 3 nennt explizit "zeitliche Kopplung" oder eine gleichwertige eigene Formulierung des Konzepts.
