---
name: osint-web2
description: Web2 OSINT skill for identifiers - email, username/handle, phone, person name, business entity, and domain/IP. Use when pivoting from one web2 identifier to accounts, profiles, ownership, and infrastructure, with explicit sources and evidence capture.
---
# OSINT Web2

## Email

Urutan: validity -> exposure -> accounts -> entity.

1. Validitas & deliverability: cek format/MX, lalu layanan verifikasi (sumber: docs/SOURCES.md kategori Email)
2. Exposure: lanjut ke osint-leak (breach search) - cukup tahu "exposed atau tidak", jangan cari password
3. Accounts: gravatar hash (MD5 email -> avatar URL), GitHub user search, whois historis yang memuat email
4. Entity: email korporat -> domain -> registry (pinjam osint-gov)

## Username / handle

Backend: blackbird (600+ platform, berbasis WhatsMyName).

```bash
bash tools/username-hunt.sh <username>
```

- Catat platform yang match + URL profil
- Pivot: bio/foto -> osint-geo; handle sama di platform kripto -> osint-web3 (bio sering link wallet/ENS)
- False positive happens: verifikasi manual tiap match sebelum dianggap satu orang

## Phone

- Tipe line (mobile/voip/fixed), carrier, negara (sumber lookup per negara: docs/SOURCES.md)
- Pivot: nomor -> akun chat/sosial via fitur "cari by phone" (butuh OPSEC, lihat osint-opsec)
- Jangan asumsikan nomor = identitas; nomor bisa dipakai ulang

## Nama orang

- Mesin pencari dengan operator: "nama" site:linkedin.com, "nama" filetype:pdf, variasi ejaan
- Profil publik -> foto -> osint-geo
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

## Evidence

Tiap temuan wajib: URL sumber, waktu akses UTC, hash screenshot kalau halaman bisa berubah. Simpan di luar repo ini - repo ini publik.