"""Starterprojekt für den Notification-Service (Python-Spur).

Enthält bewusst noch keinen RabbitMQ-Consumer; dieser entsteht in Modul 6.
"""
from fastapi import FastAPI

app = FastAPI(title="Notification Service", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    """Health-Check für Preflight und Orchestrierung."""
    return {"status": "UP"}
