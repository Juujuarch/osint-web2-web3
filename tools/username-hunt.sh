#!/usr/bin/env bash
# Wrapper blackbird: cari username di 600+ platform, output ke out/
# Usage: bash tools/username-hunt.sh <username>
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BLACKBIRD="$ROOT/backends/blackbird/blackbird.py"

[ $# -ge 1 ] || { echo "Usage: bash tools/username-hunt.sh <username>"; exit 1; }
USERNAME="$1"

if [ ! -f "$BLACKBIRD" ]; then
  echo "ERROR: blackbird belum terinstall. Jalankan: bash tools/install-backends.sh"
  exit 1
fi

OUT="$ROOT/out/username-$USERNAME"
mkdir -p "$OUT"

echo "==> Hunt username: $USERNAME"
python3 "$BLACKBIRD" --username "$USERNAME" 2>&1 | tee "$OUT/results.txt"

# ekspor CSV/PDF kalau blackbird mendukung flag-nya (versi-dependent)
echo "==> Hasil mentah: $OUT/results.txt"
echo "==> Ingat: verifikasi manual tiap match (false positive umum)."