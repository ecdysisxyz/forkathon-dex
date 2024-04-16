// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "bundle/gauge/GaugeLib.sol";

contract Withdraw {

    // Event for Withdraw action
    event Withdrawn(address indexed user, uint256 amount);

    // Function to withdraw LP tokens from the gauge
    function withdraw(uint256 amount) public {
        Schema.$GaugeState storage gaugeState = Storage.GaugeState();
        Schema.UserInfo storage userState = gaugeState.userInfo[msg.sender];

        // First update rewards for everyone to keep the state consistent
        GaugeLib.updateReward(gaugeState);
        GaugeLib.updatePendingReward(userState, gaugeState.accLPTPerShare);
        
        gaugeState.totalStaked -= amount;

        // Update the user's staked amount and calculate new reward debt
        userState.amount -= amount;
        userState.rewardDebt = (userState.amount * gaugeState.accLPTPerShare) / GaugeLib.DENOMINATOR;

        // Transfer LP tokens from the contract to the user
        require(IERC20(gaugeState.lpToken).transfer(msg.sender, amount), "Transfer failed");

        // Emit an event for this withdraw action
        emit Withdrawn(msg.sender, amount);
    }
}
