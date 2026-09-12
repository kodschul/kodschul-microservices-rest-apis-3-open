# Übung: Load Balancing beobachten

**Dauer:** ca. 40 Minuten · **Typ:** Diagnosis (Sandbox) · **Verändert die Projektbasis:** Nein

## Szenario

Ihr startet zwei Instanzen eures Order-Service und beobachtet, wie ein einfacher Load Balancer die Last verteilt - und was dabei mit dem Datenzustand passiert.

## Voraussetzungen

- Order-Service aus Modul 2 (Java oder Python, je nach eurer Spur).
- Docker lokal verfügbar.

## Aufgaben

1. **Zweite Instanz starten.** Startet eine zweite Instanz eures Order-Service auf Port 8082 (Befehl siehe Theorie), während die erste auf 8081 weiterläuft.

2. **Load Balancer starten.** Startet nginx mit `output/project/starter/nginx/loadbalancer.conf` wie in der Theorie beschrieben.

3. **Verteilung beobachten.** Sendet mindestens 6 aufeinanderfolgende `GET`-Anfragen an `http://localhost:8080/orders` (oder `/health` bzw. `/actuator/health`) und protokolliert, welche Instanz (Port 8081 oder 8082) jeweils geantwortet hat. Nutzt dazu z. B. ein Logging-Statement oder die Portnummer aus den jeweiligen Konsolenausgaben.

4. **Zustandsproblem provozieren.** Legt über den Load Balancer (`http://localhost:8080`) eine Bestellung an, ruft danach wiederholt `GET /orders` über den Load Balancer auf und beobachtet, ob die Bestellung bei jeder Anfrage sichtbar ist oder nur bei manchen.

5. **Beobachtung dokumentieren.** Haltet in 3-5 Sätzen fest, was ihr beobachtet habt und warum (Bezug zur In-Memory-Speicherung aus Modul 2).

## Checkpoint

Ihr habt dokumentiert, dass Anfragen abwechselnd von beiden Instanzen beantwortet werden und dass eine angelegte Bestellung nur bei der Instanz sichtbar ist, die sie entgegengenommen hat.

## Abschlusskriterium

Die Beobachtung aus Aufgabe 5 benennt explizit die In-Memory-Speicherung als Ursache des inkonsistenten Verhaltens.
