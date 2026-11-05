---
name: osint-opsec
description: Operational security skill for OSINT work - attribution hygiene, sock puppet management, evidence chain, secure data handling, and counter-matching logic (how an adversary could link your personas, and how to break those links).
---
# OPSEC untuk OSINT

## Agent instruction

1. Sebelum investigasi: siapkan posture (VM, profile, jaringan)
2. Selama: patuhi aturan interaksi (nol jejak di sisi target)
3. Sesudah: evidence ter-hash, simpan terenkripsi, bersihkan jejak kerja
4. Audit linkability persona sebelum sesi sensitif (counter-matching di bawah)

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
- Format laporan: temuan -> bukti -> tier -> tindak lanjut. Evidence-first, bukan kesimpulan dulu

## 4. Data handling

- Hasil investigasi terenkripsi (VeraCrypt/LUKS atau encrypted archive), jangan auto-sync ke cloud pribadi
- Pisahkan "working data" dan "evidence" - working bisa dibuang, evidence disimpan
- Retensi: tentukan umur simpan; data PII orang lain jangan disimpan lebih lama dari perlu

## 5. COCOKLOGI TERBALIK - counter-matching (bagaimana lawan bisa melink kamu)

Prinsip: setiap sinyal yang dipakai buat mencocokkan target, bisa dipakai lawan buat mencocokkan persona kamu. Audit sebelum sesi sensitif.

| Vektor linkability | Risiko | Mitigasi |
|---|---|---|
| Avatar reuse antar persona | KUAT - perceptual hash sama | avatar unik per persona (generate, jangan crop foto yang sama) |
| Gaya bahasa & typo pattern | KUAT - stylometry | variasi gaya; jangan copy-paste teks antar persona |
| Jam & timezone aktivitas | SEDANG - pattern kebiasaan | jadwalkan sesi konsisten dengan zona target |
| Email pattern / recovery email | KUAT | email terpisah total, recovery terpisah |
| Device & browser fingerprint | KUAT | VM per persona, jangan share browser profile |
| Metadata file (screenshot EXIF, author field) | SEDANG | strip metadata sebelum publish/share |
| IP / ASN / netblock | KUAT | VPN/Tor terpisah per persona, jangan VPN gratis |
| Username handle reuse | SEDANG | variasi, jangan pola sama |
| Nomor telepon recovery | KUAT | nomor terpisah, atau tanpa telepon |
| Domain / link personal di profil | KUAT | domain terpisah per persona |

### Aturan audit (jalanin sebelum sesi sensitif)

1. Bandingkan semua persona aktif: ada avatar mirip? handle mirip? email pattern sama?
2. Cek metadata file yang akan di-share
3. Pastikan VM/network sesi ini tidak pernah dipakai identitas asli
4. Kalau ada 1+ vektor KUAT yang belum dimitigasi -> JANGAN lanjut, perbaiki dulu

## 6. Legal boundary

- Punya otorisasi/dasar hukum sebelum investigasi mendalam (kontrak pentest, ownership, kepentingan publik yang jelas)
- Hormati ToS platform; scraping agresif = risiko hukum + expose IP kamu
- Kalau ragu: stop, dokumentasikan, minta nasihat hukum