param(
    [switch]$SkipMessaging
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Net.Http
$client = [System.Net.Http.HttpClient]::new()
$client.Timeout = [TimeSpan]::FromSeconds(3)

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
    if ($health.Status -ne 200 -or $health.Body -notmatch '"status":"UP"') {
        throw "FastAPI health check failed: $($health.Status) $($health.Body)"
    }

    $created = Send-JsonRequest POST "http://localhost:8080/api/orders" '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}'
    if ($created.Status -ne 201 -or $created.Body -notmatch '"notificationStatus":"accepted"') {
        throw "Java-to-Python request failed: $($created.Status) $($created.Body)"
    }

    $invalid = Send-JsonRequest POST "http://localhost:8080/api/orders" '{"sku":"SKU-100","quantity":0,"recipient":"dev@example.test"}'
    if ($invalid.Status -ne 400 -or $invalid.Body -notmatch '"code":"INVALID_ORDER"') {
        throw "Boundary check failed: $($invalid.Status) $($invalid.Body)"
    }

    if (-not $SkipMessaging) {
        $orderId = ($created.Body | ConvertFrom-Json).orderId
        $dispatched = Send-JsonRequest POST "http://localhost:8080/api/orders/$orderId/dispatch"
        if ($dispatched.Status -ne 202) {
            throw "Dispatch failed: $($dispatched.Status) $($dispatched.Body)"
        }

        $eventSeen = $false
        for ($attempt = 0; $attempt -lt 20; $attempt++) {
            $events = Send-JsonRequest GET "http://localhost:8000/events"
            if ($events.Status -eq 200 -and $events.Body -match [regex]::Escape($orderId)) {
                $eventSeen = $true
                break
            }
            Start-Sleep -Milliseconds 250
        }
        if (-not $eventSeen) {
            throw "Published event was not consumed"
        }
    }

    Write-Output "Smoke test passed"
} finally {
    $client.Dispose()
}