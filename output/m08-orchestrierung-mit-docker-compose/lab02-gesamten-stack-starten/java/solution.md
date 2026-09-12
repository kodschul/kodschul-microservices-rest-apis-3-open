# Lösung (Java-Spur): Gesamten Stack starten

## Aufgabe 1+2: Starten und Zustand prüfen

```bash
docker compose up --build
```

Erwartete Reihenfolge in der Ausgabe: `rabbitmq` startet zuerst und durchläuft den Healthcheck, danach starten `order-service` und `notification-service` nahezu gleichzeitig.

```bash
docker compose ps
```

```text
NAME                   STATUS
rabbitmq               Up (healthy)
order-service          Up (healthy)
notification-service   Up
```

## Aufgabe 3: End-to-End über den Stack

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'

docker compose logs notification-service
```

Die Logs enthalten dieselbe Benachrichtigungszeile wie in Modul 6/7.

## Aufgabe 4: Neustart-Verhalten

```bash
docker compose down
docker compose up --build
curl http://localhost:8081/orders
# []
```

Nach dem Neustart ist die Bestellliste leer, weil die In-Memory-Speicherung (Modul 2) an den Lebenszyklus des jeweiligen Container-Prozesses gebunden ist. Ein Neustart des Containers erzeugt eine komplett neue, leere Map - dieselbe Einschränkung, die bereits in Modul 4 bei mehreren parallelen Instanzen sichtbar wurde.
