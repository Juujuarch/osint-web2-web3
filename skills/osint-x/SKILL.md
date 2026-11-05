---
name: osint-x
description: X (Twitter) identity OSINT skill. Use when the starting point is an X username (current or old) or a real person name - track username changes, display name changes, and bio changes via public archives and mirrors, and apply matching logic to confirm that two handles, or a handle and a real name, are the same identity.
---
# OSINT X (Twitter)

Entry point: **username X** (yang diketahui sekarang) atau **nama asli**. Output: timeline handle/bio + keputusan identitas dengan confidence + evidence.

## Konsep kunci (fondasi semua teknik di bawah)

1. **User ID numerik bersifat kekal.** Handle bisa berubah kapan saja; user ID tidak pernah berubah. Ini anchor utama pencocokan.
2. **Tweet ID kekal, authorship mengikuti handle sekarang.** URL tweet lama yang dibuat waktu akun masih @lama, kalau dibuka sekarang menampilkan @baru. Ini bukti konfirmasi username change.
3. **Arsip = sumber sejarah.** Wayback Machine, archive.today, dan mirror pihak-ketiga menyimpan versi profil masa lalu: display name, bio, avatar, link.
4. **Handle change itu biasa** (rebrand, akun lama kompromi, pivot persona, pindah username). Jangan asumsikan handle beda = orang beda.

## Entry A - mulai dari username X sekarang

1. **Baseline profil saat ini**: display name, bio, lokasi, link, join date, follower/following, foto profil (simpan + hash), pinned tweet, tweet terakhir
2. **Riwayat**: `bash tools/x-history.sh <handle>`
3. Untuk tiap snapshot arsip: catat tanggal + display name + bio + avatar + link -> satu baris timeline
4. Handle lama yang muncul (dari arsip, mention, atau mirror) -> jalankan lagi `tools/x-history.sh <handle-lama>`
5. **Pivot keluar**: link di bio -> domain (osint-web2), foto profil -> osint-geo, handle kripto -> osint-web3

## Entry B - mulai dari nama asli

1. **Kumpulkan kandidat akun**:
   - Search engine: `"Nama Lengkap" site:x.com`, `"Nama Lengkap" site:twitter.com`
   - Google/Bing: `"Nama Lengkap" twitter OR x.com`, variasi ejaian, inisial
   - People search & social aggregator (lihat osint-web2)
2. **Baseline tiap kandidat** (sama seperti Entry A langkah 1)
3. **Terapkan matching logic** di bawah - hanya lanjut kalau confidence minimal *probable*
4. Kalau kandidat kuat, lacak riwayat handle/bio-nya seperti Entry A

## Deteksi username change

| Teknik | Cara | Kekuatan |
|---|---|---|
| **Tweet lama -> authorship** | Ambil URL tweet lama (dari arsip, mention, atau hasil search). Buka. Author yang tampil = handle sekarang. Beda dari handle saat tweet dibuat = change terkonfirmasi | Konfirmasi |
| **User ID kekal** | Cari ID numerik di HTML arsip/response - paling mudah dari URL gambar profil: `pbs.twimg.com/profile_images/<USER_ID>/...`. ID sama di dua handle = akun sama | Konfirmasi |
| **CDX arsip handle lama** | Snapshot handle lama setelah tanggal perubahan akan menampilkan handle baru (profil yang sama). Batas waktu perubahan = antara snapshot terakhir dengan handle lama dan snapshot pertama dengan handle baru | Kuat |
| **Mention handle lama** | Cari `@oldhandle` di pencarian/Google. Konteks tweet sering memuat "dulu known as", "previously", "akun lama" | Kuat |
| **Mirror pihak-ketiga** | xstalk, sotwe, twstalker, threadreaderapp dll menyimpan cache profil + kadang histori | Pendukung |
| **Display name continuity** | Nama tampil sama persis lintas dua handle dengan gap waktu rapat | Sedang |

## Deteksi bio change

1. Bandingkan bio antar snapshot arsip: teks exact + hash tiap versi
2. Sertakan field lain yang ikut berubah: display name, avatar (pakai perceptual hash, bukan exact hash - avatar sering di-recompress), lokasi, link, pinned tweet
3. Format timeline (satu baris per versi):

```
<tanggal UTC> | <handle saat itu> | <display name> | <bio text> | <avatar pHash> | <link> | <sumber URL arsip>
```

4. Kalau snapshot banyak, diff sederhana antar baris cukup; yang dicari adalah **perubahan makna** (pindah kota, gaji/profesi, hubungan, proyek baru) bukan typo

## Logika pencocokan (matching logic)

| Sinyal | Kekuatan | Catatan |
|---|---|---|
| User ID numerik sama | Konfirmasi | Kekal sepanjang hidup akun |
| Tweet lama + authorship handle baru | Konfirmasi | Tweet ID kekal |
| Avatar match lintas waktu (perceptual hash) | Kuat | Orang jarang ganti foto; recompress tetap mirip |
| Overlap bio text / link personal | Kuat | Link domain pribadi atau email langka = sinyal kuat |
| Overlap follower graph (mutual konsisten) | Kuat | Lihat 10-20 mutual teratas, bukan jumlah |
| Join date sama | Kuat | Tanggal pembuatan akun tidak berubah |
| Display name sama persis | Sedang | Nama umum = lemah; nama langka = naik jadi kuat |
| Gaya bahasa, jam posting, topik | Pendukung | Kombinasikan dengan sinyal lain |
| Handle mirip | Lemah | Handle bisa dibeli, direbut, atau dijual |

Aturan keputusan:

- **confirmed**: minimal 1 sinyal konfirmasi (user ID sama, atau tweet lama->authorship)
- **probable**: minimal 2 sinyal kuat, tanpa kontradiksi
- **possible**: 1 sinyal kuat atau beberapa pendukung
- **rejected**: ada kontradiksi keras - user ID beda, join date beda jauh, follower graph nol tumpang-tindi, topik/l Bahasa tidak konsisten

Kalau hasil *possible*: laporkan sebagai hipotesis dengan daftar sinyal, jangan sebagai fakta.

## OPSEC

- Fase arsip (Wayback, archive.today, mirror) = **pasif**, tidak menyentuh X sama sekali
- Kalau harus buka X langsung: browser profile dedicated, tanpa login, jangan follow/like/reply - interaksi = jejak yang bisa dilihat target
- Jangan pernah search nama target pakai akun personal
- Hasil kerja (screenshot, HTML) di-hash dan disimpan terenkripsi di luar repo ini

## Output standar

1. Timeline handle/display name/bio (format baris di atas)
2. Tabel pencocokan: sinyal -> kekuatan -> bukti (URL, user ID, tweet ID, timestamp UTC)
3. Verdict: confirmed / probable / possible / rejected + alasan
4. Daftar pivot lanjutan (domain, foto, handle lain)