package com.kodschul.orderservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Starterprojekt für den Order-Service (Java-Spur).
 * Enthält bewusst noch keine Order-Endpunkte; diese entstehen in Modul 2.
 */
@SpringBootApplication
public class OrderServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(OrderServiceApplication.class, args);
    }
}
