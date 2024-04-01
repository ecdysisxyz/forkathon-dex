// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IPool {
    function addLiquidity(uint amountADesired, uint amountBDesired) external;
    function initializePool(address tokenA, address tokenB) external;
    function removeLiquidity(uint256 amount) external;
    function swap(uint amountAIn, uint amountBIn) external;
}
