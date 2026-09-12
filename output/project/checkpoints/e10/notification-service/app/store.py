from threading import Lock


class EventStore:
    def __init__(self) -> None:
        self._events: list[dict[str, object]] = []
        self._lock = Lock()

    def add(self, event: dict[str, object]) -> None:
        with self._lock:
            self._events.append(event)

    def all(self) -> list[dict[str, object]]:
        with self._lock:
            return [event.copy() for event in self._events]

    def clear(self) -> None:
        with self._lock:
            self._events.clear()