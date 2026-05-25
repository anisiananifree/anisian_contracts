# Anisian (ANI)

Fixed-supply, immutable ERC-20 token on Base with a deflationary halving burn schedule.

- **Supply:** 100,000,000 ANI (minted once at deployment).
- **Burn:** 79,000,000 ANI scheduled to burn over ~14 years via a permissionless `triggerBurn()` on the burn vault.
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
