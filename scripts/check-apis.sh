#!/usr/bin/env bash
# IP Check APIs health check (Linux / macOS / Git Bash)
#
# Usage:
#   bash scripts/check-apis.sh                  # check all endpoints
#   GROUP=json bash scripts/check-apis.sh       # only one response-format group
#   EXPECTED=1.2.3.4 bash scripts/check-apis.sh # strict: body must contain this IP
#   TIMEOUT=20 bash scripts/check-apis.sh       # per-request timeout (default 12)
#
# Verifies: HTTP 200 and a parseable IP in the response body.

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APIS_FILE="$SCRIPT_DIR/../apis.json"

GROUP="${GROUP:-}"
EXPECTED="${EXPECTED:-}"
TIMEOUT="${TIMEOUT:-12}"
UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/131.0.0.0'

if [ ! -f "$APIS_FILE" ]; then
    echo "ERROR: apis.json not found at $APIS_FILE" >&2
    exit 1
fi
if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl not found" >&2
    exit 1
fi

# Extract the "apis" section only (stop before "rejected"), then pull every
# http:// and https:// URL out of it. Note: must accept BOTH http and https,
# otherwise http-only endpoints are silently skipped.
URLS=$(sed -n '/"apis"/,/"rejected"/p' "$APIS_FILE" \
    | grep -oE '"https?://[^"]+"' \
    | tr -d '"' \
    | sort -u)

IP_RE='[0-9]{1,3}(\.[0-9]{1,3}){3}'

if [ -n "$GROUP" ]; then
    # keep only URLs whose entry declares the requested group
    FILTERED=""
    for u in $URLS; do
        if sed -n "/\"apis\"/,/\"rejected\"/p" "$APIS_FILE" | grep -F "\"$u\"" | grep -q "\"group\": \"$GROUP\""; then
            FILTERED="$FILTERED $u"
        fi
    done
    URLS=$(printf '%s\n' $FILTERED)
    if [ -z "$URLS" ]; then
        echo "ERROR: no endpoints matched GROUP='$GROUP'" >&2
        exit 1
    fi
fi

TOTAL=$(printf '%s\n' $URLS | grep -c .)
MODE="basic"
[ -n "$EXPECTED" ] && MODE="strict (expect $EXPECTED)"

echo "IP Check APIs health check  $(date '+%Y-%m-%d %H:%M:%S')"
echo "source: $APIS_FILE"
echo "mode: $MODE   endpoints: $TOTAL"
echo "--------------------------------------------------------------"

i=0; ok=0; failed=""
for u in $URLS; do
    i=$((i + 1))
    body=$(curl -sL -m "$TIMEOUT" -A "$UA" -w '\n%{http_code}' "$u" 2>/dev/null)
    code=$(printf '%s' "$body" | tail -n 1)
    payload=$(printf '%s' "$body" | sed '$d')

    # Prefer an IP that sits next to a known label (ip / ip_addr / IP / origin /
    # query / ipAddress) so that host echoes such as "h=1.0.0.1" in a
    # cdn-cgi/trace body are not mistaken for the visitor IP.
    ip=$(printf '%s' "$payload" \
        | grep -oiE '(ip_addr|ipaddress|origin|query|ip)["'"'"' ]*[:=]["'"'"' ]*'"$IP_RE" \
        | grep -oE "$IP_RE" | head -n 1)
    [ -z "$ip" ] && ip=$(printf '%s' "$payload" | grep -oE "$IP_RE" | head -n 1)

    if [ -n "$EXPECTED" ]; then
        valid=no
        if [ "$code" = "200" ] && printf '%s' "$payload" | grep -qF "$EXPECTED"; then
            valid=yes
            ip="$EXPECTED"
        fi
    else
        valid=no
        if [ "$code" = "200" ] && [ -n "$ip" ]; then valid=yes; fi
    fi

    if [ "$valid" = "yes" ]; then
        ok=$((ok + 1))
        printf "%3d [OK]  %-4s ip=%-17s %s\n" "$i" "$code" "$ip" "$u"
    else
        failed="$failed $u"
        printf "%3d [BAD] %-4s ip=%-17s %s\n" "$i" "$code" "${ip:--}" "$u"
    fi
done

echo "--------------------------------------------------------------"
echo "SUMMARY: $ok / $TOTAL OK"
if [ -n "$failed" ]; then
    echo "Failed endpoints:"
    for u in $failed; do echo "  $u"; done
fi
