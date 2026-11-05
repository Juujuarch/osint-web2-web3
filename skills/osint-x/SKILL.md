---
name: osint-x
description: X (Twitter) identity OSINT skill. Use when the starting point is an X username (current or old) or a real person name - track username changes, display name changes, and bio changes via public archives and mirrors, and apply matching logic to confirm that two handles, or a handle and a real name, are the same identity.
---
# OSINT X (Twitter)

Entry points: **an X username** (currently known) or **a real name**. Output: handle/bio timeline + identity verdict with confidence + evidence.

## Key concepts (foundation of every technique below)

1. **The numeric user ID is immutable.** Handles change at any time; the user ID never does. This is the primary matching anchor.
2. **Tweet IDs are immutable and authorship follows the current handle.** An old tweet URL created when the account was @old, opened today, displays @new. This is confirming evidence of a username change.
3. **Archives are the history source.** Wayback Machine, archive.today, and third-party mirrors preserve past profile versions: display name, bio, avatar, links.
4. **Handle changes are normal** (rebrand, compromised old account, persona pivot). Do not assume a different handle = a different person.

## Entry A - start from a current X username

1. **Baseline current profile**: display name, bio, location, link, join date, follower/following counts, profile photo (save + hash), pinned tweet, latest tweet
2. **History**: `bash tools/x-history.sh <handle>`
3. For each archived snapshot, record: date + display name + bio + avatar + link -> one timeline row
4. Any old handle that surfaces (from archives, mentions, or mirrors) -> run `tools/x-history.sh <old-handle>` again
5. **Pivot outward**: bio link -> domain (osint-web2), profile photo -> osint-geo, crypto handle -> osint-web3

## Entry B - start from a real name

1. **Collect candidate accounts**:
   - Search engines: `"Full Name" site:x.com`, `"Full Name" site:twitter.com`
   - Google/Bing: `"Full Name" twitter OR x.com`, spelling variants, initials
   - People search and social aggregators (see osint-web2)
2. **Baseline each candidate** (same as Entry A step 1)
3. **Apply matching logic** below - only proceed at confidence >= probable
4. If a candidate is strong, trace its handle/bio history as in Entry A

## Username change detection

| Technique | How | Strength |
|---|---|---|
| **Old tweet -> authorship** | Open an old tweet URL (from archives, mentions, or search). The displayed author = current handle. Different from the handle when the tweet was created = change confirmed | CONFIRMED |
| **Immutable user ID** | Find the numeric ID in archived HTML/responses - easiest from the profile image URL: `pbs.twimg.com/profile_images/<USER_ID>/...`. Same ID across two handles = same account | CONFIRMED |
| **CDX archive of the old handle** | Snapshots of the old handle after the change display the new handle (same profile). The change window = between the last old-handle snapshot and the first new-handle snapshot | STRONG |
| **Mentions of the old handle** | Search `@oldhandle` - tweet context often says "previously", "aka", "old account" | STRONG |
| **Third-party mirrors** | xstalk, sotwe, twstalker, threadreaderapp etc. cache profiles, sometimes with history | SUPPORTING |
| **Display name continuity** | Identical display name across two handles with a tight time gap | MEDIUM |

## Bio change detection

1. Compare bios across archived snapshots: exact text + hash of each version
2. Also track fields that change together: display name, avatar (use perceptual hash, not exact hash - avatars get recompressed), location, link, pinned tweet
3. Timeline format (one row per version):

```
<UTC date> | <handle at the time> | <display name> | <bio text> | <avatar pHash> | <link> | <archive source URL>
```

4. With many snapshots, a simple diff between rows is enough; look for **changes of meaning** (moved city, new profession, relationship, new project), not typos

## Matching logic

| Signal | Strength | Note |
|---|---|---|
| Same numeric user ID | CONFIRMED | Immutable for the account's lifetime |
| Old tweet + authorship on new handle | CONFIRMED | Tweet ID immutable |
| Avatar match across time (perceptual hash) | STRONG | People rarely change photos; recompression still matches |
| Bio text / personal link overlap | STRONG | Personal domains or rare links are strong signals |
| Follower graph overlap (consistent mutuals) | STRONG | Look at the top 10-20 mutuals, not counts |
| Same join date | STRONG | Account creation date never changes |
| Identical display name | MEDIUM | Common name = weak; rare name = upgrades to strong |
| Language style, posting hours, topics | SUPPORTING | Combine with other signals |
| Similar handle | WEAK | Handles can be bought, squatted, or sold |

Decision rules:

- **confirmed**: at least 1 CONFIRMED signal (same user ID, or old tweet -> authorship)
- **probable**: at least 2 STRONG signals, no contradictions
- **possible**: 1 STRONG or several SUPPORTING signals
- **rejected**: hard contradiction - different user IDs, very different join dates, zero follower graph overlap, inconsistent language/topics

If the result is *possible*: report as a hypothesis with the signal list, not as fact.

## OPSEC

- The archive phase (Wayback, archive.today, mirrors) is **passive** - it never touches X
- If you must open X directly: dedicated browser profile, not logged in, no follow/like/reply - interaction leaves traces the target can see
- Never search a target's name from a personal account
- Hash and encrypt all work artifacts (screenshots, HTML) outside this repo

## Standard output

1. Handle/display name/bio timeline (row format above)
2. Matching table: signal -> strength -> evidence (archive URL, user ID, tweet ID, UTC timestamp)
3. Verdict: confirmed / probable / possible / rejected + reasoning
4. Follow-up pivots (domain, photo, other handles)