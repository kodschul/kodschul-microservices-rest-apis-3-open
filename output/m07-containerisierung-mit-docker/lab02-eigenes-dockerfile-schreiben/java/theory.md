---
theme: default
---

# Lab 2 (Java-Spur): Eigenes Dockerfile schreiben

## Lernziel

Nach diesem Lab habt ihr für Order-Service und Notification-Service je ein mehrstufiges (Multi-Stage) Dockerfile, das die in Lab 1 erkannten Probleme vermeidet.

## Leitfragen

1. Wie trennt ein Multi-Stage-Build Build- und Laufzeitumgebung?
2. Wie wird ein Container mit einem nicht-privilegierten Nutzer betrieben?

## Multi-Stage-Build für Spring Boot

```dockerfile
# Stage 1: Bauen
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Laufzeit
FROM eclipse-temurin:17-jre-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=build /build/target/*.jar app.jar
USER app
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
```

- **Stage 1** nutzt das große Maven/JDK-Image nur zum Bauen; es landet nicht im finalen Image.
- `COPY pom.xml .` und `mvn dependency:go-offline` **vor** `COPY src`: Abhängigkeiten werden separat gecacht und nur neu geladen, wenn sich `pom.xml` ändert.
- **Stage 2** nutzt ein schlankes JRE-Basis-Image und kopiert nur das gebaute JAR.
- `USER app` verhindert, dass der Container als `root` läuft.

## `.dockerignore`

```text
target/
.git/
*.md
```

## Checkpoint

Ihr könnt ein Multi-Stage-Dockerfile für einen Spring-Boot-Service schreiben, das Build- und Laufzeitumgebung trennt und einen nicht-privilegierten Nutzer verwendet.
