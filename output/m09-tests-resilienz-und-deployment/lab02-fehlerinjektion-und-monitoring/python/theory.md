---
theme: default
---

# Lab 2 (Python-Spur): Fehlerinjektionstest und Monitoring-Konzept

## Lernziel

Nach diesem Lab habt ihr automatisiert nachgewiesen, dass euer Retry-Muster tatsächlich mehrfach versucht, und ein Monitoring-/Logging-Konzept für die Plattform skizziert.

## Leitfragen

1. Wie testet man Retry-Verhalten automatisiert, ohne RabbitMQ tatsächlich abzuschalten?
2. Welche Informationen sollte ein Monitoring-/Logging-Konzept mindestens festhalten?

## Fehlerinjektion mit `unittest.mock`

Statt RabbitMQ manuell zu stoppen (Lab 1, Aufgabe 4), simuliert ihr den Fehler in einem automatisierten Test, indem ihr `pika.BlockingConnection` durch ein Mock ersetzt, das bei jedem Aufruf eine Exception wirft:

```python
from unittest.mock import patch

import pika.exceptions
import pytest

from app.events import publish_order_created


@patch("app.events.pika.BlockingConnection")
def test_publish_order_created_retries_three_times_on_connection_error(mock_connection):
    mock_connection.side_effect = pika.exceptions.AMQPConnectionError("simulierter Ausfall")

    with pytest.raises(pika.exceptions.AMQPConnectionError):
        publish_order_created(sample_order())

    assert mock_connection.call_count == 3
```

Der Test bestätigt **automatisiert und reproduzierbar**, dass genau drei Versuche unternommen wurden - ohne echte Netzwerkverbindung oder manuelles Stoppen von Containern.

## Monitoring- und Logging-Konzept: Mindestinhalt

| Aspekt | Frage, die das Konzept beantwortet |
| --- | --- |
| Health-Signale | Welche Endpunkte/Mechanismen zeigen, dass ein Service grundsätzlich läuft? |
| Fachliche Metriken | Welche Kennzahlen sagen etwas über den Geschäftsbetrieb aus (z. B. Anzahl angelegter Bestellungen pro Minute)? |
| Fehler-Sichtbarkeit | Wie werden Fehler (z. B. erschöpfte Retries) sichtbar gemacht, statt nur in Logs zu verschwinden? |
| Log-Korrelation | Wie lässt sich eine Bestellung über Order- und Notification-Service hinweg in den Logs verfolgen (z. B. gemeinsame Korrelations-ID)? |

## Checkpoint

Ihr könnt Retry-Verhalten automatisiert testen und ein Monitoring-/Logging-Konzept mit den vier Mindestaspekten skizzieren.
