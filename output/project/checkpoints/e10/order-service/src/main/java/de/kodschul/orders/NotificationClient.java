package de.kodschul.orders;

import java.net.http.HttpClient;
import java.time.Duration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.JdkClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

@Component
public class NotificationClient {
    private final RestClient restClient;

    @Autowired
    public NotificationClient(
            @Value("${notification.base-url}") String baseUrl,
            @Value("${notification.connect-timeout}") Duration connectTimeout,
            @Value("${notification.read-timeout}") Duration readTimeout) {
        HttpClient httpClient = HttpClient.newBuilder().connectTimeout(connectTimeout).build();
        JdkClientHttpRequestFactory requestFactory = new JdkClientHttpRequestFactory(httpClient);
        requestFactory.setReadTimeout(readTimeout);
        this.restClient = RestClient.builder().baseUrl(baseUrl).requestFactory(requestFactory).build();
    }

    NotificationClient(RestClient restClient) {
        this.restClient = restClient;
    }

    public String notifyOrder(String orderId, String recipient) {
        try {
            NotificationResponse response = restClient.post()
                    .uri("/notifications")
                    .body(new NotificationRequest(orderId, recipient, "email"))
                    .retrieve()
                    .body(NotificationResponse.class);
            if (response == null || response.status() == null || response.status().isBlank()) {
                throw new DownstreamServiceException("Notification service returned an invalid response");
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