#!/usr/bin/env bash
# Breach exposure check using the k-anonymity model (HIBP range API).
# Only the first 5 hex chars of the SHA-1 hash leave this machine.
# Usage: bash tools/breach-check.sh <email-or-identifier>
# No API key required for the range endpoint.
set -uo pipefail

[ $# -ge 1 ] || { echo "Usage: bash tools/breach-check.sh <email-or-identifier>"; exit 1; }
IDENT="$1"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/breach-check"
mkdir -p "$OUT"

echo "==> Hashing locally (identifier never sent in full)"
if command -v sha1sum >/dev/null 2>&1; then
  HASH=$(printf '%s' "$IDENT" | tr '[:upper:]' '[:lower:]' | sha1sum | cut -d' ' -f1)
elif command -v shasum >/dev/null 2>&1; then
  HASH=$(printf '%s' "$IDENT" | tr '[:upper:]' '[:lower:]' | shasum -a 1 | cut -d' ' -f1)
else
  echo "ERROR: need sha1sum or shasum"; exit 1
fi
PREFIX="${HASH:0:5}"
SUFFIX="${HASH:5}"
echo "==> Sending only prefix: $PREFIX (5 chars of 40)"

RESP=$(curl -sS --max-time 30 "https://haveibeenpwned.com/range/$PREFIX" || true)
if [ -z "$RESP" ]; then
  echo "ERROR: no response from HIBP range API (network?)"
  exit 1
fi

echo "$RESP" > "$OUT/range-$PREFIX.txt"

# match suffix locally, case-insensitive
MATCHES=$(echo "$RESP" | grep -i "^$SUFFIX:" || true)

if [ -z "$MATCHES" ]; then
  echo "==> CLEAN: $IDENT not found in indexed breaches"
  exit 0
fi

echo "==> EXPOSED: $IDENT appears in the following breaches"
echo "$MATCHES" | while IFS=: read -r suffix count; do
  echo "  - breach count: $count (see https://haveibeenpwned.com for breach names)"
done

echo ""
echo "==> Next steps (see skills/osint-leak/SKILL.md):"
echo "  1. Look up each breach name + date on haveibeenpwned.com"
echo "  2. Record: breach name, date, exposed fields"
echo "  3. Run MATCHING LOGIC before attributing a record to a target"
echo "  4. Own credentials exposed -> rotate + MFA everywhere reused"
echo ""
echo "NOTE: range response saved to $OUT/range-$PREFIX.txt"