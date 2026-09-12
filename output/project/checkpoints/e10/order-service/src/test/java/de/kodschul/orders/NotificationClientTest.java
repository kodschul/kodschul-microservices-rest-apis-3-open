package de.kodschul.orders;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.ExpectedCount.once;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

class NotificationClientTest {
    @Test
    void acceptsValidNotificationResponse() {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        NotificationClient client = new NotificationClient(builder.baseUrl("http://notification.test").build());
        server.expect(once(), requestTo("http://notification.test/notifications"))
                .andRespond(withSuccess("""
                        {"order_id":"order-100","status":"accepted","channel":"email"}
                        """, MediaType.APPLICATION_JSON));

        assertThat(client.notifyOrder("order-100", "dev@example.test")).isEqualTo("accepted");
        server.verify();
    }

    @Test
    void rejectsEmptyNotificationStatus() {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
                NotificationClient client = new NotificationClient(builder.baseUrl("http://notification.test").build());
        server.expect(once(), requestTo("http://notification.test/notifications"))
                .andRespond(withSuccess("""
                        {"order_id":"order-100","status":"","channel":"email"}
                        """, MediaType.APPLICATION_JSON));

        assertThatThrownBy(() -> client.notifyOrder("order-100", "dev@example.test"))
                .isInstanceOf(DownstreamServiceException.class)
                .hasMessage("Notification service returned an invalid response");
        server.verify();
    }
}