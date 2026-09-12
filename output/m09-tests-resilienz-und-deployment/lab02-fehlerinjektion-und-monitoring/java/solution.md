# Lösung (Java-Spur): Fehlerinjektionstest und Monitoring-Konzept

## `OrderEventPublisherTest.java`

```java
package com.kodschul.orderservice;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.amqp.AmqpException;
import org.springframework.amqp.rabbit.core.RabbitTemplate;

class OrderEventPublisherTest {

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

    @Test
    void publishOrderCreated_succeedsWithoutRetryWhenNoException() {
        RabbitTemplate rabbitTemplate = mock(RabbitTemplate.class);
        OrderEventPublisher publisher = new OrderEventPublisher(rabbitTemplate);
        Order order = new Order(UUID.randomUUID(), "Mara Beispiel", "Kaffeemaschine", 1,
                OrderStatus.NEW, Instant.now());

        publisher.publishOrderCreated(order);

        verify(rabbitTemplate, times(1)).convertAndSend(anyString(), anyString(), any(Object.class));
    }
}
```

## Monitoring-/Logging-Konzept (`output/project/monitoring-logging-concept.md`, Auszug)

```markdown
# Monitoring- und Logging-Konzept: Bestell-Plattform

## Health-Signale
- Order-Service: `/actuator/health` (Java) bzw. `/health` (Python)
- Notification-Service: `/actuator/health` (Java) bzw. `/health` (Python)
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
