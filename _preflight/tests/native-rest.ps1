$ErrorActionPreference = "Stop"
$preflight = Split-Path $PSScriptRoot -Parent
$reference = Join-Path $preflight "reference"
$notification = Join-Path $reference "notification-service"
$order = Join-Path $reference "order-service"
$python = Join-Path $notification ".venv/Scripts/python.exe"
$jar = Join-Path $order "target/order-service-1.0.0.jar"
$smoke = Join-Path $preflight "scripts/smoke-reference.ps1"
$pythonProcess = $null
$javaProcess = $null

function Invoke-Http {
    param([string]$Method, [string]$Url, [string]$Body = "")
    $responseFile = [System.IO.Path]::GetTempFileName()
    $requestFile = [System.IO.Path]::GetTempFileName()
    try {
        $arguments = @("--silent", "--connect-timeout", "1", "--max-time", "3", "--output", $responseFile, "--write-out", "%{http_code}", "--request", $Method)
        if ($Body) {
            [System.IO.File]::WriteAllText($requestFile, $Body, [System.Text.UTF8Encoding]::new($false))
            $arguments += @("--header", "Content-Type: application/json", "--data-binary", "@$requestFile")
        }
        $arguments += $Url
        $status = (& curl.exe @arguments) -join ""
        return @{ Status = $status.Trim(); Body = Get-Content $responseFile -Raw }
    } finally {
        Remove-Item $responseFile -Force -ErrorAction SilentlyContinue
        Remove-Item $requestFile -Force -ErrorAction SilentlyContinue
    }
}

function Wait-ForStatus {
    param([string]$Method, [string]$Url, [string]$Body, [string]$Expected)
    for ($attempt = 0; $attempt -lt 80; $attempt++) {
        $response = Invoke-Http $Method $Url $Body
        if ($response.Status -eq $Expected) {
            return
        }
        Start-Sleep -Milliseconds 250
    }
    throw "Timed out waiting for HTTP $Expected from $Url"
}

try {
    if (-not (Test-Path $python)) {
        throw "Missing Python environment: $python"
    }
    if (-not (Test-Path $jar)) {
        throw "Missing Java package: $jar"
    }

    Get-CimInstance Win32_Process | Where-Object {
        $_.CommandLine -and
        ($_.CommandLine -match "order-service-1.0.0.jar" -or
         ($_.CommandLine -like "*$reference*" -and $_.CommandLine -match "uvicorn"))
    } | ForEach-Object {
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    }

    $logDirectory = Join-Path ([System.IO.Path]::GetTempPath()) "kodschul-preflight"
    New-Item -ItemType Directory -Force $logDirectory | Out-Null
    $pythonProcess = Start-Process $python -ArgumentList "-m", "uvicorn", "app.main:app", "--host", "127.0.0.1", "--port", "8000" -WorkingDirectory $notification -RedirectStandardOutput (Join-Path $logDirectory "python.out.log") -RedirectStandardError (Join-Path $logDirectory "python.err.log") -PassThru
    $javaProcess = Start-Process java -ArgumentList "-jar `"$jar`"" -WorkingDirectory $order -RedirectStandardOutput (Join-Path $logDirectory "java.out.log") -RedirectStandardError (Join-Path $logDirectory "java.err.log") -PassThru

    Write-Output "Waiting for native services"
    Wait-ForStatus GET "http://localhost:8000/health" "" "200"
    Wait-ForStatus POST "http://localhost:8080/api/orders" '{"sku":"readiness","quantity":0,"recipient":"dev@example.test"}' "400"

    Write-Output "Running Java-to-Python smoke test"
    & $smoke -SkipMessaging

    Stop-Process -Id $pythonProcess.Id -Force
    $pythonProcess.WaitForExit()
    $failure = Invoke-Http POST "http://localhost:8080/api/orders" '{"sku":"SKU-100","quantity":2,"recipient":"dev@example.test"}'
    if ($failure.Status -ne "502" -or $failure.Body -notmatch '"code":"DOWNSTREAM_UNAVAILABLE"') {
        throw "Downstream failure check failed: $($failure.Status) $($failure.Body)"
    }

    Write-Output "Downstream failure check passed"
} finally {
    if ($pythonProcess -and -not $pythonProcess.HasExited) {
        Stop-Process -Id $pythonProcess.Id -Force
        $pythonProcess.WaitForExit()
    }
    if ($javaProcess -and -not $javaProcess.HasExited) {
        Stop-Process -Id $javaProcess.Id -Force
        $javaProcess.WaitForExit()
    }
    Get-CimInstance Win32_Process | Where-Object {
        $_.CommandLine -and
        ($_.CommandLine -match "order-service-1.0.0.jar" -or
         ($_.CommandLine -like "*$reference*" -and $_.CommandLine -match "uvicorn"))
    } | ForEach-Object {
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    }
    Write-Output "Native services stopped"
}