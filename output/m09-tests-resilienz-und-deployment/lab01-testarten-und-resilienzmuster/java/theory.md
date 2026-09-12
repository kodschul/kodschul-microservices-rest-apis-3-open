---
theme: default
---

# Lab 1 (Java-Spur): Testarten zuordnen und Resilienzmuster implementieren

## Lernziel

Nach diesem Lab könnt ihr Tests nach Testart einordnen und ein Retry-Muster für eine potenziell fehlschlagende Operation implementieren.

## Leitfragen

1. Was unterscheidet Unit-, Integrations- und Contract-Tests?
2. Wie funktioniert ein Retry-Muster mit Backoff, und wofür ist es geeignet?

## Testarten im Überblick

| Testart | Prüft | Beispiel aus dem Kurs |
| --- | --- | --- |
| Unit-Test | eine einzelne Funktion/Methode isoliert, ohne externe Abhängigkeiten | Test der Benachrichtigungstext-Erzeugung |
| Integrationstest | das Zusammenspiel mehrerer Komponenten innerhalb eines Services | `OrderControllerTest` mit `MockMvc` (Modul 2) |
| Contract-Test | ob eine Implementierung einem vereinbarten Vertrag entspricht | Abgleich der generierten OpenAPI-Spezifikation mit `order-api.yaml` (Modul 3) |
| End-to-End-Test | den gesamten Ablauf über mehrere Services hinweg | Der manuelle Checkpoint-Nachweis aus Modul 8 |

## Retry-Muster mit Backoff

Ein **Retry-Muster** wiederholt eine fehlgeschlagene Operation automatisch, statt sofort aufzugeben - sinnvoll bei kurzzeitigen, vorübergehenden Fehlern (z. B. RabbitMQ ist gerade kurz nicht erreichbar). **Exponential Backoff** vergrößert die Wartezeit zwischen den Versuchen, um das fehlerhafte System nicht zusätzlich zu belasten.

```java
@Retryable(
    retryFor = AmqpException.class,
    maxAttempts = 3,
    backoff = @Backoff(delay = 500, multiplier = 2))
public void publishOrderCreated(Order order) {
    rabbitTemplate.convertAndSend(
            RabbitMQConfig.ORDER_EVENTS_EXCHANGE,
            RabbitMQConfig.ORDER_CREATED_ROUTING_KEY,
            new OrderCreatedEvent(order));
}
```

`@Retryable` (aus `spring-retry`) versucht die Methode bei einer `AmqpException` bis zu dreimal, mit 500 ms, 1000 ms und 2000 ms Wartezeit dazwischen. Schlagen alle Versuche fehl, wird die Exception weitergereicht.

## Wichtige Grenze

Retry allein löst nicht jedes Problem: Bei einem **dauerhaften** Fehler (z. B. falsche Zugangsdaten) verzögert Retry nur das unvermeidliche Scheitern. Retry passt zu **vorübergehenden** Fehlern, nicht zu strukturellen.

## Checkpoint

Ihr könnt Tests nach Testart einordnen und ein Retry-Muster mit Backoff für eine externe Operation implementieren.
