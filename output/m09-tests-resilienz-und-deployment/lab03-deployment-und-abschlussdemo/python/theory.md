---
theme: default
---

# Lab 3 (Python-Spur): Deployment-Strategien, DevOps und Abschlussdemonstration

## Lernziel

Nach diesem Lab könnt ihr Deployment-Strategien vergleichen, ihre Rolle im agilen/DevOps-Arbeitsalltag einordnen und die gesamte Bestell-Plattform als funktionierendes Gesamtsystem demonstrieren.

## Leitfragen

1. Was unterscheidet Rolling-, Blue-Green- und Canary-Deployment?
2. Wie hängen Agile Softwareentwicklung, CI/CD und DevOps zusammen?

## Deployment-Strategien im Überblick

| Strategie | Vorgehen | Vorteil | Nachteil |
| --- | --- | --- | --- |
| Rolling Deployment | Alte Instanzen werden nach und nach durch neue ersetzt | Kein zusätzlicher Ressourcenbedarf | Kurzzeitig laufen alte und neue Version parallel |
| Blue-Green Deployment | Neue Version läuft komplett parallel (Green), Umschaltung erfolgt schlagartig | Schneller Rollback durch Zurückschalten | Doppelter Ressourcenbedarf während der Umstellung |
| Canary Deployment | Neue Version erhält zunächst nur einen kleinen Anteil des Traffics | Risiko wird früh und mit kleiner Nutzergruppe sichtbar | Höherer Steuerungsaufwand (Traffic-Aufteilung nötig) |

Für dieses Kursprojekt (lokale Docker-Compose-Umgebung) ist ein einfaches **Rolling Deployment** ausreichend; Blue-Green und Canary lohnen sich erst bei produktivem Cloud-Betrieb mit echtem Nutzerverkehr.

## Agile Softwareentwicklung, CI/CD und DevOps

- **Agile Softwareentwicklung** liefert in kurzen Zyklen nutzbare Ergebnisse - passt zur inkrementellen Struktur dieses Kurses (jedes Modul liefert einen funktionierenden Zwischenstand).
- **Continuous Integration (CI)** baut und testet bei jeder Codeänderung automatisiert - eure `test_orders.py`- und `test_events.py`-Tests wären typische CI-Bausteine.
- **Continuous Deployment (CD)** bringt geprüfte Änderungen automatisiert in Richtung Produktion.
- **DevOps** beschreibt die organisatorische Praxis, Entwicklung und Betrieb eng zu verzahnen - sichtbar z. B. daran, dass ihr in diesem Kurs sowohl Code (Modul 1-6) als auch Betrieb (Modul 7-9) selbst verantwortet.

## Checkpoint

Ihr könnt eine Deployment-Strategie für ein gegebenes Szenario begründet wählen und die Rolle von CI/CD im Gesamtbild einordnen.
