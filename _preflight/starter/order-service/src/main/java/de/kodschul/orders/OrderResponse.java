package de.kodschul.orders;

public record OrderResponse(String orderId, String status, String notificationStatus) {
}