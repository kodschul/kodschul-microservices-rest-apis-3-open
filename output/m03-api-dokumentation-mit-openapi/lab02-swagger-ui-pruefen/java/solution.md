# Lösung (Java-Spur): Swagger UI prüfen

## Aufgabe 1 + 2: Bestellung anlegen

Nach "Try it out" bei `POST /orders` und Eingabe von z. B.

```json
{"customerName": "Mara Beispiel", "itemName": "Kaffeemaschine", "quantity": 2}
```

zeigt Swagger UI im Antwortbereich `Code: 201` sowie den vollständigen Response-Body inklusive generierter `id` und `status: "NEW"`.

## Aufgabe 3: Fehlerfall

Mit `"quantity": 0` zeigt Swagger UI `Code: 400` und den in Modul 2/Lab 3 definierten Fehlerkörper (`{"error": "Validation failed"}`), sofern die Fehlerbehandlung korrekt implementiert wurde.

## Aufgabe 4: Grenzen von Swagger UI

Swagger UI eignet sich für manuelles, exploratives Testen, aber nicht für wiederholbare automatisierte Prüfungen: Jeder Aufruf erfordert manuelle Klicks, es gibt keine Historie über mehrere Testläufe hinweg, und die Ergebnisse werden nicht automatisch mit einem erwarteten Wert verglichen. `MockMvc`-Tests laufen dagegen bei jedem Build automatisch, sind reproduzierbar und lassen sich in CI/CD-Pipelines einbinden (Vorgriff auf Modul 9).
