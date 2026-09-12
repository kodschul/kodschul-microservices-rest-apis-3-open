#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_DIR/.env.example"

compose() {
  docker compose --env-file "$ENV_FILE" --project-directory "$PROJECT_DIR" -f "$PROJECT_DIR/compose.yaml" "$@"
}

health=$(curl --fail --silent http://localhost:8000/health)
printf '%s' "$health" | grep -q '"status":"UP"'

created_file=$(mktemp)
response_file=$(mktemp)
trap 'rm -f "$created_file" "$response_file"' EXIT

created_status=$(curl --silent --output "$created_file" --write-out '%{http_code}' \
  --header 'Content-Type: application/json' \
  --data '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}' \
  http://localhost:8080/api/orders)
test "$created_status" = "201"
grep -q '"notificationStatus":"accepted"' "$created_file"

invalid_status=$(curl --silent --output "$response_file" --write-out '%{http_code}' \
  --header 'Content-Type: application/json' \
  --data '{"sku":"SKU-100","quantity":0,"recipient":"dev@example.test"}' \
  http://localhost:8080/api/orders)
test "$invalid_status" = "400"
grep -q '"code":"INVALID_ORDER"' "$response_file"

order_id=$(sed -n 's/.*"orderId":"\([^"]*\)".*/\1/p' "$created_file")
dispatch_status=$(curl --silent --output /dev/null --write-out '%{http_code}' --request POST \
  "http://localhost:8080/api/orders/$order_id/dispatch")
test "$dispatch_status" = "202"

event_seen=false
attempt=0
while [ "$attempt" -lt 20 ]; do
  curl --fail --silent http://localhost:8000/events > "$response_file"
  if grep -q "$order_id" "$response_file"; then
    event_seen=true
    break
  fi
  sleep 1
  attempt=$((attempt + 1))
done
test "$event_seen" = "true"

compose stop notification-service
failed_status=$(curl --silent --max-time 4 --output "$response_file" --write-out '%{http_code}' \
  --header 'Content-Type: application/json' \
  --data '{"sku":"SKU-200","quantity":1,"recipient":"dev@example.test"}' \
  http://localhost:8080/api/orders)
test "$failed_status" = "502"
grep -q '"code":"DOWNSTREAM_UNAVAILABLE"' "$response_file"
compose start notification-service

notification_ready=false
attempt=0
while [ "$attempt" -lt 20 ]; do
  if curl --fail --silent http://localhost:8000/health > /dev/null; then
    notification_ready=true
    break
  fi
  sleep 1
  attempt=$((attempt + 1))
done
test "$notification_ready" = "true"

echo "Smoke test passed: health=200 create=201 invalid=400 dispatch=202 event=consumed downstream=502"