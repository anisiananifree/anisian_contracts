# `scripts/`

Small terminal utilities for reading on-chain state of the Anisian system. None of these scripts modify anything — they are read-only queries against a public Base RPC.

## `check-burn-progress.sh`

Prints the current state of the burn vault: vault balance, total burned, schedule target, and pending burn (the amount anyone can burn right now by calling `triggerBurn()`).

### Requirements

- `bash` (POSIX-compatible)
- `curl`
- `python3` (optional, used for nicer formatting of large numbers and date conversion)

### Usage

```bash
./check-burn-progress.sh
```

By default it uses the public Base RPC at `https://mainnet.base.org`. To use a different RPC (e.g. your own node or a third-party provider):

```bash
BASE_RPC=https://your-rpc.example ./check-burn-progress.sh
```

### Example output

```
================================================================
 Anisian (ANI) burn vault status
 RPC:   https://mainnet.base.org
 Token: 0xE378841a3970FD43ac8aD4D1D77b068C87287e5f
 Vault: 0xAF727167448374f73AE22e3d026D11965EDf416B
================================================================

  Vault start time : 2026-05-XX HH:MM:SS UTC
  Days since start : N

  Vault balance    :     79,000,000.0000 ANI
  Total burned     :              0.0000 ANI
  Schedule target  :         54,794.5205 ANI  (cumulative burn the schedule allows now)
  Pending burn     :         54,794.5205 ANI  <-- callable right now via triggerBurn()

  ▶ Anyone can call triggerBurn() on 0xAF727167448374f73AE22e3d026D11965EDf416B to burn the pending amount.
```

### How it works

The script makes five `eth_call`s against the burn vault contract on Base, decodes the returned 32-byte values, and prints them as ANI (dividing by `10^18`). Selectors used:

| Function | Selector |
| --- | --- |
| `vaultBalance()` | `0x0bf6cc08` |
| `totalBurned()` | `0xd89135cd` |
| `pendingBurn()` | `0x371f530a` |
| `burnedTargetAt(uint256)` | `0x20296445` |
| `startTime()` | `0x78e97925` |

No private keys, no signing, no gas. Purely read-only.

## Triggering a burn

The scripts directory intentionally **does not** include a "burn now" script. Calling `triggerBurn()` is a chain-modifying transaction that requires a wallet. Use:

- The [Basescan write tab](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B#writeContract) (no install, browser wallet).
- [`cast send`](https://book.getfoundry.sh/cast/) if you have Foundry installed.
- Any web3 library you like (`ethers`, `viem`, `web3.js`).

The function is permissionless — any wallet with a tiny amount of ETH on Base can call it.
