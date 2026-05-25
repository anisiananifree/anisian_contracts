# Changelog

All notable changes to this repository are documented here. The on-chain contracts are immutable; entries below describe changes to the **repository contents**, not the protocol.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for the repository structure (not the contracts, which have no version after deployment).

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
- **2026-05-2X** — First community `triggerBurn()` call(s) executed; 26,651.45 ANI burned from vault (verifiable: vault `totalBurned()` view).
- **2026-08-22 22:30:01 UTC** (unix `1787437801`) — *(future)* launch protection limits permanently disable on the next transfer.

> Exact block numbers and per-transaction details are available on Basescan via the addresses linked in [`README.md`](./README.md). Live state can be queried any time via `scripts/check-burn-progress.sh`.
