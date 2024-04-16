// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "bundle/gauge/GaugeLib.sol";

contract Claim {

    // Event for Claim action
    event Claimed(address indexed user, uint256 amount);

    // Function to claim reward tokens from the gauge
    function claim() public {
        Schema.$GaugeState storage gaugeState = Storage.GaugeState();
        Schema.UserInfo storage userState = gaugeState.userInfo[msg.sender];

        // First update rewards for everyone to keep the state consistent
        GaugeLib.updateReward(gaugeState);
        GaugeLib.updatePendingReward(userState, gaugeState.accLPTPerShare);

        uint256 pending = userState.pendingReward;

        if(pending > 0){
            userState.pendingReward = 0;
            // Transfer LP tokens from the user to the contract
            require(IERC20(gaugeState.rewardToken).transfer(msg.sender, pending), "Transfer failed");
            // Emit an event for this deposit action
            emit Claimed(msg.sender, pending);
        }
    }
}
