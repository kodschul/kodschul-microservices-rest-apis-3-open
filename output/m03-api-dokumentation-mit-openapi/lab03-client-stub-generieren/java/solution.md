# Lösung (Java-Spur): Client-Stub generieren

## Aufgabe 1: Client generieren

```bash
docker run --rm -v "$PWD:/local" openapitools/openapi-generator-cli generate \
  -i http://host.docker.internal:8081/v3/api-docs \
  -g typescript-fetch \
  -o /local/generated-client
```

Erwartete Ausgabe (gekürzt): Log-Zeilen mit `[main] INFO ... writing file ... generated-client/apis/OrdersApi.ts` und ähnlichen Pfaden.

*Unter nativem Docker Engine (z. B. Linux):* den Befehl aus der Theorie mit `--add-host=host.docker.internal:host-gateway` verwenden, sonst schlägt die Verbindung zum Host fehl.

Die generierte Methode für `POST /orders` liegt sinngemäß in `generated-client/apis/OrdersApi.ts` und heißt (abhängig vom generierten `operationId`) etwa `createOrder(requestParameters: CreateOrderRequest)`. Ihre Parameterstruktur entspricht `NewOrderRequest` aus Modul 2 (Felder `customerName`, `itemName`, `quantity`), da der Generator das Schema `NewOrder` aus der Spezifikation 1:1 in ein TypeScript-Interface übersetzt.

## Aufgabe 3: Lücke erkennen

Ohne die in Lab 1 ergänzte `@Operation`-Annotation enthält die generierte Methode keinen aussagekräftigen Kommentar, nur den technischen `operationId`. Mit `@Operation(summary = "...", description = "...")` in `OrderController` würde der Generator diese Texte als JSDoc-Kommentar über der Methode übernehmen.

## Erweiterung: Review zu zweit

Typische Kandidaten für zusätzliche Annotationen: `updateOrder` (fehlt oft eine Beschreibung, was bei einer nicht existierenden ID passiert) und `deleteOrder` (fehlt oft eine explizite `@ApiResponse(responseCode = "404", ...)`-Angabe).
