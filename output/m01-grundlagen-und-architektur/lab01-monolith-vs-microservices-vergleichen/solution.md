# Lösung: Monolith vs. Microservices einordnen

## Aufgabe 1: Drei Systeme einordnen

| System | Empfehlung | Begründung |
| --- | --- | --- |
| A: Interne Reporting-App, 4 Personen, ein Team | **Monolith** | Kein unabhängiger Skalierungsbedarf, ein Team, seltene Änderungen. Der zusätzliche Betriebsaufwand von Microservices hat hier keinen Gegenwert. |
| B: Online-Shop mit stark schwankendem Checkout-Traffic, drei Teams | **Microservices** | Checkout muss unabhängig vom Backoffice skalieren (Kriterium "Skalierungsbedarf"); drei Teams profitieren von unabhängigem Deployment (Kriterium "Teamgröße"). |
| C: Studierenden-Verwaltung, ein Team, überschaubare Nutzerzahl | **Monolith** | Ein Team, gleichmäßige und geringe Last, seltene Änderungen; Microservices würden nur zusätzliche Betriebskomplexität ohne Nutzen erzeugen. |

## Aufgabe 2: Bestell-Plattform einordnen

**Empfehlung: Microservices**, mit folgender Begründung:

- **Skalierungsbedarf unterschiedlich:** Bestellannahme (Order) kann bei Aktionen/Lastspitzen deutlich stärker beansprucht werden als Benachrichtigung (Notification); eine getrennte Skalierung ist sinnvoll.
- **Fehlertoleranz:** Ein Ausfall der Benachrichtigung soll die Bestellannahme nicht blockieren - das ist mit Microservices und asynchroner Kommunikation (siehe Modul 5/6) direkt abbildbar, mit einem Monolithen nur über Zusatzaufwand.
- Zusätzlich unterstützt die Aufteilung das didaktische Ziel des Kurses, reale Servicegrenzen, REST- und Ereigniskommunikation an einem nachvollziehbaren Beispiel zu üben.

Eine Begründung ausschließlich mit "Microservices sind moderner" wäre nicht ausreichend - das Kriterium fehlt.

## Aufgabe 3: Grenzfall

Wenn bei System B **ein einziges kleines Team** für alle drei Bereiche (Checkout, Backoffice, Reporting) zuständig wäre und die Lastunterschiede gering blieben, würde das Kriterium "Teamgröße" und "Skalierungsbedarf" beide für einen Monolithen sprechen: Die Koordinationskosten mehrerer Services würden dann höher wiegen als der Skalierungsvorteil.
