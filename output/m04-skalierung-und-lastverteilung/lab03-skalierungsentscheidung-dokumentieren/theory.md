---
theme: default
---

# Lab 3: Skalierungsentscheidung dokumentieren

## Lernziel

Nach diesem Lab könnt ihr eine Skalierungsentscheidung für die Bestell-Plattform inklusive Cloud-Optionen begründet dokumentieren.

## Leitfragen

1. Welche Services der Bestell-Plattform haben unterschiedlichen Skalierungsbedarf?
2. Welche Cloud-Skalierungsoptionen passen zu welchem Bedarf?

## Cloud-Skalierungsoptionen im Überblick

| Option | Kurzbeschreibung | Passt gut zu |
| --- | --- | --- |
| Managed Container-Orchestrierung (z. B. Kubernetes-Dienst eines Cloud-Anbieters) | automatisches Hinzufügen/Entfernen von Pods nach Metriken | mehrere Services mit unterschiedlichem, schwankendem Bedarf |
| Serverless-Funktionen | Code läuft nur bei Bedarf, automatische Skalierung auf null | seltene, ereignisgetriebene Aufgaben (z. B. Benachrichtigungsversand) |
| Managed Datenbank mit Lesereplikaten | zusätzliche Lesekapazität ohne eigene Infrastruktur | lesehungrige Services bei wachsender Nutzerzahl |
| Feste Instanzgruppe mit Autoscaling-Regel | Anzahl der Instanzen richtet sich nach CPU/Anfragen | vorhersehbar schwankende Last (z. B. Tagesrhythmus) |

## Entscheidungsdokument: erwarteter Aufbau

Ein knappes Entscheidungsdokument beantwortet:

1. Welcher Service/welche Services sind betroffen?
2. Welches Lastmuster liegt vor (gleichmäßig, schwankend, spitzenlastig)?
3. Welche Option wurde gewählt, und warum?
4. Welche Kosten oder Risiken nimmt die Entscheidung bewusst in Kauf?

## Checkpoint

Ihr könnt ein kurzes, begründetes Entscheidungsdokument für die Skalierung eines Services erstellen.
