# Lösung (Python-Spur): Checkpoint verifizieren

## Beispiel `CHECKPOINT.md`

```markdown
## Checkpoint: Bestell-Plattform über Docker Compose (Python-Spur)

### Status (`docker compose ps`)

NAME                   STATUS
rabbitmq               Up (healthy)
order-service          Up (healthy)
notification-service   Up

### Erreichbarkeit

- `curl http://localhost:8081/health` → `{"status":"UP"}`
- `curl http://localhost:8091/health` → `{"status":"UP"}`

### Funktionaler Nachweis

Request:

    curl -X POST http://localhost:8081/orders \
      -H "Content-Type: application/json" \
      -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'

Response: `201 Created`, `id: 7c2e1a4b-...`, `status: "NEW"`

Notification-Log (`docker compose logs notification-service`):

    notification-service | Benachrichtigung: Bestellung 7c2e1a4b-... für Mara Beispiel (2x Kaffeemaschine) ist eingegangen.
```

Entscheidend ist, dass alle vier Nachweise (Status, zwei Health-Checks, funktionaler Nachweis mit zitierter Log-Zeile) tatsächlich vorhanden und in sich stimmig sind (z. B. dieselbe `id` in Response und Log) - die genaue Formatierung ist frei wählbar.
