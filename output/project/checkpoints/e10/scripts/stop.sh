#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_DIR/.env.example"

docker compose --env-file "$ENV_FILE" --project-directory "$PROJECT_DIR" -f "$PROJECT_DIR/compose.yaml" down --remove-orphans