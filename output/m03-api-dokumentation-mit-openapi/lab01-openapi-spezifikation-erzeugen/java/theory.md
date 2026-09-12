---
theme: default
---

# Lab 1 (Java-Spur): OpenAPI-Spezifikation erzeugen

## Lernziel

Nach diesem Lab erzeugt euer Order-Service automatisch eine OpenAPI-Spezifikation aus dem vorhandenen Code und ihr könnt sie mit dem Vertrag aus Modul 2 abgleichen.

## Leitfragen

1. Wie erzeugt man eine OpenAPI-Beschreibung aus vorhandenem Spring-MVC-Code, ohne sie von Hand zu pflegen?
2. Was tut man, wenn generierte Spezifikation und ursprünglicher Vertrag voneinander abweichen?

## springdoc-openapi

`springdoc-openapi` liest zur Laufzeit eure `@RestController`-Klassen, Methoden-Annotationen und DTOs und erzeugt daraus automatisch eine OpenAPI-3-Beschreibung - ohne dass ihr die Struktur erneut von Hand schreiben müsst.

Abhängigkeit in `pom.xml`:

```xml
<dependency>
  <groupId>org.springdoc</groupId>
  <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
  <version>2.6.0</version>
</dependency>
```

Nach einem Neustart ist die generierte Spezifikation unter `http://localhost:8081/v3/api-docs` als JSON abrufbar.

## Generierte Spezifikation verfeinern

Ohne Zusatzangaben liefert springdoc nur technisch korrekte, aber wenig aussagekräftige Beschreibungen (z. B. Methodenname als `summary`). Mit `@Operation` und `@Schema` lässt sich das verbessern:

```java
@Operation(summary = "Neue Bestellung anlegen", description = "Legt eine Bestellung mit Status NEW an.")
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Order createOrder(@Valid @RequestBody NewOrderRequest request) { ... }
```

## Vertrag vs. generierte Spezifikation

Der in Modul 2 handgeschriebene Vertrag (`order-api.yaml`) und die jetzt generierte Spezifikation sollten dieselben Pfade, Methoden und Statuscodes beschreiben. Abweichungen sind ein Signal, dass entweder der Code oder der ursprüngliche Vertrag nachgezogen werden muss - genau das ist der Sinn des Abgleichs.

## Checkpoint

Ihr könnt die generierte OpenAPI-Spezifikation abrufen und mit dem Vertrag aus Modul 2 vergleichen.
