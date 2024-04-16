// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IFactory.sol";

contract FactoryFacade is IFactory {
    function createGauge(address lpToken, address rewardToken, uint256 allocAmount) external returns (address gauge) {}
    function createPool(address tokenA, address tokenB) external returns (address pool) {}
    function getPool(address tokenA, address tokenB) external returns (address pool) {}
    function initialize(address poolDictionary) external {}
}
