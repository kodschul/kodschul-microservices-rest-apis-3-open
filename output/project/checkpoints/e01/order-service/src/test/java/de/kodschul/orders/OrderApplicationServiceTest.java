package de.kodschul.orders;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.UUID;

import org.junit.jupiter.api.Test;

class OrderApplicationServiceTest {
    private final OrderApplicationService orderService = new OrderApplicationService();

    @Test
    void createsAnOrder() {
        OrderRequest request = new OrderRequest("BOOK-42", 2, "dev@example.test");

        OrderResponse response = orderService.create(request);

        assertThat(UUID.fromString(response.orderId())).isNotNull();
        assertThat(response.status()).isEqualTo("created");
        assertThat(response.notificationStatus()).isEqualTo("pending");
    }
}