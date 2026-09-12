package de.kodschul.orders;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

class OrderEventPublisherTest {
    @Test
    void publishesJsonThatThePythonConsumerCanParse() {
        RabbitTemplate rabbitTemplate = mock(RabbitTemplate.class);
        ObjectMapper objectMapper = new ObjectMapper();
        OrderEventPublisher publisher = new OrderEventPublisher(rabbitTemplate, objectMapper);

        publisher.publishDispatched("order-100");

        ArgumentCaptor<String> body = ArgumentCaptor.forClass(String.class);
        verify(rabbitTemplate).convertAndSend(eq("order.events"), body.capture());
        JsonNode event = objectMapper.readTree(body.getValue());
        assertThat(event.get("orderId").asString()).isEqualTo("order-100");
        assertThat(event.get("type").asString()).isEqualTo("OrderDispatched");
        assertThat(event.get("occurredAt").asString()).isNotBlank();
    }
}