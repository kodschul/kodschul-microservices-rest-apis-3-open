# Notification-Service (Python-Spur) - Starterprojekt

Minimales FastAPI-Projekt mit `pika` als RabbitMQ-Client. Enthält nur die Projektstruktur und einen Health-Endpunkt; der RabbitMQ-Consumer wird in Modul 6 ergänzt.

## Voraussetzungen

- Python 3.11+
- Laufende RabbitMQ-Instanz (`output/project/starter/rabbitmq-compose.yml`)

## Starten

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8091
```

Health-Check:

```bash
curl http://localhost:8091/health
```
