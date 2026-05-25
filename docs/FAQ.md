# Frequently Asked Questions

## About the token

### What is Anisian (ANI)?

Anisian is a **fixed-supply, immutable ERC-20 token on Base** with a deflationary halving burn schedule. 100,000,000 ANI were minted once at deployment. ~79,000,000 are scheduled to be burned over ~14 years via a permissionless burn vault.

### What chain is it on?

**Base mainnet** (chainId `8453`). Token contract: [`0xE378841a3970FD43ac8aD4D1D77b068C87287e5f`](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f).

### What is the total supply?

100,000,000 ANI minted at deployment. The supply only ever **decreases** (via scheduled burns). It can never increase — there is no `mint` function.

### Where is the source code?

Right here in this repository, in [`contracts/`](../contracts/). The same source is **verified on Basescan** and matches byte-for-byte.

## About the burn

### How does the burn work?

The [`AnisianBurnVault`](../contracts/AnisianBurnVault.sol) holds 79,000,000 ANI. Anyone can call `triggerBurn()` on the vault — there is no permission check. The function burns as much ANI as the schedule has accrued since the last call, up to the vault's balance.

See [`BURN_SCHEDULE.md`](./BURN_SCHEDULE.md) for the exact per-epoch allocation table.

### Who decides when the burn happens?

Nobody decides "when" — the schedule is fully deterministic from `startTime`. Anybody can trigger the burn at any time (a user, a bot, a keeper). The schedule "catches up" automatically; delaying the call only delays the burn, it does not reduce it.

### What happens if nobody ever calls `triggerBurn()`?

Burns simply don't happen. The 79M ANI sit in the vault forever. The schedule never enforces itself — it is a **pull mechanism**, not a push one. In practice it is extremely likely that at least one bot or community member will call it for the gas-rebate / community benefit, but there is no protocol-level keeper.

### Can the burn be sped up or slowed down?

No. The schedule is anchored to the vault's `startTime` (set at deployment) and uses immutable constants. Even calling `triggerBurn()` every block does not burn more than `pendingBurn()`.

### Can the deployer take ANI back from the vault?

No. The vault has no withdraw function. The only way ANI leaves the vault is by being burned via `triggerBurn()`.

## About admin / ownership

### Who owns this contract?

Nobody. There is **no owner, no admin, no multisig, no pause function, no upgrade proxy**. The deployer has the same on-chain powers as any other holder.

### Can the deployer change the rules?

No. The only on-chain action available to the deployer after deployment is `initialize()`, which can be called exactly once. After that, the deployer has no special functions.

### Is there a backdoor?

No. The full source is in this repo and verified on Basescan. There is no hidden admin role. There are no `onlyOwner` modifiers. The `_initializer` check on `initialize()` is only used to ensure the one-shot setup is called by the deployer (not anyone), and is permanently consumed after the first call.

### Can the contracts be upgraded?

No. The contracts are not behind a proxy. They are deployed at fixed addresses and the bytecode at those addresses cannot change.

### Can the launch protection (90-day buy limits) be re-enabled?

No. Once `limitsFinalized` flips to `true` (automatically on the first transfer after 90 days), the limit branch is permanently skipped in the `_update` function.

## About buying / using ANI

### Where can I buy ANI?

Aerodrome on Base, via the registered ANI/USDC volatile pool [`0x2F947691C97244D845B2db2f86489D21c4c919bD`](https://basescan.org/address/0x2F947691C97244D845B2db2f86489D21c4c919bD). The pool is paired with **native USDC on Base** (`0x8335…2913`), not WETH. Direct link: [Buy on Aerodrome](https://aerodrome.finance/swap?from=0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913&to=0xE378841a3970FD43ac8aD4D1D77b068C87287e5f).

> **Important:** see [`STATUS.md`](../STATUS.md) for the current pool liquidity. At time of writing the pool is **very thin** — buys and sells will see large price impact until somebody adds more USDC-side liquidity. Trade responsibly.

### Why does my buy revert?

During the first 90 days after `initialize()`, three limits apply **only to buys from the registered pool**:

- Max **10,000 ANI** per single buy (`MaxBuyExceeded`)
- Max **20,000 ANI** balance per wallet after a buy (`MaxWalletExceeded`)
- **10-minute cooldown** between buys per wallet (`CooldownActive`)

These limits **do not apply** to wallet-to-wallet transfers, sells, or the exempt wallets (the burn vault `0xAF72..416B` and the personal wallet `0x4124..AF28` that was registered as `ownerWallet` in `initialize()`). After 90 days the limits permanently disable for everyone.

### Can I add ANI to MetaMask / Rabby / Coinbase Wallet / Trust Wallet?

Yes. Use `Import token` / `Add custom token` and paste the contract address `0xE378841a3970FD43ac8aD4D1D77b068C87287e5f` with network **Base**. Symbol and decimals are read from the contract automatically.

### Is ANI on CoinGecko / CoinMarketCap?

Submission is in progress. Once listed, wallets that pull metadata from those providers (most major wallets) will show the logo automatically.

### Is ANI on Trust Wallet's listed assets?

A PR is open at [`trustwallet/assets#36846`](https://github.com/trustwallet/assets/pull/36846). Trust Wallet uses a paid review process; merging may take time and is not guaranteed.

## About this repository

### Who maintains this repo?

This repository is a **public reference**. There is no required maintainer — the protocol on Base runs without one. Community members are welcome to mirror, fork, or contribute updates (see [`CONTRIBUTING.md`](../CONTRIBUTING.md)).

### Can I fork this?

Yes. The contracts are MIT-licensed. The logos and metadata are released for community use. Forks are encouraged.

### Can I host the token list?

Yes. The `tokenlist.json` follows the [Uniswap Token List](https://tokenlists.org) standard and can be mirrored anywhere. The canonical raw URL is:

```
https://raw.githubusercontent.com/anisiananifree/anisian_contracts/main/tokenlist.json
```

### How do I report a security issue?

See [`SECURITY.md`](../SECURITY.md). Note that because the contracts are **immutable**, bugs cannot be patched — only forked around. Disclosure is for awareness, not coordinated patching.

### Why is the GitHub username `anisiananifree`?

The username `anisian` was already taken when this repo was created. `anisiananifree` is the canonical owner of the on-chain contracts and this repository. The on-chain addresses are the source of truth — the GitHub username is only the off-chain hosting.

## Still have a question?

[Open an issue](https://github.com/anisiananifree/anisian_contracts/issues/new/choose) using the `question` template.
