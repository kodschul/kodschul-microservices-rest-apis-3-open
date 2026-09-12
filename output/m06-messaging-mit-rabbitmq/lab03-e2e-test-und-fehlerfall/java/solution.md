# Lösung (Java-Spur): End-to-End-Ereignisfluss testen und Fehlerfall betrachten

## Aufgabe 1: End-to-End-Bestätigung

Siehe Modul 6, Lab 2, Aufgabe 5. Erwartete Log-Zeile im Notification-Service:

```text
Benachrichtigung: Bestellung a3f1... für Mara Beispiel (2x Kaffeemaschine) ist eingegangen.
```

## Aufgabe 2: `OrderCreatedListenerTest.java`

```java
package com.kodschul.notificationservice;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

import org.junit.jupiter.api.Test;

class OrderCreatedListenerTest {

    @Test
    void handleOrderCreated_processesEventWithoutException() {
        OrderCreatedListener listener = new OrderCreatedListener();
        OrderEventPayload payload = new OrderEventPayload(
                "a3f1...", "Mara Beispiel", "Kaffeemaschine", 2, "NEW");
        OrderCreatedEvent event = new OrderCreatedEvent(payload);

        assertDoesNotThrow(() -> listener.handleOrderCreated(event));
    }
}
```

*Hinweis:* `OrderEventPayload` benötigt für diesen Test einen zusätzlichen Konstruktor, der die Felder direkt entgegennimmt (statt nur aus einem `Order`-Objekt), z. B. `OrderEventPayload(String orderId, String customerName, String itemName, int quantity, String status)`.

## Aufgabe 3: Fehlerfall provozieren

```java
@RabbitListener(queues = RabbitMQConfig.QUEUE_NAME)
public void handleOrderCreated(OrderCreatedEvent event) {
    if (event.getOrder().getQuantity() > 1) {
        throw new RuntimeException("Testweise ausgelöster Verarbeitungsfehler");
    }
    log.info("Benachrichtigung: Bestellung {} für {} ({}x {}) ist eingegangen.",
            event.getOrder().getOrderId(), event.getOrder().getCustomerName(),
            event.getOrder().getQuantity(), event.getOrder().getItemName());
}
```

Nach `POST /orders` mit `quantity: 2` zeigt die RabbitMQ-Management-UI (Queue `notification.order-created`) eine wachsende Anzahl unbestätigter/erneut zugestellter Nachrichten, da Spring AMQP ohne Fehlerbehandlung kein `ack` sendet und RabbitMQ die Nachricht wiederholt zustellt.

## Aufgabe 4: Zurücksetzen

Die testweise eingefügte `if`-Bedingung wird entfernt; der End-to-End-Fluss aus Aufgabe 1 funktioniert wieder wie zuvor.

## Erweiterung: Retry-Strategie

```java
@Bean
public SimpleRabbitListenerContainerFactory rabbitListenerContainerFactory(
        ConnectionFactory connectionFactory, MessageConverter converter) {
    SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
    factory.setConnectionFactory(connectionFactory);
    factory.setMessageConverter(converter);
    factory.setRetryTemplate(new RetryTemplateBuilder()
            .maxAttempts(3)
            .fixedBackoff(1000)
            .build());
    return factory;
}
```

Nach drei erfolglosen Versuchen markiert Spring AMQP die Nachricht als endgültig fehlgeschlagen; ohne konfigurierte Dead-Letter-Queue wird sie verworfen. Für produktiven Einsatz wäre eine Dead-Letter-Queue zur manuellen Nachbearbeitung Pflicht - das ist bewusst außerhalb des Kursumfangs.
