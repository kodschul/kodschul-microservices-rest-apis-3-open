---
theme: default
---

# Lab 3 (Java-Spur): Validierung, Fehlerbehandlung und Integrationstest

## Lernziel

Nach diesem Lab validiert euer Order-Service Eingaben serverseitig, liefert konsistente Fehlerantworten und ist durch einen automatisierten Integrationstest abgesichert.

## Leitfragen

1. Wie erzwingt man Validierungsregeln (z. B. `quantity >= 1`) serverseitig statt nur im Vertrag zu beschreiben?
2. Wie liefert man für alle Fehlerfälle konsistente, vorhersehbare Antworten?
3. Wie testet man einen REST-Endpunkt automatisiert, ohne den Server manuell zu starten?

## Bean Validation

```java
public class NewOrderRequest {

    @NotBlank
    private String customerName;

    @NotBlank
    private String itemName;

    @Min(1)
    private int quantity;
    // Getter/Setter wie in Lab 2
}
```

Damit Spring diese Annotationen auswertet, muss der Controller-Parameter mit `@Valid` markiert werden:

```java
@PostMapping
public Order createOrder(@Valid @RequestBody NewOrderRequest request) { ... }
```

Ohne `@Valid` werden die Annotationen ignoriert - ein häufiger Anfängerfehler.

## Zentrale Fehlerbehandlung mit `@RestControllerAdvice`

Statt in jeder Methode einzeln `try/catch` zu schreiben, bündelt ein globaler Advice die Fehlerbehandlung:

```java
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

`MethodArgumentNotValidException` wird von Spring automatisch geworfen, wenn `@Valid` fehlschlägt - ihr müsst sie nicht selbst auslösen.

## Integrationstests mit `@SpringBootTest` und `MockMvc`

`MockMvc` simuliert HTTP-Anfragen gegen den Controller, ohne einen echten Netzwerk-Port zu öffnen. Das macht Tests schnell und unabhängig von Portkonflikten.

```java
@SpringBootTest
@AutoConfigureMockMvc
class OrderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void createOrder_returns201() throws Exception { ... }
}
```

## Checkpoint

Ihr könnt eine Validierungsregel serverseitig erzwingen, eine zentrale Fehlerbehandlung einrichten und einen Endpunkt mit `MockMvc` automatisiert testen.
