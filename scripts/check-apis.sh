#!/usr/bin/env bash
# IP Check APIs 体检脚本 (Linux / macOS)
# 用法: bash scripts/check-apis.sh
# 说明: 逐个请求 apis.json 中的 API，验证 HTTP 200 且响应中含合法 IP

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIS_FILE="$SCRIPT_DIR/../apis.json"

# 从 apis.json 抽取 url 列表（仅 apis 段，排除 rejected；无 jq 依赖）
URLS=$(sed -n '/"apis"/,/"rejected"/p' "$APIS_FILE" | grep -oE '"https://[^"]+"' | tr -d '"' | sort -u)

IP_RE='([0-9]{1,3}\.){3}[0-9]{1,3}'
i=0; ok=0; fail=""

echo "IP Check APIs 体检  $(date '+%Y-%m-%d %H:%M:%S')"
echo "--------------------------------------------------------------"
for u in $URLS; do
    i=$((i + 1))
    body=$(curl -sL -m 12 -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/131.0.0.0' -w '\n%{http_code}' "$u" 2>/dev/null)
    code=$(printf '%s' "$body" | tail -n 1)
    ip=$(printf '%s' "$body" | grep -oE "$IP_RE" | head -n 1)
    [ -z "$ip" ] && ip='-'
    if [ "$code" = "200" ] && [ "$ip" != "-" ]; then
        ok=$((ok + 1))
        printf "%2d [OK]  %-4s ip=%-17s %s\n" "$i" "$code" "$ip" "$u"
    else
        fail="$fail $u"
        printf "%2d [BAD] %-4s ip=%-17s %s\n" "$i" "$code" "$ip" "$u"
    fi
done
echo "--------------------------------------------------------------"
echo "SUMMARY: $ok / $i OK"
if [ -n "$fail" ]; then
    echo "失败的接口:"
    for u in $fail; do echo "  $u"; done
fi
