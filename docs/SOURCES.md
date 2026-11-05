# Daftar Sumber (kurasi)

Link ke upstream, tidak di-vendor. API key TIDAK disimpan di repo ini - set via env var saat runtime.

## X / Twitter (riwayat & matching)

| Sumber | Fungsi |
|---|---|
| Wayback Machine CDX API | snapshot profil per titik waktu (twitter.com & x.com) |
| archive.today (archive.ph) | snapshot manual, sering punya profil yang di-screenshot user |
| URL gambar profil `pbs.twimg.com/profile_images/<USER_ID>/...` | user ID numerik = kekal, anchor matching |
| Mirror pihak-ketiga (xstalk, sotwe, twstalker, threadreaderapp) | cache profil, kadang histori |
| X Advanced Search / Google `site:x.com` | mention handle lama, kandidat akun dari nama |
| Tweet URL lama (`/status/<id>`) | authorship mengikuti handle sekarang = bukti change |

## Email

| Sumber | Fungsi |
|---|---|
| haveibeenpwned.com/API/ v3 | breach search (butuh key; pakai range API untuk k-anonymity) |
| hunter.io | email pattern perusahaan (butuh key) |
| emailrep.io | reputasi email |

## Username / people

| Sumber | Fungsi |
|---|---|
| blackbird (p1ngul1n0/blackbird) | 600+ platform, export PDF/CSV |
| whatsmyname (WebBreacher) | dataset username->profil |
| namechk / checkusernames | cek cepat multi-platform |

## Phone

| Sumber | Fungsi |
|---|---|
| numverify / apilayer | carrier + line type per negara |
| phoneinfoga (sundowndev) | framework recon nomor |

## Domain / DNS / infra

| Sumber | Fungsi |
|---|---|
| crt.sh | certificate transparency, subdomain |
| whois / whoishistory | pemilik domain, historis |
| SecurityTrails | DNS historis (butuh key) |
| Shodan / Censys | perangkat & service exposure (butuh key) |
| reconspider (bhavsec) | scan IP/email/domain/org + dashboard |

## Breach / leak / darknet

| Sumber | Fungsi |
|---|---|
| HIBP | breach search |
| psbdmp / paste scrape | paste monitoring |
| DeHashed / leak-lookup | breach lookup (berbayar, legal-review dulu) |
| Ahmia | darknet search (Tor) |

## Gov & corporate

| Sumber | Fungsi |
|---|---|
| OFAC SDN / sanctionssearch | sanctions list |
| OpenCorporates | registry multi-negara |
| SEC EDGAR (incl. full-text search) | filing perusahaan US |
| CourtListener | court records US (gratis) |
| SAM.gov / EU TED | procurement |
| ICIJ Offshore Leaks Database | entity/officer/leak dokumen |
| OCCRP Aleph | dataset investigatif |

## GEOINT

| Sumber | Fungsi |
|---|---|
| Google Lens / Yandex Images / TinEye / Bing Visual | reverse image |
| Mapillary | street-level imagery crowdsourced |
| Sentinel Hub / USGS Earth Explorer | satelit imagery |
| SunCalc | posisi matahari (verifikasi bayangan) |

## Web3 / on-chain

| Sumber | Fungsi |
|---|---|
| Etherscan & block explorer lain | tx, label, token, holder |
| On-Chain Investigations Handbook (offgrid.labs) | kurasi tools investigasi on-chain + Monero |
| Dune Analytics | query on-chain (SQL) |
| Arkham / Nansen / Bubblemaps | attribution & graph (sebagian berbayar) |

API keys untuk layanan di atas: env var saja (SHODAN_KEY, HIBP_KEY, dsb). Lihat SECURITY.md.

## Tools framework

| Sumber | Fungsi |
|---|---|
| SpiderFoot | OSINT automation 200+ modul |
| Recon-ng | framework recon modular |
| Maltego | link analysis (komersial) |