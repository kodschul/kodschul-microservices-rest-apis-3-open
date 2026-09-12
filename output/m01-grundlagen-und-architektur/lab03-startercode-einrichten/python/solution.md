# Lösung (Python-Spur): Startercode einrichten und verifizieren

## Aufgabe 1: Projekt kopieren

Kein Code-Ergebnis, nur Kopiervorgang; wichtig ist, dass `requirements.txt` und `app/main.py` unverändert übernommen werden.

## Aufgabe 2: Virtuelle Umgebung

```bash
cd order-service
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

## Aufgabe 3: Projekt starten

```bash
uvicorn app.main:app --reload --port 8081
```

Erwartete Ausgabe (gekürzt):

```text
INFO:     Uvicorn running on http://127.0.0.1:8081 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Application startup complete.
```

## Aufgabe 4: Health-Endpunkt und Dokumentation

```bash
curl http://localhost:8081/health
```

```json
{"status":"UP"}
```

`http://localhost:8081/docs` zeigt die automatisch generierte **Swagger UI**: FastAPI erzeugt aus den Typannotationen und Routen-Dekoratoren automatisch eine OpenAPI-Beschreibung und rendert daraus eine interaktive Oberfläche - das ist bereits eine Vorschau auf Modul 3.

## Aufgabe 5: Fehlkonfiguration/Umbenennung

```python
@app.get("/health")
def healthcheck() -> dict[str, str]:
    return {"status": "UP"}
```

Der Endpunkt funktioniert weiterhin unter `/health`, weil FastAPI die Route über das Argument in `@app.get("/health")` registriert, nicht über den Funktionsnamen. Der Funktionsname ist nur innerhalb des Python-Moduls relevant (z. B. für Referenzierung, automatisch generierte `operationId` in der OpenAPI-Spezifikation).

## Typische Stolpersteine

- Wird `uvicorn` ohne aktivierte virtuelle Umgebung aufgerufen, meldet die Shell `command not found`.
- Wird der Modulpfad falsch angegeben (`main:app` statt `app.main:app`), meldet uvicorn `Error loading ASGI app`.
