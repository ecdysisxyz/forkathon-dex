// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MCDevKit} from "mc/devkit/MCDevKit.sol";
import {MCTest} from "mc/devkit/MCTest.sol";
import {stdError} from "forge-std/StdError.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {DeployLib} from "../../script/DeployLib.sol";

import {TestERC20} from "bundle/TestERC20.sol";

import {IFactory} from "bundle/factory/interfaces/IFactory.sol";
import {Storage} from "bundle/factory/storage/Storage.sol";
import {Schema} from "bundle/factory/storage/Schema.sol";

contract FactoryTest is MCTest {
    using DeployLib for MCDevKit;
    IFactory public factory;
    address[3] public tokens;

    function setUp() public {
        factory = IFactory(mc.deployFactory().toProxyAddress());
        // mc.setStorageGetter(StorageReader.CounterState.selector, address(new StorageReader()));
        for (uint i;i<3;i++) {
            tokens[i] = address(new TestERC20(address(this)));
        }
    }

    function test_Success_CreatePool() public {
        factory.createPool(tokens[0], tokens[1]);
    }

    function test_Fail_CreatePool_zero() public {
        vm.expectRevert();
        factory.createPool(address(0), tokens[0]);
        vm.expectRevert();
        factory.createPool(tokens[0], address(0));
    }

    function test_Fail_CreatePool_same() public {
        vm.expectRevert();
        factory.createPool(tokens[0], tokens[0]);

        factory.createPool(tokens[0], tokens[1]);

        vm.expectRevert();
        factory.createPool(tokens[0], tokens[1]);
    }

    function test_Fail_CreatePool_reverse() public {
        factory.createPool(tokens[0], tokens[1]);

        vm.expectRevert();
        factory.createPool(tokens[1], tokens[0]);
    }

    function test_Success_getPool() public {
        vm.expectRevert();
        factory.getPool(tokens[0], tokens[1]);
        vm.expectRevert();
        factory.getPool(tokens[1], tokens[0]);

        factory.createPool(tokens[0], tokens[1]);

        assertTrue(factory.getPool(tokens[0], tokens[1]) != address(0));
        assertTrue(factory.getPool(tokens[0], tokens[1]) != address(0));
    }
}
