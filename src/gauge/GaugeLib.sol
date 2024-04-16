// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "bundle/gauge/storage/Schema.sol";

library GaugeLib {
    uint public constant DENOMINATOR = 1e12;

    // Helper function to update reward variables of the given gauge
    function updateReward(Schema.$GaugeState storage gauge) internal {
        if (block.number <= gauge.lastRewardBlock) {
            return;
        }

        uint256 totalStaked = gauge.totalStaked;
        if (totalStaked == 0) {
            gauge.lastRewardBlock = block.number;
            return;
        }

        uint256 blocks = block.number - gauge.lastRewardBlock;
        uint256 reward = blocks * gauge.allocAmount;
        gauge.accLPTPerShare += (reward * DENOMINATOR) / totalStaked;
        gauge.lastRewardBlock = block.number;
    }

    // add pending rewards
    function updatePendingReward(Schema.UserInfo storage user, uint256 accLPTPerShare) internal {
        uint256 pending = user.amount * accLPTPerShare / DENOMINATOR - user.rewardDebt;
        if (pending > 0) {
            // add rewards
            user.pendingReward += pending;
        }
    }
}