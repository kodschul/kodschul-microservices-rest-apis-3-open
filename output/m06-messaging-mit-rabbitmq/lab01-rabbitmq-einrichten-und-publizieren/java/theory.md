---
theme: default
---

# Lab 1 (Java-Spur): RabbitMQ einrichten und Ereignis publizieren

## Lernziel

Nach diesem Lab publiziert euer Order-Service bei jeder neuen Bestellung ein `order.created`-Ereignis nach `output/project/contracts/messaging-contract.md` an RabbitMQ.

## Leitfragen

1. Welche Bausteine bringt Spring AMQP für die Arbeit mit RabbitMQ mit?
2. Wie wird ein Exchange deklariert und eine Nachricht darauf veröffentlicht?

## RabbitMQ lokal starten

```bash
docker compose -f output/project/starter/rabbitmq-compose.yml up -d
```

Management-UI: `http://localhost:15672` (Login `kodschul`/`kodschul`).

## Spring AMQP: Exchange deklarieren

```java
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

`Jackson2JsonMessageConverter` sorgt dafür, dass `RabbitTemplate` Java-Objekte automatisch als JSON serialisiert - mit denselben Jackson-Regeln (also `camelCase`), die ihr bereits aus Modul 2/3 kennt.

## Ereignis publizieren

```java
@Component
public class OrderEventPublisher {

    private final RabbitTemplate rabbitTemplate;

    public OrderEventPublisher(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void publishOrderCreated(Order order) {
        OrderCreatedEvent event = new OrderCreatedEvent(order);
        rabbitTemplate.convertAndSend(
                RabbitMQConfig.ORDER_EVENTS_EXCHANGE,
                RabbitMQConfig.ORDER_CREATED_ROUTING_KEY,
                event);
    }
}
```

## Checkpoint

Ihr könnt RabbitMQ lokal starten, einen Exchange deklarieren und ein Ereignis publizieren, das in der Management-UI unter "Exchanges" sichtbar wird.
