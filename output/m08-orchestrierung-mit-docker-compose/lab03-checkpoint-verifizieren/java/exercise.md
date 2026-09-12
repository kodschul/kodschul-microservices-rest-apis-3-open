# Übung (Java-Spur): Checkpoint verifizieren

**Dauer:** ca. 20 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr erstellt ein Checkpoint-Protokoll, das belegt, dass die gesamte Bestell-Plattform über `docker compose up` reproduzierbar funktioniert. Dieses Protokoll ist die Grundlage für Modul 9 (Tests, Resilienz, Deployment).

## Voraussetzungen

- Laufender Stack aus Lab 2.

## Aufgaben

1. **Status dokumentieren.** Führt `docker compose ps` aus und kopiert die Ausgabe in euer Protokoll.

2. **Erreichbarkeit dokumentieren.** Ruft die Health-Endpunkte beider Services auf und dokumentiert die Antworten.

3. **Funktionalen Nachweis erbringen.** Legt eine Testbestellung an, dokumentiert Request und Response, und zitiert die zugehörige Log-Zeile aus `docker compose logs notification-service`.

4. **Protokoll speichern.** Speichert das vollständige Protokoll als `CHECKPOINT.md` in eurem Projekt-Wurzelverzeichnis, nach dem Muster aus der Theorie.

## Checkpoint

`CHECKPOINT.md` enthält alle vier Nachweise (Status, Erreichbarkeit beider Services, funktionaler Nachweis mit Log-Zitat).

## Abschlusskriterium

Jemand, der nur `CHECKPOINT.md` liest, kann nachvollziehen, dass die Plattform funktioniert, ohne sie selbst starten zu müssen.
