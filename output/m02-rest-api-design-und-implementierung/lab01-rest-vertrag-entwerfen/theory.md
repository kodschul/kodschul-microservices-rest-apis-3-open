---
theme: default
---

# Lab 1: REST-API-Design-Prinzipien und Vertragsentwurf

## Lernziel

Nach diesem Lab könnt ihr HTTP-Methoden und Statuscodes korrekt einsetzen und einen REST-Vertrag (OpenAPI) für eine Ressource entwerfen, bevor Code geschrieben wird.

## Leitfragen

1. Welche HTTP-Methode passt zu welcher Operation?
2. Welche Statuscodes signalisieren welches Ergebnis?
3. Warum lohnt sich "Contract-first" vor der Implementierung?

## HTTP-Methoden für REST-Ressourcen

| Methode | Bedeutung | Beispiel für `/orders` |
| --- | --- | --- |
| `GET` | Ressource(n) lesen, keine Seiteneffekte | `GET /orders`, `GET /orders/{id}` |
| `POST` | neue Ressource anlegen | `POST /orders` |
| `PUT` | Ressource vollständig ersetzen/aktualisieren | `PUT /orders/{id}` |
| `DELETE` | Ressource entfernen | `DELETE /orders/{id}` |

`GET` und `DELETE` sollten **idempotent** sein: mehrfaches Ausführen derselben Anfrage liefert denselben Endzustand. `POST` ist bewusst nicht idempotent (jeder Aufruf legt eine neue Ressource an).

## Statuscodes

| Code | Bedeutung | Beispiel |
| --- | --- | --- |
| `200 OK` | Anfrage erfolgreich, Antwortkörper vorhanden | `GET /orders/{id}` gefunden |
| `201 Created` | Ressource erfolgreich angelegt | `POST /orders` erfolgreich |
| `204 No Content` | Erfolgreich, kein Antwortkörper | `DELETE /orders/{id}` erfolgreich |
| `400 Bad Request` | Eingabe fehlerhaft (z. B. Validierung) | `quantity` ist 0 oder negativ |
| `404 Not Found` | Ressource existiert nicht | `GET /orders/{unbekannte-id}` |
| `409 Conflict` | Zustand erlaubt die Operation nicht | Status-Übergang unzulässig |

## JSON als Datenformat

Der Kurs verwendet JSON als einziges Austauschformat (statt XML), da es kompakter ist und von beiden Sprachspuren (Java/Jackson, Python/Pydantic) ohne Zusatzaufwand unterstützt wird. Ein Beispiel-Order-Objekt:

```json
{
  "id": "a3f1c2d4-...",
  "customerName": "Mara Beispiel",
  "itemName": "Kaffeemaschine",
  "quantity": 2,
  "status": "NEW",
  "createdAt": "2026-09-12T09:00:00Z"
}
```

## Contract-first mit OpenAPI

Beim **Contract-first-Ansatz** wird die Schnittstelle (Pfade, Methoden, Datenmodelle, Statuscodes) zuerst als OpenAPI-Dokument beschrieben, bevor Code entsteht. Vorteile:

- Frontend/Client-Teams können parallel gegen den Vertrag arbeiten, bevor die Implementierung fertig ist.
- Der Vertrag ist sprachneutral - er gilt unabhängig davon, ob dahinter Java oder Python steht (wichtig für den Dual-Track-Ansatz dieses Kurses).
- Abweichungen zwischen Vertrag und späterer Implementierung werden sichtbar (siehe Modul 3).

## Checkpoint

Ihr könnt begründen, welche HTTP-Methode und welcher Statuscode zu einer gegebenen Operation passen, und eine minimale OpenAPI-Struktur lesen.
