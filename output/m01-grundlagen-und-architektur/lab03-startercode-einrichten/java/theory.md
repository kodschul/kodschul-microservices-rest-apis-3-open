---
theme: default
---

# Lab 3 (Java-Spur): Startercode einrichten und verifizieren

## Lernziel

Nach diesem Lab läuft euer persönlicher Order-Service (Java/Spring Boot) lokal, und ihr habt den Health-Endpunkt erfolgreich aufgerufen.

## Leitfragen

1. Woraus besteht das Starterprojekt, und welche Datei ist der Einstiegspunkt?
2. Wie startet man eine Spring-Boot-Anwendung lokal?
3. Woran erkennt man, dass der Service korrekt läuft?

## Projektstruktur des Starters

```text
order-service/
├── pom.xml                     # Maven-Build, Abhängigkeiten
├── src/main/java/com/kodschul/orderservice/
│   └── OrderServiceApplication.java   # Einstiegspunkt (main-Methode)
└── src/main/resources/
    └── application.yml         # Konfiguration (Port 8081)
```

`OrderServiceApplication` ist mit `@SpringBootApplication` annotiert. Diese Annotation aktiviert Auto-Konfiguration, Component-Scanning und die eingebettete Webserver-Startlogik. Die `main`-Methode ruft `SpringApplication.run(...)` auf und startet damit einen eingebetteten Tomcat-Server auf dem in `application.yml` konfigurierten Port.

## Der Actuator-Health-Endpunkt

Der Starter bindet `spring-boot-starter-actuator` ein. Dieser stellt automatisch `/actuator/health` bereit, ohne dass ihr selbst Code schreiben müsst. Das ist die schnellste Methode, um zu prüfen, ob eine Spring-Boot-Anwendung überhaupt läuft, bevor eigene Endpunkte existieren.

Erwartete Antwort:

```json
{"status":"UP"}
```

## Typische Startprobleme

| Symptom | Wahrscheinliche Ursache |
| --- | --- |
| `Port 8081 already in use` | Ein anderer Prozess (evtl. eine vorherige Instanz) belegt den Port bereits |
| `mvn: command not found` | Maven ist nicht installiert oder nicht im PATH |
| Build schlägt mit Abhängigkeitsfehlern fehl | Kein Zugriff auf Maven Central (Firewall/Proxy) - siehe Preflight-Hinweise des Trainers |

## Checkpoint

Ihr könnt eine Spring-Boot-Anwendung starten, den konfigurierten Port identifizieren und über `curl` oder den Browser den Health-Status abrufen.
