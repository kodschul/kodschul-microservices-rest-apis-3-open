# Order-Service (Java-Spur) - Starterprojekt

Minimales Spring-Boot-3-Projekt für den Kurs "Microservices und REST API für Entwickler". Enthält nur die Projektstruktur und Actuator-Healthcheck; die Order-Domäne wird in Modul 2 ergänzt.

## Voraussetzungen

- JDK 17
- Maven 3.9+ (oder das mitgelieferte `mvnw`, falls vorhanden)

## Starten

```bash
mvn spring-boot:run
```

Der Service startet auf Port `8081`. Health-Check:

```bash
curl http://localhost:8081/actuator/health
```

Erwartete Antwort: `{"status":"UP"}`
