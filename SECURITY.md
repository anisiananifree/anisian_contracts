# Security policy

## Summary

The Anisian contracts on Base mainnet are **immutable**. They have:

- No owner / admin / multisig.
- No pause function.
- No upgrade proxy.
- No mint function (other than the constructor's one-time mint).
- No withdraw / drain path from the burn vault.

This means **bugs cannot be patched**. Disclosure here is for **awareness only** — to inform holders, downstream integrators, and forkers.

## Supported versions

Only the deployed contracts at these addresses are "in scope":

| Contract | Address | Verified on Basescan |
| --- | --- | :---: |
| `Anisian` | [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f#code) | ✅ |
| `AnisianBurnVault` | [`0xAF727167448374f73AE22e3d026D11965EDf416B`](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B#code) | ✅ |

Older or forked versions are not maintained.

## Reporting a vulnerability

Because the contracts cannot be patched, "responsible disclosure" looks different than for traditional software:

1. **Open a public issue** in this repository using the `bug_report` template.
   - Public disclosure is preferred so that holders, integrators, and forkers can react.
   - There is no coordinated patch window to protect.

2. If you believe the disclosure could cause **acute, immediate, recoverable harm** (e.g., a previously-unknown exploit that drains an active liquidity pool), prefer **private notification first** to the deployer wallet's known channels (whichever are listed in the README at that time) so users can act before the issue becomes widely known.

3. There is **no bug bounty**. The protocol has no treasury, no foundation, and no maintainer commitment to reward disclosures. Disclosure is purely a community service.

## Known properties (by design)

These are not vulnerabilities — they are intentional design choices:

- **`triggerBurn()` is permissionless.** Anyone can burn ANI from the vault on schedule, including front-runners. This is intended; the schedule, not the caller, determines the amount.
- **The deployer wallet's 1M ANI is not vested or timelocked.** It is documented in the README's supply table and any movement is publicly visible on Basescan.
- **Launch protection (90-day buy limits) is one-way.** Once it expires (or is bypassed for exempt wallets), it cannot be re-enabled.
- **OpenZeppelin is imported via GitHub URL tag.** The contract source on Basescan is the authoritative source; the live URL is a developer convenience.

## What you should do if you find a bug

1. Verify it against the **on-chain bytecode** (not just the repo). The Basescan verified source is the source of truth.
2. Open an issue in this repo.
3. If you operate a wallet, indexer, or downstream service that depends on Anisian, evaluate whether your integration needs to react.
4. If the issue is severe enough to justify a fork, **fork the source freely** (MIT licensed) and publish your remediated version. Holders of the original token are unaffected by forks.

## What we will not do

- We will not "patch" the deployed contracts (we can't).
- We will not pay a bounty for disclosure.
- We will not silence or remove public issues describing bugs.
- We will not claim the protocol is more centralized or more decentralized than its on-chain code demonstrates.

---

The contracts are MIT-licensed. Use, audit, fork, integrate, or critique freely.
