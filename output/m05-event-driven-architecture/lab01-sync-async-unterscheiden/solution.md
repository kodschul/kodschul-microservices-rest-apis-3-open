# Lösung: Synchrone/asynchrone Interaktionen unterscheiden

## Aufgabe 1: Einordnung

| Interaktion | Einordnung | Begründung |
| --- | --- | --- |
| `GET /orders/{id}` vom Kunden | synchron | Der Client wartet unmittelbar auf die Antwort mit dem aktuellen Status. |
| Order → Notification bei neuer Bestellung | asynchron | Der Order-Service publiziert ein Ereignis und wartet nicht auf dessen Verarbeitung. |
| `POST /orders` mit sofortiger Erfolgsprüfung | synchron | Das Frontend braucht die Bestätigung (oder den Fehler) direkt im selben Request-Zyklus. |
| Notification verschickt E-Mail nach Ereignisempfang | asynchron (Folge einer asynchronen Zustellung) | Der E-Mail-Versand geschieht entkoppelt vom ursprünglichen Bestellvorgang. |
| Monitoring fragt Health-Endpunkt ab | synchron | Klassischer Request/Response-Aufruf mit sofortiger Antwort. |

## Aufgabe 2: Musterzuordnung

Die Order→Notification-Interaktion folgt dem Muster **Event-Carried State Transfer**: Das Ereignis trägt bereits alle Daten (Bestell-ID, Kundenname, Artikel, Menge), die der Notification-Service für die Benachrichtigung braucht. Er muss den Order-Service nicht zusätzlich per REST befragen, um Details nachzuladen.

## Aufgabe 3: Kopplung

Bei einem direkten synchronen Aufruf müsste der Order-Service warten, bis der Notification-Service erreichbar ist und geantwortet hat - ein Ausfall der Benachrichtigung würde die Bestellannahme blockieren oder verlangsamen. Über RabbitMQ als Vermittler entsteht **zeitliche Entkopplung**: Der Order-Service publiziert das Ereignis und arbeitet sofort weiter, unabhängig davon, ob der Notification-Service gerade läuft, beschäftigt oder kurzzeitig nicht erreichbar ist.
