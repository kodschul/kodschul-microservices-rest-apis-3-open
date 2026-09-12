package de.kodschul.orders;

import java.util.UUID;

import org.springframework.stereotype.Service;

@Service
public class OrderApplicationService {
    private final NotificationClient notificationClient;
    private final OrderEventPublisher eventPublisher;

    public OrderApplicationService(NotificationClient notificationClient, OrderEventPublisher eventPublisher) {
        this.notificationClient = notificationClient;
        this.eventPublisher = eventPublisher;
    }

    public OrderResponse create(OrderRequest request) {
        String orderId = UUID.randomUUID().toString();
        String notificationStatus = notificationClient.notifyOrder(orderId, request.recipient());
        return new OrderResponse(orderId, "created", notificationStatus);
    }

    public void dispatch(String orderId) {
        eventPublisher.publishDispatched(orderId);
    }
}