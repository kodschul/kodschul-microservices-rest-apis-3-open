---
theme: default
---

# Lab 2 (Java-Spur): REST-Endpunkte implementieren

## Lernziel

Nach diesem Lab implementiert euer Order-Service alle fünf Operationen aus dem Vertrag (`order-api.yaml`) mit Spring MVC.

## Leitfragen

1. Wie bildet Spring MVC HTTP-Methoden und Pfade auf Java-Methoden ab?
2. Wie werden Request- und Response-Bodies automatisch in Java-Objekte umgewandelt?
3. Wie hält man einen einfachen Zustand ohne echte Datenbank (für diesen Kurs bewusst in-memory)?

## `@RestController` und Routing

```java
@RestController
@RequestMapping("/orders")
public class OrderController {

    @GetMapping
    public List<Order> listOrders() { ... }

    @GetMapping("/{id}")
    public Order getOrder(@PathVariable UUID id) { ... }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Order createOrder(@RequestBody NewOrderRequest request) { ... }
}
```

- `@RestController` kombiniert `@Controller` und `@ResponseBody`: Rückgabewerte werden automatisch als JSON serialisiert (über Jackson, das Spring Boot standardmäßig einbindet).
- `@RequestMapping("/orders")` auf Klassenebene setzt den gemeinsamen Basis-Pfad; `@GetMapping`, `@PostMapping` usw. ergänzen Methode und Unterpfad.
- `@PathVariable` bindet Platzhalter aus der URL, `@RequestBody` bindet den JSON-Body auf ein Java-Objekt.
- `@ResponseStatus(HttpStatus.CREATED)` erzeugt den in Modul 2/Lab 1 festgelegten `201`-Statuscode für `POST`.

## Zustand ohne Datenbank

Für dieses Kurs genügt eine **In-Memory-Speicherung** in einer thread-sicheren Map (`ConcurrentHashMap`). Das ist bewusst eine didaktische Vereinfachung: In einem echten System würde eine Datenbank (z. B. PostgreSQL mit Spring Data JPA) verwendet - das ist nicht Lernziel dieses Kurses.

```java
private final Map<UUID, Order> orders = new ConcurrentHashMap<>();
```

## Trennung von Request- und Response-Modell

Der Vertrag unterscheidet zwischen `NewOrder` (was der Client sendet) und `Order` (was der Server zurückgibt, inklusive `id`, `status`, `createdAt`). Diese Trennung verhindert, dass Clients serverseitig gesetzte Felder überschreiben können.

## Checkpoint

Ihr könnt eine Ressource mit Spring MVC über alle fünf HTTP-Methoden ansprechen und versteht, warum Request- und Response-Modell getrennt sind.
