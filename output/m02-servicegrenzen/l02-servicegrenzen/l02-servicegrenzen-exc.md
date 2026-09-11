# Übung M02: Servicegrenzen begründen

## Szenario und Ziel

Der laufende Order Service bündelt Bestellannahme, Bestandsbezug und Benachrichtigung. Das Team benötigt vor weiteren API-Änderungen eine nachvollziehbare Architekturentscheidung.

**Dauer:** 75 Minuten
**Zielartefakt:** Context Map mit Verantwortungen, Datenhoheit, Beziehungen und einem kurzen Entscheidungsprotokoll

## Voraussetzungen

- abgeschlossener M01-Stand
- bereitgestellter Quellcode des Order Service
- Context-Map- oder Diagrammvorlage
- Notizfläche für Kriterien und Alternativen

## Aufgabe 1: Kopplung im Ausgangspunkt markieren

1. Verfolgen Sie den Bestellablauf vom HTTP-Eingang bis zu seinen fachlichen Folgewirkungen.
2. Markieren Sie Stellen, an denen mehrere Verantwortungen, Datenbereiche oder Änderungsgründe zusammentreffen.
3. Ordnen Sie jede Beobachtung als fachliche oder technische Kopplung ein.

**Checkpoint:** Mindestens drei konkrete Kopplungsstellen sind mit ihrer Auswirkung dokumentiert.

## Aufgabe 2: Fähigkeiten und Datenhoheit ordnen

1. Benennen Sie die fachlichen Fähigkeiten im betrachteten Ablauf.
2. Ordnen Sie jeder Fähigkeit Regeln und veränderbare Daten zu.
3. Kennzeichnen Sie unklare oder konkurrierende Schreibverantwortung.

**Checkpoint:** Für jeden Kandidaten ist sichtbar, wer welche Daten ändern darf.

## Aufgabe 3: Context Map entwerfen

1. Zeichnen Sie die fachlichen Kontexte und ihre gerichteten Beziehungen.
2. Beschriften Sie jede Beziehung mit ausgetauschter Information oder Absicht.
3. Trennen Sie fachliche Grenzen von reinen Framework- oder Paketgrenzen.

**Checkpoint:** Die Map ist ohne Erläuterung des Quellcodes lesbar.

## Aufgabe 4: Architekturvarianten vergleichen

1. Vergleichen Sie einen modularen Monolithen mit Ihrer Servicezerlegung.
2. Bewerten Sie beide Varianten anhand von Verantwortung, Datenhoheit, Änderbarkeit und Betriebskosten.
3. Halten Sie mindestens einen Nachteil Ihrer bevorzugten Variante fest.

**Checkpoint:** Die Entscheidung folgt Kriterien und nicht der Anzahl möglicher Services.

## Aufgabe 5: Grenzen begründen und prüfen

1. Formulieren Sie für jede gewählte Grenze einen fachlichen und einen betrieblichen Grund.
2. Prüfen Sie, ob eine Grenze ohne gemeinsame Schreibzugriffe funktionieren kann.
3. Notieren Sie eine Annahme, deren Änderung zu einem anderen Zuschnitt führen würde.

**Checkpoint:** Jede Grenze besitzt Verantwortung, Datenhoheit, Änderungsgrund und benannte Kosten.

## Abschlusskriterien

- [ ] Die Context Map zeigt alle betrachteten Fähigkeiten und Beziehungen.
- [ ] Schreibverantwortung ist eindeutig oder als offenes Risiko markiert.
- [ ] Monolith und Microservices wurden mit denselben Kriterien verglichen.
- [ ] Die gewählten Grenzen sind nachvollziehbar begründet.

## Erweiterung

Untersuchen Sie, ob ein zunächst modularer Monolith dieselben fachlichen Grenzen erhalten könnte. Beschreiben Sie einen späteren Auslöser für eine Extraktion.

## Fallback

Falls der Quellcode nicht ausführbar ist, analysieren Sie die bereitgestellte Projektstruktur und den dokumentierten Request-Pfad. Damit entsteht eine Architekturentscheidung, aber keine Laufzeitevidenz zur Kopplung.