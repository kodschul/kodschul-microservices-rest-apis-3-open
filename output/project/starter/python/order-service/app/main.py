"""Starterprojekt für den Order-Service (Python-Spur).

Enthält bewusst noch keine Order-Endpunkte; diese entstehen in Modul 2.
"""
from fastapi import FastAPI

app = FastAPI(title="Order Service", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    """Health-Check für Preflight und Orchestrierung."""
    return {"status": "UP"}
