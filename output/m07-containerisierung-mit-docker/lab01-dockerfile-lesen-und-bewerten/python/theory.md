---
theme: default
---

# Lab 1 (Python-Spur): Dockerfile lesen und bewerten

## Lernziel

Nach diesem Lab könnt ihr ein gegebenes Dockerfile auf gängige Probleme hin bewerten (Basis-Image-Wahl, Cache-Nutzung, Rechte).

## Leitfragen

1. Welche Rolle spielt ein gepinntes Basis-Image gegenüber `latest`?
2. Wie beeinflusst die Reihenfolge der Anweisungen das Docker-Layer-Caching?
3. Warum sollte ein Container möglichst nicht als `root` laufen?

## Gegebenes Dockerfile (bewusst mit Schwachstellen)

```dockerfile
FROM python:latest

COPY . .
RUN pip install -r requirements.txt

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8081"]
```

## Typische Probleme in diesem Beispiel

| Problem | Erklärung |
| --- | --- |
| `python:latest` statt fester Version | `latest` kann sich jederzeit ändern und liefert dann eine andere Python-Version als getestet - reproduzierbare Builds brauchen eine gepinnte Version (z. B. `python:3.11-slim`). |
| `COPY . .` vor `RUN pip install` | Jede Codeänderung invalidiert den Docker-Cache für den kompletten Installationsschritt. `requirements.txt` sollte zuerst kopiert und installiert werden, danach der restliche Code. |
| Kein festgelegter Nutzer | Der Container läuft standardmäßig als `root`. |
| Kein `.dockerignore` | Ohne `.dockerignore` werden unnötige Dateien (z. B. `.venv/`, `__pycache__/`) mit in den Build-Kontext übertragen. |

## Checkpoint

Ihr könnt ein gegebenes Dockerfile auf diese vier Problemklassen hin untersuchen und Verbesserungsvorschläge benennen.
