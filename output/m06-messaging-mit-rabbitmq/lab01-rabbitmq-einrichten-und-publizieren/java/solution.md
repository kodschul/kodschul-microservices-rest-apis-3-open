# Lösung (Java-Spur): RabbitMQ einrichten und Ereignis publizieren

## `pom.xml` (ergänzter Ausschnitt)

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
```

## `application.yml` (ergänzter Ausschnitt)

```yaml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: kodschul
    password: kodschul
```

## `RabbitMQConfig.java`

```java
package com.kodschul.orderservice;

import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    public static final String ORDER_EVENTS_EXCHANGE = "order.events";
    public static final String ORDER_CREATED_ROUTING_KEY = "order.created";

    @Bean
    public TopicExchange orderEventsExchange() {
        return new TopicExchange(ORDER_EVENTS_EXCHANGE);
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
```

## `OrderEventPayload.java` und `OrderCreatedEvent.java`

```java
package com.kodschul.orderservice;

public class OrderEventPayload {
    private final String orderId;
    private final String customerName;
    private final String itemName;
    private final int quantity;
    private final String status;

    public OrderEventPayload(Order order) {
        this.orderId = order.getId().toString();
        this.customerName = order.getCustomerName();
        this.itemName = order.getItemName();
        this.quantity = order.getQuantity();
        this.status = order.getStatus().name();
    }

    public String getOrderId() { return orderId; }
    public String getCustomerName() { return customerName; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }
    public String getStatus() { return status; }
}
```

```java
package com.kodschul.orderservice;

import java.time.Instant;
import java.util.UUID;

public class OrderCreatedEvent {
    private final String eventId;
    private final String eventType = "order.created";
    private final Instant occurredAt;
    private final OrderEventPayload order;

    public OrderCreatedEvent(Order order) {
        this.eventId = UUID.randomUUID().toString();
        this.occurredAt = Instant.now();
        this.order = new OrderEventPayload(order);
    }

    public String getEventId() { return eventId; }
    public String getEventType() { return eventType; }
    public Instant getOccurredAt() { return occurredAt; }
    public OrderEventPayload getOrder() { return order; }
}
```

## `OrderEventPublisher.java`

```java
package com.kodschul.orderservice;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

@Component
public class OrderEventPublisher {

    private final RabbitTemplate rabbitTemplate;

    public OrderEventPublisher(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void publishOrderCreated(Order order) {
        rabbitTemplate.convertAndSend(
                RabbitMQConfig.ORDER_EVENTS_EXCHANGE,
                RabbitMQConfig.ORDER_CREATED_ROUTING_KEY,
                new OrderCreatedEvent(order));
    }
}
```

## `OrderController.java` (angepasster Ausschnitt)

```java
private final OrderEventPublisher eventPublisher;

public OrderController(OrderRepository repository, OrderEventPublisher eventPublisher) {
    this.repository = repository;
    this.eventPublisher = eventPublisher;
}

@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Order createOrder(@Valid @RequestBody NewOrderRequest request) {
    Order order = new Order(UUID.randomUUID(), request.getCustomerName(), request.getItemName(),
            request.getQuantity(), OrderStatus.NEW, Instant.now());
    Order saved = repository.save(order);
    eventPublisher.publishOrderCreated(saved);
    return saved;
}
```

## Manuelles Verifizieren

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'
```

In der Management-UI (`http://localhost:15672` → Exchanges → `order.events`) steigt die "Publish"-Rate sichtbar an.
