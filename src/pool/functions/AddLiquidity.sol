// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "../../DEXLib.sol";

/**
 * @title AddLiquidity
 * @dev Implementation of adding liquidity to a liquidity pool.
 */
contract AddLiquidity {
    using Math for uint;

    /**
     * @notice Adds liquidity to the pool for the given token pair.
     * @param amountADesired The desired amount of tokenA to add.
     * @param amountBDesired The desired amount of tokenB to add.
     * @return amountA The amount of tokenA added to the pool.
     * @return amountB The amount of tokenB added to the pool.
     * @return liquidity The amount of liquidity tokens minted to the provider.
     */
    function addLiquidity(
        uint amountADesired,
        uint amountBDesired
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        Schema.$PoolState storage state = Storage.PoolState();
        // Ensure the pool has been initialized
        require(state.initialized, "AddLiquidity: POOL_NOT_INITIALIZED");

        IERC20 lptoken = IERC20(state.lptoken);

        uint reserveA = IERC20(state.tokenA).balanceOf(address(this));
        uint reserveB = IERC20(state.tokenB).balanceOf(address(this));

        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = DEXLib.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint amountAOptimal = DEXLib.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
        IERC20(state.tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(state.tokenB).transferFrom(msg.sender, address(this), amountB);

        uint _totalSupply = lptoken.totalSupply();
        if (_totalSupply == 0) {
            liquidity = Math.sqrt(amountA*amountB) - DEXLib.MINIMUM_LIQUIDITY;
            DEXLib.mint(address(lptoken), address(this), DEXLib.MINIMUM_LIQUIDITY);
        } else {
            liquidity = Math.min(amountA * _totalSupply / reserveA, amountB * _totalSupply / reserveB);
        }
        require(liquidity > 0, 'AddLiquidity: INSUFFICIENT_LIQUIDITY_MINTED');
        DEXLib.mint(address(lptoken), msg.sender, liquidity);
    }
}