---
theme: default
---

# Lab 3: Trade-offs von Event-Driven Architecture gegenüber REST

## Lernziel

Nach diesem Lab könnt ihr begründen, wann Ereigniskommunikation REST-Kommunikation vorzuziehen ist und welche Kosten das mit sich bringt.

## Leitfragen

1. Welche Vorteile bietet Ereigniskommunikation gegenüber REST?
2. Welche Kosten oder Risiken entstehen dadurch?

## Vorteile von Ereigniskommunikation

- **Zeitliche Entkopplung:** Sender und Empfänger müssen nicht gleichzeitig verfügbar sein (siehe Lab 1).
- **Mehrere Konsumenten ohne Zusatzaufwand für den Sender:** Ein Ereignis kann von beliebig vielen Diensten konsumiert werden, ohne dass der Order-Service sie kennen muss.
- **Pufferung bei Lastspitzen:** Die Warteschlange gleicht kurzfristige Lastunterschiede zwischen Erzeuger und Konsument aus.

## Kosten von Ereigniskommunikation

- **Zusätzliche Infrastruktur:** Ein Message Broker muss betrieben, überwacht und abgesichert werden.
- **Schwerer nachvollziehbare Abläufe:** Ein Fehler kann zeitlich versetzt und an anderer Stelle sichtbar werden als seine Ursache (siehe Modul 6, Fehlerfallbetrachtung).
- **Nachrichtenzustellung ist nicht "exactly once":** Konsumenten müssen mit doppelten oder verzögerten Nachrichten umgehen (siehe `messaging-contract.md`).
- **Kein sofortiges Feedback:** Der Sender weiß nicht unmittelbar, ob und wie ein Konsument das Ereignis verarbeitet hat.

## Faustregel für die Wahl

REST passt, wenn der Aufrufer eine unmittelbare Antwort braucht, um weiterzuarbeiten. Ereigniskommunikation passt, wenn mehrere unabhängige Konsumenten informiert werden sollen und eine leichte Verzögerung akzeptabel ist.

## Checkpoint

Ihr könnt für ein gegebenes Szenario abwägen, ob REST oder Ereigniskommunikation besser passt, und mindestens einen Kompromiss benennen.
