---
name: osint-web2
description: Web2 OSINT skill for identifiers - email, username/handle, phone, person name, business entity, and domain/IP. Use when pivoting from one web2 identifier to accounts, profiles, ownership, and infrastructure, with explicit sources, matching logic, and evidence capture. For X/Twitter-specific work use osint-x; for full-name dossiers use osint-people.
---
# OSINT Web2

Note: if the identifier is an **X handle or a real name whose main target is on X**, use skills/osint-x/SKILL.md - it has username change, bio change, and matching logic. For full-name dossiers use skills/osint-people/SKILL.md. This skill covers general web2. To connect 2+ identifiers across domains, use skills/osint-correlation/SKILL.md.

## Agent instruction

1. Baseline the identifier (searchable attributes)
2. Quick sweep first: `bash tools/person-hunt.sh <username>` (or `--name "Full Name"`) - keyless profile-existence check on github / x / keybase / steam / tiktok (+ instagram when not rate-limited), with handle-candidate generation in name mode
3. Pivot one at a time: email -> accounts, username -> platforms, phone -> carrier/accounts, name -> profiles
4. Tier every match using the global framework (skills/osint/SKILL.md)
5. Output: tiered match list + evidence + next pivots

## Email

Order: validity -> exposure -> accounts -> entity.

1. Validity & deliverability: format/MX check, then verification services (sources: docs/SOURCES.md and docs/API-CATALOG.md)
2. Exposure: proceed to osint-leak (breach search) - just learn "exposed or not", do not hunt passwords
3. Accounts: gravatar hash (MD5 email -> avatar URL), GitHub user search, historical whois containing the email
4. Entity: corporate email -> domain -> registry (borrow osint-gov)

## Username / handle (non-X)

Backend: blackbird (600+ platforms, WhatsMyName-based).

```bash
bash tools/username-hunt.sh <username>
```

- Record matching platforms + profile URLs
- Pivot: bio/photo -> osint-geo; same handle on crypto platforms -> osint-web3
- If the handle is on X -> switch to osint-x (needs history + matching logic)
- False positives happen: verify every match manually before treating it as one person

## Phone

- Line type (mobile/voip/fixed), carrier, country (sources: docs/API-CATALOG.md, phone category)
- Pivot: number -> chat/social accounts via "search by phone" features (needs OPSEC, see osint-opsec)
- Never assume number = identity; numbers get recycled

## Person name (outside X)

- Search engines with operators: `"name" site:linkedin.com`, `"name" filetype:pdf`, spelling variants
- Public profiles -> photo -> osint-geo
- If the main target is on X: use osint-x Entry B (real name -> candidate accounts -> matching logic)
- Name + country clear -> osint-gov (directorship registry, court records)

## Domain / IP / DNS

Backend: tools/domain-recon.sh + reconspider (optional).

1. whois (including historical)
2. Subdomains: crt.sh certificate transparency
3. Tech fingerprint: response headers, favicon hash, JS bundle (for offensive context, continue with the recon skills in hack-skills)
4. Infrastructure: reverse DNS, ASN, neighboring netblocks

## Entity / company

- Corporate registry: osint-gov
- Footprint: domain, email pattern, public employees
- Documents: filings, pitch decks, tenders - often leak as searchable PDFs

## MATCHING LOGIC - identifier -> account/person

### Signal table

| Signal | Tier | Note |
|---|---|---|
| Gravatar hash match across platforms (same email) | CONFIRMED-strong | MD5 email -> identical avatar URL strongly implies same email |
| Email verified on profile (not just bio text) | STRONG | requires verification evidence (reset flow, notification) |
| Avatar perceptual hash match across platforms | STRONG | compare p-hash, not exact bytes |
| Same personal link/domain in bios on 2+ platforms | STRONG | rare links are strong signals |
| Exact username on a niche platform | MEDIUM | common platforms = weak |
| Follower/following graph overlap | STRONG | look at the top 10-20 mutuals |
| Display name + city + profession match | MEDIUM | common combination |
| Bio text overlap > 50% | MEDIUM | copy-paste bios are common |
| Posting hours & language style | SUPPORTING | only in combination |
| Similar handle | WEAK | handles can be bought/squatted |

### Verdict rules

- confirmed: gravatar match / verified email
- probable: >= 2 STRONG (e.g. avatar pHash + personal link)
- possible: 1 STRONG or >= 2 MEDIUM
- rejected: different gravatar + join dates far apart + zero follower graph overlap

### Common traps

- Corporate emails reused after an employee leaves
- Phone numbers recycled by carriers
- Common names (not a signal)
- Popular culture handles chased by many people (similar handle != relationship)

## Evidence

Every finding requires: source URL, UTC access time, screenshot hash when the page can change. Store outside this repo - this repo is public.