import json
from pathlib import Path

from app.main import app


CONTRACT = Path(__file__).parents[3] / "contracts" / "notification-api.json"


def test_runtime_api_contains_published_contract_operations() -> None:
    published = json.loads(CONTRACT.read_text(encoding="utf-8"))
    runtime = app.openapi()

    for path, path_item in published["paths"].items():
        assert path in runtime["paths"]
        for method, operation in path_item.items():
            assert method in runtime["paths"][path]
            for status in operation["responses"]:
                assert status in runtime["paths"][path][method]["responses"]


def test_notification_constraints_match_runtime_schema() -> None:
    published = json.loads(CONTRACT.read_text(encoding="utf-8"))
    runtime = app.openapi()
    expected = published["components"]["schemas"]["NotificationRequest"]["properties"]
    actual = runtime["components"]["schemas"]["NotificationRequest"]["properties"]

    assert actual["order_id"]["minLength"] == expected["order_id"]["minLength"]
    assert actual["order_id"]["maxLength"] == expected["order_id"]["maxLength"]
    assert actual["channel"]["enum"] == expected["channel"]["enum"]