// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title LPToken
 * @dev ERC20 token that represents liquidity shares in a pool, controlled by the pool contract.
 */
contract LPToken is ERC20, Ownable {
    constructor() ERC20("LPToken", "LPT") Ownable(msg.sender) {}

    /**
     * @dev Allows the pool contract (the owner) to mint liquidity tokens.
     * @param to The address that will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Allows the pool contract (the owner) to burn liquidity tokens.
     * @param from The address from which tokens will be burned.
     * @param amount The amount of tokens to burn.
     */
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}