// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/token/ERC20/ERC20.sol";

/// @title Anisian
/// @author Anisian
/// @notice ERC-20 token (ANI) with one-shot launch setup and optional post-launch buy limits.
/// @dev
/// - Fixed supply minted once in the constructor (100M ANI). No further minting.
/// - One-time `initialize` wires the burn vault, a single liquidity pool, and limit-exempt addresses.
/// - No Ownable, pause, upgrade proxy, or post-init admin functions.
///
/// Launch protection (90 days after `initialize`): limits apply only to buys from the registered LP pool.
contract Anisian is ERC20 {
    /// @notice Total supply minted at deployment.
    uint256 public constant INITIAL_SUPPLY = 100_000_000 ether;

    /// @notice Duration of buy-side limits after pool registration.
    uint64 public constant PROTECTION_WINDOW = 90 days;

    /// @notice Minimum time between two pool buys for the same recipient.
    uint64 public constant BUY_COOLDOWN = 10 minutes;

    /// @notice Maximum ANI bought from the pool per transfer during protection.
    uint256 public constant MAX_BUY_AMOUNT = 10_000 ether;

    /// @notice Maximum ANI balance per wallet after a pool buy during protection.
    uint256 public constant MAX_WALLET_AMOUNT = 20_000 ether;

    /// @notice Burn vault; sole caller of `burnFromVault`.
    address public burnVault;

    /// @notice Registered liquidity pool addresses (one pool set at `initialize`).
    mapping(address => bool) public isLiquidityPool;

    /// @notice Wallets exempt from launch buy limits.
    mapping(address => bool) public isLimitExempt;

    /// @notice Timestamp when the LP pool was registered.
    uint64 public liquidityCreatedAt;

    /// @notice Timestamp when launch buy limits end.
    uint64 public protectionEndsAt;

    /// @notice When true, launch limits are permanently disabled.
    bool public limitsFinalized;

    /// @notice Last pool-buy timestamp per recipient (cooldown).
    mapping(address => uint64) public lastBuyTime;

    address private _initializer;
    bool private _initialized;

    event BurnVaultInitialized(address indexed vault);
    event LiquidityPoolRegistered(address indexed pool);
    event LimitExemptSet(address indexed account);
    event LimitsFinalized(uint64 at);

    error NotInitializer();
    error AlreadyInitialized();
    error NotBurnVault();
    error MaxBuyExceeded(uint256 attempted, uint256 max);
    error MaxWalletExceeded(uint256 attempted, uint256 max);
    error CooldownActive(uint64 remainingSeconds);

    /// @notice Mints the full `INITIAL_SUPPLY` to the deployer.
    constructor() ERC20("Anisian", "ANI") {
        _initializer = msg.sender;
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /// @notice One-time setup: burn vault, LP pool, and limit-exempt owner wallet.
    /// @param vault Address of {AnisianBurnVault}.
    /// @param pool Address of the liquidity pool (pair).
    /// @param ownerWallet Wallet exempt from buy limits (e.g. team treasury).
    function initialize(address vault, address pool, address ownerWallet) external {
        if (msg.sender != _initializer) revert NotInitializer();
        if (_initialized) revert AlreadyInitialized();
        _initialized = true;

        burnVault = vault;
        isLimitExempt[vault] = true;
        emit BurnVaultInitialized(vault);
        emit LimitExemptSet(vault);

        isLimitExempt[ownerWallet] = true;
        emit LimitExemptSet(ownerWallet);

        isLiquidityPool[pool] = true;
        uint64 ts = uint64(block.timestamp);
        liquidityCreatedAt = ts;
        protectionEndsAt = ts + PROTECTION_WINDOW;
        emit LiquidityPoolRegistered(pool);
    }

    /// @notice Burns ANI from the vault balance. Callable only by `burnVault`.
    /// @param amount Amount to burn (18 decimals).
    function burnFromVault(uint256 amount) external {
        if (msg.sender != burnVault) revert NotBurnVault();
        _burn(burnVault, amount);
    }

    /// @inheritdoc ERC20
    function _update(address from, address to, uint256 value) internal override {
        if (limitsFinalized || from == address(0) || to == address(0) || liquidityCreatedAt == 0) {
            super._update(from, to, value);
            return;
        }

        if (block.timestamp >= protectionEndsAt) {
            limitsFinalized = true;
            emit LimitsFinalized(uint64(block.timestamp));
            super._update(from, to, value);
            return;
        }

        if (isLimitExempt[from] || isLimitExempt[to]) {
            super._update(from, to, value);
            return;
        }

        bool fromIsPool = isLiquidityPool[from];

        if (!fromIsPool && !isLiquidityPool[to]) {
            super._update(from, to, value);
            return;
        }

        if (fromIsPool) {
            uint64 now64 = uint64(block.timestamp);
            uint64 last = lastBuyTime[to];
            if (last != 0 && (last + BUY_COOLDOWN > now64)) {
                revert CooldownActive(last + BUY_COOLDOWN - now64);
            }

            if (value > MAX_BUY_AMOUNT) revert MaxBuyExceeded(value, MAX_BUY_AMOUNT);

            uint256 newBal = balanceOf(to) + value;
            if (newBal > MAX_WALLET_AMOUNT) revert MaxWalletExceeded(newBal, MAX_WALLET_AMOUNT);

            lastBuyTime[to] = now64;
        }

        super._update(from, to, value);
    }
}
