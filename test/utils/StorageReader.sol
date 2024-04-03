// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Schema} from "../../src/pool/storage/Schema.sol";
import {Storage} from "../../src/pool/storage/Storage.sol";

contract StorageReader {
    function PoolState() public pure returns(Schema.$PoolState memory) {
        return Storage.PoolState();
    }
}