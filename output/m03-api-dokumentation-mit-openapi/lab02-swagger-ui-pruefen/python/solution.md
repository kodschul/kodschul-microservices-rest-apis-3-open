# Lösung (Python-Spur): Swagger UI prüfen

## Aufgabe 1 + 2: Bestellung anlegen

Nach "Try it out" bei `POST /orders` und Eingabe von z. B.

```json
{"customerName": "Mara Beispiel", "itemName": "Kaffeemaschine", "quantity": 2}
```

zeigt Swagger UI im Antwortbereich `Code: 201` sowie den vollständigen Response-Body inklusive generierter `id` und `status: "NEW"`.

## Aufgabe 3: Fehlerfall

Mit `"quantity": 0` zeigt Swagger UI `Code: 400` (statt FastAPIs Standard `422`), sofern der in Modul 2/Lab 3 registrierte `RequestValidationError`-Handler korrekt implementiert wurde. Ist der Handler nicht registriert, zeigt sich hier `422` - ein guter Anlass, die Lab-3-Lösung noch einmal zu prüfen.

## Aufgabe 4: `/docs` vs. `/redoc`

`/docs` (Swagger UI) bietet interaktives "Try it out" mit ausführbaren Formularen; `/redoc` ist rein lesend, zeigt aber häufig eine übersichtlichere, besser strukturierte Darstellung bei vielen Endpunkten und Schemas - praktisch für reine Dokumentationszwecke ohne Testabsicht.
