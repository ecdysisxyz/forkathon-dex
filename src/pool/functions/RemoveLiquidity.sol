// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "../../DEXLib.sol";

/**
 * @title RemoveLiquidity
 * @dev Implementation of adding liquidity to a liquidity pool.
 */
contract RemoveLiquidity {
    /**
     * @notice Removes liquidity from the pool and burns the provider's LPTs in exchange for underlying assets.
     * @param amount The amount of liquidity tokens to burn.
     * @return amountA The amount of tokenA returned to the liquidity provider.
     * @return amountB The amount of tokenB returned to the liquidity provider.
     */
    function removeLiquidity(uint256 amount) external returns (uint256 amountA, uint256 amountB) {
        Schema.$PoolState storage state = Storage.PoolState();
        // Ensure the pool has been initialized
        require(state.initialized, "RemoveLiquidity: POOL_NOT_INITIALIZED");

        IERC20 lptoken = IERC20(state.lptoken);
        IERC20 tokenA = IERC20(state.tokenA);
        IERC20 tokenB = IERC20(state.tokenB);

        uint reserveA = tokenA.balanceOf(address(this));
        uint reserveB = tokenB.balanceOf(address(this));

        uint _totalSupply = IERC20(state.lptoken).totalSupply();

        amountA = (amount * reserveA) / _totalSupply;
        amountB = (amount * reserveB) / _totalSupply;
        
        require(amountA > 0 && amountB > 0, 'RemoveLiquidity: INSUFFICIENT_LIQUIDITY_BURNED');
        
        DEXLib.burn(address(lptoken), msg.sender, amount);
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }
}