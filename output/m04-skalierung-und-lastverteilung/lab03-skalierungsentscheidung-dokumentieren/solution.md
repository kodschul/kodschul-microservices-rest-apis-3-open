# Lösung: Skalierungsentscheidung dokumentieren

## Beispiel-Entscheidungsdokument

**Order-Service**

- Lastmuster: synchrone Kundenanfragen, tageszeitabhängig schwankend mit erkennbaren Spitzen (z. B. Aktionstage).
- Gewählte Option: Feste Instanzgruppe mit Autoscaling-Regel (CPU- und Anfragenbasiert).
- Begründung: Der Service muss Anfragen mit niedriger Latenz beantworten; Serverless-Kaltstarts wären hier störend, während Autoscaling schwankende Last automatisch abfängt.
- Risiko: Autoscaling reagiert mit Verzögerung (typisch einige Sekunden bis Minuten); kurzfristige Extremspitzen können trotzdem Warteschlangen erzeugen.

**Notification-Service**

- Lastmuster: asynchrone, ereignisgetriebene Verarbeitung (reagiert auf RabbitMQ-Nachrichten), keine direkten Nutzeranfragen.
- Gewählte Option: Serverless-Funktion, die durch neue Nachrichten in der Warteschlange ausgelöst wird.
- Begründung: Die Aufgabe ist kurz, ereignisgetrieben und muss nicht dauerhaft laufen; Serverless spart Kosten in lastarmen Phasen.
- Risiko: Kaltstartzeit bei seltener Nutzung kann die Benachrichtigung leicht verzögern; das ist hier akzeptabel, da Benachrichtigungen nicht in Echtzeit-Kritikalität liegen (siehe Modul 5, asynchrone Kommunikation).

Alternative, ebenso vertretbare Kombinationen sind zulässig (z. B. beide Services über eine gemeinsame Container-Orchestrierung), solange Lastmuster, Option und mindestens ein Risiko schlüssig zusammenpassen.

