// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Schema} from "./Schema.sol";

library Storage {
    bytes32 constant DEX_POOL_POOLSTATE = 0x20f89623b1d8819806d0c64168114e7afdca896ad4bd8717d877aab5dff78700;

    function PoolState() internal pure returns(Schema.$PoolState storage ref) {
        bytes32 slot = DEX_POOL_POOLSTATE;
        assembly { ref.slot := slot }
    }
}
