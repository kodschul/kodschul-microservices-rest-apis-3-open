# Lösung (Java-Spur): Image bauen und einzeln starten

## Aufgabe 1: Images bauen

```bash
docker build -t order-service:0.1.0 ./order-service
docker build -t notification-service:0.1.0 ./notification-service
docker images | grep -E "order-service|notification-service"
```

Erwartung: Beide Images sind deutlich kleiner als ein Image, das auf dem vollen Maven/JDK-Basis-Image basieren würde (typischerweise unter 300 MB dank `eclipse-temurin:17-jre-alpine`).

## Aufgabe 2: Order-Service starten

```bash
docker run --rm -p 8081:8081 \
  --add-host=host.docker.internal:host-gateway \
  -e SPRING_RABBITMQ_HOST=host.docker.internal \
  order-service:0.1.0
```

```bash
curl http://localhost:8081/actuator/health
# {"status":"UP"}
```

## Aufgabe 3: Notification-Service starten

```bash
docker run --rm -p 8091:8091 \
  --add-host=host.docker.internal:host-gateway \
  -e SPRING_RABBITMQ_HOST=host.docker.internal \
  notification-service:0.1.0
```

```bash
curl http://localhost:8091/actuator/health
# {"status":"UP"}
```

## Aufgabe 4: End-to-End im Container

```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Mara Beispiel","itemName":"Kaffeemaschine","quantity":2}'
```

Die Container-Logs des Notification-Service (`docker logs <container-id>`) zeigen dieselbe Benachrichtigungszeile wie in Modul 6.
