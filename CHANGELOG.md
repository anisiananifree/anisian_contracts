# Changelog

All notable changes to this repository are documented here. The on-chain contracts are immutable; entries below describe changes to the **repository contents**, not the protocol.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for the repository structure (not the contracts, which have no version after deployment).

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

These are the underlying chain events, not repository commits:

- **2026-05-XX** — `Anisian.sol` deployed to `0xE378841a3970FD43ac8aD4D1D77b068C87287e5f` on Base mainnet. 100,000,000 ANI minted to deployer in the constructor.
- **2026-05-XX** — `AnisianBurnVault.sol` deployed to `0xAF727167448374f73AE22e3d026D11965EDf416B`. `startTime` anchored to deployment timestamp.
- **2026-05-XX** — Aerodrome liquidity pool created at `0x2F947691C97244D845B2db2f86489D21c4c919bD`.
- **2026-05-XX** — `Anisian.initialize(vault, pool, ownerWallet)` called. Burn vault and pool registered. 90-day launch protection window started.
- **2026-05-XX** — 79,000,000 ANI transferred from deployer to burn vault, funding the schedule.
- **2026-05-XX** — Contracts verified on Basescan.

> Exact block numbers and timestamps are available on Basescan via the addresses linked in [`README.md`](./README.md).
