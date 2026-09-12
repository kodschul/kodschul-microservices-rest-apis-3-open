# Checkpoint E01: lokale Bestellerstellung

Dieser Checkpoint ist der geprüfte Endstand von E01 und der Wiederherstellungs- oder Startpunkt für M02. Der Order Service erstellt Bestellungen lokal. Service-Integration und Messaging sind noch nicht Bestandteil dieses Stands. Der Notification Service ist als vorbereiteter, eigenständig ausführbarer Zielservice enthalten.

## Erwartbares Verhalten

- `GET /actuator/health` am Order Service liefert HTTP `200` und `"status":"UP"`.
- Ein gültiges `POST /api/orders` liefert HTTP `201`.
- Die Antwort enthält eine neue UUID als `orderId`, `status` mit dem Wert `created` und `notificationStatus` mit dem Wert `pending`.
- Die Dispatch-Operation ist in diesem Checkpoint nicht vorhanden.
- `GET /health` am Notification Service liefert HTTP `200`.
- `POST /notifications` am Notification Service liefert HTTP `202` mit dem Status `accepted`.

## Java nativ prüfen und starten

Im Verzeichnis `order-service`:

```powershell
mvn -B clean package
mvn -B test
mvn spring-boot:run
```

Der fokussierte Test `createsAnOrder` prüft UUID, `created` und `pending`. Health und Bestellerstellung lassen sich in einem zweiten Terminal beobachten:

```powershell
curl.exe -i http://localhost:8080/actuator/health
curl.exe -i -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d '{"sku":"BOOK-42","quantity":2,"recipient":"dev@example.test"}'
```

Beenden Sie den Service mit `Ctrl+C`.

## FastAPI nativ prüfen und starten

Im Verzeichnis `notification-service`:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m uvicorn app.main:app --host 0.0.0.0 --port 8000
```

In einem zweiten Terminal:

```powershell
curl.exe -i http://localhost:8000/health
curl.exe -i -X POST http://localhost:8000/notifications -H "Content-Type: application/json" -d '{"order_id":"demo-order","recipient":"dev@example.test","channel":"email"}'
```

Beenden Sie Uvicorn mit `Ctrl+C`. Entfernen Sie die lokale Umgebung anschließend bei Bedarf mit `Remove-Item -Recurse -Force .venv`.

## Gemeinsam mit Compose starten

Im Verzeichnis dieses Checkpoints:

```powershell
Copy-Item .env.example .env
docker compose build
docker compose up -d
docker compose ps
curl.exe -i http://localhost:8080/actuator/health
curl.exe -i http://localhost:8000/health
docker compose down --remove-orphans
```

Compose startet nur die beiden Services dieses Checkpoints. Es sind keine persistenten Volumes vorgesehen.