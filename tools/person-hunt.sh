#!/usr/bin/env bash
# Person hunt: username or full name -> profile existence across platforms + pivot data.
# Pure-HTTP, keyless. Tiered per skills/osint-web2 MATCHING LOGIC.
#
# Usage:
#   bash tools/person-hunt.sh <username>
#   bash tools/person-hunt.sh --name "Budi Santoso"     # generates handle candidates
#
# Verified discriminating from a residential ID connection (2026-11-05):
#   github (web+api), x.com, keybase, steam, tiktok oembed = clean signal
#   instagram web_profile_info = works but rate-limits (429) - retried once, then reported
#   reddit/youtube/facebook/linkedin/pinterest/twitch = no keyless signal from this network
set -uo pipefail

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
IG_APP_ID="936619743392459"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NAME_MODE=0
INPUT=""
for arg in "$@"; do
  case "$arg" in
    --name) NAME_MODE=1 ;;
    -h|--help) echo "Usage: bash tools/person-hunt.sh <username> | bash tools/person-hunt.sh --name \"Full Name\""; exit 0 ;;
    *) [ -z "$INPUT" ] && INPUT="$arg" || INPUT="$INPUT $arg" ;;
  esac
done
[ -n "$INPUT" ] || { echo "Usage: bash tools/person-hunt.sh <username> | --name \"Full Name\""; exit 1; }

TS=$(date +%Y%m%d-%H%M%S)
SAFE=$(printf '%s' "$INPUT" | tr ' /' '__')
OUT="$ROOT/out/person-hunt/$SAFE-$TS"
mkdir -p "$OUT"
REPORT="$OUT/report.txt"

# ---- candidate handles ----
if [ $NAME_MODE -eq 1 ]; then
  # "Budi Santoso" -> budi.santoso budisantoso budi_santoso bsantoso b_santoso budisantoso1
  FIRST=$(printf '%s' "$INPUT" | awk '{print tolower($1)}')
  LAST=$(printf '%s' "$INPUT" | awk '{print tolower($2)}')
  FI=${FIRST:0:1}
  CANDIDATES="$FIRST.$LAST $FIRST$LAST ${FIRST}_$LAST $FI$LAST ${FIRST}${LAST}1 ${FIRST}${LAST}123 $FIRST _$FIRST$LAST"
else
  CANDIDATES="$INPUT"
fi

log() { printf '%s\n' "$1" | tee -a "$REPORT"; }

log "==> person-hunt: '$INPUT' (name mode: $NAME_MODE)"
log "==> candidates: $(printf '%s' "$CANDIDATES" | tr '\n' ' ')"
log "==> output: $OUT"
log ""

TOTAL_HITS=0

check_status() { # url, exists_codes (space separated)
  local url="$1" want="$2" code
  code=$(curl -s -o /dev/null -w "%{http_code}" -m 12 -L -A "$UA" "$url" 2>/dev/null || echo "000")
  for w in $want; do [ "$code" = "$w" ] && return 0; done
  return 1
}

for u in $CANDIDATES; do
  HITS=""

  # github web + api (api also yields pivot fields)
  if check_status "https://github.com/$u" "200"; then
    HITS="$HITS github"
    API=$(curl -s -m 12 -A "$UA" "https://api.github.com/users/$u" 2>/dev/null || true)
    NAME=$(printf '%s' "$API" | grep -o '"name": *"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
    EMAIL=$(printf '%s' "$API" | grep -o '"email": *"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
    BLOG=$(printf '%s' "$API" | grep -o '"blog": *"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
    BIO=$(printf '%s' "$API" | grep -o '"bio": *"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
    TW=$(printf '%s' "$API" | grep -o '"twitter_username": *"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
    log "  [$u] github: EXISTS"
    [ -n "$NAME" ] && log "      name: $NAME"
    [ -n "$EMAIL" ] && log "      email: $EMAIL   <- pivot (KUAT if non-generic domain)"
    [ -n "$BLOG" ] && log "      blog: $BLOG"
    [ -n "$TW" ] && log "      twitter: @$TW   <- pivot to osint-x"
    [ -n "$BIO" ] && log "      bio: $BIO"
  fi

  # x.com
  if check_status "https://x.com/$u" "200"; then
    HITS="$HITS x"; log "  [$u] x.com: EXISTS"
  fi

  # keybase
  if check_status "https://keybase.io/$u" "200"; then
    HITS="$HITS keybase"; log "  [$u] keybase: EXISTS"
  fi

  # tiktok via oembed (200 = exists, 400 = not)
  TT=$(curl -s -o /dev/null -w "%{http_code}" -m 12 -A "$UA" "https://www.tiktok.com/oembed?url=https://www.tiktok.com/@$u" 2>/dev/null || echo "000")
  if [ "$TT" = "200" ]; then
    HITS="$HITS tiktok"; log "  [$u] tiktok: EXISTS"
  fi

  # steam via body marker
  BODY=$(curl -s -m 12 -L -A "$UA" "https://steamcommunity.com/id/$u" 2>/dev/null || true)
  if [ -n "$BODY" ] && ! printf '%s' "$BODY" | grep -qi "could not be found"; then
    HITS="$HITS steam"; log "  [$u] steam: EXISTS"
  fi

  # instagram via public app-id endpoint (429 = rate limited, reported honestly)
  IG=$(curl -s -m 15 -A "$UA" -H "x-ig-app-id: $IG_APP_ID" \
       "https://www.instagram.com/api/v1/users/web_profile_info/?username=$u" 2>/dev/null || true)
  IG_CODE=$(curl -s -o /dev/null -w "%{http_code}" -m 15 -A "$UA" -H "x-ig-app-id: $IG_APP_ID" \
       "https://www.instagram.com/api/v1/users/web_profile_info/?username=$u" 2>/dev/null || echo "000")
  case "$IG_CODE" in
    200)
      if printf '%s' "$IG" | grep -q '"username"'; then
        HITS="$HITS instagram"; log "  [$u] instagram: EXISTS"
        IGFN=$(printf '%s' "$IG" | grep -o '"full_name":"[^"]*"' | head -1 | sed 's/.*:"//;s/"$//')
        [ -n "$IGFN" ] && log "      full_name: $IGFN"
      fi
      ;;
    429) log "  [$u] instagram: RATE-LIMITED (429) - retry later or via proxy" ;;
    *)   log "  [$u] instagram: not found (HTTP $IG_CODE)" ;;
  esac

  if [ -n "$HITS" ]; then
    N=$(printf '%s' "$HITS" | wc -w)
    TOTAL_HITS=$((TOTAL_HITS + N))
    log "  => [$u] found on $N platform(s):$HITS"
    if [ "$N" -ge 2 ]; then
      log "     VERDICT: same handle on $N platforms = KUAT signal (handle reuse) - run osint-correlation before attributing"
    fi
  else
    log "  [$u] not found on any checked platform"
  fi
  log ""
done

log "==> Done. $TOTAL_HITS profile hit(s) total. Report: $REPORT"
log "==> Tiering (skills/osint-web2): profile exists = SEDANG | same handle 2+ platforms = KUAT"
log "    GitHub public email = KUAT pivot | signed message / immutable ID = KONFIRMASI"
log "==> Next: pivot every hit through tools/username-hunt.sh (600+ platforms) + osint-correlation"
