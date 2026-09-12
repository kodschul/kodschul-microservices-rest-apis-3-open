package de.kodschul.orders;

import java.util.UUID;

import org.springframework.stereotype.Service;

@Service
public class OrderApplicationService {
    public OrderResponse create(OrderRequest request) {
        return new OrderResponse(UUID.randomUUID().toString(), "created", "pending");
    }
}