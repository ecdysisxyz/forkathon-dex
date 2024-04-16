// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IGauge.sol";

contract GaugeFacade is IGauge {
    function claim() external {}
    function deposit(uint256 amount) external {}
    function withdraw(uint256 amount) external {}
    function initialize(address lpToken, address rewardToken, uint256 allocAmount) external {}
}
