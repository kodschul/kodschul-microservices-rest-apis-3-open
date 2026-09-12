# Lösung: REST-Vertrag für die Order-Ressource entwerfen

## Aufgabe 1 + 2: Pfade, Methoden, Statuscodes

| Operation | Methode | Pfad | Erfolg | Fehler |
| --- | --- | --- | --- | --- |
| Liste abrufen | GET | `/orders` | 200 | - |
| Einzelne abrufen | GET | `/orders/{id}` | 200 | 404 |
| Anlegen | POST | `/orders` | 201 | 400 |
| Aktualisieren | PUT | `/orders/{id}` | 200 | 400, 404 |
| Löschen | DELETE | `/orders/{id}` | 204 | 404 |

## Aufgabe 3: Vollständiges OpenAPI-Dokument

Die Referenzlösung liegt unter [`output/project/contracts/order-api.yaml`](../../../project/contracts/order-api.yaml) und wird ab Lab 2 als verbindlicher Vertrag für beide Sprachspuren verwendet.

## Aufgabe 4: Grenzfall `quantity: 0`

`POST /orders` mit `quantity: 0` verstößt gegen `minimum: 1` im `NewOrder`-Schema und muss mit `400 Bad Request` beantwortet werden. Das ist bereits in der Referenzlösung als Antwortcode für `createOrder` und `updateOrder` hinterlegt. Die serverseitige Durchsetzung dieser Regel entsteht in Lab 3 (Validierung); der Vertrag legt hier nur fest, *dass* ein Fehlerfall existiert, nicht *wie* er implementiert wird.
