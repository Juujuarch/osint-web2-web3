---
name: osint-leak
description: Leak and breach exposure OSINT skill - breach search (k-anonymity safe), paste monitoring, combolist awareness, darknet market watch, and self-monitoring for owned domains/emails. Use when checking whether an identity, email, domain, or credential has appeared in public leaks.
---
# OSINT Leak & Breach

## 1. Breach search untuk email/identifier

- Gunakan model k-anonymity (HIBP range API): kirim hanya prefix hash SHA-1 password/email, cocokkan suffix secara lokal. Jangan kirim identifier utuh ke layanan yang tidak dipercaya.
- Catat: nama breach, tanggal, field yang ter-expose (email/hash/password/phone). Jangan unduh isi breach-nya - cukup konfirmasi eksposur.
- Sumber: docs/SOURCES.md kategori Breach & Leak.

## 2. Paste & public dump

- Pastebin-like: cari via API/search engine (site:pastebin.com "domain" dsb)
- Kalau nemu dump yang relevan: catat URL + timestamp, hash file kalau diunduh, lalu analisa offline di environment terisolasi (dump = malware risk)

## 3. Combolist awareness

- Tujuan OSINT: tahu apakah email/nomor target muncul di combolist yang beredar (indikasi kredensial bocor)
- Jangan pakai combolist untuk login attempt terhadap akun orang - itu credential stuffing, ilegal di hampir semua yurisdiksi
- Kalau nemu kredensial sendiri yang bocor: rotate, jangan cuma ganti password

## 4. Darknet market watch

- Akses via Tor saja, dari VM dedicated, dengan OPSEC penuh (lihat osint-opsec)
- Fokus: listing data target (database dijual), actor profile, reputation
- Jangan interaksi transaksi/komunikasi dengan actor kecuali ada dasar hukum dan otorisasi eksplisit

## 5. Self-monitoring (domain/email sendiri)

- Monitor: paste site, breach DB, certificate transparency (subdomain tak terduga = takeover/indikator kompromi)
- Alerting sederhana: cron/schedule ke sumber di atas, diff hasil, simpan history ter-hash

## Evidence & handling

- Semua artefak (screenshot dump, HTML) di-hash dan disimpan terenkripsi
- Laporan: "identifier X exposed di breach Y tanggal Z, field A/B" - bukan isi datanya
- Repo ini publik: JANGAN simpan hasil investigasi di sini