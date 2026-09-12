# E06-Variante: einmalige Consumer-Stoerung

Diese Variante aktiviert im Notification Service einen absichtlich einmaligen Verarbeitungsfehler. Die erste gueltige RabbitMQ-Nachricht wird vor dem Speichern mit `requeue=true` abgelehnt. Bei der erneuten Zustellung verarbeitet und bestaetigt derselbe Consumer die Nachricht.

Fuehre die Befehle im Verzeichnis `output/project` aus. Die Basis-Konfiguration und die lokalen Beispielwerte bleiben im E10-Checkpoint; die Variante ueberschreibt nur den Fehler-Schalter.

## Starten

```powershell
$Base = "checkpoints/e10/compose.yaml"
$Override = "variants/e06-consumer-failure/compose.override.yaml"
$EnvFile = "checkpoints/e10/.env.example"
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override up --build --detach --wait
```

## Ereignis ausloesen

```powershell
$order = Invoke-RestMethod -Method Post -Uri "http://localhost:8080/api/orders" -ContentType "application/json" -Body '{"sku":"BOOK-42","quantity":1,"recipient":"dev@example.test"}'
Invoke-RestMethod -Method Post -Uri "http://localhost:8080/api/orders/$($order.orderId)/dispatch"
```

## Beobachten und pruefen

```powershell
$logs = docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override logs notification-service
$logs | Select-String "Injected one-time consumer failure"
($logs | Select-String "Injected one-time consumer failure").Count
Invoke-RestMethod -Uri "http://localhost:8000/events" | ConvertTo-Json -Depth 5
```

Erwartet werden genau eine Warnung und danach ein sichtbares Ereignis mit der zuvor ausgegebenen `orderId`. Falls die erneute Zustellung noch nicht sichtbar ist, rufe `/events` nach einem kurzen Moment erneut ab.

Die Stoerung ist eine lokale, absichtlich eingebaute Demonstration. Sie simuliert weder einen Prozessabsturz noch Netzwerk-, Broker- oder Persistenzfehler und ersetzt keine produktive Retry- oder Dead-Letter-Strategie.

## Aufraeumen

```powershell
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override down --remove-orphans
```