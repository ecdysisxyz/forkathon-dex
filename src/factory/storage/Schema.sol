// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title DEXFactory Storage Schema
 * @dev Storage schema for the DEX Factory contract
 * @custom:storage-location erc7201:dexFactory
 */
interface Schema {

    /// @custom:storage-location erc7201:DEX.Factory.FactoryState
    struct $FactoryState {
        // Flag to indicate if the pool has been initialized
        bool initialized;
        // Address of the pool dictionary
        address poolDictionary;
        // Mapping from token pair to pool address
        mapping(address => mapping(address => address)) poolAddress;
        // Array of all pools for enumeration
        address[] allPools;
        // Address of the gauge dictionary
        address gaugeDictionary;
    }
}
