from typing import Literal

from fastapi import FastAPI
from pydantic import BaseModel, Field


class NotificationRequest(BaseModel):
    order_id: str = Field(min_length=1, max_length=40)
    recipient: str = Field(min_length=3, max_length=120)
    channel: Literal["email", "sms"] = "email"


class NotificationResponse(BaseModel):
    order_id: str
    status: Literal["accepted"]
    channel: Literal["email", "sms"]


app = FastAPI(title="Notification Service", version="1.0.0")


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