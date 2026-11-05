#!/usr/bin/env bash
# X/Twitter profile history via public archives (PASIF - tidak menyentuh X).
# Usage: bash tools/x-history.sh <handle>       (handle bisa pakai @ atau tanpa)
set -uo pipefail

[ $# -ge 1 ] || { echo "Usage: bash tools/x-history.sh <handle>"; exit 1; }
HANDLE="${1#@}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/x-history-$HANDLE"
mkdir -p "$OUT"

echo "==> [1/3] Wayback CDX: twitter.com/$HANDLE"
curl -sS --max-time 60 "http://web.archive.org/cdx/search/cdx?url=twitter.com/$HANDLE&output=text&fl=timestamp,original,statuscode&collapse=timestamp:6" \
  | tee "$OUT/wayback-twitter-com.txt" || echo "  (gagal)"

echo "==> [2/3] Wayback CDX: x.com/$HANDLE"
curl -sS --max-time 60 "http://web.archive.org/cdx/search/cdx?url=x.com/$HANDLE&output=text&fl=timestamp,original,statuscode&collapse=timestamp:6" \
  | tee "$OUT/wayback-x-com.txt" || echo "  (gagal)"

echo "==> [3/3] archive.today newest"
curl -sS --max-time 30 -o /dev/null -w "  http %{http_code} -> %{redirect_url}\n" \
  "https://archive.ph/newest/https://x.com/$HANDLE" | tee "$OUT/archive-today.txt" || echo "  (gagal / tidak ada snapshot)"

cat <<NOTE

==> Selesai. Output: $OUT

Langkah lanjut (lihat skills/osint-x/SKILL.md):
1. Buka snapshot: https://web.archive.org/web/<timestamp>/https://x.com/$HANDLE
   -> baca display name, bio, avatar per titik waktu; catat satu baris timeline per versi
2. Cari USER ID numerik di HTML arsip:
   URL gambar profil pbs.twimg.com/profile_images/<USER_ID>/...  (ID = kekal)
3. Bandingkan handle di snapshot lama vs sekarang:
   - beda handle, USER ID sama  -> username change (catat tanggal batas)
   - handle sama, bio beda      -> bio change (catat versi bio)
4. Kalau ketemu handle lama: bash tools/x-history.sh <handle-lama>
NOTE