# Übung (Java-Spur): Gesamten Stack starten

**Dauer:** ca. 35 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr startet die komplette Bestell-Plattform über die in Lab 1 erstellte `compose.yaml`.

## Voraussetzungen

- `compose.yaml` aus Lab 1.
- Keine der Einzel-Container aus Modul 7 laufen mehr (`docker ps` prüfen, ggf. `docker stop` bzw. `docker compose -f output/project/starter/rabbitmq-compose.yml down`).

## Aufgaben

1. **Stack starten.** Führt `docker compose up --build` aus und beobachtet die Startreihenfolge in der Konsolenausgabe.

2. **Zustand prüfen.** Führt in einem zweiten Terminal `docker compose ps` aus, bis alle drei Services `healthy` bzw. `running` anzeigen.

3. **End-to-End über den Stack testen.** Legt über `POST http://localhost:8081/orders` eine Bestellung an und prüft über `docker compose logs notification-service`, dass die Benachrichtigung protokolliert wurde.

4. **Neustart-Verhalten beobachten.** Beendet den Stack mit `Strg+C` (oder `docker compose down` in einem zweiten Terminal) und startet ihn erneut. Prüft, ob Order-Service beim zweiten Start wieder mit einer leeren Bestellliste beginnt, und erklärt warum (Rückbezug auf die In-Memory-Speicherung aus Modul 2/4).

## Checkpoint

Alle drei Services zeigen in `docker compose ps` den Status `healthy`/`running`; eine über den Stack angelegte Bestellung erzeugt eine protokollierte Benachrichtigung.

## Abschlusskriterium

Die Erklärung aus Aufgabe 4 nennt die In-Memory-Speicherung als Ursache dafür, dass Bestellungen nach einem Neustart nicht mehr vorhanden sind.
