# Lösung (Python-Spur): Dockerfile lesen und bewerten

## Aufgabe 1+2: Probleme und Verbesserungen

| Problem | Zeile | Verbesserung |
| --- | --- | --- |
| `python:latest` unpinned | `FROM python:latest` | Feste Version verwenden, z. B. `python:3.11-slim`. |
| Schlechtes Layer-Caching | `COPY . .` vor `RUN pip install` | Erst `requirements.txt` kopieren und installieren, danach den restlichen Code kopieren. |
| Läuft als `root` | Kein `USER`-Befehl vorhanden | Einen nicht-privilegierten Nutzer anlegen und mit `USER` aktivieren. |
| Kein `.dockerignore` | Gesamte Datei betroffen | `.dockerignore` mit `.venv/`, `__pycache__/`, `*.md` ergänzen. |

## Aufgabe 3: Priorisierung

Die unpinned `python:latest`-Version würde zuerst behoben: Ohne feste Version kann ein Build heute anders ausfallen als morgen, was die Reproduzierbarkeit gefährdet - ein grundlegenderes Problem als Build-Geschwindigkeit oder Image-Größe. In der Praxis empfiehlt sich, alle vier Punkte gemeinsam im finalen Dockerfile umzusetzen (siehe Lab 2).
