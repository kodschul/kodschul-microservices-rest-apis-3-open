$ErrorActionPreference = "Stop"
$project = Split-Path -Parent $PSScriptRoot
$environment = Join-Path $project ".env.example"

docker compose --env-file $environment --project-directory $project -f (Join-Path $project "compose.yaml") up --build --detach --wait
if ($LASTEXITCODE -ne 0) { throw "Docker Compose start failed" }