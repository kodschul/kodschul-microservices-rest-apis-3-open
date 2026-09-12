---
theme: default
---

# Lab 3 (Python-Spur): Startercode einrichten und verifizieren

## Lernziel

Nach diesem Lab läuft euer persönlicher Order-Service (Python/FastAPI) lokal, und ihr habt den Health-Endpunkt erfolgreich aufgerufen.

## Leitfragen

1. Woraus besteht das Starterprojekt, und welche Datei ist der Einstiegspunkt?
2. Wie startet man eine FastAPI-Anwendung lokal?
3. Woran erkennt man, dass der Service korrekt läuft?

## Projektstruktur des Starters

```text
order-service/
├── requirements.txt        # Abhängigkeiten (fastapi, uvicorn, pydantic)
└── app/
    └── main.py             # Einstiegspunkt: FastAPI-App-Instanz
```

`app/main.py` erzeugt mit `FastAPI(...)` die Anwendung und definiert mit `@app.get("/health")` einen einfachen Endpunkt. `uvicorn` ist der ASGI-Server, der diese Anwendung tatsächlich lauffähig macht - FastAPI selbst ist nur das Web-Framework, nicht der Server.

## Der Health-Endpunkt

```python
@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "UP"}
```

Erwartete Antwort:

```json
{"status":"UP"}
```

## Virtuelle Umgebungen

Python-Abhängigkeiten sollten nicht global installiert werden. `venv` erzeugt eine isolierte Umgebung pro Projekt, damit Versionskonflikte zwischen Kursprojekten vermieden werden.

## Typische Startprobleme

| Symptom | Wahrscheinliche Ursache |
| --- | --- |
| `ModuleNotFoundError: No module named 'fastapi'` | Virtuelle Umgebung nicht aktiviert oder `pip install -r requirements.txt` nicht ausgeführt |
| `Address already in use` | Ein anderer Prozess belegt Port 8081 bereits |
| `command not found: uvicorn` | Virtuelle Umgebung nicht aktiviert, oder Installation fehlgeschlagen |

## Checkpoint

Ihr könnt eine virtuelle Umgebung anlegen, Abhängigkeiten installieren, die Anwendung starten und über `curl` oder den Browser den Health-Status abrufen.
