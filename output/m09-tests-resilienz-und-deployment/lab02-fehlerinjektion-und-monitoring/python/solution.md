# Lösung (Python-Spur): Fehlerinjektionstest und Monitoring-Konzept

## `tests/test_events.py`

```python
from unittest.mock import MagicMock, patch

import pika.exceptions
import pytest

from app.events import publish_order_created
from app.models import Order, OrderStatus
from datetime import datetime, timezone
from uuid import uuid4


def sample_order() -> Order:
    return Order(
        id=uuid4(),
        customer_name="Mara Beispiel",
        item_name="Kaffeemaschine",
        quantity=1,
        status=OrderStatus.NEW,
        created_at=datetime.now(timezone.utc),
    )


@patch("app.events.pika.BlockingConnection")
def test_publish_order_created_retries_three_times_on_connection_error(mock_connection):
    mock_connection.side_effect = pika.exceptions.AMQPConnectionError("simulierter Ausfall")

    with pytest.raises(pika.exceptions.AMQPConnectionError):
        publish_order_created(sample_order())

    assert mock_connection.call_count == 3


@patch("app.events.pika.BlockingConnection")
def test_publish_order_created_succeeds_without_retry(mock_connection):
    mock_connection.return_value = MagicMock()

    publish_order_created(sample_order())

    assert mock_connection.call_count == 1
```

## Monitoring-/Logging-Konzept (`output/project/monitoring-logging-concept.md`, Auszug)

```markdown
# Monitoring- und Logging-Konzept: Bestell-Plattform

## Health-Signale
- Order-Service: `/health` (Python) bzw. `/actuator/health` (Java)
- Notification-Service: `/health` (Python) bzw. `/actuator/health` (Java)
- RabbitMQ: `rabbitmq-diagnostics ping` (bereits als Compose-Healthcheck aktiv)

## Fachliche Metriken
- Anzahl angelegter Bestellungen pro Minute (Order-Service)
- Anzahl verarbeiteter Benachrichtigungen pro Minute (Notification-Service)
- Anzahl fehlgeschlagener Ereignisveröffentlichungen (Retry-Erschöpfung)

## Fehler-Sichtbarkeit
- Erschöpfte Retries werden als ERROR-Log mit Bestell-ID protokolliert
- Ein einfaches Dashboard oder Alert bei wiederholten Fehlern innerhalb kurzer Zeit wäre die nächste sinnvolle Ausbaustufe (außerhalb des Kursumfangs)

## Log-Korrelation
- Die Bestell-ID (`orderId`) wird sowohl im Order-Service-Log (bei Anlage) als auch im Notification-Service-Log (bei Empfang) mitgeführt
- Damit lässt sich eine einzelne Bestellung über beide Services hinweg in den Logs nachvollziehen, ohne einen zentralen Tracing-Dienst zu benötigen
```

## Korrelations-ID (Vorschlag)

Die Bestell-ID (`orderId`) wird bereits über das Ereignis vom Order-Service zum Notification-Service transportiert und in beiden Log-Zeilen ausgegeben (siehe Modul 6). Für ein vollständiges Tracing über REST-Aufrufe hinweg würde man zusätzlich einen HTTP-Header wie `X-Correlation-Id` einführen, den jeder Service in seine Logs übernimmt - das ist eine sinnvolle Erweiterung außerhalb des Kursumfangs.
