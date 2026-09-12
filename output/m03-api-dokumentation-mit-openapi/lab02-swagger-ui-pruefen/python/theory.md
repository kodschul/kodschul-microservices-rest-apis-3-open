---
theme: default
---

# Lab 2 (Python-Spur): Swagger UI prüfen

## Lernziel

Nach diesem Lab könnt ihr die von FastAPI mitgelieferte Swagger UI nutzen, um eure API interaktiv zu erkunden und zu testen.

## Leitfragen

1. Woher kommt die Swagger UI unter `/docs`, und wie hängt sie mit der OpenAPI-Spezifikation aus Lab 1 zusammen?
2. Wofür eignet sich Swagger UI im Alltag, wofür eher nicht?

## Swagger UI in FastAPI

FastAPI liefert Swagger UI **automatisch mit**, ohne Zusatzabhängigkeit - erreichbar unter `http://localhost:8081/docs`. Sie liest die unter `/openapi.json` erzeugte Spezifikation und rendert daraus interaktive Formulare für jede Operation. Zusätzlich steht unter `/redoc` eine alternative, eher lesefreundliche Dokumentationsoberfläche zur Verfügung (kein "Try it out", dafür bessere Übersichtlichkeit bei größeren APIs).

## Wofür Swagger UI gut ist

- schneller manueller Test einzelner Endpunkte während der Entwicklung,
- Onboarding neuer Teammitglieder oder Kolleg:innen aus anderen Teams,
- lebendige Dokumentation, die nie veraltet, weil sie aus dem laufenden Code stammt.

## Wofür Swagger UI nicht geeignet ist

- automatisierte, wiederholbare Tests (dafür: Integrationstests wie in Modul 2/Lab 3 mit `TestClient`),
- Lasttests oder Testszenarien mit vielen Abhängigkeiten zwischen Aufrufen,
- Dokumentation für Endanwender:innen ohne technischen Hintergrund.

## Checkpoint

Ihr könnt in Swagger UI eine Operation ausklappen, Beispieldaten eingeben, ausführen und die tatsächliche Antwort (Statuscode, Body) ablesen.
