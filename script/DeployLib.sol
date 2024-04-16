// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {MCDevKit} from "mc/devkit/MCDevKit.sol";

// Functions
import {CreateGauge} from "bundle/factory/functions/CreateGauge.sol";
import {CreatePool} from "bundle/factory/functions/CreatePool.sol";
import {GetPool} from "bundle/factory/functions/GetPool.sol";
import {InitializeFactory} from "bundle/factory/functions/InitializeFactory.sol";
import {FactoryFacade} from "bundle/factory/interfaces/FactoryFacade.sol";

import {Claim} from "bundle/gauge/functions/Claim.sol";
import {Deposit} from "bundle/gauge/functions/Deposit.sol";
import {InitializeGauge} from "bundle/gauge/functions/InitializeGauge.sol";
import {Withdraw} from "bundle/gauge/functions/Withdraw.sol";
import {GaugeFacade} from "bundle/gauge/interfaces/GaugeFacade.sol";

import {AddLiquidity} from "bundle/pool/functions/AddLiquidity.sol";
import {InitializePool} from "bundle/pool/functions/InitializePool.sol";
import {RemoveLiquidity} from "bundle/pool/functions/RemoveLiquidity.sol";
import {Swap} from "bundle/pool/functions/Swap.sol";
import {PoolFacade} from "bundle/pool/interfaces/PoolFacade.sol";

library DeployLib {
    function factoryBundleName() internal pure returns(string memory) {
        return "DEX-factory";
    }
    function gaugeBundleName() internal pure returns(string memory) {
        return "DEX-gauge";
    }
    function poolBundleName() internal pure returns(string memory) {
        return "DEX-pool";
    }

    function deployGauge(MCDevKit storage mc) internal returns(MCDevKit storage) {
        mc.init(gaugeBundleName());
        mc.use("Claim", Claim.claim.selector, address(new Claim()));
        mc.use("Deposit", Deposit.deposit.selector, address(new Deposit()));
        mc.use("InitializeGauge", InitializeGauge.initialize.selector, address(new InitializeGauge()));
        mc.use("Withdraw", Withdraw.withdraw.selector, address(new Withdraw()));
        mc.useFacade(address(new GaugeFacade()));
        mc.deploy();
        return mc;
    }

    function deployPool(MCDevKit storage mc) internal returns(MCDevKit storage) {
        mc.init(poolBundleName());
        mc.use("AddLiquidity", AddLiquidity.addLiquidity.selector, address(new AddLiquidity()));
        mc.use("InitializePool", InitializePool.initialize.selector, address(new InitializePool()));
        mc.use("RemoveLiquidity", RemoveLiquidity.removeLiquidity.selector, address(new RemoveLiquidity()));
        mc.use("Swap", Swap.swap.selector, address(new Swap()));
        mc.useFacade(address(new PoolFacade()));
        mc.deploy();
        return mc;
    }

    function deployFactory(MCDevKit storage mc) internal returns(MCDevKit storage) {
        deployGauge(mc);
        address gaugeDictionary = mc.toDictionaryAddress();
        deployPool(mc);
        address poolDictionary = mc.toDictionaryAddress();

        mc.init(factoryBundleName());
        mc.use("CreateGauge",CreateGauge.createGauge.selector, address(new CreateGauge()));
        mc.use("CreatePool",CreatePool.createPool.selector, address(new CreatePool()));
        mc.use("GetPool",GetPool.getPool.selector, address(new GetPool()));
        mc.use("InitializeFactory", InitializeFactory.initialize.selector, address(new InitializeFactory()));
        mc.useFacade(address(new FactoryFacade()));
        mc.deploy(abi.encodeCall(InitializeFactory.initialize, (poolDictionary, gaugeDictionary)));
        return mc;
    }
}
