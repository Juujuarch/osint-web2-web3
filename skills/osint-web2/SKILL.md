---
name: osint-web2
description: Web2 OSINT skill for identifiers - email, username/handle, phone, person name, business entity, domain/IP. Use when pivoting from one web2 identifier to accounts, profiles, ownership, and infrastructure. Includes matching logic (cocoklogi) for deciding whether an identifier belongs to a target. For X/Twitter-specific work use osint-x.
---
# OSINT Web2

Catatan: kalau identifier-nya handle X atau nama asli yang target utamanya di X, pakai skills/osint-x/SKILL.md. Skill ini untuk web2 umum. Untuk menyambung 2+ identifier lintas domain, pakai skills/osint-correlation/SKILL.md.

## Agent instruction

1. Baseline identifier (atribut yang bisa dicari)
2. Pivot satu per satu: email -> akun, username -> platform, phone -> carrier/akun, nama -> profil
3. Setiap kecocokan: beri tier pakai framework global (skills/osint/SKILL.md)
4. Output: daftar match bertier + evidence + pivot berikutnya

## Email

Urutan: validity -> exposure -> accounts -> entity.

1. Validitas & deliverability: cek format/MX, lalu layanan verifikasi (sumber: docs/SOURCES.md, katalog API docs/API-CATALOG.md)
2. Exposure: lanjut ke osint-leak (breach search) - cukup tahu "exposed atau tidak", jangan cari password
3. Accounts: gravatar hash (MD5 email -> avatar URL), GitHub user search, whois historis yang memuat email
4. Entity: email korporat -> domain -> registry (pinjam osint-gov)

## Username / handle (non-X)

Backend: blackbird (600+ platform, berbasis WhatsMyName).

```bash
bash tools/username-hunt.sh <username>
```

- Catat platform yang match + URL profil
- Pivot: bio/foto -> osint-geo; handle sama di platform kripto -> osint-web3
- Kalau handle-nya di X -> pindah ke osint-x (butuh riwayat + matching logic)
- False positive happens: verifikasi manual tiap match sebelum dianggap satu orang

## Phone

- Tipe line (mobile/voip/fixed), carrier, negara (sumber: docs/API-CATALOG.md kategori phone)
- Pivot: nomor -> akun chat/sosial via fitur "cari by phone" (butuh OPSEC, lihat osint-opsec)
- Jangan asumsikan nomor = identitas; nomor bisa dipakai ulang

## Nama orang (di luar X)

- Mesin pencari dengan operator: "nama" site:linkedin.com, "nama" filetype:pdf, variasi ejaan
- Profil publik -> foto -> osint-geo
- Kalau target utamanya di X: pakai osint-x Entry B (nama asli -> kandidat akun -> matching logic)
- Nama + negara jelas -> osint-gov (registry direksi, court records)

## Domain / IP / DNS

Backend: tools/domain-recon.sh + reconspider (opsional).

1. whois (termasuk historical)
2. Subdomain: crt.sh certificate transparency
3. Tech fingerprint: response headers, favicon hash, JS bundle (kalau konteks ofensif, lanjut ke skill recon di hack-skills)
4. Infra: reverse DNS, ASN, netblock tetangga

## Entity / perusahaan

- Corporate registry: osint-gov
- Footprint: domain, email pattern, karyawan publik
- Dokumen: filing, pitch deck, tender - sering bocor sebagai PDF yang bisa di-search

## COCOKLOGI - matching identifier -> akun/orang

### Tabel sinyal

| Sinyal | Tier | Catatan |
|---|---|---|
| Gravatar hash cocok antar platform (email sama) | KONFIRMASI-kuat | MD5 email -> URL avatar yang identik = email kuat sama |
| Email exact terverifikasi di profil (bukan cuma teks bio) | KUAT | butuh bukti verifikasi (reset flow, notifikasi) |
| Avatar perceptual hash cocok lintas platform | KUAT | bandingkan p-hash, bukan exact bytes |
| Link personal/domain sama di bio 2+ platform | KUAT | link langka = sinyal kuat |
| Username exact + platform niche | SEDANG | platform umum = lemah |
| Follower/following graph overlap | KUAT | lihat 10-20 mutual teratas |
| Display name + kota + profesi sama | SEDANG | kombinasi umum |
| Bio text overlap > 50% | SEDANG | copy-paste bio umum |
| Jam posting & gaya bahasa | PENDUKUNG | hanya kombinasi |
| Handle mirip | LEMAH | handle bisa dibeli/direbut |

### Aturan verdict

- confirmed: gravatar cocok / email terverifikasi
- probable: >= 2 KUAT (avatar pHash + link personal, dst)
- possible: 1 KUAT atau >= 2 SEDANG
- rejected: gravatar beda + join date beda jauh + follower graph nol overlap

### Jebakan umum

- Email corporat yang dipakai ulang setelah karyawan keluar
- Nomor telepon yang didaur ulang operator
- Nama umum (bukan sinyal)
- Handle pop Culture yang diburu banyak orang (handle mirip bukan hubungan)

## Evidence

Tiap temuan wajib: URL sumber, waktu akses UTC, hash screenshot kalau halaman bisa berubah. Simpan di luar repo ini - repo ini publik.