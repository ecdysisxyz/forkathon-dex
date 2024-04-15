// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ucs-contracts/src/proxy/Proxy.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import  {InitializePool} from "../../pool/functions/InitializePool.sol";
import "../../DEXLib.sol";

/**
 * @title CreatePool
 * @dev Contract to create new liquidity pools in the DEX Factory
 */
contract CreatePool {
    // Event to announce the creation of a new liquidity pool
    event PoolCreated(address indexed token0, address indexed token1, address pool, uint poolCount);

    /**
     * @notice Creates a new liquidity pool for a given token pair if it doesn't already exist
     * @param tokenA The address of the first token in the pair
     * @param tokenB The address of the second token in the pair
     * @return pool The address of the newly created liquidity pool
     */
    function createPool(address tokenA, address tokenB) external returns (address pool) {
        require(tokenA != tokenB, "CreatePool: IDENTICAL_ADDRESSES");
        require(tokenA != address(0) && tokenB != address(0), "CreatePool: ZERO_ADDRESS");

        // Sort tokens to prevent duplicates (tokenA should always be less than tokenB)
        (address token0, address token1) = DEXLib.sortTokens(tokenA, tokenB);

        Schema.$FactoryState storage state = Storage.FactoryState();

        // Ensure a pool does not already exist for this token pair
        require(state.poolAddress[token0][token1] == address(0), "CreatePool: POOL_EXISTS");

        // Code to deploy a new liquidity pool contract for the token pair
        // This can be a clone of a master pool contract or a new deployment, depending on the design.
        // For simplicity, the actual deployment logic is abstracted away.
        pool = _deployPool(state.poolDictionary, token0, token1);

        // Register the new pool in the factory's storage
        state.poolAddress[token0][token1] = pool;
        state.allPools.push(pool);

        // Emit an event for the pool creation
        emit PoolCreated(token0, token1, pool, state.allPools.length);

        return pool;
    }

    /**
     * @dev Deploys a new liquidity pool for the given token pair.
     * Could involve complex logic for deploying or cloning contracts, not shown for brevity.
     */
    function _deployPool(address poolDictionary, address tokenA, address tokenB) internal returns (address pool) {
        // Implementation of pool deployment or cloning
        // Return the new pool's address
        bytes memory initializePool = abi.encodeWithSelector(InitializePool.initialize.selector, tokenA, tokenB);
        pool = address(new Proxy(poolDictionary, initializePool));
    }
}
