# Lösung M03: REST-Vertrag entwerfen und prüfen

## Szenario und Ziel

Die Lösung bindet den bestehenden Java-Endpunkt an einen konsistenten REST-Entwurf und prüft die drei im Referenzpfad nachgewiesenen Verhaltensklassen.

**Gesamtdauer:** 255 Minuten über Tag 1 und Tag 2
**Zielartefakt:** REST-Entwurf, validierter OpenAPI-Vertrag, Generierungsbeobachtung sowie positive, Grenz- und Fehlerchecks am Java-Endpunkt

## Voraussetzungen

- abgeschlossene Context Map aus M02
- bereitgestellter Java-Starterstand und Testgerüst
- vorbereitete OpenAPI-Ausgangsdatei und Validator
- API-Client
- vorbereitete Generator-Konfiguration für die Demo

## Aufgabe 1: Ressourcen und Operationen modellieren

| Absicht | Methode und URI | Begründung |
| --- | --- | --- |
| Bestellung anlegen | `POST /api/orders` | erzeugt eine neue Order-Ressource |
| Bestellung versenden | `POST /api/orders/{orderId}/dispatch` | stößt den vorhandenen fachlichen Übergang an |

Lesen, Ersetzen und Löschen bleiben außerhalb des aktuellen Vertrags, weil der geprüfte Referenzpfad dafür kein Verhalten implementiert.

**Checkpoint:** Beide vorhandenen Operationen sind mit Ressource, Methode, URI und Absicht dokumentiert.

## Aufgabe 2: Repräsentation und Formatgrenze festlegen

Bestellerstellung:

| Feld | Typ | Pflicht | Grenze |
| --- | --- | --- | --- |
| `sku` | String | ja | nicht leer |
| `quantity` | Integer | ja | 1 bis 100 |
| `recipient` | String | ja | nicht leer, E-Mail-Format |

Erfolgsantwort:

| Feld | Typ | Bedeutung |
| --- | --- | --- |
| `orderId` | String | erzeugte Bestell-ID |
| `status` | String | Bestellstatus |
| `notificationStatus` | String | Ergebnis des Benachrichtigungsauftrags |

JSON ist der Basispfad, weil die geprüften Java- und Python-Schnittstellen JSON austauschen. XML wäre darstellbar, erforderte aber einen separaten Medientyp, Schema- und Parserentscheidungen; dieser Pfad ist nicht implementiert.

**Checkpoint:** Pflichtfelder, Typen, Grenzen und Formatentscheidung sind festgehalten.

## Aufgabe 3: Erfolgs-, Grenz- und Fehlerfälle entwerfen

| Fall | Status | Antwort |
| --- | --- | --- |
| gültige Bestellung | `201` | `orderId`, `status: created`, `notificationStatus: accepted` |
| `quantity: 0` | `400` | `code: INVALID_ORDER`, verständliche Meldung |
| Notification Service nicht erreichbar | `502` | `code: DOWNSTREAM_UNAVAILABLE`, verständliche Meldung |

Die beiden Fehlercodes erlauben eine stabile maschinelle Unterscheidung unabhängig vom Meldungstext.

**Checkpoint:** Erfolg, Eingabegrenze und Downstream-Ausfall sind anhand von Status und Schema unterscheidbar.

## Aufgabe 4: OpenAPI-Vertrag ergänzen und validieren

Ein passender Kern der Bestelloperation lautet:

```yaml
paths:
  /api/orders:
    post:
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OrderRequest'
      responses:
        '201':
          description: Order created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderResponse'
        '400':
          description: Order data is invalid
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiError'
        '502':
          description: Notification service is unavailable
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiError'
```

Die Komponenten definieren die Felder und Grenzen aus Aufgabe 2 sowie `code` und `message` für `ApiError`. Nach Einfügen in die vollständige Ausgangsdatei muss der bereitgestellte Validator ohne Struktur- oder Referenzfehler enden.

**Checkpoint:** Alle drei Responses referenzieren vorhandene Schemas; der vollständige Vertrag ist validatorfehlerfrei.

## Aufgabe 5: Generierung beobachten und bewerten

| Beobachtung | Bewertung |
| --- | --- |
| Request- und Response-Typen entstehen aus Schemas | reduziert manuelle Transporttypen |
| Methoden entstehen aus Pfaden und Operationen | vereinheitlicht Client-Aufrufe |
| Fachlogik fehlt | Generierung ersetzt keine Domänenentscheidung |
| Ausgabe hängt von Generator und Optionen ab | Versionen müssen reproduzierbar festgelegt sein |

Generierte Dateien werden nicht manuell geändert. Anpassungen erfolgen am Vertrag, an Generatorvorlagen oder in getrennten handgeschriebenen Adaptern.

**Checkpoint:** Zwei Vorteile und zwei Grenzen sind konkret dokumentiert; generierte und handgeschriebene Dateien sind getrennt.

## Aufgabe 6: Java-Erfolgsfall an den Vertrag binden

Die Controller-Grenze liefert nach erfolgreicher Verarbeitung `201`:

```java
@PostMapping
public ResponseEntity<OrderResponse> create(@Valid @RequestBody OrderRequest request) {
    return ResponseEntity.status(HttpStatus.CREATED).body(orderService.create(request));
}
```

Die Anwendungslogik erzeugt die ID und übernimmt den Status des Notification-Aufrufs:

```java
public OrderResponse create(OrderRequest request) {
    String orderId = UUID.randomUUID().toString();
    String notificationStatus = notificationClient.notifyOrder(orderId, request.recipient());
    return new OrderResponse(orderId, "created", notificationStatus);
}
```

Reproduzierbarer Check:

```powershell
curl.exe --request POST http://localhost:8080/api/orders `
  --header "Content-Type: application/json" `
  --data '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}'
```

Erwartet werden HTTP `201`, eine nicht leere `orderId`, `status: created` und `notificationStatus: accepted`.

**Checkpoint:** Unit-Test und HTTP-Aufruf bestätigen Status und Antwortfelder.

## Aufgabe 7: Eingabegrenze prüfen

```powershell
curl.exe --request POST http://localhost:8080/api/orders `
  --header "Content-Type: application/json" `
  --data '{"sku":"SKU-100","quantity":0,"recipient":"dev@example.test"}'
```

Erwartet werden HTTP `400` und `code: INVALID_ORDER`. Die Bean Validation lehnt den Request vor erfolgreicher Bestellerstellung ab, weil `quantity` mindestens `1` sein muss.

**Checkpoint:** Der getestete Wert direkt unter der Untergrenze wird reproduzierbar abgelehnt.

## Aufgabe 8: Abhängigen Fehlerfall prüfen

Beenden Sie den vorbereiteten Notification Service kontrolliert, während der Java-Service weiterläuft, und wiederholen Sie den positiven Request aus Aufgabe 6.

Erwartet werden HTTP `502` und `code: DOWNSTREAM_UNAVAILABLE`. Der Java-Client fängt den Transportfehler ab und die zentrale Fehlerbehandlung bildet ihn auf den öffentlichen Vertrag ab. Starten Sie den Notification Service danach wieder und prüfen Sie erneut den Erfolgsfall.

**Checkpoint:** Ausfall und Wiederherstellung sind mit je einem HTTP-Ergebnis dokumentiert.

## Abschlusskriterien

- [x] Ressourcen, Methoden und Schemas sind fachlich begründet.
- [x] JSON ist praktisch festgelegt und XML vergleichend abgegrenzt.
- [x] Der OpenAPI-Vertrag ist syntaktisch gültig.
- [x] Generierungsnutzen und -grenzen sind dokumentiert.
- [x] Positiver, Grenz- und Fehlerfall sind automatisiert und über HTTP geprüft.

## Erweiterung

Wird beispielsweise die obere Mengengrenze verändert, müssen OpenAPI-Schema, Java-Validierung und positive sowie negative Tests gemeinsam angepasst werden. Ein generierter Client muss aus derselben Vertragsversion neu erzeugt werden. Die Änderung ist erst vollständig, wenn Validator und betroffene Checks erneut grün sind.

## Fallback

Die bereitgestellten Generatorausgaben zeigen Typen und Aufrufoberflächen; aufgezeichnete Ergebnisse zeigen die drei HTTP-Fälle. Ohne eigene Ausführung ist jedoch weder die lokale Vertragsvalidierung noch die Übereinstimmung des eigenen Java-Stands nachgewiesen.