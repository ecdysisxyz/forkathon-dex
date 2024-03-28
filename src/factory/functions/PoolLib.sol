// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library PoolLib {
    /**
     * @dev Sorts two token addresses in order to prevent duplicates pools
     * and ensure consistent ordering across the platform.
     */
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }
}