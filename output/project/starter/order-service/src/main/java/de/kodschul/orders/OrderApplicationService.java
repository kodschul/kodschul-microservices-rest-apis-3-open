package de.kodschul.orders;

import org.springframework.stereotype.Service;

@Service
public class OrderApplicationService {
    public OrderResponse create(OrderRequest request) {
        throw new ExerciseIncompleteException("Implement order creation and the notification call");
    }

    public void dispatch(String orderId) {
        throw new ExerciseIncompleteException("Implement publishing of OrderDispatched");
    }
}