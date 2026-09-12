# Lösung (Java-Spur): Testarten zuordnen und Resilienzmuster implementieren

## Aufgabe 1: Testarten

| Test/Prüfung | Testart |
| --- | --- |
| `OrderControllerTest` (`MockMvc`, Modul 2) | Integrationstest |
| Abgleich generierter OpenAPI-Spezifikation gegen `order-api.yaml` (Modul 3) | Contract-Test |
| Checkpoint-Nachweis aus Modul 8 (gesamter Stack, echte Anfrage, echte Benachrichtigung) | End-to-End-Test |
| Test der Benachrichtigungstext-Erzeugung (isolierte Funktion, keine externen Abhängigkeiten) | Unit-Test |

## Aufgabe 2: Abhängigkeiten

```xml
<dependency>
  <groupId>org.springframework.retry</groupId>
  <artifactId>spring-retry</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

```java
@EnableRetry
@SpringBootApplication
public class OrderServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(OrderServiceApplication.class, args);
    }
}
```

## Aufgabe 3: Retry implementieren

```java
@Component
public class OrderEventPublisher {

    private final RabbitTemplate rabbitTemplate;

    public OrderEventPublisher(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

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
}
```

## Aufgabe 4: Verhalten beobachten

```bash
docker compose stop rabbitmq
curl -X POST http://localhost:8081/orders -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":1}'
```

Erwartete Log-Zeilen (sinngemäß): drei Versuche im Abstand von ca. 500 ms, 1000 ms, 2000 ms, danach eine `AmqpException`, die an den Aufrufer weitergereicht wird (der `POST`-Aufruf schlägt dann mit einem Serverfehler fehl - eine vollständige Fallback-Behandlung dafür wäre eine sinnvolle Erweiterung außerhalb des Kursumfangs).

```bash
docker compose start rabbitmq
# erneuter POST /orders funktioniert wieder normal
```

## Erweiterung: Timeout-Muster

```yaml
spring:
  rabbitmq:
    connection-timeout: 3000
```

Ein expliziter Verbindungs-Timeout verhindert, dass ein nicht erreichbarer Broker die Anwendung unbegrenzt blockiert.
