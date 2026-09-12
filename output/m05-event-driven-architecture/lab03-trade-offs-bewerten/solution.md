# Lösung: Trade-offs von Event-Driven Architecture gegenüber REST bewerten

## Aufgabe 1: Bewertung

| Interaktion | Empfehlung | Begründung |
| --- | --- | --- |
| Kunde möchte sofortige Bestätigung | REST | Unmittelbare Antwort im selben Anfragezyklus notwendig. |
| Drei unabhängige Systeme sollen informiert werden | Ereigniskommunikation | Ein Ereignis, beliebig viele Konsumenten - der Order-Service muss die Konsumenten nicht einzeln kennen oder aufrufen. |
| Gezielte Suche nach einer Bestellung per ID | REST | Klassische, gezielte Abfrage mit sofortiger Antwort, kein Verteilungsbedarf an mehrere Konsumenten. |

## Aufgabe 2: Kompromiss (Beispiel für "drei unabhängige Systeme")

Kompromiss: Der Order-Service weiß nach dem Publizieren nicht mehr, ob und wann jedes der drei Systeme das Ereignis tatsächlich verarbeitet hat. Für Anwendungsfälle, die eine Zustellbestätigung brauchen, müsste zusätzlich ein Rückmeldemechanismus (z. B. ein weiteres Ereignis oder ein Status-Endpunkt) ergänzt werden.

## Aufgabe 3: Grenzfall mit zehn Systemen

Bei REST müsste der Order-Service zehn einzelne Aufrufe absetzen (oder eine Liste von Empfängern pflegen), was ihn mit jedem neuen Konsumenten stärker koppelt und langsamer macht (zehn synchrone Aufrufe hintereinander oder parallel verwalten). Bei Ereigniskommunikation ändert sich für den Order-Service nichts: Er publiziert weiterhin ein einziges Ereignis; neue Konsumenten abonnieren einfach zusätzlich die bestehende Routing-Key-Struktur. Ereigniskommunikation profitiert hier deutlich stärker von wachsender Konsumentenzahl.
