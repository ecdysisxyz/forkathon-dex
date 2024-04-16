// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {MCDevKit} from "mc/devkit/MCDevKit.sol";
import {MCTest} from "mc/devkit/MCTest.sol";

import {stdError} from "forge-std/StdError.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {DeployLib} from "../../script/DeployLib.sol";

import {TestERC20} from "bundle/TestERC20.sol";

import {IFactory} from "bundle/factory/interfaces/IFactory.sol";

import {IPoolTester} from "../utils/IPoolTester.sol";
import {StorageReader} from "../utils/StorageReader.sol";

contract PoolTest is MCTest {
    using DeployLib for MCDevKit;

    IFactory public factory;
    IPoolTester public pool;
    address[2] public tokens;
    IERC20 public lptoken; 

    function setUp() public {
        factory = IFactory(mc.deployFactory().toProxyAddress());

        mc.setStorageReader(DeployLib.poolBundleName(), IPoolTester.PoolState.selector, address(new StorageReader()));

        for (uint i;i<2;i++) {
            tokens[i] = address(new TestERC20(address(this)));
        }
        pool = IPoolTester(factory.createPool(tokens[0], tokens[1]));
        for (uint i;i<2;i++) {
            IERC20(tokens[i]).approve(address(pool), type(uint).max);
        }

        lptoken = IERC20(pool.PoolState().lptoken);

    }

    function test_Success_AddLiquidity() public {
        assertTrue(lptoken.totalSupply() == 0);
        pool.addLiquidity(1e18, 1e18);
        assertTrue(lptoken.totalSupply() > 0);
    }

    function test_Success_RemoveLiquidity() public {
        pool.addLiquidity(1e18, 1e18);

        uint befLpTtlSply = lptoken.totalSupply();
        uint befLpBalance = lptoken.balanceOf(address(this));
        
        pool.removeLiquidity(1e17);

        assertLt(lptoken.totalSupply(), befLpTtlSply);
        assertLt(lptoken.balanceOf(address(this)), befLpBalance);
    }

    function test_Fail_RemoveLiquidity_Insufficient() public {
        vm.expectRevert();
        pool.removeLiquidity(1e18);
    }

    function test_Success_Swap() public {
        pool.addLiquidity(1e18, 1e18);

        uint befTokenBBalance = IERC20(tokens[0]).balanceOf(address(this));
        pool.swap(1e15, 0);
        assertGt(IERC20(tokens[0]).balanceOf(address(this)), befTokenBBalance);
    }

    function test_Fail_Swap_Insufficient() public {
        pool.addLiquidity(1e18, 1e18);

        vm.expectRevert();
        pool.swap(1, 0);

    }
}
