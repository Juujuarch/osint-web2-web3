---
name: osint-geo
description: GEOINT and image OSINT skill - reverse image search, face search awareness, geolocation reasoning, imagery verification. Includes matching logic for deciding whether an image was actually taken at a claimed location, with confidence tiers.
---
# OSINT GEOINT

## Agent instruction

1. EXIF/metadata dulu (kalau ada = KONFIRMASI)
2. Reverse image search multi-engine
3. Geolocation reasoning: objek besar -> objek kecil -> bayangan/matahari -> cuaca
4. Verifikasi 2+ fitur independen di imagery; beri tier per fitur
5. Output: koordinat perkiraan + daftar fitur pembanding + tier + confidence

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
1. EXIF/metadata - koordinat, device, timestamp (sering sudah di-strip; kalau ada, simpan hash-nya)
2. Objek besar: bentuk bangunan, pegunungan, garis pantai, jenis vegetasi
3. Objek kecil: rambu (bahasa/format nomor), plafon listrik, stopkontak, mobil (plate format, sisi kemudi)
4. Bayangan & matahari: arah + panjang bayangan -> perkiraan waktu & arah matahari (suncalc)
5. Cuaca: kondisi cuaca di foto vs record historis

- Imagery: Mapillary (street-level crowdsourced), Sentinel/Landsat (perubahan lahan), Google Earth historical
- Verifikasi: cari 2+ fitur independen yang cocok sebelum klaim lokasi

## COCOKLOGI - apakah foto diambil di lokasi X?

| Sinyal | Tier | Catatan |
|---|---|---|
| GPS EXIF + timestamp konsisten | KONFIRMASI | verifikasi device/timestamp bisa dipalsukan, tapi default kuat |
| EXIF device + foto lain dari device sama di lokasi X | KUAT | |
| Landmark unik + nama jalan readable + plate format | KUAT | 3 fitur kecil independen |
| 2+ fitur kecil cocok (rambu bahasa + sisi kemudi + stopkontak tipe) | KUAT | |
| Sun angle konsisten dengan lokasi+waktu yang diklaim | SEDANG | men-support atau men-ontradiksi |
| Vegetasi/iklim cocok | PENDUKUNG | |
| "Mirip" / kesan visual | LEMAH | bukan sinyal |

### Aturan verdict

- confirmed: EXIF GPS (tanpa indikasi manipulasi), atau landmark unik + 2+ fitur kecil
- probable: 2+ fitur kecil independen cocok
- possible: 1 fitur kecil atau landmark umum
- rejected: kontradiksi keras - sun angle beda arah, plate format beda negara, vegetasi mustahil untuk iklim, landmark ternyata di lokasi lain

### Kontradiksi yang harus dicek

- Bayangan vs waktu yang diklaim (pagi vs sore = arah berlawanan)
- Sisi kemudi mobil vs negara (kiri vs kanan)
- Format plate / bahasa rambu vs negara
- Musim vegetasi vs tanggal foto
- Cuaca di foto vs record historis lokasi tersebut

### Jebakan umum

- Foto lama di-post ulang dengan klaim lokasi baru (cek reverse image untuk sumber asli + tanggal)
- AI-generated / edited scenery
- Landmark yang punya "kembaran" di negara lain (menara, patung, gereja yang sama)
- Street View imagery yang sudah usang vs kondisi sekarang

## 4. Verification discipline

- Klaim lokasi = high confidence hanya kalau ada match visual yang bisa diulang orang lain
- Simpan: URL imagery, koordinat perkiraan, daftar fitur pembanding, screenshot
- Foto bisa dipindahkan/diedit: latihan selalu "cari bukti foto diambil di lokasi X", bukan "fotonya mirip lokasi X"