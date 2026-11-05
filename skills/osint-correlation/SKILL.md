---
name: osint-correlation
description: Cross-domain identity correlation skill. Use when you have two or more identifiers (email, X handle, username, phone, wallet, name, photo, domain) and need to decide whether they belong to the same entity - with signal tiers, bridge-identifier logic, graph-based confidence, and contradiction handling.
---
# OSINT Correlation (matching logic across domains)

This skill answers the core investigative question: **"are identifier A and identifier B the same entity?"** Domain skills collect attributes; this skill decides.

## Agent instruction

When asked to connect 2+ identifiers:
1. Collect attributes for each identifier via the respective domain skill
2. Look for bridge identifiers (see the table below)
3. Build the graph: nodes = identifiers, edges = tiered evidence
4. Compute verdicts using path-strength rules
5. Output: graph + edge table + verdict per pair + contradiction list

## Bridge identifiers (connectors across domains)

| From | To | Bridge | Bridge tier |
|---|---|---|---|
| Email | Any account | gravatar hash (MD5 email -> avatar) | STRONG |
| Email | X handle | breach/paste record, gravatar | STRONG |
| X handle | Wallet | bio link, ENS, pinned tweet | MEDIUM-STRONG |
| X handle | Email | gravatar, leak record | STRONG |
| Wallet | X handle | ENS reverse, tx memo, ENS social profile | MEDIUM |
| Wallet | Wallet | common-input, gas funder, bridge tx | STRONG (see osint-web3) |
| Phone | Email/account | breach record, "search by phone" feature | STRONG |
| Name | Account | search + attribute verification | MEDIUM |
| Photo | Person | avatar pHash, face match | STRONG |
| Photo | Location | landmark, EXIF | CONFIRMED (GPS EXIF) |
| Domain | Email | historical whois | STRONG |
| Domain | Wallet | whois + on-chain funding? (weak, be careful) | WEAK |

## Graph model

- **Node**: an identifier (email, handle, wallet, phone, name, photo, domain)
- **Edge**: evidence of a relationship, with a tier (CONFIRMED/STRONG/MEDIUM/SUPPORTING/WEAK)
- **Path strength**: the weakest edge along the path determines the path's tier

## Verdict rules (cross-domain)

1. **confirmed**: a path containing >= 1 CONFIRMED edge
2. **probable**: strongest path is STRONG (weakest edge STRONG), or >= 2 independent STRONG edges
3. **possible**: strongest edge is MEDIUM
4. **rejected**: a hard contradiction along the path

**Key principle**: an identity cluster = the set of nodes connected by paths of >= probable. Isolated nodes stay "possible" and are never merged.

## Hard contradictions (auto-reject)

| Contradiction | Why |
|---|---|
| Different X user IDs | user IDs are immutable |
| GPS EXIF in different cities at the same timestamp | impossible |
| Join dates more than a year apart on the "same" account | different accounts |
| Different registry IDs (NPWP/LEI/company number) | different entities |
| Zero follower graph overlap on social accounts | strong indicator of different people |
| Credential hash mismatch | not the same account |

## Soft contradictions (downgrade one tier + record)

- Different timezone/posting hours (can be VPN or faked)
- Changed writing style (can be a ghostwriter or pivot)
- Replaced avatar (normal)
- Changed handle (normal - see osint-x)

## Output format

```
## Identity cluster (verdict: confirmed/probable/possible)
Nodes: <identifier list>
Edges:
  <A> --[TIER: evidence, source, timestamp]--> <B>
Verdict: <x> because <tier reasoning>
Contradictions: <list / none>
Next pivots: <skill + step>
```

## Anti-patterns

- Merging clusters on a single WEAK signal (similar handle)
- Failing to record contradictions that were checked and found clean
- Claiming confirmed from >= 2 MEDIUM signals (that is possible)
- Using "feels right" as a tier