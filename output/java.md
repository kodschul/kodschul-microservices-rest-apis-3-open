# Java- und Spring-Boot-Referenz

Diese Kurzreferenz unterstützt die Arbeit am Order Service. Sie behandelt nur die Java- und Spring-Boot-Mittel, die im Kursprojekt verwendet werden.

## Projektorientierung

| Stelle | Aufgabe |
| --- | --- |
| `pom.xml` | Java-Version, Abhängigkeiten und Build-Plug-ins |
| `OrderServiceApplication` | Startpunkt der Anwendung |
| `OrderController` | öffentliche HTTP-Endpunkte |
| `OrderApplicationService` | fachlicher Ablauf |
| `NotificationClient` | synchroner HTTP-Aufruf zu FastAPI |
| `OrderEventPublisher` | asynchrones Ereignis an RabbitMQ |
| `ApiExceptionHandler` | zentrale HTTP-Fehlerabbildung |
| `application.yml` | externe Laufzeitkonfiguration |
| `src/test/java` | automatisierte Verhaltenserwartungen |

## Maven

Im Verzeichnis des jeweiligen `order-service`:

```powershell
mvn -B test
mvn -B -Dtest=OrderApplicationServiceTest test
mvn -B package
mvn spring-boot:run
```

`test` führt alle Tests aus, `-Dtest=...` nur eine Testklasse, `package` erzeugt das JAR unter `target/`, und `spring-boot:run` startet die Anwendung. `-B` sorgt für nicht interaktive Ausgaben. Ein erfolgreicher Build beweist noch nicht, dass externe Services erreichbar sind.

## Spring-Boot-Rollen

| Annotation | Rolle |
| --- | --- |
| `@SpringBootApplication` | startet Konfiguration und Komponentensuche |
| `@RestController` | verarbeitet HTTP-Requests und Responses |
| `@Service` | kapselt den Anwendungsablauf |
| `@Component` | bindet technische Adapter ein |
| `@Configuration` und `@Bean` | stellen explizite Spring-Konfiguration bereit |
| `@RestControllerAdvice` | behandelt Controller-Fehler zentral |

Abhängigkeiten werden über den Konstruktor übergeben:

```java
public OrderController(OrderApplicationService orderService) {
    this.orderService = orderService;
}
```

So sind notwendige Abhängigkeiten sichtbar und im Test ersetzbar. Bei genau einem Konstruktor ist kein `@Autowired` nötig.

## Records und Validierung

Records beschreiben unveränderliche API-Daten kompakt. Zugriff erfolgt beispielsweise über `response.orderId()`.

```java
public record OrderRequest(
        @NotBlank String sku,
        @Min(1) @Max(100) int quantity,
        @NotBlank @Email String recipient) {
}
```

`@Valid @RequestBody OrderRequest request` am Controller aktiviert die Jakarta-Validierung und deserialisiert JSON. Java-Regeln, OpenAPI-Vertrag und Tests müssen dieselben Grenzen beschreiben.

## REST-Endpunkte

```java
@RestController
@RequestMapping("/api/orders")
public class OrderController {
    @PostMapping
    public ResponseEntity<OrderResponse> create(
            @Valid @RequestBody OrderRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(orderService.create(request));
    }
}
```

`ResponseEntity` legt Status, Header und Body explizit fest. Im Projekt bedeuten:

- `201 Created`: Bestellung erzeugt.
- `202 Accepted`: Dispatch angenommen.
- `400 Bad Request`: Eingabe ungültig.
- `502 Bad Gateway`: Downstream-Service nicht nutzbar.

## Fehler zentral abbilden

```java
@ExceptionHandler(DownstreamServiceException.class)
public ResponseEntity<Map<String, String>> downstreamUnavailable(
        DownstreamServiceException exception) {
    return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
            .body(Map.of("code", "DOWNSTREAM_UNAVAILABLE",
                    "message", exception.getMessage()));
}
```

Der Handler hält den Controller beim Erfolgsablauf und erzeugt stabile öffentliche Fehlercodes. Interne Stacktraces oder Bibliotheksfehler gehören nicht in die API-Antwort.

## HTTP-Aufruf mit RestClient

```java
NotificationResponse response = restClient.post()
        .uri("/notifications")
        .body(new NotificationRequest(orderId, recipient, "email"))
        .retrieve()
        .body(NotificationResponse.class);
```

Request- und Response-Records bilden den JSON-Vertrag ab. Das Feld `order_id` trägt absichtlich den Namen aus dem Python-Vertrag.

Der Client begrenzt beide Wartephasen:

```java
HttpClient httpClient = HttpClient.newBuilder()
        .connectTimeout(connectTimeout).build();
JdkClientHttpRequestFactory requestFactory =
        new JdkClientHttpRequestFactory(httpClient);
requestFactory.setReadTimeout(readTimeout);
```

Der Connect Timeout begrenzt den Verbindungsaufbau, der Read Timeout das Warten auf die Antwort. Ein Timeout macht einen Retry nicht automatisch sicher; dafür müssen Fehlerart und Idempotenz geklärt sein.

## Umgebungskonfiguration

```yaml
notification:
  base-url: ${NOTIFICATION_BASE_URL:http://localhost:8000}
  connect-timeout: 500ms
  read-timeout: 1s
```

`@Value("${notification.base-url}")` injiziert den Wert. In `${NAME:standard}` steht vor dem Doppelpunkt die Umgebungsvariable und danach der lokale Standard. Sensible Werte erhalten keinen öffentlichen Standard und werden nicht eingecheckt.

## RabbitMQ und JSON

```java
@Bean
Queue orderEventsQueue() {
    return new Queue("order.events", true);
}
```

Der Publisher serialisiert das Ereignis mit Jackson 3 (`tools.jackson.databind.ObjectMapper`) explizit als JSON:

```java
String event = objectMapper.writeValueAsString(Map.of(
        "orderId", orderId,
        "type", "OrderDispatched",
        "occurredAt", Instant.now().toString()));
rabbitTemplate.convertAndSend("order.events", event);
```

Die explizite Serialisierung hält die Sprachgrenze zu Python sichtbar. Ein Publisher-Test parst den String erneut und prüft die vereinbarten Felder.

## JUnit 5, AssertJ und Mockito

```java
@Test
void createsAnOrder() {
    OrderResponse response = service.create(request);
    assertThat(response.orderId()).isNotBlank();
    assertThat(response.status()).isEqualTo("created");
}
```

Tests folgen Arrange, Act, Assert: Ausgangslage vorbereiten, Verhalten ausführen, beobachtbares Ergebnis prüfen. AssertJ liefert lesbare Assertions.

```java
NotificationClient client = mock(NotificationClient.class);
when(client.notifyOrder(anyString(), eq("dev@example.test")))
        .thenReturn("accepted");
verify(client).notifyOrder(anyString(), eq("dev@example.test"));
```

Mockito erzeugt mit `mock(...)` eine kontrollierte Abhängigkeit, `when(...).thenReturn(...)` legt ihr Verhalten fest und `verify(...)` prüft relevante Interaktionen. Nicht jede interne Methode braucht eine Verifikation.

## Actuator und Diagnose

Spring Boot Actuator stellt `/actuator/health` bereit. `management.endpoints.web.exposure.include: health,info` begrenzt die veröffentlichten Endpunkte. Ein grüner Healthcheck bestätigt den definierten technischen Zustand, ersetzt aber keinen fachlichen Smoke-Test.

Diagnosefolge:

Erste relevante Fehlermeldung lesen, Prozessstatus, Port und Health prüfen, Request samt Antwort sichern und die beteiligten Logs vergleichen. Danach eine konkrete Hypothese mit dem kleinsten passenden Test prüfen und denselben Fall nach der Änderung erneut ausführen.

| Symptom | Grenze | Erste Prüfung |
| --- | --- | --- |
| Compilerfehler | Code oder Abhängigkeit | erste Compilerzeile und Klasse |
| `400` | Request oder Validierung | JSON-Felder und Regeln |
| `502` | Downstream-Integration | Zieladresse, Health und Timeout |
| Dispatch schlägt fehl | Broker-Verbindung | RabbitMQ-Health, Queue und Publisher-Log |
| Event fehlt | Consumer-Verarbeitung | Queue, Consumer-Log und Ack/Nack |
