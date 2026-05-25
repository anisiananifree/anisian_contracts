# Burn schedule

The Anisian burn vault distributes burns on a **halving schedule** anchored to its deployment timestamp. Each period is exactly **730 days (2 years)**. The allocation per period halves until the **79,000,000 ANI** total budget is exhausted.

## Constants (from `AnisianBurnVault.sol`)

- `TOTAL_BURN_BUDGET = 79,000,000 ANI`
- `HALVING_PERIOD = 730 days`
- Period 0 allocation = `40,000,000 ANI`
- Each subsequent period: `prev / 2`, capped at `remaining` budget.

## Allocation table

| Period | Years from `startTime` | Period allocation | Annual rate (linear) | Cumulative burned (end of period) | Remaining |
| :---: | :---: | ---: | ---: | ---: | ---: |
| 0 | 0 → 2  | 40,000,000 ANI | 20,000,000 ANI / year | 40,000,000 ANI | 39,000,000 ANI |
| 1 | 2 → 4  | 20,000,000 ANI | 10,000,000 ANI / year | 60,000,000 ANI | 19,000,000 ANI |
| 2 | 4 → 6  | 10,000,000 ANI | 5,000,000 ANI / year  | 70,000,000 ANI |  9,000,000 ANI |
| 3 | 6 → 8  |  5,000,000 ANI | 2,500,000 ANI / year  | 75,000,000 ANI |  4,000,000 ANI |
| 4 | 8 → 10 |  2,500,000 ANI | 1,250,000 ANI / year  | 77,500,000 ANI |  1,500,000 ANI |
| 5 | 10 → 12 | 1,250,000 ANI |   625,000 ANI / year  | 78,750,000 ANI |    250,000 ANI |
| 6 | 12 → 14 |   250,000 ANI (capped) |    125,000 ANI / year  | **79,000,000 ANI** | **0** ✅ |

> Period 6 allocation would naturally be 625,000 ANI (half of 1.25M), but the schedule caps it at the remaining 250,000 ANI so the cumulative total cannot exceed the budget.

## How `burnedTargetAt(t)` works

For any timestamp `t ≥ startTime`:

```
elapsed         = t - startTime
period          = elapsed / HALVING_PERIOD          // integer division
elapsedInPeriod = elapsed - period * HALVING_PERIOD
```

The cumulative burn target is computed as:

```
target = sum of (alloc[0..period-1])     // fully-elapsed periods
       + alloc[period] * elapsedInPeriod / HALVING_PERIOD   // linear within current period
```

Each `alloc[p]` is `min(40e6 / 2^p, remaining_at_p)`.

## `pendingBurn()` and `triggerBurn()`

- `pendingBurn()` returns `min(burnedTargetAt(now) - totalBurned, vaultBalance())`.
- `triggerBurn()` is **permissionless**: anyone may call it, anytime. It burns `pendingBurn()` ANI from the vault. There is no penalty for delay; the schedule "catches up" on the next call.

### Practical examples

| Scenario | Behavior |
| --- | --- |
| 100 days after deploy, nobody has called `triggerBurn` yet | First caller burns `40e6 * 100 / 730 ≈ 5,479,452 ANI` in one tx. |
| Called every 7 days from the start | ~383,562 ANI burned per call in period 0; the rate halves automatically when period 1 begins. |
| Vault was not yet funded with 79M | `triggerBurn` reverts with `NotFunded`. (This applies only at the very beginning, before the 79M transfer.) |
| Already burned everything the schedule allows so far | `pendingBurn() == 0` → `triggerBurn` reverts with `NothingToBurn`. |
| Year 14+, all 79M burned | `totalBurned == 79e6`, `pendingBurn() == 0` forever. Vault is permanently empty. |

## Why halving?

The halving curve front-loads burns:

- **~51 % of the total burn** happens in the first 2 years (40M of 79M).
- **~76 % in the first 4 years** (60M of 79M).
- **~89 % in the first 6 years** (70M of 79M).
- The last 4M is spread over the final 6 years for a long tail.

This rewards holders early (rapid supply contraction near launch) while maintaining a credible long-term deflationary commitment.

## How to check progress

From the command line (requires `curl` and `cast` or any Base RPC):

```bash
./scripts/check-burn-progress.sh
```

Or read on Basescan:

- [Burn vault contract](https://basescan.org/address/0xAF727167448374f73AE22e3d026D11965EDf416B#readContract) → `totalBurned`, `vaultBalance`, `pendingBurn`.

## See also

- [`ARCHITECTURE.md`](./ARCHITECTURE.md) — full system overview.
- [`../contracts/AnisianBurnVault.sol`](../contracts/AnisianBurnVault.sol) — source.
