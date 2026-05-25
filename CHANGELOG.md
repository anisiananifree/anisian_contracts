# Changelog

All notable changes to this repository are documented here. The on-chain contracts are immutable; entries below describe changes to the **repository contents**, not the protocol.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for the repository structure (not the contracts, which have no version after deployment).

## [1.4.0] – 2026-05-25

### Fixed

- `scripts/get-live-state.py`: corrected function selectors for `limitsFinalized()`, `protectionEndsAt()`, `liquidityCreatedAt()`; script now prints all three.
- `CHANGELOG.md` on-chain history: replaced "first community `triggerBurn()`" wording with the precise event facts (caller, tx hash, amount, UTC time per event).
- `README.md` supply-distribution note: clarified the 700K LP-incentive earmark is a stated intention, not a smart-contract obligation.
- `CONTRIBUTING.md` IPFS section: replaced "single CID covers logos and metadata" claim with a per-file CID table (5 entries) and a marker on the canonical 512px logo.
- `STATUS.md` refresh instructions: replaced a misformatted shell comment with the runnable command.

### Added

- `STATUS.md` on-chain history table for `triggerBurn()` events (tx hashes, amounts, timestamps).

## [1.3.0] – 2026-05-25

### Added

- `STATUS.md` — point-in-time on-chain snapshot (balances, pool reserves, listings status, burn history).
- `scripts/get-live-state.py` — stdlib-only Python script printing the full on-chain snapshot; the script's sum-of-balances equals `totalSupply()`.
- `STATUS.md` linked from `README.md` (overview, quick-links, repository layout, documentation list) and `docs/FAQ.md`.

### Fixed

- Pool pair: liquidity pool is **ANI/USDC** (native USDC `0x8335…2913`), not ANI/WETH. References in `README.md`, `docs/ARCHITECTURE.md`, and `docs/FAQ.md` updated; `ARCHITECTURE.md` now names the exact Aerodrome v1 PoolFactory.
- Aerodrome swap deep-links: `from=eth` replaced with `from=0x8335…2913` to match the pool pair.

### Changed

- `CONTRIBUTING.md` listings: tracks all four PRs by number (Trust Wallet `#36846`, Uniswap default `#2496`, Sushiswap `#2370`, Cow Protocol `#1436`); added Basescan token-info-update and Aerodrome Discord entries.

## [1.2.0] – 2026-05-25

### Changed

- Supply distribution table corrected to match on-chain reality (verified by direct RPC reads):
  - 700,000 ANI on the deployer wallet `0xDc1D…6412` (earmarked for LP incentives).
  - 300,000 ANI on personal wallet `0x4124…AF28` (registered as `ownerWallet` in `initialize()`; `isLimitExempt = true`).
  - Aerodrome pool holds 20,000,000 ANI as initial liquidity.
- README addresses table: deployer wallet listed explicitly; previous "Owner wallet" row renamed to "Personal / limit-exempt wallet".
- README key timestamps section added: vault `startTime`, `liquidityCreatedAt`, `protectionEndsAt`.
- `deploy-addresses.txt`, `docs/ARCHITECTURE.md`, `docs/FAQ.md`, `SECURITY.md` updated for the same role/wallet clarity.
- README architecture diagram shows deployer wallet and personal wallet as distinct nodes.

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
