---
theme: default
---

# Lab 2 (Python-Spur): Eigenes Dockerfile schreiben

## Lernziel

Nach diesem Lab habt ihr für Order-Service und Notification-Service je ein schlankes Dockerfile, das die in Lab 1 erkannten Probleme vermeidet.

## Leitfragen

1. Wie sorgt die Reihenfolge der Anweisungen für gutes Layer-Caching bei Python-Abhängigkeiten?
2. Wie wird ein Container mit einem nicht-privilegierten Nutzer betrieben?

## Dockerfile für FastAPI-Services

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

- `python:3.11-slim` ist eine feste, schlanke Version statt `latest`.
- `COPY requirements.txt .` und `RUN pip install` **vor** `COPY app ./app`: Abhängigkeiten werden separat gecacht und nur neu installiert, wenn sich `requirements.txt` ändert.
- `USER app` verhindert, dass der Container als `root` läuft.
- Ein Multi-Stage-Build ist bei Python seltener nötig als bei Java, da es keinen separaten Kompilierschritt gibt; `--no-cache-dir` hält das Image dennoch schlank.

## `.dockerignore`

```text
.venv/
__pycache__/
*.md
```

## Checkpoint

Ihr könnt ein Dockerfile für einen FastAPI-Service schreiben, das Abhängigkeiten cache-freundlich installiert und einen nicht-privilegierten Nutzer verwendet.
