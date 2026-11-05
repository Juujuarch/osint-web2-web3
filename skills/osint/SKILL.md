---
name: osint
description: Entry-point router for any OSINT task across web2 and web3. Use at the start of an investigation to map the starting identifier (email, username, phone, domain, wallet, photo, name, X handle) to the right domain skill, and to apply the global confidence framework for every match.
---
# OSINT Router

Satu pintu masuk untuk semua investigasi. Tugas router: tentukan skill domain, sumber, urutan langkah, dan framework confidence untuk setiap klaim pencocokan.

## FRAMEWORK CONFIDENCE GLOBAL (berlaku di SEMUA skill)

Setiap klaim "A = B" atau "A milik orang X" WAJIB memakai tier ini. Tanpa tier, klaim bukan temuan.

### Tier sinyal

| Tier | Definisi | Contoh |
|---|---|---|
| **KONFIRMASI** | Identifier kekal yang identik | user ID numerik X, tweet ID -> authorship, wallet signature, GPS EXIF, registry ID (NPWP/LEI/company number), hash kredensial cocok |
| **KUAT** | Atribut langka yang cocok | avatar perceptual hash, link personal/domain, follower graph overlap, join date, ENS, alamat terap |
| **SEDANG** | Atribut umum yang cocok | display name, overlap bio text, nama+domisili, phone carrier |
| **PENDUKUNG** | Pola perilaku | gaya bahasa, jam posting, timing tx, nilai bulat |
| **LEMAH** | Kemiripan dangkal | handle mirip, nama umum, "mirip orangnya" |

### Aturan verdict

| Verdict | Syarat |
|---|---|
| **confirmed** | >= 1 sinyal KONFIRMASI, tanpa kontradiksi |
| **probable** | >= 2 sinyal KUAT, tanpa kontradiksi |
| **possible** | 1 KUAT, atau >= 2 SEDANG, atau kombinasi SEDANG+PENDUKUNG |
| **rejected** | ada kontradiksi keras (identifier kekal beda, tanggal beda jauh, graph nol overlap) |

### Aturan kontradiksi

1. Satu kontradiksi keras = rejected, apa pun sinyal positifnya
2. Kontradiksi lunak (misal timezone beda) = turunkan 1 tier + catat
3. Klaim tanpa tier = bukan temuan, jangan masuk laporan
4. Hasil possible: laporkan sebagai hipotesis + daftar sinyal + apa yang bisa mengonfirmasi/menolak

## Peta routing

| Kamu punya | Skill pertama | Skill lanjutan |
|---|---|---|
| **Nama lengkap orang (butuh dossier: phone/alamat/dll)** | **osint-people** | osint-web2, osint-gov, osint-x |
| Email | osint-web2 | osint-leak (breach), osint-gov (entity) |
| Username/handle (non-X) | osint-web2 | osint-geo (foto profil), osint-leak |
| Username X / handle X | osint-x | osint-geo (avatar), osint-leak, osint-web3 |
| Phone number | osint-web2 | osint-gov, osint-people (kembalikan ke orang) |
| Perusahaan/domain | osint-web2 | osint-gov |
| Wallet address | osint-web3 | osint-leak, osint-web2 |
| Token/NFT contract | osint-web3 | osint-gov |
| Foto/gambar | osint-geo | osint-x / osint-web2 / osint-people |
| File bocor/dump | osint-leak | osint-opsec |
| 2+ identifier yang harus disambung | osint-correlation | skill domain masing-masing |

## Aturan main

1. Read-only dulu. Fase pertama tidak pernah butuh login dan tidak meninggalkan jejak di sisi target.
2. OPSEC sebelum ekspansi. Begitu investigasi menyentuh identitas asli target, baca skills/osint-opsec/SKILL.md dulu.
3. Evidence-first. Tiap temuan: URL sumber, timestamp UTC, hash file kalau ada.
4. Satu pivot per langkah. Dari satu identifier, ekspansi ke satu hipotesis; catat, lalu lanjut.
5. Setiap klaim pencocokan pakai framework di atas. Tanpa tier = bukan temuan.
6. **Legal gate** untuk identifier sensitif (NIK, data biometrik, kesehatan): baca skills/osint-people/SKILL.md bagian Legal boundary.
7. Stop kalau legal grey. Kalau langkah berikutnya butuh akses data non-publik tanpa dasar hukum, berhenti dan dokumentasikan.

## Flow standar

```
START (identifier)
  -> osint-opsec       : siapkan posture (VM / profile / jaringan)
  -> domain skill      : ekstrak atribut + pivot pertama
  -> osint-correlation : kalau ada 2+ identifier, bangun graph + verdict
  -> cross-domain      : pinjam skill lain sesuai tabel routing
  -> osint-opsec       : simpan evidence ter-hash, bersihkan jejak kerja
END (laporan: temuan bertier + evidence + verdict + confidence)
```

## Anti-pattern

- Mulai dari tool tanpa hipotesis
- Pakai akun personal untuk search target sensitif
- Simpan hasil investigasi di folder cloud yang auto-sync
- Klaim "A = B" tanpa tier konfirmasi
- Merge semua username jadi satu orang cuma karena handle mirip
- Proses NIK/data sensitif tanpa mendokumentasikan dasar hukum