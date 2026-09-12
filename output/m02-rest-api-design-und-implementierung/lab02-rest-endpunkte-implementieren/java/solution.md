# Lösung (Java-Spur): REST-Endpunkte implementieren

## `Order.java`

```java
package com.kodschul.orderservice;

import java.time.Instant;
import java.util.UUID;

public class Order {
    private UUID id;
    private String customerName;
    private String itemName;
    private int quantity;
    private OrderStatus status;
    private Instant createdAt;

    public Order(UUID id, String customerName, String itemName, int quantity,
                 OrderStatus status, Instant createdAt) {
        this.id = id;
        this.customerName = customerName;
        this.itemName = itemName;
        this.quantity = quantity;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getter (von Jackson für die JSON-Serialisierung benötigt)
    public UUID getId() { return id; }
    public String getCustomerName() { return customerName; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }
    public OrderStatus getStatus() { return status; }
    public Instant getCreatedAt() { return createdAt; }

    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
```

## `OrderStatus.java`

```java
package com.kodschul.orderservice;

public enum OrderStatus {
    NEW, CONFIRMED, CANCELLED
}
```

## `NewOrderRequest.java`

```java
package com.kodschul.orderservice;

public class NewOrderRequest {
    private String customerName;
    private String itemName;
    private int quantity;

    public String getCustomerName() { return customerName; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }

    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
```

## `OrderRepository.java`

```java
package com.kodschul.orderservice;

import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Repository;

@Repository
public class OrderRepository {

    private final Map<UUID, Order> orders = new ConcurrentHashMap<>();

    public Order save(Order order) {
        orders.put(order.getId(), order);
        return order;
    }

    public Collection<Order> findAll() {
        return orders.values();
    }

    public Optional<Order> findById(UUID id) {
        return Optional.ofNullable(orders.get(id));
    }

    public void deleteById(UUID id) {
        orders.remove(id);
    }
}
```

## `OrderController.java`

```java
package com.kodschul.orderservice;

import java.time.Instant;
import java.util.Collection;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
public class OrderController {

    private final OrderRepository repository;

    public OrderController(OrderRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public Collection<Order> listOrders() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrder(@PathVariable UUID id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Order createOrder(@RequestBody NewOrderRequest request) {
        Order order = new Order(
                UUID.randomUUID(),
                request.getCustomerName(),
                request.getItemName(),
                request.getQuantity(),
                OrderStatus.NEW,
                Instant.now());
        return repository.save(order);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Order> updateOrder(@PathVariable UUID id,
                                              @RequestBody NewOrderRequest request) {
        return repository.findById(id)
                .map(existing -> {
                    existing.setCustomerName(request.getCustomerName());
                    existing.setItemName(request.getItemName());
                    existing.setQuantity(request.getQuantity());
                    return ResponseEntity.ok(repository.save(existing));
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOrder(@PathVariable UUID id) {
        if (repository.findById(id).isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
```

## Manuelles Testen

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'
# -> 201, liefert u. a. die generierte "id"

curl http://localhost:8081/orders
curl http://localhost:8081/orders/<id-aus-der-antwort>

curl -X PUT http://localhost:8081/orders/<id> \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":3}'

curl -X DELETE http://localhost:8081/orders/<id> -i
# -> 204, kein Body

curl http://localhost:8081/orders/00000000-0000-0000-0000-000000000000 -i
# -> 404
```

## Erweiterung: Filter nach Status

```java
@GetMapping
public Collection<Order> listOrders(@RequestParam(required = false) OrderStatus status) {
    if (status == null) {
        return repository.findAll();
    }
    return repository.findAll().stream()
            .filter(order -> order.getStatus() == status)
            .toList();
}
```
