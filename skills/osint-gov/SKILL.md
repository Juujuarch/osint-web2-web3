---
name: osint-gov
description: Government and corporate records OSINT skill - sanctions lists, corporate registries, court records, procurement, document leaks (ICIJ/OCCRP), FOIA. Includes entity-resolution matching logic for deciding whether records in different registries refer to the same person or company.
---
# OSINT Gov & Corporate Records

## Agent instruction

1. Identifikasi jenis entity (orang / perusahaan) + yurisdiksi
2. Query sumber resmi satu per satu, catat identifier resmi (registry ID, LEI, tax ID, case number)
3. Cocokkan record antar-sumber pakai COCOKLOGI di bawah - nama sama bukan bukti
4. Output: profil entity + officer network + flag sanctions + tier tiap link

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
- Hati-hati: kasus masih berjalan != fakta keputusan; catat status

## 4. Procurement & tender

- SAM.gov (US federal), EU TED, portal tender lokal
- Kegunaan: siapa pemilik vendor, kontrak dengan pemerintah, alamat, nilai kontrak

## 5. Document leaks & investigative databases

- ICIJ Offshore Leaks (Panama Papers, Pandora Papers dll) - cari entity/officer/intermediary
- OCCRP Aleph - search dokumen & dataset investigatif
- Kegunaan: kepemilikan tersembunyi, alamat, hubungan antar-entity

## 6. FOIA / informasi publik

- US FOIA + state-level public records; tiap negara punya padanan
- Proses: identifikasi agency -> drafting request -> track. Berguna untuk dokumen yang tidak terbit online

## COCOKLOGI - entity resolution (record = orang/company yang sama?)

### Orang

| Sinyal | Tier | Catatan |
|---|---|---|
| Registry/tax ID sama (NPWP, SSN terakhir 4, passport no) | KONFIRMASI | identifier resmi kekal |
| Nama + DOB exact | KUAT | DOB langka jadi pembeda |
| Nama + alamat terap | KUAT | alamat sama persis |
| Officer di perusahaan yang sama + periode sama | KUAT | kombinasi |
| Nama exact + kota | SEDANG | nama umum = lemah |
| Fuzzy name (transliterasi: Muhammad/Mohamed/Mohammad, Wong/Wan) | SEDANG | periksa alias & DOB |
| Nama saja | LEMAH | bukan sinyal |
| Email/nomor di filing sama dengan milik target | KUAT | |

### Perusahaan

| Sinyal | Tier | Catatan |
|---|---|---|
| Company number / registry ID sama | KONFIRMASI | |
| LEI sama | KONFIRMASI | |
| Nama + registered address exact | KUAT | |
| Officer set overlap >= 50% + periode sama | KUAT | |
| Nama mirip | LEMAH | nama PT bisa sama beda kota |
| Domain/email pattern sama | SEDANG | |

### Aturan verdict

- confirmed: identifier resmi sama (registry ID / LEI / DOB+ID)
- probable: >= 2 KUAT (nama+DOB+alamat, atau officer+periode+address)
- possible: 1 KUAT atau fuzzy name + atribut umum
- rejected: registry ID beda (entity beda), DOB beda > margin error, officer periode tidak overlap sama sekali

### Jebakan umum

- Nama orang sama di registry beda negara/kota - selalu cek yurisdiksi
- Perusahaan rename/merge: nama beda tapi registry ID sama = confirmed
- Pasangan/keluarga pakai alamat sama - jangan merge otomatis
- Officer nominee (orang pinjam nama) - record resmi benar tapi kontrol sebenarnya
- Transliterasi nama Arab/Tionghoa/India bikin false match

## Evidence

Simpan: sumber resmi, nomor dokumen/filing, tanggal, hash PDF. Kasih confidence: registry resmi = tinggi; mesin pencari/agregator = verifikasi ulang ke sumber primer.