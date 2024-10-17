//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {GNXToken} from "../src/GNXToken.sol";
import {Script} from "forge-std/Script.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script{
    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4; 
    uint256 private AMOUNT_TO_TRANSFER=4*25*1e18;
    function deployMerkleAirdrop() public returns(MerkleAirdrop, GNXToken){
        vm.startBroadcast();
        GNXToken gnxToken = new GNXToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(ROOT, IERC20(gnxToken));
        gnxToken.mint(gnxToken.owner(),AMOUNT_TO_TRANSFER);
        IERC20(gnxToken).transfer(address(airdrop),AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, gnxToken);
    }
}