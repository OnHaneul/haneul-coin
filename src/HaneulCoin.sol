// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract HaneulCoin is ERC20, Ownable {
    mapping(address => bool) public isWhitelisted;

    // --- Events ---
    event WhitelistAdded(address indexed account);
    event WhitelistRemoved(address indexed account);

    constructor() ERC20("HaneulCoin", "HNL") Ownable(msg.sender) {
        isWhitelisted[msg.sender] = true;
        emit WhitelistAdded(msg.sender);
        _mint(msg.sender, 100_000 * 10 ** decimals());
    }

    // --- Whitelist Management ---

    function addToWhitelist(address account) external onlyOwner {
        require(!isWhitelisted[account], "Account is already whitelisted");
        isWhitelisted[account] = true;
        emit WhitelistAdded(account);
    }

    function removeFromWhitelist(address account) external onlyOwner {
        require(isWhitelisted[account], "Account is not whitelisted");
        isWhitelisted[account] = false;
        emit WhitelistRemoved(account);
    }

    // --- Checkpoint Logic ---

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        if (from != address(0)) {
            require(isWhitelisted[from], "HaneulCoin: Sender is not whitelisted");
        }
        
        if (to != address(0)) {
            require(isWhitelisted[to], "HaneulCoin: Receiver is not whitelisted");
        }

        super._update(from, to, value);
    }
}