---
name: osint-gov
description: Government and corporate records OSINT skill - sanctions lists, corporate registries, court records, procurement, document leaks (ICIJ/OCCRP), and FOIA-style requests. Use when investigating a person or company through official and public records.
---
# OSINT Gov & Corporate Records

## 1. Sanctions & watchlist

- OFAC SDN list (US), EU consolidated list, UN Security Council list, UK OFSI
- Cocokkan: nama exact + alias + fuzzy (nama bisa ditransliterasi beda)
- Output: status listed/unlisted, program, tanggal listing, identifier (DOB, passport, address kalau ada)

## 2. Corporate registry

- OpenCorporates (multi-negara), SEC EDGAR (US filing + full-text search), registry lokal per negara
- Yang dicari: officers/directors, registered address, filing history, status aktif/non-aktif
- Pivot: officer name -> orang (osint-web2), address -> cluster perusahaan lain

## 3. Court & legal records

- CourtListener (US, gratis), PACER (berbayar), registry lokal
- Cari: nama pihak, nomor perkara, jenis (civil/criminal/bankruptcy), outcome
- Hatir-hati: kasus masih berjalan != fakta keputusan; catat status

## 4. Procurement & tender

- SAM.gov (US federal), EU TED, portal tender lokal
- Kegunaan: siapa pemilik vendor, kontrak dengan pemerintah, alamat, nilai kontrak

## 5. Document leaks & investigative databases

- ICIJ Offshore Leaks (Panama Papers, Pandora Papers dll) - cari entity/officer/intermediary
- OCCRP Aleph - search dokumen & dataset investigatif
- Kegunaan: kepemilikan tersembunyi, alamat, hubungan antar-entity

## 6. FOIA / informasi publik

- US FOIA + state-level public records; tiap negara punya padanan (UUD Information di UK, dsb)
- Proses: identifikasi agency -> drafting request -> track. Berguna untuk dokumen yang tidak terbit online

## Evidence

- Simpan: sumber resmi, nomor dokumen/filing, tanggal, hash PDF
- Kasih confidence: registry resmi = tinggi; mesin pencari/agregator = verifikasi ulang ke sumber primer