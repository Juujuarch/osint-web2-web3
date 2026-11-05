---
name: osint-web3
description: Web3 on-chain OSINT skill for wallet attribution, address clustering, cross-chain pivots, and holder/token graph analysis, with matching logic for attribution verdicts. Strictly read-only - never signs or sends transactions. Use when investigating a wallet, contract, token, or NFT holder set.
---
# OSINT Web3 (read-only)

Aturan keras: tidak pernah signing, tidak pernah kirim tx, tidak pernah minta private key/seed. Semua data dari public RPC, block explorer, atau public API.

## Agent instruction

1. Baseline address: balance, first seen, first funding, counterparty set, ENS
2. Clustering heuristik (bukan kepastian) - catat tier tiap sinyal
3. Verdict atribusi pakai aturan di bawah
4. Output: hipotesis pemilik/entity + bukti on-chain (chain/block/tx) + tier

## 1. Wallet attribution

Tujuan: jawab "ini siapa / apa" untuk satu address.

- Label publik: block explorer (Etherscan dll), dataset attribution komunitas
- First funding: tx pertama yang masuk -> siapa pengirim (exchange deposit, bridge, atau EOA orang)
- Counterparty: daftar address lawan yang berulang -> exchange, mixer, known contract
- ENS / naming: reverse resolve + profil sosial yang di-link ENS (jembatan ke web2)

## 2. Clustering (heuristik, bukan kepastian)

| Sinyal | Artinya | Tier |
|---|---|---|
| Common-input ownership | Beberapa input dari address sama dalam satu tx = kemungkinan satu pemilik | KUAT |
| Signed message dari address | Address mengklaim/konten statement (ENS, login, airdrop claim) | KONFIRMASI |
| Deposit address exchange | Cuma terima dari banyak user, kirim ke hot wallet | KUAT untuk "ini exchange" |
| Gas funder yang sama | Address di-fund dari satu sumber | SEDANG-KUAT |
| Bridge tx pasangan | Deposit di chain A, mint di chain B dari batch sama | KUAT |
| ENS nama sama | Dua address resolve ke ENS sama | KUAT |
| Timing & pola nilai | Tx rutin, nilai bulat, jam kerja | PENDUKUNG |
| Nilai tx mirip | Banyak tx nilai identik | LEMAH (bisa bot/copy-trading) |

Selalu laporkan clustering sebagai confidence, bukan fakta. Satu pemilik bisa punya banyak wallet; satu wallet bisa dikendalikan banyak pihak (exchange, multisig, custodial).

## 3. Cross-chain pivot

- Address EVM yang sama (ETH/BSC/Polygon/Arbitrum/Base/Optimism) -> cek balance & aktivitas per chain
- Bridge tx (deposit/withdraw event) -> address pasangan di chain lain
- Wrapped asset (WETH/WMATIC/WBTC) -> underlying bisa reveal sumber dana
- Non-EVM (Solana, TON, dll): pakai explorer masing-masing; jangan assume linkage tanpa bukti - signed message cross-chain adalah bukti kuat

## 4. Holder / token graph

- Holder set dari event Transfer (via explorer API atau public RPC log query)
- Graph: siapa funding siapa, siapa LP provider, siapa terima airdrop lalu jual (farm pattern)
- Sinkronkan dengan web2: holder address -> ENS -> sosial -> osint-web2

## COCOKLOGI - attribution verdict

### Aturan verdict

| Verdict | Syarat |
|---|---|
| **confirmed** | signed message dari address, atau label KYC dari exchange (via legal process), atau common-input + deposit pattern konsisten dengan 1 entity |
| **probable** | >= 2 KUAT (common-input + gas funder sama; ENS + bridge pair) |
| **possible** | 1 KUAT atau beberapa PENDUKUNG |
| **rejected** | kontradiksi: address beda chain punya pola yang mustahil satu pemilik (misal bersamaan di 2 benua tanpa bridge record), atau masuk sanctions list berbeda entity |

### Kontradiksi khusus on-chain

- Dua address diklaim satu orang tapi tidak pernah berbagi input/funder/bridge DAN graph nol overlap -> rejected (bukan bukti beda pemilik, tapi klaim "satu orang" tidak berdasar)
- Address exchange di-klaim "milik individu" -> rejected (kepemilikan = banyak user)
- Address mixer disebut "milik X" -> hanya possible

### Jebakan umum

- Address reuse orang lain (testnet, faucet)
- Copy-trading/bot = nilai mirip tapi beda pemilik
- Dust attack: address dapat tx kecil dari stranger, jangan dianggap hubungan
- Address yang di-fund exchange bukan berarti pemilik = pemilik akun exchange

## Tools & sumber

- Kurasi sumber: docs/SOURCES.md kategori Web3 + docs/API-CATALOG.md
- Analisa mendalam satu protokol/dex: buat skill sempit terpisah dengan pola command table + zero-dependency script + output --json
- Semua read-only: cukup public RPC + explorer API

## Evidence

Simpan: chain id, block number, tx hash, address, timestamp UTC, dan script/versi yang dipakai supaya hasil bisa diulang.