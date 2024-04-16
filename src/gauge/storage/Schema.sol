// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title DEXGauge Storage Schema
 * @dev Storage schema for the DEX Gauge contract
 * @custom:storage-location erc7201:dexGauge
 */
interface Schema {
    struct UserInfo {
        // The amount of tokens that the user has staked in the gauge
        uint256 amount;
        // The amount of reward debt the user had the last time their rewards were calculated
        uint256 rewardDebt;
        // The amount of rewards that are pending withdrawal by the user
        uint256 pendingReward;
    }

    /// @custom:storage-location erc7201:DEX.Gauge.GaugeState
    struct $GaugeState {
        // Flag to indicate if the gauge has been initialized
        bool initialized;
        // The address of the liquidity provider token associated with this gauge
        address lpToken;
        // The address of the reward token associated with this gauge
        address rewardToken;
        // A mapping from user addresses to their corresponding UserInfo records
        mapping(address => UserInfo) userInfo;
        // The number of allocation points assigned to this gauge
        uint256 allocAmount;
        // The last block number at which rewards were calculated for this gauge
        uint256 lastRewardBlock;
        // total amount of staked LP tokens 
        uint256 totalStaked;
        // Accumulated LP tokens per share
        uint256 accLPTPerShare;
    }
}
