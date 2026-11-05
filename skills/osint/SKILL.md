---
name: osint
description: Entry-point router for any OSINT task across web2 and web3. Use at the start of an investigation to map the starting identifier (email, username, phone, domain, wallet, photo, full name, X handle) to the right domain skill, and to apply the global confidence framework to every match.
---
# OSINT Router

Single entry point for all investigations. The router's job: pick the domain skill, sources, and step order - and enforce the confidence framework for every matching claim.

## GLOBAL CONFIDENCE FRAMEWORK (applies to ALL skills)

Every claim "A = B" or "A belongs to person X" MUST use these tiers. Without a tier, a claim is not a finding.

### Signal tiers

| Tier | Definition | Examples |
|---|---|---|
| **CONFIRMED** | immutable identifier identical | X numeric user ID, tweet ID -> authorship, wallet signature, GPS EXIF, registry ID (NPWP/LEI/company number), credential hash match |
| **STRONG** | rare attribute match | avatar perceptual hash, personal link/domain, follower graph overlap, join date, ENS, exact street address |
| **MEDIUM** | common attribute match | display name, bio text overlap, name + city, phone carrier |
| **SUPPORTING** | behavioral pattern | writing style, posting hours, tx timing, round-number amounts |
| **WEAK** | surface similarity | similar handle, common name, "looks like them" |

### Verdict rules

| Verdict | Requirement |
|---|---|
| **confirmed** | >= 1 CONFIRMED signal, no contradiction |
| **probable** | >= 2 STRONG signals, no contradiction |
| **possible** | 1 STRONG, or >= 2 MEDIUM, or MEDIUM + SUPPORTING combination |
| **rejected** | a hard contradiction exists (different immutable ID, dates far apart, zero graph overlap) |

### Contradiction rules

1. One hard contradiction = rejected, regardless of positive signals
2. Soft contradiction (e.g. different timezone) = downgrade one tier and record it
3. An untiered claim is not a finding and does not enter the report
4. A "possible" result is reported as a hypothesis + signal list + what would confirm or refute it

## Routing map

| You have | First skill | Follow-up skills |
|---|---|---|
| **Full name (need dossier: phone/address/etc.)** | **osint-people** | osint-web2, osint-gov, osint-x, osint-leak |
| Email | osint-web2 | osint-leak (breach), osint-gov (entity) |
| Username/handle (non-X) | osint-web2 | osint-geo (profile photo), osint-leak |
| X username / handle | osint-x | osint-geo (avatar), osint-leak, osint-web3 |
| Phone number | osint-web2 | osint-gov, osint-people (back to the person) |
| Company/domain | osint-web2 | osint-gov |
| Wallet address | osint-web3 | osint-leak, osint-web2 |
| Token/NFT contract | osint-web3 | osint-gov |
| Photo/image | osint-geo | osint-x / osint-web2 / osint-people |
| Leaked file / dump | osint-leak | osint-opsec (handling) |
| 2+ identifiers to connect | osint-correlation | respective domain skills |

## Standing rules

1. Read-only first. The initial phase never requires login and leaves no trace on the target side.
2. OPSEC before expansion. As soon as the investigation touches a real target identity, read skills/osint-opsec/SKILL.md first.
3. Evidence-first. Every finding: source URL, UTC timestamp, file hash where applicable.
4. One pivot per step. From one identifier, expand to one hypothesis; record, then continue.
5. Every matching claim uses the framework above. No tier = not a finding.
6. **Legal gate** for sensitive identifiers (NIK, biometrics, health data): read the Legal boundary section of skills/osint-people/SKILL.md.
7. Stop in legal grey zones. If the next step needs non-public data without a legal basis, stop and document.

## Standard flow

```
START (identifier)
  -> osint-opsec        : prepare posture (VM / profile / network)
  -> domain skill       : extract attributes + first pivot
  -> osint-correlation  : if 2+ identifiers, build graph + verdict
  -> cross-domain       : borrow other skills per the routing map
  -> osint-opsec        : store hashed evidence, clean up work traces
END (report: tiered findings + evidence + verdict + confidence)
```

## Anti-patterns

- Starting from a tool without a hypothesis
- Using personal accounts to search sensitive targets
- Storing investigation results in auto-syncing cloud folders
- Claiming "A = B" without a CONFIRMED-tier signal
- Merging usernames into one person just because handles look alike
- Processing NIK/sensitive data without documenting the legal basis