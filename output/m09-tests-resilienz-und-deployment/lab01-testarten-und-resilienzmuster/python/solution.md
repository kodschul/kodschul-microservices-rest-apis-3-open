# Lösung (Python-Spur): Testarten zuordnen und Resilienzmuster implementieren

## Aufgabe 1: Testarten

| Test/Prüfung | Testart |
| --- | --- |
| `test_orders.py` (`TestClient`, Modul 2) | Integrationstest |
| Abgleich generierter OpenAPI-Spezifikation gegen `order-api.yaml` (Modul 3) | Contract-Test |
| Checkpoint-Nachweis aus Modul 8 (gesamter Stack, echte Anfrage, echte Benachrichtigung) | End-to-End-Test |
| Test der Benachrichtigungstext-Erzeugung (`build_notification_text`, Modul 6) | Unit-Test |

## Aufgabe 2: Abhängigkeit

`requirements.txt` (ergänzt):

```text
tenacity==9.0.0
```

## Aufgabe 3: Retry implementieren

```python
from tenacity import retry, retry_if_exception_type, stop_after_attempt, wait_exponential
import pika.exceptions


@retry(
    retry=retry_if_exception_type(pika.exceptions.AMQPConnectionError),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=0.5, min=0.5, max=4),
)
def publish_order_created(order: Order) -> None:
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=RABBITMQ_HOST,
            credentials=pika.PlainCredentials("kodschul", "kodschul"),
        )
    )
    try:
        channel = connection.channel()
        channel.exchange_declare(exchange=EXCHANGE_NAME, exchange_type="topic", durable=True)
        event = OrderCreatedEvent(...)
        channel.basic_publish(
            exchange=EXCHANGE_NAME,
            routing_key=ROUTING_KEY,
            body=event.model_dump_json(by_alias=True),
            properties=pika.BasicProperties(content_type="application/json"),
        )
    finally:
        connection.close()
```

## Aufgabe 4: Verhalten beobachten

```bash
docker compose stop rabbitmq
curl -X POST http://localhost:8081/orders -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":1}'
```

Erwartetes Verhalten: drei Versuche mit steigender Wartezeit (ca. 0,5 s, 1 s, 2 s), danach wird die letzte `AMQPConnectionError` weitergereicht (der `POST`-Aufruf schlägt dann mit einem Serverfehler fehl - eine vollständige Fallback-Behandlung dafür wäre eine sinnvolle Erweiterung außerhalb des Kursumfangs).

```bash
docker compose start rabbitmq
# erneuter POST /orders funktioniert wieder normal
```

## Erweiterung: Timeout-Muster

```python
pika.ConnectionParameters(
    host=RABBITMQ_HOST,
    credentials=pika.PlainCredentials("kodschul", "kodschul"),
    blocked_connection_timeout=3,
    socket_timeout=3,
)
```

Explizite Timeouts verhindern, dass ein nicht erreichbarer Broker die Anwendung unbegrenzt blockiert.
