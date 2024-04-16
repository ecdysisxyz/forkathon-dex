// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {MCDevKit} from "mc/devkit/MCDevKit.sol";
import {MCTest} from "mc/devkit/MCTest.sol";

import {stdError} from "forge-std/StdError.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {DeployLib} from "../../script/DeployLib.sol";

import {TestERC20} from "bundle/TestERC20.sol";

import {IFactory} from "bundle/factory/interfaces/IFactory.sol";

import {IGaugeTester} from "../utils/IGaugeTester.sol";
import {IPoolTester} from "../utils/IPoolTester.sol";
import {StorageReader} from "../utils/StorageReader.sol";

contract GaugeTest is MCTest {
    using DeployLib for MCDevKit;

    IFactory public factory;
    IGaugeTester public gauge;
    IPoolTester public pool;
    address[3] public tokens;
    IERC20 public lptoken; 

    function setUp() public {
        factory = IFactory(mc.deployFactory().toProxyAddress());

        for (uint i;i<3;i++) {
            tokens[i] = address(new TestERC20(address(this)));
        }
        
        pool = IPoolTester(factory.createPool(tokens[0], tokens[1]));
        mc.setStorageReader(DeployLib.poolBundleName(), IPoolTester.PoolState.selector, address(new StorageReader()));

        for (uint i;i<2;i++) {
            IERC20(tokens[i]).approve(address(pool), type(uint).max);
        }

        lptoken = IERC20(pool.PoolState().lptoken);

        gauge = IGaugeTester(factory.createGauge(address(lptoken), tokens[2], 1e15));

        lptoken.approve(address(gauge), type(uint).max);

        IERC20(tokens[2]).transfer(address(gauge), 1e20);

        pool.addLiquidity(1e18, 1e18);

        vm.roll(0);
    }

    function test_Success_Deposit() public {
        uint befLpBalance = lptoken.balanceOf(address(this));
        gauge.deposit(1e15);
        assertLt(lptoken.balanceOf(address(this)), befLpBalance);
    }

    function test_Fail_deposit_Insufficient() public {
        vm.expectRevert();
        gauge.deposit(1e18);
    }

    function test_Success_withdraw() public {
        uint befLpBalance = lptoken.balanceOf(address(this));
        gauge.deposit(1e15);
        gauge.withdraw(1e15);
        assertEq(lptoken.balanceOf(address(this)), befLpBalance);
    }

    function test_Fail_withdraw_Insufficient() public {
        vm.expectRevert();
        gauge.withdraw(1e18);
    }

    function test_Success_Claim() public {
        uint befRewardBalance = IERC20(tokens[2]).balanceOf(address(this));
        
        gauge.deposit(1e15);

        vm.roll(100);

        gauge.claim();

        assertGt(IERC20(tokens[2]).balanceOf(address(this)), befRewardBalance);
    }
}
