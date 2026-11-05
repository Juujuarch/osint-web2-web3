#!/usr/bin/env bash
# Blackbird wrapper: search a username across 600+ platforms, output to out/
# Usage: bash tools/username-hunt.sh <username>
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BLACKBIRD="$ROOT/backends/blackbird/blackbird.py"

[ $# -ge 1 ] || { echo "Usage: bash tools/username-hunt.sh <username>"; exit 1; }
USERNAME="$1"

if [ ! -f "$BLACKBIRD" ]; then
  echo "ERROR: blackbird not installed. Run: bash tools/install-backends.sh"
  exit 1
fi

OUT="$ROOT/out/username-$USERNAME"
mkdir -p "$OUT"

echo "==> Hunting username: $USERNAME"
python3 "$BLACKBIRD" --username "$USERNAME" 2>&1 | tee "$OUT/results.txt"

# export CSV/PDF if blackbird supports the flag (version-dependent)
echo "==> Raw results: $OUT/results.txt"
echo "==> Remember: verify every match manually (false positives are common)."