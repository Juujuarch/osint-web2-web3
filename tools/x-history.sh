#!/usr/bin/env bash
# X/Twitter profile history via public archives (PASSIVE - never touches X).
# Usage: bash tools/x-history.sh <handle>       (handle with or without @)
set -uo pipefail

[ $# -ge 1 ] || { echo "Usage: bash tools/x-history.sh <handle>"; exit 1; }
HANDLE="${1#@}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/x-history-$HANDLE"
mkdir -p "$OUT"

echo "==> [1/3] Wayback CDX: twitter.com/$HANDLE"
curl -sS --max-time 60 "http://web.archive.org/cdx/search/cdx?url=twitter.com/$HANDLE&output=text&fl=timestamp,original,statuscode&collapse=timestamp:6" \
  | tee "$OUT/wayback-twitter-com.txt" || echo "  (failed)"

echo "==> [2/3] Wayback CDX: x.com/$HANDLE"
curl -sS --max-time 60 "http://web.archive.org/cdx/search/cdx?url=x.com/$HANDLE&output=text&fl=timestamp,original,statuscode&collapse=timestamp:6" \
  | tee "$OUT/wayback-x-com.txt" || echo "  (failed)"

echo "==> [3/3] archive.today newest"
curl -sS --max-time 30 -o /dev/null -w "  http %{http_code} -> %{redirect_url}\n" \
  "https://archive.ph/newest/https://x.com/$HANDLE" | tee "$OUT/archive-today.txt" || echo "  (failed / no snapshot)"

cat <<NOTE

==> Done. Output: $OUT

Next steps (see skills/osint-x/SKILL.md):
1. Open snapshots: https://web.archive.org/web/<timestamp>/https://x.com/$HANDLE
   -> read display name, bio, avatar per point in time; record one timeline row per version
2. Look for the numeric USER ID in the archived HTML:
   profile image URL pbs.twimg.com/profile_images/<USER_ID>/...  (the ID is immutable)
3. Compare handles in old vs current snapshots:
   - different handle, same USER ID  -> username change (record the date bound)
   - same handle, different bio      -> bio change (record each bio version)
4. If an old handle is found: bash tools/x-history.sh <old-handle>
NOTE