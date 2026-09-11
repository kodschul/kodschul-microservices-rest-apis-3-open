$ErrorActionPreference = "Stop"
$project = Join-Path $PSScriptRoot "../reference"

docker compose --project-directory $project -f (Join-Path $project "compose.yaml") up --build --detach --wait