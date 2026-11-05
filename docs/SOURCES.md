# Source List (curated)

Links to upstream only; nothing vendored. API keys are NEVER stored in this repo - set them via environment variables at runtime.

> **Master API index**: [API-CATALOG.md](API-CATALOG.md) - 243 APIs / 44 categories,
> distilled from [cipher387/API-s-for-OSINT](https://github.com/cipher387/API-s-for-OSINT)
> (CC0 1.0). Refresh: `bash tools/sync-api-catalog.sh`.
> This file adds workflow-specific sources not covered by the generic catalog.

## X / Twitter (history & matching)

| Source | Function |
|---|---|
| Wayback Machine CDX API | profile snapshots over time (twitter.com & x.com) |
| archive.today (archive.ph) | manual snapshots, often user-captured profiles |
| Profile image URL `pbs.twimg.com/profile_images/<USER_ID>/...` | numeric user ID = immutable matching anchor |
| Third-party mirrors (xstalk, sotwe, twstalker, threadreaderapp) | cached profiles, sometimes history |
| X Advanced Search / Google `site:x.com` | old-handle mentions, name-based candidates |
| Old tweet URLs (`/status/<id>`) | authorship follows the current handle = change evidence |

## Email

| Source | Function |
|---|---|
| haveibeenpwned.com/API/ v3 | breach search (needs key; use the range API for k-anonymity) |
| hunter.io | company email patterns (needs key) |
| emailrep.io | email reputation |

## Username / people

| Source | Function |
|---|---|
| blackbird (p1ngul1n0/blackbird) | 600+ platforms, PDF/CSV export |
| whatsmyname (WebBreacher) | username -> profile dataset |
| namechk / checkusernames | quick multi-platform check |

## Phone

| Source | Function |
|---|---|
| numverify / apilayer | carrier + line type by country |
| phoneinfoga (sundowndev) | phone number recon framework |

## Domain / DNS / infra

| Source | Function |
|---|---|
| crt.sh | certificate transparency, subdomains |
| whois / whoishistory | domain ownership, history |
| SecurityTrails | historical DNS (needs key) |
| Shodan / Censys | device & service exposure (needs key) |
| reconspider (bhavsec) | IP/email/domain/org scan + dashboard |

## Breach / leak / darknet

| Source | Function |
|---|---|
| HIBP (range API, k-anonymity) | breach exposure check, no key needed for range endpoint |
| psbdmp / paste scrape | paste monitoring |
| DeHashed / leak-lookup / Snusbase | breach lookup (paid, legal-review first) |
| Ahmia | darknet search (Tor) |

## People search / data broker (name -> profile)

| Source | Function |
|---|---|
| People-search aggregators / data brokers (per country) | name -> phone/address/age |
| Local registries (AHU Online ID, OpenCorporates) | name -> company -> registered address |
| Court records (SIpp, CourtListener) | name -> cases -> parties/addresses |
| KYC/identity-verification APIs (Onfido, Appruve, Surepass - see API-CATALOG.md) | LEGAL channel for document verification - requires contract + consent |
| Official publications (announcement/tender/decree PDFs) | name + title + institution |

NOTE: national ID numbers (NIK) are sensitive personal data (UU PDP No. 27/2022 / GDPR Art. 9).
Process only through legal channels with a documented basis. Free "check NIK by name" services
are generally based on leaked databases - see the Legal boundary section of skills/osint-people/SKILL.md.

## Gov & corporate

| Source | Function |
|---|---|
| OFAC SDN / sanctionssearch | sanctions lists |
| OpenCorporates | multi-country registry |
| SEC EDGAR (incl. full-text search) | US company filings |
| CourtListener | US court records (free) |
| SAM.gov / EU TED | procurement |
| ICIJ Offshore Leaks Database | entity/officer/leaked documents |
| OCCRP Aleph | investigative datasets |

## GEOINT

| Source | Function |
|---|---|
| Google Lens / Yandex Images / TinEye / Bing Visual | reverse image search |
| Mapillary | crowdsourced street-level imagery |
| Sentinel Hub / USGS Earth Explorer | satellite imagery |
| SunCalc | sun position (shadow verification) |

## Web3 / on-chain

| Source | Function |
|---|---|
| Etherscan & other block explorers | txs, labels, tokens, holders |
| On-Chain Investigations Handbook (offgrid.labs) | curated on-chain investigation tools + Monero |
| Dune Analytics | on-chain SQL queries |
| Arkham / Nansen / Bubblemaps | attribution & graph (partly paid) |

API keys for the services above: environment variables only (SHODAN_KEY, HIBP_KEY, etc.). See SECURITY.md.

## Tool frameworks

| Source | Function |
|---|---|
| SpiderFoot | OSINT automation, 200+ modules |
| Recon-ng | modular recon framework |
| Maltego | link analysis (commercial) |