# Lösung (Java-Spur): OpenAPI-Spezifikation erzeugen

## `pom.xml` (ergänzter Ausschnitt)

```xml
<dependency>
  <groupId>org.springdoc</groupId>
  <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
  <version>2.6.0</version>
</dependency>
```

## Spezifikation abrufen

```bash
curl http://localhost:8081/v3/api-docs | jq '.paths | keys'
```

Erwartete Ausgabe (sinngemäß):

```json
["/orders", "/orders/{id}"]
```

Beide Pfade zusammen decken alle fünf Operationen (GET-Liste, GET-Einzel, POST, PUT, DELETE) ab.

## Operation verfeinern

```java
@Operation(summary = "Neue Bestellung anlegen",
           description = "Legt eine Bestellung mit Status NEW an und liefert sie inklusive generierter ID zurück.")
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Order createOrder(@Valid @RequestBody NewOrderRequest request) { ... }
```

Nach dem Neustart erscheint der Text unter `paths./orders.post.summary` bzw. `.description` in `/v3/api-docs`.

## Abgleich mit dem Vertrag

Bei korrekter Umsetzung von Modul 2/Lab 3 stimmen Statuscodes überein: `201` für `POST`, `400` für Validierungsfehler, `404` für unbekannte IDs, `204` für `DELETE`. Eine typische, plausible Abweichung an dieser Stelle: springdoc listet `400` unter `POST /orders` möglicherweise nicht automatisch auf, da es nur tatsächlich mit `@ApiResponse` dokumentierte Fehlerfälle anzeigt - der Code verhält sich zur Laufzeit korrekt, die *Dokumentation* muss aber explizit ergänzt werden (`@ApiResponse(responseCode = "400", description = "Ungültige Eingabe")`).
