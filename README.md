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
- **Liquidity:** initial seed (~10.35 USDC + 20.7M ANI) is permanently locked — LP tokens burned to `0x000…dEaD` ([tx](https://basescan.org/tx/0x195bd10da146618cda04bd7a0cc58548a99d076f6c012586b25aaa5fe976ed4c)). Nobody, including the deployer, can withdraw.
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

## Build / verify

Solidity `0.8.24`, optimizer enabled (runs = 200), EVM `cancun`, `viaIR = false`, OpenZeppelin Contracts `v5.2.0`. The verified source on Basescan matches `contracts/` byte-for-byte.

## License

[MIT](./LICENSE).
