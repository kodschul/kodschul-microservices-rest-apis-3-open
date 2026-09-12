---
theme: default
---

# Lab 2 (Java-Spur): Swagger UI prüfen

## Lernziel

Nach diesem Lab könnt ihr Swagger UI nutzen, um eure API interaktiv zu erkunden und zu testen, ohne `curl` oder einen separaten HTTP-Client zu benötigen.

## Leitfragen

1. Woher kommt Swagger UI, und wie hängt sie mit der OpenAPI-Spezifikation aus Lab 1 zusammen?
2. Wofür eignet sich Swagger UI im Alltag, wofür eher nicht?

## Swagger UI und OpenAPI

Swagger UI ist eine Weboberfläche, die eine OpenAPI-Spezifikation liest und daraus automatisch eine interaktive Dokumentation rendert - mit Formularen für jede Operation, direkt im Browser ausführbar. `springdoc-openapi-starter-webmvc-ui` (aus Lab 1) bringt Swagger UI bereits mit; keine weitere Abhängigkeit nötig.

Erreichbar unter:

```text
http://localhost:8081/swagger-ui.html
```

## Wofür Swagger UI gut ist

- schneller manueller Test einzelner Endpunkte während der Entwicklung,
- Onboarding neuer Teammitglieder oder Kolleg:innen aus anderen Teams,
- lebendige Dokumentation, die nie veraltet, weil sie aus dem laufenden Code stammt.

## Wofür Swagger UI nicht geeignet ist

- automatisierte, wiederholbare Tests (dafür: Integrationstests wie in Modul 2/Lab 3),
- Lasttests oder Testszenarien mit vielen Abhängigkeiten zwischen Aufrufen,
- Dokumentation für Endanwender:innen ohne technischen Hintergrund.

## Checkpoint

Ihr könnt in Swagger UI eine Operation ausklappen, Beispieldaten eingeben, ausführen und die tatsächliche Antwort (Statuscode, Body) ablesen.
