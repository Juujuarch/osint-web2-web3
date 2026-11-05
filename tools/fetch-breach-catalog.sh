#!/usr/bin/env bash
# Fetch the keyless HIBP breach catalog (breach names, dates, domains, exposed field
# classes - public metadata, NO personal data) into data/, and build a CSV index.
# Usage: bash tools/fetch-breach-catalog.sh
set -uo pipefail

UA="osint-web2-web3-suite/1.0"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/data"
mkdir -p "$OUT"
CATALOG="$OUT/breaches-catalog.json"

echo "==> Fetching HIBP breach catalog (keyless, public metadata)"
RESP=$(curl -sS --max-time 60 -A "$UA" "https://haveibeenpwned.com/api/v3/breaches" || true)
printf '%s\n' "$RESP" > "$CATALOG"

if printf '%s' "$RESP" | grep -qi '<!DOCTYPE\|<html\|cloudflare'; then
  echo "ERROR: got an HTML page instead of JSON (blocked?) - inspect $CATALOG"
  exit 2
fi
# NOTE: no `head -c1` here - under `set -o pipefail` a SIGPIPE'd printf makes the
# pipeline exit non-zero and a valid response would be rejected.
FIRST="${RESP:0:1}"
if [ "$FIRST" != "[" ]; then
  echo "ERROR: response is not a JSON array (starts with '${FIRST:-empty}') - inspect $CATALOG"
  exit 2
fi

SIZE=$(wc -c < "$CATALOG")
echo "==> Saved: $CATALOG ($SIZE bytes)"

# compact CSV index via python (stdlib only); fall back to grep if python is missing
INDEX="$OUT/breach-index.csv"
PY=""
for cand in python python3 py; do
  # WindowsApps python3 stubs resolve but fail to run - verify before trusting
  if command -v "$cand" >/dev/null 2>&1 && "$cand" -c 'import sys' >/dev/null 2>&1; then
    PY="$cand"; break
  fi
done
if [ -n "$PY" ]; then
  "$PY" - "$CATALOG" "$INDEX" <<'EOF'
import csv, json, sys
src, dst = sys.argv[1], sys.argv[2]
with open(src, encoding="utf-8") as f:
    data = json.load(f)
with open(dst, "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["Name", "BreachDate", "Domain", "PwnCount", "DataClasses"])
    for b in data:
        w.writerow([b.get("Name",""), b.get("BreachDate",""), b.get("Domain",""),
                    b.get("PwnCount",""), "; ".join(b.get("DataClasses", []))])
print(f"==> Index: {dst} ({len(data)} breaches)")
EOF
else
  echo "WARN: python not found - skipping CSV index"
fi

echo "==> Done. Reference data only - this catalog contains NO personal data."
echo "    Look up a domain: grep -i '<domain>' $INDEX"
