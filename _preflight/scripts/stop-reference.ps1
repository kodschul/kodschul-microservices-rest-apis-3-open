$ErrorActionPreference = "Stop"
$project = Join-Path $PSScriptRoot "../reference"

docker compose --project-directory $project -f (Join-Path $project "compose.yaml") down --remove-orphans