#!/usr/bin/env bash
# Local leak-dataset query: search combolists / stealer logs / breach dumps for an identifier.
# Everything stays on this machine. Credential fields are masked by default (--show to reveal).
# Usage: bash tools/leak-grep.sh <identifier> [dataset-dir] [--show]
#   identifier : email | username | phone | domain | wallet address | any token
#   dataset-dir: directory holding leak files (default: $ROOT/leaks, gitignored)
#   --show     : print full matching lines (default prints file:line + masked context)
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IDENT=""
DATASET=""
SHOW=0
for arg in "$@"; do
  case "$arg" in
    --show) SHOW=1 ;;
    *) if [ -z "$IDENT" ]; then IDENT="$arg"; elif [ -z "$DATASET" ]; then DATASET="$arg"; fi ;;
  esac
done

[ -n "$IDENT" ] || { echo "Usage: bash tools/leak-grep.sh <identifier> [dataset-dir] [--show]"; exit 1; }
DATASET="${DATASET:-$ROOT/leaks}"

if [ ! -d "$DATASET" ]; then
  echo "ERROR: dataset dir not found: $DATASET"
  echo "  Create it and drop combolist/stealer-log files in (dir is gitignored):"
  echo "    mkdir -p \"$DATASET\""
  exit 1
fi

# lowercase the identifier for case-insensitive matching
IDENT_LC=$(printf '%s' "$IDENT" | tr '[:upper:]' '[:lower:]')

# classify identifier type (reporting only - matching is literal either way)
case "$IDENT_LC" in
  *@*.*)   KIND="email" ;;
  0x[0-9a-f]*) KIND="wallet/hex" ;;
  +[0-9]*|[0-9][0-9][0-9]*) KIND="phone/number" ;;
  *.*)     KIND="domain" ;;
  *)       KIND="username/token" ;;
esac

TS=$(date +%Y%m%d-%H%M%S)
OUT="$ROOT/out/leak-grep/$IDENT_LC-$TS"
mkdir -p "$OUT"
REPORT="$OUT/report.txt"

echo "==> Identifier: $IDENT (classified: $KIND)"
echo "==> Dataset: $DATASET"
echo "==> Mode: $([ $SHOW -eq 1 ] && echo 'FULL LINES (--show)' || echo 'masked (default)')"

# collect candidate files: plain text + gzip + json (zip/7z left to manual extraction)
FILES=$(find "$DATASET" -type f \( -name '*.txt' -o -name '*.csv' -o -name '*.tsv' -o -name '*.gz' -o -name '*.log' -o -name '*.json' \) 2>/dev/null | sort)
if [ -z "$FILES" ]; then
  echo "==> No .txt/.csv/.tsv/.gz/.log files in dataset - nothing to scan"
  exit 0
fi

TOTAL_FILES=0
TOTAL_HITS=0
HIT_FILES=0
: > "$REPORT"

while IFS= read -r f; do
  TOTAL_FILES=$((TOTAL_FILES+1))
  case "$f" in
    *.gz) MATCHES=$(zgrep -in -- "$IDENT_LC" "$f" 2>/dev/null || true) ;;
    *)    MATCHES=$(grep -in -- "$IDENT_LC" "$f" 2>/dev/null || true) ;;
  esac
  [ -z "$MATCHES" ] && continue

  COUNT=$(printf '%s\n' "$MATCHES" | grep -c . || true)
  HIT_FILES=$((HIT_FILES+1))
  TOTAL_HITS=$((TOTAL_HITS+COUNT))
  echo "  HIT x$COUNT  $f"
  {
    echo "FILE: $f"
    echo "HITS: $COUNT"
    if [ $SHOW -eq 1 ]; then
      printf '%s\n' "$MATCHES" | head -20
    else
      # masked: keep only file:lineno + the matched token, drop the rest of the line
      printf '%s\n' "$MATCHES" | head -20 | while IFS=: read -r lineno rest; do
        echo "  line $lineno: [matched token present - rerun with --show for full line]"
      done
    fi
    echo "---"
  } >> "$REPORT"
done <<< "$FILES"

echo ""
echo "==> Scan complete: $TOTAL_FILES files, $TOTAL_HITS hits in $HIT_FILES files"
echo "==> Report: $REPORT"

if [ "$TOTAL_HITS" -eq 0 ]; then
  echo "==> CLEAN in this dataset (absence here != absence everywhere - see skills/osint-leak/SKILL.md)"
  exit 0
fi

echo ""
echo "==> Next steps (skills/osint-leak/SKILL.md):"
echo "  1. Run MATCHING LOGIC before attributing any row to a target"
echo "  2. Freshness: check record date vs identifier age (stale rows are noise)"
echo "  3. Own credentials exposed -> rotate + MFA + invalidate ALL sessions (cookies bypass MFA)"
echo "  4. NEVER use these credentials for login attempts - that is credential stuffing"
echo "  5. Dataset holds third-party PII: isolate, minimize, hash artifacts (SHA-256)"
