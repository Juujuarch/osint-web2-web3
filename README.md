# OSINT WEB2 & WEB3

Suite skill OSINT (Open-Source Intelligence) untuk investigasi **web2** (email, phone, username, people, entity, domain) dan **web3** (wallet attribution, clustering, cross-chain pivot), plus **leak/breach**, **gov records**, **GEOINT**, dan **OPSEC**.

Prinsip desain: **router -> domain skill -> backend tool**. Satu entry point (`osint`), tiap domain punya workflow + sumber yang eksplisit, backend tool opsional dipasang terpisah dan tidak pernah menyimpan kredensial di repo ini.

## Isi repo

| Path | Fungsi |
|---|---|
| `skills/osint/` | Router - entry point, menentukan skill domain mana yang dipakai |
| `skills/osint-web2/` | Identitas & web: email, phone, username, people, entity, domain |
| `skills/osint-web3/` | On-chain: wallet attribution, clustering, cross-chain pivot (read-only) |
| `skills/osint-leak/` | Breach exposure, combolist, paste, darknet monitoring |
| `skills/osint-gov/` | Sanctions, corporate registry, court records, procurement, document leaks |
| `skills/osint-geo/` | Reverse image search, face search, geolocation |
| `skills/osint-opsec/` | Attribution hygiene, sock puppet, evidence chain, data handling |
| `tools/` | Installer backend, wrapper, secret scanner |
| `docs/` | Workflow per skenario + daftar sumber |

## Quick start

```bash
# 1. pasang backend opsional (blackbird = username/email, reconspider = IP/domain/org)
bash tools/install-backends.sh

# 2. wrapper siap pakai
bash tools/username-hunt.sh <username>
bash tools/domain-recon.sh <domain>

# 3. sebelum commit/push apa pun
bash tools/scan-secrets.sh
```

Skill-nya bisa dibaca langsung dari `skills/*/SKILL.md` (format agent-skill standar) atau di-load sebagai Claude/Codex skill folder.

## Skill domain - ringkas

### osint (router)
Titik masuk. Petakan apa yang kamu punya (email / username / wallet / domain / foto / nama) ke skill domain yang tepat, lalu ke sumber konkret.

### osint-web2
- **Email**: validity, deliverability, breach exposure (lihat osint-leak), akun yang pakai email itu (gravatar, github, dll)
- **Username**: enumerasi lintas platform (blackbird, 600+ site), pivot ke profil lain
- **Phone**: carrier, line type, lookup per negara (via sumber di docs/SOURCES.md)
- **People/entity**: nama -> profil publik, business entity, directorship
- **Domain/IP/DNS**: whois, subdomain (crt.sh), tech fingerprint, endpoint surface (gabung dengan recon skill hack-skills kalau konteksnya ofensif)

### osint-web3
- **Wallet attribution**: label, first-funding source, exchange touchpoint
- **Clustering**: common-input ownership, deposit address, gas funder, ENS
- **Cross-chain pivot**: address yang sama di EVM lain, bridge tx, wrapped asset
- **Holder/token graph**: NFT holder, LP provider, airdrop farm pattern
- Semua **read-only** - skill ini tidak pernah menandatangani transaksi

### osint-leak
- Breach search (HIBP model k-anonymity: hanya prefix hash yang dikirim)
- Paste monitoring, combolist awareness, darknet market watch (via Tor, dengan OPSEC)
- Monitoring domain/email sendiri

### osint-gov
- Sanctions (OFAC SDN, EU, UN), corporate registry (OpenCorporates, SEC EDGAR), court records (CourtListener, PACER), procurement (SAM.gov, TED), document leaks (ICIJ Offshore Leaks, OCCRP Aleph), FOIA

### osint-geo
- Reverse image (Google Lens, Yandex, TinEye), face search (hati-hati legal), geolocation reasoning (shadow/sun, signage, landmark), imagery (Mapillary, Sentinel), EXIF discipline

### osint-opsec
- Aturan sebelum investigasi: VM/browser profile terpisah, nol akun personal yang login, jaringan terpisah
- Sock puppet management, evidence chain (hash + timestamp), storage terenkripsi, batas legal

## Backend tools

| Tool | Fungsi | Install |
|---|---|---|
| blackbird | username/email search 600+ platform, export PDF/CSV | `bash tools/install-backends.sh` |
| reconspider | IP/email/domain/org scan + dashboard | `bash tools/install-backends.sh` |

Keduanya opsional. Repo ini tidak pernah menyimpan API key - semua key masuk via environment variable yang **tidak** di-commit (lihat `.gitignore`).

## Keamanan

- Baca [SECURITY.md](SECURITY.md): kebijakan kredensial + OPSEC minimum
- `tools/scan-secrets.sh` wajib jalan sebelum commit/push
- Repo ini publik: **anggap semua isinya bisa dibaca siapa saja**

## Legal & etik

Suite ini untuk OSINT pada target yang kamu punya dasar legal (asest sendiri, riset keamanan berizin, riset publik, jurnalisme dengan dasar publik). Kepatuhan ToS platform dan hukum yurisdiksi masing-masing tetap tanggung jawab pengguna. Lihat `skills/osint-opsec/SKILL.md`.

## Roadmap

- [ ] Skill: telegram/discord channel OSINT
- [ ] Skill: image EXIF/metadata forensics
- [ ] Integrasi backend: spiderfoot
- [ ] Template laporan investigasi (evidence-first)

## License

MIT - lihat [LICENSE](LICENSE).