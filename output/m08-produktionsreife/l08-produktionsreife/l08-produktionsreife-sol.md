# Lösung M08: Produktionsreife bewerten und nächste Schritte priorisieren

## Szenario und Ziel

Die Referenzbewertung behandelt den Kursstand als funktionsfähigen Entwicklungsnachweis, nicht als produktionsfertiges System. Sie ordnet die lokale Skalierungsgrenze ein und priorisiert fehlende Betriebs-, Delivery- und Ownership-Nachweise.

**Dauer Basispfad:** 95 Minuten, D02 20 Minuten und E11 75 Minuten
**Zielartefakt:** Skalierungsbeobachtung, ausgefülltes Produktionsreife-Review und priorisierter Verbesserungsplan mit Transferschritt

## Voraussetzungen und Starter

- abgeschlossener M07-Basispfad
- lauffähige Compose-Landschaft
- alle eigenen Pflichtcheckpoints aus M01 bis M07
- Review-Raster für Architektur, Verträge, Tests, Betrieb, Beobachtbarkeit, Deployment, Delivery und Ownership
- Vorlage für Risiko, Evidenz, Maßnahme, Priorität, Abhängigkeit, Rolle und Nachweis

## Aufgabe 1: Horizontale und vertikale Skalierung abgrenzen

Vertikal bedeutet für den Notification Service mehr CPU oder Arbeitsspeicher für denselben Container. Horizontal bedeutet mehrere gleichartige Notification-Instanzen. Vertikal ist lokal einfacher, besitzt aber eine harte Ressourcenobergrenze. Horizontal kann Kapazität und Ausfallverteilung verbessern, benötigt jedoch Routing, zustandsarme Verarbeitung und Betriebsbeobachtung.

```powershell
Set-Location reference
docker compose up --build --detach --wait
docker compose ps
docker compose up --detach --scale notification-service=2
docker compose ps --all
```

Die feste Host-Veröffentlichung des Notification-Ports kann die zweite Instanz an einer Portkollision hindern. Selbst wenn zwei Instanzen laufen, ruft der Order Service über den Compose-Service-Namen auf; ohne nachgewiesene Verteilungsregel und Lastmessung ist weder faire Verteilung noch Kapazitätsgewinn belegt.

```powershell
docker compose up --detach --scale notification-service=1
docker compose ps
```

**Checkpoint:** Der Versuch zeigt Instanzierung und lokale Portgrenzen. Er ist kein Lasttest, kein Hochverfügbarkeitsnachweis und keine Cloud- oder Kubernetes-Übung.

## Aufgabe 2: Architektur und Verträge bewerten

| Dimension | Evidenz | Stärke | Verbleibendes Risiko | Nächster Nachweis |
| --- | --- | --- | --- | --- |
| Servicegrenzen | Context Map und getrennte Java-/Python-Rollen | Order und Notification sind fachlich unterscheidbar | Datenhoheit für dauerhaft gespeicherte Bestellungen ist noch nicht umgesetzt | Eigentümer und Schreibpfad pro Datensatz dokumentieren |
| REST | positiver, Grenz- und Downstream-Fall | Fehler werden fachlich sichtbar | Kompatibilitätsregeln für Änderungen fehlen | eine rückwärtskompatible Vertragsänderung prüfen |
| OpenAPI | veröffentlichter Vertrag gegen Laufzeitschema getestet | strukturelle Drift wird früh erkannt | Versionierungs- und Freigabeprozess fehlt | Vertragsprüfung als verpflichtendes Delivery-Gate definieren |
| Messaging | Event-Payload und Ende-zu-Ende-Fluss getestet | asynchroner Dispatch ist nachvollziehbar | Duplikate und Wiederanlauf sind nicht abgesichert | Idempotenzregel und Wiederanlauftest entwerfen |

Das höchste Vertragsrisiko ist die fehlende Änderungspolitik: Ein grüner Vertragstest schützt den aktuellen Stand, aber noch nicht vor einer inkompatiblen nächsten Version.

**Checkpoint:** Stärke, Risiko und nächster Nachweis sind getrennt; die priorisierte Vertragsmaßnahme ist ein Kompatibilitäts-Gate.

## Aufgabe 3: Tests, Resilienz und Betrieb bewerten

| Bereich | Vorhandene Evidenz | Bewertung | Größte Lücke |
| --- | --- | --- | --- |
| Unit | Java-Service- und Event-Tests | zentrale Klassenpfade sind schnell prüfbar | fachliche Regeln sind noch sehr klein |
| Vertrag | OpenAPI gegen FastAPI-Schema | aktuelle Struktur ist abgesichert | Versionskompatibilität fehlt |
| Integration | Java-Python-Smoke und Downstream-Ausfall | Servicegrenze und `502` sind belegt | langsame Antwort ist nicht separat simuliert |
| End-to-End | Compose-Smoke mit RabbitMQ | positiver Gesamtfluss ist ausführbar | Last, Wiederanlauf und Duplikate fehlen |
| Betrieb | Start, Status, Logs und Cleanup | lokaler Ablauf ist reproduzierbar | Rückroll- und Bereitschaftskriterien für Releases fehlen |
| Resilienz | expliziter Timeout ohne blinde Wiederholung | Wartezeit ist begrenzt | Idempotenz vor einer Wiederholungsstrategie fehlt |

Das größte Betriebsrisiko ist nicht fehlende Testmenge, sondern ein fehlender Release- und Rückrollnachweis. Er verbindet Vertragskompatibilität, Smoke-Test und Betriebsentscheidung.

**Checkpoint:** Die Bewertung unterscheidet vorhandene lokale Evidenz von noch offenen Produktionsbedingungen.

## Aufgabe 4: Logging und Monitoring-Konzept skizzieren

| Serviceziel | Signal | Beispielschwelle | Reaktion | Rolle |
| --- | --- | --- | --- | --- |
| gültige Bestellungen erhalten zeitnah eine kontrollierte Antwort | Anteil erfolgreicher Antworten, Downstream-Fehler, Antwortzeit | vereinbarte Fehlerrate oder Antwortzeit wird in mehreren Messfenstern überschritten | Änderung stoppen, Logs korrelieren, Rückrollentscheidung treffen | diensthabende Betriebsrolle mit Service-Ownership |
| Dispatch-Ereignisse werden verarbeitet | veröffentlichte und konsumierte Ereignisse, Alter unbearbeiteter Ereignisse | Differenz oder Alter überschreitet das vereinbarte Betriebsziel | Consumer und Brokerzustand prüfen, Wiederanlauf kontrollieren | verantwortliches Messaging-/Service-Team |

Strukturierte Logs benötigen mindestens Zeit, Service, Operation, Ergebnis und eine korrelierbare Auftragskennung. Metriken zeigen Häufigkeit und Dauer; Traces verbinden den Weg über Servicegrenzen. Konkrete Schwellen werden aus realen Last- und Geschäftsanforderungen abgeleitet, nicht aus dem Kursbeispiel erfunden.

**Checkpoint:** Zwei Ziele besitzen Signale, Reaktion und Ownership. Prometheus, Grafana oder ein anderer Monitoring-Stack werden nicht implementiert.

## Aufgabe 5: Deployment, Delivery und Ownership planen

| Strategie | Eignung | Trade-off |
| --- | --- | --- |
| Rolling | geeignet bei rückwärtskompatiblen Versionen und knappen Ressourcen | Mischbetrieb alter und neuer Version muss unterstützt werden |
| Blue/Green | geeignet, wenn schneller Umschalt- und Rücksprung wichtiger ist | zwei vollständige Umgebungen und Datensynchronität kosten mehr |
| Canary | geeignet bei messbaren Signalen und steuerbarem Routing | Routing, Beobachtung und Abbruchkriterien sind zwingend |

Für die nächste Vertragsänderung wird Rolling erst nach nachgewiesener Rückwärtskompatibilität gewählt. Der Delivery-Ablauf lautet:

| Gate oder Übergabe | Nachweis | Verantwortliche Rolle |
| --- | --- | --- |
| fachliche Freigabe | Akzeptanzfälle für positiv, Grenze und Fehler | Product Owner mit Entwicklung |
| Build und Codeprüfung | reproduzierbares Artefakt, Unit-Tests | Entwicklung |
| Vertragsprüfung | OpenAPI-Kompatibilität und Cross-Service-Test | beteiligte Service-Teams |
| Systemprüfung | Compose-Smoke und Teilausfalltest | Entwicklung und Betrieb gemeinsam |
| Deployment-Freigabe | Rollback-Schritt und Stop-Kriterien | Service-Ownership mit Betriebsrolle |
| Nachbeobachtung | Serviceziele bleiben innerhalb vereinbarter Grenzen | diensthabende Betriebsrolle |

Das ist ein Pipeline-Konzept, keine implementierte CI/CD-Pipeline. DevOps-Handoffs bestehen aus überprüfbaren Artefakten und Entscheidungen, nicht aus einer unkommentierten Übergabe.

**Checkpoint:** Rolling, Gates, Rückrollentscheidung und Rollen bilden einen konsistenten Ablauf.

## Aufgabe 6: Verbesserungsplan und Transfer abschließen

| Priorität | Risiko und Begründung | Maßnahme | Abhängigkeit | Rolle | Abschlussnachweis | Grenze |
| ---: | --- | --- | --- | --- | --- | --- |
| 1 | inkompatible Vertragsänderung kann beide Services blockieren | Kompatibilitätsregeln und verpflichtenden Vertragstest im Delivery-Fluss festlegen | keine neue Laufzeitplattform | beide Service-Teams | absichtlich inkompatible Änderung wird vor Deployment abgelehnt | ersetzt keinen laufenden Integrationstest |
| 2 | Wiederholung eines POST kann doppelte Benachrichtigungen erzeugen | Idempotenzschlüssel und gespeicherte Verarbeitung fachlich entwerfen und testen | Datenhoheit und Aufbewahrung klären | Notification-Service-Team | gleicher Schlüssel wirkt höchstens einmal; Konfliktfall ist definiert | automatische Wiederholung bleibt bis dahin aus |
| 3 | Releases besitzen keine messbare Stop- oder Rückrollentscheidung | zwei Serviceziele, Signale und Rollback-Runbook vereinbaren | reale Last- und Betriebsanforderungen | Service-Ownership und Betrieb | Probe-Release erfüllt Gate oder wird nachvollziehbar gestoppt | kein Monitoring-Stack im Kurs |

**Konkreter Transfer:** Innerhalb des nächsten Teamtermins wird ein realer Service mit demselben Review-Raster bewertet. Die verantwortliche Person bringt Vertrag, Testübersicht und letzten Betriebsbefund mit. Ergebnis sind drei priorisierte Risiken; mindestens das erste erhält Rolle, Termin und überprüfbaren Nachweis.

Diese Reihenfolge senkt zuerst das serviceübergreifende Änderungsrisiko, schafft danach die Voraussetzung für sichere Wiederholung und verbindet schließlich Releases mit Betriebsentscheidungen.

```powershell
& ../scripts/stop-reference.ps1
```

**Checkpoint:** Der Plan enthält drei abhängige, überprüfbare Maßnahmen und einen terminierten ersten Transfer statt einer ungeordneten Wunschliste.

## Abschlusskriterien

- [x] Horizontale und vertikale Skalierung wurden korrekt abgegrenzt.
- [x] Alle acht Review-Dimensionen wurden individuell bewertet.
- [x] Risiken beruhen auf vorhandener oder sichtbar fehlender Evidenz.
- [x] Drei Maßnahmen wurden priorisiert und Rollen zugeordnet.
- [x] Ein konkreter Transferschritt mit Nachweis wurde festgelegt.

## Erweiterung

Beim Übertrag auf einen eigenen anonymisierten Service werden nur die drei höchsten Risiken verglichen. Abweichende Prioritäten sind valide, wenn Auswirkung, Wahrscheinlichkeit, Evidenz und Abhängigkeiten belegt sind. Kurswerte, Portgrenzen oder Beispielrollen werden nicht ungeprüft auf die Zielumgebung übertragen.

## Fallback

Der dokumentierte Skalierungsversuch zeigt, dass eine feste Host-Port-Veröffentlichung eine lokale Zusatzinstanz begrenzen kann. Ohne eigenen Versuch bleibt diese Beobachtung unbestätigt. Architektur-, Vertrags-, Test-, Betriebs-, Beobachtbarkeits-, Deployment-, Delivery- und Ownership-Review sowie der priorisierte Transferplan bleiben vollständig bearbeitbar.