#!/usr/bin/env bash
# Leak-campaign news watch: pull the Dark Web Informer RSS feed (clearnet index of
# darknet leak/broker/extortion activity) and log new items locally.
# This is campaign INTELLIGENCE (actor, claimed victim, record count, date) -
# not stolen data itself. Feed the findings into skills/osint-leak section 8.
# Usage: bash tools/leak-news-watch.sh
set -uo pipefail

UA="osint-web2-web3-suite/1.0"
FEED="https://darkwebinformer.com/feed/"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/leak-watch"
mkdir -p "$OUT"
LOG="$OUT/feed-log.tsv"
[ -f "$LOG" ] || printf 'first_seen_wib\ttitle\tlink\tpubdate\tcategory\n' > "$LOG"

echo "==> Fetching $FEED"
RAW=$(curl -sSL --max-time 30 -A "$UA" "$FEED" || true)
[ -n "$RAW" ] || { echo "ERROR: empty feed response (network?)"; exit 1; }
case "$RAW" in
  *"<item"*|*"<entry"*) ;;
  *) echo "ERROR: feed response has no items (got $(printf '%s' "$RAW" | head -c 80))"; exit 2 ;;
esac

BEFORE=$(wc -l < "$LOG")

# split the single-line feed into per-item chunks (split BEFORE <item> so each
# chunk is exactly one item; the channel-header chunk is dropped by the case filter)
printf '%s' "$RAW" | sed 's/<item>/\n<item>/g' | while IFS= read -r item; do
  case "$item" in *"<item"*) ;; *) continue ;; esac

  title=$(printf '%s' "$item" | grep -o '<title><!\[CDATA\[.*\]\]></title>' | head -1 \
          | sed -e 's/^<title><!\[CDATA\[//' -e 's/\]\]><\/title>$//')
  link=$(printf '%s' "$item" | grep -o '<link>[^<]*</link>' | head -1 \
         | sed -e 's/^<link>//' -e 's/<\/link>$//')
  pub=$(printf '%s' "$item" | grep -o '<pubDate>[^<]*</pubDate>' | head -1 \
        | sed -e 's/^<pubDate>//' -e 's/<\/pubDate>$//')
  cat=$(printf '%s' "$item" | grep -o '<category><!\[CDATA\[.*\]\]></category>' | head -1 \
        | sed -e 's/^<category><!\[CDATA\[//' -e 's/\]\]><\/category>$//')

  [ -n "$link" ] || continue
  grep -qF "$link" "$LOG" 2>/dev/null && continue

  NOW=$(TZ="Asia/Jakarta" date +"%Y-%m-%d %H:%M:%S")
  printf '%s\t%s\t%s\t%s\t%s\n' "$NOW" "$title" "$link" "$pub" "$cat" >> "$LOG"
  echo "  NEW [$cat] $title"
  echo "       $pub"
  echo "       $link"
done

AFTER=$(wc -l < "$LOG")
NEW=$((AFTER - BEFORE))
echo ""
echo "==> $NEW new item(s); log: $LOG ($AFTER lines incl. header)"
echo "==> Next: cross-check claimed victims against your own assets, then run"
echo "    tools/breach-check.sh / tools/leak-grep.sh for exposure confirmation."
