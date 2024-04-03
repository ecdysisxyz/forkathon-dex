// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IPool.sol";

contract PoolFacade is IPool {
    function addLiquidity(uint amountADesired, uint amountBDesired) external {}
    function initializePool(address tokenA, address tokenB) external {}
    function removeLiquidity(uint256 amount) external {}
    function swap(uint amountAIn, uint amountBIn) external {}
}
