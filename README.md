# OSINT WEB2 & WEB3

An OSINT (Open-Source Intelligence) skill suite for **web2** investigations (email, phone, username, people, entity, domain), **X/Twitter** (username change, bio change, matching logic), **data leak / breach** exposure and enrichment, **web3** (wallet attribution, clustering, cross-chain pivot), **gov & corporate records**, **GEOINT**, **cross-domain correlation**, and **OPSEC**.

Designed as an **agent skill set**: every skill has `name` + `description` frontmatter (triggers), an agent instruction block, detailed methodology, and a **MATCHING LOGIC** section with signal tiers. All skills share one global confidence framework.

Design principle: **router -> domain skill -> backend tool**. One entry point (`osint`), each domain has an explicit workflow and sources, optional backend tools installed separately, and no credentials are ever stored in this repo.

## Repository layout

| Path | Function |
|---|---|
| `skills/osint/` | Router + **global confidence framework** |
| `skills/osint-people/` | Full name -> dossier: phone, address, employment, official IDs (legal-gated) |
| `skills/osint-x/` | X/Twitter: username change, bio change, matching logic |
| `skills/osint-web2/` | Identity & web: email, phone, username, people, entity, domain |
| `skills/osint-web3/` | On-chain: wallet attribution, clustering, cross-chain (read-only) |
| `skills/osint-leak/` | Breach exposure, k-anonymity search, leak enrichment, combolist, darknet |
| `skills/osint-gov/` | Sanctions, corporate registry, court records, procurement, document leaks |
| `skills/osint-geo/` | Reverse image search, face search, geolocation |
| `skills/osint-opsec/` | Attribution hygiene, sock puppets, evidence chain, counter-matching |
| `skills/osint-correlation/` | Cross-domain matching: bridge identifiers, graph, verdicts |
| `skills/osint-telegram/` | Telegram & Discord: immutable ID anchors, username history, channel enumeration, message archaeology |
| `tools/` | Backend installer, wrappers, secret scanner, X history, breach check, local leak-dataset query, API catalog sync |
| `docs/` | Scenario workflows, source list, API catalog |

## Confidence framework (core of every skill)

Every claim "A = B" must be tiered:

| Tier | Meaning | Examples |
|---|---|---|
| KONFIRMASI (CONFIRMED signal) | immutable identifier identical | X user ID, tweet ID -> authorship, GPS EXIF, registry ID, hash match |
| KUAT (STRONG) | rare attribute match | avatar perceptual hash, personal link, follower graph overlap, on-chain common-input |
| SEDANG (MEDIUM) | common attribute match | display name, bio overlap, name + city |
| PENDUKUNG (SUPPORTING) | behavioral pattern | writing style, posting hours, tx timing |
| LEMAH (WEAK) | surface similarity | similar handle, common name |

Verdicts: **confirmed** (>=1 CONFIRMED signal) / **probable** (>=2 STRONG) / **possible** (1 STRONG or >=2 MEDIUM) / **rejected** (hard contradiction). An untiered claim is not a finding.

## Quick start

```bash
# optional backends (blackbird = username/email, reconspider = IP/domain/org)
bash tools/install-backends.sh

# ready-to-use wrappers
bash tools/username-hunt.sh <username>      # search a username across 600+ platforms
bash tools/person-hunt.sh <username>        # keyless profile check: github/x/keybase/steam/tiktok (+IG)
bash tools/person-hunt.sh --name "Full Name" # name -> handle candidates -> same checks
bash tools/agent-reach.sh web <query>      # Exa web search / yt / rd / ig / tw / read (Agent-Reach)
bash tools/domain-recon.sh <domain>         # whois/DNS/subdomains/headers
bash tools/x-history.sh <handle>            # X profile history via public archives
HIBP_KEY=... bash tools/breach-check.sh <email>   # email -> breach list (HIBP API key)
bash tools/breach-check.sh '<password>' --pass    # password exposure (k-anonymity, keyless)
bash tools/leak-grep.sh <identifier> [dir]  # query a local combolist/stealer-log dataset (masked)
python tools/gen-synthetic-leak.py          # synthetic combolist/stealer/breach dataset (validation)
bash tools/leak-news-watch.sh               # darknet leak-campaign news watch -> out/leak-watch/
bash tools/fetch-breach-catalog.sh          # keyless HIBP breach catalog -> data/ (metadata only)
bash tools/sync-api-catalog.sh              # refresh the API catalog from upstream

# before any commit or push
bash tools/scan-secrets.sh
```

Skills are read directly from `skills/*/SKILL.md` or loaded as a Claude/Codex skill folder.

## Domain skills - overview

### osint (router)
Entry point. Maps the starting identifier (email / username / X handle / wallet / domain / photo / full name) to the right domain skill and sources. Carries the global confidence framework.

### osint-people
Typical case: you only have someone's full name and need a detailed dossier (phone, address, employment, digital footprint, official IDs). Phase 1 candidate discovery -> Phase 2 attribute enrichment -> Phase 3 matching logic. Official IDs (NIK etc.) are legal-gated (UU PDP / GDPR). Output: tiered dossier template.

### osint-correlation
Cross-domain matching logic: bridge identifier table (email <-> handle <-> wallet <-> phone <-> photo), node/edge graph with tiers, path strength = weakest edge, contradiction rules, graph+verdict output format.

### osint-x
Typical case: only an X username or a real name. Immutable numeric user ID, old tweet -> current authorship, Wayback/archive.today archives, bio timeline, matching verdicts confirmed/probable/possible/rejected.

### osint-web2
Email (validity -> exposure -> accounts -> entity), username (blackbird, 600+ platforms), phone, people, domain/IP/DNS, entity. MATCHING LOGIC: gravatar, avatar pHash, personal links, follower graph overlap.

### osint-web3
Wallet attribution (labels, first funding, counterparty, ENS), clustering (common-input, gas funder, deposit pattern, bridge), cross-chain pivot, holder/token graph. Read-only. MATCHING LOGIC: signed message = CONFIRMED signal; tiered attribution verdicts.

### osint-leak
K-anonymity breach search, leak-record enrichment (phone/address/IDs from breach data), paste and combolist awareness, darknet market watch, self-monitoring. MATCHING LOGIC: hash match = CONFIRMED; breach date vs identifier age as contradiction. Legal gate for third-party PII.

### osint-gov
Sanctions (OFAC/EU/UN), corporate registry (OpenCorporates, EDGAR), court records (CourtListener, PACER), procurement (SAM.gov, TED), ICIJ/OCCRP. MATCHING LOGIC: entity resolution - registry ID/LEI = CONFIRMED signal; transliteration and nominee-officer traps.

### osint-geo
Reverse image (Lens, Yandex, TinEye), face search (legal limits), geolocation reasoning (shadows, signage, vehicles, vegetation). MATCHING LOGIC: EXIF GPS = CONFIRMED; sun angle / plate format / vegetation as contradictions.

### osint-opsec
Investigation posture, sock puppets, evidence chain, encrypted storage. **Counter-matching**: audit persona linkability vectors (avatar reuse, stylometry, fingerprint, metadata) before sensitive sessions.

## Backend tools

| Tool | Function | Install |
|---|---|---|
| blackbird | username/email search across 600+ platforms | `bash tools/install-backends.sh` |
| reconspider | IP/email/domain/org scan + dashboard | `bash tools/install-backends.sh` |

This repo never stores API keys - all keys come from environment variables that are gitignored (see `.gitignore`).

## Security

- Read [SECURITY.md](SECURITY.md): credential policy + minimum OPSEC
- `tools/scan-secrets.sh` must pass before any commit/push
- This repo is public: **assume everything in it is readable by anyone**

## Legal & ethics

This suite is for OSINT on targets where you have a legal basis (your own assets, authorized security research, public-interest research, journalism with a public basis). Compliance with platform ToS and local law remains the user's responsibility. See `skills/osint-opsec/SKILL.md`.

## Roadmap

- [x] Skill: telegram/discord channel OSINT
- [ ] Skill: image EXIF/metadata forensics
- [ ] Backend integration: SpiderFoot
- [ ] Investigation report template (evidence-first)

## License

MIT - see [LICENSE](LICENSE).