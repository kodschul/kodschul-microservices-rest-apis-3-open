# Übung (Python-Spur): Swagger UI prüfen

**Dauer:** ca. 15 Minuten · **Typ:** Project Lab · **Verändert die Projektbasis:** Nein (nur Nutzung, kein neuer Code)

## Szenario

Ihr testet eure API interaktiv über die von FastAPI mitgelieferte Swagger UI, statt jede Anfrage manuell mit `curl` zu formulieren.

## Voraussetzungen

- Order-Service aus Lab 1 (mit verfeinerter OpenAPI-Spezifikation).

## Aufgaben

1. **Swagger UI öffnen.** Ruft `http://localhost:8081/docs` im Browser auf und macht euch mit der Oberfläche vertraut (Liste der Operationen, "Try it out").

2. **Bestellung über die Oberfläche anlegen.** Klappt `POST /orders` auf, klickt "Try it out", tragt Beispieldaten ein und führt die Anfrage aus. Notiert den zurückgegebenen Statuscode und die generierte `id`.

3. **Fehlerfall auslösen.** Führt `POST /orders` mit `quantity: 0` aus und prüft, ob Swagger UI den erwarteten `400`-Statuscode anzeigt (nicht den FastAPI-Standard `422`).

4. **Alternative Ansicht vergleichen.** Öffnet zusätzlich `http://localhost:8081/redoc` und beschreibt in 1-2 Sätzen einen Unterschied zur Swagger-UI-Ansicht.

## Checkpoint

Ihr habt über Swagger UI erfolgreich eine Bestellung angelegt und einen Fehlerfall (`400`) beobachtet, ohne eine Kommandozeile zu benutzen.

## Abschlusskriterium

Statuscode und Antwortkörper aus Aufgabe 2 und 3 sind notiert, und mindestens ein Unterschied zwischen `/docs` und `/redoc` ist benannt.
