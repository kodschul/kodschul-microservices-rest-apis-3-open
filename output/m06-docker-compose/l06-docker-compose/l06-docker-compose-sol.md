# Lösung M06: Compose-Landschaft betreiben und diagnostizieren

## Szenario und Ziel

Die Referenzlösung baut den Java- und Python-Service, startet beide zusammen mit RabbitMQ, prüft den vollständigen Durchstich und belegt einen Fehler anhand von Compose-Konfiguration, Status und Logs.

**Dauer Basispfad:** 105 Minuten, E08 60 Minuten und E09 45 Minuten
**Zielartefakt:** laufende Compose-Landschaft, Diagnoseprotokoll, korrigierte Konfiguration und sauberer Abschluss

## Voraussetzungen und Starter

- abgeschlossene M05-Referenzlösung
- funktionsfähige lokale Container-Runtime mit Compose
- vorhandene Java- und Python-Dockerfiles
- vorbereitete Compose-Datei für Java, Python und RabbitMQ
- vorbereitete fehlerhafte Compose-Variante
- freie Kursports und konfigurierte lokale Werte, die nicht ausgegeben werden

## Aufgabe 1: Dockerfiles prüfen und Images bauen

Der Java-Build verwendet eine Maven-Stufe mit `verify` und kopiert danach nur das erzeugte JAR in ein Java-Laufzeit-Image. Der Python-Build installiert die festgelegten Abhängigkeiten in ein schlankes Python-Image und kopiert anschließend die Anwendung. Beide Images definieren Port, Startkommando und Healthcheck.

```powershell
docker compose build order-service notification-service
```

Erwartet werden zwei erfolgreiche Image-Builds. Zu diesem Zeitpunkt müssen noch keine Anwendungscontainer laufen.

**Checkpoint:** Images sind gebaute Vorlagen; Container entstehen erst beim Start der Services.

## Aufgabe 2: Compose-Konfiguration erklären

```powershell
docker compose config
```

Die gerenderte Konfiguration enthält drei Services. Vom Host werden die veröffentlichten Kursports verwendet. Im Compose-Netzwerk verbindet sich Java mit `notification-service` und `rabbitmq`; Python verbindet sich ebenfalls mit `rabbitmq`. Die internen Zielports bleiben die in den jeweiligen Containern bereitgestellten Ports.

RabbitMQ besitzt einen Broker-Healthcheck. Notification Service und Order Service prüfen ihre HTTP-Health-Endpunkte. Die Abhängigkeiten warten auf `service_healthy`, bevor nachgelagerte Services starten.

**Checkpoint:** Hostzugriff, interne Service-Namen, Umgebung und Health-Abhängigkeiten sind getrennt erklärt.

## Aufgabe 3: Gesamtlandschaft starten und prüfen

```powershell
& ..\scripts\start-reference.ps1
docker compose ps
& ..\scripts\smoke-reference.ps1
```

`ps` soll RabbitMQ, Notification Service und Order Service als laufend und gesund zeigen. Der Smoke-Test endet mit `Smoke test passed` und prüft:

- Python-Health mit HTTP `200`,
- gültige Bestellung mit HTTP `201` und angenommener Notification,
- Bestellmenge an der unteren ungültigen Grenze mit HTTP `400`,
- Dispatch mit HTTP `202` und anschließend sichtbarem `OrderDispatched`.

**Checkpoint:** Build, Netzwerk, Service-Namen, HTTP-Integration und Messaging funktionieren gemeinsam.

## Aufgabe 4: Vorbereiteten Fehler eingrenzen

Beispiel für die bereitgestellte Service-Name-Störung: Die Basisadresse des Notification Service zeigt auf einen Namen, der im Compose-Netzwerk nicht existiert.

```powershell
docker compose config
docker compose ps
docker compose logs order-service notification-service
```

| Feld | Diagnose |
| --- | --- |
| Symptom | Order-Aufruf erreicht den Notification Service nicht |
| Konfiguration | interne Basisadresse enthält einen unbekannten Service-Namen |
| Status | Container können laufen, obwohl der fachliche Aufruf scheitert |
| Logs | Order Service meldet den Downstream-Verbindungsfehler; Python zeigt keinen passenden Aufruf |
| Ursache | Namensauflösung im Compose-Netzwerk kann das falsche Ziel nicht finden |

Bei einer Portstörung wäre die Evidenz anders: `up` meldet die gescheiterte Host-Port-Bindung. Die Fehlerarten dürfen deshalb nicht aus demselben Symptom abgeleitet werden.

**Checkpoint:** Der falsche interne Zielname ist durch gerenderte Konfiguration und korrespondierende Logs belegt.

## Aufgabe 5: Ursache korrigieren und validieren

Setzen Sie die interne Notification-Basisadresse wieder auf den Compose-Service `notification-service` mit dessen Container-Port. Lokale Zugriffswerte bleiben in der vorhandenen Umgebungskonfiguration.

```powershell
docker compose up --detach --wait order-service
docker compose ps
& ..\scripts\smoke-reference.ps1
```

Erwartet werden wieder gesunde Services und `Smoke test passed`. Das Diagnoseprotokoll ergänzt: eine Konfigurationsursache geändert, betroffenen Service neu erstellt, vollständigen positiven, Grenz- und Ereignispfad erneut geprüft.

**Checkpoint:** Die Korrektur stellt den vollständigen Referenzcheckpoint wieder her, nicht nur einen laufenden Prozess.

## Aufgabe 6: Umgebung kontrolliert bereinigen

```powershell
& ..\scripts\stop-reference.ps1
docker compose ps
```

Der erste Befehl verwendet `down --remove-orphans`. Die anschließende Statusausgabe enthält keine laufenden Kursservices. Images dürfen für spätere Module lokal erhalten bleiben; M06 führt keine Registry, Volumes, Kubernetes-Ressourcen oder Monitoring-Dienste ein.

**Checkpoint:** Container und Compose-Netzwerk der Kurslandschaft sind entfernt, lokale Konfigurationswerte wurden nicht protokolliert.

## Abschlusskriterien

- [x] Java- und Python-Images wurden aus den vorhandenen Dockerfiles gebaut.
- [x] Java, Python und RabbitMQ liefen gesund in Compose.
- [x] Positiver, Grenz- und Ereignispfad wurden geprüft.
- [x] Eine vorbereitete Störung wurde mit Evidenz diagnostiziert und korrigiert.
- [x] Die Umgebung wurde ohne Ausgabe lokaler Werte bereinigt.

## Erweiterung

Beim Portfehler scheitert der Start an einer belegten Host-Port-Bindung; die Service-Logs sind dafür meist nachrangig. Beim falschen Service-Namen können Container gesund erscheinen, während der fachliche Netzwerkaufruf scheitert; hier sind effektive Konfiguration und Anwendungslogs entscheidend. Diese Gegenüberstellung bleibt innerhalb des genehmigten Diagnoseumfangs.

## Fallback

Gerenderte Konfiguration, Status- und Logauszüge erlauben eine belegte Ursachenanalyse. Ohne Container-Runtime sind Image-Build, Netzwerk, Health-Abhängigkeiten, Smoke-Test und Cleanup jedoch nicht selbst ausgeführt; der Reproduzierbarkeitscheckpoint bleibt offen.