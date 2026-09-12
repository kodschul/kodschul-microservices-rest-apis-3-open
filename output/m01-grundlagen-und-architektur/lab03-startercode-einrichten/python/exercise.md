# Übung (Python-Spur): Startercode einrichten und verifizieren

**Dauer:** ca. 45 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr richtet euer persönliches Order-Service-Projekt ein und bringt es zum ersten Mal zum Laufen.

## Voraussetzungen

- Python 3.11 oder neuer installiert (`python --version`).
- Starterprojekt aus `output/project/starter/python/order-service/` in euer Arbeitsverzeichnis kopiert.

## Aufgaben

1. **Projekt kopieren und öffnen.** Kopiert `output/project/starter/python/order-service/` in euer persönliches Arbeitsverzeichnis und öffnet es in eurer IDE.

2. **Virtuelle Umgebung anlegen.** Erstellt eine virtuelle Umgebung, aktiviert sie und installiert die Abhängigkeiten aus `requirements.txt`.

3. **Projekt starten.** Startet die Anwendung mit `uvicorn app.main:app --reload --port 8081`. Notiert euch die Konsolenzeile, die den erfolgreichen Start bestätigt.

4. **Health-Endpunkt aufrufen.** Ruft `http://localhost:8081/health` per Browser oder `curl` auf und dokumentiert die Antwort. Ruft zusätzlich `http://localhost:8081/docs` auf und beschreibt in 1-2 Sätzen, was dort zu sehen ist.

5. **Absichtlichen Fehler auslösen und beheben.** Benennt in `app/main.py` die Funktion `health` testweise in `healthcheck` um, ohne die Route-Annotation `@app.get("/health")` zu ändern. Startet neu, prüft, ob der Endpunkt weiterhin funktioniert, und erklärt, warum der Funktionsname für die Route irrelevant ist.

## Checkpoint

- Konsolenausgabe zeigt `Uvicorn running on http://127.0.0.1:8081`.
- `curl http://localhost:8081/health` liefert `{"status":"UP"}`.
- Ihr könnt erklären, warum `/docs` bereits ohne eigenen Code eine Oberfläche zeigt (Vorgriff auf Modul 3).

## Abschlusskriterium

Der Service läuft stabil auf Port 8081, der Health-Endpunkt antwortet mit Status `UP`, und ihr könnt erklären, welcher Teil des Codes für die Route und welcher für den Funktionsnamen verantwortlich ist.
