package de.kodschul.orders;

import org.junit.jupiter.api.Test;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

@SpringBootTest
class OrderServiceApplicationTest {
    @MockitoBean
    private ConnectionFactory connectionFactory;

    @Test
    void contextLoads() {
    }
}