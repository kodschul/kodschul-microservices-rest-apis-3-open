# Lösung (Java-Spur): Startercode einrichten und verifizieren

## Aufgabe 1: Projekt kopieren

Kein Code-Ergebnis, nur Kopiervorgang; wichtig ist, dass die Ordnerstruktur aus `output/project/starter/java/order-service/` unverändert übernommen wird.

## Aufgabe 2: Projekt starten

```bash
cd order-service
mvn spring-boot:run
```

Erwartete Ausgabe (gekürzt):

```text
...
Tomcat started on port 8081 (http) with context path ''
Started OrderServiceApplication in 1.9 seconds
...
```

## Aufgabe 3: Health-Endpunkt

```bash
curl http://localhost:8081/actuator/health
```

Erwartete Antwort:

```json
{"status":"UP"}
```

## Aufgabe 4: Fehlkonfiguration beobachten

`application.yml` mit ungültigem Port:

```yaml
server:
  port: -1
```

Beim Start erscheint sinngemäß:

```text
***************************
APPLICATION FAILED TO START
***************************

Description:
Failed to bind to port -1

Action:
Identify and stop the process that's listening on port -1, or configure this application to listen on another port.
```

Nach Zurücksetzen auf `port: 8081` startet die Anwendung wieder wie in Aufgabe 2 beschrieben.

## Typische Stolpersteine

- Wird `mvn spring-boot:run` aus dem falschen Verzeichnis aufgerufen (nicht dort, wo `pom.xml` liegt), meldet Maven `No POM in this directory`.
- Ein bereits laufender Prozess auf Port 8081 (z. B. eine nicht sauber beendete vorherige Instanz) erzeugt `Port already in use`; in dem Fall den alten Prozess beenden oder Port temporär ändern.
