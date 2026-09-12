package de.kodschul.orders;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.HttpURLConnection;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class OrderApiTest {
    private static final Pattern ORDER_ID = Pattern.compile("\\\"orderId\\\":\\\"([^\\\"]+)\\\"");

    @LocalServerPort
    private int port;

    @Test
    void createsValidOrder() throws Exception {
        ApiResponse response = post("""
                {"sku":"BOOK-42","quantity":2,"recipient":"dev@example.test"}
                """);

        Matcher orderId = ORDER_ID.matcher(response.body());
        assertThat(response.statusCode()).isEqualTo(201);
            assertThat(orderId.find()).isTrue();
            assertThat(UUID.fromString(orderId.group(1))).isNotNull();
            assertThat(response.body()).contains("\"status\":\"created\"");
            assertThat(response.body()).contains("\"notificationStatus\":\"pending\"");
    }

    @Test
    void rejectsQuantityBelowMinimum() throws Exception {
        assertInvalid("""
                {"sku":"BOOK-42","quantity":0,"recipient":"dev@example.test"}
                """);
    }

    @Test
    void rejectsInvalidEmail() throws Exception {
        assertInvalid("""
                {"sku":"BOOK-42","quantity":2,"recipient":"invalid"}
                """);
    }

    @Test
    void rejectsBlankSku() throws Exception {
        assertInvalid("""
                {"sku":" ","quantity":2,"recipient":"dev@example.test"}
                """);
    }

    private void assertInvalid(String requestBody) throws Exception {
        ApiResponse response = post(requestBody);

        assertThat(response.statusCode()).isEqualTo(400);
        assertThat(response.body()).contains("\"code\":\"INVALID_ORDER\"");
        assertThat(response.body()).contains("\"message\":\"Order data is invalid\"");
    }

        private ApiResponse post(String requestBody) throws Exception {
        HttpURLConnection connection = (HttpURLConnection) URI
            .create("http://localhost:" + port + "/api/orders")
            .toURL()
            .openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);
        connection.getOutputStream().write(requestBody.getBytes(StandardCharsets.UTF_8));

        int statusCode = connection.getResponseCode();
        String body = new String(
            statusCode >= 400
                ? connection.getErrorStream().readAllBytes()
                : connection.getInputStream().readAllBytes(),
            StandardCharsets.UTF_8);
        connection.disconnect();
        return new ApiResponse(statusCode, body);
        }

        private record ApiResponse(int statusCode, String body) {
    }
}