# Übung (Java-Spur): Deployment-Strategien, DevOps und Abschlussdemonstration

**Dauer:** ca. 55 Minuten · **Typ:** Capstone · **Verändert die Projektbasis:** Ja

## Szenario

Ihr trefft eine begründete Deployment-Entscheidung, ordnet CI/CD/DevOps für die Bestell-Plattform ein und demonstriert das Gesamtsystem als Abschluss des Kurses.

## Voraussetzungen

- Alle vorherigen Module abgeschlossen; Stack aus Modul 8 startet fehlerfrei; Resilienzmuster aus Lab 1/2 vorhanden.

## Aufgaben

1. **Deployment-Strategie wählen.** Wählt für die Bestell-Plattform in einem angenommenen Cloud-Produktivbetrieb (nicht das lokale Compose-Setup) eine Deployment-Strategie aus der Theorie und begründet in 3-5 Sätzen, warum sie zum Risikoprofil der Plattform passt.

2. **CI/CD-Pipeline skizzieren.** Skizziert (als Liste oder einfaches Diagramm) die Schritte einer CI/CD-Pipeline für den Order-Service: Von "Code committen" bis "Deployment", unter Einbeziehung eurer vorhandenen Tests (`OrderControllerTest`, `OrderEventPublisherTest`) und des Docker-Images aus Modul 7.

3. **Gesamtsystem demonstrieren.** Startet den vollständigen Stack (`docker compose up --build`) und führt eine vollständige End-to-End-Demonstration durch: Bestellung anlegen, REST-API über Swagger UI zeigen, Ereignis in RabbitMQ nachweisen, Benachrichtigung im Notification-Service-Log zeigen.

4. **Abschlussdokument erstellen.** Fasst Aufgaben 1-3 sowie die wichtigsten Erkenntnisse aus dem gesamten Kurs (in Stichpunkten, bezogen auf die sechs Lernziele aus `01-concept.md`) in `output/project/capstone-summary.md` zusammen.

## Checkpoint

`output/project/capstone-summary.md` enthält eine begründete Deployment-Entscheidung, eine skizzierte CI/CD-Pipeline und eine Zusammenfassung der Kurs-Lernziele; die End-to-End-Demonstration aus Aufgabe 3 war erfolgreich.

## Abschlusskriterium

Alle sechs Lernziele aus dem Kurskonzept sind im Abschlussdokument mit einem konkreten Bezug zum eigenen Projektstand versehen (nicht nur abstrakt wiederholt).
