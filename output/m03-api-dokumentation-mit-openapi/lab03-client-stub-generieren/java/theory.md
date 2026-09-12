---
theme: default
---

# Lab 3 (Java-Spur): Client-Stub generieren

## Lernziel

Nach diesem Lab könnt ihr aus einer laufenden OpenAPI-Spezifikation automatisiert einen Client generieren, statt ihn von Hand zu schreiben.

## Leitfragen

1. Welchen Vorteil bietet ein generierter Client gegenüber einem handgeschriebenen HTTP-Client?
2. Wie hängt die Qualität des generierten Clients von der Qualität der Spezifikation aus Lab 1 ab?

## OpenAPI Generator

Der [OpenAPI Generator](https://openapi-generator.tech/) liest eine OpenAPI-Spezifikation (JSON oder YAML) und erzeugt daraus Client-Code für viele Zielsprachen. Er lässt sich ohne lokale Installation über Docker ausführen:

```bash
docker run --rm -v "$PWD:/local" openapitools/openapi-generator-cli generate \
  -i http://host.docker.internal:8081/v3/api-docs \
  -g typescript-fetch \
  -o /local/generated-client
```

- `-i` ist die Quelle (hier: die laufende Spezifikation eures Order-Service),
- `-g typescript-fetch` ist der Zielgenerator (ein TypeScript-Client auf Basis der `fetch`-API - eine typische Wahl für ein Frontend-Team, das euren Service konsumiert),
- `-o` ist das Ausgabeverzeichnis.

`host.docker.internal` löst den Host-Rechner aus dem Container heraus auf und funktioniert so auf Docker Desktop (Windows/Mac). Unter nativem Docker Engine (häufig unter Linux) muss der Zuordnung explizit ergänzt werden:

```bash
docker run --rm --add-host=host.docker.internal:host-gateway \
  -v "$PWD:/local" openapitools/openapi-generator-cli generate \
  -i http://host.docker.internal:8081/v3/api-docs \
  -g typescript-fetch \
  -o /local/generated-client
```

Alternativ kann unter Linux `--network=host` verwendet und die Quelle direkt als `http://localhost:8081/v3/api-docs` angegeben werden.

## Warum generieren statt von Hand schreiben?

Ein handgeschriebener HTTP-Client muss bei jeder API-Änderung manuell nachgepflegt werden und ist fehleranfällig (Tippfehler in Pfaden, vergessene Felder). Ein generierter Client entsteht direkt aus der Spezifikation und bleibt automatisch synchron, solange die Spezifikation aktuell gehalten wird - das ist einer der zentralen Vorteile des Contract-first-Ansatzes aus Modul 2.

## Grenzen

Die Qualität des generierten Clients hängt direkt von der Qualität der Spezifikation ab: fehlen `@Operation`-Beschreibungen oder `@ApiResponse`-Angaben (siehe Lab 1), fehlen diese auch im generierten Client - der Generator kann nur wiedergeben, was in der Spezifikation steht.

## Checkpoint

Ihr könnt einen Client aus einer laufenden OpenAPI-Spezifikation generieren und eine generierte Methode einer manuell geschriebenen `curl`-Anfrage zuordnen.
