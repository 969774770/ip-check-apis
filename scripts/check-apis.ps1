# IP Check APIs 体检脚本 (Windows PowerShell)
# 用法: ./scripts/check-apis.ps1
# 说明: 逐个请求 apis.json 中的 API，验证 HTTP 200 且响应中含合法 IP

$ErrorActionPreference = 'SilentlyContinue'
$apisFile = Join-Path $PSScriptRoot '..\apis.json'
$apis = (Get-Content $apisFile -Raw | ConvertFrom-Json).apis

$tmp = New-TemporaryFile
$i = 0; $ok = 0; $pass = @()

Write-Host "IP Check APIs health check  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host ('-' * 78)

foreach ($api in $apis) {
    $i++
    $code = curl.exe -sL -m 12 -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/131.0.0.0' `
        -o $tmp.FullName -w '%{http_code}' $api.url 2>$null
    $body = Get-Content $tmp.FullName -Raw -ErrorAction SilentlyContinue
    $ip = '-'
    if ($body -match '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})') { $ip = $Matches[1] }
    $valid = ($code -eq '200') -and ($ip -ne '-')
    if ($valid) { $ok++; $pass += $api.url }
    Write-Host ("{0,2} [{1}] {2,-4} ip={3,-17} {4}" -f $i, $(if ($valid) { 'OK' } else { 'BAD' }), $code, $ip, $api.url)
}

Remove-Item $tmp.FullName -ErrorAction SilentlyContinue
Write-Host ('-' * 78)
Write-Host "SUMMARY: $ok / $($apis.Count) OK"
if ($ok -lt $apis.Count) {
    Write-Host "Failed APIs:"
    $apis | Where-Object { $pass -notcontains $_.url } | ForEach-Object { Write-Host "  $($_.url)" }
}
