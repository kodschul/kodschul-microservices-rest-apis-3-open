---
theme: default
title: M03 – REST und OpenAPI
transition: slide-left
mdc: true
---

# M03: REST und OpenAPI

## Von der Servicegrenze zum überprüfbaren Vertrag

**Ergebnis:** Ressourcen, HTTP-Semantik, Fehler und Java-Verhalten bilden einen validierten Vertrag.

**Gesamtdauer:** 255 Minuten über Tag 1 und Tag 2: 45 Minuten Input, 20 Minuten Demo sowie 190 Minuten E03/E04-Praxis.

---

# Leitfragen

- Welche Ressource trägt die fachliche Bedeutung?
- Wie unterscheiden sich Erfolg, Grenzfall und Fehler im Vertrag?
- Was prüft OpenAPI, und was bleibt Implementierungsaufgabe?
- Wann hilft generierter Code, und wo erzeugt er neue Abhängigkeit?

---

# Das mentale Modell

**Domänenentscheidung → Ressource und Operation → OpenAPI-Vertrag → Implementierung und Vertragscheck**

Die Fachgrenze bestimmt die Ressource. OpenAPI beschreibt die öffentliche Grenze. Erst der Abgleich mit dem laufenden Service zeigt, ob Vertrag und Verhalten übereinstimmen.

---

# Ressourcen statt Aktionen

- `/api/orders` bezeichnet die Sammlung der Bestellungen.
- `POST` erzeugt eine Bestellung aus einer Repräsentation.
- `/api/orders/{orderId}` bezeichnet eine konkrete Bestellung.
- Der Statuscode beschreibt das Ergebnis auf HTTP-Ebene.
- Der Antwortkörper trägt fachliche Daten oder einen stabilen Fehlercode.

URI, Methode, Status und Schema bilden gemeinsam die Operation. Keines dieser Elemente ersetzt die anderen.

---

# Methoden und beobachtbare Ergebnisse

| Methode | Fachliche Absicht |
| --- | --- |
| `POST` | anlegen oder fachlichen Übergang anstoßen |
| `GET` | lesen |
| `PUT` / `PATCH` | vollständig ersetzen / teilweise ändern |
| `DELETE` | entfernen |

Methodenwahl folgt der fachlichen Absicht. Nicht jede theoretisch mögliche Operation gehört in den Kursvertrag.

---

# Erfolg, Grenze und Fehler

Der geprüfte Bestellpfad unterscheidet drei Fälle:

| Fall | HTTP-Ergebnis | Stabiler Fehlercode |
| --- | --- | --- |
| gültige Bestellung | `201 Created` | keiner |
| Menge außerhalb der Eingabegrenze | `400 Bad Request` | `INVALID_ORDER` |
| Notification Service nicht erreichbar | `502 Bad Gateway` | `DOWNSTREAM_UNAVAILABLE` |

Ein stabiler maschinenlesbarer Code ist für Clients verlässlicher als die freie Formulierung einer Meldung.

---

# JSON als Basispfad, XML als Grenze

JSON ist im Referenzpfad praktisch geprüft und passt direkt zu Java-Records, Python-Modellen und OpenAPI-Schemas.

XML kann dieselbe Fachinformation darstellen, benötigt aber zusätzliche Festlegungen zu Elementen, Attributen, Namespaces und Parserkonfiguration. Der Kurs vergleicht diese Konsequenzen, implementiert jedoch keinen zweiten XML-Pfad.

Die Entscheidung ist keine allgemeine Rangfolge: Ein bestehender XML-Vertrag kann organisatorisch oder technisch verbindlich sein.

---

# OpenAPI als Vertrag

Ein belastbarer Ausschnitt beschreibt Pfad, Methode, Request Body, Medientyp, Pflichtfelder, Grenzen und jede relevante Response. Wiederverwendbare Komponenten halten die Schemas konsistent.

Syntaxvalidierung findet Strukturfehler. Sie beweist nicht, dass der laufende Java-Endpunkt dieselben Antworten liefert.

---

# Verifiziertes Schema-Beispiel

Der bereitgestellte Notification-Vertrag begrenzt `order_id` auf 1 bis 40 Zeichen, erlaubt die Kanäle `email` und `sms` und liefert bei Annahme den Status `accepted`.

```json
{
  "order_id": "order-100",
  "recipient": "dev@example.test",
  "channel": "email"
}
```

Erwartetes Ergebnis des geprüften Aufrufs: `202 Accepted` mit derselben `order_id`, dem Status `accepted` und dem gewählten Kanal.

---

# Generierte Clients und Server-Stubs

| Nutzen | Grenze |
| --- | --- |
| Typen und Aufrufoberflächen entstehen reproduzierbar | Fachregeln entstehen nicht |
| Vertragsänderungen werden beim Build sichtbar | ungünstige Verträge erzeugen ungünstige APIs |
| wiederholter Transportcode wird reduziert | Generator und Optionen werden Build-Abhängigkeiten |
| Ausgabe kann neu erzeugt werden | manuelle Änderungen gehen dabei verloren |

Die vorbereitete Client-Variante ist deshalb ein Vergleichspunkt, keine Garantie für korrekte Integration.

---

# Java-Vertragschecks

Ein vollständiger Check beobachtet die öffentliche Grenze: positiver Request, Grenzwertverletzung und Ausfall des abhängigen Service. Status und Antwortschema werden jeweils geprüft.

Ein Unit-Test der Anwendungslogik ergänzt diesen Check, ersetzt ihn aber nicht.

---

# Fehlerbild: Vertrag und Laufzeit driften

Der Vertrag nennt einen Fehler, aber die Implementierung liefert einen anderen Status oder ein anderes Feld. Ursachen können ein unveränderter Controller, abweichende Validierungsgrenzen, ein veralteter Client oder ein ungefilterter Downstream-Fehler sein.

Die Reparatur beginnt mit einem reproduzierbaren Vertragscheck, nicht mit einer stillen Anpassung nur einer Seite.

---

# Checkpoint und Brücke

M03 ist abgeschlossen, wenn:

- Ressourcen und Methoden fachlich begründet sind,
- JSON-Schemas Erfolg und Fehler abdecken,
- der OpenAPI-Vertrag syntaktisch gültig ist,
- positiver, Grenz- und Ausfallfall am Java-Endpunkt geprüft sind,
- Nutzen und Grenzen der Generierung dokumentiert sind.

**Nächster Schritt:** M04 nutzt den Vertrag, um den vorbereiteten FastAPI-Service ohne Python-Voraussetzung in den Java-Pfad einzubinden.