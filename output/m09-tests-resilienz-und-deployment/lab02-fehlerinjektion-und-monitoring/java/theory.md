---
theme: default
---

# Lab 2 (Java-Spur): Fehlerinjektionstest und Monitoring-Konzept

## Lernziel

Nach diesem Lab habt ihr automatisiert nachgewiesen, dass euer Retry-Muster tatsächlich mehrfach versucht, und ein Monitoring-/Logging-Konzept für die Plattform skizziert.

## Leitfragen

1. Wie testet man Retry-Verhalten automatisiert, ohne RabbitMQ tatsächlich abzuschalten?
2. Welche Informationen sollte ein Monitoring-/Logging-Konzept mindestens festhalten?

## Fehlerinjektion mit Mockito

Statt RabbitMQ manuell zu stoppen (Lab 1, Aufgabe 4), simuliert ihr den Fehler in einem automatisierten Test, indem ihr `RabbitTemplate` durch ein Mock ersetzt, das bei jedem Aufruf eine Exception wirft:

```java
@Test
void publishOrderCreated_retriesThreeTimesOnAmqpException() {
    RabbitTemplate rabbitTemplate = mock(RabbitTemplate.class);
    doThrow(new AmqpException("simulierter Ausfall"))
            .when(rabbitTemplate).convertAndSend(anyString(), anyString(), any(Object.class));

    OrderEventPublisher publisher = new OrderEventPublisher(rabbitTemplate);
    Order order = new Order(UUID.randomUUID(), "Mara Beispiel", "Kaffeemaschine", 1,
            OrderStatus.NEW, Instant.now());

    assertThrows(AmqpException.class, () -> publisher.publishOrderCreated(order));
    verify(rabbitTemplate, times(3)).convertAndSend(anyString(), anyString(), any(Object.class));
}
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
