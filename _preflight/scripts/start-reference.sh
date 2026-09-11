#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIR="$SCRIPT_DIR/../reference"

docker compose --project-directory "$PROJECT_DIR" -f "$PROJECT_DIR/compose.yaml" up --build --detach --wait