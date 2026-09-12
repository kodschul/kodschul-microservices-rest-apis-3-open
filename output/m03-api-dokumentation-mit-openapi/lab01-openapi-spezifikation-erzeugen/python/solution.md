# Lösung (Python-Spur): OpenAPI-Spezifikation erzeugen

## Spezifikation abrufen

```bash
curl http://localhost:8081/openapi.json | jq '.paths | keys'
```

Erwartete Ausgabe (sinngemäß):

```json
["/health", "/orders", "/orders/{order_id}"]
```

## Operation verfeinern

```python
@router.post(
    "",
    response_model=Order,
    status_code=201,
    summary="Neue Bestellung anlegen",
    description="Legt eine Bestellung mit Status NEW an und liefert sie inklusive generierter ID zurück.",
)
def create_order(request: NewOrderRequest) -> Order:
    ...
```

## Fehlerantwort dokumentieren

```python
@router.get(
    "/{order_id}",
    response_model=Order,
    responses={404: {"description": "Order not found"}},
)
def get_order_by_id(order_id: UUID) -> Order:
    ...
```

## Abgleich mit dem Vertrag

Bei korrekter Umsetzung aus Modul 2/Lab 3 stimmen die Statuscodes überein: `201` für `POST`, `400` für Validierungsfehler (dank des in Lab 3 registrierten Exception-Handlers), `404` für unbekannte IDs (nach Ergänzung von Aufgabe 3), `204` für `DELETE`. Ohne die `responses={...}`-Ergänzung würde die generierte Spezifikation nur den Erfolgsfall (`200`) und FastAPIs eingebauten `422`-Validierungsfall zeigen, obwohl der Code bereits `400` und `404` korrekt zurückgibt - ein typisches Beispiel dafür, dass generierte Dokumentation dem tatsächlichen Verhalten "hinterherlaufen" kann.

Die Feldnamen stimmen ebenfalls überein: Da `NewOrderRequest` und `Order` in Modul 2/Lab 2 mit `alias_generator=to_camel` konfiguriert wurden, zeigt die generierte Spezifikation `customerName`/`itemName` statt `customer_name`/`item_name` - identisch zum Vertrag. Ohne diese Alias-Konfiguration wäre dies die auffälligste Abweichung gewesen.

Der Lernwert liegt darin, zu erkennen, dass automatisch generierte Dokumentation die tatsächlichen Fehlerantworten nicht von selbst kennt - sie muss explizit ergänzt werden, sonst weicht die Spezifikation vom echten Serviceverhalten ab.
