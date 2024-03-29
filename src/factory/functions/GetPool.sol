// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "../../DEXLib.sol";

/**
 * @title GetPool
 * @dev Contract to retrieve the address of a liquidity pool for a given token pair
 */
contract GetPool {

    /**
     * @notice Returns the address of the liquidity pool for a given token pair, if it exists.
     * @param tokenA The address of the first token in the pair
     * @param tokenB The address of the second token in the pair
     * @return pool The address of the liquidity pool corresponding to the token pair
     */
    function getPool(address tokenA, address tokenB) external view returns (address pool) {
        require(tokenA != tokenB, "GetPool: IDENTICAL_ADDRESSES");
        require(tokenA != address(0) && tokenB != address(0), "GetPool: ZERO_ADDRESS");

        // Sort tokens to prevent duplicates (tokenA should always be less than tokenB)
        (address token0, address token1) = DEXLib.sortTokens(tokenA, tokenB);

        Schema.$FactoryState storage state = Storage.FactoryState();

        // Retrieve the pool address from the factory's storage
        pool = state.poolAddress[token0][token1];
        require(pool != address(0), "GetPool: POOL_NOT_FOUND");

        return pool;
    }
}
