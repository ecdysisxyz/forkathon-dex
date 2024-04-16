// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "bundle/gauge/GaugeLib.sol";

contract Deposit {

    // Event for Deposit action
    event Deposited(address indexed user, uint256 amount);

    // Function to deposit LP tokens into the gauge
    function deposit(uint256 amount) public {
        Schema.$GaugeState storage gaugeState = Storage.GaugeState();
        Schema.UserInfo storage userState = gaugeState.userInfo[msg.sender];

        // First update rewards for everyone to keep the state consistent
        GaugeLib.updateReward(gaugeState);
        GaugeLib.updatePendingReward(userState, gaugeState.accLPTPerShare);

        gaugeState.totalStaked += amount;

        // Update the user's staked amount and calculate new reward debt
        userState.amount += amount;
        userState.rewardDebt = (userState.amount * gaugeState.accLPTPerShare) / GaugeLib.DENOMINATOR;

        // Transfer LP tokens from the user to the contract
        require(IERC20(gaugeState.lpToken).transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Emit an event for this deposit action
        emit Deposited(msg.sender, amount);
    }
}
