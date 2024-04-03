// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {MCDevKit} from "mc/devkit/MCDevKit.sol";

// Functions
import {CreatePool} from "bundle/factory/functions/CreatePool.sol";
import {GetPool} from "bundle/factory/functions/GetPool.sol";
import {InitializeFactory} from "bundle/factory/functions/InitializeFactory.sol";
import {FactoryFacade} from "bundle/factory/interfaces/FactoryFacade.sol";

import {AddLiquidity} from "bundle/pool/functions/AddLiquidity.sol";
import {InitializePool} from "bundle/pool/functions/InitializePool.sol";
import {RemoveLiquidity} from "bundle/pool/functions/RemoveLiquidity.sol";
import {Swap} from "bundle/pool/functions/Swap.sol";
import {PoolFacade} from "bundle/pool/interfaces/PoolFacade.sol";

library DeployLib {
    function factoryBundleName() internal pure returns(string memory) {
        return "DEX-factory";
    }
    function poolBundleName() internal pure returns(string memory) {
        return "DEX-pool";
    }

    function deployPool(MCDevKit storage mc) internal returns(MCDevKit storage) {
        mc.init(poolBundleName());
        mc.use("AddLiquidity", AddLiquidity.addLiquidity.selector, address(new AddLiquidity()));
        mc.use("InitializePool", InitializePool.initialize.selector, address(new InitializePool()));
        mc.use("RemoveLiquidity", RemoveLiquidity.removeLiquidity.selector, address(new RemoveLiquidity()));
        mc.use("Swap", Swap.swap.selector, address(new Swap()));
        mc.set(address(new PoolFacade()));
        mc.deploy();
        return mc;
    }

    function deployFactory(MCDevKit storage mc) internal returns(MCDevKit storage) {
        deployPool(mc);
        address poolDictionary = mc.getDictionaryAddress();
        
        mc.init(factoryBundleName());
        mc.use("CreatePool",CreatePool.createPool.selector, address(new CreatePool()));
        mc.use("GetPool",GetPool.getPool.selector, address(new GetPool()));
        mc.use("InitializeFactory", InitializeFactory.initialize.selector, address(new InitializeFactory()));
        mc.set(address(new FactoryFacade()));
        mc.deploy(abi.encodeCall(InitializeFactory.initialize, poolDictionary));
        return mc;
    }
}
