---
name: osint-correlation
description: Cross-domain identity correlation skill. Use when you have two or more identifiers (email, X handle, username, phone, wallet, name, photo, domain) and need to decide whether they belong to the same entity - with signal tiers, bridge-identifier logic, graph-based confidence, and contradiction handling.
---
# OSINT Correlation (cocoklogi lintas domain)

Skill ini jawab pertanyaan inti investigasi: **"identifier A dan identifier B orang/entitas yang sama?"** Domain skill lain mengumpulkan atribut; skill ini memutuskan.

## Agent instruction

Kalau diminta menyambungkan 2+ identifier:
1. Kumpulkan atribut tiap identifier via skill domain masing-masing
2. Cari bridge identifier (penghubung) di daftar bawah
3. Bangun graph: node = identifier, edge = bukti bertier
4. Hitung verdict pakai aturan path strength
5. Output: graph + tabel edge + verdict per pasangan + daftar kontradiksi

## Bridge identifier (penghubung antar domain)

| Dari | Ke | Bridge | Tier bridge |
|---|---|---|---|
| Email | Akun manapun | gravatar hash (MD5 email -> avatar) | KUAT |
| Email | X handle | breach/paste record, gravatar | KUAT |
| X handle | Wallet | link di bio, ENS, tweet pinned | SEDANG-KUAT |
| X handle | Email | gravatar, leak record | KUAT |
| Wallet | X handle | ENS reverse, tx memo, ENS profile sosial | SEDANG |
| Wallet | Wallet | common-input, gas funder, bridge tx | KUAT (lihat osint-web3) |
| Phone | Email/akun | breach record, fitur "cari by phone" | KUAT |
| Nama | Akun | search + verifikasi atribut | SEDANG |
| Foto | Orang | avatar pHash, face match | KUAT |
| Foto | Lokasi | landmark, EXIF | KONFIRMASI (EXIF GPS) |
| Domain | Email | whois historis | KUAT |
| Domain | Wallet | whois + on-chain funding? (lemah, hati-hati) | LEMAH |

## Graph model

- **Node**: identifier (email, handle, wallet, phone, nama, foto, domain)
- **Edge**: bukti hubungan, dengan tier (KONFIRMASI/KUAT/SEDANG/PENDUKUNG/LEMAH)
- **Path strength**: edge terlemah di sepanjang path menentukan tier path

## Aturan verdict (lintas domain)

1. **confirmed**: ada path yang memuat >= 1 edge KONFIRMASI
2. **probable**: path terkuat KUAT (edge terlemah KUAT), atau >= 2 edge KUAT independen
3. **possible**: edge terkuat SEDANG
4. **rejected**: ada kontradiksi keras di sepanjang path

**Prinsip kunci**: cluster identitas = himpunan node yang saling terhubung via path >= probable. Node terisolasi = possible, jangan di-merge.

## Kontradiksi keras (auto-reject)

| Kontradiksi | Kenapa |
|---|---|
| user ID X berbeda | user ID kekal |
| GPS EXIF beda kota di timestamp yang sama | mustahil |
| join date beda > 1 tahun pada akun "yang sama" | akun berbeda |
| registry ID (NPWP/LEI/company number) beda | entity berbeda |
| follower graph nol overlap pada akun sosial | kuat indikasi beda |
| hash kredensial tidak cocok | bukan akun yang sama |

## Kontradiksi lunak (turunkan tier + catat)

- Timezone/jam posting beda (bisa VPN/palsu)
- Gaya bahasa berubah (bisa ghostwriter/pivot)
- Avatar ganti (wajar)
- Handle berubah (wajar - lihat osint-x)

## Output format

```
## Cluster identitas (verdict: confirmed/probable/possible)
Node: <identifier list>
Edges:
  <A> --[TIER: bukti, sumber, timestamp]--> <B>
Verdict: <x> karena <alasan tier>
Kontradiksi: <daftar / tidak ada>
Pivot berikutnya: <skill + langkah>
```

## Anti-pattern

- Merge cluster karena 1 sinyal LEMAH (handle mirip)
- Lupa catat kontradiksi yang sudah dicek dan ternyata bersih
- Klaim confirmed dari >= 2 SEDANG (itu possible)
- Pake "feels right" sebagai tier