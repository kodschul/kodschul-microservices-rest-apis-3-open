from fastapi.testclient import TestClient

from app.main import app, event_store


client = TestClient(app)


def setup_function() -> None:
    event_store.clear()


def test_health_is_up() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "UP"}


def test_accepts_notification() -> None:
    response = client.post(
        "/notifications",
        json={"order_id": "order-100", "recipient": "dev@example.test"},
    )

    assert response.status_code == 202
    assert response.json() == {
        "order_id": "order-100",
        "status": "accepted",
        "channel": "email",
    }


def test_accepts_maximum_order_id_length() -> None:
    response = client.post(
        "/notifications",
        json={"order_id": "x" * 40, "recipient": "+49123456789", "channel": "sms"},
    )

    assert response.status_code == 202


def test_rejects_unsupported_channel() -> None:
    response = client.post(
        "/notifications",
        json={"order_id": "order-100", "recipient": "dev@example.test", "channel": "fax"},
    )

    assert response.status_code == 422


def test_lists_consumed_events() -> None:
    event_store.add({"orderId": "order-100", "type": "OrderDispatched"})

    response = client.get("/events")

    assert response.status_code == 200
    assert response.json() == [{"orderId": "order-100", "type": "OrderDispatched"}]