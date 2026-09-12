package com.kodschul.notificationservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Starterprojekt für den Notification-Service (Java-Spur).
 * Enthält bewusst noch keinen RabbitMQ-Consumer; dieser entsteht in Modul 6.
 */
@SpringBootApplication
public class NotificationServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(NotificationServiceApplication.class, args);
    }
}
