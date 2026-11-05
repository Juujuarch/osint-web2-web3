---
name: osint-geo
description: GEOINT and image OSINT skill - reverse image search, face search awareness, geolocation reasoning, and imagery verification. Use when locating where a photo was taken or identifying what is in an image.
---
# OSINT GEOINT

## 1. Reverse image search

- Engine: Google Lens, Yandex Images (paling kuat untuk wajah/objek lokal), TinEye, Bing Visual Search
- Varian: crop objek spesifik (rambu, plang, bangunan), cari dengan resize/rotate, bandingkan hasil antar-engine
- Catat: mana engine yang match, URL sumber asli, tanggal publish (bisa lebih tua dari post yang kita lihat)

## 2. Face search

- Layanan face search komersial ada tapi batas legal/etik ketat (biometric privacy: BIPA, GDPR)
- Default stance: jangan face-search orang privat tanpa dasar; untuk riset, pakai sumber publik + verifikasi manual
- Kalau dipakai: dokumentasikan dasar hukum di catatan kasus

## 3. Geolocation reasoning

Urutan analisa foto:
1. **EXIF/metadata** - koordinat, device, timestamp (sering sudah di-strip; kalau ada, simpan hash-nya)
2. **Objek besar**: bentuk bangunan, pegunungan, garis pantai, jenis vegetasi
3. **Objek kecil**: rambu (bahasa/format nomor), plafon listrik, stopkontak, mobil (plate format, sisi kemudi), kaos/kostum tim
4. **Bayangan & matahari**: arah + panjang bayangan -> perkiraan waktu & arah matahari (suncalc)
5. **Cuaca**: kondite cuaca di foto vs record historis

- Imagery: Mapillary (street-level crowdsourced), Sentinel/Landsat (perubahan lahan), Google Earth historical
- Verifikasi: cari 2+ fitur independen yang cocok sebelum klaim lokasi

## 4. Verification discipline

- Klaim lokasi = high confidence hanya kalau ada match visual yang bisa diulang orang lain
- Simpan: URL imagery, koordinat perkiraan, daftar fitur pembanding, screenshot
- Foto bisa dipindahkan/diedit: latihan selalu "cari bukti foto diambil di lokasi X", bukan "fotonya mirip lokasi X"