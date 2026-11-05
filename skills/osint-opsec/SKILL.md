---
name: osint-opsec
description: Operational security skill for OSINT work - attribution hygiene, sock puppet management, evidence chain, secure data handling, and counter-matching logic (how an adversary could link your personas, and how to break those links).
---
# OPSEC for OSINT

## Agent instruction

1. Before an investigation: prepare posture (VM, profile, network)
2. During: follow interaction rules (zero traces on the target side)
3. After: hashed evidence, encrypted storage, clean up work traces
4. Audit persona linkability before sensitive sessions (counter-matching below)

## 1. Attribution hygiene

- Dedicated browser profile per case; zero personal accounts logged in
- Search engines without an account; if needed, via Tor or a paid VPN (never free VPNs)
- Separate the investigation network from the personal network (VM with isolated or host-only networking)
- Time and timezone: if interaction is needed, match the target's timezone (not yours)

## 2. Sock puppet management

- Consistent identity: name, email, avatar, coherent account history
- Aging: new accounts are suspicious; use accounts with organic history
- One persona per target/case - never reuse (one burn exposes every case)
- Never log into a persona from the same network/device as your real identity

## 3. Evidence chain

- Every artifact: SHA-256 hash, UTC timestamp, source URL, tool + version used
- Chain of custody: who collected it, when, from where; any change is recorded
- Report format: finding -> evidence -> tier -> follow-up. Evidence-first, not conclusion-first

## 4. Data handling

- Investigation results encrypted (VeraCrypt/LUKS or encrypted archive), never auto-synced to personal cloud
- Separate "working data" and "evidence" - working can be discarded, evidence is retained
- Retention: define a storage period; do not keep others' PII longer than necessary

## 5. COUNTER-MATCHING - how an adversary could link you

Principle: every signal used to match a target can be used by an adversary to match your personas. Audit before sensitive sessions.

| Linkability vector | Risk | Mitigation |
|---|---|---|
| Avatar reuse across personas | STRONG - identical perceptual hash | unique generated avatar per persona |
| Writing style & typo patterns | STRONG - stylometry | vary style; never copy-paste text between personas |
| Activity hours & timezone | MEDIUM - behavioral pattern | schedule sessions consistently in the target's timezone |
| Email pattern / recovery email | STRONG | fully separate emails, separate recovery |
| Device & browser fingerprint | STRONG | one VM per persona, never share browser profiles |
| File metadata (screenshot EXIF, author fields) | MEDIUM | strip metadata before publishing/sharing |
| IP / ASN / netblock | STRONG | separate VPN/Tor per persona, never free VPNs |
| Username handle reuse | MEDIUM | vary patterns |
| Recovery phone number | STRONG | separate numbers, or none |
| Personal domain/link in profiles | STRONG | separate domains per persona |

### Pre-session audit rules

1. Compare all active personas: similar avatars? similar handles? same email pattern?
2. Check metadata on files about to be shared
3. Ensure this session's VM/network has never been used with your real identity
4. If any STRONG vector is unmitigated: DO NOT proceed - fix it first

## 6. Legal boundary

- Have authorization or a legal basis before deep investigation (pentest contract, ownership, clear public interest)
- Respect platform ToS; aggressive scraping creates legal risk and exposes your IP
- When in doubt: stop, document, seek legal advice