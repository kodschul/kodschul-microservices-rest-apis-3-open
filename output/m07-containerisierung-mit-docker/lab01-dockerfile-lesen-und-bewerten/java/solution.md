# Lösung (Java-Spur): Dockerfile lesen und bewerten

## Aufgabe 1+2: Probleme und Verbesserungen

| Problem | Zeile | Verbesserung |
| --- | --- | --- |
| Großes Basis-Image für Laufzeit | `FROM maven:3.9-eclipse-temurin-17` | Multi-Stage-Build: Maven-Image nur zum Bauen, schlankes JRE-Image (z. B. `eclipse-temurin:17-jre-alpine`) für die Laufzeit. |
| Schlechtes Layer-Caching | `COPY . .` vor `RUN mvn package` | Erst `pom.xml` kopieren und Abhängigkeiten auflösen (`mvn dependency:go-offline`), danach den restlichen Code kopieren. |
| Läuft als `root` | Kein `USER`-Befehl vorhanden | Einen nicht-privilegierten Nutzer anlegen und mit `USER` aktivieren. |
| Kein `.dockerignore` | Gesamte Datei betroffen | `.dockerignore` mit `target/`, `.git/`, `*.md` ergänzen. |

## Aufgabe 3: Priorisierung

Die Nutzung als `root` würde zuerst behoben: Ein Sicherheitsrisiko wiegt schwerer als eine langsamere Build-Zeit oder ein größeres Image, auch wenn beide ebenfalls behoben werden sollten. In der Praxis empfiehlt sich aber, alle vier Punkte gemeinsam im finalen Dockerfile umzusetzen (siehe Lab 2).
