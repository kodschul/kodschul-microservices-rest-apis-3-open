# Checkpoint E04: vertragstreue Order API

Dieser Checkpoint ist der Endstand von E04 und der Wiederherstellungs- oder Startpunkt vor E05. Der Order Service erstellt Bestellungen lokal und lehnt ungueltige Eingaben mit einer stabilen Fehlerantwort ab.

## Voraussetzungen

- Java 21
- Maven 3.9 oder neuer

## Tests ausfuehren

Im Verzeichnis `order-service`:

```powershell
mvn -B test
```

Die Tests pruefen die Anwendungslogik sowie die API mit gueltigen und ungueltigen Requests.

## Service bauen und starten

```powershell
mvn -B clean package
java -jar target/order-service-1.0.0.jar
```

Der Service verwendet Port `8080`. In einem zweiten Terminal lassen sich Health und API-Verhalten beobachten:

```powershell
curl.exe -i http://localhost:8080/actuator/health
curl.exe -i -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d '{"sku":"BOOK-42","quantity":2,"recipient":"dev@example.test"}'
curl.exe -i -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d '{"sku":"BOOK-42","quantity":0,"recipient":"dev@example.test"}'
```

Der gueltige Request liefert HTTP `201`, eine nicht leere UUID, `status: created` und `notificationStatus: pending`. Der ungueltige Request liefert HTTP `400` mit `code: INVALID_ORDER`.

Beenden Sie den Service mit `Ctrl+C`.

## API-Vertrag

Der vollstaendige OpenAPI-3.1-Vertrag liegt unter `contracts/order-api.yaml`. Request-, Response- und Fehlerschemas bilden dieselben Pflichtfelder und Validierungsgrenzen wie die Java-Implementierung ab.

## Container verwenden

Im Verzeichnis `order-service`:

```powershell
docker build -t order-service:e04 .
docker run --rm -p 8080:8080 order-service:e04
```

Beenden Sie den Container mit `Ctrl+C`. Das Image kann anschliessend mit `docker image rm order-service:e04` entfernt werden.

## Naechster Schritt

E05 verwendet diese stabile Order API als Ausgangspunkt fuer die Integration mit dem vorbereiteten Python-Zielservice.