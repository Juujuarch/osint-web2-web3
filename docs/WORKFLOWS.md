# Workflow per Skenario

Semua workflow mengikuti flow router: OPSEC -> domain skill -> cross-domain -> evidence.

## 1. Email -> akun & eksposur

1. osint-opsec: siapkan posture
2. osint-web2: validitas/MX -> gravatar -> GitHub search
3. osint-leak: breach search (k-anonymity) -> catat nama breach + field
4. osint-gov: kalau email korporat -> domain -> registry
5. Output: daftar akun, status eksposur, entity terkait + confidence

## 2. Username -> orang

1. osint-web2: `bash tools/username-hunt.sh <username>`
2. Verifikasi manual tiap match (false positive)
3. osint-geo: foto profil -> reverse search
4. osint-leak: handle muncul di paste/dump?
5. Output: peta platform -> identitas kandidat (confidence per platform)

## 3. Wallet -> entitas

1. osint-web3: label explorer -> first funding -> counterparty
2. Clustering: common-input, gas funder, deposit pattern
3. Cross-chain: bridge tx -> address pasangan
4. osint-web2: ENS/sosial yang ke-link
5. Output: hipotesis pemilik + bukti on-chain (chain/block/tx) + confidence

## 4. Cek kebocoran untuk aset sendiri

1. osint-leak self-monitoring: email/domain sendiri di breach DB, paste, crt.sh
2. Kalau exposed: rotate kredensial, cek scope (password vs hash vs phone)
3. Dokumentasikan timeline + tindakan

## 5. Perusahaan -> profil resmi

1. osint-gov: registry (officers, address, filing) -> sanctions check
2. osint-web2: domain footprint, email pattern
3. osint-gov: procurement/tender history
4. Output: profil entity + officer network + flag sanctions

## 6. Foto -> lokasi

1. osint-geo: EXIF -> reverse image (Lens, Yandex, TinEye)
2. Geolocation reasoning: bayangan, rambu, mobil, vegetasi
3. Verifikasi 2+ fitur independen di Mapillary/Sentinel
4. Output: koordinat perkiraan + daftar fitur pembanding + confidence