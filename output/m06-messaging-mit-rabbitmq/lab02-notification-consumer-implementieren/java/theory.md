---
theme: default
---

# Lab 2 (Java-Spur): Notification-Service als Consumer

## Lernziel

Nach diesem Lab konsumiert euer Notification-Service `order.created`-Ereignisse aus RabbitMQ und protokolliert eine Benachrichtigung.

## Leitfragen

1. Wie bindet man eine Queue an einen bestehenden Exchange?
2. Wie empfängt und verarbeitet Spring AMQP Nachrichten automatisch?

## Queue und Binding deklarieren

```java
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

Der Notification-Service deklariert Exchange **und** Queue erneut (idempotent). Das ist beabsichtigt: Beide Services sollen unabhängig voneinander startbar sein, ohne sich auf die Startreihenfolge zu verlassen.

## Nachrichten empfangen mit `@RabbitListener`

```java
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

Spring AMQP dedupliziert Nachrichten **nicht** automatisch (siehe `messaging-contract.md`, "mindestens einmal"-Zustellung). Dieses Lab protokolliert nur; eine echte Deduplizierung wäre eine Erweiterung außerhalb des Kursumfangs.

## Checkpoint

Ihr könnt eine Queue an einen bestehenden Exchange binden und eingehende Ereignisse mit `@RabbitListener` verarbeiten.
