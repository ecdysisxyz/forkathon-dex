// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IFactory {
    function createPool(address tokenA, address tokenB) external returns (address pool);
    function getPool(address tokenA, address tokenB) external returns (address pool);
    function initializeFactory(address poolDictionary) external;
}
