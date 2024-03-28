// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";

/**
 * @title RemoveLiquidity
 * @dev Implementation of removing liquidity from a DEX liquidity pool.
 */
contract RemoveLiquidity {
    using SafeERC20 for IERC20;

    // Event emitted when liquidity is removed
    event LiquidityRemoved(address indexed provider, address tokenA, address tokenB, uint amountA, uint amountB, uint liquidity);

    /**
     * @notice Removes liquidity from the pool and returns the underlying assets to the provider.
     * @param tokenA The address of the first token in the pool.
     * @param tokenB The address of the second token in the pool.
     * @param liquidity The amount of liquidity tokens to burn in exchange for the pool's assets.
     * @return amountA The amount of tokenA returned to the provider.
     * @return amountB The amount of tokenB returned to the provider.
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity
    ) external returns (uint amountA, uint amountB) {
        Schema.$PoolState storage state = Storage.PoolState();
        // Ensure the pool has been initialized
        require(state.initialized, "RemoveLiquidity: POOL_NOT_INITIALIZED");

        // Calculate the amounts of tokens to return based on the liquidity share
        (amountA, amountB) = _calculateTokenAmounts(tokenA, tokenB, liquidity);

        // Burn the liquidity tokens from the provider's balance
        _burnLiquidityTokens(msg.sender, liquidity);

        // Transfer the underlying assets back to the liquidity provider
        IERC20(tokenA).safeTransfer(msg.sender, amountA);
        IERC20(tokenB).safeTransfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, tokenA, tokenB, amountA, amountB, liquidity);
    }

    /**
     * @dev Calculates the amounts of tokenA and tokenB to return based on the liquidity share being removed.
     */
    function _calculateTokenAmounts(address tokenA, address tokenB, uint liquidity) internal view returns (uint amountA, uint amountB) {
        // Implementation details to calculate the proportional amount of each token to return
    }

    /**
     * @dev Burns the specified amount of liquidity tokens from the provider's balance.
     */
    function _burnLiquidityTokens(address provider, uint liquidity) internal {
        // Implementation details to burn the liquidity tokens
    }
}
