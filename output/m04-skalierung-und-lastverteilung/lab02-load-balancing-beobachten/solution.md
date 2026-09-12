# Lösung: Load Balancing beobachten

## Aufgabe 1+2: Zweite Instanz und Load Balancer starten

Java:

```bash
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082
```

Python:

```bash
uvicorn app.main:app --port 8082
```

nginx:

```bash
docker run --rm -p 8080:8080 \
  -v "$PWD/output/project/starter/nginx/loadbalancer.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:1.27
```

## Aufgabe 3: Verteilung beobachten

Sechs aufeinanderfolgende Aufrufe von `curl http://localhost:8080/health` (Python) bzw. `curl http://localhost:8080/actuator/health` (Java) zeigen in den jeweiligen Konsolen der beiden Instanzen abwechselnd eingehende Anfragen - nginx verteilt im Round-Robin-Verfahren (Instanz 1, Instanz 2, Instanz 1, Instanz 2, ...).

## Aufgabe 4: Zustandsproblem

Eine über `http://localhost:8080/orders` angelegte Bestellung landet nur im In-Memory-Speicher **einer** der beiden Instanzen (je nachdem, welche nginx für den `POST`-Aufruf gewählt hat). Ruft man danach wiederholt `GET http://localhost:8080/orders` auf, erscheint die Bestellung nur in etwa der Hälfte der Antworten - abhängig davon, welche Instanz nginx gerade für die jeweilige `GET`-Anfrage ausgewählt hat.

## Aufgabe 5: Dokumentierte Beobachtung (Beispiel)

"Der Load Balancer verteilt Anfragen im Wechsel auf beide Instanzen. Eine neu angelegte Bestellung ist jedoch nur bei der Instanz sichtbar, die die `POST`-Anfrage entgegengenommen hat, weil jede Instanz ihre eigene In-Memory-Map führt. Für einen produktiv horizontal skalierten Order-Service wäre eine gemeinsame, externe Datenbank statt der In-Memory-Speicherung erforderlich."

