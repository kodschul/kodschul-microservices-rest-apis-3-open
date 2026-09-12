# Lösung (Java-Spur): Validierung, Fehlerbehandlung und Integrationstest

## `NewOrderRequest.java` (erweitert)

```java
package com.kodschul.orderservice;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

public class NewOrderRequest {

    @NotBlank
    private String customerName;

    @NotBlank
    private String itemName;

    @Min(1)
    private int quantity;

    public String getCustomerName() { return customerName; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }

    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
```

## `OrderNotFoundException.java`

```java
package com.kodschul.orderservice;

import java.util.UUID;

public class OrderNotFoundException extends RuntimeException {
    public OrderNotFoundException(UUID id) {
        super("Order not found: " + id);
    }
}
```

## `ApiExceptionHandler.java`

```java
package com.kodschul.orderservice;

import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(OrderNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public Map<String, String> handleNotFound(OrderNotFoundException ex) {
        return Map.of("error", ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, String> handleValidation(MethodArgumentNotValidException ex) {
        return Map.of("error", "Validation failed");
    }
}
```

## `OrderController.java` (angepasste Ausschnitte)

```java
@GetMapping("/{id}")
public Order getOrder(@PathVariable UUID id) {
    return repository.findById(id).orElseThrow(() -> new OrderNotFoundException(id));
}

@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Order createOrder(@Valid @RequestBody NewOrderRequest request) {
    Order order = new Order(UUID.randomUUID(), request.getCustomerName(), request.getItemName(),
            request.getQuantity(), OrderStatus.NEW, Instant.now());
    return repository.save(order);
}

@PutMapping("/{id}")
public Order updateOrder(@PathVariable UUID id, @Valid @RequestBody NewOrderRequest request) {
    Order existing = repository.findById(id).orElseThrow(() -> new OrderNotFoundException(id));
    existing.setCustomerName(request.getCustomerName());
    existing.setItemName(request.getItemName());
    existing.setQuantity(request.getQuantity());
    return repository.save(existing);
}

@DeleteMapping("/{id}")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void deleteOrder(@PathVariable UUID id) {
    repository.findById(id).orElseThrow(() -> new OrderNotFoundException(id));
    repository.deleteById(id);
}
```

## `OrderControllerTest.java`

```java
package com.kodschul.orderservice;

import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class OrderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void createOrder_withValidData_returns201() throws Exception {
        mockMvc.perform(post("/orders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id", notNullValue()))
                .andExpect(jsonPath("$.status").value("NEW"));
    }

    @Test
    void createOrder_withInvalidQuantity_returns400() throws Exception {
        mockMvc.perform(post("/orders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":0}
                                """))
                .andExpect(status().isBadRequest());
    }

    @Test
    void getOrder_withUnknownId_returns404() throws Exception {
        mockMvc.perform(get("/orders/00000000-0000-0000-0000-000000000000"))
                .andExpect(status().isNotFound());
    }
}
```
