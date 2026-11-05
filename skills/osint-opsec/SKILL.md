---
name: osint-opsec
description: Operational security skill for OSINT work - attribution hygiene, sock puppet management, evidence chain, and secure data handling. Read before any investigation that touches a real target identity.
---
# OPSEC untuk OSINT

## 1. Attribution hygiene

- Browser profile dedicated per kasus; nol akun personal yang login
- Search engine yang tidak memakai akun; kalau perlu, via Tor atau VPN berbayar (jangan VPN gratis)
- Pisahkan jaringan investigasi dari jaringan pribadi (VM dengan network terpisah atau host-only)
- Jam & zona waktu: kalau interaksi perlu, samakan dengan zona target (bukan zona kamu)

## 2. Sock puppet management

- Identitas konsisten: nama, email, avatar, sejarah akun yang koheren
- Aging: akun baru = suspicious; pakai akun yang sudah ada riwayat organik
- Satu persona per target/kasus - jangan reuse (satu burn = semua kasus ke-expose)
- Jangan pernah login persona dari jaringan/device yang sama dengan identitas asli

## 3. Evidence chain

- Tiap artefak: SHA-256 hash, timestamp UTC, sumber URL, tool + versi yang dipakai
- Chain of custody: siapa mengumpulkan, kapan, dari mana; perubahan apa pun tercatat
- Format laporan: temuan -> bukti -> confidence -> tindak lanjut. Evidence-first, bukan kesimpulan dulu

## 4. Data handling

- Hasil investigasi terenkripsi (VeraCrypt/LUKS atau encrypted archive), jangan auto-sync ke cloud pribadi
- Pisahkan "working data" dan "evidence" - working bisa dibuang, evidence disimpan
- Retensi: tentukan umur simpan; data PII orang lain jangan disimpan lebih lama dari perlu

## 5. Legal boundary

- Punya otorisasi/dasar hukum sebelum investigasi mendalam (kontrak pentest, ownership, kepentingan publik yang jelas)
- Hormati ToS platform; scraping agresif = risiko hukum + expose IP kamu
- Kalau ragu: stop, dokumentasikan, minta nasihat hukum