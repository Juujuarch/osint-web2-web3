---
name: osint-web3
description: Web3 on-chain OSINT skill for wallet attribution, address clustering, cross-chain pivots, and holder/token graph analysis, with matching logic for attribution verdicts. Strictly read-only - never signs or sends transactions. Use when investigating a wallet, contract, token, or NFT holder set.
---
# OSINT Web3 (read-only)

Hard rules: never sign, never send transactions, never request private keys/seeds. All data comes from public RPCs, block explorers, or public APIs.

## Agent instruction

1. Baseline the address: balance, first seen, first funding, counterparty set, ENS
2. Run clustering heuristics (not certainties) - tier each signal
3. Attribution verdict per the rules below
4. Output: ownership/entity hypothesis + on-chain evidence (chain/block/tx) + tier

## 1. Wallet attribution

Goal: answer "who/what is this" for one address.

- Public labels: block explorers (Etherscan etc.), community attribution datasets
- First funding: the first incoming tx -> who sent it (exchange deposit, bridge, or someone's EOA)
- Counterparties: repeated opposing addresses -> exchange, mixer, known contract
- ENS / naming: reverse resolve + social profiles linked to ENS (bridge to web2)

## 2. Clustering (heuristics, not certainties)

| Signal | Meaning | Tier |
|---|---|---|
| Common-input ownership | Multiple inputs from the same address in one tx = likely one owner | STRONG |
| Signed message from the address | The address signs/claims a statement (ENS, login, airdrop claim) | CONFIRMED |
| Exchange deposit address | Only receives from many users, sends to hot wallet | STRONG for "this is an exchange" |
| Same gas funder | Addresses funded from one source | MEDIUM-STRONG |
| Bridge tx pair | Deposit on chain A, mint on chain B from the same batch | STRONG |
| Same ENS name | Two addresses resolve to the same ENS | STRONG |
| Timing & amount patterns | Regular txs, round amounts, working hours | SUPPORTING |
| Similar tx amounts | Many identical-value txs | WEAK (could be bots/copy-trading) |

Always report clustering as confidence, not fact. One owner can hold many wallets; one wallet can be controlled by many parties (exchange, multisig, custodial).

## 3. Cross-chain pivot

- Same EVM address (ETH/BSC/Polygon/Arbitrum/Base/Optimism) -> check balance & activity per chain
- Bridge txs (deposit/withdraw events) -> counterpart address on the other chain
- Wrapped assets (WETH/WMATIC/WBTC) -> the underlying can reveal funding source
- Non-EVM (Solana, TON, etc.): use each chain's explorer; do not assume linkage without evidence - a cross-chain signed message is strong evidence

## 4. Holder / token graph

- Holder set from Transfer events (via explorer API or public RPC log queries)
- Graph: who funds whom, who provides LP, who received an airdrop and sold (farm pattern)
- Sync with web2: holder address -> ENS -> social -> osint-web2

## MATCHING LOGIC - attribution verdicts

### Verdict rules

| Verdict | Requirement |
|---|---|
| **confirmed** | signed message from the address, KYC label from an exchange (via legal process), or common-input + deposit pattern consistently pointing to one entity |
| **probable** | >= 2 STRONG signals (common-input + same gas funder; ENS + bridge pair) |
| **possible** | 1 STRONG or several SUPPORTING signals |
| **rejected** | contradiction: two addresses claimed as one owner but never share input/funder/bridge AND have zero graph overlap; or the address is an exchange address attributed to an individual |

### On-chain contradictions

- Two addresses claimed as one person but with no shared inputs/funders/bridges and zero graph overlap -> the "same owner" claim is unsupported (rejected as a claim, not as ownership)
- Exchange address claimed as "owned by an individual" -> rejected (ownership = many users)
- Mixer address attributed to a specific person -> possible at best

### Common traps

- Address reuse by others (testnet, faucets)
- Copy-trading/bots: similar amounts, different owners
- Dust attacks: small txs from strangers are not relationships
- An exchange-funded address does not make the target the exchange account owner

## Tools & sources

- Curated sources: docs/SOURCES.md (Web3 category) + docs/API-CATALOG.md
- Deep analysis of a single protocol/dex: create a narrow skill with a command table + zero-dependency script + --json output
- All read-only: public RPCs + explorer APIs are enough

## Evidence

Record: chain id, block number, tx hash, address, UTC timestamp, and the script/version used so results are reproducible.