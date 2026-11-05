#!/usr/bin/env bash
# Install backend OSINT tools (blackbird + reconspider) into ./backends/
# Never stores credentials. All API keys enter via environment variables at runtime.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKENDS="$ROOT/backends"
mkdir -p "$BACKENDS"

echo "==> Requires: python3, pip, git. Checking..."
for bin in python3 pip3 git; do
  command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: $bin not found"; exit 1; }
done

echo "==> Installing blackbird (username/email OSINT, 600+ platforms)"
if [ ! -d "$BACKENDS/blackbird" ]; then
  git clone --depth 1 https://github.com/p1ngul1n0/blackbird "$BACKENDS/blackbird"
fi
pip3 install -r "$BACKENDS/blackbird/requirements.txt"

echo "==> Installing reconspider (IP/email/domain/org OSINT framework)"
if [ ! -d "$BACKENDS/reconspider" ]; then
  git clone --depth 1 https://github.com/bhavsec/reconspider "$BACKENDS/reconspider"
fi
pip3 install -r "$BACKENDS/reconspider/requirements.txt" 2>/dev/null || \
  echo "  (reconspider requirements optional, continuing)"

cat <<'NOTE'

==> Done.

OPSEC NOTES:
- This repo does NOT store .env files from any backend.
- If blackbird/reconspider need API keys, set them via env vars at runtime:
    export SHODAN_KEY="..."        # example
  Never write keys into files inside this repo.
- backends/ is already gitignored.

NOTE