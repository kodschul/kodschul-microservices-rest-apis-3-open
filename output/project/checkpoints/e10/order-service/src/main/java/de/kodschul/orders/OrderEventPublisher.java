package de.kodschul.orders;

import java.time.Instant;
import java.util.Map;

import org.springframework.amqp.AmqpException;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;
import tools.jackson.core.JacksonException;
import tools.jackson.databind.ObjectMapper;

@Component
public class OrderEventPublisher {
    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper;

    public OrderEventPublisher(RabbitTemplate rabbitTemplate, ObjectMapper objectMapper) {
        this.rabbitTemplate = rabbitTemplate;
        this.objectMapper = objectMapper;
    }

    public void publishDispatched(String orderId) {
        try {
            String event = objectMapper.writeValueAsString(Map.of(
                    "orderId", orderId,
                    "type", "OrderDispatched",
                    "occurredAt", Instant.now().toString()));
            rabbitTemplate.convertAndSend("order.events", event);
        } catch (AmqpException | JacksonException exception) {
            throw new DownstreamServiceException("RabbitMQ is unavailable", exception);
        }
    }
}