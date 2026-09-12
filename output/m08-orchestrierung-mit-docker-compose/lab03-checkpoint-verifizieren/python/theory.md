---
theme: default
---

# Lab 3 (Python-Spur): Checkpoint verifizieren

## Lernziel

Nach diesem Lab habt ihr einen reproduzierbaren Nachweis, dass die gesamte Bestell-Plattform über Docker Compose startet und funktioniert.

## Leitfragen

1. Welche Nachweise zeigen zuverlässig, dass ein Stack tatsächlich funktioniert, statt nur "zu laufen scheint"?
2. Wie dokumentiert man einen Checkpoint so, dass ihn jemand anderes nachvollziehen kann?

## Was ein guter Checkpoint zeigt

Ein sichtbarer, reproduzierbarer Checkpoint besteht aus mehr als "der Container läuft". Er zeigt:

1. **Status:** Alle Services sind `running`/`healthy` (`docker compose ps`).
2. **Erreichbarkeit:** Jeder Service antwortet über seinen Health-Endpunkt.
3. **Funktionaler Nachweis:** Eine tatsächliche fachliche Aktion (Bestellung anlegen) erzeugt eine nachvollziehbare Wirkung (Benachrichtigung protokolliert).
4. **Logs als Beleg:** Die relevante Logzeile ist zitiert, nicht nur behauptet.

## Checkpoint-Protokoll: erwarteter Aufbau

```markdown
## Checkpoint: Bestell-Plattform über Docker Compose (Python-Spur)

- `docker compose ps`: rabbitmq (healthy), order-service (healthy), notification-service (running)
- `curl http://localhost:8081/health` → {"status":"UP"}
- `curl http://localhost:8091/health` → {"status":"UP"}
- Testbestellung angelegt: POST /orders mit {...} → 201, id=...
- Notification-Log: "Benachrichtigung: Bestellung ... ist eingegangen."
```

## Checkpoint

Ihr könnt ein Checkpoint-Protokoll erstellen, das Status, Erreichbarkeit und einen funktionalen Nachweis der gesamten Plattform belegt.
