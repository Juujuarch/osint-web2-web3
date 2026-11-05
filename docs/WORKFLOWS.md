# Workflow per Skenario

Semua workflow: OPSEC -> domain skill -> correlation -> evidence. Setiap klaim pencocokan bertier (framework global di skills/osint/SKILL.md).

## 1. Nama lengkap -> dossier (phone, alamat, NIK, dll)

1. osint-opsec: posture + legal gate (dasar hukum untuk data sensitif?)
2. osint-people Phase 1: candidate discovery (search operator, people-search, registry, sosial, akademik)
3. Phase 2 enrichment per kandidat: phone (people-search/breach/dokumen publik), alamat (registry/court/dokumen), pekerjaan, jejak digital, identifier resmi (KANAL LEGAL ONLY untuk NIK)
4. Phase 3 cocoklogi: tier tiap atribut, verdict per kandidat
5. Kalau ada identifier lain yang ketemu (email/phone/username): sambungkan via osint-correlation
6. Output: dossier pakai template (ringkasan verdict, per-kandidat bertier, evidence hash, tindak lanjut)

## 2. Email -> akun & eksposur

1. osint-opsec: siapkan posture
2. osint-web2: validitas/MX -> gravatar -> GitHub search
3. osint-leak: breach search (k-anonymity) -> catat nama breach + field
4. osint-gov: kalau email korporat -> domain -> registry
5. Output: daftar akun bertier, status eksposur, entity terkait

## 3. Username (non-X) -> orang

1. osint-web2: `bash tools/username-hunt.sh <username>`
2. Verifikasi manual tiap match (false positive)
3. osint-geo: foto profil -> reverse search
4. osint-leak: handle muncul di paste/dump?
5. Output: peta platform -> identitas kandidat (confidence per platform)

## 4. Username X -> riwayat & identitas

1. osint-opsec: siapkan posture (fase arsip = pasif)
2. osint-x Entry A: baseline profil sekarang (display name, bio, join date, avatar hash, pinned)
3. `bash tools/x-history.sh <handle>` -> snapshot arsip
4. Bangun timeline: tanggal | handle | display name | bio | avatar | link | sumber
5. Deteksi change: bio berubah; handle beda -> cek USER ID (`pbs.twimg.com/profile_images/<USER_ID>/...`); tweet lama -> authorship = handle baru
6. Handle lama -> `bash tools/x-history.sh <handle-lama>` -> perpanjang timeline
7. Pivot: link bio -> osint-web2, avatar -> osint-geo, handle kripto -> osint-web3
8. Output: timeline + daftar change + evidence

## 5. Nama asli -> akun X (tanpa handle awal)

1. osint-x Entry B: kandidat (`"Nama Lengkap" site:x.com`, Google/Bing, people search)
2. Baseline tiap kandidat (profil + arsip)
3. Matching logic: konfirmasi (user ID sama / tweet lama->authorship), kuat (avatar, bio/link, follower graph, join date)
4. Verdict per kandidat; probable+ -> lanjut workflow #4
5. Output: tabel kandidat x sinyal x verdict

## 6. Cek kebocoran untuk aset sendiri

1. osint-leak self-monitoring: email/domain di breach DB, paste, crt.sh
2. COCOKLOGI: hash cocok = confirmed; nama doang = possible
3. Kalau exposed: rotate kredensial, cek scope
4. Dokumentasikan timeline + tindakan

## 7. Perusahaan -> profil resmi

1. osint-gov: registry (officers, address, filing) -> sanctions check
2. osint-web2: domain footprint, email pattern
3. osint-gov: procurement/tender history
4. Output: profil entity + officer network + flag sanctions (bertier)

## 8. Foto -> lokasi

1. osint-geo: EXIF -> reverse image (Lens, Yandex, TinEye)
2. Geolocation reasoning: bayangan, rambu, mobil, vegetasi
3. Verifikasi 2+ fitur independen di Mapillary/Sentinel
4. Output: koordinat + fitur pembanding + confidence

## 9. Dua handle X -> orang yang sama?

1. Baseline kedua handle (profil + arsip)
2. Cari user ID kedua handle
3. ID sama -> confirmed; ID beda + sinyal kuat -> probable
4. Output: verdict + tabel sinyal + bukti

## 10. Multi-identifier -> satu identitas (correlation)

1. Kumpulkan atribut tiap identifier via skill domain
2. osint-correlation: cari bridge identifier (gravatar, ENS, breach record, link personal)
3. Bangun graph: node = identifier, edge = bukti bertier
4. Path strength = edge terlemah; cluster = node dengan path >= probable
5. Cek kontradiksi keras
6. Output: graph + verdict per cluster + daftar kontradiksi + pivot berikutnya