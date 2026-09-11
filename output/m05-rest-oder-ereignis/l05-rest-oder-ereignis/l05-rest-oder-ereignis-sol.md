# Lösung M05: REST oder Ereignis entscheiden und beobachten

## Szenario und Ziel

Die Bestellplattform behält REST für Interaktionen mit unmittelbarer Antwort bei. Der Versand wird als `OrderDispatched` über RabbitMQ entkoppelt und durch den Notification Service beobachtbar verarbeitet.

**Dauer Basispfad:** 120 Minuten, E07 45 Minuten und E06 75 Minuten
**Zielartefakt:** REST-/Messaging-Entscheidungsübersicht, ausführbarer Ereignisfluss und dokumentierter Redelivery-Befund

## Voraussetzungen und Starter

- abgeschlossener Java-Python-Checkpoint aus M04
- vorbereiteter RabbitMQ-Broker
- Publisher-, Queue- und Consumer-Gerüst
- Entscheidungsvorlage mit Kriterienfeldern
- API-Client und vorgesehene lokale Kursumgebung
- konfigurierte lokale Zugriffswerte, die nicht ausgegeben oder dokumentiert werden

## Aufgabe 1: Direkte Antwortbedarfe klassifizieren

| Interaktion | Sofortige Antwort | Folge bei Nichtverfügbarkeit |
| --- | --- | --- |
| Bestellung anlegen | ja, Identifier und Annahme | Auftraggeber kennt den Bestellstand nicht |
| Notification synchron anfordern | im bisherigen M04-Pfad ja | Bestellpfad endet mit Downstream-Fehler |
| Versandbenachrichtigung auslösen | nein, Versand ist bereits geschehen | Benachrichtigung darf später folgen |

**Checkpoint:** Der Versand benötigt keine Notification-Antwort innerhalb desselben HTTP-Aufrufs; die anderen Beispiele zeigen den fachlichen Grund für eine direkte Antwort.

## Aufgabe 2: Messaging-Alternativen bewerten

| Interaktion | Wahl | Kopplung | Konsistenz | Akzeptierter Nachteil |
| --- | --- | --- | --- | --- |
| Bestellung anlegen | REST | Aufrufer wartet auf Order Service | unmittelbarer Bestellstand | zeitliche Kopplung bleibt |
| Notification im M04-Pfad | REST | Order und Notification laufen gleichzeitig | Ergebnis steht in Order-Antwort | Downstream-Ausfall blockiert Erfolg |
| Versandbenachrichtigung | Messaging | Sender benötigt nur RabbitMQ | Notification-Sicht folgt verzögert | Redelivery und Duplikate sind möglich |

**Checkpoint:** Jede Wahl nennt Kopplung und Konsistenz; Messaging wird nicht pauschal als überlegen bewertet.

## Aufgabe 3: Bestellereignis veröffentlichen

Der Publisher erzeugt die Ereignisfelder und sendet an die dauerhafte Queue:

```java
String event = objectMapper.writeValueAsString(Map.of(
        "orderId", orderId,
        "type", "OrderDispatched",
        "occurredAt", Instant.now().toString()));
rabbitTemplate.convertAndSend("order.events", event);
```

Die Queue-Konfiguration lautet:

```java
@Bean
Queue orderEventsQueue() {
    return new Queue("order.events", true);
}
```

Wechseln Sie in den bereitgestellten Referenzprojektordner und starten Sie die Landschaft:

```powershell
docker compose up --build --detach --wait
```

Der Dispatch-Aufruf erfolgt nach dem Anlegen einer gültigen Bestellung. Seine erwartete Antwort ist HTTP `202` ohne Response-Body. Das bestätigt die Annahme des Befehls, nicht die Consumer-Verarbeitung.

**Checkpoint:** `OrderDispatched` wird mit `orderId` und Zeitstempel an `order.events` veröffentlicht.

## Aufgabe 4: Ereignis konsumieren

Der Consumer deklariert dieselbe dauerhafte Queue, speichert das gelesene JSON und bestätigt erst danach:

```python
channel.queue_declare(queue="order.events", durable=True)
event = json.loads(body)
event_store.add(event)
channel.basic_ack(method.delivery_tag)
```

Der bereitgestellte Smoke-Test führt Erzeugung, Dispatch und begrenztes Polling der Ereignisliste aus:

```powershell
& ..\scripts\smoke-reference.ps1
```

Erwartet wird `Smoke test passed`. Die Ereignisliste enthält für die erzeugte `orderId` den Typ `OrderDispatched`.

**Checkpoint:** Producer und Consumer beziehen sich auf dieselbe Queue und dasselbe Bestellereignis.

## Aufgabe 5: Positiven und verzögerten Pfad vergleichen

Für den positiven Pfad lautet die Reihenfolge: Bestellung anlegen, Dispatch mit `202` annehmen, Ereignis publizieren, konsumieren und über die Ereignisliste sichtbar machen.

Für den verzögerten Pfad:

```powershell
docker compose stop notification-service
```

Lösen Sie während des Stopps einen weiteren Dispatch aus. Starten Sie den Consumer danach wieder:

```powershell
docker compose start notification-service
```

Die HTTP-Annahme geschieht vor dem Consumer-Ergebnis. Nach Wiederherstellung wird die gepufferte Nachricht verarbeitet. Genau dieses Zeitfenster ist Eventual Consistency.

**Checkpoint:** Der verzögerte Pfad trennt erfolgreiche Veröffentlichung von später Consumer-Verarbeitung.

## Aufgabe 6: Verarbeitungsfehler und Redelivery analysieren

In der vorbereiteten Fehlervariante tritt die Störung nach Empfang und vor `basic_ack` auf. Solange keine Bestätigung gesendet wurde, ist die Nachricht nicht erfolgreich abgeschlossen. Beim Abbruch des Kanals stellt RabbitMQ sie erneut zu.

Das Diagnoseprotokoll hält fest:

| Beobachtung | Befund |
| --- | --- |
| Consumer-Meldung | Verarbeitung scheitert vor der Bestätigung |
| Queue-Zustand | Nachricht bleibt unbestätigt oder wird erneut bereitgestellt |
| Wiederherstellung | Consumer erhält dieselbe fachliche Nachricht erneut |
| Endzustand | Ereignis ist verarbeitet; mögliche Doppelwirkung muss geprüft werden |

Die Referenz bestätigt erst nach `event_store.add(event)`. Der Kursfehler zeigt damit die richtige Reihenfolge, beweist aber keine Exactly-once-Verarbeitung. Ein produktiver Consumer benötigt eine idempotente Wirkung oder eine Duplikaterkennung.

**Checkpoint:** Ursache, fehlendes Acknowledgement, erneute Zustellung und Duplikatrisiko sind getrennt dokumentiert.

## Aufgabe 7: Trade-off-Entscheidung abschließen

**REST-Entscheidung:** Das Anlegen einer Bestellung bleibt synchron, weil der Aufrufer unmittelbar wissen muss, ob die Eingabe angenommen wurde und welchen Identifier die Bestellung besitzt. Nachteil ist die zeitliche Kopplung an den Order Service.

**Messaging-Entscheidung:** `OrderDispatched` wird asynchron verteilt, weil die Benachrichtigung den bereits erfolgten Versand nicht blockieren soll. Verzögerte Konsistenz ist akzeptiert; als Gegenleistung sind Redelivery, Duplikate und ausbleibende Verarbeitung zu kontrollieren.

**Checkpoint:** Beide Entscheidungen nennen fachlichen Antwortbedarf, Kopplung, Konsistenz und Fehlerfolge.

## Abschlusskriterien

- [x] E07 ist als Kriterien- und Trade-off-Übersicht abgeschlossen.
- [x] Das Versandereignis wird veröffentlicht und konsumiert.
- [x] Das Ergebnis ist derselben Bestellung zugeordnet.
- [x] Verzögerung, Fehler und Redelivery sind nachvollziehbar dokumentiert.
- [x] Konfigurierte lokale Zugriffswerte werden nicht ausgegeben.

## Erweiterung

Für eine Lagerreservierung sind beide Formen vertretbar. REST passt, wenn die Bestellung ohne sofort bestätigte Reservierung nicht angenommen werden darf. Messaging passt, wenn ein Zwischenstatus zulässig ist und Kompensation sowie spätere Ablehnung fachlich vorgesehen sind. Das Qualitätsziel „keine Annahme ohne bestätigten Bestand“ kippt die Entscheidung zu REST.

## Fallback

Die bereitgestellten Ereignis- und Fehlerbeobachtungen ermöglichen eine vollständige Kriterienanalyse. Ohne lokal ausgeführten Broker sind Veröffentlichung, Queueing und Redelivery jedoch nicht selbst verifiziert; der technische Checkpoint bleibt entsprechend offen.