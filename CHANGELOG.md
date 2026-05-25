# Changelog

All notable changes to this repository are documented here. The on-chain contracts are immutable; entries below describe changes to the **repository contents**, not the protocol.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for the repository structure (not the contracts, which have no version after deployment).

## [1.4.0] – 2026-05-25

### Fixed

- **`scripts/get-live-state.py` function selectors** were silently incorrect for `limitsFinalized()`, `protectionEndsAt()`, and `liquidityCreatedAt()` — they hit no function on-chain and the RPC returned `0x0` (which happened to coincide with the truthy answer for `limitsFinalized` at this moment, masking the bug). Recomputed via `keccak256(signature)[:4]` using `pycryptodome`:
  - `limitsFinalized()`      → `0xbc023556` (was `0x99fa6dec`)
  - `protectionEndsAt()`     → `0xa929442c` (was `0xafb29ba0`)
  - `liquidityCreatedAt()`   → `0x43185304` (newly added; not previously queried)
  The script now also prints `liquidityCreatedAt` and `protectionEndsAt` alongside `limitsFinalized` so the full launch-protection state is visible at a glance. Verified the new selectors return the values matching the docs' on-chain claims.
- **`CHANGELOG.md` on-chain history** claim ("First *community* `triggerBurn()` call(s) executed") corrected to reflect ground truth: both burns to date were called by the **deployer wallet** `0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412` — `triggerBurn()` is permissionless so this carries no special access semantics, but labelling it "community" was misleading.
- **`README.md` supply-distribution narrative**: the line *"After distribution, the deployer wallet's balance goes to zero"* was reworded to *"If and when those are distributed, the deployer wallet's balance goes to zero"*, plus an explicit note that the 700K is informally earmarked and not contract-bound. The deployer's earmark is a stated intention, not a smart-contract obligation.
- **`CONTRIBUTING.md` "Pin the metadata on IPFS"** previously claimed a single CID covered "the token logos and `token-metadata.json`". A single CIDv1-raw covers exactly one file's bytes. The section now lists the individual CID for each of the five files under `ipfs/` (four PNGs + the JSON), with sizes and an explicit ⭐ marker on `ani-logo-512.png` (the canonical project logo referenced from `tokenlist.json` and `ipfs/token-metadata.json`).
- **`STATUS.md` refresh instructions** previously contained `# pool reserves: see scripts/get-live-state.py` as a shell comment instead of an actual command. Replaced with the runnable `python3 scripts/get-live-state.py`. Also clarified that the in-file snapshot values are pinned to a specific block height and not auto-refreshed.

### Added

- **`STATUS.md` on-chain history table** for `triggerBurn()` calls, populated from the actual `Burned(uint256,uint256,address)` event topic `0x851e3b0d709635c31490f023f3cf3d419f0f8abd8adc8b2155e1aa08b3f70ff5` on the vault. Currently lists both burns with their tx hashes and timestamps. Total `26,651.445967` ANI burned — matches `totalBurned()` view exactly.

### Verified (block `46459587`, 2026-05-25 11:28:41 UTC, all calls cross-checked with newly-verified selectors)

```
name()                = "Anisian"
symbol()              = "ANI"
decimals()            = 18
INITIAL_SUPPLY()      = 100,000,000.000000 ANI
totalSupply()         =  99,973,348.554033 ANI
PROTECTION_WINDOW()   = 7,776,000 sec (=  90 days)
BUY_COOLDOWN()        =       600 sec (=  10 min)
MAX_BUY_AMOUNT()      =      10,000 ANI
MAX_WALLET_AMOUNT()   =      20,000 ANI
burnVault()           = 0xAF727167448374f73AE22e3d026D11965EDf416B   (cross-ref ✓)
isLiquidityPool[POOL] = true
isLimitExempt[VAULT]  = true
isLimitExempt[PERS]   = true
isLimitExempt[DEPL]   = false
isLimitExempt[POOL]   = false
liquidityCreatedAt()  = 1779661801   (2026-05-24 22:30:01 UTC)
protectionEndsAt()    = 1787437801   (2026-08-22 22:30:01 UTC)
limitsFinalized()     = false

VAULT.token()         = 0xE378841a3970FD43ac8aD4D1D77b068C87287e5f   (cross-ref ✓)
VAULT.startTime()     = 1779648119   (2026-05-24 18:41:59 UTC)
TOTAL_BURN_BUDGET()   = 79,000,000 ANI
HALVING_PERIOD()      = 63,072,000 sec (= 730 days)
totalBurned()         =     26,651.445967 ANI
vaultBalance()        = 78,973,348.554033 ANI
isFunded()            = true

POOL.factory()        = 0x420DD381b31aEf6683db6B902084cB0FFECe40Da  (Aerodrome v1 PoolFactory)
POOL.token0()         = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913  (USDC native, 6 dec)
POOL.token1()         = 0xE378841a3970FD43ac8aD4D1D77b068C87287e5f  (ANI, 18 dec)
POOL.getReserves()    = (10.0000 USDC, 20,000,000.0000 ANI)
POOL.stable()         = 0 (false; volatile pool)
```

Sanity check: `balanceOf(vault)+balanceOf(pool)+balanceOf(deployer)+balanceOf(personal) = totalSupply()` to 6 decimals.

## [1.3.0] – 2026-05-25

### Added

- **`STATUS.md`** — a point-in-time, honest snapshot of the project's actual on-chain state, including pool TVL, implied ANI price, market cap, and the precise status of every known listing / integration channel. Includes an explicit "Call for stewardship" section inviting community members to take over the off-chain side of the project.
- **`scripts/get-live-state.py`** — a stdlib-only Python script that prints the full on-chain snapshot (block, balances, pool reserves, burn vault progress, launch-protection flag) used to regenerate the numbers in `STATUS.md`. Includes a sanity check that `sum(known holders) == totalSupply()`.
- `STATUS.md` is referenced from `README.md` (overview callout, quick-links bar, repository layout, documentation list) and from `docs/FAQ.md` (in the "Where can I buy ANI?" answer).

### Fixed

- **Pool pair correction**: the liquidity pool is **ANI/USDC** (paired with native USDC `0x8335…2913` on Base), not ANI/WETH. References in `README.md` and `docs/ARCHITECTURE.md` updated. The `ARCHITECTURE.md` reference now also names the exact Aerodrome v1 PoolFactory (`0x420DD381b31aEf6683db6B902084cB0FFECe40Da`).
- **Aerodrome swap deep-links**: in `README.md` and `docs/FAQ.md` the `from=eth` parameter on `aerodrome.finance/swap?...` URLs was replaced with `from=0x8335…2913` (USDC contract address) to match the actual pool pair and avoid routing edge-cases.
- **`docs/FAQ.md`**: the "Where can I buy ANI?" answer now explicitly states the pool is USDC-paired and adds a thin-liquidity warning linking to `STATUS.md`.

### Changed

- **`CONTRIBUTING.md` listings section** now tracks all four GitHub PRs opened to date with their numbers (Trust Wallet `#36846`, Uniswap default `#2496`, Sushiswap `#2370`, Cow Protocol `#1436`) and their current status, instead of only loosely mentioning Uniswap. Also added the Basescan token-info-update channel and an off-GitHub Aerodrome Discord entry.

### Verified during this revision (block `46459216`, 2026-05-25 11:16:19 UTC)

```
totalSupply()                        99,973,348.5540 ANI
balanceOf(burn vault)                78,973,348.5540 ANI
balanceOf(Aerodrome pool)            20,000,000.0000 ANI
balanceOf(deployer 0xDc1D..6412)        700,000.0000 ANI
balanceOf(personal 0x4124..AF28)        300,000.0000 ANI
                                     ---------------
sum                                  99,973,348.5540 ANI  (matches totalSupply ✓)

Pool reserves: USDC = 10.0000 (token0)  |  ANI = 20,000,000 (token1)
Implied price: $0.0000005 per ANI
Pool TVL:      ~$20 USD
totalBurned:   26,651.4460 ANI
pendingBurn:   11,185.9462 ANI (callable right now via triggerBurn())
limitsFinalized: false
```

## [1.2.0] – 2026-05-25

### Changed

- **Supply distribution table corrected to match on-chain reality**, verified by direct RPC introspection of the deployed token:
  - The 700,000 ANI for LP incentives is held on the deployer wallet `0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412` (previously the README mistakenly listed both 700K and 300K on the same address).
  - The 300,000 ANI personal allocation is held on `0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28`, which was registered as `ownerWallet` in `initialize()` and is therefore `isLimitExempt = true`.
  - The Aerodrome pool holds 20,000,000 ANI as initial liquidity (the exact amount, previously displayed only as "held in LP").
- README on-chain addresses table now lists the deployer wallet explicitly and renames the previous "Owner wallet" row to "Personal / limit-exempt wallet" to disambiguate.
- README now includes the exact on-chain key timestamps: vault `startTime`, `liquidityCreatedAt`, and `protectionEndsAt`.
- `deploy-addresses.txt` extended with the deployer wallet, key timestamps, and inline comments documenting each address's role and balance.
- `docs/ARCHITECTURE.md` and `docs/FAQ.md` clarified to reflect the correct deployer/exempt wallet roles.
- `SECURITY.md` clarified to list the two separate non-vested wallets.
- `CHANGELOG.md` on-chain history section filled in with exact timestamps read from the deployed contracts.
- README architecture diagram updated to show the deployer wallet and the personal wallet as distinct nodes.

### Verified directly on-chain

All claims in the supply distribution table and addresses section were cross-checked against block timestamp `1779705209` on Base mainnet via the public RPC. Specifically:

```
totalSupply():                       99,973,348.5540 ANI
balanceOf(vault)                     78,973,348.5540 ANI
balanceOf(Aerodrome pool)            20,000,000.0000 ANI
balanceOf(0xDc1D..6412 deployer)        700,000.0000 ANI
balanceOf(0x4124..AF28 personal)        300,000.0000 ANI
                                     ---------------
sum                                  99,973,348.5540 ANI  (matches totalSupply ✓)

isLimitExempt(0x4124..AF28)          true
isLimitExempt(0xDc1D..6412)          false
isLimitExempt(vault)                 true
isLiquidityPool(Aerodrome pool)      true
vault.isFunded()                     true
vault.totalBurned()                  26,651.4460 ANI
```

## [1.1.0] – 2026-05-25

### Added

- Hero header with logo, badges, and table of contents in `README.md`.
- Mermaid architecture diagram in `README.md`.
- `docs/ARCHITECTURE.md` — full system architecture, components, trust model, failure modes.
- `docs/BURN_SCHEDULE.md` — per-epoch allocation table, math walkthrough.
- `docs/FAQ.md` — common questions about the token, burn, admin model, buying, and the repository.
- `SECURITY.md` — security policy for immutable contracts.
- `CONTRIBUTING.md` — community contribution guide (translations, IPFS pinning, wallet directory submissions, keeper bots).
- `.github/ISSUE_TEMPLATE/` — `bug_report.yml`, `question.yml`, `listing_request.yml`.
- `.github/PULL_REQUEST_TEMPLATE.md`.
- `.github/FUNDING.yml`.
- `.editorconfig` — code style consistency hints.
- `scripts/check-burn-progress.sh` — terminal tool to query the burn vault state from a public Base RPC.
- `scripts/README.md`.
- This `CHANGELOG.md` file.

## [1.0.2] – 2026-05-25

### Fixed

- `README.md`: corrected the canonical Token List URL to use the actual GitHub username (`anisiananifree`).

## [1.0.1] – 2026-05-25

### Added

- `info.json`: included a `website` field (points to this repository) and `links` array with `github` and `source_code` entries, satisfying the Trust Wallet asset schema.
- `info.json`: added `tags: ["defi"]`.

### Fixed

- Corrected EIP-55 checksum casing of the Aerodrome pool address in `README.md`, `tokenlist.json`, `ipfs/token-metadata.json`, and `deploy-addresses.txt`.

## [1.0.0] – 2026-05-25

### Added

- Initial repository commit with the deployed Anisian (ANI) contracts, metadata, logos, and Uniswap-format token list.
- `contracts/Anisian.sol`, `contracts/AnisianBurnVault.sol`, `contracts/interfaces/IAnisian.sol`.
- `ipfs/` directory with logos (128/256/512 px and 512-white-bg) and `token-metadata.json`.
- `tokenlist.json` — Uniswap Token List, chainId 8453.
- `info.json` — Trust Wallet asset schema descriptor.
- `deploy-addresses.txt` — deployed addresses on Base mainnet.
- `.remix/settings.json` — compiler config (Solidity 0.8.24, optimizer runs=200, EVM cancun, viaIR=false).
- `README.md`, `LICENSE` (MIT), `.gitignore`.

## On-chain history (informational)

These are the underlying chain events, not repository commits. Timestamps are read directly from the on-chain state of the deployed contracts.

- **2026-05-24 18:41:59 UTC** (unix `1779648119`) — `AnisianBurnVault.sol` deployed to `0xAF727167448374f73AE22e3d026D11965EDf416B`. `startTime` anchored here; burn schedule clock begins.
- **2026-05-24 (slightly later)** — `Anisian.sol` deployed to `0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`. 100,000,000 ANI minted to deployer `0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412` in the constructor.
- **2026-05-24** — Aerodrome liquidity pool created at `0x2F947691C97244D845B2db2f86489D21c4c919bD`; 20,000,000 ANI seeded as initial liquidity.
- **2026-05-24 22:30:01 UTC** (unix `1779661801`) — `Anisian.initialize(vault, pool, ownerWallet)` called by deployer with `ownerWallet = 0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28`. Burn vault and Aerodrome pool registered; vault and ownerWallet marked `isLimitExempt`. 90-day launch protection window started.
- **2026-05-24** — 79,000,000 ANI transferred from deployer to burn vault, funding the schedule. `isFunded()` returns true.
- **2026-05-24** — 300,000 ANI transferred from deployer (`0xDc1D..6412`) to personal wallet (`0x4124..AF28`). Deployer wallet retains 700,000 ANI earmarked for LP incentives.
- **2026-05-24** — Contracts verified on Basescan (source matches this repository byte-for-byte).
- **2026-05-24 23:10:19 UTC** — First `triggerBurn()` executed by deployer `0xDc1D…6412` (tx [`0x848d…2473`](https://basescan.org/tx/0x848d82b1d4f58bca8a01232a6f1c41c6a961050f520e725b7c694c4c1f1a2473)). 10,210.553019 ANI burned.
- **2026-05-25 06:22:23 UTC** — Second `triggerBurn()` executed by deployer (tx [`0x0197…09bb`](https://basescan.org/tx/0x019716837af1642c988600c8f2ed2e0cd11ea2c1aa4bd47b57f50bf5352609bb)). 16,440.892948 ANI burned. Cumulative `totalBurned()` = 26,651.445967 ANI.
- **2026-08-22 22:30:01 UTC** (unix `1787437801`) — *(future)* launch protection limits permanently disable on the next transfer.

> Exact block numbers and per-transaction details are available on Basescan via the addresses linked in [`README.md`](./README.md). Live state can be queried any time via `scripts/check-burn-progress.sh`.
