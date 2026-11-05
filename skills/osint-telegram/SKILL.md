---
name: osint-telegram
description: Telegram and Discord OSINT skill - immutable numeric ID resolution, username history recovery, channel/group enumeration, member and message archaeology (deleted-message recovery), Discord snowflake decoding, and leak-channel watch. Includes matching logic for handle changes and cross-platform pivots, plus legal gates for member scraping.
---
# OSINT Telegram & Discord

Messaging platforms are where handles change fast, leaks get traded, and communities leave public traces. This skill covers Telegram (MTProto + Bot API surfaces, username history, channel/group enumeration, message archaeology) and Discord (snowflake IDs, username history, guild enumeration), with matching logic for pivoting a handle change back to a stable identity.

## Agent instruction

1. Fix the anchor first: numeric user ID (Telegram) / snowflake (Discord) is immutable - the @handle is not
2. Resolve handle -> ID via public bots or MTProto before anything else
3. History: archive.today, Wayback, third-party mirrors, forwarded-message origin
4. Enumeration: public channels/groups only; member scraping needs a legal basis
5. Watch: leak channels and access-broker shops (bridge to osint-leak)
6. Output: tiered identity verdict + evidence chain

## 1. Telegram - surfaces and access models

| Surface | What it gives | Access |
|---|---|---|
| Bot API | messages in channels the bot is admin of; no history for others | bot token |
| MTProto (Telethon / Pyrogram) | full client surface: search, history, members, joins | api_id + api_hash from my.telegram.org |
| Public ID bots (@userinfobot, @getidsbot, @username_to_id_bot) | handle -> numeric ID, no login | none |
| t.me / web.telegram.org | public channel preview (last posts without login) | none |
| Third-party mirrors (tgstat, telemetr, combot) | channel stats, subscriber graphs, growth | none / freemium |

- MTProto with your own account = full fidelity but links the investigation to a real number; use a VOIP-registered session (see osint-opsec)
- api_id/api_hash are per-app, free, from https://my.telegram.org - store in env, never in repo

## 2. Anchor resolution - handle -> immutable ID

```text
1. Forward any message from the target to @userinfobot (or @getidsbot) -> numeric ID
2. Or MTProto: client.get_entity("@handle") -> .id
3. Record: handle_at_time + numeric ID + capture timestamp (WIB)
```

The numeric ID never changes - not on username change. Account deletion + recreation = new ID (that is a contradiction signal, see MATCHING LOGIC). This is the KONFIRMASI anchor for everything below.

## 3. Username history

Telegram has no public username-history API. Recover it from:

| Source | Method | Tier |
|---|---|---|
| Forwarded messages in other channels | forward header shows origin channel/user | KUAT |
| Old t.me links in web archives | Wayback CDX: `t.me/<oldhandle>` | KUAT |
| Third-party mirrors (tgstat, telemetr) | historical handle snapshots | KUAT |
| Search engines | `site:t.me "<oldhandle>"`, forum mentions | SEDANG |
| Group member lists captured earlier | diff old vs new member exports | KUAT |

## 4. Channel & group enumeration

- Public channels: search via MTProto `contacts.SearchRequest`, tgstat, telemetr, or Google `site:t.me`
- Invite links: `t.me/+<hash>` - membership required to resolve; `t.me/<name>` is public
- Linked discussion groups: every channel has an attached discussion group - its member list and message history are often richer than the channel itself
- Related-channel graph: channels cross-promote; build the graph from forwarded-message origin + linked chats
- Record per channel: ID, title, subscriber count, creation date, linked group, admin handles

## 5. Member enumeration (legal gate)

Public channel member lists are visible to members via MTProto. Scraping them:

- Allowed: your own channels, authorized research, public-interest work with documented basis
- A member list is third-party PII (user ID + optional name/bio) - same legal frame as osint-leak
- Practical: `client.get_participants(channel, aggressive=True)` - rate-limited, large channels need paging; record only the IDs + usernames the investigation needs

## 6. Message archaeology

| Technique | What it recovers |
|---|---|
| Channel search (MTProto) | keyword hits across full public history |
| Edit history | not public - edits overwrite; only pinned + replies keep context |
| Deleted messages | recoverable from third-party archive bots, mirror channels, local caches, forwarded copies |
| Media | files stay downloadable by file_id even after the message is deleted, if you have the ID |
| Replies / threads | quote-replies bind messages to authors = attribution anchors |

Deleted-message recovery is the highest-yield technique: actors delete, forwards survive.

## 7. Discord

| Surface | Method |
|---|---|
| Snowflake ID | encodes creation timestamp - decode with any snowflake lib; ID is immutable |
| Username history | no public API; recover from old messages, webhooks, server member lists, third-party archives |
| Guild enumeration | public servers via discovery, disboard.org, invite links `discord.gg/<code>` |
| Member list | requires a bot with GUILD_MEMBERS intent present in the guild |
| Message search | in-client only; bots see history of channels they can read |
| Account trade watch | token sellers advertise handles; a handle with an old snowflake + new username = resold account |

Discord username system (post-2023): no discriminants, unique per handle, changeable - the snowflake is the only stable anchor.

## 8. Leak-channel & broker watch (bridge to osint-leak)

Telegram is the primary distribution layer for stolen data. Watch pattern:

- Channels selling logs/combos/databases, initial-access brokers, RaaS affiliate channels
- Signals to record: sample screenshots (hash them), claimed breach names, price, actor reputation, contact handle
- Validation: samples are frequently fabricated or re-dated old data - validate before believing (see osint-leak MATCHING LOGIC)
- No purchases or actor contact without legal basis + explicit authorization

## MATCHING LOGIC - is this the same identity?

| Signal | Tier | Note |
|---|---|---|
| Numeric user ID (Telegram) identical | KONFIRMASI | immutable anchor |
| Snowflake ID identical (Discord) | KONFIRMASI | immutable anchor |
| Forwarded-message origin chain | KUAT | header shows original author/channel |
| Old t.me link in archive resolving to current account | KUAT | handle-change evidence |
| Same profile photo (pHash) across handle change | KUAT | perceptual hash, not visual guess |
| Linked discussion group membership overlap | KUAT | graph edge |
| Same @handle on another platform | SEDANG | handles are reused and squatted |
| Bio / display-name overlap | PENDUKUNG | weak alone |
| Posting-hour / language / style pattern | PENDUKUNG | stylometry, corroboration only |

Verdict rules: confirmed (>=1 KONFIRMASI) / probable (>=2 KUAT) / possible (1 KUAT or >=2 SEDANG) / rejected (hard contradiction).

Contradiction checks:
- Numeric ID differs but handle identical = different account (handle recycled or squatted) = rejected
- Snowflake creation date after the claimed account age = rejected
- Archive timestamp of old handle AFTER the claimed change date = rejected

Common traps:
- Handle recycling: deleted accounts free the @handle within days
- Impersonation channels copying name/photo of a known channel - check channel ID + creation date
- Buy/sell: accounts trade with the numeric ID intact - old ID + new behavior = new owner, not the same person
- Mirror channels repost content - the forwarded origin is the author, the mirror is not

## Evidence & handling

- Record per artifact: platform, ID, URL, capture timestamp (WIB), SHA-256 of any media
- MTProto session files are credentials - chmod 600, gitignored, never in repo
- This repo is public: NEVER store investigation results here
