//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract GNXToken is ERC20, Ownable{

    
    constructor()ERC20("Genix","GNX") Ownable(msg.sender){

    }
    function mint(address account, uint256 amount)external onlyOwner{
        _mint(account,amount);
    }
}