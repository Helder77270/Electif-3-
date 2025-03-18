// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Money is ERC20, Ownable {

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) Ownable(_msgSender()){

    }

    function mint(address account_, uint256 value_) external onlyOwner {
        _mint(account_,value_);
    }
}
