---
name: osint-web3
description: Web3 on-chain OSINT skill for wallet attribution, address clustering, cross-chain pivots, and holder/token graph analysis. Strictly read-only - never signs or sends transactions. Use when investigating a wallet, contract, token, or NFT holder set.
---
# OSINT Web3 (read-only)

Aturan keras: tidak pernah signing, tidak pernah kirim tx, tidak pernah minta private key/seed. Semua data dari public RPC, block explorer, atau public API.

## 1. Wallet attribution

Tujuan: jawab "ini siapa / apa" untuk satu address.

- Label publik: block explorer (Etherscan dll), dataset attribution komunitas
- First funding: tx pertama yang masuk -> siapa pengirim (exchange deposit, bridge, atau EOA orang)
- Counterparty: daftar address lawan yang berulang -> exchange, mixer, known contract
- ENS / naming: reverse resolve + profil sosial yang di-link ENS (jembatan ke web2)

## 2. Clustering (heuristik, bukan kepastian)

| Sinyal | Artinya | Kekuatan |
|---|---|---|
| Common-input ownership | Beberapa input dari address sama dalam satu tx = kemungkinan satu pemilik | Kuat |
| Gas funder yang sama | Address di-fund dari satu sumber | Sedang |
| Deposit address exchange | Cuma terima dari banyak user, kirim ke hot wallet | Kuat untuk "ini exchange" |
| Timing & pola nilai | Tx rutin, nilai bulat, jam kerja | Lemah - pendukung saja |

Selalu laporkan clustering sebagai confidence, bukan fakta. Satu pemilik bisa punya banyak wallet; satu wallet bisa dikendalikan banyak pihak (exchange, multisig).

## 3. Cross-chain pivot

- Address EVM yang sama (ETH/BSC/Polygon/Arbitrum/Base/Optimism) -> cek balance & aktivitas per chain
- Bridge tx (deposit/withdraw event) -> address pasangan di chain lain
- Wrapped asset (WETH/WMATIC/WBTC) -> underlying bisa reveal sumber dana
- Non-EVM (Solana, TON, dll): pakai explorer masing-masing; jangan assume linkage tanpa bukti - signed message cross-chain adalah bukti kuat

## 4. Holder / token graph

- Holder set dari event Transfer (via explorer API atau public RPC log query)
- Graph: siapa funding siapa, siapa LP provider, siapa terima airdrop lalu jual (farm pattern)
- Sinkronkan dengan web2: holder address -> ENS -> sosial -> osint-web2

## Tools & sumber

- Kurasi sumber: docs/SOURCES.md kategori Web3 (termasuk handbook On-Chain Investigations)
- Analisa mendalam satu protokol/dex: buat skill sempit terpisah dengan pola command table + zero-dependency script + output --json
- Semua read-only: cukup public RPC + explorer API

## Evidence

Simpan: chain id, block number, tx hash, address, timestamp UTC, dan script/versi yang dipakai supaya hasil bisa diulang.