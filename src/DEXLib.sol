// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DEXLib {
    uint public constant MINIMUM_LIQUIDITY = 10**3;
    /**
     * @dev Sorts two token addresses in order to prevent duplicates pools
     * and ensure consistent ordering across the platform.
     */
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }

    function mint(address token, address to, uint amount) internal {
        (bool success, ) = token.call(abi.encodeWithSignature("mint(address,uint256)", to, amount));
        require(success);
    }

    function burn(address token, address from, uint amount) internal {
        (bool success, ) = token.call(abi.encodeWithSignature("burn(address,uint256)", from, amount));
        require(success);
    }

    /**
     * @dev Calculates the optimal amounts of tokens to add as liquidity, based on the desired amounts and pool reserves.
     * This can prevent imbalanced liquidity provision and ensure fair distribution of liquidity tokens.
     */
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        amountB = amountA * reserveB / reserveA;
    }


}