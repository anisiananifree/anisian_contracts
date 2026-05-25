# Contributing

Thanks for being here. Anisian is a **community-owned, immutable project** — there is no central maintainer who needs to bless your work. You can help in several concrete ways, all of which are valuable.

## How you can help

### 🌐 Translate the documentation

The README, FAQ, and other docs are written in English. Translating to your language makes ANI accessible to more people:

1. Fork this repo.
2. Add a translated file with a language suffix, e.g. `README.sk.md`, `docs/FAQ.de.md`, etc.
3. Link to it from the main `README.md` (we keep a `Translations` row near the top).
4. Open a pull request.

### 📌 Pin the assets on IPFS

The files under `ipfs/` are content-addressable. Each has its own CIDv1 (raw codec, sha256), independently computable from the file bytes. The more independent pinners host these, the more resilient the project is. **The project's canonical "primary logo" referenced from `tokenlist.json` and `ipfs/token-metadata.json` is `ani-logo-512.png`** (the 512×512 PNG), whose CID is `bafkreigausrrafbfp4g7jtze7hryusey7jbfhkv4fngcucwesxtbndczjy`.

Full CID table (computed at the last commit; reproducible via `sha256sum` + CIDv1-raw):

| File | Size | CIDv1-raw (`bafkrei…`) |
| --- | ---: | --- |
| `ipfs/ani-logo-128.png` | 23,135 B | `bafkreifiunoxepyhnuicnsi4kr4y367bzjuk4d26mwdb5hmyvzg5cftfvy` |
| `ipfs/ani-logo-256.png` | 67,695 B | `bafkreiem2g2spi5u47z2drc3r2qqw4rt4nwb4ndkmj62kz3r7c6yf7y5wy` |
| `ipfs/ani-logo-512.png` | 193,153 B | `bafkreigausrrafbfp4g7jtze7hryusey7jbfhkv4fngcucwesxtbndczjy` ⭐ canonical |
| `ipfs/ani-logo-512-white-bg.png` | 163,934 B | `bafkreifrv2c4crz6quk3ckiuvod3pi6jma6nqhlxhzt2oohvvc452ryiku` |
| `ipfs/token-metadata.json` | 778 B | `bafkreidg33i7ndyzjhwvbfwfeiriqectkxqii3eiiymvwqvb5c6ggcupo4` |

Free / cheap pinning services:

- [Pinata](https://www.pinata.cloud) — free tier
- [web3.storage](https://web3.storage) — free tier, Filecoin redundancy
- [Filebase](https://filebase.com) — S3-compatible IPFS, free tier
- Run your own [IPFS Kubo](https://docs.ipfs.tech/install/) node and `ipfs pin add <cid>` each CID.

If you pin them, drop the CID(s) + your pinning service in an issue tagged `community-pin` so others can see how the redundancy graph looks.

### 📝 Submit ANI to wallet directories

These submissions only need to happen once each. The current state of known submissions is tracked in [`STATUS.md`](./STATUS.md). If you have an account / can help on these platforms, here is the full list:

**Web forms (no GitHub account required):**

- **[CoinGecko new-coin form](https://www.coingecko.com/request-form/new-coin-form)** — most wallets read from here for the logo.
- **[CoinMarketCap listing request](https://support.coinmarketcap.com/hc/en-us/articles/360043659351)** — same idea, second largest source.
- **[Basescan token info update](https://basescan.org/token/0xE378841a3970FD43ac8aD4D1D77b068C87287e5f)** — click "Update Token Info" on the token page.
- **[DexScreener](https://dexscreener.com/base/0x2F947691C97244D845B2db2f86489D21c4c919bD)** — click "Update info" on the pool page (eligibility may depend on pool TVL).
- **[GeckoTerminal](https://www.geckoterminal.com/base/pools/0x2F947691C97244D845B2db2f86489D21c4c919bD)** — pool info update.

**GitHub PRs (already opened by this repo's author, anyone may follow up / nudge maintainers):**

| Target list | PR | Status |
| --- | --- | --- |
| [Trust Wallet assets](https://github.com/trustwallet/assets) | [#36846](https://github.com/trustwallet/assets/pull/36846) | open (paid review fee applies) |
| [Uniswap default-token-list](https://github.com/Uniswap/default-token-list) | [#2496](https://github.com/Uniswap/default-token-list/pull/2496) | open (high bar; awaiting review) |
| [Sushiswap list](https://github.com/sushiswap/list) | [#2370](https://github.com/sushiswap/list/pull/2370) | open |
| [Cow Protocol token-lists](https://github.com/cowprotocol/token-lists) | [#1436](https://github.com/cowprotocol/token-lists/pull/1436) | open (CLA pending) |

**Off-GitHub channels:**

- **Aerodrome Discord** — request UI listing + logo + token whitelist for a gauge (see template in [`STATUS.md`](./STATUS.md)).

If you successfully get ANI accepted somewhere, please open an issue with the link so [`STATUS.md`](./STATUS.md) and the `README.md` can be updated.

### 🤖 Run a `triggerBurn()` keeper

The burn vault's `triggerBurn()` is permissionless. The community benefits when somebody is reliably calling it — it does not require anything more than gas. Examples:

- A simple cron job that calls `triggerBurn()` once a week.
- A [Gelato](https://www.gelato.network/) / [OpenZeppelin Defender](https://defender.openzeppelin.com/) automated task.
- A bot that calls it when `pendingBurn()` exceeds a threshold.

Document your bot's address in an issue if you'd like community trust.

### 🪞 Mirror the repository

Mirror this repo somewhere durable so the source is not dependent on a single GitHub username:

- A second GitHub user / org.
- [Codeberg](https://codeberg.org) (Gitea, no registration friction).
- [Radicle](https://radicle.xyz) (peer-to-peer).
- [Software Heritage](https://www.softwareheritage.org) (academic preservation).
- IPFS / Arweave snapshot.

Open an issue with the mirror URL.

### 🐛 Report bugs or unclear documentation

Open an issue using the `bug_report` or `question` template. We will keep the docs in this repo accurate and up to date as a community.

### 🎨 Design contributions

Alternative logos, dark-mode variants, social media banners, marketing assets — all welcome. Add them under `ipfs/` or a new `assets/` folder and open a PR.

## What we don't accept

- **Changes to the deployed Solidity sources** in `contracts/`. The on-chain contracts are immutable and the repo files match the verified Basescan bytecode. Modifying them locally is fine; PRs that change them will not be merged because the on-chain state cannot change.

  If you have an improvement to the contract design, that is a **fork**, not a contribution to this repo. Fork the source freely (MIT) and deploy your improved version under a different token.

- **Changes that misrepresent the on-chain state.** Any documentation claiming ANI has features it does not have on-chain will be rejected.

## Pull request process

1. Fork the repo, create a branch named `topic/<short-description>`.
2. Make your changes.
3. If you're adding documentation in another language, link to it from `README.md`.
4. Open a PR using the template.
5. PRs are merged by community consensus and basic sanity check. There is no QA pipeline beyond eyeballing the diff — keep changes small and focused.

## Code of conduct

Be technical, be precise, be kind. Bad-faith engagement, harassment, and promoting unrelated tokens or scams will get issues / PRs closed without comment.

---

By contributing, you agree that your contributions are released under the same [MIT License](./LICENSE) as the rest of this repository.
