# Anisian (ANI)

Anisian is a **fixed-supply, immutable ERC-20 token on Base** with a deflationary halving burn schedule.

- **100,000,000 ANI** minted once at deployment.
- **~79,000,000 ANI** will be burned over **~14 years** via a permissionless burn vault (`triggerBurn` callable by anyone).
- **No admin, no mint, no pause, no upgrade proxy.** Once deployed, nobody — not even the deployer — can change the rules.

> Wallets are recommended to fetch token information from this repository or the official explorer pages linked below.

---

## On-chain addresses (Base mainnet, chainId `8453`)

| Role | Address |
| --- | --- |
| ANI token | [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) |
| Burn vault | [`0xAF727167448374f73AE22e3d026D11965EDf416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B) |
| Liquidity pool | [`0x2f947691c97244d845b2db2f86489d21c4c919bd`](https://basescan.org/address/0x2f947691c97244d845b2db2f86489d21c4c919bd) |
| Owner wallet (limit-exempt) | [`0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28`](https://basescan.org/address/0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28) |

Contracts are verified on Basescan — source code matches this repository exactly.

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
https://raw.githubusercontent.com/anisian/anisian_contracts/main/tokenlist.json
```

---

## Repository layout

```
.
├── contracts/
│   ├── Anisian.sol              # ERC-20 token (100M fixed supply, launch protection)
│   ├── AnisianBurnVault.sol     # Halving burn schedule, permissionless triggerBurn
│   └── interfaces/IAnisian.sol
├── ipfs/
│   ├── ani-logo-128.png
│   ├── ani-logo-256.png
│   ├── ani-logo-512.png
│   ├── ani-logo-512-white-bg.png
│   └── token-metadata.json      # ERC-721/ERC-20 style metadata (also pinned on IPFS)
├── tokenlist.json               # Uniswap Token List
├── info.json                    # Short project descriptor
├── deploy-addresses.txt         # Deployed addresses
├── .remix/settings.json         # Solidity 0.8.24, optimizer runs=200, evm=cancun, viaIR=false
├── LICENSE
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

---

## License

[MIT](./LICENSE) — see file.

The contracts themselves carry an `SPDX-License-Identifier: MIT` header.
