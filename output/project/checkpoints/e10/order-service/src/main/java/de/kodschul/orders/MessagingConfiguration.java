package de.kodschul.orders;

import org.springframework.amqp.core.Queue;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MessagingConfiguration {
    @Bean
    Queue orderEventsQueue() {
        return new Queue("order.events", true);
    }
}