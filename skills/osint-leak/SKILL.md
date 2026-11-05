---
name: osint-leak
description: Data leak and breach exposure OSINT skill - k-anonymity breach search, leak-record enrichment, combolist and stealer-log exposure (Lumma/RedLine/Vidar/MetaStealer), leak forums and shops, telegram leak-channel watch, darknet market watch, local dataset query, and self-monitoring. Includes matching logic for deciding whether a leak record actually refers to the target, and a legal gate for third-party personal data.
---
# OSINT Data Leak & Breach

This skill turns breach/leak data into usable intelligence: confirming exposure, enriching a person profile with details that appear in leaks, and monitoring owned assets. It covers methods, sources, matching logic, and legal gating.

## Agent instruction

1. Legal gate (see below) - especially for third-party targets
2. Breach search with k-anonymity (tools/breach-check.sh) - never send full identifiers to untrusted services
3. Local dataset query if you hold a dump (tools/leak-grep.sh) - masked by default
4. If a record matches: run MATCHING LOGIC before attributing it to the target
5. Enrichment: extract fields, check freshness, dedupe
6. Output: exposure status (tiered) + field scope + recommended action

## Legal gate (read first)

- Breach data contains third-party PII. Processing it has the same legal frame as any PII processing (Indonesia UU PDP No. 27/2022, EU GDPR Art. 6/9)
- Always allowed: checking **your own** identifiers
- Third-party lookups need a documented basis: written authorization, clear public interest (journalism, fraud reporting to authorities), or legal process
- National ID numbers (NIK), biometrics, health data = sensitive personal data - stricter basis required
- Hard rule for everything below: leak data is for **exposure confirmation and defense**. Using stolen credentials to access any account you do not own is credential stuffing / unauthorized access - illegal in effectively every jurisdiction, no matter how the data was obtained
- Prefer k-anonymity and commercial services with ToS over downloading full leaked databases; if you must handle a dump, isolate it (offline VM, no network) and minimize what you keep

## 1. Breach search (k-anonymity)

K-anonymity model: only the first 5 hex chars of the SHA-1 hash are sent to the service; matching suffixes are checked locally. The full identifier never leaves your machine.

```bash
bash tools/breach-check.sh <email-or-identifier>
```

What to record per hit: breach name, breach date, exposed fields (email / password hash / phone / address / IP), and whether the record is verified or unverified.

## 2. Leak-record enrichment (getting details from leaks)

When investigating a person (see osint-people), breach records are a high-yield source for fields that are not public elsewhere.

### Field map (what to extract and how to use it)

| Field in leak | Use in dossier | Typical tier when matched |
|---|---|---|
| email | contact point, pivot to accounts | KUAT (if non-generic domain) |
| phone | contact point, carrier lookup (osint-web2) | KUAT |
| full name + DOB | identity confirmation | KUAT (combo), KONFIRMASI if ID included |
| physical address | address history | KUAT |
| national ID (NIK/passport) | identity confirmation | KONFIRMASI only via legal channel |
| password hash | confirms exposure scope; never crack others' creds | KONFIRMASI for own assets |
| IP address | rough location at time of leak | PENDUKUNG |
| username/handle | pivot to osint-web2 / osint-x | SEDANG |
| autofill block (name+addr+phone+email) | identity confirmation | KUAT (combo) |
| session cookie / token | confirms account takeover risk | KONFIRMASI for own assets |

### Enrichment rules

1. **Extract, don't hoard**: copy only the fields the investigation needs into the dossier; keep the rest out
2. **Freshness check**: a phone/address from a 2013 breach may be stale - look for newer records before relying on it
3. **Dedupe**: the same record circulates in many combolists; count it once, note all sources
4. **Validate before use**: phone via carrier lookup, address via registry/public docs, email via deliverability - a leak value is a lead, not a fact
5. **Attribute with matching logic**: a leak row only belongs to your target if the match clears the tiers below

## 3. Paste & public dumps

- Paste sites: search via engine operators (`site:pastebin.com "domain"`), paste-monitoring APIs (see docs/SOURCES.md)
- If a relevant dump is found: record URL + timestamp, hash the file if downloaded, analyze offline in an isolated VM (dumps are malware vectors)

## 4. Combolist & stealer-log exposure

This is where most real-world credential exposure actually lives - not in "breaches" that get press, but in continuous criminal trade of stolen data.

### What circulates

| Product | Contents | Typical abuse |
|---|---|---|
| Combolist (`email:pass`) | credential pairs from many breaches, deduped, sold by the million | credential stuffing |
| Stealer log (LummaC2, RedLine, Vidar, MetaStealer, RisePro, Stealc, Mars) | per-machine archive: saved browser creds (URL/login/pass), **cookies (session hijack)**, autofill (name/address/phone/card), crypto wallet files + exchange API keys, FTP/VPN/RDP creds, Telegram `tdata` sessions, Discord tokens, game sessions, screenshots, machine info (HWID, OS, installed software) | account takeover, wallet drain, lateral movement |
| Cloud/CI dumps | `.env` files, AWS keys, npm/PyPI tokens, kubeconfigs from exposed S3 buckets, GitHub leaks, CI logs | infra takeover, supply-chain |
| Fresh vs stale | "fresh logs" (hours old, cookies valid) priced 10-100x higher than recycled combos | - |

### Exposure check (defensive use)

1. Known breaches: `bash tools/breach-check.sh <email>` (k-anonymity)
2. Own passwords: check against the Pwned Passwords API (k-anonymity hash prefix) - never send the full password anywhere
3. Local dump you legitimately hold: `bash tools/leak-grep.sh <identifier> [dataset-dir]` - masked by default, `--show` for full lines
4. Session risk: cookies in a stealer log bypass MFA entirely - password rotation alone is insufficient, **invalidate all sessions** (log out everywhere) and rotate tokens/API keys
5. Wallet risk: any stealer log containing wallet files or seed material for an address you own = treat the wallet as compromised, move assets to a fresh key

### Where it is traded (awareness & monitoring only)

- Leak forums (exploit.in, XSS.is, BreachForums-style clearnet/mirror sites), telegram shop channels, automated "log shops" with API + balance top-up
- Initial-access brokers (IAB) selling corporate VPN/RDP/SSO access, RaaS affiliate channels recruiting insiders
- Signals worth recording: claimed breach name, sample validity (validate - see traps), price, actor reputation, payment method (usually crypto), contact handle
- No purchases, no actor contact, no downloads without legal basis and explicit authorization - shop panels serve malware to non-buyers

## 5. Darknet market watch

- Tor only, dedicated VM, full OPSEC (see osint-opsec)
- Focus: listings selling the target's data, actor profiles, reputation, sample validity
- Many listings are fabricated or repackaged old data - treat samples as leads and validate
- No transactions or direct actor communication without legal basis and explicit authorization

## 6. Local leak-dataset query

```bash
bash tools/leak-grep.sh <identifier> [dataset-dir] [--show]
```

- Dataset dir defaults to `leaks/` (gitignored). Supports `.txt/.csv/.tsv/.gz/.log`; extract `.zip/.7z` first
- Default output is masked (file + line number + hit count); `--show` prints full lines - only in an isolated environment
- Classifies the identifier (email / wallet / phone / domain / username) for reporting; matching is literal and case-insensitive
- Report lands in `out/leak-grep/` (gitignored) - move findings into the case file, never into this repo

## 7. Self-monitoring (owned assets)

- Monitor: breach DBs, paste sites, certificate transparency (unexpected subdomains = compromise indicator)
- Schedule periodic runs of tools/breach-check.sh against your own identifiers; diff and archive results hashed
- For orgs: canary tokens in likely leak paths (fake creds in a decoy vault), then watch for them appearing in combolists

## MATCHING LOGIC - does this leak record belong to the target?

| Signal | Tier | Note |
|---|---|---|
| Password hash matches your own hash (k-anonymity full match) | KONFIRMASI | own assets only |
| Session cookie / token for your own account | KONFIRMASI | own assets only |
| National ID (NIK) match via legal channel | KONFIRMASI | legal gate |
| Exact rare email (corporate, custom domain) | KUAT | generic gmail/yahoo = downgrade |
| Exact phone | KUAT | numbers get recycled - check breach date vs usage period |
| Name + DOB + city combo | KUAT | rare combination |
| Autofill block (name+addr+phone+email, one machine) | KUAT | multi-field co-occurrence |
| Saved-credential entry for a rare domain | KUAT | e.g. corporate VPN, niche forum |
| Name + city only | SEDANG | common names are noise |
| Username/handle in record | SEDANG | corroborate with other fields |
| Machine HWID + local username | PENDUKUNG | common on shared/family machines |
| Name only | LEMAH | never sufficient |

Verdict rules: confirmed (>=1 KONFIRMASI) / probable (>=2 KUAT) / possible (1 KUAT or >=2 SEDANG) / rejected (contradiction).

Contradiction checks:
- Breach date BEFORE the identifier existed in the target's hands (e.g. 2013 breach, email created 2020) = rejected
- Record location contradicts verified current location without any move evidence = downgrade + flag
- Log capture timestamp after the target's documented credential rotation = stale, downgrade

Common traps:
- Common names in big breaches (Budi, Siti, John Smith) - not evidence
- Gmail dot-variations (john.doe vs johndoe) - different accounts
- Records from previous owners of an email/number
- Fabricated data sold on darknet markets and telegram shops (a significant share of listings is fake or re-dated)
- Stealer logs from shared/family/cafe machines - the machine owner is not the credential owner
- Re-dumped old breaches sold as "fresh 2026 database" - check the newest record date inside

## Evidence & handling

- All artifacts (screenshots, dump files) hashed (SHA-256) and stored encrypted
- Report format: "identifier X exposed in breach Y (date Z), fields A/B" - never the record contents
- This repo is public: NEVER store investigation results here
