// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "../LPToken.sol";

contract InitializePool {
    /**
     * @notice Initializes a new liquidity pool with token addresses and other parameters.
     * @param tokenA Address of the first token in the pool
     * @param tokenB Address of the second token in the pool
     * This function can only be called once, typically right after the pool is created.
     */
    function initialize(address tokenA, address tokenB) external {
        Schema.$PoolState storage state = Storage.PoolState();

        // Ensure that this function is called only once
        require(!state.initialized, "initialize: ALREADY_INITIALIZED");

        // Set the token addresses, along with any other initial setup
        state.tokenA = tokenA;
        state.tokenB = tokenB;
        
        // Deploy a new LPToken
        state.lptoken = address(new LPToken());
        
        // Mark the pool as initialized to prevent re-initialization
        state.initialized = true;
    }
}