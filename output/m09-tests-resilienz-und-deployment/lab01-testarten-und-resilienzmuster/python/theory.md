---
theme: default
---

# Lab 1 (Python-Spur): Testarten zuordnen und Resilienzmuster implementieren

## Lernziel

Nach diesem Lab könnt ihr Tests nach Testart einordnen und ein Retry-Muster für eine potenziell fehlschlagende Operation implementieren.

## Leitfragen

1. Was unterscheidet Unit-, Integrations- und Contract-Tests?
2. Wie funktioniert ein Retry-Muster mit Backoff, und wofür ist es geeignet?

## Testarten im Überblick

| Testart | Prüft | Beispiel aus dem Kurs |
| --- | --- | --- |
| Unit-Test | eine einzelne Funktion isoliert, ohne externe Abhängigkeiten | Test der Benachrichtigungstext-Erzeugung (`build_notification_text`, Modul 6) |
| Integrationstest | das Zusammenspiel mehrerer Komponenten innerhalb eines Services | `test_orders.py` mit `TestClient` (Modul 2) |
| Contract-Test | ob eine Implementierung einem vereinbarten Vertrag entspricht | Abgleich der generierten OpenAPI-Spezifikation mit `order-api.yaml` (Modul 3) |
| End-to-End-Test | den gesamten Ablauf über mehrere Services hinweg | Der manuelle Checkpoint-Nachweis aus Modul 8 |

## Retry-Muster mit Backoff

Ein **Retry-Muster** wiederholt eine fehlgeschlagene Operation automatisch, statt sofort aufzugeben - sinnvoll bei kurzzeitigen, vorübergehenden Fehlern (z. B. RabbitMQ ist gerade kurz nicht erreichbar). **Exponential Backoff** vergrößert die Wartezeit zwischen den Versuchen, um das fehlerhafte System nicht zusätzlich zu belasten.

```python
from tenacity import retry, retry_if_exception_type, stop_after_attempt, wait_exponential
import pika.exceptions

@retry(
    retry=retry_if_exception_type(pika.exceptions.AMQPConnectionError),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=0.5, min=0.5, max=4),
)
def publish_order_created(order: Order) -> None:
    ...
```

`tenacity` versucht die Funktion bei einem `AMQPConnectionError` bis zu dreimal, mit exponentiell steigender Wartezeit. Schlagen alle Versuche fehl, wird die letzte Exception weitergereicht.

## Wichtige Grenze

Retry allein löst nicht jedes Problem: Bei einem **dauerhaften** Fehler (z. B. falsche Zugangsdaten) verzögert Retry nur das unvermeidliche Scheitern. Retry passt zu **vorübergehenden** Fehlern, nicht zu strukturellen.

## Checkpoint

Ihr könnt Tests nach Testart einordnen und ein Retry-Muster mit Backoff für eine externe Operation implementieren.
