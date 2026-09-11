# Lösung M07: Testlücke schließen und Teilausfall kontrollieren

## Szenario und Ziel

Die Referenzlösung schließt eine konkrete Java-Unit-Test-Lücke, validiert den veröffentlichten Notification-Vertrag gegen das FastAPI-Laufzeitschema und diagnostiziert den Ausfall des Notification Service. Ein expliziter Client-Timeout begrenzt Wartezeit, ohne den schreibenden Aufruf automatisch zu wiederholen.

**Dauer Basispfad:** 110 Minuten, E10
**Zielartefakt:** ergänzter Test, Test- und Evidenzprotokoll sowie begründete Resilienzentscheidung

## Voraussetzungen und Starter

- abgeschlossener M06-Basispfad
- lauffähige Compose-Landschaft mit Java, Python und RabbitMQ
- vorhandene Java- und Python-Testgerüste
- veröffentlichter Notification-Vertrag und Laufzeitschema
- vorbereiteter Teilausfall des Notification Service
- Vorlage mit Risiko, Testebene, Beobachtung, Ursache, Kontrolle und Trade-off

## Aufgabe 1: Risiken den Testebenen zuordnen

| Risiko | Ebene | Vorhandener Nachweis | Gewählte Lücke |
| --- | --- | --- | --- |
| Order Service übernimmt akzeptierte Benachrichtigung falsch | Unit | positiver Service-Test | nein |
| Event-Payload ist für Python nicht lesbar | Unit/Vertrag | Publisher-Test prüft Pflichtfelder | nein |
| OpenAPI und FastAPI-Laufzeitschema driften | Vertrag | Python-Vertragstest | nein |
| Java reagiert bei Notification-Ausfall unkontrolliert | Integration | nativer Downstream-Test | nein |
| Notification Client liefert keinen Status | Unit | noch kein Test im Application Service | ja |
| Gesamtfluss über Java, Python und RabbitMQ bricht | End-to-End | Smoke-Test | nein |

Die gewählte Lücke liegt in `OrderApplicationService`: Für einen fehlenden Notification-Status existiert noch kein fokussierter Test. Ein Unit-Test ist die engste Ebene, weil nur die Reaktion der Klasse auf ihren direkten Partner geprüft wird; Container oder Netzwerk würden keine zusätzliche Aussage liefern.

**Checkpoint:** Das Risiko lautet: Eine leere Downstream-Antwort darf nicht still als erfolgreiche Bestellung erscheinen.

## Aufgabe 2: Gewählte Testlücke schließen

In `OrderApplicationServiceTest` wird der folgende Test ergänzt:

```java
@Test
void createKeepsEmptyNotificationStatusVisible() {
    when(notificationClient.notifyOrder(org.mockito.ArgumentMatchers.anyString(),
            org.mockito.ArgumentMatchers.eq("dev@example.test"))).thenReturn("");

    OrderResponse response = service.create(
            new OrderRequest("SKU-100", 2, "dev@example.test"));

    assertThat(response.status()).isEqualTo("created");
    assertThat(response.notificationStatus()).isEmpty();
}
```

Der Test dokumentiert zunächst das vorhandene Verhalten, statt eine nicht genehmigte Fachregel zu erfinden. Danach werden Einzeltest und Suite ausgeführt:

```powershell
Set-Location reference/order-service
mvn -B -Dtest=OrderApplicationServiceTest#createKeepsEmptyNotificationStatusVisible test
mvn -B test
```

Erwartet werden ein grüner Einzeltest und anschließend alle Java-Tests ohne Fehler. Als nächste Produktentscheidung wäre zu klären, ob ein leerer Status zulässig ist oder als Downstream-Fehler gelten muss.

**Checkpoint:** Die bislang unsichtbare leere Antwort ist reproduzierbar beschrieben und in der Suite abgesichert.

## Aufgabe 3: Cross-Service-Vertrag prüfen

```powershell
Set-Location ../notification-service
./.venv/Scripts/python.exe -m pytest -q tests/test_contract.py
Set-Location ../..
& ./scripts/start-reference.ps1
& ./scripts/smoke-reference.ps1 -SkipMessaging
```

Der Vertragstest vergleicht veröffentlichte Pfade, Methoden, Antwortdefinitionen sowie Länge und erlaubte Werte zentraler Felder mit dem FastAPI-Laufzeitschema. Er erkennt strukturelle Drift ohne gestartete Services.

Der Smoke-Test ergänzt den laufenden Nachweis: Java sendet eine gültige Bestellung an Python und erhält den akzeptierten Notification-Status. Er findet Verbindungs-, Serialisierungs- und Laufzeitprobleme, die ein reiner Schemavergleich nicht erkennt.

**Checkpoint:** Ein grüner Vertragstest belegt strukturelle Übereinstimmung; `Smoke test passed` belegt die laufende Java-Python-Integration.

## Aufgabe 4: Vorbereiteten Teilausfall diagnostizieren

```powershell
Set-Location reference
docker compose stop notification-service
docker compose ps
docker compose logs --since 2m order-service notification-service
```

Für den positiven Downstream-Fall wird zunächst der bereits erfolgreiche Smoke-Lauf verwendet. Während des Teilausfalls bleibt der lokale Grenzfall unabhängig vom Downstream prüfbar:

```powershell
curl.exe --silent --output boundary.json --write-out "%{http_code}" --request POST `
  --header "Content-Type: application/json" `
  --data-binary '{"sku":"SKU-100","quantity":0,"recipient":"dev@example.test"}' `
  http://localhost:8080/api/orders
curl.exe --silent --output failure.json --write-out "%{http_code}" --request POST `
  --header "Content-Type: application/json" `
  --data-binary '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}' `
  http://localhost:8080/api/orders
```

| Feld | Befund |
| --- | --- |
| Symptom | gültige Bestellung scheitert, ungültige Menge bleibt lokal ablehnbar |
| Status | Order Service läuft; Notification Service ist gestoppt |
| Logs | Java meldet einen nicht erreichbaren Downstream; Python verarbeitet keinen passenden Aufruf |
| Ursache | der synchrone Partner ist im Compose-Netzwerk nicht verfügbar |
| API-Wirkung | Grenzfall `400`; gültiger Downstream-Aufruf `502` mit `DOWNSTREAM_UNAVAILABLE` |

**Checkpoint:** Status, Logs und API-Verhalten erklären denselben Teilausfall.

## Aufgabe 5: Befund reproduzieren und Kontrolle auswählen

```powershell
docker compose start notification-service
docker compose ps
Set-Location ..
& ./scripts/smoke-reference.ps1 -SkipMessaging
Set-Location reference
docker compose stop notification-service
docker compose ps
```

Der erneute positive Lauf und derselbe Stopp reproduzieren Ausgangszustand und Fehler. Für den schreibenden Notification-POST wird ein Timeout gewählt:

| Kontrolle | Eignung | Grenze |
| --- | --- | --- |
| Timeout | begrenzt Verbindungs- und Antwortwartezeit | zu knapp erzeugt Fehler bei langsamen, noch gesunden Antworten |
| begrenzte Wiederholung | nur mit klarer transienter Fehlerklasse sinnvoll | kann denselben POST mehrfach wirksam machen und Last erhöhen |
| Idempotenz | schützt vor doppelter fachlicher Wirkung | benötigt Schlüssel und gespeicherten Zustand, die noch nicht Teil der Referenz sind |

**Checkpoint:** Der Timeout ist die kleinste testbare Kontrolle; automatische Wiederholung bleibt ohne Idempotenz ausgeschlossen.

## Aufgabe 6: Kontrolle testen und Trade-off begründen

`NotificationClient` erhält eine explizit konfigurierte Request Factory:

```java
import java.time.Duration;

import org.springframework.http.client.SimpleClientHttpRequestFactory;

public NotificationClient(@Value("${notification.base-url}") String baseUrl) {
    SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
    requestFactory.setConnectTimeout(Duration.ofSeconds(1));
    requestFactory.setReadTimeout(Duration.ofSeconds(2));
    this.restClient = RestClient.builder()
            .baseUrl(baseUrl)
            .requestFactory(requestFactory)
            .build();
}
```

```powershell
Set-Location order-service
mvn -B test
Set-Location ..
docker compose up --build --detach --wait order-service notification-service
Set-Location ..
& ./scripts/smoke-reference.ps1 -SkipMessaging
Set-Location reference
docker compose stop notification-service
```

Danach werden die beiden Aufrufe aus Aufgabe 4 wiederholt. Erwartet sind weiterhin der unveränderte Grenzfall und der kontrollierte Downstream-Fehler. Der Timeout setzt zusätzlich eine obere Wartezeit für Verbindungsaufbau und Antwort.

Der Nutzen ist begrenzte Ressourcenbindung. Die neue Gefahr ist ein falsch positiver Ausfall bei einer Antwort oberhalb der gewählten Grenze. Eine spätere Wiederholung benötigt eine kleine Höchstzahl, eine definierte transiente Fehlerklasse und für diesen POST zuerst Idempotenz.

```powershell
docker compose start notification-service
Set-Location ..
& ./scripts/smoke-reference.ps1
& ./scripts/stop-reference.ps1
Remove-Item reference/boundary.json,reference/failure.json -ErrorAction SilentlyContinue
```

**Checkpoint:** Java-Tests, positiver Smoke-Test, Grenzfall und Teilausfall bleiben nachvollziehbar; Wartezeit ist begrenzt und der Trade-off dokumentiert.

## Abschlusskriterien

- [x] Eine risikobasierte Testlücke wurde geschlossen.
- [x] Vertragstest und Cross-Service-Integration wurden getrennt nachgewiesen.
- [x] Positiver, Grenz- und Teilausfallfall wurden ausgeführt.
- [x] Der Fehler wurde vor und nach der Pause mit Test, Status und Logs reproduziert.
- [x] Eine begrenzte Kontrolle wurde getestet und mit Restgrenze begründet.

## Erweiterung

Ein Duplikatfall sendet denselben fachlichen Notification-Auftrag zweimal mit demselben stabilen Idempotenzschlüssel. Die gewünschte Regel lautet: Ein Schlüssel erzeugt höchstens eine fachliche Benachrichtigung; weitere identische Aufrufe liefern dasselbe Ergebnis, abweichende Nutzdaten zum selben Schlüssel werden abgelehnt. Dafür fehlen im Basispfad noch Schlüsselübergabe und gespeicherter Verarbeitungszustand. Die Erweiterung bleibt deshalb ein Entwurf und blockiert M08 nicht.

## Fallback

Die vorhandenen Ergebnis-, Status- und Logauszüge erlauben die Trennung von Testebenen, Symptom, Evidenz und Ursache. Ohne eigenen Maven-/Pytest-Lauf, Compose-Stopp und erneuten Smoke-Test sind die ergänzte Testlücke, Fehlerreproduktion und Timeout-Wirkung nicht selbst verifiziert.