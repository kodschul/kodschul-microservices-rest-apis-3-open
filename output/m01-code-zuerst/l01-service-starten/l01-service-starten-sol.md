# Lösung M01: Service starten und verändern

## Szenario und Ziel

Die Lösung zeigt einen reproduzierbaren Start und die kleinste belastbare Bestellerstellung. Die spätere Python-Integration bleibt in M01 noch außerhalb des Pflichtumfangs.

## Voraussetzungen

- bereitgestelltes Starterprojekt
- Java 21 oder kompatible freigegebene Laufzeit
- Maven 3.9.x oder Docker Compose v2
- API-Client oder `curl`
- freie Ports `8080` und `8000`

## Aufgabe 1: Projekt orientieren

| Stelle | Aufgabe |
| --- | --- |
| `pom.xml` | definiert Java 21, Spring Boot und den Maven-Build |
| `OrderServiceApplication` | startet den Spring-Kontext |
| `OrderController` | bildet HTTP auf Anwendungslogik ab |
| `OrderApplicationService` | verarbeitet die Bestellung |
| `OrderApplicationServiceTest` | beschreibt erwartetes Fachverhalten |

Der Request läuft vom Controller über `create(request)` in den Application Service.

## Aufgabe 2: Build und Tests ausführen

```powershell
mvn -B test
```

Erwartet wird `BUILD SUCCESS`. Im unveränderten Starter können als Übungsmarkierung deaktivierte Tests erscheinen; nach Aufgabe 4 muss der aktivierte Erfolgstest grün sein.

Warnungen, etwa zu dynamisch geladenen Test-Agenten, sind getrennt von Compilerfehlern oder fehlgeschlagenen Tests zu bewerten.

## Aufgabe 3: Service starten und API beobachten

```powershell
mvn spring-boot:run
```

Healthcheck:

```text
GET http://localhost:8080/actuator/health
```

Der Health-Endpunkt liefert `200`. Die anfangs offene Bestellerstellung darf `501` mit `EXERCISE_INCOMPLETE` liefern. Dieser Zustand beweist, dass Transport und Fehlerabbildung funktionieren, die Fachlogik aber noch fehlt.

## Aufgabe 4: Kleine Verhaltensänderung absichern

Eine minimale Implementierung erzeugt eine ID und gibt den Bestellstatus zurück:

```java
public OrderResponse create(OrderRequest request) {
    String orderId = UUID.randomUUID().toString();
    return new OrderResponse(orderId, "created", "pending");
}
```

Der aktivierte Test prüft mindestens:

```java
OrderResponse response = service.create(
        new OrderRequest("SKU-100", 2, "dev@example.test"));

assertThat(response.orderId()).isNotBlank();
assertThat(response.status()).isEqualTo("created");
assertThat(response.notificationStatus()).isEqualTo("pending");
```

Nach erneutem `mvn -B test` liefert der API-Aufruf `201` und einen nicht leeren `orderId`-Wert. Die Notification bleibt bewusst `pending`, weil die Service-Integration erst in M04 erfolgt.

## Aufgabe 5: Ergebnis sichern

Das Änderungsprotokoll enthält:

- ausgeführten Build- und Testbefehl,
- Anzahl bestandener Tests,
- beobachtete Änderung von `501` zu `201`,
- geänderte Fachlogik und Testdatei.

Ein lokaler Commit kann beispielsweise die Absicht `Implement basic order creation` dokumentieren.

## Abschlusskriterien

- [x] Service ist erreichbar.
- [x] Build und Test sind reproduzierbar.
- [x] Die kleine Änderung ist durch einen Test abgesichert.
- [x] Ausgangs- und Endverhalten sind dokumentiert.

## Erweiterung

Ein zusätzlicher Test übergibt Menge `0` und erwartet eine Ablehnung. Die genaue öffentliche Fehlerform wird erst zusammen mit dem REST-Vertrag in M03 festgelegt.

## Fallback

Der Container-Build ist ein gültiger Build-Nachweis, wenn er selbst ausgeführt wurde. Ohne eigenen ausführbaren Nachweis bleibt der Checkpoint offen.