# Workflow per Skenario

Semua workflow: OPSEC -> domain skill -> correlation -> evidence. Setiap klaim pencocokan bertier (framework global di skills/osint/SKILL.md).

## 1. Email -> akun & eksposur

1. osint-opsec: siapkan posture
2. osint-web2: validitas/MX -> gravatar -> GitHub search
3. osint-leak: breach search (k-anonymity) -> catat nama breach + field
4. osint-gov: kalau email korporat -> domain -> registry
5. Output: daftar akun bertier, status eksposur, entity terkait

## 2. Username (non-X) -> orang

1. osint-web2: `bash tools/username-hunt.sh <username>`
2. Verifikasi manual tiap match (false positive)
3. osint-geo: foto profil -> reverse search
4. osint-leak: handle muncul di paste/dump?
5. Output: peta platform -> identitas kandidat (confidence per platform)

## 3. Username X -> riwayat & identitas

1. osint-opsec: siapkan posture (fase arsip = pasif)
2. osint-x Entry A: baseline profil sekarang (display name, bio, join date, avatar hash, pinned)
3. `bash tools/x-history.sh <handle>` -> snapshot arsip
4. Bangun timeline: tanggal | handle | display name | bio | avatar | link | sumber
5. Deteksi change:
   - bio berubah antar snapshot -> bio change
   - handle beda antar snapshot -> cari USER ID di HTML arsip (`pbs.twimg.com/profile_images/<USER_ID>/...`); ID sama = username change
   - tweet URL lama -> authorship sekarang = handle baru -> konfirmasi
6. Handle lama yang ketemu -> `bash tools/x-history.sh <handle-lama>` -> perpanjang timeline
7. Pivot: link bio -> osint-web2, avatar -> osint-geo, handle kripto -> osint-web3
8. Output: timeline + daftar change dengan tanggal batas + evidence

## 4. Nama asli -> akun X (tanpa handle awal)

1. osint-x Entry B: kandidat (`"Nama Lengkap" site:x.com`, Google/Bing, people search)
2. Baseline tiap kandidat (profil + arsip)
3. Matching logic: konfirmasi (user ID sama / tweet lama->authorship), kuat (avatar match, bio/link overlap, follower graph, join date)
4. Verdict per kandidat: confirmed / probable / possible / rejected
5. Kandidat probable+ -> lanjut workflow #3
6. Output: tabel kandidat x sinyal x verdict

## 5. Cek kebocoran untuk aset sendiri

1. osint-leak self-monitoring: email/domain di breach DB, paste, crt.sh
2. COCOKLOGI: hash cocok = confirmed; nama doang = possible
3. Kalau exposed: rotate kredensial, cek scope
4. Dokumentasikan timeline + tindakan

## 6. Perusahaan -> profil resmi

1. osint-gov: registry (officers, address, filing) -> sanctions check
2. osint-web2: domain footprint, email pattern
3. osint-gov: procurement/tender history
4. Output: profil entity + officer network + flag sanctions (bertier)

## 7. Foto -> lokasi

1. osint-geo: EXIF -> reverse image (Lens, Yandex, TinEye)
2. Geolocation reasoning: bayangan, rambu, mobil, vegetasi
3. Verifikasi 2+ fitur independen di Mapillary/Sentinel
4. Output: koordinat + fitur pembanding + confidence

## 8. Dua handle X -> orang yang sama?

1. Baseline kedua handle (profil + arsip)
2. Cari user ID kedua handle
3. ID sama -> confirmed; ID beda + sinyal kuat -> probable
4. Output: verdict + tabel sinyal + bukti

## 9. Multi-identifier -> satu identitas (correlation)

1. Kumpulkan atribut tiap identifier via skill domain
2. osint-correlation: cari bridge identifier (gravatar, ENS, breach record, link personal)
3. Bangun graph: node = identifier, edge = bukti bertier
4. Path strength = edge terlemah; cluster = node dengan path >= probable
5. Cek kontradiksi keras (user ID beda, join date beda jauh, graph nol overlap)
6. Output: graph + verdict per cluster + daftar kontradiksi + pivot berikutnya