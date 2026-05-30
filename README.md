<div align="center">

<img src="https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/ipfs/ani-logo-256.png" alt="Anisian (ANI)" width="180" height="180" />

# Anisian (ANI)

[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636?logo=solidity)](https://soliditylang.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Network](https://img.shields.io/badge/Network-Base-0052FF?logo=coinbase&logoColor=white)](https://base.org)
[![Verified on Basescan](https://img.shields.io/badge/Verified-Basescan-2E78A7)](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f#code)
[![Immutable](https://img.shields.io/badge/Contracts-Immutable-success)](#)
[![No Admin](https://img.shields.io/badge/Admin-None-critical)](#)
[![Liquidity Locked](https://img.shields.io/badge/Liquidity-Locked%20forever-9333ea)](https://basescan.org/tx/0x195bd10da146618cda04bd7a0cc58548a99d076f6c012586b25aaa5fe976ed4c)

</div>

Fixed-supply, immutable ERC-20 token on Base with a deflationary halving burn schedule.

- **Supply:** 100,000,000 ANI (minted once at deployment).
- **Burn:** 79,000,000 ANI scheduled to burn over ~14 years via a permissionless `triggerBurn()` on the burn vault.
- **Liquidity:** permanently locked — LP tokens burned to `0x000…dEaD` ([tx](https://basescan.org/tx/0x195bd10da146618cda04bd7a0cc58548a99d076f6c012586b25aaa5fe976ed4c)). Nobody, including the deployer, can withdraw.
- **Admin:** none. No owner, no mint, no pause, no upgrade.

## Addresses (Base, chainId 8453)

| Role | Address |
| --- | --- |
| Token | [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) |
| Burn vault | [`0xAF727167448374f73AE22e3d026D11965EDf416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B) |
| Aerodrome ANI/USDC pool | [`0x2F947691C97244D845B2db2f86489D21c4c919bD`](https://basescan.org/address/0x2F947691C97244D845B2db2f86489D21c4c919bD) |

Both contracts are verified on Basescan and immutable.

## Add ANI to a wallet

Most wallets (MetaMask, Rabby, Coinbase Wallet, …) accept the contract address `0xE378841a3970FD43ac8aD4D1D77b068C87287e5f` on the Base network. Symbol `ANI`, decimals `18` are auto-filled.

DEX UIs and wallets supporting the [Uniswap Token List](https://tokenlists.org) standard can import this list:

```
https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/tokenlist.json
```

### ANI token (`Anisian.sol`) https://anisian.org

A standard OpenZeppelin v5.2.0 ERC-20 with a one-time setup and a 90-day buy-side launch protection.

| Function | Who can call | What it does |
|---|---|---|
| `constructor()` | (auto, at deploy) | Mints `100,000,000 ANI` once to the deployer. Sets `_initializer = msg.sender`. No further minting ever. |
| `initialize(vault, pool, ownerWallet)` | Only `_initializer`, **only once** | Wires the burn vault, registers the LP pool, marks `vault` and `ownerWallet` as limit-exempt. Starts the 90-day launch protection clock. Subsequent calls revert with `AlreadyInitialized`. |
| `burnFromVault(amount)` | Only the burn vault contract | Burns `amount` ANI from the vault's balance. Other callers revert with `NotBurnVault`. |
| `transfer / transferFrom / approve / balanceOf / allowance / totalSupply` | Anyone | Standard ERC-20 from OpenZeppelin. `_update` is overridden to apply launch limits, see below. |
| `_update(from, to, value)` | (internal hook) | Applies launch protection. After 90 days the limits flip off permanently via `limitsFinalized = true`. |

What does **not** exist (intentionally): no `mint`, no `pause`, no `setOwner`, no `upgrade`, no admin-protected setter of any kind.

### Burn vault (`AnisianBurnVault.sol`)

Holds `79,000,000 ANI` on a halving schedule. Anyone can call `triggerBurn()` at any time; the contract calculates how much should have been burned by now and burns the delta.

| Function | Type | What it does |
|---|---|---|
| `triggerBurn()` | external, **permissionless** | Burns `pendingBurn()` ANI. Reverts with `NothingToBurn` if the schedule hasn't accrued anything new, or `NotFunded` if the vault was never seeded. Emits `Burned(amount, totalBurned, msg.sender)`. |
| `vaultBalance()` | view | ANI still held by the vault. |
| `totalBurned` | view (storage) | Cumulative ANI burned across all `triggerBurn` calls. |
| `burnedTargetAt(t)` | view (pure-ish) | Cumulative ANI the schedule says should be burned by unix timestamp `t`. The math behind the schedule, fully on-chain. |
| `pendingBurn()` | view | `min(burnedTargetAt(now) − totalBurned, vaultBalance())`. The amount the next `triggerBurn` will burn. |
| `startTime` | view (immutable) | Unix timestamp when the burn schedule started (vault deployment). |
| `isFunded()` | view | Returns true once the vault has received at least `TOTAL_BURN_BUDGET` (one-time seed check). |
| `TOTAL_BURN_BUDGET`, `HALVING_PERIOD` | constants | `79_000_000 ether` and `730 days` respectively. |

There is no `withdraw`, no admin function, no way to change the schedule. The only ANI that leaves the vault is via the burn path.

### Burn schedule

Period 0 starts at vault deployment (`startTime`). Each period is **730 days** (≈ 2 years). The allocation halves every period, starting from `40M ANI`:

| Period | Years (approx) | Period allocation | Cumulative burned | Remaining in vault |
|---:|---:|---:|---:|---:|
| 0 | 0 – 2  | 40,000,000 ANI | 40,000,000 | 39,000,000 |
| 1 | 2 – 4  | 20,000,000 ANI | 60,000,000 | 19,000,000 |
| 2 | 4 – 6  | 10,000,000 ANI | 70,000,000 |  9,000,000 |
| 3 | 6 – 8  |  5,000,000 ANI | 75,000,000 |  4,000,000 |
| 4 | 8 – 10 |  2,500,000 ANI | 77,500,000 |  1,500,000 |
| 5 |10 – 12 |  1,250,000 ANI | 78,750,000 |    250,000 |
| 6 |12 – 14 |    250,000 ANI | 79,000,000 |          0 |

Within each period the schedule accrues **linearly with time** — every second a tiny additional amount becomes burnable. Anyone calling `triggerBurn()` realizes the accrued amount and pays the gas; the next call has to wait for new time to elapse.

Gas for `triggerBurn()` is paid by the caller, but the caller receives **no reward** — they pay a few cents on Base in exchange for being the one who burned ANI on behalf of the network. The burn supply goes to `0x000…dEaD` (irretrievable).

### Launch protection (first 90 days only)

Active from pool registration until `protectionEndsAt` (= `liquidityCreatedAt + 90 days`). After that block, the limits are **permanently** disabled on the first transfer that crosses the threshold.

| Situation | During 90 days | After 90 days |
|---|---|---|
| Wallet ↔ wallet transfer (no LP pool involved) | Unlimited | Unlimited |
| Sell to pool (`from = your wallet`, `to = pool`) | Unlimited | Unlimited |
| Buy from pool (`from = pool`, `to = your wallet`) | Max `10,000 ANI` per buy, max `20,000 ANI` per wallet, `10 min` cooldown between buys | Unlimited |
| LP add / remove via Router | Unlimited | Unlimited |
| Transfer involving the burn vault | Unlimited | Unlimited |
| Transfer involving the `ownerWallet` | Unlimited (limit-exempt) | Unlimited |

After the first `_update` call past `protectionEndsAt`, `limitsFinalized` is set to `true` and the limit-checking branch is permanently skipped. From that block on, ANI is a plain ERC-20 with no special rules.

### Trust model

What is enforced **by code**, on-chain, with no off-chain assumptions:

- Total supply is exactly 100,000,000 ANI, now and forever. No mint function exists.
- Only the burn vault can call `burnFromVault`; only the burn vault address (set once via `initialize`) can.
- The vault can only burn what is currently scheduled (`pendingBurn()`); it cannot burn faster than the math allows.
- The vault has no owner and no withdrawal path. Its only outbound flow is the burn function.
- The 90-day launch limits cannot be re-enabled once `limitsFinalized` flips to true.
- The LP for the Aerodrome ANI/USDC pool was transferred to `0x000…dEaD` ([proof](https://basescan.org/tx/0x195bd10da146618cda04bd7a0cc58548a99d076f6c012586b25aaa5fe976ed4c)).

What is **not** enforced by this code:

- Token price, market depth, or trading volume. Those depend on swappers and other LPs, not on the contracts.
- The price you pay for ANI on Aerodrome at any moment. Slippage and price discovery happen in the AMM, not here.

## Build / verify

Solidity `0.8.24`, optimizer enabled (runs = 200), EVM `cancun`, `viaIR = false`, OpenZeppelin Contracts `v5.2.0`. The verified source on Basescan matches `contracts/` byte-for-byte.

## License

```
MIT License

Copyright (c) 2026 Anisian

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Also stored as [`LICENSE`](./LICENSE) and as the `SPDX-License-Identifier: MIT` header in every `.sol` file.

