---
name: osint-people
description: Person deep-dive OSINT skill - from a full name (plus optional city, age, company) build a detailed dossier: contact points, addresses, employment, digital footprint, and identifiers. Includes matching logic for candidate resolution and a mandatory legal gate for sensitive identifiers such as national ID numbers (NIK).
---
# OSINT People (full name -> dossier)

Typical case: you only have someone's **full name** and need the fullest possible profile - phone number, address, employer, digital footprint, official identifiers.

## Agent instruction

1. **Legal gate** (mandatory, before anything else) - see Legal boundary below
2. Phase 1: candidate discovery - who are the people with this name
3. Phase 2: attribute enrichment per candidate (contact, address, work, digital, IDs)
4. Phase 3: matching logic - tier every attribute, verdict per candidate
5. Output a dossier using the template below

## Legal boundary (gate - do not skip)

- **National ID numbers (NIK) and similar = sensitive personal data.** In Indonesia governed by UU PDP No. 27/2022; in the EU by GDPR Article 9. Processing without a legal basis creates legal risk for **you as the processor**, not just the subject.
- Valid bases (at least one): (a) your own data, (b) written authorization from the subject, (c) clearly documented public interest (journalism, fraud reporting to authorities), (d) legal process/contract enforcement
- **Do not use leaked-database mirrors** (free "check NIK by name" services are generally based on the 2023 population-data breach) without a strong legal basis. If unavoidable, document the basis and minimize retention
- KYC/identity-verification APIs (People and documents verification category in docs/API-CATALOG.md: Onfido, Appruve, Surepass etc.) are legal channels but require a commercial contract + subject consent - they are not tools for covert investigation
- If the legal basis is unclear: run phases 1-2 for non-sensitive attributes only, and write "official identifiers: not accessed (legal gate)" in the report

## Entry

- Required: full name (the more complete, the better)
- Optional strengtheners: city/province, approximate age/DOB, employer/institution, or any already-known identifier (username, email, phone) - if present, start from osint-web2/osint-x/osint-correlation and use this skill as enrichment

## Phase 1 - candidate discovery

1. Search engines: `"Full Name"`, `"Full Name" + city`, `"Name" site:linkedin.com`, `"Name" filetype:pdf` (decrees, letters, tenders, certificates), spelling variants and titles
2. People-search aggregators / data brokers (sources: docs/SOURCES.md, People search category)
3. Business registry: name as officer/owner (AHU Online/OpenCorporates/local registry) - often yields address and company
4. Social: LinkedIn, X, Facebook, Instagram via search + `bash tools/username-hunt.sh <name-variant>`
5. Professional/academic: publications, conferences, patents, ORCID, Google Scholar, organization boards
6. Output: candidate list (name variants, city, URLs, attribute summary)

## Phase 2 - attribute enrichment (per candidate)

### Contact
- **Phone**: people-search aggregators, breach records (osint-leak), social bios, public documents (announcements, tenders, registry filings) - cross-check against the candidate's city
- **Email**: gravatar hash, breach records, historical whois, registry filings, document signatures

### Address
- Company registry (registered address), public documents (announcements/tenders/decrees), court records
- Historical addresses: whois, Wayback-archived profile pages, breach records
- Property/land records where public in that jurisdiction

### Employment & affiliation
- LinkedIn, registry officer records, tender winners, press releases, publications, community boards

### Official identifiers (legal gate applies)
- NIK/passport: only via legal channels (contracted KYC API, legal process, or own data)
- If obtained through a legal channel: store encrypted, restrict access, record the legal basis and access date
- In the report: write the status ("verified via legal channel on date X" / "not accessed - legal gate")

### Digital footprint
- username -> osint-web2 (600+ platforms), X handle -> osint-x (handle/bio history), domain -> whois, profile photo -> osint-geo (reverse search + pHash)

### Family & associates (third-party PII - relevance only)
- Registry: co-officers, co-owners, same address; court records: related parties
- Record only what is relevant to the investigation's purpose; do not expand into family without reason

## Phase 3 - matching logic (is this candidate the target?)

Global framework: skills/osint/SKILL.md. People-specific signal table:

| Signal | Tier |
|---|---|
| Official ID (NIK) match via legal channel | CONFIRMED |
| Rare email + exact phone match | STRONG |
| Exact phone + matching city | STRONG |
| Exact address match | STRONG |
| Name + date of birth match | STRONG |
| Avatar pHash matches a social profile | STRONG |
| Name + city | MEDIUM |
| Name + employer | MEDIUM |
| Name only | WEAK |
| Similar username | WEAK |

Verdicts: confirmed / probable / possible / rejected (see global framework). **Common names (Budi, Siti, John Smith) can never be confirmed from the name alone.**

## Output - dossier template

```
# Dossier: <name>
## Summary
- Primary identity verdict: <confirmed/probable/possible> - tier reasoning
- Candidates: N total, M probable+
## Candidate 1 - <name + discriminator> (verdict: probable)
- Contact:
  - phone: <value> [TIER - source, access date]
  - email: <value> [TIER - source]
- Address: <value> [TIER - source, period]
- Employment/affiliation: <value> [source]
- Official identifiers: <legal-gate status / value> [CONFIRMED only via legal channel]
- Digital footprint: <platform: URL> [TIER]
- Photo: <pHash>
- Contradictions: <list / none>
## Candidate 2 ...
## Timeline (if data is sufficient)
## Evidence (URL + UTC timestamp + file hash)
## Recommended next steps
```

## Anti-patterns

- Confirmed from name alone
- Storing NIK/PII from investigations in the repo, chat, or auto-syncing cloud folders
- Using leaked-DB mirrors without documenting the legal basis
- Merging people because they share an address (spouses, siblings, housemates = different people)
- Reporting "their NIK is ..." without a legal channel - write "not yet verified"
- Output without tiers (unauditable)