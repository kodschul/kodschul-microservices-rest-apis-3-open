# Lösung (Java-Spur): Eigenes Dockerfile schreiben

## `order-service/Dockerfile`

```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=build /build/target/order-service-0.1.0.jar app.jar
USER app
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## `notification-service/Dockerfile`

```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=build /build/target/notification-service-0.1.0.jar app.jar
USER app
EXPOSE 8091
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## `.dockerignore` (beide Projekte identisch)

```text
target/
.git/
*.md
```

## Abgleich mit Lab 1

| Problem aus Lab 1 | Behoben durch |
| --- | --- |
| Großes Basis-Image für Laufzeit | Zweite Stage nutzt `eclipse-temurin:17-jre-alpine`, nicht das Maven-Image. |
| Schlechtes Layer-Caching | `pom.xml` und `dependency:go-offline` vor `COPY src`. |
| Läuft als `root` | `USER app` nach dem Anlegen eines eigenen Nutzers. |
| Kein `.dockerignore` | `.dockerignore` mit `target/`, `.git/`, `*.md` ergänzt. |
