# Lösung (Python-Spur): Client-Stub generieren

## Aufgabe 1: Client generieren

```bash
docker run --rm -v "$PWD:/local" openapitools/openapi-generator-cli generate \
  -i http://host.docker.internal:8081/openapi.json \
  -g typescript-fetch \
  -o /local/generated-client
```

Erwartete Ausgabe (gekürzt): Log-Zeilen mit `[main] INFO ... writing file ... generated-client/apis/OrdersApi.ts` und ähnlichen Pfaden.

*Unter nativem Docker Engine (z. B. Linux):* den Befehl aus der Theorie mit `--add-host=host.docker.internal:host-gateway` verwenden, sonst schlägt die Verbindung zum Host fehl.

Die generierte Funktion für `POST /orders` liegt sinngemäß in `generated-client/apis/OrdersApi.ts` und heißt (abhängig vom generierten `operationId`) etwa `createOrderOrdersPost(requestParameters)`. Ihre Parameterstruktur entspricht `NewOrderRequest` aus Modul 2 (Felder `customerName`, `itemName`, `quantity` - dank der in Modul 2/Lab 2 konfigurierten `camelCase`-Aliase entsprechen die generierten Feldnamen exakt dem Vertrag, nicht den internen Python-Attributnamen `customer_name`/`item_name`), da der Generator das Pydantic-Schema 1:1 in ein TypeScript-Interface übersetzt.

## Aufgabe 3: Lücke erkennen

Ohne die in Lab 1 ergänzten `summary`/`description`-Parameter enthält die generierte Funktion keinen aussagekräftigen Kommentar, nur den technischen `operationId`. Mit `summary=...` und `description=...` am `@router.post(...)`-Dekorator würde der Generator diese Texte als JSDoc-Kommentar über der Funktion übernehmen.

## Erweiterung: Review zu zweit

Typische Kandidaten für zusätzliche Angaben: `update_order` (fehlt oft eine Beschreibung, was bei einer nicht existierenden ID passiert) und `remove_order` (fehlt oft eine explizite `responses={404: ...}`-Angabe wie in Lab 1, Aufgabe 3).
