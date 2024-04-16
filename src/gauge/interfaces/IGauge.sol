// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IGauge {
    function claim() external;
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function initialize(address lpToken, address rewardToken, uint256 allocAmount) external;
}
