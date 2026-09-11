from contextlib import asynccontextmanager
import os
from typing import Iterator, Literal

from fastapi import FastAPI
from pydantic import BaseModel, Field

from app.rabbit_consumer import RabbitConsumer
from app.store import EventStore


class NotificationRequest(BaseModel):
    order_id: str = Field(min_length=1, max_length=40)
    recipient: str = Field(min_length=3, max_length=120)
    channel: Literal["email", "sms"] = "email"


class NotificationResponse(BaseModel):
    order_id: str
    status: Literal["accepted"]
    channel: Literal["email", "sms"]


event_store = EventStore()


@asynccontextmanager
async def lifespan(_: FastAPI) -> Iterator[None]:
    consumer = RabbitConsumer(event_store)
    if os.getenv("RABBITMQ_ENABLED", "false").lower() == "true":
        consumer.start()
    yield
    consumer.stop()


app = FastAPI(title="Notification Service", version="1.0.0", lifespan=lifespan)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "UP"}


@app.post("/notifications", response_model=NotificationResponse, status_code=202)
def create_notification(request: NotificationRequest) -> NotificationResponse:
    return NotificationResponse(
        order_id=request.order_id,
        status="accepted",
        channel=request.channel,
    )


@app.get("/events")
def list_events() -> list[dict[str, object]]:
    return event_store.all()