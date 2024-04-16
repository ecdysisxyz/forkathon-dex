// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../storage/Schema.sol";
import "../storage/Storage.sol";

contract InitializeGauge {

    function initialize(address lpToken, address rewardToken, uint256 allocAmount) external {
        Schema.$GaugeState storage state = Storage.GaugeState();

        // Ensure that this function is called only once
        require(!state.initialized, "initialize: ALREADY_INITIALIZED");

        // Set the token addresses, along with any other initial setup
        state.lpToken = lpToken;
        state.rewardToken = rewardToken;
        state.allocAmount = allocAmount;
        
        // Mark the factory as initialized to prevent re-initialization
        state.initialized = true;
    }
}