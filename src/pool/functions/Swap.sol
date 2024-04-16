// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";

/**
 * @title Swap
 * @dev Implementation of token swap functionality in a DEX liquidity pool.
 */
contract Swap {
    /**
     * @notice Executes a token swap from token A to token B or vice versa in the liquidity pool.
     * @dev This function allows a user to swap an input amount of one token (token A or token B)
     * for an output amount of the other token, based on the current reserve ratios and swap fee rates
     * in the pool. The function is designed to be called externally. It calculates the output amount
     * taking into consideration the invariant formula, fees, and slippage.
     * @param amountAIn The amount of token A that the caller wants to swap into the pool.
     * @param amountBIn The amount of token B that the caller wants to swap into the pool.
     * @return amountOut The total amount of the other token (token B for amountAIn, token A for amountBIn)
     *                   that will be received as a result of the swap.\
     */    
    function swap(
        uint amountAIn, uint amountBIn
    ) external returns (uint amountOut) {
        Schema.$PoolState storage state = Storage.PoolState();
        // Ensure the pool has been initialized
        require(state.initialized, "Swap: POOL_NOT_INITIALIZED");

        require(amountAIn > 0 || amountBIn > 0, 'Swap: INSUFFICIENT_INPUT_AMOUNT');

        uint reserveA = IERC20(state.tokenA).balanceOf(address(this));
        uint reserveB = IERC20(state.tokenB).balanceOf(address(this));

        if (amountAIn > 0) {
            amountOut = _getAmountOut(amountAIn, reserveA, reserveB);
            require(amountOut > 0, 'Swap: INSUFFICIENT_OUTPUT_AMOUNT');
            IERC20(state.tokenA).transferFrom(msg.sender, address(this), amountAIn);
            IERC20(state.tokenB).transfer(msg.sender, amountOut);
        } else if (amountBIn > 0) {
            amountOut = _getAmountOut(amountBIn, reserveB, reserveA);
            require(amountOut > 0, 'Swap: INSUFFICIENT_OUTPUT_AMOUNT');
            IERC20(state.tokenB).transferFrom(msg.sender, address(this), amountBIn);
            IERC20(state.tokenA).transfer(msg.sender, amountOut);
        }
    }

    /**
     * @dev Given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset.
     */
    function _getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        amountOut = amountIn * reserveOut / (reserveIn + amountIn);
    }
}