# Starter: Order Service und Notification Service

Dieser Stand ist der Ausgangspunkt für M01. Der Java-Service startet und liefert Health-Informationen. Die Bestellerstellung ist absichtlich noch nicht implementiert. Der vorbereitete FastAPI-Service kann unabhängig davon gestartet und geprüft werden.

## Versionen und Ports

| Komponente | Version oder Port |
| --- | --- |
| Java | 21 |
| Spring Boot | 4.1.1 |
| Maven | 3.9.16 |
| Python | 3.12.14 |
| FastAPI | 0.141.1 |
| Uvicorn | 0.52.4 |
| Order Service | `8080` |
| Notification Service | `8000` |

## Java nativ bauen, testen und starten

Im Verzeichnis `order-service`:

```powershell
mvn -B clean package
mvn -B test
mvn spring-boot:run
```

Der Testlauf findet zwei vorbereitete, deaktivierte Übungstests. Der Build bleibt deshalb grün. Der Service läuft, bis der Prozess mit `Ctrl+C` beendet wird.

Health prüfen:

```powershell
curl.exe -i http://localhost:8080/actuator/health
```

Erwartbar sind HTTP `200` und ein JSON-Dokument mit `"status":"UP"`.

Aktuelles Bestellverhalten prüfen:

```powershell
curl.exe -i -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d '{"sku":"BOOK-42","quantity":2,"recipient":"dev@example.test"}'
```

Der syntaktisch gültige Request liefert absichtlich HTTP `501` mit dem Code `EXERCISE_INCOMPLETE`. Das ist der Startpunkt für die Änderung in E01.

## FastAPI nativ starten und prüfen

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

`GET /health` liefert HTTP `200` mit `{"status":"UP"}`. `POST /notifications` liefert HTTP `202`; die Antwort enthält dieselbe `order_id`, den Status `accepted` und den gewählten Kanal. Beenden Sie Uvicorn mit `Ctrl+C`. Die lokale Umgebung kann anschließend mit `Remove-Item -Recurse -Force .venv` entfernt werden.

## Container bauen, starten und prüfen

Im Verzeichnis dieses Starters:

```powershell
Copy-Item .env.example .env
docker compose build
docker compose up -d
docker compose ps
curl.exe -i http://localhost:8080/actuator/health
curl.exe -i http://localhost:8000/health
```

Der Standardstart umfasst nur Order Service und Notification Service. Der vorbereitete RabbitMQ-Baustein für ein späteres Modul wird ausschließlich mit `docker compose --profile messaging up -d` aktiviert und ist für den Health-Status des Order Service nicht erforderlich.

Container und Netzwerk reproduzierbar entfernen:

```powershell
docker compose down --remove-orphans
```

Die Compose-Konfiguration verwendet keine persistenten Volumes.