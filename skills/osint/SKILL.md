---
name: osint
description: Entry-point router for any OSINT task across web2 and web3. Use at the start of an investigation to map the starting identifier (email, username, phone, domain, wallet, photo, name, X handle) to the right domain skill, sources, and OPSEC posture.
---
# OSINT Router

Satu pintu masuk untuk semua investigasi. Tugas router: tentukan skill domain, sumber, dan urutan langkah - bukan langsung nembak tool.

## Peta routing

| Kamu punya | Skill pertama | Skill lanjutan |
|---|---|---|
| Email | osint-web2 | osint-leak (breach), osint-gov (entity) |
| Username/handle (non-X) | osint-web2 | osint-geo (foto profil), osint-leak |
| **Username X / handle X** | **osint-x** | osint-geo (avatar), osint-leak, osint-web3 (handle kripto di bio) |
| **Nama asli orang** | **osint-x** (cari akun X + matching logic) | osint-web2 (platform lain), osint-gov (registry, court) |
| Phone number | osint-web2 | osint-gov (carrier/registry per negara) |
| Perusahaan/domain | osint-web2 | osint-gov (registry, procurement) |
| Wallet address | osint-web3 | osint-leak (paste/dox), osint-web2 (linked social) |
| Token/NFT contract | osint-web3 | osint-gov (kalau issuer terdaftar) |
| Foto/gambar | osint-geo | osint-x / osint-web2 (cari pemilik foto) |
| File bocor/dump | osint-leak | osint-opsec (handling) |

## Aturan main (berlaku semua domain)

1. Read-only dulu. Fase pertama tidak pernah butuh login dan tidak meninggalkan jejak di sisi target.
2. OPSEC sebelum ekspansi. Begitu investigasi menyentuh identitas asli target, baca skills/osint-opsec/SKILL.md dulu.
3. Evidence-first. Tiap temuan disimpan dengan URL sumber, timestamp akses UTC, dan hash file kalau ada.
4. Satu pivot per langkah. Dari satu identifier, ekspansi ke satu hipotesis; catat, lalu lanjut.
5. Stop kalau legal grey. Kalau langkah berikutnya butuh akses data non-publik tanpa dasar hukum, berhenti dan dokumentasikan.

## Flow standar

```
START (identifier)
  -> osint-opsec   : siapkan posture (VM / profile / jaringan)
  -> domain skill  : ekstrak atribut + pivot pertama
  -> cross-domain  : pinjam skill lain sesuai tabel routing
  -> osint-opsec   : simpan evidence ter-hash, bersihkan jejak kerja
END (laporan temuan + confidence per temuan)
```

## Anti-pattern

- Mulai dari tool tanpa hipotesis
- Pakai akun personal untuk search target sensitif
- Simpan hasil investigasi di folder cloud yang auto-sync
- Klaim "handle A = handle B" atau "akun = orang X" tanpa sinyal konfirmasi (user ID sama, tweet lama -> authorship)