#!/usr/bin/env sh
set -eu

SKIP_MESSAGING=${SKIP_MESSAGING:-false}

health=$(curl --fail --silent http://localhost:8000/health)
printf '%s' "$health" | grep -q '"status":"UP"'

created_file=$(mktemp)
events_file=$(mktemp)
trap 'rm -f "$created_file" "$events_file"' EXIT

created_status=$(curl --silent --output "$created_file" --write-out '%{http_code}' \
  --header 'Content-Type: application/json' \
  --data '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}' \
  http://localhost:8080/api/orders)
test "$created_status" = "201"
grep -q '"notificationStatus":"accepted"' "$created_file"

invalid_status=$(curl --silent --output "$events_file" --write-out '%{http_code}' \
  --header 'Content-Type: application/json' \
  --data '{"sku":"SKU-100","quantity":0,"recipient":"dev@example.test"}' \
  http://localhost:8080/api/orders)
test "$invalid_status" = "400"
grep -q '"code":"INVALID_ORDER"' "$events_file"

if [ "$SKIP_MESSAGING" != "true" ]; then
  order_id=$(sed -n 's/.*"orderId":"\([^"]*\)".*/\1/p' "$created_file")
  dispatch_status=$(curl --silent --output /dev/null --write-out '%{http_code}' \
    --request POST "http://localhost:8080/api/orders/$order_id/dispatch")
  test "$dispatch_status" = "202"

  event_seen=false
  attempt=0
  while [ "$attempt" -lt 20 ]; do
    curl --fail --silent http://localhost:8000/events > "$events_file"
    if grep -q "$order_id" "$events_file"; then
      event_seen=true
      break
    fi
    sleep 1
    attempt=$((attempt + 1))
  done
  test "$event_seen" = "true"
fi

echo "Smoke test passed"