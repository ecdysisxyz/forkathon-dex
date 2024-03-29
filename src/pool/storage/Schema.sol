// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title DEXFactory Storage Schema
 * @dev Storage schema for the DEX Factory contract
 * @custom:storage-location erc7201:dexFactory
 */
interface Schema {

    /// @custom:storage-location erc7201:DEX.Factory.FactoryState
    struct $PoolState {
        // Flag to indicate if the pool has been initialized
        bool initialized;
        // Token addresses for the liquidity pool
        address tokenA;
        address tokenB;
        // Address of the associated liquidity token
        address lptoken;
    }
}
