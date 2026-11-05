# OSINT WEB2 & WEB3

Suite skill OSINT (Open-Source Intelligence) untuk investigasi **web2** (email, phone, username, people, entity, domain), **X/Twitter** (username change, bio change, matching logic), dan **web3** (wallet attribution, clustering, cross-chain pivot), plus **leak/breach**, **gov records**, **GEOINT**, **correlation lintas domain**, dan **OPSEC**.

Dirancang sebagai **agent skill set**: setiap skill punya frontmatter `name` + `description` (trigger), agent instruction, metodologi detail, dan **section COCOKLOGI** (logika pencocokan bertier). Semua skill memakai satu framework confidence global.

Prinsip desain: **router -> domain skill -> backend tool**. Satu entry point (`osint`), tiap domain punya workflow + sumber eksplisit, backend tool opsional dipasang terpisah dan tidak pernah menyimpan kredensial di repo ini.

## Isi repo

| Path | Fungsi |
|---|---|
| `skills/osint/` | Router + **framework confidence global** |
| `skills/osint-correlation/` | Cocoklogi lintas domain: bridge identifier, graph, verdict |
| `skills/osint-x/` | X/Twitter: username change, bio change, matching logic |
| `skills/osint-web2/` | Identitas & web: email, phone, username, people, entity, domain |
| `skills/osint-web3/` | On-chain: wallet attribution, clustering, cross-chain (read-only) |
| `skills/osint-leak/` | Breach exposure, combolist, paste, darknet monitoring |
| `skills/osint-gov/` | Sanctions, corporate registry, court, procurement, document leaks |
| `skills/osint-geo/` | Reverse image search, face search, geolocation |
| `skills/osint-opsec/` | Attribution hygiene, sock puppet, evidence chain, counter-matching |
| `tools/` | Installer backend, wrapper, secret scanner, X history, API catalog sync |
| `docs/` | Workflow per skenario, daftar sumber, katalog API |

## Framework confidence (inti dari semua skill)

Setiap klaim "A = B" wajib bertier:

| Tier | Arti | Contoh |
|---|---|---|
| KONFIRMASI | identifier kekal identik | user ID X, tweet ID->authorship, GPS EXIF, registry ID, hash cocok |
| KUAT | atribut langka cocok | avatar pHash, link personal, follower graph overlap, common-input on-chain |
| SEDANG | atribut umum cocok | display name, bio overlap, nama+domisili |
| PENDUKUNG | pola perilaku | gaya bahasa, jam posting, timing tx |
| LEMAH | kemiripan dangkal | handle mirip, nama umum |

Verdict: **confirmed** (>=1 KONFIRMASI) / **probable** (>=2 KUAT) / **possible** (1 KUAT atau >=2 SEDANG) / **rejected** (kontradiksi keras). Klaim tanpa tier bukan temuan.

## Quick start

```bash
# backend opsional (blackbird = username/email, reconspider = IP/domain/org)
bash tools/install-backends.sh

# wrapper siap pakai
bash tools/username-hunt.sh <username>      # cari username di 600+ platform
bash tools/domain-recon.sh <domain>         # whois/DNS/subdomain/headers
bash tools/x-history.sh <handle>            # riwayat profil X via arsip publik
bash tools/sync-api-catalog.sh              # refresh katalog API dari upstream

# sebelum commit/push apa pun
bash tools/scan-secrets.sh
```

Skill dibaca langsung dari `skills/*/SKILL.md` atau di-load sebagai Claude/Codex skill folder.

## Skill domain - ringkas

### osint (router)
Titik masuk. Petakan identifier (email / username / handle X / wallet / domain / foto / nama) ke skill domain yang tepat, lalu ke sumber konkret. Memuat framework confidence global.

### osint-correlation
Cocoklogi lintas domain: tabel bridge identifier (email<->handle<->wallet<->phone<->foto), graph node+edge bertier, path strength = edge terlemah, aturan kontradiksi, output format graph+verdict.

### osint-x
Kasus khas: cuma punya username X atau nama asli. User ID numerik kekal, tweet lama -> authorship handle baru, arsip Wayback/archive.today, timeline bio, matching logic confirmed/probable/possible/rejected.

### osint-web2
Email (validity -> exposure -> accounts -> entity), username (blackbird 600+ platform), phone, people, domain/IP/DNS, entity. COCOKLOGI: gravatar, avatar pHash, link personal, follower graph overlap.

### osint-web3
Wallet attribution (label, first funding, counterparty, ENS), clustering (common-input, gas funder, deposit pattern, bridge), cross-chain pivot, holder/token graph. Read-only. COCOKLOGI: signed message = KONFIRMASI, verdict atribusi bertier.

### osint-leak
Breach search (k-anonymity), paste, combolist awareness, darknet watch, self-monitoring. COCOKLOGI: hash cocok = KONFIRMASI; tanggal breach vs umur identifier bisa jadi kontradiksi.

### osint-gov
Sanctions (OFAC/EU/UN), corporate registry (OpenCorporates, EDGAR), court (CourtListener, PACER), procurement (SAM.gov, TED), ICIJ/OCCRP. COCOKLOGI: entity resolution - registry ID/LEI = KONFIRMASI, transliterasi & nominee officer = jebakan.

### osint-geo
Reverse image (Lens, Yandex, TinEye), face search (batas legal), geolocation reasoning (bayangan, rambu, mobil, vegetasi). COCOKLOGI: EXIF GPS = KONFIRMASI, sun-angle/plate/vegetasi bisa jadi kontradiksi.

### osint-opsec
Posture investigasi, sock puppet, evidence chain, storage terenkripsi. **Counter-matching**: audit vektor linkability persona (avatar reuse, stylometry, fingerprint, metadata) sebelum sesi sensitif.

## Backend tools

| Tool | Fungsi | Install |
|---|---|---|
| blackbird | username/email search 600+ platform | `bash tools/install-backends.sh` |
| reconspider | IP/email/domain/org scan + dashboard | `bash tools/install-backends.sh` |

Repo ini tidak pernah menyimpan API key - semua key masuk via environment variable yang tidak di-commit (lihat `.gitignore`).

## Keamanan

- Baca [SECURITY.md](SECURITY.md): kebijakan kredensial + OPSEC minimum
- `tools/scan-secrets.sh` wajib jalan sebelum commit/push
- Repo ini publik: **anggap semua isinya bisa dibaca siapa saja**

## Legal & etik

Suite ini untuk OSINT pada target yang kamu punya dasar legal (aset sendiri, riset keamanan berizin, riset publik, jurnalisme dengan dasar publik). Kepatuhan ToS platform dan hukum yurisdiksi masing-masing tetap tanggung jawab pengguna. Lihat `skills/osint-opsec/SKILL.md`.

## Roadmap

- [ ] Skill: telegram/discord channel OSINT
- [ ] Skill: image EXIF/metadata forensics
- [ ] Integrasi backend: SpiderFoot
- [ ] Template laporan investigasi (evidence-first)

## License

MIT - lihat [LICENSE](LICENSE).