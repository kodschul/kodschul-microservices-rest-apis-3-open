from app.rabbit_consumer import RabbitConsumer
from app.store import EventStore


def test_failure_injection_is_disabled_by_default(monkeypatch) -> None:
    monkeypatch.delenv("RABBITMQ_FAIL_ONCE", raising=False)
    consumer = RabbitConsumer(EventStore())

    assert consumer._should_inject_failure() is False
    assert consumer._should_inject_failure() is False


def test_failure_injection_is_used_only_once(monkeypatch) -> None:
    monkeypatch.setenv("RABBITMQ_FAIL_ONCE", "true")
    consumer = RabbitConsumer(EventStore())

    assert consumer._should_inject_failure() is True
    assert consumer._should_inject_failure() is False