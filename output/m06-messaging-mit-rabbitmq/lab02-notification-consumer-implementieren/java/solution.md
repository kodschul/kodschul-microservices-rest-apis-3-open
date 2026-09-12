# Lösung (Java-Spur): Notification-Service als Consumer

## `OrderEventPayload.java` / `OrderCreatedEvent.java`

Identisch zur Lösung aus Modul 6, Lab 1 (Order-Service), im Package `com.kodschul.notificationservice` angelegt. Da beide Services unabhängige Codebasen sind, wird die Struktur bewusst dupliziert - das ist der Preis eines nicht gemeinsam genutzten Sprachmoduls und wird über die Schemadatei (`order-created-event.schema.json`) als gemeinsame Quelle der Wahrheit synchron gehalten.

## `RabbitMQConfig.java`

```java
package com.kodschul.notificationservice;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    public static final String QUEUE_NAME = "notification.order-created";
    public static final String EXCHANGE_NAME = "order.events";
    public static final String ROUTING_KEY = "order.created";

    @Bean
    public Queue notificationQueue() {
        return new Queue(QUEUE_NAME, true);
    }

    @Bean
    public TopicExchange orderEventsExchange() {
        return new TopicExchange(EXCHANGE_NAME);
    }

    @Bean
    public Binding binding(Queue notificationQueue, TopicExchange orderEventsExchange) {
        return BindingBuilder.bind(notificationQueue).to(orderEventsExchange).with(ROUTING_KEY);
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
```

## `OrderCreatedListener.java`

```java
package com.kodschul.notificationservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class OrderCreatedListener {

    private static final Logger log = LoggerFactory.getLogger(OrderCreatedListener.class);

    @RabbitListener(queues = RabbitMQConfig.QUEUE_NAME)
    public void handleOrderCreated(OrderCreatedEvent event) {
        log.info("Benachrichtigung: Bestellung {} für {} ({}x {}) ist eingegangen.",
                event.getOrder().getOrderId(), event.getOrder().getCustomerName(),
                event.getOrder().getQuantity(), event.getOrder().getItemName());
    }
}
```

## End-to-End-Test

1. Order-Service starten (Port 8081), Notification-Service starten (Port 8091), beide mit laufender RabbitMQ-Instanz.
2. `curl -X POST http://localhost:8081/orders -H "Content-Type: application/json" -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'`
3. In der Konsole des Notification-Service erscheint sinngemäß:

```text
Benachrichtigung: Bestellung a3f1... für Mara Beispiel (2x Kaffeemaschine) ist eingegangen.
```
