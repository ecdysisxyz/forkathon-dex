// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Schema} from "./Schema.sol";

library Storage {
    bytes32 constant DEX_GAUGE_GAUGESTATE = 0x4f9427d858cc6b833d1670d56a01c3f38a2cdf9a60c991abe318cddcaa53a200;

    function GaugeState() internal pure returns(Schema.$GaugeState storage ref) {
        bytes32 slot = DEX_GAUGE_GAUGESTATE;
        assembly { ref.slot := slot }
    }
}
