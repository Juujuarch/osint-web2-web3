#!/usr/bin/env bash
# Recon ringan domain: whois, DNS, subdomain (crt.sh), headers
# Usage: bash tools/domain-recon.sh <domain>
set -euo pipefail

[ $# -ge 1 ] || { echo "Usage: bash tools/domain-recon.sh <domain>"; exit 1; }
DOMAIN="$1"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/domain-$DOMAIN"
mkdir -p "$OUT"

echo "==> WHOIS"
whois "$DOMAIN" 2>/dev/null | tee "$OUT/whois.txt" || echo "  (whois gagal / tidak ada)"

echo "==> DNS records"
for r in A AAAA MX NS TXT; do
  echo "--- $r"
  dig +short "$r" "$DOMAIN" 2>/dev/null | tee -a "$OUT/dns.txt" || echo "  (dig gagal)"
done

echo "==> Subdomain via crt.sh (certificate transparency)"
curl -sS "https://crt.sh/?q=%25.$DOMAIN&output=json" \
  | tr ',' '\n' | grep -o '"name_value":"[^"]*"' | cut -d'"' -f4 \
  | sort -u | tee "$OUT/subdomains.txt" || echo "  (crt.sh gagal)"

echo "==> HTTP headers"
curl -sS -I -L --max-time 15 "https://$DOMAIN" 2>/dev/null | tee "$OUT/headers.txt" || echo "  (https gagal, coba http)"

echo "==> Selesai. Output di: $OUT"