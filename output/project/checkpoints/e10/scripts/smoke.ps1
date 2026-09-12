$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Net.Http
$project = Split-Path -Parent $PSScriptRoot
$environment = Join-Path $project ".env.example"
$compose = @("compose", "--env-file", $environment, "--project-directory", $project, "-f", (Join-Path $project "compose.yaml"))
$client = [System.Net.Http.HttpClient]::new()
$client.Timeout = [TimeSpan]::FromSeconds(4)

function Send-JsonRequest {
    param([string]$Method, [string]$Url, [string]$Body = "")
    $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::new($Method), $Url)
    if ($Body) {
        $request.Content = [System.Net.Http.StringContent]::new($Body, [System.Text.Encoding]::UTF8, "application/json")
    }
    $response = $client.SendAsync($request).GetAwaiter().GetResult()
    $content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    return @{ Status = [int]$response.StatusCode; Body = $content }
}

try {
    $health = Send-JsonRequest GET "http://localhost:8000/health"
    if ($health.Status -ne 200 -or $health.Body -notmatch '"status":"UP"') { throw "Notification health check failed" }

    $created = Send-JsonRequest POST "http://localhost:8080/api/orders" '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}'
    if ($created.Status -ne 201 -or $created.Body -notmatch '"notificationStatus":"accepted"') { throw "Positive REST check failed" }

    $invalid = Send-JsonRequest POST "http://localhost:8080/api/orders" '{"sku":"SKU-100","quantity":0,"recipient":"dev@example.test"}'
    if ($invalid.Status -ne 400 -or $invalid.Body -notmatch '"code":"INVALID_ORDER"') { throw "Boundary check failed" }

    $orderId = ($created.Body | ConvertFrom-Json).orderId
    $dispatched = Send-JsonRequest POST "http://localhost:8080/api/orders/$orderId/dispatch"
    if ($dispatched.Status -ne 202) { throw "Dispatch check failed" }

    $eventSeen = $false
    for ($attempt = 0; $attempt -lt 20; $attempt++) {
        $events = Send-JsonRequest GET "http://localhost:8000/events"
        if ($events.Status -eq 200 -and $events.Body -match [regex]::Escape($orderId)) {
            $eventSeen = $true
            break
        }
        Start-Sleep -Milliseconds 250
    }
    if (-not $eventSeen) { throw "RabbitMQ event was not consumed" }

    & docker @compose stop notification-service
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $failed = Send-JsonRequest POST "http://localhost:8080/api/orders" '{"sku":"SKU-200","quantity":1,"recipient":"dev@example.test"}'
    $timer.Stop()
    if ($failed.Status -ne 502 -or $failed.Body -notmatch '"code":"DOWNSTREAM_UNAVAILABLE"') { throw "Downstream failure check failed" }
    if ($timer.Elapsed.TotalSeconds -ge 4) { throw "Downstream failure exceeded the bounded response time" }

    & docker @compose start notification-service
    $notificationReady = $false
    for ($attempt = 0; $attempt -lt 20; $attempt++) {
        try {
            $restored = Send-JsonRequest GET "http://localhost:8000/health"
            if ($restored.Status -eq 200) {
                $notificationReady = $true
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }
    if (-not $notificationReady) { throw "Notification service did not recover" }
    Write-Output "Smoke test passed: health=200 create=201 invalid=400 dispatch=202 event=consumed downstream=502"
} finally {
    $client.Dispose()
}