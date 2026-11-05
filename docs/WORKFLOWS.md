# Scenario Workflows

All workflows: OPSEC -> domain skill -> correlation -> evidence. Every matching claim is tiered (global framework in skills/osint/SKILL.md).

## 1. Full name -> dossier (phone, address, NIK, etc.)

1. osint-opsec: posture + **legal gate** (legal basis for sensitive data?)
2. osint-people Phase 1: candidate discovery (search operators, people-search, registry, social, academic)
3. Phase 2 enrichment per candidate: phone (people-search/breach/public documents), address (registry/court/documents), employment, digital footprint, official identifiers (LEGAL CHANNEL ONLY for NIK)
4. Phase 3 matching logic: tier each attribute, verdict per candidate
5. If other identifiers surface (email/phone/username): connect them via osint-correlation
6. Output: dossier using the template (verdict summary, tiered per-candidate profile, hashed evidence, next steps)

## 2. Email -> accounts & exposure

1. osint-opsec: prepare posture
2. osint-web2: validity/MX -> gravatar -> GitHub search
3. osint-leak: breach search (k-anonymity) -> record breach names + fields
4. osint-gov: corporate email -> domain -> registry
5. Output: tiered account list, exposure status, related entities

## 3. Username (non-X) -> person

1. osint-web2: `bash tools/username-hunt.sh <username>`
2. Verify each match manually (false positives)
3. osint-geo: profile photo -> reverse search
4. osint-leak: does the handle appear in pastes/dumps?
5. Output: platform map -> candidate identity (confidence per platform)

## 4. X username -> history & identity

1. osint-opsec: prepare posture (archive phase is passive)
2. osint-x Entry A: baseline current profile (display name, bio, join date, avatar hash, pinned)
3. `bash tools/x-history.sh <handle>` -> archived snapshots
4. Build the timeline: date | handle | display name | bio | avatar | link | source
5. Detect changes: bio changes; different handles -> check the USER ID (`pbs.twimg.com/profile_images/<USER_ID>/...`); old tweet -> current authorship
6. Old handle -> `bash tools/x-history.sh <old-handle>` -> extend the timeline
7. Pivot: bio link -> osint-web2, avatar -> osint-geo, crypto handle -> osint-web3
8. Output: timeline + change list with date bounds + evidence

## 5. Real name -> X account (no starting handle)

1. osint-x Entry B: candidates (`"Full Name" site:x.com`, Google/Bing, people search)
2. Baseline each candidate (profile + archives)
3. Matching logic: CONFIRMED (same user ID / old tweet -> authorship), STRONG (avatar, bio/link, follower graph, join date)
4. Verdict per candidate; probable+ -> continue with workflow #4
5. Output: candidate x signal x verdict table

## 6. Leak/breach exposure check for owned assets

1. osint-leak self-monitoring: `bash tools/breach-check.sh <email>` + paste sites + crt.sh
2. MATCHING LOGIC: hash match = confirmed; name alone = possible
3. If exposed: rotate credentials, check the scope
4. Document the timeline + actions taken

## 7. Breach data -> person details (enrichment)

1. Legal gate: documented basis for processing third-party PII
2. osint-leak section 2: extract fields (email, phone, address, DOB, IDs) from records
3. Validate before use: phone via carrier lookup, address via registry/public docs, email via deliverability
4. Freshness + dedupe: check breach dates, count each record once
5. MATCHING LOGIC before attributing any record to the target
6. Output: enrichment rows with tiers + sources + legal-basis note

## 8. Company -> official profile

1. osint-gov: registry (officers, address, filings) -> sanctions check
2. osint-web2: domain footprint, email pattern
3. osint-gov: procurement/tender history
4. Output: entity profile + officer network + sanctions flags (tiered)

## 9. Photo -> location

1. osint-geo: EXIF -> reverse image (Lens, Yandex, TinEye)
2. Geolocation reasoning: shadows, signage, vehicles, vegetation
3. Verify 2+ independent features in Mapillary/Sentinel
4. Output: coordinates + comparison features + confidence

## 10. Two X handles -> same person?

1. Baseline both handles (profile + archives)
2. Find the user ID of both handles
3. Same ID -> confirmed; different ID + strong signals -> probable
4. Output: verdict + signal table + evidence

## 11. Multi-identifier -> one identity (correlation)

1. Collect attributes for each identifier via the domain skills
2. osint-correlation: find bridge identifiers (gravatar, ENS, breach record, personal link)
3. Build the graph: nodes = identifiers, edges = tiered evidence
4. Path strength = weakest edge; cluster = nodes connected by >= probable paths
5. Check hard contradictions
6. Output: graph + verdict per cluster + contradiction list + next pivots