# Übung (Java-Spur): Startercode einrichten und verifizieren

**Dauer:** ca. 45 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Ja

## Szenario

Ihr richtet euer persönliches Order-Service-Projekt ein und bringt es zum ersten Mal zum Laufen.

## Voraussetzungen

- JDK 17 installiert (`java -version` zeigt 17 oder neuer).
- Maven 3.9+ installiert (`mvn -version`).
- Starterprojekt aus `output/project/starter/java/order-service/` in euer Arbeitsverzeichnis kopiert.

## Aufgaben

1. **Projekt kopieren und öffnen.** Kopiert `output/project/starter/java/order-service/` in euer persönliches Arbeitsverzeichnis und öffnet es in eurer IDE.

2. **Projekt starten.** Startet die Anwendung mit `mvn spring-boot:run`. Notiert euch die Zeilen aus der Konsolenausgabe, die den verwendeten Port und den erfolgreichen Start bestätigen (Suchbegriff: `Tomcat started on port`).

3. **Health-Endpunkt aufrufen.** Ruft `http://localhost:8081/actuator/health` per Browser oder `curl` auf und dokumentiert die Antwort.

4. **Absichtlichen Fehler auslösen und beheben.** Ändert in `application.yml` den Port testweise auf `-1` (ungültig), startet neu und beobachtet die Fehlermeldung. Setzt den Port danach wieder auf `8081` zurück und bestätigt, dass der Service wieder startet.

## Checkpoint

- Konsolenausgabe zeigt einen erfolgreichen Start ohne Exceptions.
- `curl http://localhost:8081/actuator/health` liefert `{"status":"UP"}`.
- Ihr habt eine absichtliche Fehlkonfiguration beobachtet und wieder korrigiert.

## Abschlusskriterium

Der Service läuft stabil auf Port 8081, der Health-Endpunkt antwortet mit Status `UP`, und ihr könnt die Bedeutung der Konsolenausgabe beim Start in eigenen Worten erklären.
