---
name: osint-people
description: Person deep-dive OSINT skill - from a full name (plus optional city, age, company) build a detailed dossier: contact points, addresses, employment, digital footprint, and identifiers. Includes matching logic (cocoklogi) for candidate resolution and a mandatory legal gate for sensitive identifiers such as national ID numbers (NIK).
---
# OSINT People (nama lengkap -> dossier)

Kasus khas: kamu cuma punya **nama lengkap** seseorang, output yang dibutuhkan: profil selengkap mungkin - nomor telepon, alamat, pekerjaan, jejak digital, identifier resmi.

## Agent instruction

1. **Legal gate** (WAJIB, sebelum apa pun) - lihat bagian Legal boundary
2. Phase 1: candidate discovery - siapa saja orang dengan nama ini
3. Phase 2: attribute enrichment per kandidat (kontak, alamat, kerja, digital, ID)
4. Phase 3: cocoklogi - tier tiap atribut, verdict per kandidat
5. Output dossier pakai template di bawah

## Legal boundary (gate - jangan skip)

- **NIK / nomor identitas nasional = data pribadi spesifik.** Di Indonesia diatur UU PDP No. 27/2022; di EU GDPR Article 9. Memproses tanpa dasar hukum = risiko hukum buat **kamu sebagai pemroses**, bukan cuma subjek.
- Dasar yang sah (minimal salah satu): (a) data diri sendiri, (b) otorisasi tertulis dari subjek, (c) kepentingan publik yang jelas dan terdokumentasi (jurnalisme, laporan penipuan ke pihak berwenang), (d) proses hukum/penegakan kontrak
- **Jangan pakai mirror database bocor** (cek-NIK-by-nama gratisan umumnya berbasis kebocoran data 2023) tanpa dasar hukum kuat. Kalau terpaksa dipakai, dokumentasikan dasar + minimisasi data yang disimpan
- KYC/identity-verification API (kategori People and documents verification di docs/API-CATALOG.md: Onfido, Appruve, Surepass dll) = kanal legal, tapi butuh kontrak komersial + consent subjek - bukan alat buat menyelidiki orang diam-diam
- Kalau ragu legal: lakukan fase 1-2 untuk atribut non-sensitif saja, tulis "identifier resmi: belum diakses (legal gate)" di laporan

## Entry

- Wajib: nama lengkap (semakin lengkap semakin baik)
- Opsional penguat: kota/provinsi, perkiraan usia/tanggal lahir, perusahaan/instansi, atau identifier yang sudah diketahui (username, email, phone) - kalau ada, mulai dari osint-web2/osint-x/osint-correlation, skill ini sebagai pelengkap

## Phase 1 - candidate discovery

1. Search engine: `"Nama Lengkap"`, `"Nama Lengkap" + kota`, `"Nama" site:linkedin.com`, `"Nama" filetype:pdf` (SK, surat, tender, ijazah), variasi ejaan dan gelar
2. People-search aggregator / data broker (sumber: docs/SOURCES.md kategori People)
3. Business registry: nama sebagai officer/pemilik (AHU Online/OpenCorporates/registry lokal) - sering ketemu alamat + perusahaan
4. Sosial: LinkedIn, X, Facebook, Instagram via search + `bash tools/username-hunt.sh <nama-variasi>`
5. Profesional/akademik: publikasi, konferensi, patent, ORCID, Google Scholar, kepengurusan organisasi
6. Output: daftar kandidat (nama variasi, kota, URL, ringkasan atribut)

## Phase 2 - attribute enrichment (per kandidat)

### Kontak
- **Phone**: people-search aggregator, breach record (osint-leak), bio sosmed, dokumen publik (PDF pengumuman, tender, registry) - cocokkan dengan kota kandidat
- **Email**: gravatar hash, breach record, whois domain historis, filing registry, tanda tangan dokumen publik

### Alamat
- Registry perusahaan (registered address), dokumen publik (pengumuman/tender/SK), court records
- Alamat historis: whois, arsip Wayback halaman profil, breach record
- Property/land record kalau publik di yurisdiksi tersebut

### Pekerjaan & afiliasi
- LinkedIn, registry officer, tender winner, press release, publikasi, kepengurusan komunitas

### Identifier resmi (legal gate berlaku)
- NIK/passport: hanya via kanal legal (KYC API berkontrak, proses hukum, atau data sendiri)
- Kalau didapat lewat kanal legal: simpan terenkripsi, akses terbatas, catat dasar hukum + tanggal akses
- Di laporan: tulis status ("diverifikasi via kanal legal tanggal X" / "belum diakses - legal gate")

### Jejak digital
- username -> osint-web2 (600+ platform), handle X -> osint-x (riwayat handle/bio), domain -> whois, foto profil -> osint-geo (reverse search + pHash)

### Keluarga & asosiasi (PII orang ketiga - relevansi saja)
- Registry: co-officer, co-owner, alamat sama; court records: pihak terkait
- Hanya catat yang relevan dengan tujuan investigasi; jangan perluas ke keluarga tanpa alasan

## Phase 3 - cocoklogi (kandidat = target?)

Framework global: skills/osint/SKILL.md. Tabel spesifik people:

| Sinyal | Tier |
|---|---|
| NIK/ID resmi cocok (kanal legal) | KONFIRMASI |
| Email langka + phone exact cocok | KUAT |
| Phone exact + kota cocok | KUAT |
| Alamat exact sama | KUAT |
| Nama + tanggal lahir cocok | KUAT |
| Avatar pHash cocok dengan profil sosial | KUAT |
| Nama + kota | SEDANG |
| Nama + perusahaan | SEDANG |
| Nama saja | LEMAH |
| Username mirip | LEMAH |

Aturan verdict: confirmed / probable / possible / rejected (lihat framework global). **Nama umum (Budi, Siti, John Smith) tidak pernah bisa confirmed dari nama saja.**

## Output - template dossier

```
# Dossier: <nama>
## Ringkasan
- Verdict identitas utama: <confirmed/probable/possible> - alasan tier
- Kandidat: N total, M probable+
## Kandidat 1 - <nama + pembeda> (verdict: probable)
- Kontak:
  - phone: <nilai> [TIER - sumber, tanggal akses]
  - email: <nilai> [TIER - sumber]
- Alamat: <nilai> [TIER - sumber, periode]
- Pekerjaan/afiliasi: <nilai> [sumber]
- Identifier resmi: <status legal gate / nilai> [KONFIRMASI hanya jika kanal legal]
- Jejak digital: <platform: URL> [TIER]
- Foto: <pHash> 
- Kontradiksi: <daftar / tidak ada>
## Kandidat 2 ...
## Timeline (kalau dataset cukup)
## Evidence (URL + timestamp UTC + hash file)
## Tindak lanjut yang diusulkan
```

## Anti-pattern

- confirmed dari nama doang
- Simpan NIK/PII hasil investigasi di repo, chat, atau folder cloud yang auto-sync
- Pakai mirror data bocor tanpa mendokumentasikan dasar hukum
- Merge orang jadi satu karena alamat sama (pasangan, saudara, kos = orang beda)
- Lapor "NIK-nya ..." tanpa kanal legal - tulis "belum diverifikasi"
- Output tanpa tier (jadi tidak bisa diaudit)

## Indonesia-specific note

- **UU PDP No. 27/2022**: NIK, data biometrik, data kesehatan = data pribadi spesifik. Proses tanpa dasar = sanksi buat pemroses
- Sumber legal untuk Indonesia: AHU Online (registry PT), SIpp/pengadilan (perkara), publikasi resmi pemerintah (PDF), people-search berbayar dengan ToS mengizinkan, KYC API berkontrak
- Layanan "cek NIK by nama + tanggal lahir" gratis di internet umumnya berbasis kebocoran data kependudukan 2023 - pakai hanya dengan dasar hukum kuat, dan simpan seminimal mungkin