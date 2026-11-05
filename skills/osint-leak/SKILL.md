---
name: osint-leak
description: Leak and breach exposure OSINT skill - breach search (k-anonymity safe), paste monitoring, combolist awareness, darknet market watch, and self-monitoring for owned domains/emails. Includes matching logic for deciding whether a leak record actually refers to the target.
---
# OSINT Leak & Breach

## Agent instruction

1. Breach search (k-anonymity) - catat: nama breach, tanggal, field ter-expose
2. Kalau nemu record: cocokkan ke target pakai COCOKLOGI di bawah - JANGAN asumsikan nama sama = orang sama
3. Handle artefak dengan OPSEC (dump = malware risk)
4. Output: status eksposur bertier + scope field + tindakan

## 1. Breach search untuk email/identifier

- Gunakan model k-anonymity (HIBP range API): kirim hanya prefix hash SHA-1, cocokkan suffix secara lokal. Jangan kirim identifier utuh ke layanan yang tidak dipercaya.
- Catat: nama breach, tanggal, field yang ter-expose (email/hash/password/phone). Jangan unduh isi breach-nya - cukup konfirmasi eksposur.
- Sumber: docs/SOURCES.md + docs/API-CATALOG.md kategori Breach & Leak.

## 2. Paste & public dump

- Pastebin-like: cari via API/search engine (site:pastebin.com "domain" dsb)
- Kalau nemu dump yang relevan: catat URL + timestamp, hash file kalau diunduh, lalu analisa offline di environment terisolasi

## 3. Combolist awareness

- Tujuan OSINT: tahu apakah email/nomor target muncul di combolist yang beredar (indikasi kredensial bocor)
- Jangan pakai combolist untuk login attempt terhadap akun orang - itu credential stuffing, ilegal di hampir semua yurisdiksi
- Kalau nemu kredensial sendiri yang bocor: rotate, jangan cuma ganti password

## 4. Darknet market watch

- Akses via Tor saja, dari VM dedicated, dengan OPSEC penuh (lihat osint-opsec)
- Fokus: listing data target (database dijual), actor profile, reputation
- Jangan interaksi transaksi/komunikasi dengan actor kecuali ada dasar hukum dan otorisasi eksplisit

## 5. Self-monitoring (domain/email sendiri)

- Monitor: paste site, breach DB, certificate transparency (subdomain tak terduga = indikator kompromi)
- Alerting sederhana: cron/schedule ke sumber di atas, diff hasil, simpan history ter-hash

## COCOKLOGI - apakah record leak ini target kita?

| Sinyal | Tier | Catatan |
|---|---|---|
| Hash kredensial cocok dengan hash milik sendiri (k-anonymity match penuh) | KONFIRMASI | hanya untuk aset sendiri |
| Email exact + email langka (bukan gmail/hotmail generik) | KUAT | email langka = kuat |
| Email exact tapi domain umum (gmail, yahoo) | SEDANG | email bisa dipakai ulang / typo-squat |
| Phone exact | KUAT | nomor bisa didaur ulang, cek tanggal breach vs pemakaian |
| Nama + DOB + kota sama | KUAT | kombinasi langka |
| Nama + kota saja | SEDANG | nama umum = lemah |
| Username/handle di record | SEDANG | cocokkan dengan atribut lain |
| Nama saja | LEMAH | bukan sinyal |
| Password hash cocok dengan hash password lama sendiri | KONFIRMASI | bukti langsung |

### Aturan verdict

- confirmed: hash cocok (aset sendiri) atau kombinasi email langka + phone exact + nama/DOB
- probable: email exact (non-generik) atau phone exact, tanpa kontradiksi tanggal
- possible: nama + kota, atau username saja
- rejected: tanggal breach SEBELUM email/nomor itu ada di tangan target (mustahil) - misal breach 2013 tapi email dibuat 2020

### Jebakan umum

- Nama umum (Budi Santoso) di breach = bukan bukti itu target
- Email gmail dengan dot-variation (john.doe vs johndoe) - beda akun
- Record lawas dari orang sebelumnya yang pakai email/nomor sama
- Data fabricasi penjual darknet (20-40% listing sering palsu/diedit)

## Evidence & handling

- Semua artefak (screenshot dump, HTML) di-hash dan disimpan terenkripsi
- Laporan: "identifier X exposed di breach Y tanggal Z, field A/B" - bukan isi datanya
- Repo ini publik: JANGAN simpan hasil investigasi di sini