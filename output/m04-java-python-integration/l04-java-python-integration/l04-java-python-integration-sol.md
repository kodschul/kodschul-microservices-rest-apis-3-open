# Lösung M04: FastAPI aus Java integrieren

## Szenario und Ziel

Die Lösung verwendet den vorbereiteten FastAPI-Service unverändert. Ein Java-Adapter kapselt JSON, HTTP und Transportfehler für die Order-Anwendungslogik.

**Dauer Basispfad:** 45 Minuten, davon 25 Minuten an Tag 1 und 20 Minuten an Tag 2
**Zielartefakt:** funktionierende Java-Python-Interaktion mit dokumentiertem Erfolgs- und Downstream-Fehlerfall

## Voraussetzungen

- abgeschlossener M03-Vertrag und funktionsfähiger Java-Erfolgsendpunkt
- vorbereiteter FastAPI-Service
- Java-Clientgerüst oder markierte Adapterstelle
- API-Client und freie Kursports
- keine Python-Vorkenntnisse für den Basispfad

## Aufgabe 1: FastAPI-Vertrag beobachten

Starten Sie den bereitgestellten Notification Service und prüfen Sie:

```powershell
curl.exe http://localhost:8000/health
```

Erwartet werden HTTP `200` und `{"status":"UP"}`. `POST /notifications` erwartet `order_id` und `recipient`; `channel` ist optional und verwendet standardmäßig `email`. Eine angenommene Anfrage liefert HTTP `202` mit `order_id`, `status: accepted` und `channel`.

**Checkpoint:** Health, Operation sowie Request- und Response-Felder stimmen mit dem veröffentlichten Vertrag überein.

## Aufgabe 2: Java-Adapter ergänzen

```java
@Component
public class NotificationClient {
    private final RestClient restClient;

    public NotificationClient(@Value("${notification.base-url}") String baseUrl) {
        this.restClient = RestClient.builder().baseUrl(baseUrl).build();
    }

    public String notifyOrder(String orderId, String recipient) {
        try {
            NotificationResponse response = restClient.post()
                    .uri("/notifications")
                    .body(new NotificationRequest(orderId, recipient, "email"))
                    .retrieve()
                    .body(NotificationResponse.class);
            if (response == null) {
                throw new DownstreamServiceException("Notification service returned no body");
            }
            return response.status();
        } catch (RestClientException exception) {
            throw new DownstreamServiceException("Notification service is unavailable", exception);
        }
    }

    private record NotificationRequest(String order_id, String recipient, String channel) {}
    private record NotificationResponse(String order_id, String status, String channel) {}
}
```

`notification.base-url` stammt aus der Laufzeitkonfiguration. Die Adapter-Records bilden die JSON-Feldnamen explizit ab.

**Checkpoint:** HTTP, Konfiguration und JSON-Abbildung sind im Adapter gekapselt.

## Aufgabe 3: Erfolgsaufruf verbinden

```java
public OrderResponse create(OrderRequest request) {
    String orderId = UUID.randomUUID().toString();
    String notificationStatus = notificationClient.notifyOrder(orderId, request.recipient());
    return new OrderResponse(orderId, "created", notificationStatus);
}
```

Der Unit-Test konfiguriert den Client als Mock mit Rückgabe `accepted` und prüft eine nicht leere ID, `status: created` sowie `notificationStatus: accepted`. Dadurch bleibt der Test der Fachlogik unabhängig vom Netzwerk.

**Checkpoint:** Die Anwendungslogik verwendet nur die Adaptermethode und kennt keine HTTP-Details.

## Aufgabe 4: Ende-zu-Ende-Erfolg prüfen

```powershell
curl.exe --request POST http://localhost:8080/api/orders `
  --header "Content-Type: application/json" `
  --data '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}'
```

Erwartet werden HTTP `201`, eine nicht leere `orderId`, `status: created` und `notificationStatus: accepted`. Dieses Ergebnis wurde für den bereitgestellten Referenzstand nativ und im vollständigen Compose-Lauf geprüft.

**Checkpoint:** Die Antwort belegt den Pfad vom Java-Endpunkt über FastAPI zurück zum ursprünglichen Client.

## Aufgabe 5: Downstream-Ausfall abbilden

Die anwendungsbezogene Ausnahme kapselt den Transportfehler:

```java
public class DownstreamServiceException extends RuntimeException {
    public DownstreamServiceException(String message, Throwable cause) {
        super(message, cause);
    }

    public DownstreamServiceException(String message) {
        super(message);
    }
}
```

Die zentrale Fehlerbehandlung liefert den öffentlichen Vertrag:

```java
@ExceptionHandler(DownstreamServiceException.class)
public ResponseEntity<Map<String, String>> downstreamUnavailable(
        DownstreamServiceException exception) {
    return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
            .body(Map.of("code", "DOWNSTREAM_UNAVAILABLE", "message", exception.getMessage()));
}
```

Nach kontrolliertem Stoppen des Notification Service liefert derselbe Order-Aufruf HTTP `502` mit `code: DOWNSTREAM_UNAVAILABLE`.

**Checkpoint:** Die Antwort enthält einen stabilen Code und keine Stacktraces oder Bibliotheksdetails.

## Aufgabe 6: Wiederherstellung prüfen

Starten Sie den Notification Service erneut und wiederholen Sie den Aufruf aus Aufgabe 4. Ohne Änderung am Java-Code wird wieder HTTP `201` mit `notificationStatus: accepted` erwartet.

Der Vergleich zeigt die zeitliche Kopplung: Während der Downstream-Service fehlt, kann der synchrone Bestellpfad nicht erfolgreich enden. Die konfigurierbare Adresse ermöglicht Wiederherstellung ohne Codeänderung.

**Checkpoint:** Erfolg, `502`-Ausfall und erneuter Erfolg sind als drei Beobachtungen festgehalten.

## Abschlusskriterien

- [x] FastAPI wurde ohne Python-Änderung als vorbereiteter Service genutzt.
- [x] Java bildet Request und Response explizit auf den Vertrag ab.
- [x] Der Ende-zu-Ende-Erfolgsfall ist reproduzierbar.
- [x] Downstream-Ausfall und Wiederherstellung sind dokumentiert.
- [x] Interne Transportfehler gelangen nicht in die öffentliche API.

## Erweiterung

**E05X:** Eine mögliche Änderung setzt den Standardkanal in Python und im veröffentlichten Schema gemeinsam auf `sms`. Der API-Test ohne expliziten Kanal erwartet danach `sms`; Tests mit explizitem `email` und `sms` bleiben erhalten. Anschließend werden Python-Tests und Vertragsabgleich erneut ausgeführt. Diese Variante ist optional und ändert keinen späteren Pflichtcheckpoint.

## Fallback

Der vorbereitete Container benötigt keine lokale Python-Entwicklung. Sind weder Laufzeit noch Container verfügbar, können Request, Response und Logs geprüft werden; die eigene Java-Implementierung gilt damit jedoch nicht als Ende zu Ende ausgeführt.