# Lösung (Python-Spur): Image bauen und einzeln starten

## Aufgabe 1: Host konfigurierbar machen

`app/events.py` (Order-Service, Ausschnitt):

```python
import os
import pika

RABBITMQ_HOST = os.environ.get("RABBITMQ_HOST", "localhost")


def publish_order_created(order: Order) -> None:
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=RABBITMQ_HOST,
            credentials=pika.PlainCredentials("kodschul", "kodschul"),
        )
    )
    ...
```

`app/consumer.py` (Notification-Service) wird analog angepasst.

## Aufgabe 2: Images bauen

```bash
docker build -t order-service:0.1.0 ./order-service
docker build -t notification-service:0.1.0 ./notification-service
docker images | grep -E "order-service|notification-service"
```

## Aufgabe 3: Order-Service starten

```bash
docker run --rm -p 8081:8081 \
  --add-host=host.docker.internal:host-gateway \
  -e RABBITMQ_HOST=host.docker.internal \
  order-service:0.1.0
```

```bash
curl http://localhost:8081/health
# {"status":"UP"}
```

## Aufgabe 4: Notification-Service starten

```bash
docker run --rm -p 8091:8091 \
  --add-host=host.docker.internal:host-gateway \
  -e RABBITMQ_HOST=host.docker.internal \
  notification-service:0.1.0
```

```bash
curl http://localhost:8091/health
# {"status":"UP"}
```

## Aufgabe 5: End-to-End im Container

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'
```

Die Container-Logs des Notification-Service (`docker logs <container-id>`) zeigen dieselbe Benachrichtigungszeile wie in Modul 6.
