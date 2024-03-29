// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";

contract InitializeFactory {

    function initialize(address poolDictionary) external {
        Schema.$FactoryState storage state = Storage.FactoryState();

        // Ensure that this function is called only once
        require(!state.initialized, "initialize: ALREADY_INITIALIZED");

        // Set the token addresses, along with any other initial setup
        state.poolDictionary = poolDictionary;
        
        // Mark the factory as initialized to prevent re-initialization
        state.initialized = true;
    }
}