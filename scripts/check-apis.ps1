# IP Check APIs health check (Windows PowerShell)
#
# Usage:
#   ./scripts/check-apis.ps1                     # check all endpoints
#   ./scripts/check-apis.ps1 -Group json         # only one response-format group
#   ./scripts/check-apis.ps1 -Expected 1.2.3.4   # strict: body must contain this IP
#
# Verifies: HTTP 200 and a parseable IP in the response body.

[CmdletBinding()]
param(
    [string]$Group,       # plain-text | json | trace | html | xml | yaml | csv | jsonp
    [string]$Expected,    # your real egress IP; enables strict mode
    [int]$TimeoutSec = 12
)

$ErrorActionPreference = 'Stop'

# --- locate apis.json (script dir, or its parent) -------------------------
$candidates = @(
    (Join-Path $PSScriptRoot '..\apis.json'),
    (Join-Path $PSScriptRoot 'apis.json')
)
$apisFile = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $apisFile) {
    Write-Host "ERROR: apis.json not found. Looked in:" -ForegroundColor Red
    $candidates | ForEach-Object { Write-Host "  $_" }
    exit 1
}

# --- curl.exe is required -------------------------------------------------
if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: curl.exe not found. Windows 10 1803+ ships it at C:\Windows\System32\curl.exe" -ForegroundColor Red
    exit 1
}

# --- read JSON as UTF-8 explicitly (PS 5.1 would otherwise use the ANSI
#     codepage and corrupt multi-byte characters, breaking the parse) ------
$json = [IO.File]::ReadAllText($apisFile, (New-Object Text.UTF8Encoding $false))
$data = $json | ConvertFrom-Json

$apis = @($data.apis)
if ($Group) {
    $apis = @($apis | Where-Object { $_.group -eq $Group })
}
if ($apis.Count -eq 0) {
    Write-Host "ERROR: no endpoints matched (Group='$Group')." -ForegroundColor Red
    Write-Host ("Available groups: " + (($data.apis | Group-Object group | ForEach-Object { $_.Name }) -join ', '))
    exit 1
}

# --- run ------------------------------------------------------------------
$tmp = New-TemporaryFile
$i = 0; $ok = 0; $failed = @()
$mode = if ($Expected) { "strict (expect $Expected)" } else { 'basic' }

Write-Host "IP Check APIs health check  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "source: $apisFile"
Write-Host "mode: $mode   endpoints: $($apis.Count)"
Write-Host ('-' * 78)

foreach ($api in $apis) {
    $i++
    $code = curl.exe -sL -m $TimeoutSec -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/131.0.0.0' `
        -o $tmp.FullName -w '%{http_code}' $api.url 2>$null
    $body = ''
    if (Test-Path $tmp.FullName) {
        $body = [IO.File]::ReadAllText($tmp.FullName, (New-Object Text.UTF8Encoding $false))
    }

    $ip = '-'
    if ($body -match '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})') { $ip = $Matches[1] }

    if ($Expected) {
        $valid = ($code -eq '200') -and ($body -match [regex]::Escape($Expected))
        if ($valid) { $ip = $Expected }
    } else {
        $valid = ($code -eq '200') -and ($ip -ne '-')
    }

    if ($valid) { $ok++ } else { $failed += $api.url }
    $tag = if ($valid) { 'OK' } else { 'BAD' }
    Write-Host ("{0,3} [{1}] {2,-4} ip={3,-17} {4}" -f $i, $tag, $code, $ip, $api.url)
}

Remove-Item $tmp.FullName -ErrorAction SilentlyContinue

Write-Host ('-' * 78)
Write-Host ("SUMMARY: $ok / $($apis.Count) OK")
if ($failed.Count -gt 0) {
    Write-Host 'Failed endpoints:'
    $failed | ForEach-Object { Write-Host "  $_" }
}
