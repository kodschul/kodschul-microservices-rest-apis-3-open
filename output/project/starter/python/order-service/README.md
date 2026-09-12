# Order-Service (Python-Spur) - Starterprojekt

Minimales FastAPI-Projekt für den Kurs "Microservices und REST API für Entwickler". Enthält nur die Projektstruktur und einen Health-Endpunkt; die Order-Domäne wird in Modul 2 ergänzt.

## Voraussetzungen

- Python 3.11+
- venv oder vergleichbares virtuelles Environment

## Starten

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8081
```

Health-Check:

```bash
curl http://localhost:8081/health
```

Erwartete Antwort: `{"status":"UP"}`
