// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IAnisian
/// @notice Minimal interface used by {AnisianBurnVault}.
interface IAnisian {
    /// @notice Burns `amount` from the vault token balance.
    function burnFromVault(uint256 amount) external;

    /// @notice Returns the ANI balance of `account`.
    function balanceOf(address account) external view returns (uint256);
}
