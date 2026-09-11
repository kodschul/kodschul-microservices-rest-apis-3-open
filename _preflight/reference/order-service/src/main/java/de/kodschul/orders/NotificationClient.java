package de.kodschul.orders;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

@Component
public class NotificationClient {
    private final RestClient restClient;

    public NotificationClient(@Value("${notification.base-url}") String baseUrl) {
        this.restClient = RestClient.builder().baseUrl(baseUrl).build();
    }

    public String notifyOrder(String orderId, String recipient) {
        try {
            NotificationResponse response = restClient.post()
                    .uri("/notifications")
                    .body(new NotificationRequest(orderId, recipient, "email"))
                    .retrieve()
                    .body(NotificationResponse.class);
            if (response == null) {
                throw new DownstreamServiceException("Notification service returned no body");
            }
            return response.status();
        } catch (RestClientException exception) {
            throw new DownstreamServiceException("Notification service is unavailable", exception);
        }
    }

    private record NotificationRequest(String order_id, String recipient, String channel) {
    }

    private record NotificationResponse(String order_id, String status, String channel) {
    }
}