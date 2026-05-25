# Project state

A point-in-time on-chain snapshot of the Anisian (ANI) protocol. The numbers below are pinned to a specific block; to regenerate them, see *How to refresh* at the bottom.

## Snapshot

| Field | Value |
| --- | --- |
| Snapshot taken at | 2026-05-25 11:16:19 UTC (Base block `46459216`) |
| Token (`Anisian`) | [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) — verified, immutable |
| Burn vault | [`0xAF727167448374f73AE22e3d026D11965EDf416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B) — verified, immutable |
| Liquidity pool | [`0x2F947691C97244D845B2db2f86489D21c4c919bD`](https://basescan.org/address/0x2F947691C97244D845B2db2f86489D21c4c919bD) — Aerodrome v1 volatile **ANI / USDC** |

## Balances

| Holder | ANI | % of supply |
| --- | ---: | ---: |
| Burn vault | 78,973,348.5540 | 78.99 % |
| Aerodrome pool (LP) | 20,000,000.0000 | 20.01 % |
| Deployer wallet (`0xDc1D…6412`) | 700,000.0000 | 0.70 % |
| Personal wallet (`0x4124…AF28`) | 300,000.0000 | 0.30 % |
| **Total supply** | **99,973,348.5540** | 100.00 % |

`100,000,000 - totalSupply = 26,651.4460 ANI` already burned forever.

## Burn vault

- Total burned to date: 26,651.4460 ANI
- Pending burn at snapshot (grows continuously between calls): 11,185.9462 ANI
- `triggerBurn()` is permissionless — any wallet with a small amount of ETH on Base can call it.

## Pool reserves

| Side | Reserve |
| --- | ---: |
| USDC (native, 6 dec) | 10.0000 |
| ANI (18 dec) | 20,000,000.0000 |
| Implied price | $0.0000005 per ANI |

Any AMM trade size > a few USDC against this pool incurs material price impact. Verify on Basescan or Aerodrome before trading.

## Launch protection

- `limitsFinalized` = false (at snapshot).
- 90-day window ends 2026-08-22 22:30:01 UTC (`1787437801`). On the first transfer after that, `limitsFinalized` flips to true permanently.
- Limit-exempt: burn vault `0xAF72…416B` and personal wallet `0x4124…AF28`. Deployer wallet `0xDc1D…6412` is **not** exempt.

## Listings & integrations

| Channel | Status | Detail |
| --- | :---: | --- |
| Basescan contract verification | done | both contracts verified |
| Basescan token info (logo + links) | open | "Update Token Info" form |
| IPFS pin (project-controlled) | done | CID `bafkreigau…czjy` reachable on `ipfs.io` |
| CoinGecko | open | [new-coin form](https://www.coingecko.com/request-form/new-coin-form) |
| CoinMarketCap | open | [listing form](https://support.coinmarketcap.com/hc/en-us/articles/360043659351) |
| Trust Wallet assets | PR open | [#36846](https://github.com/trustwallet/assets/pull/36846) (paid review) |
| Uniswap default-token-list | PR open | [#2496](https://github.com/Uniswap/default-token-list/pull/2496) |
| Sushiswap list | PR open | [#2370](https://github.com/sushiswap/list/pull/2370) |
| Cow Protocol token-lists | PR open, CLA pending | [#1436](https://github.com/cowprotocol/token-lists/pull/1436) — [sign CLA](https://cla-assistant.io/cowprotocol/token-lists?pullRequest=1436) |
| Aerodrome UI / gauge | open | requires Aerodrome Discord ticket; gauge additionally requires `Voter.whitelistToken(ANI)` (currently false) |

## On-chain history (informational)

| When (UTC) | Event | Detail |
| --- | --- | --- |
| 2026-05-24 18:41:59 | Vault deployed | `AnisianBurnVault` at `0xAF72…416B`; `startTime` anchored |
| 2026-05-24 (next tx) | Token deployed | `Anisian` at `0xE378…7e5f`; 100,000,000 ANI minted to deployer |
| 2026-05-24 | Aerodrome pool created | seeded with 20,000,000 ANI |
| 2026-05-24 22:30:01 | `initialize()` called | vault + pool registered; vault and ownerWallet `0x4124…AF28` marked `isLimitExempt`; 90-day protection started |
| 2026-05-24 | Vault funded | 79,000,000 ANI transferred from deployer → vault; `isFunded() = true` |
| 2026-05-24 | 300,000 ANI to personal wallet | from deployer to `0x4124…AF28` |
| 2026-05-24 23:10:19 | `triggerBurn()` #1 | 10,210.553019 ANI burned ([tx](https://basescan.org/tx/0x848d82b1d4f58bca8a01232a6f1c41c6a961050f520e725b7c694c4c1f1a2473)) |
| 2026-05-25 06:22:23 | `triggerBurn()` #2 | 16,440.892948 ANI burned ([tx](https://basescan.org/tx/0x019716837af1642c988600c8f2ed2e0cd11ea2c1aa4bd47b57f50bf5352609bb)); cumulative `totalBurned()` = 26,651.445967 ANI |
| 2026-08-22 22:30:01 | *(scheduled)* | launch protection limits permanently disable on the next transfer |

## How to refresh

The snapshot values above do not auto-update. To pull the current on-chain state:

```bash
python3 scripts/get-live-state.py    # full snapshot (balances, pool reserves, vault, launch protection)
./scripts/check-burn-progress.sh     # focused on the burn vault
```

Both scripts are read-only (no signing, no gas).

If you spot a discrepancy between this file and the current on-chain state, open a PR with the corrected numbers and the block height you read them at.
