# Project state

> A point-in-time, **honest** snapshot of the Anisian (ANI) project — on-chain reality, listings, what works, what doesn't, and what would help.
>
> This file is the source of truth for "where the project actually stands today". It is updated by hand from public on-chain reads, not from optimism. If anything in this file contradicts the README, **this file is correct** and the README needs fixing.

---

## Snapshot

| Field | Value |
| --- | --- |
| Snapshot taken at | **2026-05-25 11:16:19 UTC** (Base block `46459216`) |
| Token (`Anisian`) | [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f) ✅ verified, immutable |
| Burn vault | [`0xAF727167448374f73AE22e3d026D11965EDf416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B) ✅ verified, immutable |
| Liquidity pool | [`0x2F947691C97244D845B2db2f86489D21c4c919bD`](https://basescan.org/address/0x2F947691C97244D845B2db2f86489D21c4c919bD) — Aerodrome v1 volatile **ANI / USDC** |
| Days since deployment | ~1 day |

### On-chain balances (live read)

| Holder | ANI | % of supply |
| --- | ---: | ---: |
| Burn vault | 78,973,348.5540 | 78.99 % |
| Aerodrome pool (LP) | 20,000,000.0000 | 20.01 % |
| Deployer wallet (`0xDc1D…6412`) | 700,000.0000 | 0.70 % |
| Personal wallet (`0x4124…AF28`) | 300,000.0000 | 0.30 % |
| **Total supply** (= sum) | **99,973,348.5540** | 100.00 % |
| Already burned forever | 26,651.4460 | (was 100,000,000 at deploy) |

### Burn vault progress

- Total burned to date: **26,651.4460 ANI**
- Pending burn (callable right now via `triggerBurn()`): **11,185.9462 ANI**
- Anyone can call `triggerBurn()` on the vault to execute the pending amount. Cost: gas only (~$0.01 on Base).

### Liquidity pool reality (this is the part nobody talks about)

| Side | Reserve |
| --- | ---: |
| USDC (native, 6 decimals) | **10.0000** |
| ANI (18 decimals) | 20,000,000.0000 |
| **Implied price** | **$0.0000005 per ANI** (= $0.5 per million) |
| **Pool TVL** | **≈ $20 USD** |
| **Implied market cap** | **≈ $50 USD** |

> **Plain English:** the pool has **ten dollars of USDC** in it. A buy of $5 worth of USDC would drain half of the USDC side and produce ~50% price impact. The pool is effectively a placeholder until additional USDC liquidity is added. Trading is technically possible but practically useless beyond a few dollars at a time.

### Launch protection (active)

- `limitsFinalized` = **false** — limits are still active for non-exempt wallets buying from the pool.
- 90-day window ends on **2026-08-22 22:30:01 UTC** (unix `1787437801`). On the first transfer after that, `limitsFinalized` flips to `true` permanently.
- Limit-exempt wallets (no buy limits): the burn vault `0xAF72…416B` and the personal wallet `0x4124…AF28`. The deployer wallet `0xDc1D…6412` is **not** exempt.

---

## Listings & integrations

| Channel | Status | Detail |
| --- | :---: | --- |
| Basescan contract verification | ✅ done | both contracts verified, source matches this repo |
| Basescan token info (logo + links) | ❌ TODO | requires the deployer to use the "Update Token Info" form |
| IPFS metadata pin (project-controlled) | ✅ done | CID `bafkreigau…czjy` returns 200 on `ipfs.io` and `gateway.pinata.cloud` |
| IPFS metadata pin (independent) | ❌ none yet | see [`CONTRIBUTING.md`](./CONTRIBUTING.md) for help |
| CoinGecko | ❌ TODO | new-coin form — only the maintainer can submit |
| CoinMarketCap | ❌ TODO | listing form — same |
| Trust Wallet assets | 🟡 PR open | [#36846](https://github.com/trustwallet/assets/pull/36846); paid review fee (500 TWT / 2.5 BNB) — not paid yet |
| Uniswap default-token-list | 🟡 PR open | [#2496](https://github.com/Uniswap/default-token-list/pull/2496) — long shot, low priority for maintainers |
| Sushiswap list | 🟡 PR open | [#2370](https://github.com/sushiswap/list/pull/2370) |
| Cow Protocol token-lists | 🟡 PR open, CLA blocked | [#1436](https://github.com/cowprotocol/token-lists/pull/1436) — needs author to sign [CLA](https://cla-assistant.io/cowprotocol/token-lists?pullRequest=1436) |
| Aerodrome UI logo + token list | ❌ not requested yet | Discord ticket needed; see template below |
| Aerodrome gauge (AERO emissions to LPs) | ❌ blocked | `isWhitelistedToken(ANI) = false` on the Voter; requires Aerodrome governance whitelist first |
| 1inch token list | ⛔ N/A | 1inch no longer maintains a public PR-able token list repo |

---

## What works right now

- The contracts run by themselves. Nothing can stop them.
- Anyone with `0.01 USD` of gas can call `triggerBurn()` and burn the pending ANI from the vault.
- Anyone can read the burn vault, token supply, and pool reserves via Basescan or `scripts/check-burn-progress.sh`.
- The IPFS-pinned logo and `token-metadata.json` (CID `bafkreigau…czjy`) are publicly fetchable.
- The GitHub repo is public, MIT-licensed, mirror-friendly, fork-friendly.

## What is blocked, and why

| Blocker | Cause | What unblocks it |
| --- | --- | --- |
| Real trading volume | Pool has $10 USDC — any buy slips dramatically | Someone has to add USDC-side liquidity (the maintainer has explicitly stated they cannot) |
| Aerodrome gauge / AERO rewards | ANI not whitelisted on the Voter contract | Aerodrome governance must `whitelistToken(ANI)`; typically requested via their Discord and conditional on real TVL |
| Wallet logos in MetaMask / Rabby etc. | CoinGecko / CoinMarketCap not yet submitted | The form submissions still need to happen; they are free and only need a few minutes |
| Coordinated LP incentive distribution | Gauge not yet exists, so bribes are impossible | Solved by either (a) getting the gauge, then bribing veAERO, or (b) doing a manual airdrop of the 700K ANI directly to qualifying LP addresses via `disperse.app` |

---

## What someone with very small resources could do

If you are reading this and want to help — you don't need money, only time. These are ordered by impact-per-minute, highest first.

1. **Submit ANI to [CoinGecko](https://www.coingecko.com/request-form/new-coin-form)** (≈10 minutes, free).
   - Once approved, MetaMask, Rabby, Phantom and most other wallets auto-pull the logo from CoinGecko.
2. **Submit ANI to [CoinMarketCap](https://support.coinmarketcap.com/hc/en-us/articles/360043659351)** (≈10 minutes, free).
3. **Update Basescan token info** — open the [token page](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f), scroll down, click "Update Token Info". Sign with the deployer wallet (`0xDc1D…6412`) to prove ownership.
4. **Open an Aerodrome Discord ticket** asking for UI listing + whitelist (template below).
5. **Run a `triggerBurn()` keeper** — see [`CONTRIBUTING.md`](./CONTRIBUTING.md). Gas is negligible on Base; setting up a Gelato task costs nothing.
6. **Pin the IPFS metadata** on your own pinning service (Pinata / web3.storage / Filebase).
7. **Mirror this repo** to a second host (Codeberg, Radicle, IPFS).

## What someone with capital could do

If you want to make the project actually tradeable:

1. **Add USDC-side liquidity** to the pool. Even $100 of USDC would let the pool absorb $20-ish trades at reasonable slippage. $1,000 makes it look like a real micro-cap. There is no "permission" needed — Aerodrome lets anyone add liquidity to any existing pool.
2. **In exchange**: nothing automatic. The maintainer has explicitly declined to promise any reward. The 700,000 ANI on the deployer wallet is loosely earmarked for LPs but is not currently bound to any contract or merkle tree. Treat any informal arrangement at your own risk.
3. **Or take over the project entirely** — see "Call for stewardship" below.

---

## Aerodrome Discord ticket template

Copy-paste this when opening a ticket in the Aerodrome Discord (`#support` or `#listings`):

```
Token: Anisian (ANI) — Base mainnet
Contract: 0xE378841a3970FD43ac8aD4D1D77b068C87287e5f  (verified on Basescan)
Pool: 0x2F947691C97244D845B2db2f86489D21c4c919bD  (Aerodrome v1 vAMM-ANI/USDC)
Initial LP: 20,000,000 ANI seeded; current USDC side is thin (see STATUS.md)
Logo (256 PNG): https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/ipfs/ani-logo-256.png
Repo / source / metadata: https://github.com/anisiananifree/anisian_contracts
Token list: https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/tokenlist.json

Requests:
  1) UI listing + logo on the pool card.
  2) Voter.whitelistToken(ANI) so a gauge can be created.

About the token (immutable, fixed-supply, deflationary):
  - 100M ANI minted once at deployment, no further minting.
  - 79M scheduled to burn over ~14 years via a permissionless `triggerBurn()`.
  - No owner, no admin, no mint, no pause, no upgrade. The deployer has no special on-chain powers after `initialize()`.
  - 90-day launch protection currently active; ends 2026-08-22 22:30:01 UTC.
  - MIT licensed, community-owned, no maintainer.
```

---

## Call for stewardship

The original deployer has been transparent: they **deployed the contracts, seeded a tiny pool, and have no further capital or capacity** to push the project forward (no marketing budget, no operations, no maintainer commitment). The contracts will keep running regardless — the burn vault doesn't care if anyone is watching — but the **off-chain side** of a token project (listings, community, partnerships, real liquidity) needs people who care.

If you are interested in **taking over the stewardship** of the off-chain side:

1. Fork this repository under your own GitHub user or org.
2. Submit ANI to the listings above (the deployer's PRs are open but slow).
3. Optionally, add USDC liquidity to the pool and start talking about it publicly.
4. Optionally, propose a fair distribution of the 700,000 ANI on the deployer wallet to LP providers (the deployer can sign a transfer if a credible, transparent merkle-tree distribution exists — open an issue in this repo with the plan).

Nothing about stewardship requires permission. The token is immutable; the off-chain world is yours to shape.

---

## How to refresh this snapshot

The on-chain state moves; this file does not auto-update. To regenerate the live numbers:

```bash
./scripts/check-burn-progress.sh                  # vault state
# pool reserves: see scripts/get-live-state.py    (or read via Basescan directly)
```

If you spot a discrepancy between this file and the current on-chain state, open a PR with the corrected numbers and the block height you read at.
