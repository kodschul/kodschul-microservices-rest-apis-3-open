# Lösung (Python-Spur): Eigenes Dockerfile schreiben

## `order-service/Dockerfile`

```dockerfile
FROM python:3.11-slim

RUN groupadd -r app && useradd -r -g app app

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
USER app

EXPOSE 8081
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8081"]
```

## `notification-service/Dockerfile`

```dockerfile
FROM python:3.11-slim

RUN groupadd -r app && useradd -r -g app app

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
USER app

EXPOSE 8091
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8091"]
```

## `.dockerignore` (beide Projekte identisch)

```text
.venv/
__pycache__/
*.md
```

## Abgleich mit Lab 1

| Problem aus Lab 1 | Behoben durch |
| --- | --- |
| `python:latest` unpinned | `python:3.11-slim` fest gepinnt. |
| Schlechtes Layer-Caching | `requirements.txt` und `pip install` vor `COPY app`. |
| Läuft als `root` | `USER app` nach dem Anlegen eines eigenen Nutzers. |
| Kein `.dockerignore` | `.dockerignore` mit `.venv/`, `__pycache__/`, `*.md` ergänzt. |
