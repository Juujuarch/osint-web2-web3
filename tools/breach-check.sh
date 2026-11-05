#!/usr/bin/env bash
# Breach exposure check - two modes, two different questions:
#   default (email) : which known breaches exposed this email?
#                    HIBP v3 /api/v3/breachedaccount/{email} - needs HIBP_API_KEY env
#   --pass          : has this exact password appeared in a breach corpus?
#                    Pwned Passwords /range/ k-anonymity API - keyless
# Responses are validated: an HTML page (moved endpoint / block page) is an ERROR,
# never a silent CLEAN. A false "clean" is worse than no answer.
# Usage:
#   HIBP_KEY=... bash tools/breach-check.sh <email>
#   bash tools/breach-check.sh <password> --pass
set -uo pipefail

UA="osint-web2-web3-suite/1.0"
INPUT=""
PASS_MODE=0
for arg in "$@"; do
  case "$arg" in
    --pass) PASS_MODE=1 ;;
    -h|--help) echo "Usage: HIBP_KEY=... bash tools/breach-check.sh <email> | bash tools/breach-check.sh <password> --pass"; exit 0 ;;
    *) [ -z "$INPUT" ] && INPUT="$arg" ;;
  esac
done

[ -n "$INPUT" ] || { echo "Usage: bash tools/breach-check.sh <email> | bash tools/breach-check.sh <password> --pass"; exit 1; }

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TS=$(date +%Y%m%d-%H%M%S)
OUT="$ROOT/out/breach-check/$TS"
mkdir -p "$OUT"

hash_sha1() {
  if command -v sha1sum >/dev/null 2>&1; then
    printf '%s' "$1" | sha1sum | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then
    printf '%s' "$1" | shasum -a 1 | cut -d' ' -f1
  else
    echo "ERROR: need sha1sum or shasum"; exit 1
  fi
}

# reject HTML / block pages instead of silently reporting "clean"
validate_api_response() {
  local resp="$1" file="$2"
  if printf '%s' "$resp" | grep -qi '<!DOCTYPE\|<html\|cloudflare\|just a moment'; then
    echo "ERROR: endpoint returned an HTML page, not API data (moved endpoint or block page)."
    echo "  Saved to $file - inspect it. Do NOT treat this as a clean result."
    exit 2
  fi
}

if [ $PASS_MODE -eq 1 ]; then
  # ---- password exposure, k-anonymity, keyless ----
  echo "==> Mode: password exposure (Pwned Passwords k-anonymity, keyless)"
  HASH=$(hash_sha1 "$INPUT")
  PREFIX="${HASH:0:5}"
  SUFFIX="${HASH:5}"
  echo "==> Sending only hash prefix: $PREFIX (5 of 40 chars; full password never leaves this machine)"

  RESP=$(curl -sS --max-time 30 -A "$UA" "https://api.pwnedpasswords.com/range/$PREFIX" || true)
  RF="$OUT/pwnedpasswords-range-$PREFIX.txt"
  printf '%s\n' "$RESP" > "$RF"
  [ -n "$RESP" ] || { echo "ERROR: no response from api.pwnedpasswords.com (network?)"; exit 1; }
  validate_api_response "$RESP" "$RF"

  MATCH=$(printf '%s\n' "$RESP" | grep -i "^$SUFFIX:" || true)
  if [ -z "$MATCH" ]; then
    echo "==> CLEAN: this password does not appear in the Pwned Passwords corpus"
  else
    COUNT=$(printf '%s' "$MATCH" | cut -d: -f2 | tr -dc '0-9')
    echo "==> EXPOSED: this password appears $COUNT time(s) in breach corpora - rotate it everywhere it was reused"
  fi
  echo "==> Raw range response: $RF"
  exit 0
fi

# ---- email breach lookup, needs key ----
if [ -z "${HIBP_KEY:-}" ]; then
  echo "ERROR: email mode needs an HIBP API key."
  echo "  export HIBP_KEY=... (get one at https://haveibeenpwned.com/API/Key)"
  echo "  Keyless alternative: bash tools/breach-check.sh '<password>' --pass"
  exit 1
fi

echo "==> Mode: email breach lookup (HIBP v3 breachedaccount)"
RESP=$(curl -sS --max-time 30 -A "$UA" -H "hibp-api-key: $HIBP_KEY" \
  "https://haveibeenpwned.com/api/v3/breachedaccount/$INPUT?truncateResponse=false" || true)
RF="$OUT/breachedaccount-$INPUT.json"
printf '%s\n' "$RESP" > "$RF"

HTTP=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 -A "$UA" -H "hibp-api-key: $HIBP_KEY" \
  "https://haveibeenpwned.com/api/v3/breachedaccount/$INPUT?truncateResponse=false" || true)

case "$HTTP" in
  200)
    echo "==> EXPOSED: $INPUT appears in the following breaches"
    if command -v jq >/dev/null 2>&1; then
      jq -r '.[] | "  - \(.Name) (\(.BreachDate)) fields: \(.DataClasses | join(", "))"' "$RF"
    else
      grep -o '"Name":"[^"]*"' "$RF" | cut -d'"' -f4 | sed 's/^/  - /'
      echo "  (install jq for breach dates + exposed field lists)"
    fi
    ;;
  404) echo "==> CLEAN: $INPUT not found in indexed breaches" ;;
  401) echo "ERROR: HIBP API key rejected (401) - check HIBP_KEY" ;;
  *)   echo "ERROR: unexpected HTTP $HTTP - inspect $RF" ;;
esac

echo ""
echo "==> Next steps (see skills/osint-leak/SKILL.md):"
echo "  1. Record: breach name, date, exposed fields"
echo "  2. Run MATCHING LOGIC before attributing a record to a target"
echo "  3. Own credentials exposed -> rotate + MFA + invalidate ALL sessions (cookies bypass MFA)"
echo "==> Response saved: $RF"
