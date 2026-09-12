# E09-Variante: fehlerhafte Service-Adresse

Diese Variante startet den E10-Stand mit einer absichtlich nicht erreichbaren Service-Adresse. Ziel ist, die Ursache aus gerenderter Compose-Konfiguration, Service-Status und Logs einzugrenzen und den Befund im Diagnoseprotokoll festzuhalten.

Fuehre die Befehle im Verzeichnis `output/project` aus. Die Variante verwendet die lokale E10-Umgebungsdatei und enthaelt keine eigenen Zugangsdaten.

## Starten

```powershell
$Base = "checkpoints/e10/compose.yaml"
$Override = "variants/e09-broken-service-name/compose.override.yaml"
$EnvFile = "checkpoints/e10/.env.example"
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override up --build --detach --wait
```

## Fehler pruefen

```powershell
curl.exe -i -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d '{"sku":"BOOK-42","quantity":1,"recipient":"dev@example.test"}'
```

Der gueltige Request kann mit HTTP `502` und einem begrenzten Downstream-Fehler enden. Dieser Status beschreibt das Symptom, aber noch nicht seine Ursache.

## Diagnostizieren

```powershell
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override config
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override ps
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override logs order-service notification-service
```

Pruefe, welche Adresse der Order Service tatsaechlich verwendet, ob die beteiligten Services laufen und welche Verbindungsursache die Logs nennen. Dokumentiere Evidenz, Ursache und eine begruendete Korrektur in `templates/e09-diagnosis-log.md`.

## Basisstand wiederherstellen

```powershell
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base -f $Override down --remove-orphans
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base up --detach --wait
curl.exe -i -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d '{"sku":"BOOK-42","quantity":1,"recipient":"dev@example.test"}'
```

Vergleiche das Verhalten mit deiner Diagnose, ohne die Basisdatei waehrend der Fehlersuche zu veraendern.

## Aufraeumen

```powershell
docker compose --env-file $EnvFile --project-directory checkpoints/e10 -f $Base down --remove-orphans
```