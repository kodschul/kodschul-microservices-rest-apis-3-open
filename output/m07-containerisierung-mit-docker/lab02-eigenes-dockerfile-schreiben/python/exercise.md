# Übung (Python-Spur): Eigenes Dockerfile schreiben

**Dauer:** ca. 35 Minuten · **Typ:** Guided Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr schreibt Dockerfiles für Order-Service und Notification-Service, die die in Lab 1 erkannten Probleme vermeiden.

## Voraussetzungen

- Order-Service (Modul 6) und Notification-Service (Modul 6) lauffähig.

## Aufgaben

1. **Dockerfile für den Order-Service.** Erstellt `Dockerfile` im Order-Service-Projekt nach dem Muster aus der Theorie (feste Python-Version, cache-freundliche Reihenfolge, nicht-privilegierter Nutzer, Port `8081`).

2. **Dockerfile für den Notification-Service.** Wiederholt Aufgabe 1 für den Notification-Service (Port `8091`). Da das Muster identisch ist, sollte das deutlich schneller gehen.

3. **`.dockerignore` ergänzen.** Legt in beiden Projekten eine `.dockerignore` an (`.venv/`, `__pycache__/`, `*.md`).

4. **Gegen Lab 1 prüfen.** Vergleicht eure Dockerfiles mit der Problemliste aus Lab 1 und bestätigt, dass keines der vier Probleme mehr zutrifft.

## Checkpoint

Beide Projekte enthalten ein Dockerfile und eine `.dockerignore`; keines der vier Probleme aus Lab 1 trifft mehr zu.

## Abschlusskriterium

Beide Dockerfiles verwenden eine feste Python-Version, installieren Abhängigkeiten vor dem Kopieren des restlichen Codes und laufen nicht als `root`.
