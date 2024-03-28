// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Schema} from "./Schema.sol";

library Storage {
    bytes32 constant DEX_FACTORY_FACTORYSTATE = 0x75cb3a26ebd2011e72fa84e38726d91a77a4751dd992cb3405fec61d87ebca00;

    function FactoryState() internal pure returns(Schema.$FactoryState storage ref) {
        bytes32 slot = DEX_FACTORY_FACTORYSTATE;
        assembly { ref.slot := slot }
    }
}
