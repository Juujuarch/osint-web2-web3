#!/usr/bin/env bash
# Install backend OSINT tools (blackbird + reconspider) into ./backends/
# Tidak pernah menyimpan kredensial. Semua API key masuk via env var runtime.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKENDS="$ROOT/backends"
mkdir -p "$BACKENDS"

echo "==> Butuh: python3, pip, git. Cek dulu..."
for bin in python3 pip3 git; do
  command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: $bin tidak ditemukan"; exit 1; }
done

echo "==> Install blackbird (username/email OSINT, 600+ platform)"
if [ ! -d "$BACKENDS/blackbird" ]; then
  git clone --depth 1 https://github.com/p1ngul1n0/blackbird "$BACKENDS/blackbird"
fi
pip3 install -r "$BACKENDS/blackbird/requirements.txt"

echo "==> Install reconspider (IP/email/domain/org OSINT framework)"
if [ ! -d "$BACKENDS/reconspider" ]; then
  git clone --depth 1 https://github.com/bhavsec/reconspider "$BACKENDS/reconspider"
fi
pip3 install -r "$BACKENDS/reconspider/requirements.txt" 2>/dev/null || \
  echo "  (reconspider requirements opsional, lanjut)"

cat <<'NOTE'

==> Selesai.

CATATAN OPSEC:
- Repo ini TIDAK menyimpan .env dari backend manapun.
- Kalau blackbird/reconspider minta API key, set via env var saat runtime:
    export SHODAN_KEY="..."        # contoh
  Jangan pernah menulis key ke file dalam repo ini.
- backends/ sudah masuk .gitignore.

NOTE