// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Schema} from "bundle/gauge/storage/Schema.sol";
import {IGauge} from "bundle/gauge/interfaces/IGauge.sol";

interface IGaugeTester is IGauge {
    // function GaugeState() external pure returns(Schema.$GaugeState memory);
}