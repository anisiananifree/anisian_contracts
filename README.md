<div align="center">

<img src="https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/ipfs/ani-logo-256.png" alt="Anisian (ANI)" width="180" height="180" />

# Anisian (ANI)

**Fixed-supply, immutable ERC-20 token on Base with a deflationary halving burn schedule.**

[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636?logo=solidity)](https://soliditylang.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Network](https://img.shields.io/badge/Network-Base-0052FF?logo=coinbase&logoColor=white)](https://base.org)
[![Verified on Basescan](https://img.shields.io/badge/Verified-Basescan-2E78A7)](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f#code)
[![Immutable](https://img.shields.io/badge/Contracts-Immutable-success)](#project-status-community-owned-no-maintainer)
[![No Admin](https://img.shields.io/badge/Admin-None-critical)](#project-status-community-owned-no-maintainer)
[![Trading on Aerodrome](https://img.shields.io/badge/Trading-Aerodrome-1F89F1)](https://aerodrome.finance/swap?from=0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913&to=0xE378841a3970FD43ac8aD4D1D77b068C87287e5f)

[**Buy on Aerodrome**](https://aerodrome.finance/swap?from=0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913&to=0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) · [**View on Basescan**](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) · [**Token List**](./tokenlist.json) · [**FAQ**](./docs/FAQ.md) · [**Project status**](./STATUS.md)

</div>

---

## Table of contents

- [Overview](#overview)
- [On-chain addresses](#on-chain-addresses-base-mainnet-chainid-8453)
- [System architecture](#system-architecture)
- [Supply distribution](#supply-distribution-100000000-ani-total)
- [Project status: community-owned, no maintainer](#project-status-community-owned-no-maintainer)
- [Add ANI to your wallet](#add-ani-to-your-wallet)
- [Repository layout](#repository-layout)
- [Contract summary](#contract-summary)
- [Build / verify](#build--verify)
- [Documentation](#documentation)
- [License](#license)

---

## Overview

- **100,000,000 ANI** minted once at deployment.
- **~79,000,000 ANI** scheduled to be burned over **~14 years** via a permissionless burn vault (`triggerBurn` callable by anyone).
- **No admin, no mint, no pause, no upgrade proxy.** Once deployed, nobody — not even the deployer — can change the rules.

> Wallets are recommended to fetch token information from this repository or the official explorer pages linked below.

> **⚠️ Read [`STATUS.md`](./STATUS.md) before trading or integrating.** The pool currently holds a very small amount of USDC-side liquidity; the project is **community-owned with no committed maintainer**. [`STATUS.md`](./STATUS.md) is the honest source of truth for the project's current on-chain state, what listings are done, what is blocked, and how someone can help (with time, capital, or stewardship).

---

## On-chain addresses (Base mainnet, chainId `8453`)

| Role | Address |
| --- | --- |
| ANI token | [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) |
| Burn vault | [`0xAF727167448374f73AE22e3d026D11965EDf416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B) |
| Aerodrome liquidity pool | [`0x2F947691C97244D845B2db2f86489D21c4c919bD`](https://basescan.org/address/0x2F947691C97244D845B2db2f86489D21c4c919bD) |
| Deployer / LP incentives wallet | [`0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412`](https://basescan.org/address/0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412) |
| Personal / limit-exempt wallet (registered as `ownerWallet`) | [`0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28`](https://basescan.org/address/0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28) |

Contracts are verified on Basescan — source code matches this repository exactly.

**Key dates (from on-chain state):**

| Event | UTC | Unix |
| --- | --- | --- |
| Vault `startTime` (burn schedule clock) | 2026-05-24 18:41:59 | `1779648119` |
| `liquidityCreatedAt` (launch protection clock) | 2026-05-24 22:30:01 | `1779661801` |
| `protectionEndsAt` (limits permanently disabled) | 2026-08-22 22:30:01 | `1787437801` |

---

## System architecture

```mermaid
flowchart TD
    Deployer[Deployer wallet<br/>0xDc1D..6412] -->|"deploys + mints 100M"| Token((Anisian Token<br/>0xE378..7e5f<br/><b>ERC-20 immutable</b>))
    Deployer -->|"deploys"| Vault((Burn Vault<br/>0xAF72..416B<br/><b>no admin</b>))
    Deployer -->|"creates LP"| Pool((Aerodrome Pool<br/>0x2F94..919bD))

    Token -. "79M transferred at init" .-> Vault
    Token -. "20M initial liquidity" .-> Pool
    Token -. "700K to be distributed<br/>as LP incentives" .-> Deployer
    Token -. "300K personal" .-> Personal[Personal wallet<br/>0x4124..AF28<br/><i>limit-exempt</i>]

    Vault ==>|"triggerBurn() permissionless<br/>halving schedule, 730d epochs"| Burned((🔥 Burned forever))

    Pool <==>|"trading"| Public((Public traders))

    classDef immutable fill:#0052FF,stroke:#fff,color:#fff,font-weight:bold
    classDef burn fill:#ff4444,stroke:#fff,color:#fff,font-weight:bold
    classDef wallet fill:#2a2a2a,stroke:#888,color:#fff
    class Token,Vault immutable
    class Burned burn
    class Deployer,Personal,Public wallet
```

See [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) for a complete description of the system and trust model.

---

## Supply distribution (100,000,000 ANI total)

| Allocation | Amount | Held by |
| --- | --- | --- |
| Burn vault (halving schedule, ~14 years) | 79,000,000 ANI | [`0xAF72..416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B) |
| Initial liquidity (Aerodrome ANI/USDC pool) | 20,000,000 ANI | [`0x2F94..919bD`](https://basescan.org/address/0x2F947691C97244D845B2db2f86489D21c4c919bD) |
| LP incentives (deployer wallet, to be distributed) | 700,000 ANI | [`0xDc1D..6412`](https://basescan.org/address/0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412) |
| Personal (limit-exempt wallet) | 300,000 ANI | [`0x4124..AF28`](https://basescan.org/address/0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28) |
| **Total** | **100,000,000 ANI** | (matches `INITIAL_SUPPLY`) |

The **700,000 ANI** sitting on the deployer wallet `0xDc1D..6412` are *informally* earmarked to be distributed to **Aerodrome liquidity providers** as a one-time bootstrapping incentive. The exact mechanism (gauge bribes, merkle airdrop, direct disperse) and whether this distribution happens at all is not bound by any smart contract — it is dependent on the deployer choosing to send the tokens. As of the latest snapshot in [`STATUS.md`](./STATUS.md), the 700,000 ANI are still held on `0xDc1D..6412` and have not been distributed. *If and when* they are distributed, the deployer wallet's balance goes to zero.

The **300,000 ANI** on the personal wallet `0x4124..AF28` are the founder's allocation. This wallet was registered as `ownerWallet` in `initialize()` and is therefore `isLimitExempt = true` on-chain — the 90-day launch protection limits do not apply to it. All balances are publicly verifiable on Basescan, and the totals above can be cross-checked against `scripts/get-live-state.py` or any block explorer.

See [`docs/BURN_SCHEDULE.md`](./docs/BURN_SCHEDULE.md) for the full per-epoch burn allocation table.

---

## Project status: community-owned, no maintainer

Anisian is **immutable by design**:

- The token contract has **no owner, no admin, no mint, no pause, no upgrade**. Nothing in the protocol can be changed by anyone — including the deployer.
- The burn vault has **no admin** and `triggerBurn()` is **permissionless** — anyone may call it on schedule.
- This repository is published as a public reference. There is no required maintainer; the protocol runs without one.

This repo, the logos, and the metadata are released for the community to **use, mirror, pin, fork, and submit to any wallet directory without permission**. See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for ideas.

---

## Add ANI to your wallet

Most wallets (MetaMask, Rabby, Coinbase Wallet, Trust Wallet, …) can add ANI by **contract address**:

1. Open your wallet → *Import token* / *Add custom token*.
2. Network: **Base**.
3. Contract address: `0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`
4. Symbol: `ANI` — Decimals: `18` (auto-filled from the contract).

### Token Lists (DEX wallets, aggregators)

Wallets and DEX UIs that support the [Uniswap Token List](https://tokenlists.org) standard can import this list directly:

```
https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/tokenlist.json
```

---

## Repository layout

```
.
├── contracts/
│   ├── Anisian.sol              # ERC-20 token (100M fixed supply, launch protection)
│   ├── AnisianBurnVault.sol     # Halving burn schedule, permissionless triggerBurn
│   └── interfaces/IAnisian.sol
├── docs/
│   ├── ARCHITECTURE.md          # System overview, components, trust model
│   ├── BURN_SCHEDULE.md         # Per-epoch burn allocation table
│   └── FAQ.md                   # Common questions
├── ipfs/
│   ├── ani-logo-{128,256,512}.png
│   ├── ani-logo-512-white-bg.png
│   └── token-metadata.json      # ERC-20 metadata (also pinned on IPFS)
├── scripts/
│   ├── README.md
│   ├── check-burn-progress.sh   # Query current burn vault state via Base RPC
│   └── get-live-state.py        # Print full on-chain snapshot (balances, pool reserves, prices)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── FUNDING.yml
├── tokenlist.json               # Uniswap Token List (importable URL)
├── info.json                    # Short project descriptor (Trust Wallet schema)
├── deploy-addresses.txt         # Deployed addresses
├── .remix/settings.json         # Compiler config (0.8.24, runs=200, evm=cancun, viaIR=false)
├── .editorconfig
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── STATUS.md                    # Live on-chain snapshot + listings + call for stewardship
├── LICENSE                      # MIT
└── README.md
```

---

## Contract summary

### `Anisian.sol`

- ERC-20 (`name = "Anisian"`, `symbol = "ANI"`, `decimals = 18`).
- `constructor()` mints `INITIAL_SUPPLY = 100_000_000 ether` to the deployer. No further minting exists.
- `initialize(vault, pool, ownerWallet)` — **one-time** setup callable only by the deployer:
  - Registers the burn vault.
  - Registers the single liquidity pool.
  - Marks `vault` and `ownerWallet` as limit-exempt.
  - Starts the 90-day launch-protection window.
- `burnFromVault(amount)` — only the registered burn vault can call this; it burns ANI from the vault balance.
- **Launch protection** (90 days from `initialize`, applies only to **buys from the registered LP pool**):
  - `MAX_BUY_AMOUNT = 10_000 ANI` per pool buy.
  - `MAX_WALLET_AMOUNT = 20_000 ANI` post-buy balance cap.
  - `BUY_COOLDOWN = 10 minutes` between pool buys per recipient.
  - After 90 days, limits permanently disable on the first transfer (`limitsFinalized = true`). Wallet-to-wallet transfers are never limited.

### `AnisianBurnVault.sol`

- Holds ANI for the scheduled burn.
- `TOTAL_BURN_BUDGET = 79_000_000 ANI`.
- `HALVING_PERIOD = 730 days` (2 years). Period 0 allocates 40M, each subsequent period halves (20M, 10M, 5M, …) until the budget is exhausted.
- `triggerBurn()` — **permissionless**; anyone may call. Burns up to `pendingBurn()` based on the linear-within-period schedule.
- No admin, no withdrawal, no pause.

### `interfaces/IAnisian.sol`

Minimal interface used by the vault (`burnFromVault`, `balanceOf`).

---

## Build / verify

The contracts compile in [Remix](https://remix.ethereum.org) with the settings in `.remix/settings.json`:

- Compiler: **Solidity 0.8.24**
- Optimizer: **enabled**, runs = **200**
- EVM version: **cancun**
- `viaIR`: **false**
- Imports: OpenZeppelin Contracts **v5.2.0** (`ERC20.sol`) via the in-source GitHub URL.

The verified source on Basescan matches the files in `contracts/` byte-for-byte.

To check the current burn progress from your terminal:

```bash
./scripts/check-burn-progress.sh
```

---

## Documentation

- [`STATUS.md`](./STATUS.md) — **honest, live on-chain state** of the project (TVL, listings, blockers, call for stewardship).
- [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) — system architecture, components, and trust model.
- [`docs/BURN_SCHEDULE.md`](./docs/BURN_SCHEDULE.md) — per-epoch burn schedule and math.
- [`docs/FAQ.md`](./docs/FAQ.md) — common questions about ANI.
- [`SECURITY.md`](./SECURITY.md) — security model and disclosure policy.
- [`CONTRIBUTING.md`](./CONTRIBUTING.md) — how the community can help.
- [`CHANGELOG.md`](./CHANGELOG.md) — versioned project history.

---

## License

[MIT](./LICENSE) — see file. The contracts themselves carry an `SPDX-License-Identifier: MIT` header.
