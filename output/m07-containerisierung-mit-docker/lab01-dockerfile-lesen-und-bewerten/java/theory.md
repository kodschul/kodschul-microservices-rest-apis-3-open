---
theme: default
---

# Lab 1 (Java-Spur): Dockerfile lesen und bewerten

## Lernziel

Nach diesem Lab könnt ihr ein gegebenes Dockerfile auf gängige Probleme hin bewerten (Image-Größe, Layer-Caching, Basis-Image-Wahl, Rechte).

## Leitfragen

1. Welche Rolle spielt die Wahl des Basis-Images für Größe und Sicherheit?
2. Wie beeinflusst die Reihenfolge der Anweisungen das Docker-Layer-Caching?
3. Warum sollte ein Container möglichst nicht als `root` laufen?

## Gegebenes Dockerfile (bewusst mit Schwachstellen)

```dockerfile
FROM maven:3.9-eclipse-temurin-17

COPY . .
RUN mvn package

CMD ["java", "-jar", "target/order-service-0.1.0.jar"]
```

## Typische Probleme in diesem Beispiel

| Problem | Erklärung |
| --- | --- |
| Ein einziges, großes Basis-Image | `maven:3.9-eclipse-temurin-17` enthält das komplette JDK und Maven - für die Laufzeit wird aber nur ein JRE gebraucht. Das Image wird unnötig groß. |
| `COPY . .` vor `RUN mvn package` | Jede Codeänderung invalidiert den Docker-Cache für den kompletten Build-Schritt, auch wenn sich nur eine Zeile geändert hat. Abhängigkeiten sollten separat kopiert und aufgelöst werden, bevor der restliche Code kopiert wird. |
| Kein festgelegter Nutzer | Der Container läuft standardmäßig als `root` - bei einer Sicherheitslücke im Prozess hat ein Angreifer mehr Rechte als nötig. |
| Kein `.dockerignore` | Ohne `.dockerignore` werden unnötige Dateien (z. B. `target/`, `.git/`) mit in den Build-Kontext übertragen, was den Build verlangsamt. |

## Checkpoint

Ihr könnt ein gegebenes Dockerfile auf diese vier Problemklassen hin untersuchen und Verbesserungsvorschläge benennen.
