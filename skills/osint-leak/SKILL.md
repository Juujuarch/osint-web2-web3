---
name: osint-leak
description: Data leak and breach exposure OSINT skill - k-anonymity breach search, leak-record enrichment (phone/address/IDs), paste and combolist awareness, darknet market watch, and self-monitoring. Includes matching logic for deciding whether a leak record actually refers to the target, and a legal gate for third-party personal data.
---
# OSINT Data Leak & Breach

This skill turns breach/leak data into usable intelligence: confirming exposure, enriching a person profile with details that appear in leaks, and monitoring owned assets. It covers methods, sources, matching logic, and legal gating.

## Agent instruction

1. Legal gate (see below) - especially for third-party targets
2. Breach search with k-anonymity (tools/breach-check.sh) - never send full identifiers to untrusted services
3. If a record matches: run MATCHING LOGIC before attributing it to the target
4. Enrichment: extract fields, check freshness, dedupe
5. Output: exposure status (tiered) + field scope + recommended action

## Legal gate (read first)

- Breach data contains third-party PII. Processing it has the same legal frame as any PII processing (Indonesia UU PDP No. 27/2022, EU GDPR Art. 6/9)
- Always allowed: checking **your own** identifiers
- Third-party lookups need a documented basis: written authorization, clear public interest (journalism, fraud reporting to authorities), or legal process
- National ID numbers (NIK), biometrics, health data = sensitive personal data - stricter basis required
- Prefer k-anonymity and commercial services with ToS over downloading full leaked databases; if you must handle a dump, isolate it and minimize what you keep

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

### Enrichment rules

1. **Extract, don't hoard**: copy only the fields the investigation needs into the dossier; keep the rest out
2. **Freshness check**: a phone/address from a 2013 breach may be stale - look for newer records before relying on it
3. **Dedupe**: the same record circulates in many combolists; count it once, note all sources
4. **Validate before use**: phone via carrier lookup, address via registry/public docs, email via deliverability - a leak value is a lead, not a fact
5. **Attribute with matching logic**: a leak row only belongs to your target if the match clears the tiers below

## 3. Paste & public dumps

- Paste sites: search via engine operators (`site:pastebin.com "domain"`), paste-monitoring APIs (see docs/SOURCES.md)
- If a relevant dump is found: record URL + timestamp, hash the file if downloaded, analyze offline in an isolated VM (dumps are malware vectors)

## 4. Combolist awareness

- Purpose: know whether the target's email/username appears in circulating combolists (indicates credential exposure)
- NEVER use combolists for login attempts against others' accounts - that is credential stuffing, illegal in most jurisdictions
- If your own credentials appear: rotate everywhere they were reused, enable MFA, don't just change one password

## 5. Darknet market watch

- Tor only, dedicated VM, full OPSEC (see osint-opsec)
- Focus: listings selling the target's data, actor profiles, reputation, sample validity
- Many listings are fabricated or repackaged old data - treat samples as leads and validate
- No transactions or direct actor communication without legal basis and explicit authorization

## 6. Self-monitoring (owned assets)

- Monitor: breach DBs, paste sites, certificate transparency (unexpected subdomains = compromise indicator)
- Schedule periodic runs of tools/breach-check.sh against your own identifiers; diff and archive results hashed

## MATCHING LOGIC - does this leak record belong to the target?

| Signal | Tier | Note |
|---|---|---|
| Password hash matches your own hash (k-anonymity full match) | KONFIRMASI | own assets only |
| National ID (NIK) match via legal channel | KONFIRMASI | legal gate |
| Exact rare email (corporate, custom domain) | KUAT | generic gmail/yahoo = downgrade |
| Exact phone | KUAT | numbers get recycled - check breach date vs usage period |
| Name + DOB + city combo | KUAT | rare combination |
| Name + city only | SEDANG | common names are noise |
| Username/handle in record | SEDANG | corroborate with other fields |
| Name only | LEMAH | never sufficient |

Verdict rules: confirmed (>=1 KONFIRMASI) / probable (>=2 KUAT) / possible (1 KUAT or >=2 SEDANG) / rejected (contradiction).

Contradiction checks:
- Breach date BEFORE the identifier existed in the target's hands (e.g. 2013 breach, email created 2020) = rejected
- Record location contradicts verified current location without any move evidence = downgrade + flag

Common traps:
- Common names in big breaches (Budi, Siti, John Smith) - not evidence
- Gmail dot-variations (john.doe vs johndoe) - different accounts
- Records from previous owners of an email/number
- Fabricated data sold on darknet markets (a significant share of listings is fake or re-dated)

## Evidence & handling

- All artifacts (screenshots, dump files) hashed (SHA-256) and stored encrypted
- Report format: "identifier X exposed in breach Y (date Z), fields A/B" - never the record contents
- This repo is public: NEVER store investigation results here