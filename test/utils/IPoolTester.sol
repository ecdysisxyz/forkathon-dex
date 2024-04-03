// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Schema} from "bundle/pool/storage/Schema.sol";
import {IPool} from "bundle/pool/interfaces/IPool.sol";

interface IPoolTester is IPool {
    function PoolState() external pure returns(Schema.$PoolState memory);
}