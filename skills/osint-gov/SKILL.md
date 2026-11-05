---
name: osint-gov
description: Government and corporate records OSINT skill - sanctions lists, corporate registries, court records, procurement, document leaks (ICIJ/OCCRP), and FOIA-style requests. Includes entity-resolution matching logic for deciding whether records in different registries refer to the same person or company.
---
# OSINT Gov & Corporate Records

## Agent instruction

1. Identify the entity type (person / company) and jurisdiction
2. Query official sources one at a time, recording official identifiers (registry ID, LEI, tax ID, case number)
3. Match records across sources with MATCHING LOGIC below - a shared name is not evidence
4. Output: entity profile + officer network + sanctions flags, each link tiered

## 1. Sanctions & watchlists

- OFAC SDN list (US), EU consolidated list, UN Security Council list, UK OFSI
- Match: exact name + aliases + fuzzy (names get transliterated differently)
- Output: listed/unlisted status, program, listing date, identifiers (DOB, passport, address where present)

## 2. Corporate registry

- OpenCorporates (multi-country), SEC EDGAR (US filings + full-text search), local registries
- Look for: officers/directors, registered address, filing history, active/inactive status
- Pivot: officer name -> person (osint-web2), address -> cluster of related companies

## 3. Court & legal records

- CourtListener (US, free), PACER (paid), local registries
- Look for: party names, case numbers, case type (civil/criminal/bankruptcy), outcome
- Careful: an ongoing case is not an adjudicated fact; record the status

## 4. Procurement & tenders

- SAM.gov (US federal), EU TED, local tender portals
- Use: vendor ownership, government contracts, addresses, contract values

## 5. Document leaks & investigative databases

- ICIJ Offshore Leaks (Panama Papers, Pandora Papers etc.) - search entity/officer/intermediary
- OCCRP Aleph - search documents and investigative datasets
- Use: hidden ownership, addresses, entity relationships

## 6. FOIA / public information requests

- US FOIA + state-level public records; every country has an equivalent
- Process: identify the agency -> draft the request -> track. Useful for documents not published online

## MATCHING LOGIC - entity resolution (is this record the same person/company?)

### Persons

| Signal | Tier | Note |
|---|---|---|
| Same official ID (NPWP, last-4 SSN, passport no.) | CONFIRMED | official identifiers are durable |
| Name + DOB exact | STRONG | a rare DOB is a strong discriminator |
| Name + exact street address | STRONG | |
| Officer at the same company + same period | STRONG | combination |
| Exact name + city | MEDIUM | common names = weak |
| Fuzzy name (transliteration: Muhammad/Mohamed/Mohammad, Wong/Wan) | MEDIUM | check aliases and DOB |
| Name only | WEAK | not a signal |
| Email/phone in a filing matches the target's | STRONG | |

### Companies

| Signal | Tier | Note |
|---|---|---|
| Same company number / registry ID | CONFIRMED | |
| Same LEI | CONFIRMED | |
| Name + exact registered address | STRONG | |
| Officer set overlap >= 50% + same period | STRONG | |
| Similar name | WEAK | company names repeat across cities |
| Same domain/email pattern | MEDIUM | |

### Verdict rules

- confirmed: same official identifier (registry ID / LEI / DOB+ID)
- probable: >= 2 STRONG (name+DOB+address, or officer+period+address)
- possible: 1 STRONG or fuzzy name + common attributes
- rejected: different registry IDs (different entities), DOB beyond error margin, officer periods with zero overlap

### Common traps

- Same person name in different countries/cities - always check jurisdiction
- Company renames/mergers: different name, same registry ID = confirmed
- Spouses/family sharing an address - do not auto-merge
- Nominee officers (lent names) - the official record is true but control lies elsewhere
- Arabic/Chinese/Indian name transliteration creates false matches

## Evidence

Record: official source, document/filing number, date, PDF hash. Assign confidence: official registry = high; search engines/aggregators = re-verify against the primary source.