#!/usr/bin/env bash
# Generate docs/API-CATALOG.md dari upstream cipher387/API-s-for-OSINT.
# License upstream: CC0 1.0 Universal (public domain) - bebas dipakai & didistilusi.
# Usage:
#   bash tools/sync-api-catalog.sh                      # fetch README terbaru dari GitHub
#   bash tools/sync-api-catalog.sh /path/to/README.md   # pakai README lokal
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM="https://raw.githubusercontent.com/cipher387/API-s-for-OSINT/main/README.md"
OUT="$ROOT/docs/API-CATALOG.md"

if [ $# -ge 1 ] && [ -f "$1" ]; then
  SRC="$1"
  echo "==> Pakai README lokal: $SRC"
else
  SRC="$(mktemp)"
  echo "==> Fetch upstream: $UPSTREAM"
  curl -sS --max-time 60 "$UPSTREAM" -o "$SRC"
fi

awk '
function trim(s){ gsub(/^[ \t]+|[ \t]+$/,"",s); return s }
function isdash(s){ return (s ~ /^-+$/ || s ~ /^:?-+:?$/) }
/^[ \t]*## / {
  cat=substr($0,4); gsub(/[ \t]+$/,"",cat)
  if (cat=="Table of contents") { skip=1; next }
  skip=0
  print ""; print "## " cat; print ""
  next
}
skip { next }
/^[ \t]*\|/ {
  n=split($0, c, "|")
  if (n>=4) {
    name=trim(c[2]); link=trim(c[3]); desc=trim(c[4]); price=(n>=5?trim(c[5]):"")
    if (tolower(name)=="name") next          # header row
    if (name=="" || isdash(name)) next       # separator / empty row
    if (isdash(desc) && link=="") next
    printf "- **%s** - %s `%s`\n", name, desc, link
    if (price!="" && !isdash(price)) printf "  - harga: %s\n", price
  }
  next
}
' "$SRC" > "$OUT.body"

{
  echo "# API Catalog (OSINT)"
  echo ""
  echo "Distilled dari upstream: **cipher387/API-s-for-OSINT**"
  echo "(https://github.com/cipher387/API-s-for-OSINT, license CC0 1.0 Universal - public domain)."
  echo ""
  echo "- Refresh katalog: \`bash tools/sync-api-catalog.sh\`"
  echo "- Repo ini TIDAK meng-vendor README upstream; file ini hasil ekstraksi"
  echo "  nama API + deskripsi + harga tier per kategori."
  echo "- API key TIDAK disimpan di repo ini - set via env var saat runtime (lihat SECURITY.md)."
  cat "$OUT.body"
} > "$OUT"
rm -f "$OUT.body"

COUNT=$(grep -c '^- \*\*' "$OUT" || true)
CATS=$(grep -c '^## ' "$OUT" || true)
echo "==> Selesai: $OUT ($COUNT API, $CATS kategori)"