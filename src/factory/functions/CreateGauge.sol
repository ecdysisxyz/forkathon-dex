// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "ucs-contracts/src/proxy/Proxy.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import  {InitializeGauge} from "bundle/gauge/functions/InitializeGauge.sol";

/**
 * @title CreateGauge
 * @dev Contract to create new gauge in the DEX Factory
 */
contract CreateGauge {
    // Event to announce the creation of a new gauge
    event GaugeCreated(address lpToken, address rewardToken, uint256 allocAmount);

    /**
     * @notice Creates a new gauge for a given lptoken
     * @return gauge The address of the newly created gauge
     */
    function createGauge(address lpToken, address rewardToken, uint256 allocAmount) external returns (address gauge) {

        Schema.$FactoryState storage state = Storage.FactoryState();

        gauge = _deployGauge(state.gaugeDictionary, lpToken, rewardToken, allocAmount);

        // Emit an event for the gauge creation
        emit GaugeCreated(lpToken, rewardToken, allocAmount);

        return gauge;
    }

    /**
     * @dev Deploys a new gauge for the given lptoken.
     * Could involve complex logic for deploying or cloning contracts, not shown for brevity.
     */
    function _deployGauge(address gaugeDictionary, address lpToken, address rewardToken, uint256 allocAmount) internal returns (address gauge) {
        // Implementation of gauge deployment or cloning
        // Return the new gauge's address
        bytes memory initializeGauge = abi.encodeWithSelector(InitializeGauge.initialize.selector, lpToken, rewardToken, allocAmount);
        gauge = address(new Proxy(gaugeDictionary, initializeGauge));
    }
}