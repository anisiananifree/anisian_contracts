// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IAnisian} from "./interfaces/IAnisian.sol";

/// @title AnisianBurnVault
/// @author Anisian
/// @notice Holds ANI for scheduled burns; anyone may call `triggerBurn` when the schedule allows.
/// @dev Budget 79M ANI over halving periods (730 days each); allocation halves each period from 40M.
contract AnisianBurnVault {
    /// @notice Total ANI to burn over the full schedule.
    uint256 public constant TOTAL_BURN_BUDGET = 79_000_000 ether;

    /// @notice Length of one schedule period.
    uint64 public constant HALVING_PERIOD = 730 days;

    uint256 private constant _PERIOD_ZERO_ALLOC = 40_000_000 ether;

    /// @notice ANI token contract.
    IAnisian public immutable token;

    /// @notice Schedule start (vault deployment time).
    uint64 public immutable startTime;

    /// @notice Cumulative ANI burned via `triggerBurn`.
    uint256 public totalBurned;

    event Burned(uint256 amount, uint256 totalBurned, address indexed triggeredBy);

    error InvalidToken();
    error NothingToBurn();
    error NotFunded();

    /// @param token_ Deployed {Anisian} token address.
    constructor(address token_) {
        if (token_ == address(0)) revert InvalidToken();
        token = IAnisian(token_);
        startTime = uint64(block.timestamp);
    }

    /// @notice Current ANI balance in this vault.
    function vaultBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    /// @notice True if vault received (or already burned) at least `TOTAL_BURN_BUDGET`.
    function isFunded() public view returns (bool) {
        return vaultBalance() + totalBurned >= TOTAL_BURN_BUDGET;
    }

    /// @notice Cumulative burn target at timestamp `t`.
    function burnedTargetAt(uint256 t) public view returns (uint256) {
        if (t <= startTime) return 0;
        uint256 elapsed = t - startTime;
        uint256 period = elapsed / HALVING_PERIOD;

        uint256 cum = 0;
        uint256 alloc = _PERIOD_ZERO_ALLOC;
        uint256 remaining = TOTAL_BURN_BUDGET;

        for (uint256 p = 0; p < period; ) {
            uint256 stepAlloc = alloc > remaining ? remaining : alloc;
            cum += stepAlloc;
            remaining -= stepAlloc;
            if (remaining == 0) return TOTAL_BURN_BUDGET;
            alloc = alloc / 2;
            unchecked {
                ++p;
            }
        }

        uint256 elapsedInPeriod = elapsed - (period * HALVING_PERIOD);
        uint256 periodAlloc = alloc > remaining ? remaining : alloc;
        uint256 periodPartial = (periodAlloc * elapsedInPeriod) / HALVING_PERIOD;

        return cum + periodPartial;
    }

    /// @notice ANI that can be burned now: min(schedule due, vault balance).
    function pendingBurn() public view returns (uint256) {
        uint256 target = burnedTargetAt(block.timestamp);
        if (target <= totalBurned) return 0;
        uint256 pending = target - totalBurned;
        uint256 bal = vaultBalance();
        return pending > bal ? bal : pending;
    }

    /// @notice Executes burn up to `pendingBurn()`.
    /// @return amount ANI burned in this call.
    function triggerBurn() external returns (uint256 amount) {
        if (!isFunded()) revert NotFunded();
        amount = pendingBurn();
        if (amount == 0) revert NothingToBurn();
        totalBurned += amount;
        emit Burned(amount, totalBurned, msg.sender);
        token.burnFromVault(amount);
    }
}
