package de.kodschul.orders;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;

class OrderApplicationServiceTest {
    private final NotificationClient notificationClient = mock(NotificationClient.class);
    private final OrderEventPublisher eventPublisher = mock(OrderEventPublisher.class);
    private final OrderApplicationService service = new OrderApplicationService(notificationClient, eventPublisher);

    @Test
    void createCallsNotificationService() {
        when(notificationClient.notifyOrder(org.mockito.ArgumentMatchers.anyString(),
                org.mockito.ArgumentMatchers.eq("dev@example.test"))).thenReturn("accepted");

        OrderResponse response = service.create(new OrderRequest("SKU-100", 2, "dev@example.test"));

        assertThat(response.status()).isEqualTo("created");
        assertThat(response.notificationStatus()).isEqualTo("accepted");
        assertThat(response.orderId()).isNotBlank();
    }

    @Test
    void dispatchPublishesEvent() {
        service.dispatch("order-100");

        verify(eventPublisher).publishDispatched("order-100");
    }
}